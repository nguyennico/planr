#' Calculates the Projected Coverages related to Projected Inventories
#'
#' @param dataset a dataframe with the demand forecasts and projected inventories for an item per period
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a period of time monthly or weekly buckets for example
#' @param Inventories the projected inventories that we aim to convert into their related projected coverages
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#'
#' @import dplyr
#' @import tidyr
#' @import lubridate
#'
#' @return a dataframe with the calculated Projected Coverages
#' @export
#'
#' @examples
#' inv_to_cov(dataset = inventories_data, DFU, Period, Inventories, Demand)
#'



inv_to_cov <- function(dataset,
                       DFU,
                       Period,
                       Inventories,
                       Demand) {


  # avoid "no visible binding for global variable"

  Inventories <- NULL
  Demand <- NULL
  Opening <- NULL
  Period <- NULL
  DFU <- NULL

  acc_Demand <- acc_Opening <- acc_Supply <- NULL
  Supply <- NULL

  Projected.Inventories.Qty <- NULL
  Calculated.Coverage.in.Periods <- NULL

  # 1. Check needed variables
  required_cols <- c("DFU", "Period", "Inventories", "Demand")
  missing_cols <- setdiff(required_cols, colnames(dataset))
  if (length(missing_cols) > 0) {
    stop(paste("Error : missing variables in the dataset :",
               paste(missing_cols, collapse = ", ")))
  }

  # 2. Initialize and create the variable Opening
  df_prepared <- dataset |>
    mutate(
      # Calculate the 1st Opening
      Opening = Inventories - Demand,
      # Keep only the positive values
      Opening = if_else(Opening > 0, Opening, 0)
    ) |>
    # Sort by ascending Period
    arrange(Period) |>
    mutate(
      # Keep the Opening only for the 1st Period
      Opening = if_else(Period == min(Period), Opening, 0)
    )

  # 3. Aggregation and accumulated calculations
  df_accumulated <- df_prepared |>
    group_by(DFU, Period) |>
    summarise(
      Demand      = sum(Demand, na.rm = TRUE),
      Opening     = sum(Opening, na.rm = TRUE),
      Inventories = sum(Inventories, na.rm = TRUE),
      .groups     = "drop"
    ) |>
    arrange(DFU, Period) |>
    group_by(DFU) |>
    mutate(
      acc_Demand  = cumsum(Demand),
      acc_Opening = cumsum(Opening),
      acc_Supply  = Inventories + acc_Demand - acc_Opening,
      Supply      = acc_Supply - lag(acc_Supply, default = 0)
    ) |>
    ungroup() |>
    select(DFU, Period, Demand, Opening, Supply)

  # 4. Call the external function to calculate the projected inventories
  df_projected <- light_proj_inv(
    dataset    = df_accumulated,
    DFU     = DFU,
    Period  = Period,
    Demand  = Demand,
    Opening = Opening,
    Supply  = Supply
  )

  # 5. Final selection for the targeted variables
  result <- df_projected |>
    select(
      DFU,
      Period,
      Demand,
      Opening,
      Projected.Inventories.Qty,
      Calculated.Coverage.in.Periods
    )

  # formatting
  result <- as.data.frame(result)

  return(result)
}
