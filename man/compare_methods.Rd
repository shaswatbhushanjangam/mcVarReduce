\name{compare_methods}
\alias{compare_methods}
\title{Compare Three Variance-Reduction Methods}
\description{
Repeats control variates, antithetic variables, and importance sampling under
the same target-function evaluation budget and summarizes accuracy and
computation time.
}
\usage{
compare_methods(
  budget = 10000,
  replications = 500,
  alpha = 1,
  pilot_fraction = 0.1,
  seed = 8670
)
}
\arguments{
\item{budget}{An even positive whole number giving the target-function evaluation budget for each method.}
\item{replications}{A whole number of independent repetitions. At least two are required.}
\item{alpha}{The control-strength parameter passed to \code{control_variate()}.}
\item{pilot_fraction}{The pilot-budget fraction passed to \code{control_variate()}.}
\item{seed}{\code{NULL} or a nonnegative whole number used to generate reproducible method-specific seeds.}
}
\details{
The exact target \eqn{e-1} is used as the accuracy reference. Plain Monte
Carlo is intentionally excluded from the project comparison. Reported
summaries include bias, empirical variance, empirical standard deviation,
RMSE, MAE, average MCSE, and average elapsed time per replication.

The control-variate pilot evaluations are counted inside the same total
\code{budget}. The antithetic method uses two target evaluations per pair, and
importance sampling uses one weighted target evaluation per draw.
}
\section{Assumptions}{
The method-specific assumptions documented for \code{control_variate()},
\code{antithetic_estimate()}, and \code{importance_sampling()} apply. The
same total target-function evaluation budget is used for all three methods.
}
\value{
A list with three components: \code{summary}, a data frame containing method
performance measures; \code{replications}, a data frame containing individual
estimates; and \code{settings}, a list describing the experiment.
}
\examples{
result <- compare_methods(
  budget = 500,
  replications = 10,
  alpha = 1,
  pilot_fraction = 0.1,
  seed = 8670
)
result$summary
}
