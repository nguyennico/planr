<!-- badges: start -->

[![CRAN Status](https://www.r-pkg.org/badges/version/planr)](https://cran.r-project.org/package=planr) [![CRAN Downloads](https://cranlogs.r-pkg.org/badges/grand-total/planr)](https://cranlogs.r-pkg.org/badges/grand-total/planr) [![CRAN download](https://cranlogs.r-pkg.org/badges/planr)](https://cran.r-project.org/package=planr)

<!-- badges: end -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

# planr <img src="man/figures/logo.png" align="right" height="200"/>

## About

The **planr** package is for **Supply Chain Management**.\
The goal is to provide some **functions to perform quickly** some classic operations in the scope of **Demand and Supply Planning** or to **run the S&OP** (Sales & Operations Planning) **process**.

There are currently 3 groups of functions :

-   Calculation & Analysis of projected inventories : **light_proj_inv()** / **proj_inv()** / **const_dmd()**

-   Calculation of Replenishment Plan (also called DRP) : **drp()**

-   Breakdown of Monthly Demand into Weekly Buckets : **month_to_week()**

To learn how to use those functions : refer to the section Get Started.

## Installation

To install the CRAN version:

``` r
#install.packages("planr")
library(planr)
```

To install the latest development version from GitHub:

``` r
library(devtools)
#install_github("nguyennico/planr")

library(planr)
```

## Get started

This section introduces the different functions of the package **planr** through :

-   a simple demo on a few items

-   an application on a product portfolio

Then, in the 3rd section we can find some examples of **shiny apps** using this package.

The goal of the **planr** package is to provide some **functions for the activity of Demand & Supply Planning and S&OP** (Sales & Operations Planning) process.

**A few functions to calculate projected inventories and coverages, and more :**

### Projected Inventories & Coverages

> The 1st, basic (light) function : **light_proj_inv()**

-   Allows to **calculate quickly the projected inventories and coverages**:

    -   for a SKU
    -   a group of SKUs
    -   at an aggregated level (a Product Family for example)

-   To use it :

    -   [A simple demo](https://rpubs.com/nikonguyen/light_proj_inv_simple_demo)

    -   [Portfolio Calculation](https://rpubs.com/nikonguyen/light_proj_inv_portfolio_demo)

![Calculated Projected Inventories using light_proj_inv()](docs/light_proj_inv_table.png)

### Calculation & Analysis

> The 2nd function : **proj_inv()**

-   Allows to calculate the projected inventories and coverages

    -   and also to **analyze the projected values based on some parameters (targeted stocks min & Max)**.

-   Useful to filter the data later on and spot which SKU is below the safety stock or in an overstock situation.

    -   We easily can identify when it will be in this situation
    -   and how much, compared to those thresholds

-   To use it :

    -   [A simple demo](https://rpubs.com/nikonguyen/proj_inv_simple_demo)

    -   [Portfolio Calculation](https://rpubs.com/nikonguyen/proj_inv_portfolio_calculation)

![Calculated Projected Inventories using proj_inv()](docs/proj_inv_table.png)

> The 3rd function : **const_dmd()**

-   Allows to calculate the projected inventories and coverages, as well as the **Constrained Demand**, which is the **Demand which can be delivered, considering the actual projected inventories**.

-   Useful to provide to a customer (or a receiving entity) the actual Demand which can be fulfilled, and then to calculate the impact on their side.

    -   For example if an Entity 1 supplies and Entity 2 : the Constrained Demand of the Entity 1 becomes the possible Supply Plan to the Entity 2. We then can calculate the expected projected inventories of the Entity 2.

    -   Another usage can be to manage some Allocations : we capture in the initial Demand the full potential of Sales, and based on the projected inventories, we get the Constrained Demand.

-   To use it : here a [demo](https://rpubs.com/nikonguyen/const_dmd_demo)

![Calculated Projected Inventories and Constrained Demand using const_dmd()](docs/const_dmd_table.png)

### Replenishment Plan

A function to calculate a Replenishment Plan (also called DRP : Distribution Requirement Planning).

> The 4th function : **drp()**

-   Based on some parameters (safety stocks, frequency of supply, minimum order quantity) allows to **calculate a Replenishment Plan for an entity**, for example at a Distributor level, and Affiliate, a Regional Distribution Center,...

-   Also **useful in the scope of the S&OP (Sales & Operations Planning) process, to calculate a theoretical, unconstrained, Replenishment Plan**.

-   To use it :

    -   [a simple demo](https://rpubs.com/nikonguyen/drp_demo)

    -   [Portfolio calculation](https://rpubs.com/nikonguyen/drp_portfolio_demo)

![Calculated Projected Inventories and Replenishment Plan using drp()](docs/drp_table.png)

### Conversion Monthly to Weekly Bucket

> The 5th function : **month_to_week()**

-   Allows to **convert a Demand initially in Monthly buckets into Weekly buckets**.

    -   By default, it assumes that the Demand is evenly distributed for each week (i.e. 25% of the Demand for each week of the month).

-   We often generate monthly sales forecasts, and want to express this quantity into weekly bucket, to use it later on for the calculation of weekly projected inventories or a DRP for example.

-   To use it : [RPubs - Transformation of Monthly Demand into Weekly Demand](https://rpubs.com/nikonguyen/month_to_week_demo)

## Links

-   R Views: [Using R in Inventory Management and Demand Forecasting](https://rviews.rstudio.com/2022/10/20/projected-inventory-calculations-using-r-1/)

-   Posit / RStudio Data Science Meetup : [Supply Chain Management](https://www.youtube.com/watch?v=rzs6aSr4XoU)

-   R Shiny app demo for projected inventories : [example of shiny app using the planr package](https://niconguyen.shinyapps.io/Projected_Inventories/)

-   ASCM : [S&OP and the Digital Supply Chain, using R & Python](https://www.ascm.org/ascm-insights/sop-and-the-digital-supply-chain/)

-   Get Started : [Demand and Supply Planning with R](https://rpubs.com/nikonguyen/972907)

-   DRP (Distribution Replenishment Planning) demo shiny app : [Demo DRP app (shinyapps.io)](https://niconguyen.shinyapps.io/DRP_Simulation_app/)

-   2 levels network demo shiny app : [2 Levels Network (shinyapps.io)](https://niconguyen.shinyapps.io/Two_Levels_Network/)

-   Portfolio Calculation of Projected Inventories : [RPubs - Demo Calculation Projected Inventories](https://rpubs.com/nikonguyen/projected_inventories_demo)
