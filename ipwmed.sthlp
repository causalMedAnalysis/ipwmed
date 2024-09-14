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
{opt dstar(real)} 
{opt cvars(varlist)} 
{opt sampwts(varname)} 
{opt censor}
{opt detail}
[{it:{help bootstrap##options:bootstrap_options}}]

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt mvars} - this specifies the mediator(s), which can be a single variable or multivariate.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable, which must be binary and coded 0/1.

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt sampwts(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt censor} - this option specifies that the inverse probability weights are censored at their 1st and 99th percentiles.

{phang}{opt detail} - this option prints the fitted models for the exposure, and it also saves three variables containing 
the inverse probability weights used to compute the effect estimates. {p_end}

{phang}{it:{help bootstrap##options:bootstrap_options}} - all {help bootstrap} options are available. {p_end}

{title:Description}

{pstd}{cmd:ipwmed} performs causal mediation analysis using inverse probability weighting, and it computes inferential statistics using the nonparametric bootstrap. {p_end}

{pstd}Two models are estimated to construct the weights: a logit model for the exposure conditional on 
baseline covariates (if specified), and another logit model for the exposure conditional on the mediator(s) 
and the baseline covariates. {p_end}

{pstd}If a single mediator is specified, {cmd:ipwmed} provides estimates of the total, natural direct, and natural indirect effects. 
If multiple mediators are specified, it provides estimates for the total effect and then for the multivariate natural direct and 
indirect effects operating through the entire set of mediators considered together. {p_end}

{pstd}If using {opt sampwts} from a complex sample design that require rescaling to produce valid boostrap estimates, be sure to appropriately 
specify the strata(), cluster(), and size() options from the {help bootstrap} command so that Nc-1 clusters are sampled from each stratum 
with replacement, where Nc denotes the number of clusters per stratum. Failing to properly adjust the bootstrap procedure to account
for a complex sample design and its associated sampling weights could lead to invalid inferential statistics. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} percentile bootstrap CIs with default settings, single mediator: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0)} {p_end}

{pstd} percentile bootstrap CIs with 1000 replications, single mediator, censored weights, and detailed output: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) censor detail reps(1000) } {p_end}

{pstd} percentile bootstrap CIs with 1000 replications, multiple mediators, and censored weights: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) censor reps(1000)} {p_end}
 
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
