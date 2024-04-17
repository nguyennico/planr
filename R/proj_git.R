#' Calculates the projected in transit for a defined DFU
#'
#' @param dataset a dataframe which contains the different variable below for each DFU
#' @param DFU name of a node, which is an item x location
#' @param Period a period of time, expressed in weekly bucket
#' @param ETA.Current quantities currently in transit displayed at their ETA date in units
#' @param ETA.Next quantities to be shipped, not yet in transit, displayed at their ETA date in units
#' @param ETD.Next quantities to be shipped, not yet in transit, displayed at their ETD date in units
#' @param TLT Transit Lead Time, expressed in weeks, represents the difference between ETA and ETD dates
#'
#' @importFrom tidyr replace_na
#' @importFrom lubridate floor_date
#' @import dplyr
#'
#' @return a dataframe with the projected in transit quantity calculated for each DFU
#' @export
#'
#' @examples
#' proj_git(dataset = demo_in_transit, DFU, Period, ETA.Current, ETA.Next, ETD.Next, TLT)
#'
proj_git <- function(dataset,
                     DFU,
                     Period,
                     ETA.Current,
                     ETA.Next,
                     ETD.Next,
                     TLT) {




  # avoid "no visible binding for global variable"
  Demand <- NULL
  Period <- NULL
  ETA.Current <- NULL
  ETA.Next <- NULL
  ETD.Next <- NULL
  TLT <- NULL

  Current.GIT <- NULL # will be calculated during the 1st step
  ETD.Current <- NULL # will be calculated during the 2nd step


  ETD.Period <- NULL
  Proj.Current.GIT <- NULL
  Proj.Future.GIT <- NULL






  #-------------------------------
  # 1st step : Calculate sum Current GIT
  #-------------------------------

  # set a working dataset
  df1 <- dataset

  # aggregate
  df1 <- df1 |> group_by(DFU) |> summarise(Current.GIT = sum(ETA.Current))

  #--------------------------

  # Get Start.Date
  Start.Date <- min(dataset$Period)

  #--------------------------

  # add Start Date
  df1$Period <- Start.Date

  # add to the initial dataset
  df1 <- left_join(dataset, df1)

  # replace missing by zero
  df1$Current.GIT <- df1$Current.GIT |> replace_na(0)

  # keep results
  Interim_DB <- df1










  #-------------------------------
  # 2nd step : Get & Add ETD.Current.GIT
  #-------------------------------

  # set a working df
  df1 <- Interim_DB

  # calculate the ETD.Period
  df1$ETD.Period <- df1$Period - (df1$TLT * 7)

  # keep only needed variables
  df1 <- df1 |> select(DFU, ETD.Period, ETA.Current)

  # rename
  df1 <- df1 |> rename(Period = ETD.Period,
                       ETD.Current = ETA.Current)

  # get the beginning of the week for the Period
  # to ensure we are following an english standard
  df1$Period <- floor_date(as.Date(df1$Period, "%Y-%m-%d"), unit = "week")

  # aggregate
  df1 <- df1 |> group_by(DFU, Period) |> summarise(ETD.Current = sum(ETD.Current))

  # add back to initial dataset
  df1 <- merge(Interim_DB, df1, all = TRUE)

  # replace missing values by zero
  df1$ETA.Current <- df1$ETA.Current |> replace_na(0)
  df1$ETD.Current <- df1$ETD.Current |> replace_na(0)

  df1$ETA.Next <- df1$ETA.Next |> replace_na(0)
  df1$ETD.Next <- df1$ETD.Next |> replace_na(0)


  # Reorder columns
  df1 <- df1 |> arrange(DFU, Period)

  # keep results
  Interim_DB <- df1





  #-------------------------------
  # 3rd step : Calculate Projection Current GIT
  #-------------------------------


  # set a working df
  df1 <- Interim_DB


  # accumulate data
  df1 <- df1 |> group_by(DFU, Period) |>
    summarise(
      ETA.Current = sum(ETA.Current),
      ETD.Current = sum(ETD.Current)
    ) |>

    mutate(
      acc_ETA.Current = cumsum(ETA.Current),
      acc_ETD.Current = cumsum(ETD.Current)
    )

  # calculate projected Current In Transit
  df1$Proj.Current.GIT <- df1$acc_ETD.Current - df1$acc_ETA.Current


  # keep only needed columns
  df1 <- df1 |> select(DFU, Period, Proj.Current.GIT)

  # keep Results
  Proj_Current_In_Transit_DB <- df1




  #-------------------------------
  # 4th step : Calculate Projection Future GIT
  #-------------------------------

  # set a working df
  df1 <- Interim_DB


  # accumulate data
  df1 <- df1 |> group_by(DFU, Period) |>
    summarise(
      ETD.Next = sum(ETD.Next),
      ETA.Next = sum(ETA.Next)
    ) |>

    mutate(
      acc_ETD.Next = cumsum(ETD.Next),
      acc_ETA.Next = cumsum(ETA.Next)
    )


  # calculate projected Future In Transit
  df1$Proj.Future.GIT <- if_else(df1$acc_ETD.Next > df1$acc_ETA.Next,
                                 df1$acc_ETD.Next - df1$acc_ETA.Next,
                                 0)


  # keep only needed columns
  df1 <- df1 |> select(DFU, Period, Proj.Future.GIT)


  # keep Results
  Proj_Future_In_Transit_DB <- df1





  #-------------------------------
  # 5th step : Combine different parts
  #-------------------------------

  # merge
  df1 <- left_join(Interim_DB, Proj_Current_In_Transit_DB)
  df1 <- left_join(df1, Proj_Future_In_Transit_DB)

  # replace missing values by zero
  df1$ETA.Current <- df1$ETA.Current |> replace_na(0)
  df1$ETA.Next <- df1$ETA.Next |> replace_na(0)
  df1$ETD.Next <- df1$ETD.Next |> replace_na(0)
  df1$Current.GIT <- df1$Current.GIT |> replace_na(0)

  df1$ETD.Current <- df1$ETD.Current |> replace_na(0)
  df1$Proj.Current.GIT <- df1$Proj.Current.GIT |> replace_na(0)
  df1$Proj.Future.GIT <- df1$Proj.Future.GIT |> replace_na(0)

  # Calculate Total Projected In Transit
  df1$Proj.GIT <- df1$Proj.Current.GIT + df1$Proj.Future.GIT




  # formatting
  df1 <- as.data.frame(df1)


  # keep only relevant Periods, i.e. > Start.Date
  df1 <- filter(df1, df1$Period >= Start.Date)


  # formatting
  df1 <- as.data.frame(df1)



  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}






