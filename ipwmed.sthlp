{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for ipwmed}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ipwmed} {hline 2}}causal mediation analysis using inverse probability weighting{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ipwmed} {varname} {ifin}{cmd:,} dvar({varname}) mvar({varname}) 
d({it:real}) dstar({it:real}) m({it:real}) [cvars({varlist}))
{reps({it:integer 1000}) strata({varname}) cluster({varname}) level(cilevel) seed({it:passthru})]

{phang}{opt varname} - this specifies the outcome variable.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable. This variable must be binary (0/1).

{phang}{opt mvar(varname)} - this specifies the mediator variable. This variable must be binary (0/1).

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{phang}{opt m(real)} - this specifies the level of the mediator at which the controlled direct effect 
is evaluated.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt weights(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt reps(integer 200)} - this option specifies the number of replications for bootstrap resampling (the default is 200).

{phang}{opt strata(varname)} - this option specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{phang}{opt cluster(varname)} - this option specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{phang}{opt level(cilevel)} - this option specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{phang}{opt seed(passthru)} - this option specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. {p_end}

{phang}{opt detail} - this option prints the fitted models for the exposure and the mediator; it 
also saves four variables containing the inverse probability weights used to compute the effect estimates. {p_end}

{title:Description}

{pstd}{cmd:ipwmed} performs causal mediation analysis using inverse probability weighting. Two models are 
estimated to construct the weights: a logit model for the exposure conditional on baseline covariates (if specified)
and another logit model for the exposure conditional on the mediator and the baseline covariates.

{pstd}{cmd:ipwmed} provides estimates of the controlled direct effect, the natural direct effect, the natural indirect effect, 
and the total effect. It also generates four variables containing the inverse probability weights used to compute
these effect estimates. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

 
{pstd} percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ipwmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0) reps(1000)} {p_end}

{title:Saved results}

{pstd}{cmd:ipwmed} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing direct, indirect and total effect estimates{p_end}


{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke GT, Zhou X, and Elwert F. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp logit R}, {manhelp bootstrap R}
{p_end}
