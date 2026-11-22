\name{correlation_study}
\alias{correlation_study}
\title{Study Control-Variate Accuracy Across Correlation Settings}
\description{
Repeats the control-variate estimator over selected \code{alpha} values and
summarizes how control correlation is associated with estimator accuracy.
}
\usage{
correlation_study(
  alpha_values = c(0, 0.1, 0.25, 0.5, 0.75, 1),
  budget = 10000,
  replications = 500,
  pilot_fraction = 0.1,
  seed = 8670
)
}
\arguments{
\item{alpha_values}{A numeric vector containing values between 0 and 1.}
\item{budget}{A positive whole number giving the target-function evaluation budget for each run.}
\item{replications}{A whole number of independent repetitions for each alpha value. At least two are required.}
\item{pilot_fraction}{A numeric value between 0 and 1 giving the fraction of the budget used for the pilot sample.}
\item{seed}{\code{NULL} or a nonnegative whole number used for reproducibility.}
}
\details{
The control is \eqn{C_alpha=alpha U+(1-alpha)V}. Its known mean remains
0.5 while its association with \eqn{Y=e^U} changes as \code{alpha} changes.
The setting \code{alpha = 0} is naturally included as an uninformative-control
limitation case.
}
\section{Assumptions}{
The assumptions of \code{control_variate()} apply to every replication.
Replications are generated with separate method-specific seeds when a seed is
provided. The same budget and pilot fraction are used across alpha settings.
}
\value{
A list with \code{summary}, \code{replications}, and \code{settings}.
The summary contains theoretical and observed control correlations,
theoretical and estimated coefficients, bias, empirical variance, empirical
standard deviation, RMSE, MAE, average MCSE, and average elapsed time for each
alpha value.
}
\examples{
result <- correlation_study(
  alpha_values = c(0, 0.5, 1),
  budget = 500,
  replications = 10,
  pilot_fraction = 0.1,
  seed = 8670
)
result$summary
}
