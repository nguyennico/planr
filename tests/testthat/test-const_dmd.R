
test_that("const_dmd) returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  # create dataset for the test
  Period <- c("2023-08-20", "2023-08-27", "2023-09-03", "2023-09-10", "2023-09-17", "2023-09-24", "2023-10-01", "2023-10-08", "2023-10-15", "2023-10-22", "2023-10-29",
    "2023-11-05", "2023-11-12", "2023-11-19", "2023-11-26", "2023-12-03", "2023-12-10", "2023-12-17", "2023-12-24","2023-12-31", "2024-01-07", "2024-01-14",
    "2024-01-21", "2024-01-28", "2024-02-04", "2024-02-11", "2024-02-18", "2024-02-25", "2024-03-03", "2024-03-10", "2024-03-17", "2024-03-24", "2024-03-31",
    "2024-04-07", "2024-04-14", "2024-04-21", "2024-04-28", "2024-05-05", "2024-05-12", "2024-05-19", "2024-05-26", "2024-06-02", "2024-06-09", "2024-06-16",
    "2024-06-23", "2024-06-30", "2024-07-07", "2024-07-14", "2024-07-21", "2024-07-28", "2024-08-04", "2024-08-11", "2024-08-18", "2024-08-25", "2024-09-01",
    "2024-09-08", "2024-09-15", "2024-09-22", "2024-09-29", "2024-10-06", "2024-10-13", "2024-10-20", "2024-10-27", "2024-11-03", "2024-11-10", "2024-11-17",
    "2024-11-24", "2024-12-01", "2024-12-08", "2024-12-15", "2024-12-22", "2024-12-29")


  Demand <- c(9240, 6600, 0, 22440, 1320, 6600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4000, 0, 0, 0, 4000, 0, 0, 0, 1362, 0,
    1385, 0, 1403, 0, 0, 4552, 4325, 5085, 5811, 5080, 5459, 5610, 5406, 0, 6155, 0, 1351, 2684, 1394, 0, 1395, 1341, 1341, 1328, 1498,
    2983, 4769, 4829, 5334, 7574, 5879, 0, 5073, 0, 0, 1535, 1614, 1362, 0, 1342, 0, 0, 1363, 0, 0, 0, 0)

  Opening <- c(8000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

  Supply <- c(0, 0, 9330, 21780, 0, 0, 9000, 0, 3540, 0, 0, 0, 0,  1500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 5280, 0, 0, 0, 0, 20100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0)


  # assemble
  input <- data.frame(Period,
                      Demand,
                      Opening,
                      Supply)

  # let's add a Product
  input$DFU <- "Product A"

  # format the Period as a date
  input$Period <- as.Date(as.character(input$Period), format = '%Y-%m-%d')





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the calculated projected coverages
  expected_output_Coverage <- c(0.0,  0.0,  0.1,  0.6,  0.0,  0.0,  8.5,  7.5, 10.4,  9.4,  8.4,  7.4,  6.4,  5.7,  4.7,  3.7,  2.7,  1.7,  0.7,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  3.0,  2.0,  1.0,  0.0,
    0.0,  2.1,  1.1,  0.1,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,
    0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0)


  # expected output for the calculated projected inventories
  expected_output_Inventories <- c(-1240,  -7840,   1490,    830,   -490,  -7090,   1910,   1910,   5450,   5450,   5450,   5450,   5450,   6950,   6950,   2950,   2950,   2950,   2950,  -1050,  -1050,
    -1050,  -1050,  -2412,  -2412,  -3797,   1483,     80,     80,     80,  -4472,  11303,   6218,    407,  -4673, -10132, -15742, -21148, -21148, -27303, -27303, -28654,
    -31338, -32732, -32732, -34127, -35468, -36809, -38137, -39635, -42618, -47387, -52216, -57550, -65124, -71003, -71003, -76076, -76076, -76076, -77611, -79225, -80587,
    -80587, -81929, -81929, -81929, -83292, -83292, -83292, -83292, -83292)

  # expected output for the calculated Constrained.Demand
  expected_output_Constrained.Demand <- c(8000, 0, 7840, 22440, 830, 0, 7090, 0, 0, 0, 0, 0, 0, 0, 0, 4000, 0, 0, 0, 2950, 0, 0, 0, 0, 0,
    0, 3797, 1403, 0, 0, 80, 8797, 5085, 5811, 407, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)



  # expected output for the calculated Current.Stock.Available.Tag
  expected_output_Current.Stock.Available.Tag <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- const_dmd(input)

  # extract the Calculated.Coverage.in.Periods
  output_Coverage <- calculated_dataset$Calculated.Coverage.in.Periods


  # extract the Projected.Inventories.Qty
  output_Inventories <- calculated_dataset$Projected.Inventories.Qty

  # extract the Constrained.Demand
  output_Constrained.Demand <- calculated_dataset$Constrained.Demand

  # extract the Current.Stock.Available.Tag
  output_Current.Stock.Available.Tag <- calculated_dataset$Current.Stock.Available.Tag



  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches the expected result for the Calculated Projected Coverages
  expect_equal(output_Coverage, expected_output_Coverage)


  # Check if the output matches the expected result for the Calculated Projected Inventories
  expect_equal(output_Inventories, expected_output_Inventories)


  # Check if the output matches the expected result for the Constrained.Demand
  expect_equal(output_Constrained.Demand, expected_output_Constrained.Demand)

  # Check if the output matches the expected result for the Current.Stock.Available.Tag
  expect_equal(output_Current.Stock.Available.Tag, expected_output_Current.Stock.Available.Tag)



})

