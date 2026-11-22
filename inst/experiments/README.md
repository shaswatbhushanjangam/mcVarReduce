# Reproducing the experiments

The experiment script is `run_experiments.R`.

After `mcVarReduce` has been installed, the complete experiment can be run with:

```r
source(system.file("experiments", "run_experiments.R", package = "mcVarReduce"))
```

A `results` directory is created in the current working directory. The following files are produced:

- `correlation-summary.csv`
- `correlation-replications.csv`
- `correlation-results.rds`
- `correlation-vs-rmse.png`
- `method-comparison-summary.csv`
- `method-comparison-replications.csv`
- `method-comparison-results.rds`
- `method-rmse-comparison.png`
- `experiment-settings.txt`
- `session-info.txt`

The default design uses a target-function evaluation budget of 10,000 and 500 independent replications. The seed is 8670. The exact target is `exp(1) - 1`.
