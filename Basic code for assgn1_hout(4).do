capture log close
clear

cd  "C:\Users\oweph65p\OneDrive - University of Otago\Documents\Teaching\ECON412\2024\assignments\" 

log using "Assgn1.log", replace

* set up 101 obs, starting value 0 plus 100 observations
set obs 101

*generate a time variable running from 0 (starting/initial/base value) and 
*the sample from 1 to 100
gen t = _n-1
list t

*set t as the time-series 'counter'
tsset t

*set up et with all zero values to start
gen et = 0

*random number generator - set to whatever you like
set seed 45678

*replace  zero values with the generated values for the 100 obs in the sample
replace et = rnormal() if t>0

*summarize the data
sum et

*listing just the 100 obs in the sample
list t et in 2/101

*acf for the 100 obs in the sample (can experiment with different options for
*different 'look' of output)
ac et in 2/101, lags(20) recast(bar) 

set obs 101
gen x1t = 0
replace x1t = et if t>0

set obs 101
gen x3t = 0
replace x3t = 0.5*L.x3t + et if t>0

list t x1t x3t in 1/101

twoway connected x3t t, saving(x3plot, replace)
ac x3t in 2/101, lags(20) saving(x3acf, replace)
pac x3t in 2/101, lags(20) recast(bar) saving (x3pacf, replace)

*see help for the arima command
*see help for the wntestq options
*save residual from arima estimation as x3t_res
*wntestq x3t_res in 2/101, lags(???)

*etc.
*
