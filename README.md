
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TCGAcatalogues

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/TCGAcatalogues)](https://CRAN.R-project.org/package=TCGAcatalogues)
[![Codecov test
coverage](https://codecov.io/gh/selkamand/TCGAcatalogues/branch/master/graph/badge.svg)](https://app.codecov.io/gh/selkamand/TCGAcatalogues?branch=master)
[![R-CMD-check](https://github.com/selkamand/TCGAcatalogues/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/selkamand/TCGAcatalogues/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

TCGAcatalogues is a data package containing each TCGA WGS dataset
cataloguesosed for SBS mutational signature analysis.

Original source of data is the TCGAmutations package, with catalogue
powered by sigminer.

## Installation

You can install the development version of TCGAcatalogues like so:

``` r
if (!require("pak", quietly = TRUE))
    install.packages("pak")

pak::pak("selkamand/TCGAcatalogues")
```

## Quick Start

List available datasets with `catalogues_available()`

Load datasets with `catalogues_load('dataset')`

``` r
library(TCGAcatalogues)
# List available datasets
catalogues_available()
#> # A tibble: 198 × 4
#>    dataset source type     genome
#>    <chr>   <chr>  <chr>    <chr> 
#>  1 ACC     MC3    DBS_1248 hg19  
#>  2 ACC     MC3    DBS_78   hg19  
#>  3 ACC     MC3    ID_83    hg19  
#>  4 ACC     MC3    SBS_1536 hg19  
#>  5 ACC     MC3    SBS_6    hg19  
#>  6 ACC     MC3    SBS_96   hg19  
#>  7 BLCA    MC3    DBS_1248 hg19  
#>  8 BLCA    MC3    DBS_78   hg19  
#>  9 BLCA    MC3    ID_83    hg19  
#> 10 BLCA    MC3    SBS_1536 hg19  
#> # ℹ 188 more rows

# Load datasets
catalogues_collection_acc <- catalogues_load('ACC')

# Load datasets as data.frames
catalogues_dataframe_acc <- catalogues_load('ACC', dataframe = TRUE)
```

## Citation

If you find TCGAcatalogues useful, please cite both *TCGAmutations*,
*sigminer*, and the relevant TCGA study (which you can find by running
`maftools::tcgaAvailable()`)
