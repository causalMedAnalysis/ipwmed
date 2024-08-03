# ipwmed
ipwmed is a stata module to perform causal mediation analysis using inverse probability weighting. Two models are 
estimated to construct the weights: a logit model for the exposure conditional on baseline covariates (if specified)
and another logit model for the exposure conditional on the mediator and the baseline covariates.
