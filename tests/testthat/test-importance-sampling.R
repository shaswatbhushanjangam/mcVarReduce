test_that("the importance-sampling estimator agrees with the known target", {
  result <- importance_sampling(budget = 10000, seed = 8670)

  expect_lt(abs(result$estimate - result$true_value), 0.02)
  expect_equal(result$true_value, exp(1) - 1, tolerance = 1e-12)
  expect_true(is.finite(result$mcse))
  expect_gt(result$contribution_variance, 0)
  expect_equal(result$proposal, "q(x) = 2(1 + x) / 3 on [0, 1]")
})

test_that("an invalid importance-sampling budget is rejected", {
  expect_error(
    importance_sampling(budget = 1),
    "`budget` must be a whole number greater than or equal to 2",
    fixed = TRUE
  )
})
