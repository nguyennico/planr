
test_that("ssl() returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  # create dataset for the test

  DFU <- c(rep("Item 1", 24))

  Period <- c(
    "1/1/2023", "2/1/2023", "3/1/2023", "4/1/2023", "5/1/2023", "6/1/2023", "7/1/2023", "8/1/2023", "9/1/2023", "10/1/2023", "11/1/2023", "12/1/2023",
    "1/1/2024", "2/1/2024", "3/1/2024", "4/1/2024", "5/1/2024", "6/1/2024", "7/1/2024", "8/1/2024", "9/1/2024", "10/1/2024", "11/1/2024", "12/1/2024")

  Demand <- c(rep(200, 24))

  Opening <- c(0,0,1000,0,0,0,1000,0,0,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0)


  # assemble
  input <- data.frame(DFU,
                      Period,
                      Demand,
                      Opening)

  # format the Period as a date
  input$Period <- as.Date(as.character(input$Period), format = '%m/%d/%Y')





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the calculated SSL Qty
  expected_output_SSL <- c(0, 0, 400, 0, 0, 0, 200, 0, 0, 400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)




  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- ssl(input)

  # extract the SSL Qty
  output_SSL <- calculated_dataset$SSL.Qty




  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches the expected result for the Calculated Projected Coverages
  expect_equal(output_SSL, expected_output_SSL)




})

