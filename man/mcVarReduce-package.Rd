\name{mcVarReduce-package}
\alias{mcVarReduce-package}
\alias{mcVarReduce}
\docType{package}
\title{mcVarReduce: Variance Reduction for Monte Carlo Integration}
\description{
The package implements control variates, antithetic variables, and importance
sampling for the common target integral \eqn{\int_0^1 e^x dx = e - 1}.
The control-variate method is the main project method, and a controlled
correlation study is provided for investigating how control quality affects
estimation accuracy.
}
\details{
The package provides reproducible variance-reduction experiments. The same exact
target is used throughout so that accuracy can be evaluated directly. Plain
Monte Carlo is intentionally not implemented as a project comparison method.
}
\author{
Shaswat Bhushan Jangam, Prakash Karki, and Mangsa Limbu Pheudin.
}
