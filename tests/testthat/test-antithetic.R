test_that("the antithetic estimator agrees with the known target", {
  result <- antithetic_estimate(budget = 10000, seed = 8670)

  expect_lt(abs(result$estimate - result$true_value), 0.02)
  expect_equal(result$true_value, exp(1) - 1, tolerance = 1e-12)
  expect_lt(result$pair_correlation, 0)
  expect_lt(
    abs(result$pair_correlation - result$theoretical_pair_correlation),
    0.05
  )
  expect_equal(result$pairs, 5000)
})

test_that("an odd antithetic budget is rejected", {
  expect_error(
    antithetic_estimate(budget = 9999, seed = 8670),
    "`budget` must be even",
    fixed = TRUE
  )
})
