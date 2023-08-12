
test_that("light_proj_inv() returns the expected result", {


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





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the calculated projected coverages
  expected_output_Coverage <- c(2.7, 1.7, 0.7, 0.0, 0.0, 7.4, 6.4, 5.4, 4.4, 3.4, 2.4, 1.4, 0.4, 0.0, 0.0, 5.9, 4.9, 3.9, 2.9, 1.9, 0.9, 0.0, 0.0, 0.0)



  # expected output for the calculated projected inventories
  expected_output_Inventories <- c(950,  492,  192,  -72, -212, 2055, 1826, 1618, 1358, 1022,  727,  501,  165, -269, -545, 1215, 1099,  890,  685,  502,  267,  -45, -315, -516)




  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- light_proj_inv(input)

  # extract the Calculated.Coverage.in.Periods
  output_Coverage <- calculated_dataset$Calculated.Coverage.in.Periods


  # extract the Projected.Inventories.Qty
  output_Inventories <- calculated_dataset$Projected.Inventories.Qty





  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches the expected result for the Calculated Projected Coverages
  expect_equal(output_Coverage, expected_output_Coverage)


  # Check if the output matches the expected result for the Calculated Projected Inventories
  expect_equal(output_Inventories, expected_output_Inventories)



})

