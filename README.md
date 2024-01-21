<!-- badges: start -->

[![CRAN Status](https://www.r-pkg.org/badges/version/planr)](https://cran.r-project.org/package=planr) [![CRAN Downloads](https://cranlogs.r-pkg.org/badges/grand-total/planr)](https://cranlogs.r-pkg.org/badges/grand-total/planr) [![CRAN download](https://cranlogs.r-pkg.org/badges/planr)](https://cran.r-project.org/package=planr)

<!-- badges: end -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

# planr <img src="man/figures/logo.png" align="right" height="200"/>

The goal of planr is to provide some functions for the activity of Demand & Supply Planning and S&OP process.

[**A few functions to calculate projected inventories and coverages, and more :**]{style="color:green"}

-   The 1st, basic (light) function : [light_proj_inv()]{style="color:red"} [**light_proj_inv()**]{style="color:blue"}

Allows to **calculate quickly the projected inventories and coverages**: for a SKU, a group of SKUs, or at an aggregated level (a Product Family for example).

-   The 2nd function : [**proj_inv()**]{style="color:blue"}

Allows to calculate the projected inventories and coverages, and also to **analyze the projected values based on some parameters (targeted stocks min & Max)**.

Useful to filter the data later on and spot which SKU is below the safety stock or in an overstock situation. We easily can identify when it will be in this situation, and how much, compared to those thresholds.

-   The 3rd function : [**const_dmd()**]{style="color:blue"}

Allows to calculate the projected inventories and coverages, as well as the **Constrained Demand**, which is the **Demand which can be delivered, considering the actual projected inventories**.

Useful to provide to a customer (or a receiving entity) the actual Demand which can be fulfilled, and then to calculate the impact on their side.

For example if an Entity 1 supplies and Entity 2 : the Constrained Demand of the Entity 1 becomes the possible Supply Plan to the Entity 2. We then can calculate the expected projected inventories of the Entity 2.

Another usage can be to manage some Allocations : we capture in the initial Demand the full potential of Sales, and based on the projected inventories, we get the Constrained Demand.

[**A function to calculate a Replenishment Plan (also called DRP : Distribution Requirement Planning)**]{style="color:green"}

-   The 4th function : [**drp()**]{style="color:blue"}

Based on some parameters (safety stocks, frequency of supply, minimum order quantity) allows to **calculate a Replenishment Plan for an entity**, for example at a Distributor level, and Affiliate, a Regional Distribution Center,...

Also **useful in the scope of the S&OP (Sales & Operations Planning) process, to calculate a theoretical, unconstrained, Replenishment Plan**.

[**A function to convert the Demand from Monthly to Weekly buckets**]{style="color:green"}

-   The 5th function : [**month_to_week()**]{style="color:blue"}

Allows to **convert a Demand initially in Monthly buckets into Weekly buckets**.

By default, it assumes that the Demand is evenly distributed for each week (i.e. 25% of the Demand for each week of the month).

We often generate monthly sales forecasts, and want to express this quantity into weekly bucket, to use it later on for the calculation of weekly projected inventories or a DRP for example.

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

## How to use

Please refer to the sections:

-   Get Started

-   See some examples of applications

## Links

-   R Views: [Using R in Inventory Management and Demand Forecasting](https://rviews.rstudio.com/2022/10/20/projected-inventory-calculations-using-r-1/)

-   Posit / RStudio Data Science Meetup : [Supply Chain Management](https://www.youtube.com/watch?v=rzs6aSr4XoU)

-   R Shiny app demo for projected inventories : [example of shiny app using the planr package](https://niconguyen.shinyapps.io/Projected_Inventories/)

-   ASCM : [S&OP and the Digital Supply Chain, using R & Python](https://www.ascm.org/ascm-insights/sop-and-the-digital-supply-chain/)

-   Get Started : [Demand and Supply Planning with R](https://rpubs.com/nikonguyen/972907)

-   DRP (Distribution Replenishment Planning) demo shiny app : [Demo DRP app (shinyapps.io)](https://niconguyen.shinyapps.io/DRP_Simulation_app/)

-   2 levels network demo shiny app : [2 Levels Network (shinyapps.io)](https://niconguyen.shinyapps.io/Two_Levels_Network/)

-   Portfolio Calculation of Projected Inventories : [RPubs - Demo Calculation Projected Inventories](https://rpubs.com/nikonguyen/projected_inventories_demo)
