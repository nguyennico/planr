# planr

<!-- badges: start -->

<!-- badges: end -->

The goal of planr is to provide some functions for the activity of Demand & Supply Planning and S&OP process:

-   to calculate projected inventories and coverages

-   to calculate and analyze projected inventories and coverages

-   to calculate a Replenishment Plan (also called DRP : Distribution Requirement Planning)

## Installation

You can install the development version of planr through github:

``` r

library(devtools)
install_github("nguyennico/planr")

library(planr)

```

## Examples

This is a basic example which shows you how to solve a common problem:

Let's create a demo database:

```{r}

Period <- c(
"1/1/2020", "2/1/2020", "3/1/2020", "4/1/2020", "5/1/2020", "6/1/2020", "7/1/2020", "8/1/2020", "9/1/2020", "10/1/2020", "11/1/2020", "12/1/2020","1/1/2021", "2/1/2021", "3/1/2021", "4/1/2021", "5/1/2021", "6/1/2021", "7/1/2021", "8/1/2021", "9/1/2021", "10/1/2021", "11/1/2021", "12/1/2021")

Demand <- c(360, 458,300,264,140,233,229,208,260,336,295,226,336,434,276,240,116,209,205,183,235,312,270,201)

Opening.Inventories <- c(1310,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

Supply.Plan <- c(0,0,0,0,0,2500,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)


# assemble
my_demand_and_suppply <- data.frame(Period,
                  Demand,
                  Opening.Inventories,
                  Supply.Plan)

# let's add a Product
my_demand_and_suppply$DFU <- "Product A"

# format the Period as a date
my_demand_and_suppply$Period <- as.Date(as.character(my_demand_and_suppply$Period), format = '%m/%d/%Y')


# let's have a look at it
my_demand_and_suppply



```

It contains some basic features:

-   a Product: it's an item, a SKU (Storage Keeping Unit), or a SKU at a location, also called a DFU (Demand Forecast Unit)

-   a Period of time : for example monthly or weekly buckets

-   a Demand : could be some sales forecasts, expressed in units

-   an Opening Inventory : what we hold as available inventories at the beginning of the horizon, expressed in units

-   a Supply Plan : the supplies that we plan to receive, expressed in units






### Calculation of Projected Inventories & Coverages


Let's apply the light_proj_inv(). 

We are going to calculate 2 new features for each DFU:

-   projected inventories

-   projected coverages, based on the Demand Forecasts





```{r}

# calculate
calculated_projection <- light_proj_inv(dataset = my_demand_and_suppply, 
                                        DFU = DFU, 
                                        Period = Period, 
                                        Demand =  Demand, 
                                        Opening.Inventories = Opening.Inventories, 
                                        Supply.Plan = Supply.Plan)

# see results
calculated_projection


```













