**********************************************************
* Stratified random sampling with N treatments and N strata
* Date: 20161217
* Author: Grant Bridgman <grantbridgman@gmail.com>
* NOTE TO USER:
*	- Set macros to suit your project (lines 15, 16, 17)
**********************************************************
clear
set more off
cap log close


*********************************
* Set macros to suit your project
global	input_data = "your-input-data-directory"
global	output_data = "your-output-data-directory"
local	groups = 5 // Set this local to the number of treatment groups you have


**********************************
* Assign individuals to treatments

use "$input_data", clear
	
	count
	codebook unique_id
	duplicates drop unique_id

	* Generate random number
	set seed 6022141
	isid unique_id
	sort unique_id
	gen random_num=uniform()
	isid random_num

	* Generate new strata variable, by the sampling strata
	egen strata = group(strata)
	drop if strata==.

	* Create rank within strata (random rank order)
	bys strata: egen rank_strata = rank(random_num)

/*		Randomly assign individuals to N treatment groups within each N strata. For stratas with
		an even number of villages, they are randomly assigned half and half; for stratas with 
		an odd number of villages, all are assigned except for one; we will group these unassigned 
		villages as "leftovers" and then use the following steps to randomly assign to either group.
*/
	
	gen m_treat = .
	bys strata: gen divisible_number = _N - mod(_N,5)
	
	* The number of treatment groups in this project
	display "`groups'"
	
	forval r = 1/`groups' {
		replace m_treat = `r' if rank_strata <= divisible_num/`groups' * (`groups' - (`r'-1))
	}
	
	* Randomly allocate the leftovers (in cases where strata is not divisible by 7)
	count if m_treat==.
	if `r(N)'>0 {
	
		mark leftover if m_treat==.
		bys leftover: egen rank_leftover = rank(random_num)
		replace rank_leftover = . if m_treat!=.
	
		count if leftover == 1
		gen divisible_num_dos = `r(N)' - mod(`r(N)',7)
		forval r = 1/`groups' {
			replace m_treat = `r' if rank_leftover <= divisible_num_dos/`groups' * (`groups' - (`r'-1))
		}
	
	count if m_treat==.
	if `r(N)'>0 {
		gsort -m_treat random_num
		replace m_treat = [_n] if m_treat==.
	}


	tab m_treat, m
	

save "$output_data", replace
