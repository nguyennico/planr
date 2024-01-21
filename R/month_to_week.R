#' Calculates the Projected Inventories and Coverages as well as the Constrained Demand and informs a Tag about the part of the Demand already covered by the Opening Inventories
#'
#' @param dataset a dataframe with the demand in monthly bucket for each item
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a monthly period of time that we want to convert into weekly buckets
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#'
#' @importFrom stats complete.cases
#' @import dplyr
#' @import lubridate
#'
#' @return a dataframe with the Demand expressed in weekly buckets for each item
#' @export
#'
#' @examples
#' month_to_week(dataset = demo_monthly_dmd, DFU, Period, Demand)
#'
month_to_week <- function(dataset,
                      DFU,
                      Period,
                      Demand) {




  # avoid "no visible binding for global variable"
  Demand <- NULL
  Monthly.Period <- NULL
  Weekly.Period <- NULL
  Daily.Distribution.Default <- NULL
  Daily.Demand <- NULL


  # rename
  dataset <- dataset |> rename(Monthly.Period = Period)


  # set a working dataset
  df1 <- dataset




  #-----------------------------
  # Create a Weekly Distribution Index
  #-----------------------------

  # Get a vector with the number and labels of products
  DFU <- unique(df1$DFU)

  # create a vector with 4 times 0.25, per the number of products
  # the idea is to use it to affect, by default, 25% of the Monthly Demand to each Weekly Period
  Weekly.Distribution.Index <- c(rep(0.25, 4 * length(DFU)))

  # Create a vector with the Weekly Periods
  Monthly.Week.no <- c("W1", "W2", "W3", "W4")

  # combine
  df1 <- cbind(DFU, Weekly.Distribution.Index)
  df1 <- as.data.frame(df1)

  # arrange
  df1 <- df1 |> arrange(DFU)

  # add the Monthly.Week.no
  df1 <- cbind(df1, Monthly.Week.no)

  # keep results
  Weekly_Distribution_DB <- df1
  Weekly_Distribution_DB <- as.data.frame(Weekly_Distribution_DB)









  #------------------------------------------
  # Generate a Master Calendar
  #------------------------------------------

  # set a working dataset
  df1 <- dataset

  # generate a sequence of dates
  Daily.Period <- seq(lubridate::ymd(min(df1$Monthly.Period)), lubridate::ymd(max(df1$Monthly.Period + 28)), by = "1 day")

  # format as dataframe
  df1 <- as.data.frame(Daily.Period)

  # get Day no
  df1$Day.no <- lubridate::day(df1$Daily.Period)

  # get start of the week day using lubridate
  df1$Weekly.Period <- floor_date(df1$Daily.Period, unit="week")

  # create a (Monthly) Period
  df1$Monthly.Period <- floor_date(df1$Daily.Period, unit = "month")

  # get results
  Master_Calendar_Distribution_DB <- df1







  #------------------------------------------
  # Create Daily Distribution Pattern
  #------------------------------------------

  # Create Daily Distribution template
  # which is just about affecting some Weeks to some days
  Day.no <- c(seq(1:31))
  Monthly.Week.no <- c(rep("W1",7), rep("W2",7), rep("W3",7), rep("W4",10))


  # create dataframe
  df1 <- data.frame(Day.no,
                    Monthly.Week.no)

  # create a by default, evenly distributed, Daily.Distribution
  df1$Daily.Distribution.Default <- (1 / 28)

  # adjust the last 3 days to 0
  df1$Daily.Distribution.Default <- if_else(df1$Day.no %in% c(29,30,31), 0, df1$Daily.Distribution.Default)

  # keep results
  Daily_Distribution_DB <- df1





  #------------------------------------------
  # Calculate Daily Distribution
  #------------------------------------------

  # merge
  df1 <- left_join(Weekly_Distribution_DB, Daily_Distribution_DB)

  # keep results
  Calculated_Daily_Distribution_DB <- df1





  #------------------------------------------
  # Merge with Master Calendar
  #------------------------------------------

  # first: make sure the Day.no in both databases are both integer
  Master_Calendar_Distribution_DB$Day.no <- as.integer(Master_Calendar_Distribution_DB$Day.no)
  Calculated_Daily_Distribution_DB$Day.no <- as.integer(Calculated_Daily_Distribution_DB$Day.no)

  # merge
  df1 <- left_join(Master_Calendar_Distribution_DB, Calculated_Daily_Distribution_DB)

  # Keep only the needed columns
  df1 <- df1 |> select(DFU, Monthly.Period, Weekly.Period, Daily.Distribution.Default)

  # Get Results
  Master_Calendar_Daily_Distribution_DB <- df1


  #------------------------------------------
  # Calculate Daily Demand
  #------------------------------------------

  # merge
  df1 <- left_join(dataset, Master_Calendar_Daily_Distribution_DB)

  # remove rows with NA, if any
  df1 <- df1[complete.cases(df1), ]

  # Calculation of Daily Sales Forecasts
  df1$Daily.Demand <- df1$Demand * df1$Daily.Distribution.Default



  #------------------------------------------
  # Aggregate into Weekly buckets
  #------------------------------------------

  # replace missing values (if any) by zero
  df1$Daily.Demand[is.na(df1$Daily.Demand)] <- 0

  # aggregate
  df1 <- df1 |> 	group_by(DFU, Weekly.Period) |>
    summarise(Demand = sum(Daily.Demand)
    )

  # rename
  df1 <- df1 |> rename(Period = Weekly.Period)

  # formatting
  df1 <- as.data.frame(df1)

  # get results
  Weekly_Demand_DB <- df1





  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}






