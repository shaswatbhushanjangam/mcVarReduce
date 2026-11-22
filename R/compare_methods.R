.summarise_method <- function(method_name,
                              estimates,
                              mcses,
                              mean_time_seconds,
                              truth) {
  data.frame(
    method = method_name,
    mean_estimate = mean(estimates),
    bias = mean(estimates) - truth,
    empirical_variance = stats::var(estimates),
    empirical_sd = stats::sd(estimates),
    rmse = sqrt(mean((estimates - truth)^2)),
    mae = mean(abs(estimates - truth)),
    average_mcse = mean(mcses),
    mean_time_ms = mean_time_seconds * 1000,
    stringsAsFactors = FALSE
  )
}

.run_repeated_estimator <- function(replications, seeds, estimator) {
  estimates <- numeric(replications)
  mcses <- numeric(replications)

  # The complete replication block is timed so that very short individual runs are measured more stably.
  start_time <- proc.time()[["elapsed"]]

  for (i in seq_len(replications)) {
    result <- estimator(.seed_or_null(seeds[i]))
    estimates[i] <- result$estimate
    mcses[i] <- result$mcse
  }

  elapsed <- proc.time()[["elapsed"]] - start_time

  list(
    estimates = estimates,
    mcses = mcses,
    mean_time_seconds = elapsed / replications
  )
}

compare_methods <- function(budget = 10000,
                            replications = 500,
                            alpha = 1,
                            pilot_fraction = 0.10,
                            seed = 8670) {
  .check_positive_integer(budget, "budget", 4L)
  .check_positive_integer(replications, "replications", 2L)
  .check_alpha(alpha)
  .check_pilot_fraction(pilot_fraction)
  .check_seed(seed)

  if (budget %% 2L != 0L) {
    stop(
      paste0(
        "`budget` must be even so that the antithetic method can use ",
        "the same target-function budget."
      ),
      call. = FALSE
    )
  }

  method_seeds <- .make_method_seeds(replications * 3L, seed)
  method_seeds <- matrix(method_seeds, nrow = replications, ncol = 3L)

  # The control-variate replications are completed under the fixed total evaluation budget.
  cv_runs <- .run_repeated_estimator(
    replications,
    method_seeds[, 1L],
    function(current_seed) {
      control_variate(
        budget = budget,
        alpha = alpha,
        pilot_fraction = pilot_fraction,
        seed = current_seed
      )
    }
  )

  # The antithetic replications are completed under the same target-function evaluation budget.
  anti_runs <- .run_repeated_estimator(
    replications,
    method_seeds[, 2L],
    function(current_seed) {
      antithetic_estimate(
        budget = budget,
        seed = current_seed
      )
    }
  )

  # The importance-sampling replications are completed under the same target-function evaluation budget.
  is_runs <- .run_repeated_estimator(
    replications,
    method_seeds[, 3L],
    function(current_seed) {
      importance_sampling(
        budget = budget,
        seed = current_seed
      )
    }
  )

  truth <- .true_value()

  summary <- rbind(
    .summarise_method(
      "Control variates",
      cv_runs$estimates,
      cv_runs$mcses,
      cv_runs$mean_time_seconds,
      truth
    ),
    .summarise_method(
      "Antithetic variables",
      anti_runs$estimates,
      anti_runs$mcses,
      anti_runs$mean_time_seconds,
      truth
    ),
    .summarise_method(
      "Importance sampling",
      is_runs$estimates,
      is_runs$mcses,
      is_runs$mean_time_seconds,
      truth
    )
  )
  rownames(summary) <- NULL

  replications_table <- data.frame(
    replication = seq_len(replications),
    control_variate = cv_runs$estimates,
    antithetic = anti_runs$estimates,
    importance_sampling = is_runs$estimates,
    stringsAsFactors = FALSE
  )

  list(
    summary = summary,
    replications = replications_table,
    settings = list(
      true_value = truth,
      budget = budget,
      replications = replications,
      alpha = alpha,
      pilot_fraction = pilot_fraction,
      seed = seed
    )
  )
}

correlation_study <- function(alpha_values = c(0, 0.10, 0.25, 0.50, 0.75, 1),
                              budget = 10000,
                              replications = 500,
                              pilot_fraction = 0.10,
                              seed = 8670) {
  .check_alpha_values(alpha_values)
  .check_positive_integer(budget, "budget", 4L)
  .check_positive_integer(replications, "replications", 2L)
  .check_pilot_fraction(pilot_fraction)
  .check_seed(seed)

  total_runs <- length(alpha_values) * replications
  run_seeds <- .make_method_seeds(total_runs, seed)

  raw_results <- data.frame(
    alpha = numeric(total_runs),
    replication = integer(total_runs),
    correlation = numeric(total_runs),
    theoretical_correlation = numeric(total_runs),
    coefficient = numeric(total_runs),
    theoretical_coefficient = numeric(total_runs),
    estimate = numeric(total_runs),
    mcse = numeric(total_runs),
    elapsed_seconds = numeric(total_runs),
    stringsAsFactors = FALSE
  )

  row_index <- 1L

  # The control-variate method is repeated across all selected correlation settings.
  for (alpha in alpha_values) {
    for (i in seq_len(replications)) {
      run <- .measure_call(function() {
        control_variate(
          budget = budget,
          alpha = alpha,
          pilot_fraction = pilot_fraction,
          seed = .seed_or_null(run_seeds[row_index])
        )
      })

      raw_results$alpha[row_index] <- alpha
      raw_results$replication[row_index] <- i
      raw_results$correlation[row_index] <- run$value$correlation
      raw_results$theoretical_correlation[row_index] <-
        run$value$theoretical_correlation
      raw_results$coefficient[row_index] <- run$value$coefficient
      raw_results$theoretical_coefficient[row_index] <-
        run$value$theoretical_coefficient
      raw_results$estimate[row_index] <- run$value$estimate
      raw_results$mcse[row_index] <- run$value$mcse
      raw_results$elapsed_seconds[row_index] <- run$elapsed

      row_index <- row_index + 1L
    }
  }

  truth <- .true_value()
  summary_rows <- vector("list", length(alpha_values))

  # A separate summary is produced for each selected value of alpha.
  for (j in seq_along(alpha_values)) {
    alpha <- alpha_values[j]
    current <- raw_results[raw_results$alpha == alpha, , drop = FALSE]

    summary_rows[[j]] <- data.frame(
      alpha = alpha,
      theoretical_correlation = current$theoretical_correlation[1L],
      mean_correlation = mean(current$correlation),
      theoretical_coefficient = current$theoretical_coefficient[1L],
      mean_coefficient = mean(current$coefficient),
      mean_estimate = mean(current$estimate),
      bias = mean(current$estimate) - truth,
      empirical_variance = stats::var(current$estimate),
      empirical_sd = stats::sd(current$estimate),
      rmse = sqrt(mean((current$estimate - truth)^2)),
      mae = mean(abs(current$estimate - truth)),
      average_mcse = mean(current$mcse),
      mean_time_ms = mean(current$elapsed_seconds) * 1000,
      stringsAsFactors = FALSE
    )
  }

  summary <- do.call(rbind, summary_rows)
  rownames(summary) <- NULL

  list(
    summary = summary,
    replications = raw_results,
    settings = list(
      true_value = truth,
      budget = budget,
      replications = replications,
      alpha_values = alpha_values,
      pilot_fraction = pilot_fraction,
      seed = seed
    )
  )
}
