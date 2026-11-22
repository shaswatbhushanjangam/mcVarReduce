test_that("the three approved methods are returned by the comparison", {
  result <- compare_methods(
    budget = 1000,
    replications = 10,
    alpha = 1,
    pilot_fraction = 0.10,
    seed = 8670
  )

  expect_equal(nrow(result$summary), 3)
  expect_equal(
    result$summary$method,
    c("Control variates", "Antithetic variables", "Importance sampling")
  )
  expect_false(any(grepl("Plain", result$summary$method, fixed = TRUE)))
  expect_true(all(is.finite(result$summary$rmse)))
  expect_true(all(is.finite(result$summary$mean_time_ms)))
})

test_that("the correlation study returns every requested alpha setting", {
  values <- c(0, 0.5, 1)
  result <- correlation_study(
    alpha_values = values,
    budget = 1000,
    replications = 10,
    pilot_fraction = 0.10,
    seed = 8670
  )

  expect_equal(result$summary$alpha, values)
  expect_equal(nrow(result$replications), length(values) * 10)
  expect_equal(result$summary$theoretical_correlation[1], 0,
               tolerance = 1e-12)
  expect_gt(result$summary$theoretical_correlation[3], 0.95)
})

test_that("an odd comparison budget is rejected", {
  expect_error(
    compare_methods(budget = 9999, replications = 10),
    "`budget` must be even",
    fixed = TRUE
  )
})
