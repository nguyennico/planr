#' Allocates a constrained demand between receiving entities
#'
#' @param dataset a dataframe with the demand and supply features for an item per period
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a period of time monthly or weekly buckets for example
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#' @param Opening the opening inventories of an item in units at the beginning of the horizon
#' @param Supply the quantity of an item planned to be supplied in units for a given period
#'
#' @import dplyr
#' @import lubridate
#'
#' @return a dataframe with the calculated Projected Inventories and Coverages as well as the total Constrained Demand and the allocated demand between receiving entities
#' @export
#'
#' @examples
#' alloc_dmd(dataset = alloc_data, DFU, Period, Demand, Opening, Supply)
#'
alloc_dmd <- function(dataset,
                      DFU,
                      Period,
                      Demand,
                      Opening,
                      Supply) {


  # thank you April for suggesting this function in September 2025
  # you are awesome


  # avoid "no visible binding for global variable"
  Demand <- Opening <- Supply <- NULL
  Calculated.Coverage.in.Periods <- NULL
  Projected.Inventories.Qty <- NULL
  Constrained.Demand <- NULL
  Current.Stock.Available.Tag <- NULL

  perc <- NULL
  allocation_tag <- NULL
  status <- NULL
  allocated_demand <- NULL
  unmet_demand <- NULL
  carried_over <- NULL
  new_demand <- NULL

  receiver <- NULL


  # set a working df
  df1 <- dataset



  #-------------------------------
  # Part 1 : Calculate PI & Const Dmd
  #-------------------------------


  #-------------------------------
  # 1.1) Get input
  #-------------------------------

  # identify the periods when allocation management is needed


  #-------------------------------
  # Create PI template

  # set a working df
  df1 <- dataset

  # keep only needed variables
  df1 <- df1 |> select(DFU, Period, Demand, Opening, Supply)

  # keep results
  pi_template_data <- df1




  #-------------------------------
  # Get Detailed Dmd

  # Calculate % of original Dmd

  # set a working df
  df1 <- dataset

  # keep only needed variables
  df1 <- df1 |> select(-Demand, -Opening, -Supply)

  # pivot
  df1 <- df1 |> gather(key = "receiver",  # Name of the new key column
                       value = "Demand", # Name of the new value column
                       3:length(df1)
  )


  # calculate the % of total Demand that each receiver represents each month
  df1 <- df1 |> group_by(DFU, Period) |> mutate(perc = Demand / sum(Demand))

  # replace NaN by zero
  df1$perc <- if_else(is.nan(df1$perc), 0, df1$perc)

  # keep results
  detailed_demand_data <- df1






  #-------------------------------
  # 1.2) Calculate Const Dmd & identify needed Allocation
  #-------------------------------

  #-------------------------------
  # a) Calculate Const Dmd

  # We use the function const_dmd() from the package planr to calculate :
  # the projected inventories
  # the constrained demand

  # calculate
  df1 <- planr::const_dmd(dataset = pi_template_data,
                          DFU = DFU,
                          Period = Period,
                          Demand =  Demand,
                          Opening = Opening,
                          Supply = Supply)


  # keep results
  calculated_pi_data <- df1


  #-------------------------------
  # b) Identify Allocation

  # We will add a tag to identify which month an allocation is needed

  # set a working df
  df1 <- calculated_pi_data

  # add tag
  df1$allocation_tag <- if_else(df1$Projected.Inventories.Qty < 0, "allocation", "ok")

  # keep results
  calculated_pi_data <- df1





  #-------------------------------
  # Part 2 : Select Allocations for this round
  #-------------------------------

  # keep only the Allocations which are not consecutives

  # arrange
  df1 <- df1 |> arrange(DFU, Period)

  # identify status
  df1 <- df1 |>
    group_by(DFU) |>
    mutate(status = if_else(
      allocation_tag == "allocation" & lag(allocation_tag, n = 1) == "allocation",
      "next",
      allocation_tag)
    )



  # keep results
  calculated_pi_data <- df1



  # In each round, we only focus on the periods where the status is "allocation".

  # If the status is "next", we will work on it the next round.



  #-------------------------------
  # Part 3 : Calculate Allocated Dmd
  #-------------------------------

  # based on the Constrained Demand

  # A fair allocation is simply based on the % of Demand of each receiver (for ex. a Distributor).

  # The idea :
  # we allocate to each receiver a quantity of stocks which is proportional to its replenishment demand.

  # Let's add the % of Demand that each receiver represents each month.

  #------------------
  # Get Constrained Demand to be allocated
  #------------------

  # keep need variables
  df1 <- calculated_pi_data |> select(DFU, Period, Constrained.Demand, status)

  # filter on periods of time when an allocation is need
  df1 <- df1 |> filter(status == "allocation")

  # keep results
  to_be_allocated_demand_data <- df1


  #------------------
  # Original Demand
  #------------------

  # get % of demand
  df1 <- detailed_demand_data |> select(DFU, Period, receiver, perc)





  #------------------
  # Combine
  #------------------

  # merge
  df1 <- left_join(df1, to_be_allocated_demand_data)

  # filter on periods of time when an allocation is need
  df1 <- df1 |> filter(status == "allocation")

  # calculate allocation of the available constrained demand
  df1$allocated_demand <- df1$Constrained.Demand * df1$perc


  # keep only needed variables
  df1 <- df1 |> select(DFU, Period, receiver, allocated_demand, status)


  # keep results
  alloc_original_demand_data <- df1




  # We just got the allocated demand when there are not enough projected inventories.

  # One part still need to be calculated : the unmet demand which has been carried over





  #-------------------------------
  # Part 4 : Calculate the unmet Dmd
  #-------------------------------

  #------------------
  # compare allocated demand vs the original demand
  # to calculate the unmet demand
  #------------------

  # merge
  df1 <- left_join(detailed_demand_data, alloc_original_demand_data)

  # replace missing values by zero
  df1$allocated_demand <- df1$allocated_demand |> replace_na(0)
  df1$status <- df1$status |> replace_na("ok")

  # calculate the unmet demand
  # only when there is an allocation to be worked on
  df1$unmet_demand <- if_else(df1$status == "allocation",
                              df1$Demand - df1$allocated_demand,
                              0
  )

  # replace missing values by zero
  df1$unmet_demand <- df1$unmet_demand |> replace_na(0)




  #-------------------------------
  # Part 5 : Carry on unmet Dmd to next period
  #-------------------------------

  # Now let's translate this unmet demand to the following month.
  # This will become the new demand.
  # If this next period is also under allocation, we then need to check whether this new demand is feasible.

  #------------------
  # Arrange dataset
  #------------------

  # ensure that data are properly ordered
  df1 <- df1 |> arrange(DFU,
                        receiver,
                        Period
  )

  # get demand to be carried over, i.e. previous period [unmet_demand]
  df1$carried_over <- lag(df1$unmet_demand, n = 1)

  # replace missing values by zero
  df1$carried_over <- df1$carried_over |> replace_na(0)

  # calculate new_demand
  df1$new_demand <- df1$Demand + df1$carried_over

  # replace by allocated_demand when it applies
  df1$new_demand <- if_else(df1$status == "allocation",
                            df1$allocated_demand,
                            df1$new_demand)



  # replace missing values by zero
  df1$new_demand <- df1$new_demand |> replace_na(0)

  # keep results
  allocation_data <- df1





  #-------------------------------
  # Part 6 : Calculate New Dmd
  #-------------------------------

  # for current period and next period

  # set a working df
  df1 <- allocation_data

  # keep only needed variables
  df1 <- df1 |> select(DFU, receiver, Period, new_demand)

  # keep results
  new_demand_data <- df1






  #-------------------------------
  # Part 7 : Create New Demand Template
  #-------------------------------


  #-------------------------------
  # 7.1) new detailed Dmd

  # by DFU | receiver | Period

  # set a working df
  df1 <- new_demand_data

  # spread
  df1 <- df1 |> spread(receiver, new_demand)

  # formatting
  df1 <- as.data.frame(df1)

  # keep results
  new_detailed_demand_data <- df1




  #-------------------------------
  # 7.2) new Total Dmd by DFU


  # set a working df
  df1 <- new_demand_data

  # replace missing values by zero
  df1$new_demand <- df1$new_demand |> replace_na(0)

  # aggregate
  df1 <- df1 |> group_by(DFU, Period) |>
    summarise(Demand = sum(new_demand)
    )

  # keep results
  total_new_demand_data <- df1



  #-------------------------------
  # 7.3) Assemble

  # merge
  df1 <- left_join(new_detailed_demand_data, total_new_demand_data)

  # keep results
  interim_data <- df1






  #-------------------------------
  # 7.4) Create new PI template

  #------------------------
  # Get variables from DC
  #------------------------

  # keep only needed variables
  df1 <- dataset |> select(DFU, Period, Opening, Supply)

  # assemble
  df1 <- left_join(interim_data, df1)

  # keep results
  pi_template_data <- df1




  #-------------------------------
  # Part 8 : Calculate New PI & Const Dmd
  #-------------------------------

  # identify the periods when allocation management is needed

  #-------------------------------
  # 8.1) Create PI template

  # set a working df
  df1 <- pi_template_data

  # keep only needed variables
  df1 <- df1 |> select(DFU, Period, Demand, Opening, Supply)

  # keep results
  pi_template_data <- df1


  #-------------------------------
  # 8.2) Calculate Const Dmd & identify needed Allocation


  #-------------------------------
  # a) Calculate Const Dmd

  # We use the function const_dmd() from the package planr to calculate :
  # - the projected inventories
  # - the constrained demand

  # calculate
  df1 <- planr::const_dmd(dataset = pi_template_data,
                          DFU = DFU,
                          Period = Period,
                          Demand =  Demand,
                          Opening = Opening,
                          Supply = Supply)


  # keep results
  calculated_pi_data <- df1



  #-------------------------------
  # b) Identify Allocation

  # We will add a tag to identify which month an allocation is needed

  # set a working df
  df1 <- calculated_pi_data

  # add tag
  df1$allocation_tag <- if_else(df1$Projected.Inventories.Qty < 0, "allocation", "ok")

  # keep results
  calculated_pi_data <- df1





  #-------------------------------
  # Part 9 : Get new template
  #-------------------------------

  # Merge
  df1 <- left_join(new_detailed_demand_data, calculated_pi_data)

  # remove not needed variables
  df1 <- df1 |> select(- Calculated.Coverage.in.Periods,
                       - Projected.Inventories.Qty,
                       - Constrained.Demand,
                       - Current.Stock.Available.Tag,
                       - allocation_tag)



  # formatting
  df1 <- as.data.frame(df1)



  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}















