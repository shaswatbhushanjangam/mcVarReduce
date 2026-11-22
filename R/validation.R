.check_positive_integer <- function(x, name, minimum = 1L) {
  if (length(x) != 1L || is.na(x) || !is.numeric(x) ||
      !is.finite(x) || x < minimum || x != floor(x)) {
    stop(
      sprintf(
        "`%s` must be a whole number greater than or equal to %d.",
        name,
        minimum
      ),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

.check_seed <- function(seed) {
  if (is.null(seed)) {
    return(invisible(TRUE))
  }

  if (length(seed) != 1L || is.na(seed) || !is.numeric(seed) ||
      !is.finite(seed) || seed < 0 || seed != floor(seed) ||
      seed > .Machine$integer.max) {
    stop(
      "`seed` must be NULL or a whole number between 0 and .Machine$integer.max.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

.check_alpha <- function(alpha) {
  if (length(alpha) != 1L || is.na(alpha) || !is.numeric(alpha) ||
      !is.finite(alpha) || alpha < 0 || alpha > 1) {
    stop("`alpha` must be a numeric value between 0 and 1.", call. = FALSE)
  }
  invisible(TRUE)
}

.check_alpha_values <- function(alpha_values) {
  if (!is.numeric(alpha_values) || length(alpha_values) < 1L ||
      anyNA(alpha_values) || any(!is.finite(alpha_values)) ||
      any(alpha_values < 0 | alpha_values > 1)) {
    stop(
      "`alpha_values` must contain numeric values between 0 and 1.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

.check_pilot_fraction <- function(pilot_fraction) {
  if (length(pilot_fraction) != 1L || is.na(pilot_fraction) ||
      !is.numeric(pilot_fraction) || !is.finite(pilot_fraction) ||
      pilot_fraction <= 0 || pilot_fraction >= 1) {
    stop(
      "`pilot_fraction` must be a numeric value greater than 0 and less than 1.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

.true_value <- function() {
  exp(1) - 1
}

.target_variance <- function() {
  ((exp(2) - 1) / 2) - (exp(1) - 1)^2
}

.cov_u_target <- function() {
  1 - (exp(1) - 1) / 2
}

.control_variance_theoretical <- function(alpha) {
  (alpha^2 + (1 - alpha)^2) / 12
}

.control_covariance_theoretical <- function(alpha) {
  alpha * .cov_u_target()
}

.control_coefficient_theoretical <- function(alpha) {
  -.control_covariance_theoretical(alpha) /
    .control_variance_theoretical(alpha)
}

.control_correlation_theoretical <- function(alpha) {
  covariance <- .control_covariance_theoretical(alpha)
  denominator <- sqrt(
    .target_variance() * .control_variance_theoretical(alpha)
  )
  covariance / denominator
}

.antithetic_covariance_theoretical <- function() {
  exp(1) - (exp(1) - 1)^2
}

.antithetic_correlation_theoretical <- function() {
  .antithetic_covariance_theoretical() / .target_variance()
}

.make_method_seeds <- function(n, seed) {
  .check_positive_integer(n, "n", 1L)
  .check_seed(seed)

  if (is.null(seed)) {
    return(rep(NA_integer_, n))
  }

  set.seed(seed)
  sample.int(.Machine$integer.max, size = n, replace = FALSE)
}

.seed_or_null <- function(x) {
  if (is.na(x)) {
    NULL
  } else {
    x
  }
}

.measure_call <- function(fun) {
  start_time <- proc.time()[["elapsed"]]
  value <- fun()
  elapsed_time <- proc.time()[["elapsed"]] - start_time
  list(value = value, elapsed = elapsed_time)
}
