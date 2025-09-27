


test_that("alloc_dmd) returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  DFU <- c(rep("item 1", 17))

  Period <- c("2023-07-01", "2023-08-01", "2023-09-01", "2023-10-01", "2023-11-01", "2023-12-01", "2024-01-01", "2024-02-01", "2024-03-01", "2024-04-01", "2024-05-01",
              "2024-06-01", "2024-07-01", "2024-08-01", "2024-09-01", "2024-10-01", "2024-11-01")

  Dist1 <- c(10664,  5099,  4363,  2538,  1588,  2172,  2685,  2413,  3076,  2326,  3563,  6706,  3376,  4533,     0,     0,     0)

  Dist2 <- c(0, 1230, 1330,  945,  457,  537,  504,  475,  500,  483,  852,  760,  553, 1013, 1219,    0,    0)

  Dist3 <- c(2580, 1505, 1635, 1168,  635,  967,  658,  647,  461,  974, 1566, 1026,  871, 1742,    0,    0,    0)

  Dist4 <- c(359,  548,  603,  291,  592, 1239,  607,  594,  558,  438,  449,  575,  881,  602,    0,    0,    0)

  Dist5 <- c(1411,  419,  302,  303,  360,  326,  365,  462,  228,  380,  497,  766,  425,    0,    0,    0,    0)


  Demand <- c(15014,  8801,  8233,  5245,  3632,  5241,  4819,  4591,  4823,  4601,  6927,  9833,  6106,  7890,  1219,     0,     0)


  Opening <- c(20000,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0)


  Supply <- c(4000,  1000,     0, 17000,     0,   500, 10000,  5000,     0,     0, 20000, 10000,     0, 10000,     0,     0,     0)



  # create the dataframe
  input <- data.frame(DFU,
                    Period,
                    Dist1,
                    Dist2,
                    Dist3,
                    Dist4,
                    Dist5,
                    Demand,
                    Opening,
                    Supply)

  # format the Period as a date
  input$Period <- as.Date(input$Period, format = "%Y-%m-%d")





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # Dist 1
  expected_output_Dist1 <- c(10664.0000,  5099.0000,   627.9795,  6273.0205,  1588.0000,   652.7189,  4204.2811, 2413.0000,  1227.0836,  4174.9164,  3563.0000,  6706.0000,  3173.6390,  4735.3610,
                             0.0000,     0.0000,     0.0000)

  # Dist 2
  expected_output_Dist2 <- c(0.0000, 1230.0000,  191.4308272, 2083.5691728,  457.0000,  161.3766457,
                             879.6233543,
                             475.0000,  199.4609164,  783.5390836,  852.0000,  760.0000,  519.8526, 1046.1474,
                             1219.0000,    0.0000,    0.0000)


  # Dist 3
  expected_output_Dist3 <- c(2580.0000, 1505.0000,  235.330378, 2567.669622,  635.0000,
                             290.598168, 1334.401832,
                             647.0000,  183.902965, 1251.097035, 1566.0000, 1026.0000,  818.7914, 1794.2086,
                             0.0000,    0.0000,    0.0000)

  # Dist 4
  expected_output_Dist4 <- c(359.00000,  548.00000,   86.79157,  807.20843,  592.00000,  372.33829, 1473.66171,
                             594.00000,  222.59838,  773.40162,  449.00000,  575.00000,  828.19194,  654.80806,
                             0.00000,    0.00000,    0.00000)

  # Dist 5
  expected_output_Dist5 <- c(1411.00000,  419.00000,   43.46775,  561.53225,  360.00000,   97.96795,  593.03205,
                             462.00000,   90.95418,  517.04582,  497.00000,  766.00000,  399.52506,   25.47494,
                             0.00000,    0.00000,    0.00000)

  # Demand
  expected_output_Demand <- c(15014,  8801,  1185, 12293,  3632,  1575,  8485,  4591,  1924,  7500,  6927,  9833,  5740, 8256,  1219,     0,     0)






  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- alloc_dmd(input)


  #--------------------------------
  # Get outputs
  #--------------------------------

  # extract the outputs
  output_Dist1 <- calculated_dataset$Dist1
  output_Dist2 <- calculated_dataset$Dist2
  output_Dist3 <- calculated_dataset$Dist3
  output_Dist4 <- calculated_dataset$Dist4
  output_Dist5 <- calculated_dataset$Dist5
  output_Demand <- calculated_dataset$Demand



  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches for each receiving entities and the total demand
  expect_equal(output_Dist1, expected_output_Dist1)

  expect_equal(output_Dist2, expected_output_Dist2)

  expect_equal(output_Dist3, expected_output_Dist3)

  expect_equal(output_Dist4, expected_output_Dist4)

  expect_equal(output_Dist5, expected_output_Dist5)

  expect_equal(output_Demand, expected_output_Demand)



})



