test_that("a strongly correlated control agrees with known theory", {
  result <- control_variate(
    budget = 30000,
    alpha = 1,
    pilot_fraction = 0.20,
    seed = 8670
  )

  expect_lt(abs(result$estimate - result$true_value), 0.02)
  expect_equal(result$true_value, exp(1) - 1, tolerance = 1e-12)
  expect_equal(result$theoretical_coefficient, 6 * exp(1) - 18,
               tolerance = 1e-12)
  expect_gt(result$correlation, 0.95)
  expect_lt(abs(result$correlation - result$theoretical_correlation), 0.03)
  expect_lt(abs(result$coefficient - result$theoretical_coefficient), 0.10)
  expect_equal(result$pilot_size + result$main_size, result$budget)
})

test_that("an uninformative control is handled as an edge case", {
  result <- control_variate(
    budget = 20000,
    alpha = 0,
    pilot_fraction = 0.10,
    seed = 8670
  )

  expect_true(is.finite(result$estimate))
  expect_lt(abs(result$estimate - result$true_value), 0.05)
  expect_equal(result$theoretical_correlation, 0, tolerance = 1e-12)
  expect_equal(result$theoretical_coefficient, 0, tolerance = 1e-12)
  expect_lt(abs(result$correlation), 0.15)
})

test_that("invalid control-variate inputs are rejected", {
  expect_error(
    control_variate(alpha = 1.5),
    "`alpha` must be a numeric value between 0 and 1",
    fixed = TRUE
  )

  expect_error(
    control_variate(pilot_fraction = 1),
    "`pilot_fraction` must be a numeric value greater than 0 and less than 1",
    fixed = TRUE
  )

  expect_error(
    control_variate(budget = 4, pilot_fraction = 0.75),
    "must leave at least two observations",
    fixed = TRUE
  )
})
