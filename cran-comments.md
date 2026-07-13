## R CMD check results

0 errors | 0 warnings | 2 note


Two notes when running devtools::check():
1. Installed size is 5.4 Mb. Apparently, this is common with packages that
use Rcpp. 
2. Unable to verify current time. This seems to depend on devtools::check()
and gives inconsistent results.

## Resubmission
This is a resubmision. In this version I have:

1. Eliminated unused and uninitialized variable, the likely cause of the
`gcc-UBSAN` failure.
2. Added graceful failure for rare unsolvable cases, the likely cause of the
`noLD` failure.