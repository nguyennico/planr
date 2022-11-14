#' Calculates a Replenishment Plan (also called DRP : Distribution Requirement Planning) and the related Projected Inventories and Coverages
#'
#' @param dataset a dataframe with the demand and supply features for an item per period
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a period of time monthly or weekly buckets for example
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#' @param Opening.Inventories the opening inventories of an item in units at the beginning of the horizon
#' @param Supply.Plan the quantity of an item planned to be supplied in units for a given period
#' @param SSCov the Safety Stock Coverage, expressed in number of periods
#' @param DRPCovDur the Frequency of Supply, expressed in number of periods
#' @param Reorder.Qty the Reorder Quantity, expressed in units, 1 by default or a multiple of a MOQ (Minimum Order Quantity)
#' @param DRP.Grid defines the Frozen and Free Horizon. It hase 2 values: Frozen or Free. If Frozen : no calculation of Replenishment Plan yet, the calculation starts when the period is defined as Free. We can use this parameter to consider some defined productions plans or supplies (allocations, workorders,...) in the short-term for example.
#'
#' @importFrom RcppRoll roll_sum
#' @importFrom magrittr %>%
#' @importFrom stats runif
#' @import dplyr
#'
#' @return a dataframe with the calculated Replenishment Plan and realted Projected inventories and Coverages
#' @export
#'
#' @examples
#' drp(dataset = blueprint_drp, DFU = DFU, Period = Period, Demand = Demand, Opening.Inventories = Opening.Inventories, Supply.Plan = Supply.Plan, SSCov = SSCov, DRPCovDur = DRPCovDur, Reorder.Qty = Reorder.Qty, DRP.Grid = DRP.Grid)
#'
drp <- function(dataset, DFU, Period,
                Demand, Opening.Inventories, Supply.Plan,
                SSCov, DRPCovDur, Reorder.Qty, DRP.Grid) {


  # set a working df
  df1 <- dataset





  # calculate the Stocks Max
  df1$Stock.Max <- df1$SSCov + df1$DRPCovDur



  #---------------------------------------------------------------
  #---------------------------------------------------------------

  # Keep a Database w/ the DRP Parameters

  #---------------------------------------------------------------
  #---------------------------------------------------------------

  DRP_Parameters_DB <- df1 %>% select(
    DFU,
    Period,
    SSCov, DRPCovDur, Stock.Max, Reorder.Qty, DRP.Grid
  )







  #-------------------------------
  # Reorder columns

  # sorting based on ascending period and after based on DFU (just to make sure all is in place)
  df1 <- df1[order(df1$Period), ]
  df1 <- df1[order(df1$DFU), ]



  #-------------------------------
  # Create a random noise component for the Demand.
  # Purpose: to make the serie w/ unique elements, and get a proper calculation of the projected coverages.
  # We will then remove this component.
  #-------------------------------

  df1$random.demand <- runif(length(df1$DFU), min = 1, max = 2)

  # make sure it's very small, by dividing by 1.000.000
  df1$random.demand <- df1$random.demand / 1000000

  # add it to the original Demand
  df1$Demand <- df1$Demand + df1$random.demand



  # Get Results
  Initial_DB <- df1




  #---------------------------------------------------------------
  #---------------------------------------------------------------


  # Calculate Projected Inventories


  #---------------------------------------------------------------
  #---------------------------------------------------------------


  # Set a working df:
  df1 <- Initial_DB






  # We consider here that Expected Supply Plan = Ordered Supply.

  # We could have 2 types of Supply Inputs:
  # - ordered
  # - and expected to be (really) delivered

  # The idea here is to understand when we need to calculate a Replenishment Plan considering the existing portfolio of POs within the Frozen Horizon .


  # Prerequisite Setup

  # to identify the Purchase Orders within the Frozen Horizon, and to keep them
  # selection of only the Expected Supply Plan within the Frozen Horizon
  df1$adjusted.Supply.Plan.Qty <- if_else(df1$DRP.Grid == "Frozen", df1$Supply.Plan, 0)





  #-------------------------------
  # Accumulate Values


  # calculate the Projected Inventories keeping only the adjusted.Supply.Plan.Qty as Supply Plan
  df1 <- df1 %>%
    group_by(DFU, Period) %>%
    summarise(
      Demand = sum(Demand),
      Opening.Inventories = sum(Opening.Inventories),
      Supply.Plan = sum(adjusted.Supply.Plan.Qty)
    ) %>%
    mutate(
      acc_Demand = cumsum(Demand),
      acc_Opening.Inventories = cumsum(Opening.Inventories),
      acc_Supply.Plan = cumsum(Supply.Plan)
    )



  #-------------------------------
  # Calculate the Projected Inventories

  # calculation projected inventories Qty

  df1 <- df1 %>%
    group_by(
      DFU, Period,
      Demand, Opening.Inventories, Supply.Plan
    ) %>%
    summarise(
      Projected.Inventories.Qty = sum(acc_Opening.Inventories) + sum(acc_Supply.Plan) - sum(acc_Demand)
    )

  # Transform as dataframe
  df1 <- as.data.frame(df1)


  #-------------------------------
  # Get Results
  Interim_DB <- df1






  #-------------------------------

  # add the DRP Parameters
  df1 <- left_join(Interim_DB, DRP_Parameters_DB)


  #-------------------------------
  # Get Results
  Interim_DB <- df1






  #---------------------------------------------------------------
  #---------------------------------------------------------------


  # Calculate Projected Coverages


  #---------------------------------------------------------------
  #---------------------------------------------------------------


  # This is needed to calculate later on the projected Stock min & Max, in units.


  #-------------------------------
  # Shift Demand

  # Make a lead shift of the Demand:
  #* the 1st shift: "Shifted.Demand" is necessary for the generation of additive columns
  #* the following shifts: will ne used to calculate the projected coverages



  # set a working df
  df1 <- Interim_DB

  # calculate additive columns
  df1 <- df1 %>%
    group_by(DFU) %>%
    mutate(
      Shifted.Demand = lead(Demand, n = 1),
      Shift2 = lead(Demand, n = 2),
      Shift3 = lead(Demand, n = 3),
      Shift4 = lead(Demand, n = 4),
      Shift5 = lead(Demand, n = 5),
      Shift6 = lead(Demand, n = 6),
      Shift7 = lead(Demand, n = 7),
      Shift8 = lead(Demand, n = 8),
      Shift9 = lead(Demand, n = 9),
      Shift10 = lead(Demand, n = 10),
      Shift11 = lead(Demand, n = 11),
      Shift12 = lead(Demand, n = 12),
      Shift13 = lead(Demand, n = 13),
      Shift14 = lead(Demand, n = 14),
      Shift15 = lead(Demand, n = 15),
      Shift16 = lead(Demand, n = 16),
      Shift17 = lead(Demand, n = 17),
      Shift18 = lead(Demand, n = 18),
      Shift19 = lead(Demand, n = 19),
      Shift20 = lead(Demand, n = 20),
      Shift21 = lead(Demand, n = 21),
      Shift22 = lead(Demand, n = 22),
      Shift23 = lead(Demand, n = 23),
      Shift24 = lead(Demand, n = 24),
      Shift25 = lead(Demand, n = 25),
      Shift26 = lead(Demand, n = 26),
      Shift27 = lead(Demand, n = 27),
      Shift28 = lead(Demand, n = 28),
      Shift29 = lead(Demand, n = 29),
      Shift30 = lead(Demand, n = 30),
      Shift31 = lead(Demand, n = 31),
      Shift32 = lead(Demand, n = 32),
      Shift33 = lead(Demand, n = 33),
      Shift34 = lead(Demand, n = 34),
      Shift35 = lead(Demand, n = 35),
      Shift36 = lead(Demand, n = 36),
      Shift37 = lead(Demand, n = 37),
      Shift38 = lead(Demand, n = 38),
      Shift39 = lead(Demand, n = 39),
      Shift40 = lead(Demand, n = 40),
      Shift41 = lead(Demand, n = 41),
      Shift42 = lead(Demand, n = 42),
      Shift43 = lead(Demand, n = 43),
      Shift44 = lead(Demand, n = 44),
      Shift45 = lead(Demand, n = 45),
      Shift46 = lead(Demand, n = 46),
      Shift47 = lead(Demand, n = 47),
      Shift48 = lead(Demand, n = 48),
      Shift49 = lead(Demand, n = 49),
      Shift50 = lead(Demand, n = 50),
      Shift51 = lead(Demand, n = 51),
      Shift52 = lead(Demand, n = 52),
      Shift53 = lead(Demand, n = 53),
      Shift54 = lead(Demand, n = 54),
      Shift55 = lead(Demand, n = 55),
      Shift56 = lead(Demand, n = 56),
      Shift57 = lead(Demand, n = 57),
      Shift58 = lead(Demand, n = 58),
      Shift59 = lead(Demand, n = 59),
      Shift60 = lead(Demand, n = 60)
    )





  #-------------------------------
  # Generate additive columns

  # Calculate a rolling sum.


  # calculate additive columns
  df1 <- df1 %>%
    group_by(DFU) %>%
    mutate(
      roll_sum1 = roll_sum(Shifted.Demand, 1, fill = NA, align = "left"),
      roll_sum2 = roll_sum(Shifted.Demand, 2, fill = NA, align = "left"),
      roll_sum3 = roll_sum(Shifted.Demand, 3, fill = NA, align = "left"),
      roll_sum4 = roll_sum(Shifted.Demand, 4, fill = NA, align = "left"),
      roll_sum5 = roll_sum(Shifted.Demand, 5, fill = NA, align = "left"),
      roll_sum6 = roll_sum(Shifted.Demand, 6, fill = NA, align = "left"),
      roll_sum7 = roll_sum(Shifted.Demand, 7, fill = NA, align = "left"),
      roll_sum8 = roll_sum(Shifted.Demand, 8, fill = NA, align = "left"),
      roll_sum9 = roll_sum(Shifted.Demand, 9, fill = NA, align = "left"),
      roll_sum10 = roll_sum(Shifted.Demand, 10, fill = NA, align = "left"),
      roll_sum11 = roll_sum(Shifted.Demand, 11, fill = NA, align = "left"),
      roll_sum12 = roll_sum(Shifted.Demand, 12, fill = NA, align = "left"),
      roll_sum13 = roll_sum(Shifted.Demand, 13, fill = NA, align = "left"),
      roll_sum14 = roll_sum(Shifted.Demand, 14, fill = NA, align = "left"),
      roll_sum15 = roll_sum(Shifted.Demand, 15, fill = NA, align = "left"),
      roll_sum16 = roll_sum(Shifted.Demand, 16, fill = NA, align = "left"),
      roll_sum17 = roll_sum(Shifted.Demand, 17, fill = NA, align = "left"),
      roll_sum18 = roll_sum(Shifted.Demand, 18, fill = NA, align = "left"),
      roll_sum19 = roll_sum(Shifted.Demand, 19, fill = NA, align = "left"),
      roll_sum20 = roll_sum(Shifted.Demand, 20, fill = NA, align = "left"),
      roll_sum21 = roll_sum(Shifted.Demand, 21, fill = NA, align = "left"),
      roll_sum22 = roll_sum(Shifted.Demand, 22, fill = NA, align = "left"),
      roll_sum23 = roll_sum(Shifted.Demand, 23, fill = NA, align = "left"),
      roll_sum24 = roll_sum(Shifted.Demand, 24, fill = NA, align = "left"),
      roll_sum25 = roll_sum(Shifted.Demand, 25, fill = NA, align = "left"),
      roll_sum26 = roll_sum(Shifted.Demand, 26, fill = NA, align = "left"),
      roll_sum27 = roll_sum(Shifted.Demand, 27, fill = NA, align = "left"),
      roll_sum28 = roll_sum(Shifted.Demand, 28, fill = NA, align = "left"),
      roll_sum29 = roll_sum(Shifted.Demand, 29, fill = NA, align = "left"),
      roll_sum30 = roll_sum(Shifted.Demand, 30, fill = NA, align = "left"),
      roll_sum31 = roll_sum(Shifted.Demand, 31, fill = NA, align = "left"),
      roll_sum32 = roll_sum(Shifted.Demand, 32, fill = NA, align = "left"),
      roll_sum33 = roll_sum(Shifted.Demand, 33, fill = NA, align = "left"),
      roll_sum34 = roll_sum(Shifted.Demand, 34, fill = NA, align = "left"),
      roll_sum35 = roll_sum(Shifted.Demand, 35, fill = NA, align = "left"),
      roll_sum36 = roll_sum(Shifted.Demand, 36, fill = NA, align = "left"),
      roll_sum37 = roll_sum(Shifted.Demand, 37, fill = NA, align = "left"),
      roll_sum38 = roll_sum(Shifted.Demand, 38, fill = NA, align = "left"),
      roll_sum39 = roll_sum(Shifted.Demand, 39, fill = NA, align = "left"),
      roll_sum40 = roll_sum(Shifted.Demand, 40, fill = NA, align = "left"),
      roll_sum41 = roll_sum(Shifted.Demand, 41, fill = NA, align = "left"),
      roll_sum42 = roll_sum(Shifted.Demand, 42, fill = NA, align = "left"),
      roll_sum43 = roll_sum(Shifted.Demand, 43, fill = NA, align = "left"),
      roll_sum44 = roll_sum(Shifted.Demand, 44, fill = NA, align = "left"),
      roll_sum45 = roll_sum(Shifted.Demand, 45, fill = NA, align = "left"),
      roll_sum46 = roll_sum(Shifted.Demand, 46, fill = NA, align = "left"),
      roll_sum47 = roll_sum(Shifted.Demand, 47, fill = NA, align = "left"),
      roll_sum48 = roll_sum(Shifted.Demand, 48, fill = NA, align = "left"),
      roll_sum49 = roll_sum(Shifted.Demand, 49, fill = NA, align = "left"),
      roll_sum50 = roll_sum(Shifted.Demand, 50, fill = NA, align = "left"),
      roll_sum51 = roll_sum(Shifted.Demand, 51, fill = NA, align = "left"),
      roll_sum52 = roll_sum(Shifted.Demand, 52, fill = NA, align = "left"),
      roll_sum53 = roll_sum(Shifted.Demand, 53, fill = NA, align = "left"),
      roll_sum54 = roll_sum(Shifted.Demand, 54, fill = NA, align = "left"),
      roll_sum55 = roll_sum(Shifted.Demand, 55, fill = NA, align = "left"),
      roll_sum56 = roll_sum(Shifted.Demand, 56, fill = NA, align = "left"),
      roll_sum57 = roll_sum(Shifted.Demand, 57, fill = NA, align = "left"),
      roll_sum58 = roll_sum(Shifted.Demand, 58, fill = NA, align = "left"),
      roll_sum59 = roll_sum(Shifted.Demand, 59, fill = NA, align = "left"),
      roll_sum60 = roll_sum(Shifted.Demand, 60, fill = NA, align = "left")
    )





  #-------------------------------
  # Calculate Coverages

  # Coverage Calculation
  # calculation of projected coverages


  df1 <- df1 %>% mutate(
    Calculated.Coverage.in.Periods =
      case_when(
        (Projected.Inventories.Qty / roll_sum1) < 1 ~ (Projected.Inventories.Qty / roll_sum1),
        (Projected.Inventories.Qty / roll_sum2) < 1 ~ 1 + (Projected.Inventories.Qty - roll_sum1) / Shift2,
        (Projected.Inventories.Qty / roll_sum3) < 1 ~ 2 + (Projected.Inventories.Qty - roll_sum2) / Shift3,
        (Projected.Inventories.Qty / roll_sum4) < 1 ~ 3 + (Projected.Inventories.Qty - roll_sum3) / Shift4,
        (Projected.Inventories.Qty / roll_sum5) < 1 ~ 4 + (Projected.Inventories.Qty - roll_sum4) / Shift5,
        (Projected.Inventories.Qty / roll_sum6) < 1 ~ 5 + (Projected.Inventories.Qty - roll_sum5) / Shift6,
        (Projected.Inventories.Qty / roll_sum7) < 1 ~ 6 + (Projected.Inventories.Qty - roll_sum6) / Shift7,
        (Projected.Inventories.Qty / roll_sum8) < 1 ~ 7 + (Projected.Inventories.Qty - roll_sum7) / Shift8,
        (Projected.Inventories.Qty / roll_sum9) < 1 ~ 8 + (Projected.Inventories.Qty - roll_sum8) / Shift9,
        (Projected.Inventories.Qty / roll_sum10) < 1 ~ 9 + (Projected.Inventories.Qty - roll_sum9) / Shift10,
        (Projected.Inventories.Qty / roll_sum11) < 1 ~ 10 + (Projected.Inventories.Qty - roll_sum10) / Shift11,
        (Projected.Inventories.Qty / roll_sum12) < 1 ~ 11 + (Projected.Inventories.Qty - roll_sum11) / Shift12,
        (Projected.Inventories.Qty / roll_sum13) < 1 ~ 12 + (Projected.Inventories.Qty - roll_sum12) / Shift13,
        (Projected.Inventories.Qty / roll_sum14) < 1 ~ 13 + (Projected.Inventories.Qty - roll_sum13) / Shift14,
        (Projected.Inventories.Qty / roll_sum15) < 1 ~ 14 + (Projected.Inventories.Qty - roll_sum14) / Shift15,
        (Projected.Inventories.Qty / roll_sum16) < 1 ~ 15 + (Projected.Inventories.Qty - roll_sum15) / Shift16,
        (Projected.Inventories.Qty / roll_sum17) < 1 ~ 16 + (Projected.Inventories.Qty - roll_sum16) / Shift17,
        (Projected.Inventories.Qty / roll_sum18) < 1 ~ 17 + (Projected.Inventories.Qty - roll_sum17) / Shift18,
        (Projected.Inventories.Qty / roll_sum19) < 1 ~ 18 + (Projected.Inventories.Qty - roll_sum18) / Shift19,
        (Projected.Inventories.Qty / roll_sum20) < 1 ~ 19 + (Projected.Inventories.Qty - roll_sum19) / Shift20,
        (Projected.Inventories.Qty / roll_sum21) < 1 ~ 20 + (Projected.Inventories.Qty - roll_sum20) / Shift21,
        (Projected.Inventories.Qty / roll_sum22) < 1 ~ 21 + (Projected.Inventories.Qty - roll_sum21) / Shift22,
        (Projected.Inventories.Qty / roll_sum23) < 1 ~ 22 + (Projected.Inventories.Qty - roll_sum22) / Shift23,
        (Projected.Inventories.Qty / roll_sum24) < 1 ~ 23 + (Projected.Inventories.Qty - roll_sum23) / Shift24,
        (Projected.Inventories.Qty / roll_sum25) < 1 ~ 24 + (Projected.Inventories.Qty - roll_sum24) / Shift25,
        (Projected.Inventories.Qty / roll_sum26) < 1 ~ 25 + (Projected.Inventories.Qty - roll_sum25) / Shift26,
        (Projected.Inventories.Qty / roll_sum27) < 1 ~ 26 + (Projected.Inventories.Qty - roll_sum26) / Shift27,
        (Projected.Inventories.Qty / roll_sum28) < 1 ~ 27 + (Projected.Inventories.Qty - roll_sum27) / Shift28,
        (Projected.Inventories.Qty / roll_sum29) < 1 ~ 28 + (Projected.Inventories.Qty - roll_sum28) / Shift29,
        (Projected.Inventories.Qty / roll_sum30) < 1 ~ 29 + (Projected.Inventories.Qty - roll_sum29) / Shift30,
        (Projected.Inventories.Qty / roll_sum31) < 1 ~ 30 + (Projected.Inventories.Qty - roll_sum30) / Shift31,
        (Projected.Inventories.Qty / roll_sum32) < 1 ~ 31 + (Projected.Inventories.Qty - roll_sum31) / Shift32,
        (Projected.Inventories.Qty / roll_sum33) < 1 ~ 32 + (Projected.Inventories.Qty - roll_sum32) / Shift33,
        (Projected.Inventories.Qty / roll_sum34) < 1 ~ 33 + (Projected.Inventories.Qty - roll_sum33) / Shift34,
        (Projected.Inventories.Qty / roll_sum35) < 1 ~ 34 + (Projected.Inventories.Qty - roll_sum34) / Shift35,
        (Projected.Inventories.Qty / roll_sum36) < 1 ~ 35 + (Projected.Inventories.Qty - roll_sum35) / Shift36,
        (Projected.Inventories.Qty / roll_sum37) < 1 ~ 36 + (Projected.Inventories.Qty - roll_sum36) / Shift37,
        (Projected.Inventories.Qty / roll_sum38) < 1 ~ 37 + (Projected.Inventories.Qty - roll_sum37) / Shift38,
        (Projected.Inventories.Qty / roll_sum39) < 1 ~ 38 + (Projected.Inventories.Qty - roll_sum38) / Shift39,
        (Projected.Inventories.Qty / roll_sum40) < 1 ~ 39 + (Projected.Inventories.Qty - roll_sum39) / Shift40,
        (Projected.Inventories.Qty / roll_sum41) < 1 ~ 40 + (Projected.Inventories.Qty - roll_sum40) / Shift41,
        (Projected.Inventories.Qty / roll_sum42) < 1 ~ 41 + (Projected.Inventories.Qty - roll_sum41) / Shift42,
        (Projected.Inventories.Qty / roll_sum43) < 1 ~ 42 + (Projected.Inventories.Qty - roll_sum42) / Shift43,
        (Projected.Inventories.Qty / roll_sum44) < 1 ~ 43 + (Projected.Inventories.Qty - roll_sum43) / Shift44,
        (Projected.Inventories.Qty / roll_sum45) < 1 ~ 44 + (Projected.Inventories.Qty - roll_sum44) / Shift45,
        (Projected.Inventories.Qty / roll_sum46) < 1 ~ 45 + (Projected.Inventories.Qty - roll_sum45) / Shift46,
        (Projected.Inventories.Qty / roll_sum47) < 1 ~ 46 + (Projected.Inventories.Qty - roll_sum46) / Shift47,
        (Projected.Inventories.Qty / roll_sum48) < 1 ~ 47 + (Projected.Inventories.Qty - roll_sum47) / Shift48,
        (Projected.Inventories.Qty / roll_sum49) < 1 ~ 48 + (Projected.Inventories.Qty - roll_sum48) / Shift49,
        (Projected.Inventories.Qty / roll_sum50) < 1 ~ 49 + (Projected.Inventories.Qty - roll_sum49) / Shift50,
        (Projected.Inventories.Qty / roll_sum51) < 1 ~ 50 + (Projected.Inventories.Qty - roll_sum50) / Shift51,
        (Projected.Inventories.Qty / roll_sum52) < 1 ~ 51 + (Projected.Inventories.Qty - roll_sum51) / Shift52,
        (Projected.Inventories.Qty / roll_sum53) < 1 ~ 52 + (Projected.Inventories.Qty - roll_sum52) / Shift53,
        (Projected.Inventories.Qty / roll_sum54) < 1 ~ 53 + (Projected.Inventories.Qty - roll_sum53) / Shift54,
        (Projected.Inventories.Qty / roll_sum55) < 1 ~ 54 + (Projected.Inventories.Qty - roll_sum54) / Shift55,
        (Projected.Inventories.Qty / roll_sum56) < 1 ~ 55 + (Projected.Inventories.Qty - roll_sum55) / Shift56,
        (Projected.Inventories.Qty / roll_sum57) < 1 ~ 56 + (Projected.Inventories.Qty - roll_sum56) / Shift57,
        (Projected.Inventories.Qty / roll_sum58) < 1 ~ 57 + (Projected.Inventories.Qty - roll_sum57) / Shift58,
        (Projected.Inventories.Qty / roll_sum59) < 1 ~ 58 + (Projected.Inventories.Qty - roll_sum58) / Shift59,
        (Projected.Inventories.Qty / roll_sum60) < 1 ~ 59 + (Projected.Inventories.Qty - roll_sum59) / Shift60,
        TRUE ~ 0
      ) # close case_when
  ) # close mutate










  #-------------------------------
  # Adjustment
  #-------------------------------

  # Now we do a little adjustment, as displaying negative coverages is not really meaningful.

  # replace negative Coverages by zero
  # as a negative coverage doesn't make sense

  df1$Calculated.Coverage.in.Periods <- if_else(df1$Calculated.Coverage.in.Periods > 0, df1$Calculated.Coverage.in.Periods, 0)



  # Another adjustment:
  # For the overstocks, we put 99 by default
  df1$Calculated.Coverage.in.Periods <- if_else(df1$Calculated.Coverage.in.Periods == 0 & df1$Projected.Inventories.Qty > 0, 99, df1$Calculated.Coverage.in.Periods)


  # round the Calculated.Coverage.in.Periods
  df1$Calculated.Coverage.in.Periods <- round(df1$Calculated.Coverage.in.Periods, 1)













  #-------------------------------
  #-------------------------------

  #         Calculation of Projected Stocks min (Safety Stocks) and Max

  #-------------------------------
  #-------------------------------


  # Calculation at Monthly Buckets

  # Methodology:
  # - we consider 2 boundaries: projected stocks min & Max
  # - the DRP calculation must ensure we are always between both


  # Calculation of Projected Stocks min & Max

  # Based on 2 (dynamic) parameters:
  # - Safety Stocks
  # - Maximum Stocks


  #-------------------------------
  # First: calculation of Safety Stocks
  #-------------------------------

  # calculation of Safety Stocks

  df1 <- df1 %>% mutate(
    Safety.Stocks =
      case_when(
        SSCov < 1 ~ SSCov * roll_sum1,
        SSCov < 2 ~ roll_sum1 + (SSCov - 1) * (roll_sum2 - roll_sum1),
        SSCov < 3 ~ roll_sum2 + (SSCov - 2) * (roll_sum3 - roll_sum2),
        SSCov < 4 ~ roll_sum3 + (SSCov - 3) * (roll_sum4 - roll_sum3),
        SSCov < 5 ~ roll_sum4 + (SSCov - 4) * (roll_sum5 - roll_sum4),
        SSCov < 6 ~ roll_sum5 + (SSCov - 5) * (roll_sum6 - roll_sum5),
        SSCov < 7 ~ roll_sum6 + (SSCov - 6) * (roll_sum7 - roll_sum6),
        SSCov < 8 ~ roll_sum7 + (SSCov - 7) * (roll_sum8 - roll_sum7),
        SSCov < 9 ~ roll_sum8 + (SSCov - 8) * (roll_sum9 - roll_sum8),
        SSCov < 10 ~ roll_sum9 + (SSCov - 9) * (roll_sum10 - roll_sum9),
        SSCov < 11 ~ roll_sum10 + (SSCov - 10) * (roll_sum11 - roll_sum10),
        SSCov < 12 ~ roll_sum11 + (SSCov - 11) * (roll_sum12 - roll_sum11),
        SSCov < 13 ~ roll_sum12 + (SSCov - 12) * (roll_sum13 - roll_sum12),
        SSCov < 14 ~ roll_sum13 + (SSCov - 13) * (roll_sum14 - roll_sum13),
        SSCov < 15 ~ roll_sum14 + (SSCov - 14) * (roll_sum15 - roll_sum14),
        SSCov < 16 ~ roll_sum15 + (SSCov - 15) * (roll_sum16 - roll_sum15),
        SSCov < 17 ~ roll_sum16 + (SSCov - 16) * (roll_sum17 - roll_sum16),
        SSCov < 18 ~ roll_sum17 + (SSCov - 17) * (roll_sum18 - roll_sum17),
        SSCov < 19 ~ roll_sum18 + (SSCov - 18) * (roll_sum19 - roll_sum18),
        SSCov < 20 ~ roll_sum19 + (SSCov - 19) * (roll_sum20 - roll_sum19),
        SSCov < 21 ~ roll_sum20 + (SSCov - 20) * (roll_sum21 - roll_sum20),
        SSCov < 22 ~ roll_sum21 + (SSCov - 21) * (roll_sum22 - roll_sum21),
        SSCov < 23 ~ roll_sum22 + (SSCov - 22) * (roll_sum23 - roll_sum22),
        SSCov < 24 ~ roll_sum23 + (SSCov - 23) * (roll_sum24 - roll_sum23),
        SSCov < 25 ~ roll_sum24 + (SSCov - 24) * (roll_sum25 - roll_sum24),
        SSCov < 26 ~ roll_sum25 + (SSCov - 25) * (roll_sum26 - roll_sum25),
        SSCov < 27 ~ roll_sum26 + (SSCov - 26) * (roll_sum27 - roll_sum26),
        SSCov < 28 ~ roll_sum27 + (SSCov - 27) * (roll_sum28 - roll_sum27),
        SSCov < 29 ~ roll_sum28 + (SSCov - 28) * (roll_sum29 - roll_sum28),
        SSCov < 30 ~ roll_sum29 + (SSCov - 29) * (roll_sum30 - roll_sum29),
        TRUE ~ 0
      ) # close case_when
  ) # close mutate






  #-------------------------------
  # Second: add the calculation of Maximum Stocks
  #-------------------------------


  # calculation of MaximumStocks

  df1 <- df1 %>% mutate(
    Maximum.Stocks =
      case_when(
        Stock.Max < 1 ~ Stock.Max * roll_sum1,
        Stock.Max < 2 ~ roll_sum1 + (Stock.Max - 1) * (roll_sum2 - roll_sum1),
        Stock.Max < 3 ~ roll_sum2 + (Stock.Max - 2) * (roll_sum3 - roll_sum2),
        Stock.Max < 4 ~ roll_sum3 + (Stock.Max - 3) * (roll_sum4 - roll_sum3),
        Stock.Max < 5 ~ roll_sum4 + (Stock.Max - 4) * (roll_sum5 - roll_sum4),
        Stock.Max < 6 ~ roll_sum5 + (Stock.Max - 5) * (roll_sum6 - roll_sum5),
        Stock.Max < 7 ~ roll_sum6 + (Stock.Max - 6) * (roll_sum7 - roll_sum6),
        Stock.Max < 8 ~ roll_sum7 + (Stock.Max - 7) * (roll_sum8 - roll_sum7),
        Stock.Max < 9 ~ roll_sum8 + (Stock.Max - 8) * (roll_sum9 - roll_sum8),
        Stock.Max < 10 ~ roll_sum9 + (Stock.Max - 9) * (roll_sum10 - roll_sum9),
        Stock.Max < 11 ~ roll_sum10 + (Stock.Max - 10) * (roll_sum11 - roll_sum10),
        Stock.Max < 12 ~ roll_sum11 + (Stock.Max - 11) * (roll_sum12 - roll_sum11),
        Stock.Max < 13 ~ roll_sum12 + (Stock.Max - 12) * (roll_sum13 - roll_sum12),
        Stock.Max < 14 ~ roll_sum13 + (Stock.Max - 13) * (roll_sum14 - roll_sum13),
        Stock.Max < 15 ~ roll_sum14 + (Stock.Max - 14) * (roll_sum15 - roll_sum14),
        Stock.Max < 16 ~ roll_sum15 + (Stock.Max - 15) * (roll_sum16 - roll_sum15),
        Stock.Max < 17 ~ roll_sum16 + (Stock.Max - 16) * (roll_sum17 - roll_sum16),
        Stock.Max < 18 ~ roll_sum17 + (Stock.Max - 17) * (roll_sum18 - roll_sum17),
        Stock.Max < 19 ~ roll_sum18 + (Stock.Max - 18) * (roll_sum19 - roll_sum18),
        Stock.Max < 20 ~ roll_sum19 + (Stock.Max - 19) * (roll_sum20 - roll_sum19),
        Stock.Max < 21 ~ roll_sum20 + (Stock.Max - 20) * (roll_sum21 - roll_sum20),
        Stock.Max < 22 ~ roll_sum21 + (Stock.Max - 21) * (roll_sum22 - roll_sum21),
        Stock.Max < 23 ~ roll_sum22 + (Stock.Max - 22) * (roll_sum23 - roll_sum22),
        Stock.Max < 24 ~ roll_sum23 + (Stock.Max - 23) * (roll_sum24 - roll_sum23),
        Stock.Max < 25 ~ roll_sum24 + (Stock.Max - 24) * (roll_sum25 - roll_sum24),
        Stock.Max < 26 ~ roll_sum25 + (Stock.Max - 25) * (roll_sum26 - roll_sum25),
        Stock.Max < 27 ~ roll_sum26 + (Stock.Max - 26) * (roll_sum27 - roll_sum26),
        Stock.Max < 28 ~ roll_sum27 + (Stock.Max - 27) * (roll_sum28 - roll_sum27),
        Stock.Max < 29 ~ roll_sum28 + (Stock.Max - 28) * (roll_sum29 - roll_sum28),
        Stock.Max < 30 ~ roll_sum29 + (Stock.Max - 29) * (roll_sum30 - roll_sum29),
        Stock.Max < 31 ~ roll_sum30 + (Stock.Max - 30) * (roll_sum31 - roll_sum30),
        Stock.Max < 32 ~ roll_sum31 + (Stock.Max - 31) * (roll_sum32 - roll_sum31),
        Stock.Max < 33 ~ roll_sum32 + (Stock.Max - 32) * (roll_sum33 - roll_sum32),
        Stock.Max < 34 ~ roll_sum33 + (Stock.Max - 33) * (roll_sum34 - roll_sum33),
        Stock.Max < 35 ~ roll_sum34 + (Stock.Max - 34) * (roll_sum35 - roll_sum34),
        Stock.Max < 36 ~ roll_sum35 + (Stock.Max - 35) * (roll_sum36 - roll_sum35),
        Stock.Max < 37 ~ roll_sum36 + (Stock.Max - 36) * (roll_sum37 - roll_sum36),
        Stock.Max < 38 ~ roll_sum37 + (Stock.Max - 37) * (roll_sum38 - roll_sum37),
        Stock.Max < 39 ~ roll_sum38 + (Stock.Max - 38) * (roll_sum39 - roll_sum38),
        Stock.Max < 40 ~ roll_sum39 + (Stock.Max - 39) * (roll_sum40 - roll_sum39),
        Stock.Max < 41 ~ roll_sum40 + (Stock.Max - 40) * (roll_sum41 - roll_sum40),
        TRUE ~ 0
      ) # close case_when
  ) # close mutate










  #-------------------------------
  # Finally: get the calculated database
  #-------------------------------

  # A bit of formatting, to display only integers
  df1$Safety.Stocks <- as.numeric(df1$Safety.Stocks)
  df1$Maximum.Stocks <- as.numeric(df1$Maximum.Stocks)


  # We now keep a file which will be used for DRP Calculation later on, as we will need all the calculated projected Safety & Maximum Stocks.

  # Get results: file which will be used for DRP Calculation later on
  # we will need all the calculated projected Safety & Maximum Stocks
  Calculated_Projected_Inventories_and_DB_for_DRP_Calculation <- df1







  #-------------------------------
  # Net Demand & DRP index
  #-------------------------------


  # Net Demand Calculation. Attention: special formula for the 1st month
  df1$Net.Demand.Qty <- df1$Projected.Inventories.Qty - df1$Safety.Stocks


  # selection of only "negative" Net Demand
  df1$Negative.Net.Demand <- if_else(df1$Net.Demand.Qty > 0, 0, df1$Net.Demand.Qty)


  # identification of DRP calculation (to identify later its date of start)
  # DRP only starts when the Net Demand appears negative for the 1st time and outside the Frozen Horizon
  df1$DRP.period <- if_else(df1$DRP.Grid == "Free",
    if_else(df1$Negative.Net.Demand < 0, 1, 0), 0
  )


  # creation of DRP index to increment the DRP horizon of calculation, and later on link w/ DRPCovDur
  # df1<-setDT(df1)[, DRP.index := cumsum(DRP.period), by = DFU]

  df1 <- df1 %>%
    group_by(DFU) %>%
    mutate(
      DRP.index = cumsum(DRP.period)
    )



  # Difference between Targets Stocks Max & min
  df1$Difference.Max.Min <- df1$Maximum.Stocks - df1$Safety.Stocks









  #-------------------------------
  # Calculation of DRP.index.Adjusted
  #-------------------------------

  # we identify the time of Replenishment

  # replace missing values by zero
  df1$DRP.index[is.na(df1$DRP.index)] <- 0

  # identify the periods where we should replenish
  df1$DRP.index.Adjusted <- (df1$DRP.index - 1) / df1$DRPCovDur

  # keep only the integers
  df1$DRP.index.Adjusted <- df1$DRP.index.Adjusted %% 1

  # affect a "YES"
  df1$DRP.index.Adjusted <- if_else(df1$DRP.index.Adjusted == 0, "YES", "NO")



  # why 'DRPindex-1'?
  # because we need to reset the origin of the DRP period considering that the displayed projected inventories are at month's end
  # ([Stock Maxi]-[Stock mini]) = DRPCovDur





  #-------------------------------
  #       DRP Plan Calculation
  #-------------------------------


  # Note: the DRP plan contains the POs within the Frozen Horizon.
  # This has been taken into consideration previously, through the variable DRP Grid and its Frozen / Free horizon.

  # Basically, there are 2 types of values (or components of the DRP plan):
  # - a periodic replenishment quantity: just the difference between Stock Max and Stock min, rounded according to the Reorder.Qty
  # - an initial replenishment quantity: the first time we replenish we reach the Stock Max


  # calculate the periodic replenishment quantity
  df1$Periodic.Replenishment.Qty <- if_else(df1$DRP.index.Adjusted == "YES",
    round(df1$Difference.Max.Min / df1$Reorder.Qty) * df1$Reorder.Qty,
    0
  )

  # calculate the initial quantity
  df1$Initial.Replenishment.Qty <- if_else(df1$DRP.index == 1,
    round((df1$Maximum.Stocks - df1$Projected.Inventories.Qty) / df1$Reorder.Qty) * df1$Reorder.Qty,
    0
  )


  # remove the Periodic.Replenishment.Qty for the first period
  df1$Periodic.Replenishment.Qty <- if_else(df1$DRP.index == 1,
    0,
    df1$Periodic.Replenishment.Qty
  )

  # sum both components to get the final DRP.Replenishment.Qty
  df1$DRP.Replenishment.Qty <- df1$Initial.Replenishment.Qty + df1$Periodic.Replenishment.Qty


  # and now we just need to add the existing Supply Plan, Putchase Orders for example, which are within the the Frozen Horizon
  # to get the complete DRP (supply) plan
  df1$DRP.plan <- df1$Supply.Plan + df1$DRP.Replenishment.Qty


  # Get Results
  DRP_DB <- df1



  #-------------------------------
  #-------------------------------

  #    Calculate the new Projected Inventories
  #    based on the DRP calculation

  #-------------------------------
  #-------------------------------


  # set a working df
  df1 <- DRP_DB

  #-------------------------------
  # Accumulate Values


  # calculate the Projected Inventories keeping only the adjusted.Supply.Plan.Qty as Supply Plan
  df1 <- df1 %>%
    group_by(DFU, Period) %>%
    summarise(
      Demand = sum(Demand),
      Opening.Inventories = sum(Opening.Inventories),
      DRP.plan = sum(DRP.plan)
    ) %>%
    mutate(
      acc_Demand = cumsum(Demand),
      acc_Opening.Inventories = cumsum(Opening.Inventories),
      acc_DRP.plan = cumsum(DRP.plan)
    )



  #-------------------------------
  # Calculate the Projected Inventories

  # calculation projected inventories Qty

  df1 <- df1 %>%
    group_by(
      DFU, Period,
      Demand, Opening.Inventories, DRP.plan
    ) %>%
    summarise(
      DRP.Projected.Inventories.Qty = sum(acc_Opening.Inventories) + sum(acc_DRP.plan) - sum(acc_Demand)
    )

  # Transform as dataframe
  df1 <- as.data.frame(df1)


  # Get Results
  Calculated_DRP_Projected_Inventories_DB <- df1





  #-------------------------------
  # in order to calculate the DRP projected coverages, we will use the previous roll_sumxxx columns

  # keep only the needed columns from Calculated_DRP_Projected_Inventories_DB
  df1 <- Calculated_DRP_Projected_Inventories_DB %>% select(DFU, Period, DRP.plan, DRP.Projected.Inventories.Qty)

  # merge w/ Calculated_Projected_Inventories_and_DB_for_DRP_Calculation
  df1 <- left_join(Calculated_Projected_Inventories_and_DB_for_DRP_Calculation, df1)








  #-------------------------------
  # Coverage Calculation
  # of DRP Projected Inventories Generation.
  #-------------------------------



  df1 <- df1 %>% mutate(
    DRP.Calculated.Coverage.in.Periods =
      case_when(
        (DRP.Projected.Inventories.Qty / roll_sum1) < 1 ~ (DRP.Projected.Inventories.Qty / roll_sum1),
        (DRP.Projected.Inventories.Qty / roll_sum2) < 1 ~ 1 + (DRP.Projected.Inventories.Qty - roll_sum1) / Shift2,
        (DRP.Projected.Inventories.Qty / roll_sum3) < 1 ~ 2 + (DRP.Projected.Inventories.Qty - roll_sum2) / Shift3,
        (DRP.Projected.Inventories.Qty / roll_sum4) < 1 ~ 3 + (DRP.Projected.Inventories.Qty - roll_sum3) / Shift4,
        (DRP.Projected.Inventories.Qty / roll_sum5) < 1 ~ 4 + (DRP.Projected.Inventories.Qty - roll_sum4) / Shift5,
        (DRP.Projected.Inventories.Qty / roll_sum6) < 1 ~ 5 + (DRP.Projected.Inventories.Qty - roll_sum5) / Shift6,
        (DRP.Projected.Inventories.Qty / roll_sum7) < 1 ~ 6 + (DRP.Projected.Inventories.Qty - roll_sum6) / Shift7,
        (DRP.Projected.Inventories.Qty / roll_sum8) < 1 ~ 7 + (DRP.Projected.Inventories.Qty - roll_sum7) / Shift8,
        (DRP.Projected.Inventories.Qty / roll_sum9) < 1 ~ 8 + (DRP.Projected.Inventories.Qty - roll_sum8) / Shift9,
        (DRP.Projected.Inventories.Qty / roll_sum10) < 1 ~ 9 + (DRP.Projected.Inventories.Qty - roll_sum9) / Shift10,
        (DRP.Projected.Inventories.Qty / roll_sum11) < 1 ~ 10 + (DRP.Projected.Inventories.Qty - roll_sum10) / Shift11,
        (DRP.Projected.Inventories.Qty / roll_sum12) < 1 ~ 11 + (DRP.Projected.Inventories.Qty - roll_sum11) / Shift12,
        (DRP.Projected.Inventories.Qty / roll_sum13) < 1 ~ 12 + (DRP.Projected.Inventories.Qty - roll_sum12) / Shift13,
        (DRP.Projected.Inventories.Qty / roll_sum14) < 1 ~ 13 + (DRP.Projected.Inventories.Qty - roll_sum13) / Shift14,
        (DRP.Projected.Inventories.Qty / roll_sum15) < 1 ~ 14 + (DRP.Projected.Inventories.Qty - roll_sum14) / Shift15,
        (DRP.Projected.Inventories.Qty / roll_sum16) < 1 ~ 15 + (DRP.Projected.Inventories.Qty - roll_sum15) / Shift16,
        (DRP.Projected.Inventories.Qty / roll_sum17) < 1 ~ 16 + (DRP.Projected.Inventories.Qty - roll_sum16) / Shift17,
        (DRP.Projected.Inventories.Qty / roll_sum18) < 1 ~ 17 + (DRP.Projected.Inventories.Qty - roll_sum17) / Shift18,
        (DRP.Projected.Inventories.Qty / roll_sum19) < 1 ~ 18 + (DRP.Projected.Inventories.Qty - roll_sum18) / Shift19,
        (DRP.Projected.Inventories.Qty / roll_sum20) < 1 ~ 19 + (DRP.Projected.Inventories.Qty - roll_sum19) / Shift20,
        (DRP.Projected.Inventories.Qty / roll_sum21) < 1 ~ 20 + (DRP.Projected.Inventories.Qty - roll_sum20) / Shift21,
        (DRP.Projected.Inventories.Qty / roll_sum22) < 1 ~ 21 + (DRP.Projected.Inventories.Qty - roll_sum21) / Shift22,
        (DRP.Projected.Inventories.Qty / roll_sum23) < 1 ~ 22 + (DRP.Projected.Inventories.Qty - roll_sum22) / Shift23,
        (DRP.Projected.Inventories.Qty / roll_sum24) < 1 ~ 23 + (DRP.Projected.Inventories.Qty - roll_sum23) / Shift24,
        (DRP.Projected.Inventories.Qty / roll_sum25) < 1 ~ 24 + (DRP.Projected.Inventories.Qty - roll_sum24) / Shift25,
        (DRP.Projected.Inventories.Qty / roll_sum26) < 1 ~ 25 + (DRP.Projected.Inventories.Qty - roll_sum25) / Shift26,
        (DRP.Projected.Inventories.Qty / roll_sum27) < 1 ~ 26 + (DRP.Projected.Inventories.Qty - roll_sum26) / Shift27,
        (DRP.Projected.Inventories.Qty / roll_sum28) < 1 ~ 27 + (DRP.Projected.Inventories.Qty - roll_sum27) / Shift28,
        (DRP.Projected.Inventories.Qty / roll_sum29) < 1 ~ 28 + (DRP.Projected.Inventories.Qty - roll_sum28) / Shift29,
        (DRP.Projected.Inventories.Qty / roll_sum30) < 1 ~ 29 + (DRP.Projected.Inventories.Qty - roll_sum29) / Shift30,
        (DRP.Projected.Inventories.Qty / roll_sum31) < 1 ~ 30 + (DRP.Projected.Inventories.Qty - roll_sum30) / Shift31,
        (DRP.Projected.Inventories.Qty / roll_sum32) < 1 ~ 31 + (DRP.Projected.Inventories.Qty - roll_sum31) / Shift32,
        (DRP.Projected.Inventories.Qty / roll_sum33) < 1 ~ 32 + (DRP.Projected.Inventories.Qty - roll_sum32) / Shift33,
        (DRP.Projected.Inventories.Qty / roll_sum34) < 1 ~ 33 + (DRP.Projected.Inventories.Qty - roll_sum33) / Shift34,
        (DRP.Projected.Inventories.Qty / roll_sum35) < 1 ~ 34 + (DRP.Projected.Inventories.Qty - roll_sum34) / Shift35,
        (DRP.Projected.Inventories.Qty / roll_sum36) < 1 ~ 35 + (DRP.Projected.Inventories.Qty - roll_sum35) / Shift36,
        (DRP.Projected.Inventories.Qty / roll_sum37) < 1 ~ 36 + (DRP.Projected.Inventories.Qty - roll_sum36) / Shift37,
        (DRP.Projected.Inventories.Qty / roll_sum38) < 1 ~ 37 + (DRP.Projected.Inventories.Qty - roll_sum37) / Shift38,
        (DRP.Projected.Inventories.Qty / roll_sum39) < 1 ~ 38 + (DRP.Projected.Inventories.Qty - roll_sum38) / Shift39,
        (DRP.Projected.Inventories.Qty / roll_sum40) < 1 ~ 39 + (DRP.Projected.Inventories.Qty - roll_sum39) / Shift40,
        (DRP.Projected.Inventories.Qty / roll_sum41) < 1 ~ 40 + (DRP.Projected.Inventories.Qty - roll_sum40) / Shift41,
        (DRP.Projected.Inventories.Qty / roll_sum42) < 1 ~ 41 + (DRP.Projected.Inventories.Qty - roll_sum41) / Shift42,
        (DRP.Projected.Inventories.Qty / roll_sum43) < 1 ~ 42 + (DRP.Projected.Inventories.Qty - roll_sum42) / Shift43,
        (DRP.Projected.Inventories.Qty / roll_sum44) < 1 ~ 43 + (DRP.Projected.Inventories.Qty - roll_sum43) / Shift44,
        (DRP.Projected.Inventories.Qty / roll_sum45) < 1 ~ 44 + (DRP.Projected.Inventories.Qty - roll_sum44) / Shift45,
        (DRP.Projected.Inventories.Qty / roll_sum46) < 1 ~ 45 + (DRP.Projected.Inventories.Qty - roll_sum45) / Shift46,
        (DRP.Projected.Inventories.Qty / roll_sum47) < 1 ~ 46 + (DRP.Projected.Inventories.Qty - roll_sum46) / Shift47,
        (DRP.Projected.Inventories.Qty / roll_sum48) < 1 ~ 47 + (DRP.Projected.Inventories.Qty - roll_sum47) / Shift48,
        (DRP.Projected.Inventories.Qty / roll_sum49) < 1 ~ 48 + (DRP.Projected.Inventories.Qty - roll_sum48) / Shift49,
        (DRP.Projected.Inventories.Qty / roll_sum50) < 1 ~ 49 + (DRP.Projected.Inventories.Qty - roll_sum49) / Shift50,
        (DRP.Projected.Inventories.Qty / roll_sum51) < 1 ~ 50 + (DRP.Projected.Inventories.Qty - roll_sum50) / Shift51,
        (DRP.Projected.Inventories.Qty / roll_sum52) < 1 ~ 51 + (DRP.Projected.Inventories.Qty - roll_sum51) / Shift52,
        (DRP.Projected.Inventories.Qty / roll_sum53) < 1 ~ 52 + (DRP.Projected.Inventories.Qty - roll_sum52) / Shift53,
        (DRP.Projected.Inventories.Qty / roll_sum54) < 1 ~ 53 + (DRP.Projected.Inventories.Qty - roll_sum53) / Shift54,
        (DRP.Projected.Inventories.Qty / roll_sum55) < 1 ~ 54 + (DRP.Projected.Inventories.Qty - roll_sum54) / Shift55,
        (DRP.Projected.Inventories.Qty / roll_sum56) < 1 ~ 55 + (DRP.Projected.Inventories.Qty - roll_sum55) / Shift56,
        (DRP.Projected.Inventories.Qty / roll_sum57) < 1 ~ 56 + (DRP.Projected.Inventories.Qty - roll_sum56) / Shift57,
        (DRP.Projected.Inventories.Qty / roll_sum58) < 1 ~ 57 + (DRP.Projected.Inventories.Qty - roll_sum57) / Shift58,
        (DRP.Projected.Inventories.Qty / roll_sum59) < 1 ~ 58 + (DRP.Projected.Inventories.Qty - roll_sum58) / Shift59,
        (DRP.Projected.Inventories.Qty / roll_sum60) < 1 ~ 59 + (DRP.Projected.Inventories.Qty - roll_sum59) / Shift60,
        TRUE ~ 0
      ) # close case_when
  ) # close mutate













  #-------------------------------

  # Keep only the needed columns

  #-------------------------------


  df1 <- df1 %>% select(
    DFU, Period,

    # Initial variables
    Demand, Opening.Inventories, Supply.Plan,

    # DRP parameters
    SSCov, DRPCovDur, Stock.Max, Reorder.Qty, DRP.Grid,

    # converted Safety and Maximum stocks in units
    Safety.Stocks,
    Maximum.Stocks,

    # DRP Results
    DRP.Calculated.Coverage.in.Periods,
    DRP.Projected.Inventories.Qty,
    DRP.plan
  )







  #-------------------------------
  # Merge w/ Initial_DB and remove the component random.demand
  # from the Demand and the Projected.Inventories.Qty
  #-------------------------------

  # keep only the needed columns
  Random_Demand_DB <- Initial_DB %>% select(DFU, Period, random.demand)

  # merge both databases
  df1 <- left_join(df1, Random_Demand_DB)

  # remove the component random.demand
  df1$Demand <- df1$Demand - df1$random.demand
  df1$DRP.Projected.Inventories.Qty <- df1$DRP.Projected.Inventories.Qty + df1$random.demand

  # remove not needed columns
  df1 <- df1[, -which(names(df1) %in% c("random.demand"))]

  # round the Projected.Inventories.Qty
  df1$DRP.Projected.Inventories.Qty <- round(df1$DRP.Projected.Inventories.Qty, 1)


  # round the DRP.Calculated.Coverage.in.Periods
  df1$DRP.Calculated.Coverage.in.Periods <- round(df1$DRP.Calculated.Coverage.in.Periods, 1)


  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}
