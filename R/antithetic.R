antithetic_estimate <- function(budget = 10000, seed = NULL) {
  .check_positive_integer(budget, "budget", 4L)
  .check_seed(seed)

  if (budget %% 2L != 0L) {
    stop(
      paste0(
        "`budget` must be even because two target-function evaluations ",
        "are used for each antithetic pair."
      ),
      call. = FALSE
    )
  }

  if (!is.null(seed)) {
    set.seed(seed)
  }

  n_pairs <- budget %/% 2L

  # Uniform inputs are generated and are paired with their reflected values.
  u <- stats::runif(n_pairs)
  first_output <- exp(u)
  second_output <- exp(1 - u)

  # A pair average is formed so that negatively related fluctuations can be reduced.
  pair_average <- (first_output + second_output) / 2

  estimate <- mean(pair_average)
  mcse <- stats::sd(pair_average) / sqrt(n_pairs)
  truth <- .true_value()

  list(
    method = "Antithetic variables",
    estimate = estimate,
    true_value = truth,
    error = estimate - truth,
    absolute_error = abs(estimate - truth),
    mcse = mcse,
    contribution_variance = stats::var(pair_average),
    pair_correlation = stats::cor(first_output, second_output),
    theoretical_pair_correlation = .antithetic_correlation_theoretical(),
    pairs = n_pairs,
    budget = budget
  )
}
