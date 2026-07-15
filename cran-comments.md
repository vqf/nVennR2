## R CMD check results

0 errors | 0 warnings | 2 note


Two notes when running devtools::check():
1. Installed size is 5.4 Mb. Apparently, this is common with packages that
use Rcpp. 
2. Unable to verify current time. This seems to depend on devtools::check()
and gives inconsistent results.

## Resubmission
This is a resubmision. In this version I have:

1. Initialized a second `bool` that was not immediately initialized, the likely 
cause of the `gcc-UBSAN` warning. I could reproduce the error with `r-debug` and
the change fixed it.
2. Spelled `TRUE` and `FALSE` at the tests, as per CRAN policy.