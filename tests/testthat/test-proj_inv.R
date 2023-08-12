


test_that("proj_inv() returns the expected result", {


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

  # add min & max coverage thresholds
  input$Min.Cov <- 2
  input$Max.Cov <- 4





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the calculated projected coverages
  expected_output_Coverage <- c(2.7, 1.7, 0.7, 0.0, 0.0, 7.4, 6.4, 5.4, 4.4, 3.4, 2.4, 1.4, 0.4, 0.0, 0.0, 5.9, 4.9, 3.9, 2.9, 1.9, 0.9, 0.0, 0.0, 0.0)



  # expected output for the calculated projected inventories
  expected_output_Inventories <- c(950,  492,  192,  -72, -212, 2055, 1826, 1618, 1358, 1022,  727,  501,  165, -269, -545, 1215, 1099,  890,  685,  502,  267,  -45, -315, -516)



  # expected output for the PI.Index
  expected_output_PI.Index <- c("OK", "Alert", "Alert", "Shortage", "Shortage", "OverStock", "OverStock", "OverStock", "OverStock",
                                "OK", "OK", "Alert", "Alert", "Shortage",  "Shortage",  "OverStock", "OverStock", "OK",
                                "OK", "Alert", "Alert", "Shortage", "Shortage", "Shortage")



  # expected output for the Ratio.PI.vs.min
  expected_output_Ratio.PI.vs.min <- c(1.25,  0.87,  0.48, -0.19, -0.46,  4.70,  3.90,  2.71,  2.15,  1.96,  1.29,  0.65,  0.23, -0.52, -1.53,
                                       3.74,  2.65,  2.29,  1.64,  0.92,  0.46, NA, NA, NA)


  # expected output for the Ratio.PI.vs.Max
  expected_output_Ratio.PI.vs.Max <- c(0.82,  0.53,  0.22, -0.09, -0.23,  1.99,  1.66,  1.45,  1.14,  0.79,  0.57,  0.39,
                                       0.15, -0.32, -0.71,  1.70,  1.32,  0.95,  0.69, NA, NA, NA, NA, NA)


  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- proj_inv(input)

  # extract the Calculated.Coverage.in.Periods
  output_Coverage <- calculated_dataset$Calculated.Coverage.in.Periods


  # extract the Projected.Inventories.Qty
  output_Inventories <- calculated_dataset$Projected.Inventories.Qty



  # extract the PI.Index
  output_PI.Index <- calculated_dataset$PI.Index

  # extract the Ratio.PI.vs.min
  output_Ratio.PI.vs.min <- calculated_dataset$Ratio.PI.vs.min

  # extract the Ratio.PI.vs.Max
  output_Ratio.PI.vs.Max <- calculated_dataset$Ratio.PI.vs.Max






  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches the expected result for the Calculated Projected Coverages
  expect_equal(output_Coverage, expected_output_Coverage)


  # Check if the output matches the expected result for the Calculated Projected Inventories
  expect_equal(output_Inventories, expected_output_Inventories)


  # Check if the output matches the expected result for the PI.Index
  expect_equal(output_PI.Index, expected_output_PI.Index)

  # Check if the output matches the expected result for the Ratio.PI.vs.min
  expect_equal(output_Ratio.PI.vs.min, expected_output_Ratio.PI.vs.min)

  # Check if the output matches the expected result for the Ratio.PI.vs.Max
  expect_equal(output_Ratio.PI.vs.Max, expected_output_Ratio.PI.vs.Max)



})



