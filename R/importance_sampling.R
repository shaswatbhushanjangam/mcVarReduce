importance_sampling <- function(budget = 10000, seed = NULL) {
  .check_positive_integer(budget, "budget", 2L)
  .check_seed(seed)

  if (!is.null(seed)) {
    set.seed(seed)
  }

  # Uniform random numbers are transformed so that draws follow q(x) = 2(1 + x) / 3.
  u <- stats::runif(budget)
  x <- sqrt(1 + 3 * u) - 1

  # The proposal density is evaluated at every generated draw.
  proposal_density <- (2 / 3) * (1 + x)

  # The target contribution is reweighted by the proposal density.
  weighted_output <- exp(x) / proposal_density

  estimate <- mean(weighted_output)
  mcse <- stats::sd(weighted_output) / sqrt(budget)
  truth <- .true_value()

  list(
    method = "Importance sampling",
    estimate = estimate,
    true_value = truth,
    error = estimate - truth,
    absolute_error = abs(estimate - truth),
    mcse = mcse,
    contribution_variance = stats::var(weighted_output),
    budget = budget,
    proposal = "q(x) = 2(1 + x) / 3 on [0, 1]"
  )
}
