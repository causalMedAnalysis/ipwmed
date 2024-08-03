*!TITLE: IPWMED - causal mediation analysis using inverse probability weighting	
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define ipwmedbs, rclass
	
	version 15	

	syntax varname(numeric) [if][in], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		[cvars(varlist numeric)] ///
		[sampwts(varname numeric)] ///
		[detail]
	
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
		local N = r(N)
		}
			
	local yvar `varlist'
	
	local ipw_var_names "sw1_r001 sw2_r001 sw3_r001 sw4_r001"
		foreach name of local ipw_var_names {
			capture confirm new variable `name'
			if _rc {
				display as error "{p 0 0 5 0}The command needs to create weight variables"
				display as error "with the following names: `ipw_var_names', "
				display as error "but these variables have already been defined.{p_end}"
				error 110
				}
			}

	local sampwt_var_names "wt_r001 wt_r002 wt_r003"
		foreach name of local sampwt_var_names {
			capture confirm new variable `name'
			if !_rc {
				local wts `name'
				continue, break
				}
			}
			if _rc {
				display as error "{p 0 0 5 0}The command needs to create a weight variable"
				display as error "with one of the following names: `sampwt_var_names', "
				display as error "but these variables have already been defined.{p_end}"
				error 110
			}
	
	qui gen `wts' = 1 if `touse'
	
	if ("`sampwts'" != "") {
		qui replace `wts' = `wts' * `sampwts'
		qui sum `wts'
		qui replace `wts' = `wts' / r(mean)
		}
		
	logit `dvar' `cvars' [pw=`wts'] if `touse'
	qui predict phat_D1_C_r001 if e(sample), pr
	qui gen phat_D0_C_r001=1-phat_D1_C_r001 if `touse'
		
	logit `dvar' `mvar' `cvars' [pw=`wts'] if `touse'
	qui predict phat_D1_CM_r001 if e(sample), pr
	qui gen phat_D0_CM_r001=1-phat_D1_CM_r001 if `touse'

	logit `mvar' `dvar' `cvars' [pw=`wts'] if `touse'
	qui predict phat_M1_CD_r001 if e(sample), pr
	qui gen phat_M0_CD_r001=1-phat_M1_CD_r001 if `touse'
	
	qui logit `dvar' [pw=`wts'] if `touse'
	qui predict phat_D1_r001 if e(sample), pr
	qui gen phat_D0_r001=1-phat_D1_r001 if `touse'
	
	qui logit `mvar' `dvar' [pw=`wts'] if `touse'
	qui predict phat_M1_D_r001 if e(sample), pr
	qui gen phat_M0_D_r001=1-phat_M1_D_r001 if `touse'

	qui gen sw1_r001 = phat_D`dstar'_r001 / phat_D`dstar'_C_r001 if `dvar'==`dstar' & `touse'
	qui gen sw2_r001 = phat_D`d'_r001 / phat_D`d'_C_r001 if `dvar'==`d' & `touse'
	qui gen sw3_r001 = (phat_D`dstar'_CM_r001*phat_D`d'_r001) / (phat_D`d'_CM_r001*phat_D`dstar'_C_r001) if `dvar'==`d' & `touse'
		
	qui gen sw4_r001 = (phat_D`d'_r001 / phat_D`d'_C_r001) if `dvar'==`d' & `touse'
	qui replace sw4_r001 = (phat_D`dstar'_r001 / phat_D`dstar'_C_r001) if `dvar'==`dstar' & `touse'
		
	qui replace sw4_r001 = sw4_r001 * ///
		(((`mvar'*phat_M1_D_r001)+((1-`mvar')*phat_M0_D_r001)) / ((`mvar'*phat_M1_CD_r001)+((1-`mvar')*phat_M0_CD_r001))) if `touse'
		
	foreach i of var sw1_r001 sw2_r001 sw3_r001 sw4_r001 {
		qui replace `i'=`i' * `wts' if `touse'
		qui centile `i' if `i'!=. & `touse', c(1 99) 
		qui replace `i'=r(c_1) if `i'<r(c_1) & `i'!=. & `touse'
		qui replace `i'=r(c_2) if `i'>r(c_2) & `i'!=. & `touse'
		}
	
	qui reg `yvar' [pw=sw1_r001] if `dvar'==`dstar' & `touse'
	local Ehat_Y0M0=_b[_cons]
		
	qui reg `yvar' [pw=sw2_r001] if `dvar'==`d' & `touse'
	local Ehat_Y1M1=_b[_cons]
		
	qui reg `yvar' [pw=sw3_r001] if `dvar'==`d' & `touse'
	local Ehat_Y1M0=_b[_cons]
	
	tempvar inter
	qui gen `inter' = `dvar' * `mvar' if `touse'
	
	qui reg `yvar' `dvar' `mvar' `inter' [pw=sw4_r001] if `touse'
		
	return scalar ate=`Ehat_Y1M1'-`Ehat_Y0M0'
	return scalar nde=`Ehat_Y1M0'-`Ehat_Y0M0'
	return scalar nie=`Ehat_Y1M1'-`Ehat_Y1M0'
	return scalar cde=(_b[`dvar']+(_b[`inter']*`m'))*(`d'-`dstar')
		
	drop phat*_r001 `wts'
	
	if ("`detail'"=="") {
		drop sw1_r001 sw2_r001 sw3_r001 sw4_r001
		}

end ipwmedbs
