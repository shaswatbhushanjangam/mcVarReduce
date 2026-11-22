\name{antithetic_estimate}
\alias{antithetic_estimate}
\title{Estimate the Target Integral with Antithetic Variables}
\description{
Estimates \eqn{\int_0^1 e^x dx = e - 1} by pairing each uniform input with
its reflection about 0.5.
}
\usage{
antithetic_estimate(budget = 10000, seed = NULL)
}
\arguments{
\item{budget}{An even positive whole number giving the total number of target-function evaluations. At least four are required.}
\item{seed}{\code{NULL} or a nonnegative whole number used for reproducibility.}
}
\details{
For each generated \eqn{U}, the outputs \eqn{e^U} and \eqn{e^(1-U)} are
averaged. Two target-function evaluations are therefore used per pair.
}
\section{Assumptions}{
The generated \eqn{U} values are independent and uniform on \eqn{[0,1]}.
The reflected value \eqn{1-U} has the same marginal distribution. Variance
reduction is useful when the paired outputs are negatively associated.
}
\value{
A named list containing \code{method}, \code{estimate}, \code{true_value},
\code{error}, \code{absolute_error}, \code{mcse},
\code{contribution_variance}, \code{pair_correlation},
\code{theoretical_pair_correlation}, \code{pairs}, and \code{budget}.
}
\examples{
result <- antithetic_estimate(budget = 2000, seed = 8670)
result[c("estimate", "true_value", "pair_correlation", "mcse")]
}
