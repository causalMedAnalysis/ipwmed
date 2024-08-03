*!TITLE: IPWMED - causal mediation analysis using inverse probability weighting	
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define ipwmed, eclass

	version 15	

	syntax varname(numeric) [if][in], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		[cvars(varlist numeric)] ///
		[sampwts(varname numeric)] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)] ///
		[detail]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	foreach i in `dvar' `mvar' {
		confirm variable `i'
		qui sum `i'
		if r(min) != 0 | r(max) != 1 {
		display as error "{p 0 0 5 0} The variable `i' is not binary and coded 0/1"
        error 198
		}
	}

	/***COMPUTE POINT AND INTERVAL ESTIMATES***/
	
	if ("`saving'" != "") {
		bootstrap ATE=r(ate) NDE=r(nde) NIE=r(nie) CDE=r(cde), ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			saving(`saving', replace) noheader notable: ///
			ipwmedbs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') sampwts(`sampwts')
			}

	if ("`saving'" == "") {
		bootstrap ATE=r(ate) NDE=r(nde) NIE=r(nie) CDE=r(cde), ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			noheader notable: ///
			ipwmedbs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') sampwts(`sampwts')
			}
			
	estat bootstrap, p noheader
	
	/***REPORT MODELS AND SAVE WEIGHTS IF REQUESTED***/
	if ("`detail'" != "") {
			ipwmedbs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') sampwts(`sampwts') `detail'
	
	label var sw1_r001 "IPW for estimating E(Y(d*,M(d*)))"
	label var sw2_r001 "IPW for estimating E(Y(d,M(d)))"
	label var sw3_r001 "IPW for estimating E(Y(d,M(d*)))"
	label var sw4_r001 "IPW for estimating E(Y(d,m))"
	}
	
end ipwmed
