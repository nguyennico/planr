#' Calculates the short shelf life of an opening inventories, also called obsolescence risks
#'
#' @param dataset a dataframe with the demand in weekly or monthly bucket for each item
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a period of time, expressed in monthly or weekly bucket
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#' @param Opening the breakdown of the opening inventories by expiry date, or percentage of minimum remaining shelflife for use
#'
#' @importFrom tidyr replace_na
#' @import dplyr
#'
#' @return a dataframe with the SSL.Qty related to the Opening Inventories of each item
#' @export
#'
#' @examples
#' ssl(dataset = slob, DFU, Period, Demand, Opening)
#'
ssl <- function(dataset,
                      DFU,
                      Period,
                      Demand,
                      Opening) {




  # avoid "no visible binding for global variable"
  Demand <- NULL
  Period <- NULL
  Opening <- NULL

  segment <- NULL
  SSL.Qty <- NULL

  # set a working dataset
  df1 <- dataset


  # replace missing values by zero
  df1$Opening <- df1$Opening |> replace_na(0)

  # add index
  df1$index <- if_else(df1$Opening > 0, "stop", "")




  #-------------------------------
  # Get Start Date
  #-------------------------------

  Start.Date <- min(df1$Period)


  # keep results
  Interim_DB <- df1



  #-------------------------------
  # Identify Qty Consumed
  #-------------------------------

  # Qty consumed between 2 expiry dates

  # set a working df
  df1 <- Interim_DB

  # Add row numbers for easier identification of segments
  df1$row_number <- seq_len(nrow(df1))

  # Identify the indices of "stop"
  stop_indices <- which(df1$index == "stop")

  stop_indices <- stop_indices + 1

  # Create a grouping variable based on the segments between "stop" indices and DFU
  df1 <- df1 |>
    mutate(segment = cumsum(row_number %in% stop_indices) )

  # Calculate cumulative sum of Demand within each segment and DFU
  cumulative_demand <- df1 |>
    group_by(DFU, segment) |>
    summarise(cumulative_demand = sum(Demand))




  #-------------------------------
  # Now let's add the results to the initial dataset
  #-------------------------------

  # merge
  df1 <- left_join(df1, cumulative_demand)

  # identify the Consumed.Qty
  df1$Consumed.Qty <- if_else(df1$index == "stop", df1$cumulative_demand, 0)

  # identify the SSL.Qty
  # this is the Qty which cannot be consumed and is at risk
  df1$SSL.Qty <- if_else(df1$Opening > df1$Consumed.Qty, df1$Opening - df1$Consumed.Qty, 0)



  #-------------------------------
  # Keep only relevant variables
  #-------------------------------

  # select variables
  df1 <- df1 |> select(DFU, Period, Demand, Opening,
                       SSL.Qty)





  # formatting
  df1 <- as.data.frame(df1)


  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}






