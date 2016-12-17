# stratafied-random-sampling-

# Summary
Stratified sampling when your strata are not evenly divisible by the number of treatment groups you have can introduce non-random bias. This Stata do-file randomly assigns the population to 5 treatment groups across the stratified sample, and assigns the leftover individuals (because the number of strata is not divisible by 5) to one of the treatments, randomly.

# How to use it
You will require the Stata program, version 12 or higher, and your data saved as a .dta file.
Edit the do-file lines 15, 16, 17 to suit your project needs.
