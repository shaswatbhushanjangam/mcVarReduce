test_that("invalid general inputs are rejected", {
  expect_error(
    control_variate(budget = -10),
    "`budget` must be a whole number",
    fixed = TRUE
  )

  expect_error(
    correlation_study(alpha_values = c(0, 1.2)),
    "`alpha_values` must contain numeric values between 0 and 1",
    fixed = TRUE
  )

  expect_error(
    importance_sampling(seed = -1),
    "`seed` must be NULL or a whole number between 0 and .Machine$integer.max",
    fixed = TRUE
  )

  expect_error(
    compare_methods(replications = 1),
    "`replications` must be a whole number greater than or equal to 2",
    fixed = TRUE
  )
})
