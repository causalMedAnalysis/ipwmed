# ipwmed: A Stata Module to Perform Causal Mediation Analysis using Inverse Probability Weighting

## Overview

**ipwmed** is a Stata module designed to perform causal mediation analysis using inverse probability weighting.

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
- `sampwts(varname)`: Specifies a variable containing sampling weights to include in the analysis.
- `censor`: Censors the inverse probability weights at their 1st and 99th percentiles.
- `detail`: Prints the fitted models for the exposure and saves three variables containing the inverse probability weights used to compute the effect estimates.
- `bootstrap_options`: All `bootstrap` options are available.

## Description

`ipwmed` performs causal mediation analysis using inverse probability weighting, and it computes inferential statistics using the nonparametric bootstrap. 

It estimates two models to construct the weights: a logit model for the exposure conditional on baseline covariates (if specified), and another logit model for the exposure conditional on the mediator(s) and the baseline covariates. 

Using these weights, `ipwmed` estimates the total, natural direct, and natural indirect effects when a single mediator is specified. When multiple mediators are specified, it provides estimates for the total effect and the multivariate natural direct and indirect effects operating through the entire set of mediators.

`ipwmed` allows sampling weights via the `sampwts` option, but it does not internally rescale them for use with the bootstrap. If using weights from a complex sample design that require rescaling to produce valid boostrap estimates, the user must be sure to appropriately specify the `strata`, `cluster`, and `size` options from the `bootstrap` command so that Nc-1 clusters are sampled within from each stratum, where Nc denotes the number of clusters per stratum. Failure to properly adjust the bootstrap sampling to account for a complex sample design that requires weighting could lead to invalid inferential statistics.

## Examples

### Example 1: Single mediator with default settings

```stata
use nlsy79.dta
ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0)
```

### Example 2: Single mediator with censored weights, detailed output, and 1000 bootstrap replications

```stata
ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000) censor detail reps(1000)
```

### Example 3: Multiple mediators with censored weights and 1000 bootstrap replications

```stata
ipwmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) censor reps(1000)
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
