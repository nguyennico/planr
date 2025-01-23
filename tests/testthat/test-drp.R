

test_that("drp() returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  # create dataset for the test
  Period <- c(
    "1/1/2020", "2/1/2020", "3/1/2020", "4/1/2020", "5/1/2020", "6/1/2020", "7/1/2020", "8/1/2020", "9/1/2020", "10/1/2020", "11/1/2020", "12/1/2020","1/1/2021", "2/1/2021", "3/1/2021", "4/1/2021", "5/1/2021", "6/1/2021", "7/1/2021", "8/1/2021", "9/1/2021", "10/1/2021", "11/1/2021", "12/1/2021")

  Demand <- c(360, 458,300,264,140,233,229,208,260,336,295,226,336,434,276,240,116,209,205,183,235,312,270,201)

  Opening <- c(1310,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

  Supply <- c(0,0,0,0,0,2500,0,0,0,0,0,0,0,0,0,2000,0,0,0,0,0,0,0,0)


  # assemble
  input <- data.frame(Period,
                      Demand,
                      Opening,
                      Supply)

  # let's add a Product
  input$DFU <- "Product A"

  # format the Period as a date
  input$Period <- as.Date(as.character(input$Period), format = '%m/%d/%Y')


  # add DRP parameters
  input$SSCov <- 2
  input$DRPCovDur <- 3
  input$MOQ <- 1
  input$FH <- c("Frozen", "Frozen", "Frozen", "Frozen","Frozen","Frozen","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free","Free")






  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the Safety.Stocks
  expected_output_Safety.Stocks <- c(758, 564, 404, 373, 462, 437, 468, 596, 631, 521, 562, 770, 710, 516, 356, 325, 414, 388, 418, 547, 582,  NA, NA,  NA)


  # expected output for the Maximum.Stocks
  expected_output_Maximum.Stocks <- c(1395, 1166, 1074, 1070, 1266, 1328, 1325, 1453, 1627, 1567, 1512, 1402, 1275, 1046,  953,  948, 1144, 1205, NA, NA, NA, NA, NA, NA)





  # expected output for the calculated projected coverages
  expected_output_Coverage <- c(2.7,  1.7,  0.7, 0, 0,  7.4,  6.4,  5.4,  4.4,  3.4,  2.4,  5.0,  4.0,  3.0,  5.0,  4.0,  3.0,  5.0,  4.0,  3.0,  NA,  NA,  NA,  NA)


  # expected output for the calculated projected inventories
  expected_output_Inventories <- c(950,  492,  192,  -72, -212, 2055, 1826, 1618, 1358, 1022,  727, 1402, 1066,  632,  953,  713,  597, 1205, 1000,  817, NA,  NA,  NA, NA)


  # expected output for the DRP.plan
  expected_output_DRP.plan <- c(0, 0, 0, 0, 0, 2500, 0,  0, 0, 0, 0, 901, 0, 0,  597, 0, 0,  817, 0, 0, NA, 0, 0, 0)




  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- drp(input)

  # extract the Safety.Stocks
  output_Safety.Stocks <- calculated_dataset$Safety.Stocks

  # extract the Maximum.Stocks
  output_Maximum.Stocks <- calculated_dataset$Maximum.Stocks


  # extract the Calculated.Coverage.in.Periods
  output_Coverage <- calculated_dataset$DRP.Calculated.Coverage.in.Periods


  # extract the Projected.Inventories.Qty
  output_Inventories <- calculated_dataset$DRP.Projected.Inventories.Qty


  # extract the DRP.plan
  output_DRP.plan <- calculated_dataset$DRP.plan


  #--------------------------------
  # Run Checks
  #--------------------------------

  # Check if the output matches the expected result for the Safety.Stocks
  expect_equal(output_Safety.Stocks, expected_output_Safety.Stocks)

  # Check if the output matches the expected result for the Maximum.Stocks
  expect_equal(output_Maximum.Stocks, expected_output_Maximum.Stocks)


  # Check if the output matches the expected result for the Calculated Projected Coverages
  expect_equal(output_Coverage, expected_output_Coverage)


  # Check if the output matches the expected result for the Calculated Projected Inventories
  expect_equal(output_Inventories, expected_output_Inventories)

  # Check if the output matches the expected result for the DRP.plan
  expect_equal(output_DRP.plan, expected_output_DRP.plan)



})




