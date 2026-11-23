# mcVarReduce

`mcVarReduce` implements three variance-reduction methods for the common Monte Carlo integration target

$$
\theta = \int_0^1 e^x\,dx = e - 1
$$

The package provides control variates, antithetic variables, and importance sampling. The exact value `exp(1) - 1` is used as the accuracy reference, and the methods can be compared under the same target-function evaluation budget.

## Authors

- Shaswat Bhushan Jangam
- Prakash Karki
- Mangsa Limbu Pheudin

## Main functions

### `control_variate()`

A pilot sample is used to estimate the variance-minimizing control coefficient. An independent main sample is then adjusted using the fixed estimated coefficient.

```r
result <- control_variate(
  budget = 10000,
  alpha = 1,
  pilot_fraction = 0.10,
  seed = 8670
)

result$estimate
result$correlation
result$coefficient
result$mcse
```

The `alpha` argument controls the strength of the control. Values near zero give weak controls, while `alpha = 1` gives the strongest control used in the package examples.

### `antithetic_estimate()`

Each uniform draw `U` is paired with `1 - U`.

```r
result <- antithetic_estimate(
  budget = 10000,
  seed = 8670
)

result[c("estimate", "true_value", "pair_correlation", "mcse")]
```

### `importance_sampling()`

Importance sampling is implemented with

\[
q(x) = \frac{2}{3}(1+x), \qquad 0 \le x \le 1.
\]

```r
result <- importance_sampling(
  budget = 10000,
  seed = 8670
)

result[c("estimate", "true_value", "mcse", "proposal")]
```

### `correlation_study()`

The control-variate estimator can be repeated across several control strengths.

```r
study <- correlation_study(
  alpha_values = c(0, 0.10, 0.25, 0.50, 0.75, 1),
  budget = 10000,
  replications = 500,
  pilot_fraction = 0.10,
  seed = 8670
)

study$summary
```

### `compare_methods()`

The three methods can be compared at the same target-function evaluation budget.

```r
comparison <- compare_methods(
  budget = 10000,
  replications = 500,
  alpha = 1,
  pilot_fraction = 0.10,
  seed = 8670
)

comparison$summary
```

The summary contains the mean estimate, bias, empirical variance, empirical standard deviation, RMSE, MAE, average MCSE, and mean computation time per replication.

## Requirements

R 4.2.0 or newer is required. The package implementation uses base R and the recommended `stats` package. The following packages are suggested for the vignette and automated tests:

```r
install.packages(c("testthat", "knitr", "rmarkdown"))
```

## Installation

A built source archive can be installed with:

```r
install.packages(
  "mcVarReduce_1.0.0.tar.gz",
  repos = NULL,
  type = "source"
)

library(mcVarReduce)
```

A package source folder can also be installed with standard R package development tools.

## Worked example

A reproducible vignette is included at:

```text
vignettes/variance-reduction.Rmd
```

After installation, available vignettes can be listed with:

```r
vignette(package = "mcVarReduce")
```

## Automated tests

The test suite is located in `tests/testthat/`. From the package source directory it can be run with:

```r
testthat::test_local(".")
```

The tests cover known reference values, the uninformative-control edge case, the antithetic relationship, and invalid input settings.

## Reproducing the experiments

After the package has been installed, the complete experiment can be reproduced with:

```r
source(
  system.file(
    "experiments",
    "run_experiments.R",
    package = "mcVarReduce"
  )
)
```

A `results` directory is created in the current working directory. It contains summary and replication CSV files, RDS result objects, figures, experiment settings, and session information.

The default experiment uses:

- target-function evaluation budget: 10,000 per method;
- independent replications: 500;
- control pilot fraction: 0.10;
- control-study alpha values: 0, 0.10, 0.25, 0.50, 0.75, 1;
- method-comparison control setting: `alpha = 1`;
- random seed: 8670.

For control variates, pilot evaluations are counted as part of the total budget. For antithetic variables, 5,000 pairs use 10,000 target-function evaluations. For importance sampling, 10,000 weighted target-function evaluations are used.

## Package structure

```text
mcVarReduce/
├── DESCRIPTION
├── NAMESPACE
├── LICENSE
├── README.md
├── R/
├── man/
├── tests/
├── vignettes/
└── inst/
    └── experiments/
```

## License

MIT License.
