
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TCGAdecomp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/TCGAdecomp)](https://CRAN.R-project.org/package=TCGAdecomp)
[![Codecov test
coverage](https://codecov.io/gh/selkamand/TCGAdecomp/branch/master/graph/badge.svg)](https://app.codecov.io/gh/selkamand/TCGAdecomp?branch=master)
[![R-CMD-check](https://github.com/selkamand/TCGAdecomp/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/selkamand/TCGAdecomp/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

TCGAdecomp is a data package containing each TCGA WGS dataset decomposed
for SBS mutational signature analysis.

Original source of data is the TCGAmutations package, with decomposition
powered by sigminer.

## Installation

You can install the development version of TCGAdecomp like so:

``` r
# install.packages('remotes')
remotes::install_github('selkamand/TCGAdecomp')
```

## Quick Start

List available datasets with `decomp_available()`

Load datasets with `decomp_load('dataset')`

``` r
library(TCGAdecomp)
# List available datasets
decomp_available()
#> # A tibble: 195 × 4
#>    dataset source   type     genome
#>    <chr>   <chr>    <chr>    <chr> 
#>  1 ACC     Firehose SBS_1536 hg19  
#>  2 ACC     Firehose SBS_6    hg19  
#>  3 ACC     Firehose SBS_96   hg19  
#>  4 ACC     MC3      SBS_1536 hg19  
#>  5 ACC     MC3      SBS_6    hg19  
#>  6 ACC     MC3      SBS_96   hg19  
#>  7 BLCA    Firehose SBS_1536 hg19  
#>  8 BLCA    Firehose SBS_6    hg19  
#>  9 BLCA    Firehose SBS_96   hg19  
#> 10 BLCA    MC3      SBS_1536 hg19  
#> # … with 185 more rows

# Load datasets
decomp_collection_acc <- decomp_load('ACC')

# Load datasets as data.frames
decomp_dataframe_acc <- decomp_load('ACC', dataframe = TRUE)
```

## Citation

If you find TCGAdecomp useful, please cite both *TCGAmutations*,
*sigminer*, and the relevant TCGA study (which you can find by running
`maftools::tcgaAvailable()`)
