
test_that("proj_git() returns the expected result", {


  #--------------------------------
  # Input values for the test
  #--------------------------------

  # create dataset for the test
  Period <- c(
    "2/18/2024", "2/25/2024", "3/3/2024", "3/10/2024", "3/17/2024", "3/24/2024",
    "3/31/2024", "4/7/2024", "4/14/2024", "4/21/2024", "4/28/2024", "5/5/2024",
    "5/12/2024", "5/19/2024", "5/26/2024", "6/2/2024", "6/9/2024", "6/16/2024",
    "6/23/2024", "6/30/2024", "7/7/2024", "7/14/2024", "7/21/2024", "7/28/2024")

  ETA.Current <- c(0, 1008,0, 252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

  ETA.Next <- c(0, 0,0,0,0, 0,0,0,0, 500,0,0,0, 800,0,0,0, 600,0,0,0,0,0,0)

  ETD.Next <- c(0, 500,0,0,0, 800,0,0,0, 600,0,0,0,0,0,0,0,0,0,0,0,0,0,0)


  # assemble
  input <- data.frame(Period,
                      ETA.Current,
                      ETA.Next,
                      ETD.Next)

  # let's add a DFU (Demand Forecasts Unit), which stands for Location x Product
  input$DFU <- "Entity1_Product A"

  # let's add a TLT (Transit Lead Time)
  input$TLT <- 8

  # format the Period as a date
  input$Period <- as.Date(as.character(input$Period), format = '%m/%d/%Y')





  #--------------------------------
  # Expected outputs
  #--------------------------------

  # expected output for the Proj.GIT
  expected_output_Proj.GIT <- c(1260,  752,  752,  500,  500, 1300, 1300, 1300, 1300, 1400, 1400, 1400, 1400,
    600,  600,  600,  600,    0,    0, 0,    0,    0,    0,    0)


  # expected output for the Proj.Current.GIT
  expected_output_Proj.Current.GIT  <- c(1260, 252, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                         0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0)


  # expected output for the Proj.Future.GIT
  expected_output_Proj.Future.GIT <- c(0,  500,  500,  500,  500, 1300, 1300, 1300, 1300, 1400, 1400, 1400, 1400,
                                600,  600,  600,  600,    0,    0, 0,    0,    0,    0,    0)


  # expected output for the ETD.Current
  expected_output_ETD.Current <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                         0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0)


  #--------------------------------
  # Run function
  #--------------------------------


  # Call the function
  calculated_dataset <- proj_git(input)


  # extract the Proj.GIT
  output_Proj.GIT <- calculated_dataset$Proj.GIT

  # extract the Proj.Current.GIT
  output_Proj.Current.GIT <- calculated_dataset$Proj.Current.GIT

  # extract the Proj.Future.GIT
  output_Proj.Future.GIT <- calculated_dataset$Proj.Future.GIT

  # extract the ETD.Current
  output_ETD.Current <- calculated_dataset$ETD.Current




  #--------------------------------
  # Run Checks
  #--------------------------------


  # Check if the output matches the expected result for the Proj.GIT
  expect_equal(output_Proj.GIT, expected_output_Proj.GIT)


  # Check if the output matches the expected result for the Proj.Current.GIT
  expect_equal(output_Proj.Current.GIT, expected_output_Proj.Current.GIT)


  # Check if the output matches the expected result for the Proj.Future.GIT
  expect_equal(output_Proj.Future.GIT, expected_output_Proj.Future.GIT)

  # Check if the output matches the expected result for the ETD.Current
  expect_equal(output_ETD.Current, expected_output_ETD.Current)

})


