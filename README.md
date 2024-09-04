# ipwmed: Causal Mediation Analysis using Inverse Probability Weighting

## Overview

**ipwmed** is a Stata module designed to perform causal mediation analysis using inverse probability weighting. It estimates the total, natural direct, and natural indirect effects when a single mediator is specified. When multiple mediators are specified, it provides estimates for the total effect and the multivariate natural direct and indirect effects operating through the entire set of mediators.

## Syntax

```stata
ipwmed depvar mvars [if] [in], dvar(varname) d(real) dstar(real) cvars(varlist) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `mvars`: Specifies the mediator(s), which can be a single variable or multivariate.
- `dvar(varname)`: Specifies the treatment (exposure) variable, which must be binary and coded as 0/1.
- `d(real)`: Specifies the reference level of treatment.
- `dstar(real)`: Specifies the alternative level of treatment. Together, (d - dstar) defines the treatment contrast of interest.

### Options

- `cvars(varlist)`: Specifies the list of baseline covariates to be included in the analysis. Categorical variables need to be coded as a series of dummy variables before being entered as covariates.
- `censor`: Censors the inverse probability weights at their 1st and 99th percentiles.
- `sampwts(varname)`: Specifies a variable containing sampling weights to include in the analysis.
- `reps(integer)`: Specifies the number of replications for bootstrap resampling (default is 200).
- `strata(varname)`: Specifies a variable that identifies resampling strata. If specified, bootstrap samples are taken independently within each stratum.
- `cluster(varname)`: Specifies a variable that identifies resampling clusters. If specified, the sample drawn during each replication is a bootstrap sample of clusters.
- `level(cilevel)`: Specifies the confidence level for constructing bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Specifies the seed for bootstrap resampling. If omitted, a random seed is used, and the results cannot be replicated.
- `detail`: Prints the fitted models for the exposure and saves three variables containing the inverse probability weights used to compute the effect estimates.

## Description

The `ipwmed` module estimates two models to construct the weights: a logit model for the exposure conditional on baseline covariates (if specified) and another logit model for the exposure conditional on the mediator(s) and the baseline covariates. Using these weights, it estimates the total, natural direct, and natural indirect effects when a single mediator is specified. When multiple mediators are specified, it provides estimates for the total effect and the multivariate natural direct and indirect effects operating through the entire set of mediators.

## Examples

### Example 1: Single mediator with default settings

```stata
use nlsy79.dta
ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)
```

### Example 2: Single mediator with censored weights and detailed output

```stata
ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000) censor detail
```

### Example 3: Multiple mediators with censored weights

```stata
ipwmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000) censor
```

## Saved Results

The following results are saved in `e()`:

- **Matrices:**
  - `e(b)`: Matrix containing total, direct, and indirect effect estimates.

## Author

**Geoffrey T. Wodtke**  
Department of Sociology  
University of Chicago  
Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, GT, and X Zhou. *Causal Mediation Analysis*. In preparation.

## See Also

- Stata manual: [logit](https://www.stata.com/manuals/rlogit.pdf), [bootstrap](https://www.stata.com/manuals/rbootstrap.pdf)
