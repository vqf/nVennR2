## R CMD check results

0 errors | 0 warnings | 2 note

* This is a new release.

Two notes when running devtools::check():
1. Installed size is 5.4 Mb. Apparently, this is common with packages that
use Rcpp. 
2. Unable to verify current time. This seems to depend on devtools::check()
and gives inconsistent results.

Changes since last version:

1. Added new citation.
2. Fixed a bug that affected function `setVennColor()`. Also added a test
to prevent future bugs of that type.