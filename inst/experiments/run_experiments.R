library(mcVarReduce)

# A results directory is created in the current working directory.
output_dir <- "results"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# The correlation study is run with the default experiment settings.
correlation_results <- correlation_study(
  alpha_values = c(0, 0.10, 0.25, 0.50, 0.75, 1),
  budget = 10000,
  replications = 500,
  pilot_fraction = 0.10,
  seed = 8670
)

# The final three-method comparison is run at the same target-function evaluation budget.
comparison_results <- compare_methods(
  budget = 10000,
  replications = 500,
  alpha = 1,
  pilot_fraction = 0.10,
  seed = 8670
)

# The complete result objects are preserved so that every reported value can be reproduced.
saveRDS(
  correlation_results,
  file.path(output_dir, "correlation-results.rds")
)
saveRDS(
  comparison_results,
  file.path(output_dir, "method-comparison-results.rds")
)

# The numerical results are written to CSV files for the report workflow.
utils::write.csv(
  correlation_results$summary,
  file.path(output_dir, "correlation-summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  correlation_results$replications,
  file.path(output_dir, "correlation-replications.csv"),
  row.names = FALSE
)
utils::write.csv(
  comparison_results$summary,
  file.path(output_dir, "method-comparison-summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  comparison_results$replications,
  file.path(output_dir, "method-comparison-replications.csv"),
  row.names = FALSE
)

# A figure is created to show how RMSE changes with the observed control correlation.
grDevices::png(
  file.path(output_dir, "correlation-vs-rmse.png"),
  width = 900,
  height = 650
)
graphics::plot(
  correlation_results$summary$mean_correlation,
  correlation_results$summary$rmse,
  type = "b",
  pch = 19,
  xlab = "Mean correlation between output and control",
  ylab = "RMSE",
  main = "Control Correlation and Estimation Accuracy"
)
graphics::grid()
grDevices::dev.off()

# A figure is created to compare RMSE across the three approved methods.
grDevices::png(
  file.path(output_dir, "method-rmse-comparison.png"),
  width = 900,
  height = 650
)
# The lower plot margin is expanded so that the method labels can be read clearly.
graphics::par(mar = c(10, 4, 4, 2) + 0.1)
graphics::barplot(
  comparison_results$summary$rmse,
  names.arg = comparison_results$summary$method,
  ylab = "RMSE",
  main = "RMSE by Variance-Reduction Method",
  las = 2
)
grDevices::dev.off()

# The final experiment settings are recorded in a simple text file.
settings_lines <- c(
  "Target: integral from 0 to 1 of exp(x) dx = exp(1) - 1",
  "Target-function budget per method: 10000",
  "Replications: 500",
  "Control alpha values: 0, 0.10, 0.25, 0.50, 0.75, 1",
  "Control pilot fraction: 0.10",
  "Method-comparison control alpha: 1",
  "Seed: 8670"
)
writeLines(settings_lines, file.path(output_dir, "experiment-settings.txt"))

# Exact software and platform information is recorded for reproducibility.
session_file <- file.path(output_dir, "session-info.txt")
utils::capture.output(utils::sessionInfo(), file = session_file)

# The locations of the generated files are displayed after the experiment is completed.
message("Experiment files were written to: ", normalizePath(output_dir))
