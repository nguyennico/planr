
test_that("month_to_week() returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  # Create a vector of Monthly Period
  Period <- c("2023-01-01", "2023-02-01", "2023-03-01",
              "2023-04-01", "2023-05-01", "2023-06-01",
              "2023-07-01", "2023-08-01", "2023-09-01",
              "2023-10-01", "2023-11-01", "2023-12-01")


  # Create a vector of Demand
  Demand <- c(1000, 1000, 2000, 1000, 1000, 2000, 1000, 1000, 2000, 1000, 1000, 2000)


  # assemble
  input <- data.frame(Period,
                      Demand)

  # let's add a Product
  input$DFU <- "Product A"

  # format the Period as a date
  input$Period <- as.Date(as.character(input$Period), format = '%Y-%m-%d')







  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the Period in weekly bucket
  expected_output_Period <- c("2023-01-01", "2023-01-08", "2023-01-15", "2023-01-22", "2023-01-29", "2023-02-05", "2023-02-12", "2023-02-19", "2023-02-26", "2023-03-05", "2023-03-12",
    "2023-03-19", "2023-03-26", "2023-04-02", "2023-04-09", "2023-04-16", "2023-04-23", "2023-04-30", "2023-05-07", "2023-05-14", "2023-05-21", "2023-05-28",
    "2023-06-04", "2023-06-11", "2023-06-18", "2023-06-25", "2023-07-02", "2023-07-09", "2023-07-16", "2023-07-23", "2023-07-30", "2023-08-06", "2023-08-13",
    "2023-08-20", "2023-08-27", "2023-09-03", "2023-09-10", "2023-09-17", "2023-09-24", "2023-10-01", "2023-10-08", "2023-10-15", "2023-10-22", "2023-10-29",
    "2023-11-05", "2023-11-12", "2023-11-19", "2023-11-26", "2023-12-03", "2023-12-10", "2023-12-17", "2023-12-24")


  # format as date
  expected_output_Period <- as.Date(as.character(expected_output_Period), format = '%Y-%m-%d')

  # expected output for the Demand split into weekly buckets
  expected_output_Demand <- c(250.00000, 250.00000, 250.00000, 250.00000, 142.85714, 250.00000, 250.00000, 250.00000, 392.85714, 500.00000, 500.00000, 500.00000, 250.00000, 250.00000, 250.00000,
    250.00000, 214.28571, 214.28571, 250.00000, 250.00000, 250.00000, 250.00000, 500.00000, 500.00000, 500.00000, 321.42857, 250.00000, 250.00000, 250.00000, 214.28571,
    178.57143, 250.00000, 250.00000, 250.00000, 214.28571, 500.00000, 500.00000, 500.00000, 357.14286, 250.00000, 250.00000, 250.00000, 250.00000, 142.85714, 250.00000,
    250.00000, 250.00000, 250.00000, 500.00000, 500.00000, 500.00000, 357.14286)


  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- month_to_week(input)

  # extract the Period
  output_Period <- calculated_dataset$Period


  # extract the Demand
  output_Demand <- calculated_dataset$Demand





  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches the expected result for the Period
  expect_equal(output_Period, expected_output_Period)


  # Check if the output matches the expected result for the Demand
  expect_equal(output_Demand, expected_output_Demand)



})
