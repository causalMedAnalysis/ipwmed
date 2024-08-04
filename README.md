# ipwmed: Causal Mediation Analysis using Inverse Probability Weighting

`ipwmed` is a Stata module to perform causal mediation analysis using inverse probability weighting (IPW). This module is esigned for binary treatment and mediator variables. It constructs a set of IPWs and then uses them to estimate the controlled direct, natural direct, natural indirect, and average total effects.

## Syntax

```stata
ipwmed varname, dvar(varname) mvar(varname) d(real) dstar(real) m(real) [options]
```

### Required Arguments

- `varname`: Specifies the outcome variable.
- `dvar(varname)`: Specifies the treatment variable. Must be binary (0/1).
- `mvar(varname)`: Specifies the mediator variable. Must be binary (0/1).
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast (d - dstar).
- `m(real)`: Level of the mediator for evaluating the controlled direct effect.

### Options

- `cvars(varlist)`: List of baseline covariates. Categorical variables should be dummy coded.
- `weights(varname)`: Variable containing survey/sampling weights.
- `reps(integer)`: Number of bootstrap replications (default is 200).
- `strata(varname)`: Variable identifying bootstrap sampling strata.
- `cluster(varname)`: Variable identifying bootstrap sampling clusters.
- `level(cilevel)`: Confidence level for bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Seed for replicable bootstrap resampling.
- `detail`: Prints models and saves variables containing the inverse probability weights.

## Description

`ipwmed` estimates two logit models to construct the necessary weights:

1. A logit model for the exposure conditional on baseline covariates.
2. A logit model for the exposure conditional on both the mediator and the baseline covariates.

It then uses the inverse probability weights to estimate controlled direct, natural direct, natural indirect, and average total effects.

## Examples

```stata
// Load data
use nlsy79.dta

// Mediation analysis with IPW; percentile bootrstrap CIs with 1000 replications
ipwmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0) reps(1000)

// Mediation analysis with IPW; percentile bootrstrap CIs with default settings; print models and save weights
ipwmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0) detail
```

## Saved Results

`ipwmed` saves results in `e()`:

- `e(b)`: Matrix with direct, indirect, and total effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology, University of Chicago  
Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation.

## Also See

- [logit](https://www.stata.com/manuals/rlogit.pdf)
- [bootstrap](https://www.stata.com/manuals/rbootstrap.pdf)
```
