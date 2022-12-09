#' Calculates projected inventories and coverages and perform an analysis vs stocks targets
#'
#' @param dataset a dataframe with the demand and supply features for an item per period
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a period of time monthly or weekly buckets for example
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#' @param Opening the opening inventories of an item in units at the beginning of the horizon
#' @param Supply the quantity of an item planned to be supplied in units for a given period
#' @param Min.Cov minimum stocks target of an item expressed in periods
#' @param Max.Cov maximum stocks target of an item expressed in periods
#'
#' @importFrom RcppRoll roll_sum
#' @importFrom magrittr %>%
#' @importFrom stats runif
#' @import dplyr
#'
#' @return a dataframe with the calculated projected inventories and coverages and the related analysis
#' @export
#'
#' @examples
#' proj_inv(dataset = blueprint, DFU, Period, Demand, Opening, Supply, Min.Cov, Max.Cov)
proj_inv <- function(dataset, DFU, Period, Demand, Opening, Supply,
                     Min.Cov, Max.Cov) {



  # avoid "no visible binding for global variable"
  Demand <- Opening <- Supply <- Min.Cov <- Max.Cov <- NULL

  acc_Demand <- acc_Opening.Inventories <- acc_Supply.Plan <- NULL

  Shifted.Demand <- NULL
  Calculated.Coverage.in.Periods <- NULL
  Projected.Inventories.Qty <- NULL
  random.demand <- NULL

  Safety.Stocks <- NULL
  Maximum.Stocks <- NULL




  # set a working df
  df1 <- dataset


  #---------------------------------------------------------------
  #---------------------------------------------------------------

  # Keep a Database w/ the DRP Parameters

  #---------------------------------------------------------------
  #---------------------------------------------------------------

  Stocks_Parameters_DB <- df1 %>% select(
    DFU,
    Period,
    Min.Cov,
    Max.Cov
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



  #-------------------------------
  # Accumulate Values

  df1 <- df1 %>%
    group_by(DFU, Period) %>%
    summarise(
      Demand = sum(Demand),
      Opening = sum(Opening),
      Supply = sum(Supply)
    ) %>%
    mutate(
      acc_Demand = cumsum(Demand),
      acc_Opening.Inventories = cumsum(Opening),
      acc_Supply.Plan = cumsum(Supply)
    )





  #-------------------------------
  # Extract Projected Inventories

  # calculation projected inventories Qty

  df1 <- df1 %>%
    group_by(DFU, Period, Demand, Opening, Supply) %>%
    summarise(
      Projected.Inventories.Qty = sum(acc_Opening.Inventories) + sum(acc_Supply.Plan) - sum(acc_Demand)
    )

  # Transform as dataframe
  df1 <- as.data.frame(df1)


  #-------------------------------
  # Get Results
  Interim_DB <- df1







  #---------------------------------------------------------------
  #---------------------------------------------------------------


  # Calculate Projected Coverages


  #---------------------------------------------------------------
  #---------------------------------------------------------------




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


  # add the Stocks_Parameters_DB
  df1 <- left_join(df1, Stocks_Parameters_DB)




  # calculation of Safety Stocks

  df1 <- df1 %>% mutate(
    Safety.Stocks =
      case_when(
        Min.Cov < 1 ~ Min.Cov * roll_sum1,
        Min.Cov < 2 ~ roll_sum1 + (Min.Cov - 1) * (roll_sum2 - roll_sum1),
        Min.Cov < 3 ~ roll_sum2 + (Min.Cov - 2) * (roll_sum3 - roll_sum2),
        Min.Cov < 4 ~ roll_sum3 + (Min.Cov - 3) * (roll_sum4 - roll_sum3),
        Min.Cov < 5 ~ roll_sum4 + (Min.Cov - 4) * (roll_sum5 - roll_sum4),
        Min.Cov < 6 ~ roll_sum5 + (Min.Cov - 5) * (roll_sum6 - roll_sum5),
        Min.Cov < 7 ~ roll_sum6 + (Min.Cov - 6) * (roll_sum7 - roll_sum6),
        Min.Cov < 8 ~ roll_sum7 + (Min.Cov - 7) * (roll_sum8 - roll_sum7),
        Min.Cov < 9 ~ roll_sum8 + (Min.Cov - 8) * (roll_sum9 - roll_sum8),
        Min.Cov < 10 ~ roll_sum9 + (Min.Cov - 9) * (roll_sum10 - roll_sum9),
        Min.Cov < 11 ~ roll_sum10 + (Min.Cov - 10) * (roll_sum11 - roll_sum10),
        Min.Cov < 12 ~ roll_sum11 + (Min.Cov - 11) * (roll_sum12 - roll_sum11),
        Min.Cov < 13 ~ roll_sum12 + (Min.Cov - 12) * (roll_sum13 - roll_sum12),
        Min.Cov < 14 ~ roll_sum13 + (Min.Cov - 13) * (roll_sum14 - roll_sum13),
        Min.Cov < 15 ~ roll_sum14 + (Min.Cov - 14) * (roll_sum15 - roll_sum14),
        Min.Cov < 16 ~ roll_sum15 + (Min.Cov - 15) * (roll_sum16 - roll_sum15),
        Min.Cov < 17 ~ roll_sum16 + (Min.Cov - 16) * (roll_sum17 - roll_sum16),
        Min.Cov < 18 ~ roll_sum17 + (Min.Cov - 17) * (roll_sum18 - roll_sum17),
        Min.Cov < 19 ~ roll_sum18 + (Min.Cov - 18) * (roll_sum19 - roll_sum18),
        Min.Cov < 20 ~ roll_sum19 + (Min.Cov - 19) * (roll_sum20 - roll_sum19),
        Min.Cov < 21 ~ roll_sum20 + (Min.Cov - 20) * (roll_sum21 - roll_sum20),
        Min.Cov < 22 ~ roll_sum21 + (Min.Cov - 21) * (roll_sum22 - roll_sum21),
        Min.Cov < 23 ~ roll_sum22 + (Min.Cov - 22) * (roll_sum23 - roll_sum22),
        Min.Cov < 24 ~ roll_sum23 + (Min.Cov - 23) * (roll_sum24 - roll_sum23),
        Min.Cov < 25 ~ roll_sum24 + (Min.Cov - 24) * (roll_sum25 - roll_sum24),
        Min.Cov < 26 ~ roll_sum25 + (Min.Cov - 25) * (roll_sum26 - roll_sum25),
        Min.Cov < 27 ~ roll_sum26 + (Min.Cov - 26) * (roll_sum27 - roll_sum26),
        Min.Cov < 28 ~ roll_sum27 + (Min.Cov - 27) * (roll_sum28 - roll_sum27),
        Min.Cov < 29 ~ roll_sum28 + (Min.Cov - 28) * (roll_sum29 - roll_sum28),
        Min.Cov < 30 ~ roll_sum29 + (Min.Cov - 29) * (roll_sum30 - roll_sum29),
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
        Max.Cov < 1 ~ Max.Cov * roll_sum1,
        Max.Cov < 2 ~ roll_sum1 + (Max.Cov - 1) * (roll_sum2 - roll_sum1),
        Max.Cov < 3 ~ roll_sum2 + (Max.Cov - 2) * (roll_sum3 - roll_sum2),
        Max.Cov < 4 ~ roll_sum3 + (Max.Cov - 3) * (roll_sum4 - roll_sum3),
        Max.Cov < 5 ~ roll_sum4 + (Max.Cov - 4) * (roll_sum5 - roll_sum4),
        Max.Cov < 6 ~ roll_sum5 + (Max.Cov - 5) * (roll_sum6 - roll_sum5),
        Max.Cov < 7 ~ roll_sum6 + (Max.Cov - 6) * (roll_sum7 - roll_sum6),
        Max.Cov < 8 ~ roll_sum7 + (Max.Cov - 7) * (roll_sum8 - roll_sum7),
        Max.Cov < 9 ~ roll_sum8 + (Max.Cov - 8) * (roll_sum9 - roll_sum8),
        Max.Cov < 10 ~ roll_sum9 + (Max.Cov - 9) * (roll_sum10 - roll_sum9),
        Max.Cov < 11 ~ roll_sum10 + (Max.Cov - 10) * (roll_sum11 - roll_sum10),
        Max.Cov < 12 ~ roll_sum11 + (Max.Cov - 11) * (roll_sum12 - roll_sum11),
        Max.Cov < 13 ~ roll_sum12 + (Max.Cov - 12) * (roll_sum13 - roll_sum12),
        Max.Cov < 14 ~ roll_sum13 + (Max.Cov - 13) * (roll_sum14 - roll_sum13),
        Max.Cov < 15 ~ roll_sum14 + (Max.Cov - 14) * (roll_sum15 - roll_sum14),
        Max.Cov < 16 ~ roll_sum15 + (Max.Cov - 15) * (roll_sum16 - roll_sum15),
        Max.Cov < 17 ~ roll_sum16 + (Max.Cov - 16) * (roll_sum17 - roll_sum16),
        Max.Cov < 18 ~ roll_sum17 + (Max.Cov - 17) * (roll_sum18 - roll_sum17),
        Max.Cov < 19 ~ roll_sum18 + (Max.Cov - 18) * (roll_sum19 - roll_sum18),
        Max.Cov < 20 ~ roll_sum19 + (Max.Cov - 19) * (roll_sum20 - roll_sum19),
        Max.Cov < 21 ~ roll_sum20 + (Max.Cov - 20) * (roll_sum21 - roll_sum20),
        Max.Cov < 22 ~ roll_sum21 + (Max.Cov - 21) * (roll_sum22 - roll_sum21),
        Max.Cov < 23 ~ roll_sum22 + (Max.Cov - 22) * (roll_sum23 - roll_sum22),
        Max.Cov < 24 ~ roll_sum23 + (Max.Cov - 23) * (roll_sum24 - roll_sum23),
        Max.Cov < 25 ~ roll_sum24 + (Max.Cov - 24) * (roll_sum25 - roll_sum24),
        Max.Cov < 26 ~ roll_sum25 + (Max.Cov - 25) * (roll_sum26 - roll_sum25),
        Max.Cov < 27 ~ roll_sum26 + (Max.Cov - 26) * (roll_sum27 - roll_sum26),
        Max.Cov < 28 ~ roll_sum27 + (Max.Cov - 27) * (roll_sum28 - roll_sum27),
        Max.Cov < 29 ~ roll_sum28 + (Max.Cov - 28) * (roll_sum29 - roll_sum28),
        Max.Cov < 30 ~ roll_sum29 + (Max.Cov - 29) * (roll_sum30 - roll_sum29),
        Max.Cov < 31 ~ roll_sum30 + (Max.Cov - 30) * (roll_sum31 - roll_sum30),
        Max.Cov < 32 ~ roll_sum31 + (Max.Cov - 31) * (roll_sum32 - roll_sum31),
        Max.Cov < 33 ~ roll_sum32 + (Max.Cov - 32) * (roll_sum33 - roll_sum32),
        Max.Cov < 34 ~ roll_sum33 + (Max.Cov - 33) * (roll_sum34 - roll_sum33),
        Max.Cov < 35 ~ roll_sum34 + (Max.Cov - 34) * (roll_sum35 - roll_sum34),
        Max.Cov < 36 ~ roll_sum35 + (Max.Cov - 35) * (roll_sum36 - roll_sum35),
        Max.Cov < 37 ~ roll_sum36 + (Max.Cov - 36) * (roll_sum37 - roll_sum36),
        Max.Cov < 38 ~ roll_sum37 + (Max.Cov - 37) * (roll_sum38 - roll_sum37),
        Max.Cov < 39 ~ roll_sum38 + (Max.Cov - 38) * (roll_sum39 - roll_sum38),
        Max.Cov < 40 ~ roll_sum39 + (Max.Cov - 39) * (roll_sum40 - roll_sum39),
        Max.Cov < 41 ~ roll_sum40 + (Max.Cov - 40) * (roll_sum41 - roll_sum40),
        TRUE ~ 0
      ) # close case_when
  ) # close mutate










  #-------------------------------
  # a little formatting
  #-------------------------------

  # A bit of formatting, to display only integers
  df1$Safety.Stocks <- as.numeric(df1$Safety.Stocks)
  df1$Maximum.Stocks <- as.numeric(df1$Maximum.Stocks)



  # round the Projected Safety and Maximum
  df1$Safety.Stocks <- round(df1$Safety.Stocks, 1)
  df1$Maximum.Stocks <- round(df1$Maximum.Stocks, 1)

















  #-------------------------------
  # Keep only the needed columns
  #-------------------------------

  df1 <- df1 %>% select(
    DFU, Period, Demand, Opening,
    Calculated.Coverage.in.Periods,
    Projected.Inventories.Qty,
    Supply,

    # Stocks Parameters
    Min.Cov,
    Max.Cov,

    # Projected Stocks Parameters
    Safety.Stocks,
    Maximum.Stocks
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
  df1$Projected.Inventories.Qty <- df1$Projected.Inventories.Qty + df1$random.demand

  # remove not needed columns
  df1 <- df1[, -which(names(df1) %in% c("random.demand"))]

  # round the Projected.Inventories.Qty
  df1$Projected.Inventories.Qty <- round(df1$Projected.Inventories.Qty, 1)






  #-------------------------------
  # Create a Projected Inventories Analysis Index: PI.Index
  #-------------------------------


  # identify OverStocks situations: above maximum stocks
  df1$PI.Index <- if_else(df1$Calculated.Coverage.in.Periods > df1$Max.Cov, "OverStock", "OK")

  # identify Alerts situations: below safety stocks
  df1$PI.Index <- if_else(df1$Calculated.Coverage.in.Periods < df1$Min.Cov, "Alert", df1$PI.Index)

  # identify Shortages: when projected inventories are negative
  df1$PI.Index <- if_else(df1$Projected.Inventories.Qty < 0, "Shortage", df1$PI.Index)

  # replace missing values by TBC
  df1$PI.Index[is.na(df1$PI.Index)] <- "TBC"









  #-------------------------------
  # Calculate ratio (percentage) of Projected Inventories vs Min and Max Thresholds
  #-------------------------------

  # ratio PI vs Safety Stocks
  df1$Ratio.PI.vs.min <- df1$Projected.Inventories.Qty / df1$Safety.Stocks

  # ratio PI vs Maximum Stocks
  df1$Ratio.PI.vs.Max <- df1$Projected.Inventories.Qty / df1$Maximum.Stocks

  # replace -Inf by NA
  df1$Ratio.PI.vs.min <- if_else(is.infinite(df1$Ratio.PI.vs.min), 0, df1$Ratio.PI.vs.min)
  df1$Ratio.PI.vs.Max <- if_else(is.infinite(df1$Ratio.PI.vs.Max), 0, df1$Ratio.PI.vs.Max)


  # round the ratios
  df1$Ratio.PI.vs.min <- round(df1$Ratio.PI.vs.min, 2)
  df1$Ratio.PI.vs.Max <- round(df1$Ratio.PI.vs.Max, 2)








  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}
