control_variate <- function(budget = 10000,
                              alpha = 1,
                              pilot_fraction = 0.10,
                              seed = NULL) {
  .check_positive_integer(budget, "budget", 4L)
  .check_alpha(alpha)
  .check_pilot_fraction(pilot_fraction)
  .check_seed(seed)

  n_pilot <- max(2L, as.integer(floor(budget * pilot_fraction)))
  n_main <- budget - n_pilot

  if (n_main < 2L) {
    stop(
      paste0(
        "The selected `budget` and `pilot_fraction` must leave at least ",
        "two observations for the main simulation."
      ),
      call. = FALSE
    )
  }

  if (!is.null(seed)) {
    set.seed(seed)
  }

  # An independent pilot sample is generated so that the coefficient can be estimated first.
  u_pilot <- stats::runif(n_pilot)
  v_pilot <- stats::runif(n_pilot)
  y_pilot <- exp(u_pilot)
  c_pilot <- alpha * u_pilot + (1 - alpha) * v_pilot

  # The control variance is checked before the coefficient is calculated.
  control_variance <- stats::var(c_pilot)
  if (!is.finite(control_variance) ||
      control_variance <= .Machine$double.eps) {
    stop(
      paste0(
        "The pilot control variable has insufficient variation for a ",
        "coefficient to be estimated."
      ),
      call. = FALSE
    )
  }

  # The variance-minimizing control coefficient is estimated from the pilot sample.
  coefficient <- -stats::cov(c_pilot, y_pilot) / control_variance

  # A separate main sample is generated so that the estimated coefficient is held fixed.
  u_main <- stats::runif(n_main)
  v_main <- stats::runif(n_main)
  y_main <- exp(u_main)
  c_main <- alpha * u_main + (1 - alpha) * v_main

  # The known control mean of 0.5 is used in the adjustment.
  adjusted <- y_main + coefficient * (c_main - 0.5)

  estimate <- mean(adjusted)
  mcse <- stats::sd(adjusted) / sqrt(n_main)
  correlation <- stats::cor(y_main, c_main)
  truth <- .true_value()

  list(
    method = "Control variates",
    estimate = estimate,
    true_value = truth,
    error = estimate - truth,
    absolute_error = abs(estimate - truth),
    mcse = mcse,
    contribution_variance = stats::var(adjusted),
    correlation = correlation,
    theoretical_correlation = .control_correlation_theoretical(alpha),
    coefficient = coefficient,
    theoretical_coefficient = .control_coefficient_theoretical(alpha),
    alpha = alpha,
    control_mean = 0.5,
    pilot_size = n_pilot,
    main_size = n_main,
    budget = budget
  )
}
