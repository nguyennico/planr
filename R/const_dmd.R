#' Calculates the Projected Inventories and Coverages as well as the Constrained Demand and informs a Tag about the part of the Demand already covered by the Opening Inventories
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
#' @return a dataframe with the calculated Projected Inventories and Coverages as well as the Constrained Demand and a Tag informing the part of the Demand already covered by the Opening Inventories
#' @export
#'
#' @examples
#' const_dmd(dataset = demo_const_dmd, DFU, Period, Demand, Opening, Supply)
#'
const_dmd <- function(dataset,
                           DFU,
                           Period,
                           Demand,
                           Opening,
                           Supply) {




  # avoid "no visible binding for global variable"
  Demand <- Opening <- Supply <- NULL
  Calculated.Coverage.in.Periods <- NULL
  Projected.Inventories.Qty <- NULL
  Lag1.PI <- NULL
  Constrained.Demand <- NULL
  Current.Stock.Available.Tag <- NULL

  # set a working df
  df1 <- dataset



  #-------------------------------
  # First step : calculate the projected inventories & coverages
  #-------------------------------


  # calculation using the light_proj_inv function from the planr package
  calculated_projection <- planr::light_proj_inv(dataset = df1,
                                          DFU = DFU,
                                          Period = Period,
                                          Demand =  Demand,
                                          Opening = Opening,
                                          Supply = Supply)




  # keep the Initial dataset
  Initial_DB <- calculated_projection


  #-------------------------------
  # Get PI Lag1
  #-------------------------------

  # To generate a reference that we will use later on during our analysis.

  # set a working df
  df1 <- calculated_projection


  # calculate additive columns
  df1 <- df1 |> group_by(DFU) |> mutate(Lag1.PI = lag(Projected.Inventories.Qty, n = 1))

  # replace missing by 0
  df1$Lag1.PI <- if_else(is.na(df1$Lag1.PI), 0, df1$Lag1.PI)




  #-------------------------------
  # Calculate the Constrained (i.e. possible) Demand
  #-------------------------------

  # We are going to calculate different scenarios
  # Based on the availability of the projected inventories, the PI at Lag1 and the Supply Plan.



  #-----------------
  # 1st scenario
  #-----------------

  # We have (projected) stocks, also during the previous period
  # so no problem: we can supply
  df1$Constrained.Demand <- if_else(df1$Projected.Inventories.Qty > 0 & df1$Lag1.PI >= 0, df1$Demand, 0)



  #-----------------
  # 2nd scenario
  #-----------------

  # We don't have enough (projected) stocks, but receive a new supply
  # we also didn't have any stocks during the previous period
  # we will use the full qty of this received supply
  df1$Constrained.Demand <- if_else(df1$Projected.Inventories.Qty < 0 & df1$Lag1.PI < 0 & df1$Supply > 0,
                                    df1$Supply,
                                    df1$Constrained.Demand)





  #-----------------
  # 3rd scenario
  #-----------------

  # We have (projected) stocks, and didn't have enough during the previous period
  # so we can supply the previous B/O as well as the new Demand
  df1$Constrained.Demand <- if_else(df1$Projected.Inventories.Qty > 0 & df1$Lag1.PI < 0,
                                    df1$Demand - df1$Lag1.PI,
                                    df1$Constrained.Demand)




  #-----------------
  # 4th scenario
  #-----------------

  # We don't have (projected) stocks, but had some stocks during the previous period (though not enough to supply the current period)
  df1$Constrained.Demand <- if_else(df1$Projected.Inventories.Qty < 0 & df1$Lag1.PI > 0,
                                    df1$Lag1.PI,
                                    df1$Constrained.Demand)




  #-----------------
  # 5th scenario
  #-----------------

  # We don't have enough projected stocks, but had some stocks during the previous period (though not enough to supply the current period) AND receive a new supply
  df1$Constrained.Demand <- if_else(df1$Projected.Inventories.Qty < 0 & df1$Lag1.PI > 0 & df1$Supply > 0,
                                    df1$Lag1.PI + df1$Supply,
                                    df1$Constrained.Demand)




  #-----------------
  # 6th scenario
  #-----------------

  # we're at the very 1st Period
  # We don't have enough projected stocks and there is no supply
  # but we have some Opening Inventories (though not enough to supply the current period)
  # so we can supply a Qty equals to our Opening Inventories
  df1$Constrained.Demand <- if_else(df1$Projected.Inventories.Qty < 0 & df1$Lag1.PI == 0 & df1$Supply == 0 & df1$Opening > 0,
                                    df1$Opening,
                                    df1$Constrained.Demand)







  #-------------------------------
  # Keep Results
  #-------------------------------

  # The Constrained.Demand = the Demand that we can supply.
  # It will become the Supply Plan for the Entities which have placed their Demand


  # keep only needed columns
  df1 <- df1 |> select(DFU, Period, Constrained.Demand)

  # get results
  Constrained_Demand_DB <- df1









  #-------------------------------
  # Tag confirmed Demand
  #-------------------------------

  # Idea :
  # we identify the Demand which is already covered by the opening inventories
  # For this, we calculate the previous Projected Inventories, but w/o any Supply Plan


  # set a working df
  df1 <- Initial_DB

  # remove (or set to zero) the Supply Plan
  df1$Supply <- 0

  # keep only needed variables
  df1 <- df1 |> select(DFU, Period, Demand, Opening, Supply)



  # calculate the Projected Inventories (w/o any Supply Plan)
  df1 <- planr::light_proj_inv(dataset = df1,
                        DFU = DFU,
                        Period = Period,
                        Demand =  Demand,
                        Opening = Opening,
                        Supply = Supply)



  # And now, let's add a Tag: Stocks available

  # The idea here is to put a tag if the current stock is available
  df1$Current.Stock.Available.Tag <- if_else(df1$Projected.Inventories.Qty > 0, 1, 0)


  # keep only needed columns
  df1 <- df1 |> select(DFU, Period, Current.Stock.Available.Tag)


  # get results
  Demand_Covered_by_Current_Stocks_DB <- df1









  #-------------------------------
  # Get Final Calculated Dataset
  #-------------------------------


  # merge
  df1 <- left_join(Constrained_Demand_DB, Demand_Covered_by_Current_Stocks_DB)

  # adjust tag
  # keeping only if there is a Constrained.Demand in front
  df1$Current.Stock.Available.Tag <- if_else(df1$Constrained.Demand >0, df1$Current.Stock.Available.Tag, 0)




  #-------------------------------
  # Add to Initial dataset (Initial_DB)
  #-------------------------------

  # merge
  df1 <- left_join(Initial_DB, df1)


  # replace missing by 0
  df1$Constrained.Demand <- if_else(is.na(df1$Constrained.Demand), 0, df1$Constrained.Demand)




  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}






