{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for ipwmed}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ipwmed} {hline 2}}causal mediation analysis using inverse probability weighting {p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ipwmed} {depvar} {help indepvars:mvars} {ifin}{cmd:,} 
{opt dvar(varname)} 
{opt d(real)} 
{opt dstar(real})} 
{opt cvars(varlist)} 
{opt censor}
{opt sampwts(varname)} 
{opt reps(integer)} 
{opt strata(varname)} 
{opt cluster(varname)} 
{opt level(cilevel)} 
{opt seed(passthru)} 
{opt detail}

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt mvars} - this specifies the mediator(s), which can be a single variable or multivariate.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable, which must be binary and coded 0/1.

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt censor} - this option specifies that the inverse probability weights are censored at their 1st and 99th percentiles.

{phang}{opt sampwts(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt reps(integer)} - this option specifies the number of replications for bootstrap resampling (the default is 200).

{phang}{opt strata(varname)} - this option specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{phang}{opt cluster(varname)} - this option specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{phang}{opt level(cilevel)} - this option specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{phang}{opt seed(passthru)} - this option specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. {p_end}

{phang}{opt detail} - this option prints the fitted models for the exposure, and it also saves three variables containing 
the inverse probability weights used to compute the effect estimates. {p_end}

{title:Description}

{pstd}{cmd:ipwmed} performs causal mediation analysis using inverse probability weighting. Two models are 
estimated to construct the weights: a logit model for the exposure conditional on baseline covariates (if specified)
and another logit model for the exposure conditional on the mediator(s) and the baseline covariates.

{pstd}If a single mediator is specified, {cmd:ipwmed} provides estimates of the total, natural direct, and natural indirect effects. 
If multiple mediators are specified, it provides estimates for the total effect and then for the multivariate natural direct and 
indirect effects operating through the entire set of mediators considered together. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} percentile bootstrap CIs with default settings, single mediator: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)} {p_end}

{pstd} percentile bootstrap CIs with default settings, single mediator, censoring the weights and printing detailed output: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000) censor detail} {p_end}

{pstd} percentile bootstrap CIs with default settings, multiple mediators, censoring the weights: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000) censor} {p_end}
 
{title:Saved results}

{pstd}{cmd:ipwmed} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing total, direct, and indirect effect estimates{p_end}

{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu

{title:References}

{pstd}Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp logit R}, {manhelp bootstrap R}
{p_end}
