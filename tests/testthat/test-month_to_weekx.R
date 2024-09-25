
test_that("month_to_weekx() returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  # Create a vector of Monthly Period
  Period <- c("2023-06-01", "2023-07-01", "2023-08-01")


  # Create a vector of Demand
  Demand <- c(1000, 2000, 1000)


  # assemble
  input <- data.frame(Period,
                      Demand)

  # let's add a Product
  input$DFU <- "Product A"

  # format the Period as a date
  input$Period <- as.Date(as.character(input$Period), format = '%Y-%m-%d')


  # define weekly distribution values
  input$W1 <- 0.75
  input$W2 <- 0.15
  input$W3 <- 0.05
  input$W4 <- 0.05





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the Period in weekly bucket
  expected_output_Period <- c("2023-05-28", "2023-06-04", "2023-06-11", "2023-06-18", "2023-06-25", "2023-07-02", "2023-07-09",
                              "2023-07-16", "2023-07-23", "2023-07-30", "2023-08-06","2023-08-13", "2023-08-20", "2023-08-27")


  # format as date
  expected_output_Period <- as.Date(as.character(expected_output_Period), format = '%Y-%m-%d')

  # expected output for the Demand split into weekly buckets
  expected_output_Demand <- c(321.42857,  492.85714,  107.14286,   50.00000,
                              242.85714, 1328.57143,  271.42857,  100.00000,
                              85.71429,  535.71429,  321.42857,   78.57143,
                              50.00000, 14.28571)


  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- month_to_weekx(input)

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
