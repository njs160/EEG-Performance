*ALL EEG*
 use "/Users/nasseralsabah/Desktop/PhD/John Jay/Research/EEG (Complete Version)/DATA/EEG:MEMORY (Repurposed for all).dta", clear
 


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use "/Users/nasseralsabah/Desktop/PhD/John Jay/Research/EEG (Complete Version)/DATA/EEG:MEMORY (Repurposed for all).dta", clear

oneway frontal_beta cohortn, bonferroni tabulate nostandard nofreq noobs

spearman decisionmaking reasoning memory frontal_beta temporal_beta parietal_beta occipital_beta hrv, stats(rho) star(0.05)

spearman stress confidence age frontal_beta temporal_beta parietal_beta occipital_beta hrv, stats(rho) star(0.05)



use "/Users/nasseralsabah/Desktop/PhD/John Jay/Research/EEG (Complete Version)/DATA/EEG:MEMORY (Repurposed for all).dta", clear
////////removed observations that were removed in final model (through cook's D) each to maintain sample sizes across models

*decisionmaking*
*(1)
regress decisionmaking frontal_beta, beta
predict betadec, cooksd
replace decisionmaking = . if betadec > 0.072175
replace decisionmaking= . in 47
replace decisionmaking= . in 25
replace decisionmaking= . in 3
replace decisionmaking= . in 31
replace decisionmaking= . in 2
regress decisionmaking frontal_beta , beta
vif
predict errordec, residuals
swilk errordec
estat hettest

*(2)
regress decisionmaking1 frontal_beta temporal_beta  parietal_beta occipital_beta, beta
predict betadec1, cooksd
replace decisionmaking1 = . if betadec1 > 0.072175
regress decisionmaking1 frontal_beta temporal_beta  parietal_beta occipital_beta , beta
vif
predict errordec1, residuals
swilk errordec1
estat hettest

*(3)
regress decisionmaking2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv 
predict betadec2, cooksd
replace decisionmaking2 = . if betadec2 > 0.072175
replace decisionmaking2= . in 47
replace decisionmaking2= . in 25
regress decisionmaking2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv, beta
scatter  frontal_beta decisionmaking2, mlabel(orig_order)
vif
predict errordec2, residuals
swilk errordec2
estat hettest



*reasoning*
*(1)
use "/Users/nasseralsabah/Desktop/PhD/John Jay/Research/EEG (Complete Version)/DATA/EEG:MEMORY (Repurposed for all).dta", clear

regress reasoning frontal_beta 
predict betareas, cooksd
replace reasoning = . if betareas > 0.072175
scatter  frontal_beta reasoning, mlabel(orig_order)
replace reasoning = . in 25
replace reasoning = . in 22
replace reasoning = . in 23
regress reasoning frontal_beta, beta
vif
predict errorreas, residuals
swilk errorreas
estat hettest

*(2)
regress reasoning1 frontal_beta temporal_beta  parietal_beta occipital_beta 
predict betareas1, cooksd
replace reasoning1 = . if betareas1 > 0.070175
replace reasoning1 = . in 25
replace reasoning1 = . in 11
scatter  frontal_beta reasoning1, mlabel(orig_order)
regress reasoning1 frontal_beta temporal_beta  parietal_beta occipital_beta 
vif
predict errorreas1, residuals
swilk errorreas1
estat hettest


*(3)
use "/Users/nasseralsabah/Desktop/PhD/John Jay/Research/EEG (Complete Version)/DATA/EEG:MEMORY (Repurposed for all).dta", clear

regress reasoning2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv
predict betareas2, cooksd
replace reasoning2 = . in 25
replace reasoning2 = . in 35
replace reasoning2 = . in 33
replace reasoning2 = . in 11
replace reasoning2 = . in 23
replace reasoning2 = . in 34
scatter  frontal_beta reasoning2, mlabel(orig_order)
regress reasoning2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv
vif
predict errorreas2, residuals
swilk errorreas2
estat hettest


*memory*
*(1)
use "/Users/nasseralsabah/Desktop/PhD/John Jay/Research/EEG (Complete Version)/DATA/EEG:MEMORY (Repurposed for all).dta", clear

regress memory frontal_beta 
predict betamem, cooksd
replace memory = . if betamem > 0.070175
replace memory = . in 25
replace memory = . in 44
replace memory = . in 32
scatter  frontal_beta memory, mlabel(orig_order)
regress memory frontal_beta 
vif
predict errormem, residuals
swilk errormem
estat hettest


*(2)
regress memory_1 frontal_beta temporal_beta  parietal_beta occipital_beta 
predict betamem1, cooksd
replace memory_1 = . if betamem > 0.070175
replace memory_1 = . in 44
replace memory_1 = . in 25
replace memory_1 = . in 32
scatter  frontal_beta memory_1, mlabel(orig_order)
regress memory_1 frontal_beta temporal_beta  parietal_beta occipital_beta 
vif
predict errormem1, residuals
swilk errormem1
estat hettest

*(3)
regress memory_2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv
predict betamem2, cooksd
replace memory_2 = . if betamem2 > 0.070175
regress memory_2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv
vif
predict errormem2, residuals
swilk errormem2
estat hettest



*****APA*****

eststo clear
eststo: regress decisionmaking frontal_beta, beta
eststo: regress decisionmaking1 frontal_beta temporal_beta  parietal_beta occipital_beta, beta
eststo: regress decisionmaking2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv, beta
esttab using decreg.rtf, scalars( p r2) se beta wide compress replace


eststo: regress reasoning frontal_beta 
eststo: regress reasoning1 frontal_beta temporal_beta  parietal_beta occipital_beta
eststo: regress reasoning2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv

eststo: regress memory frontal_beta 
eststo: regress memory_1 frontal_beta temporal_beta  parietal_beta occipital_beta
eststo: regress memory_2 frontal_beta temporal_beta  parietal_beta occipital_beta hrv

esttab using EEG.csv, scalars( p r2) se beta wide compress replace




