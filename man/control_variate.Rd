\name{control_variate}
\alias{control_variate}
\title{Estimate the Target Integral with Control Variates}
\description{
Estimates \eqn{\int_0^1 e^x dx = e - 1} with a control-variate adjustment.
The strength of the control relationship is changed with \code{alpha}.
}
\usage{
control_variate(
  budget = 10000,
  alpha = 1,
  pilot_fraction = 0.1,
  seed = NULL
)
}
\arguments{
\item{budget}{A positive whole number giving the total number of target-function evaluations. At least four are required.}
\item{alpha}{A numeric value between 0 and 1. Values near 1 produce a strong control, while values near 0 produce a weak or uninformative control.}
\item{pilot_fraction}{A numeric value between 0 and 1 giving the fraction of the total budget used to estimate the control coefficient.}
\item{seed}{\code{NULL} or a nonnegative whole number used for reproducibility.}
}
\details{
Independent \eqn{U} and \eqn{V} values are generated from the uniform
distribution on \eqn{[0,1]}. The target output is \eqn{Y=e^U}, and the control
is \eqn{C_alpha=alpha U+(1-alpha)V}. The known control mean is 0.5.

An independent pilot sample is used to estimate
\eqn{c=-Cov(C,Y)/Var(C)}. The estimated coefficient is then held fixed in the
main simulation. Pilot evaluations are counted as part of \code{budget}.
}
\section{Assumptions}{
The generated uniform draws are independent within the pilot and main samples.
The pilot sample is independent of the main sample. The control mean is known
to be 0.5. The control must have positive variance in the pilot sample.
}
\value{
A named list containing \code{method}, \code{estimate}, \code{true_value},
\code{error}, \code{absolute_error}, \code{mcse},
\code{contribution_variance}, \code{correlation},
\code{theoretical_correlation}, \code{coefficient},
\code{theoretical_coefficient}, \code{alpha}, \code{control_mean},
\code{pilot_size}, \code{main_size}, and \code{budget}.
}
\examples{
result <- control_variate(
  budget = 2000,
  alpha = 1,
  pilot_fraction = 0.1,
  seed = 8670
)
result[c("estimate", "true_value", "correlation", "coefficient", "mcse")]
}
