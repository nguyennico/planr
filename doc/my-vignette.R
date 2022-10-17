## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(devtools)
install_github("nguyennico/planr")
library(planr)

## -----------------------------------------------------------------------------

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




## -----------------------------------------------------------------------------

# calculate
calculated_projection <- light_proj_inv(dataset = my_demand_and_suppply, 
                                        DFU = DFU, 
                                        Period = Period, 
                                        Demand =  Demand, 
                                        Opening.Inventories = Opening.Inventories, 
                                        Supply.Plan = Supply.Plan)

# see results
calculated_projection



## -----------------------------------------------------------------------------

library(reactable)
library(reactablefmtr)

library(dplyr)


## -----------------------------------------------------------------------------

# set a working df
df1 <- calculated_projection

# keep only the needed columns
df1 <- df1 %>% select(Period,
                      Demand,
                      Calculated.Coverage.in.Periods,
                      Projected.Inventories.Qty,
                      Supply.Plan)


# create a f_colorpal field
df1 <- df1 %>% mutate(f_colorpal = case_when( Calculated.Coverage.in.Periods > 8 ~ "#FFA500",
                                              Calculated.Coverage.in.Periods > 2 ~ "#32CD32",
                                              Calculated.Coverage.in.Periods > 0 ~ "#FFFF99",
                                              TRUE ~ "#FF0000" ))



# create reactable
reactable(df1, resizable = TRUE, showPageSizeOptions = TRUE,

              striped = TRUE, highlight = TRUE, compact = TRUE,
              defaultPageSize = 20,

              columns = list(


                Demand = colDef(
                  name = "Demand (units)",

                  cell = data_bars(df1,
                                   fill_color = "#3fc1c9",
                                   text_position = "outside-end"
                  )

                ),




              Calculated.Coverage.in.Periods = colDef(
                name = "Coverage (Periods)",
                maxWidth = 90,
                cell= color_tiles(df1, color_ref = "f_colorpal")
              ),


              f_colorpal = colDef(show = FALSE), # hidden, just used for the coverages



                `Projected.Inventories.Qty`= colDef(
                  name = "Projected Inventories (units)",
                  format = colFormat(separators = TRUE, digits=0),

                  style = function(value) {
                    if (value > 0) {
                      color <- "#008000"
                    } else if (value < 0) {
                      color <- "#e00000"
                    } else {
                      color <- "#777"
                    }
                    list(color = color
                         #fontWeight = "bold"
                    )
                  }
                ),




              Supply.Plan = colDef(
                name = "Supply (units)",
                cell = data_bars(df1,
                                 fill_color = "#3CB371",
                                 text_position = "outside-end"
                                 )
                )





              ), # close columns lits

              columnGroups = list(
                colGroup(name = "Projected Inventories", columns = c("Calculated.Coverage.in.Periods",
                                                                     "Projected.Inventories.Qty"))


              )

    ) # close reactable





## -----------------------------------------------------------------------------

my_data_with_parameters <- my_demand_and_suppply

my_data_with_parameters$Min.Stocks.Coverage <- 2
my_data_with_parameters$Max.Stocks.Coverage <- 4

my_data_with_parameters


## -----------------------------------------------------------------------------

df1 <- proj_inv(data = my_data_with_parameters, 
                DFU = DFU, 
                Period = Period, 
                Demand =  Demand, 
                Opening.Inventories = Opening.Inventories, 
                Supply.Plan = Supply.Plan,
                Min.Stocks.Coverage = Min.Stocks.Coverage, 
                Max.Stocks.Coverage = Max.Stocks.Coverage)

df1


## -----------------------------------------------------------------------------

df1 <- my_demand_and_suppply

df1$SSCov <- 2
df1$DRPCovDur <- 3
df1$Reorder.Qty <- 1
df1$DRP.Grid <- c("Frozen",
                  "Frozen",
                  "Frozen",
                  "Frozen",
                  "Frozen",
                  "Frozen",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free",
                  "Free")


df1


## -----------------------------------------------------------------------------

demo_drp <- drp(data = df1,
           DFU = DFU,
           Period = Period,
           Demand =  Demand,
           Opening.Inventories = Opening.Inventories,
           Supply.Plan = Supply.Plan,
           SSCov = SSCov,
           DRPCovDur = DRPCovDur,
           Reorder.Qty = Reorder.Qty,
           DRP.Grid = DRP.Grid
)


demo_drp


## -----------------------------------------------------------------------------

# set a working df
df1 <- demo_drp

# keep only the needed columns
df1 <- df1 %>% select(Period,
                      Demand,
                      DRP.Calculated.Coverage.in.Periods,
                      DRP.Projected.Inventories.Qty,
                      DRP.plan)


# replace missing values by zero
df1$DRP.plan[is.na(df1$DRP.plan)] <- 0
df1$DRP.Projected.Inventories.Qty[is.na(df1$DRP.Projected.Inventories.Qty)] <- 0

# create a f_colorpal field
df1 <- df1 %>% mutate(f_colorpal = case_when( DRP.Calculated.Coverage.in.Periods > 8 ~ "#FFA500",
                                              DRP.Calculated.Coverage.in.Periods > 2 ~ "#32CD32",
                                              DRP.Calculated.Coverage.in.Periods > 0 ~ "#FFFF99",
                                              TRUE ~ "#FF0000" ))



# create reactable
reactable(df1, resizable = TRUE, showPageSizeOptions = TRUE,

              striped = TRUE, highlight = TRUE, compact = TRUE,
              defaultPageSize = 20,

              columns = list(


                Demand = colDef(
                  name = "Demand (units)",

                  cell = data_bars(df1,
                                   fill_color = "#3fc1c9",
                                   text_position = "outside-end"
                  )

                ),




              DRP.Calculated.Coverage.in.Periods = colDef(
                name = "Coverage (Periods)",
                maxWidth = 90,
                cell= color_tiles(df1, color_ref = "f_colorpal")
              ),


              f_colorpal = colDef(show = FALSE), # hidden, just used for the coverages



                `DRP.Projected.Inventories.Qty`= colDef(
                  name = "Projected Inventories (units)",
                  format = colFormat(separators = TRUE, digits=0),

                  style = function(value) {
                    if (value > 0) {
                      color <- "#008000"
                    } else if (value < 0) {
                      color <- "#e00000"
                    } else {
                      color <- "#777"
                    }
                    list(color = color
                         #fontWeight = "bold"
                    )
                  }
                ),




              DRP.plan = colDef(
                name = "Replenishment (units)",
                cell = data_bars(df1,
                                 fill_color = "#3CB371",
                                 text_position = "outside-end"
                                 )
                )





              ), # close columns lits

              columnGroups = list(
                colGroup(name = "Projected Inventories", columns = c("DRP.Calculated.Coverage.in.Periods",
                                                                     "DRP.Projected.Inventories.Qty"))


              )

    ) # close reactable





