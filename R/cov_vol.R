#' Calculates the calculated coverage expressed in volume of a coverage initially expressed in periods of time
#'
#' @param dataset a dataframe with the demand and supply features for an item per period
#' @param DFU name of an item, a SKU, or a node like an item x location
#' @param Period a period of time monthly or weekly buckets for example
#' @param Demand the quantity of an item planned to be consumed in units for a given period
#' @param Coverage the defined Coverage, expressed in number of periods
#'
#' @importFrom RcppRoll roll_sum
#' @importFrom magrittr %>%
#' @importFrom stats runif
#' @import dplyr
#'
#' @return a dataframe with the calculated coverage expressed in volume
#' @export
#'
#' @examples
#' cov_vol(dataset = cov_vol_data, DFU, Period, Demand, Coverage)
#'
cov_vol <- function(dataset, DFU, Period,
                Demand, Coverage) {


  # avoid "no visible binding for global variable"
  Demand <- Coverage <- NULL


  acc_Demand <- NULL

  Shifted.Demand <- NULL

  random.demand <- NULL

  Coverage.Volume <- NULL


  # set a working df
  df1 <- dataset




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


  # Calculate Accumulated Demand


  #---------------------------------------------------------------
  #---------------------------------------------------------------


  # Set a working df:
  df1 <- Initial_DB


  # calculate the accumulated Demand
  df1 <- df1 |>
    group_by(DFU, Coverage, Period) |>
    summarise(
      Demand = sum(Demand)
    ) |>
    mutate(
      acc_Demand = cumsum(Demand)
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
  df1 <- df1 |>
    group_by(DFU, Coverage) |>
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
      Shift60 = lead(Demand, n = 60),

      Shift61 = lead(Demand, n = 61),
      Shift62 = lead(Demand, n = 62),
      Shift63 = lead(Demand, n = 63),
      Shift64 = lead(Demand, n = 64),
      Shift65 = lead(Demand, n = 65),
      Shift66 = lead(Demand, n = 66),
      Shift67 = lead(Demand, n = 67),
      Shift68 = lead(Demand, n = 68),
      Shift69 = lead(Demand, n = 69),
      Shift70 = lead(Demand, n = 70),

      Shift71 = lead(Demand, n = 71),
      Shift72 = lead(Demand, n = 72),
      Shift73 = lead(Demand, n = 73),
      Shift74 = lead(Demand, n = 74),
      Shift75 = lead(Demand, n = 75),
      Shift76 = lead(Demand, n = 76),
      Shift77 = lead(Demand, n = 77),
      Shift78 = lead(Demand, n = 78),
      Shift79 = lead(Demand, n = 79),
      Shift80 = lead(Demand, n = 80),

      Shift81 = lead(Demand, n = 81),
      Shift82 = lead(Demand, n = 82),
      Shift83 = lead(Demand, n = 83),
      Shift84 = lead(Demand, n = 84),
      Shift85 = lead(Demand, n = 85),
      Shift86 = lead(Demand, n = 86),
      Shift87 = lead(Demand, n = 87),
      Shift88 = lead(Demand, n = 88),
      Shift89 = lead(Demand, n = 89),
      Shift90 = lead(Demand, n = 90),

      Shift91 = lead(Demand, n = 91),
      Shift92 = lead(Demand, n = 92),
      Shift93 = lead(Demand, n = 93),
      Shift94 = lead(Demand, n = 94),
      Shift95 = lead(Demand, n = 95),
      Shift96 = lead(Demand, n = 96),
      Shift97 = lead(Demand, n = 97),
      Shift98 = lead(Demand, n = 98),
      Shift99 = lead(Demand, n = 99),
      Shift100 = lead(Demand, n = 100),

      Shift101 = lead(Demand, n = 101),
      Shift102 = lead(Demand, n = 102),
      Shift103 = lead(Demand, n = 103),
      Shift104 = lead(Demand, n = 104),
      Shift105 = lead(Demand, n = 105),
      Shift106 = lead(Demand, n = 106),
      Shift107 = lead(Demand, n = 107),
      Shift108 = lead(Demand, n = 108),
      Shift109 = lead(Demand, n = 109),
      Shift110 = lead(Demand, n = 110),

      Shift111 = lead(Demand, n = 111),
      Shift112 = lead(Demand, n = 112),
      Shift113 = lead(Demand, n = 113),
      Shift114 = lead(Demand, n = 114),
      Shift115 = lead(Demand, n = 115),
      Shift116 = lead(Demand, n = 116),
      Shift117 = lead(Demand, n = 117),
      Shift118 = lead(Demand, n = 118),
      Shift119 = lead(Demand, n = 119),
      Shift120 = lead(Demand, n = 120)



    )





  #-------------------------------
  # Generate additive columns

  # Calculate a rolling sum.


  # calculate additive columns
  df1 <- df1 |> group_by(DFU, Coverage) |>
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
      roll_sum60 = roll_sum(Shifted.Demand, 60, fill = NA, align = "left"),

      roll_sum61 = roll_sum(Shifted.Demand, 61, fill = NA, align = "left"),
      roll_sum62 = roll_sum(Shifted.Demand, 62, fill = NA, align = "left"),
      roll_sum63 = roll_sum(Shifted.Demand, 63, fill = NA, align = "left"),
      roll_sum64 = roll_sum(Shifted.Demand, 64, fill = NA, align = "left"),
      roll_sum65 = roll_sum(Shifted.Demand, 65, fill = NA, align = "left"),
      roll_sum66 = roll_sum(Shifted.Demand, 66, fill = NA, align = "left"),
      roll_sum67 = roll_sum(Shifted.Demand, 67, fill = NA, align = "left"),
      roll_sum68 = roll_sum(Shifted.Demand, 68, fill = NA, align = "left"),
      roll_sum69 = roll_sum(Shifted.Demand, 69, fill = NA, align = "left"),
      roll_sum70 = roll_sum(Shifted.Demand, 70, fill = NA, align = "left"),

      roll_sum71 = roll_sum(Shifted.Demand, 71, fill = NA, align = "left"),
      roll_sum72 = roll_sum(Shifted.Demand, 72, fill = NA, align = "left"),
      roll_sum73 = roll_sum(Shifted.Demand, 73, fill = NA, align = "left"),
      roll_sum74 = roll_sum(Shifted.Demand, 74, fill = NA, align = "left"),
      roll_sum75 = roll_sum(Shifted.Demand, 75, fill = NA, align = "left"),
      roll_sum76 = roll_sum(Shifted.Demand, 76, fill = NA, align = "left"),
      roll_sum77 = roll_sum(Shifted.Demand, 77, fill = NA, align = "left"),
      roll_sum78 = roll_sum(Shifted.Demand, 78, fill = NA, align = "left"),
      roll_sum79 = roll_sum(Shifted.Demand, 79, fill = NA, align = "left"),
      roll_sum80 = roll_sum(Shifted.Demand, 80, fill = NA, align = "left"),

      roll_sum81 = roll_sum(Shifted.Demand, 81, fill = NA, align = "left"),
      roll_sum82 = roll_sum(Shifted.Demand, 82, fill = NA, align = "left"),
      roll_sum83 = roll_sum(Shifted.Demand, 83, fill = NA, align = "left"),
      roll_sum84 = roll_sum(Shifted.Demand, 84, fill = NA, align = "left"),
      roll_sum85 = roll_sum(Shifted.Demand, 85, fill = NA, align = "left"),
      roll_sum86 = roll_sum(Shifted.Demand, 86, fill = NA, align = "left"),
      roll_sum87 = roll_sum(Shifted.Demand, 87, fill = NA, align = "left"),
      roll_sum88 = roll_sum(Shifted.Demand, 88, fill = NA, align = "left"),
      roll_sum89 = roll_sum(Shifted.Demand, 89, fill = NA, align = "left"),
      roll_sum90 = roll_sum(Shifted.Demand, 90, fill = NA, align = "left"),


      roll_sum91 = roll_sum(Shifted.Demand, 91, fill = NA, align = "left"),
      roll_sum92 = roll_sum(Shifted.Demand, 92, fill = NA, align = "left"),
      roll_sum93 = roll_sum(Shifted.Demand, 93, fill = NA, align = "left"),
      roll_sum94 = roll_sum(Shifted.Demand, 94, fill = NA, align = "left"),
      roll_sum95 = roll_sum(Shifted.Demand, 95, fill = NA, align = "left"),
      roll_sum96 = roll_sum(Shifted.Demand, 96, fill = NA, align = "left"),
      roll_sum97 = roll_sum(Shifted.Demand, 97, fill = NA, align = "left"),
      roll_sum98 = roll_sum(Shifted.Demand, 98, fill = NA, align = "left"),
      roll_sum99 = roll_sum(Shifted.Demand, 99, fill = NA, align = "left"),
      roll_sum100 = roll_sum(Shifted.Demand, 100, fill = NA, align = "left"),

      roll_sum101 = roll_sum(Shifted.Demand, 101, fill = NA, align = "left"),
      roll_sum102 = roll_sum(Shifted.Demand, 102, fill = NA, align = "left"),
      roll_sum103 = roll_sum(Shifted.Demand, 103, fill = NA, align = "left"),
      roll_sum104 = roll_sum(Shifted.Demand, 104, fill = NA, align = "left"),
      roll_sum105 = roll_sum(Shifted.Demand, 105, fill = NA, align = "left"),
      roll_sum106 = roll_sum(Shifted.Demand, 106, fill = NA, align = "left"),
      roll_sum107 = roll_sum(Shifted.Demand, 107, fill = NA, align = "left"),
      roll_sum108 = roll_sum(Shifted.Demand, 108, fill = NA, align = "left"),
      roll_sum109 = roll_sum(Shifted.Demand, 109, fill = NA, align = "left"),
      roll_sum110 = roll_sum(Shifted.Demand, 110, fill = NA, align = "left"),

      roll_sum111 = roll_sum(Shifted.Demand, 111, fill = NA, align = "left"),
      roll_sum112 = roll_sum(Shifted.Demand, 112, fill = NA, align = "left"),
      roll_sum113 = roll_sum(Shifted.Demand, 113, fill = NA, align = "left"),
      roll_sum114 = roll_sum(Shifted.Demand, 114, fill = NA, align = "left"),
      roll_sum115 = roll_sum(Shifted.Demand, 115, fill = NA, align = "left"),
      roll_sum116 = roll_sum(Shifted.Demand, 116, fill = NA, align = "left"),
      roll_sum117 = roll_sum(Shifted.Demand, 117, fill = NA, align = "left"),
      roll_sum118 = roll_sum(Shifted.Demand, 118, fill = NA, align = "left"),
      roll_sum119 = roll_sum(Shifted.Demand, 119, fill = NA, align = "left"),
      roll_sum120 = roll_sum(Shifted.Demand, 120, fill = NA, align = "left")


    )







  #-------------------------------
  #-------------------------------

  # Calculation of Projected Volumes, based on needed Coverage

  #-------------------------------
  #-------------------------------

  df1 <- df1 |> mutate(
    Coverage.Volume =
      case_when(
        Coverage < 1 ~ Coverage * roll_sum1,
        Coverage < 2 ~ roll_sum1 + (Coverage - 1) * (roll_sum2 - roll_sum1),
        Coverage < 3 ~ roll_sum2 + (Coverage - 2) * (roll_sum3 - roll_sum2),
        Coverage < 4 ~ roll_sum3 + (Coverage - 3) * (roll_sum4 - roll_sum3),
        Coverage < 5 ~ roll_sum4 + (Coverage - 4) * (roll_sum5 - roll_sum4),
        Coverage < 6 ~ roll_sum5 + (Coverage - 5) * (roll_sum6 - roll_sum5),
        Coverage < 7 ~ roll_sum6 + (Coverage - 6) * (roll_sum7 - roll_sum6),
        Coverage < 8 ~ roll_sum7 + (Coverage - 7) * (roll_sum8 - roll_sum7),
        Coverage < 9 ~ roll_sum8 + (Coverage - 8) * (roll_sum9 - roll_sum8),
        Coverage < 10 ~ roll_sum9 + (Coverage - 9) * (roll_sum10 - roll_sum9),
        Coverage < 11 ~ roll_sum10 + (Coverage - 10) * (roll_sum11 - roll_sum10),
        Coverage < 12 ~ roll_sum11 + (Coverage - 11) * (roll_sum12 - roll_sum11),
        Coverage < 13 ~ roll_sum12 + (Coverage - 12) * (roll_sum13 - roll_sum12),
        Coverage < 14 ~ roll_sum13 + (Coverage - 13) * (roll_sum14 - roll_sum13),
        Coverage < 15 ~ roll_sum14 + (Coverage - 14) * (roll_sum15 - roll_sum14),
        Coverage < 16 ~ roll_sum15 + (Coverage - 15) * (roll_sum16 - roll_sum15),
        Coverage < 17 ~ roll_sum16 + (Coverage - 16) * (roll_sum17 - roll_sum16),
        Coverage < 18 ~ roll_sum17 + (Coverage - 17) * (roll_sum18 - roll_sum17),
        Coverage < 19 ~ roll_sum18 + (Coverage - 18) * (roll_sum19 - roll_sum18),
        Coverage < 20 ~ roll_sum19 + (Coverage - 19) * (roll_sum20 - roll_sum19),
        Coverage < 21 ~ roll_sum20 + (Coverage - 20) * (roll_sum21 - roll_sum20),
        Coverage < 22 ~ roll_sum21 + (Coverage - 21) * (roll_sum22 - roll_sum21),
        Coverage < 23 ~ roll_sum22 + (Coverage - 22) * (roll_sum23 - roll_sum22),
        Coverage < 24 ~ roll_sum23 + (Coverage - 23) * (roll_sum24 - roll_sum23),
        Coverage < 25 ~ roll_sum24 + (Coverage - 24) * (roll_sum25 - roll_sum24),
        Coverage < 26 ~ roll_sum25 + (Coverage - 25) * (roll_sum26 - roll_sum25),
        Coverage < 27 ~ roll_sum26 + (Coverage - 26) * (roll_sum27 - roll_sum26),
        Coverage < 28 ~ roll_sum27 + (Coverage - 27) * (roll_sum28 - roll_sum27),
        Coverage < 29 ~ roll_sum28 + (Coverage - 28) * (roll_sum29 - roll_sum28),
        Coverage < 30 ~ roll_sum29 + (Coverage - 29) * (roll_sum30 - roll_sum29),
        Coverage < 31 ~ roll_sum30 + (Coverage - 30) * (roll_sum31 - roll_sum30),
        Coverage < 32 ~ roll_sum31 + (Coverage - 31) * (roll_sum32 - roll_sum31),
        Coverage < 33 ~ roll_sum32 + (Coverage - 32) * (roll_sum33 - roll_sum32),
        Coverage < 34 ~ roll_sum33 + (Coverage - 33) * (roll_sum34 - roll_sum33),
        Coverage < 35 ~ roll_sum34 + (Coverage - 34) * (roll_sum35 - roll_sum34),
        Coverage < 36 ~ roll_sum35 + (Coverage - 35) * (roll_sum36 - roll_sum35),
        Coverage < 37 ~ roll_sum36 + (Coverage - 36) * (roll_sum37 - roll_sum36),
        Coverage < 38 ~ roll_sum37 + (Coverage - 37) * (roll_sum38 - roll_sum37),
        Coverage < 39 ~ roll_sum38 + (Coverage - 38) * (roll_sum39 - roll_sum38),
        Coverage < 40 ~ roll_sum39 + (Coverage - 39) * (roll_sum40 - roll_sum39),
        Coverage < 41 ~ roll_sum40 + (Coverage - 40) * (roll_sum41 - roll_sum40),
        TRUE ~ 0
      ) # close case_when
  ) # close mutate




  # A bit of formatting, to display only integers
  df1$Coverage.Volume <- as.numeric(df1$Coverage.Volume)



  #-------------------------------

  # Keep only the needed columns

  #-------------------------------


  df1 <- df1 |> select(
    DFU, Period,

    # Initial variables
    Demand, Coverage,

    # Results
    Coverage.Volume
  )







  #-------------------------------
  # Merge w/ Initial_DB and remove the component random.demand
  # from the Demand
  #-------------------------------

  # keep only the needed columns
  Random_Demand_DB <- Initial_DB |> select(DFU, Period, random.demand)

  # merge both databases
  df1 <- left_join(df1, Random_Demand_DB)

  # remove the component random.demand
  df1$Demand <- df1$Demand - df1$random.demand

  # remove not needed columns
  df1 <- df1 |> select(-random.demand)






  # formatting
  df1 <- as.data.frame(df1)



  #-------------------------------
  # Get Results
  #-------------------------------

  return(df1)
}


