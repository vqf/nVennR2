
[![R-hub](https://github.com/vqf/nVennR2/actions/workflows/rhub.yaml/badge.svg)](https://github.com/vqf/nVennR2/actions/workflows/rhub.yaml)

# nVennR2

This package offers an interface to the `nVenn2` algorithm to create generalized,
quasi-proportional Venn diagrams. The `nVenn2` algorithm differs substantially
from the [`nVenn`](https://github.com/vqf/nVennR) algorithm in that the time 
needed to produce a diagram scales
with the number of non-empty regions, rather than with the number of sets. In 
practice, this means that very complex diagrams can be generated with the 
second version much faster with `nVennR2` than with `nVennR`.

# Installation

```{r}
devtools::install_github("vqf/nVennR2")
```
If you want to use the vignette, install with:

```{r}
devtools::install_github("vqf/nVennR2", build_vignettes=TRUE)
```
To install from CRAN,

```{r}
install.packages('nVennR2', dependencies = T)
```

# Introduction

Proportional Venn diagrams show the relationships between several sets
in a compact representation. Each `set` is depicted as a contiguous area
proportional to the number of elements it contains, delimited by a
closed curve. Those curves may intersect, creating `regions` that belong
to one or more sets. To be accurate, the area of each region should be
proportional to the number of elements it contains.

Representing proportional Venn diagrams with more than two sets is not
trivial, as the number of potential regions grows exponentially with the
number of sets. The `nVenn` algorithm represents regions as circles with
the desired areas and then encloses those circles in curves to create
the sets. The resulting diagrams are approximately proportional and can
represent an arbitrary number of sets.

# Input

To make a Venn diagram, nVennR2 provides the `nVennDiagram` function.
Its input is either a list of lists, a text with the shape of a table or
a previously generated nVenn object.

## List of lists

This is the same form of input that the first version of nVennR2 used.
Each inner list has a name which is interpreted as the name of the set.
The inner list itself contains the elements in that set. The algorithm
accepts an arbitrary number of sets, although there is a hard limit in
the code of 20 sets. Diagrams of that size would take a very long time
to build, and probably would be of little use.

``` r
library(nVennR2)
exampledf
#> $SAS
#>  [1] "A001" "A003" "A004" "A005" "A006" "A008" "A011" "A012" "A013" "A014"
#> 
#> $PYTHON
#> [1] "A001" "A002" "A003" "A004" "A011" "A012" "A017" "A018"
#> 
#> $R
#>  [1] "A001" "A002" "A004" "A006" "A009" "A010" "A011" "A012" "A013" "A014"
#> [11] "A015" "A016"
```

``` r
myv <- nVennDiagram(exampledf)
#> Step 1 finished.
#> Step 2 finished.
#> Step 3 finished.
#> Step 4 finished.
#> Step 5 finished.
#> Step 6 finished.
#> Step 7 finished.
```


Each time the algorithm is used, the starting conditions are chosen
pseudorandomly. This means that executing `nVennDiagram` again on the
same data will result in a different plot.

``` r
myv <- nVennDiagram(exampledf, verbose = F)
```


This feature is very useful for more complex diagrams. It means that we
can run the diagram multiple times and choose which one best represents
the data. It also means that it is important to store the result of a
good diagram, as there is no guarantee that it may be reproduced. In the
examples, `myv` can be stored with `saveRDS` and recovered with
`readRDS`.

## Text

The native input for `nVenn2` is a text table. Sets can be defined in
rows or columns. If sets are in rows, the first column must contain set
names. If sets are in columns, the first row must contain the set names.
In most cases, `nVennDiagram` can guess if sets are in rows or columns.
Users can also make sure that this is correct by providing the `byCol`
parameter (1 means by column, 2 means by row).

``` r
toVenn <- 'Set1 Set2 Set3
a a b
b q d
c  e'
myv2 <- nVennDiagram(toVenn, byCol = 1, verbose = F)
```
If instead of a text table we pass an existing file path, `nVennDiagram`
will use the content of that file. This means that the file must be
text-only.

## Object

The function `nVennDiagram` also accepts an nVenn object from a previous
execution. In that case, it will generate a new Venn diagram with the
same data. As in previous cases, the resulting diagram will be different
than the previous one.

``` r
myv2 <- nVennDiagram(myv2, verbose = F)
```


# Listing elements

Once the diagram is ready, the object returned can be queried to
retrieve the elements in each region. A region will usually be
represented with a vector of names of the sets it belongs to. In the
example with `exampledf`, stored in `myv`, the sets are named `SAS`,
`PYTHON` and `R`. To find out which elements belong to `SAS` and `R`,
but not to `PYTHON`, the region will be `c('SAS', 'R')`.

``` r
getVennRegion(myv, c('SAS', 'R'))
#> [[1]]
#> [1] "A006"
#> 
#> [[2]]
#> [1] "A013"
#> 
#> [[3]]
#> [1] "A014"
```

We can also list all the elements by region.

``` r
listVennRegions(myv)
#> Region 1 (SAS):
#>  A005
#>  A008
#> Region 2 (PYTHON):
#>  A017
#>  A018
#> Region 3 (SAS, PYTHON):
#>  A003
#> Region 4 (R):
#>  A015
#>  A009
#>  A010
#>  A016
#> Region 5 (SAS, R):
#>  A006
#>  A013
#>  A014
#> Region 6 (PYTHON, R):
#>  A002
#> Region 7 (SAS, PYTHON, R):
#>  A001
#>  A004
#>  A011
#>  A012
```

# Appearance

There are several functions that modify the graphical parameters of the
Venn diagram. To see the result of the modifications, we must call
`plotVenn` afterwards. Most parameters can be accessed through
`setVennOpts` except for set colors, which can be edited with
`setVennPalette` and `setVennColor` or `setVennColors`. Finally, we can
set a list of options and apply them all at once with `setVennSkin`.

## Set graphical options

With `setVennOpts`, we can tweak the opacity of the fill of sets
(`opacity`), the size of the labels in the sets (`fontSize`), the width
of the line surrounding the sets (`lineWidth`), the color palette
(`palette`) and whether to show a description of each region
(`showRegions`) or the number of elements in each region
(`showWeights`).

``` r
myv2 <- setVennOpts(myv2, opacity = 0.2, lineWidth = 2, palette = 3, showRegions = F)
```

## Set colors

The most straightforward way to change a set color is by using
`setVennColor`. WARNING: colors must be formatted as [valid svg color
expressions](https://www.w3.org/TR/css-color-3/). If we pass an invalid
svg color, there may be unexpected results.

``` r
myv2 <- setVennColor(myv2, "Set2", 'black')
```


There are also functions to change several colors at once. First,
`nVenn` has four pre-packaged color palettes (`0`-`3`). The key to
understand the behavior of `nVennR2` is that it first applies a palette
and then individual colors. This means that set colors take precedence
over palettes. Therefore, if we now apply a different palette, `Set2`
will still be black.

``` r
myv2 <- setVennOpts(myv2, palette = 2)
```


To apply a palette and override set colors, we can use `setVennPalette`.
This also deletes any set color previously applied with `setVennColor`
or `setVennColors`.

``` r
myv2 <- setVennPalette(myv2, palette = 2)
```


The other way to change several colors at once is `setVennColors`. When
using this function, it is understood that we want to set a theme. That
is why this function resets any unspecified color to the palette we are
using. If a vector with svg colors is passed, they will be applied to
each set in the same order. If there are more sets than colors, the
remaining sets keep their previous color.

``` r
colorVector <- c("red", "grey")
myv2 <- setVennColors(myv2, colorVector)
```


This function also accepts a list, whose names must indicate set names.

``` r
colorList <- list(Set1="blue", Set3="#00ff11")
myv2 <- setVennColors(myv2, colorList)
```


Notice that the color of `Set2` has been reset to its default in palette
2.

## Set skin

Plots generated by `nVenn` have a defult graphical theme. In addition to
changing each parameter, we can define a custom theme and apply it at
once. To do this, we simply generate a list with all the parameters we
may want to set (those in `setVennOpts` plus `colors`) and use
`setVennSkin`. The logical way to use colors in this case is to pass a
vector, so that we can apply the theme to any diagram, regardless of the
names of the sets.

``` r
mytheme <- list(opacity=0.2, lineWidth=2, fontSize=16, showRegions=F, colors=c("red", "green", "blue", "black", "#ffff00"))
myv2 <- setVennSkin(myv2, mytheme)
myv <- setVennSkin(myv, mytheme)
```


## Rotate the diagram

We can also rotate the plot with `rotateVenn`. The angle is interpreted
in degrees and it is applied counterclockwise.

``` r
plotVenn(myv2)
myv2 <- rotateVenn(myv2, 30)
```

