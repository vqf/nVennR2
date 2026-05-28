## R CMD check results

0 errors | 0 warnings | 2 note

* This is a new release.

Two notes when running devtools::check():
1. Installed size is 5.4 Mb. Apparently, this is common with packages that
use Rcpp. 
2. Unable to verify current time. This seems to depend on devtools::check()
and gives inconsistent results.

Actions after first review:
1. Functions now feature "TRUE" instead of "T" and "FALSE" instead of "F".
2. Added a \value to nVennR2.Rd (using the @return tag in the corresponding
roxygen entry).
3. Avoided unsuppressible messages:
  3.1. Exchanged "cat" with "paste" inside warning at `setVennColor` function.
  3.2. Exchanged "Rcout" calls with "message()" calls at `nvSimulate` (not 
  exported), `estimateExhaustiveRunTime` and `nVennDiagram`.

I would like to thank the reviewer for clearly explaining the issues and the
solutions.