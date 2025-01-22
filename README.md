# tsimgR <img src="man/figures/logo.png" align="right" height="220/"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
![NEPEMVERSE](https://img.shields.io/endpoint?url=https://nepemufsc.com/.netlify/functions/verser?project=tsimgR-stamp&label=LatestVersion:&labelColor=1278ce&logo=nepemverse&logoColor=white&style=metallic&color=#9e2621&cacheSeconds=3600)
[![CI](https://github.com/NEPEM-UFSC/tsimgR/actions/workflows/r.yml/badge.svg)](https://github.com/NEPEM-UFSC/tsimgR/actions/workflows/r.yml)
<!-- badges: end -->

## tsimgR: R Package for Dynamic and Interactive Export of Series Images

### Overview
tsimgR is an R package that facilitates the dynamic and interactive export of series images, allowing clear and accurate visualization of temporal and evolutionary data, by implementing _tsimg_
seamlessly into R.

_tsimg_ is a C++ application for the automatic creation of GIF, spice, and other image formats. This application can be easily integrated with various applications to create facilitated visualizations of temporal, evolutionary, and series images.

For more information, see tsimg documentation: [README](https://github.com/NEPEM-UFSC/tsimg/blob/main/README.md).

### Features:
- GIF Export: Create dynamic GIFs to represent the evolution of your data.

- Interactive Images: Generate interactive graphics with play buttons, sliders, and cursors to facilitate analysis and results exporting.

## Installation

You can install the development version of tsimgR from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("NEPEM-UFSC/tsimgR")
```
