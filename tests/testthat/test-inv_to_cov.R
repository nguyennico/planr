

test_that("inv_to_cov() returns the expected result", {

  # test performed:
  # Calculated.Coverage.in.Periods is correct for the 1st 3 months of Product_B



  #--------------------------------
  # Input values for the test
  #--------------------------------


  # 1. Generate dataset (keep Period directly as Date class)
  DFU <- c("Product_A", "Product_B", "Product_C")
  Period <- seq(as.Date("2026-09-01"), by = "month", length.out = 24)

  set.seed(42)
  input <- crossing(DFU, Period) |>
    mutate(
      Inventories = sample(100:300, n(), replace = TRUE),
      Demand = sample(50:200, n(), replace = TRUE)
    )


  # formatting
  input <- as.data.frame(input)






  #--------------------------------
  # Run function
  #--------------------------------


  # 2. Execute planr::inv_to_cov()
  result <- inv_to_cov(input)


  # 3. Extract 3 first rows for Product_B (sorted by ascending date)
  prod_b_results <- result |>
    filter(DFU == "Product_B") |>
    arrange(Period) |>
    head(3)

  # 4. Define expected values
  expected_values <- c(1.5, 0.7, 1.7)

  # 5. test of equality of testthat
  expect_equal(
    prod_b_results$Calculated.Coverage.in.Periods,
    expected_values,
    tolerance = 1e-4 # to avoid micro differences
  )



})
