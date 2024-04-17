#' blueprint
#'
#' This dataset contains the basic features to calculate projected inventories and coverages.
#' And also 2 additional info: a minimum and maximum targets of stock coverage.
#' We can apply on it the proj_inv() function, it will return calculated projected inventories and coverages as well as an analysis of the position of the projected inventories versus the minimum and maximum stocks targets.
#'
#' \itemize{
#'   \item DFU, an item
#'   \item Period, a date
#'   \item Demand, a consumption in units
#'   \item Opening, available inventories at the beginning in units
#'   \item Supply, a Replenishment Plan in units
#'   \item Min.Cov, a Minimum Stocks Targets in number of Periods
#'   \item Max.Cov, a Maximum Stocks Targets in number of Periods
#'
#' }
#'
#'
#' @name blueprint
#' @usage data(blueprint)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 520 rows and 7 variables
NULL




#' blueprint_light
#'
#' This dataset contains the basic features to calculate projected inventories and coverages.
#' Just 5 features are needed for this: a DFU, a Period, a Demand, an initial Opening Inventory and a Supply Plan.
#' We can apply on it the light_proj_inv() function, it will return calculated projected inventories and coverages.
#'
#' \itemize{
#'   \item DFU, an item
#'   \item Period, a date
#'   \item Demand, a consumption in units
#'   \item Opening, available inventories at the beginning in units
#'   \item Supply, a Replenishment Plan in units
#'
#' }
#'
#'
#' @name blueprint_light
#' @usage data(blueprint_light)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 520 rows and 5 variables
NULL




#' blueprint_drp
#'
#' This dataset contains the basic features to calculate a Replenishment Plan (also called DRP) and its related projected inventories and coverages.
#' We can apply on it the drp() function, it will return the calculated Replenishment Plan and its related projected inventories and coverages.
#'
#' \itemize{
#'   \item DFU, an item
#'   \item Period, a date
#'   \item Demand, a consumption in units
#'   \item Opening, available inventories at the beginning in units
#'   \item Supply, a Replenishment Plan in units
#'   \item FH, defines the Frozen and Free Horizon. It has 2 values: Frozen or Free. If Frozen : no calculation of Replenishment Plan yet, the calculation starts when the period is defined as Free. We can use this parameter to consider some defined productions plans or supplies (allocations, workorders,...) in the short-term for example.
#'   \item SSCov, the Safety Stock Coverage, expressed in number of periods
#'   \item DRPCovDur the Frequency of Supply, expressed in number of periods
#'   \item MOQ the Multiple Order Quantity, expressed in units, 1 by default or a Minimum Order Quantity
#'
#' }
#'
#'
#' @name blueprint_drp
#' @usage data(blueprint_drp)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 520 rows and 9 variables
NULL



#' demo_const_dmd
#'
#' This dataset contains the basic features to calculate projected inventories and coverages.
#' Just 5 features are needed for this: a DFU, a Period, a Demand, an initial Opening Inventory and a Supply Plan.
#' The idea is to use this dataset to calculate a constrained demand for each Product, on top of the projected inventories & coverages.
#' A constrained demand is a possible demand, which can be answered considering the projected inventories.
#' Then we can apply on this dataset the const_dmd() function, it will add 2 variables : a Constrained.Demand and a Current.Stock.Available.Tag .
#' The Constrained.Demand is the Demand which can be answered considering the projected inventories, i.e which quantity can be answered and when it can be answered.
#' The Current.Stock.Available.Tag informs the part of the Demand which is already covered by the Opening Inventories.
#'
#' \itemize{
#'   \item DFU, an item
#'   \item Period, a date
#'   \item Demand, a consumption in units
#'   \item Opening, available inventories at the beginning in units
#'   \item Supply, a Replenishment Plan in units
#'
#' }
#'
#'
#' @name demo_const_dmd
#' @usage data(demo_const_dmd)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 144 rows and 5 variables
NULL



#' demo_monthly_dmd
#'
#' This dataset contains a set of Monthly Demand for two Products.
#' There are 3 variables: a DFU, a Monthly Period, a Monthly Demand.
#' The idea is to use this dataset to convert the Demand from Monthly into Weekly bucket.
#' We can apply on this dataset the month_to_week() function, it will create a weekly bucket Period and convert the Demand from Monthly into Weekly bucket.
#'
#' \itemize{
#'   \item DFU, an item
#'   \item Period, a date in monthly format
#'   \item Demand, a consumption in units
#'
#' }
#'
#'
#' @name demo_monthly_dmd
#' @usage data(demo_monthly_dmd)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 24 rows and 3 variables
NULL



#' slob
#'
#' This dataset contains the detailed Opening Inventories for two Products.
#' There are 4 variables: a DFU, a Period, a Demand and the breakdown of the Opening Inventories by expiry date or minimum Remaining Shelf Life for use.
#' The idea is to use this dataset to calculate the Short Shelf Life quantities, called here SSL Qty.
#' We can apply on this dataset the ssl() function, it will calculate a SSL Qty field.
#'
#' \itemize{
#'   \item DFU, an item
#'   \item Period, a date in monthly format
#'   \item Demand, a consumption in units
#'   \item Opening, the breakdown of the opening inventories in units by expiry date
#'
#' }
#'
#'
#' @name slob
#' @usage data(slob)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 44 rows and 4 variables
NULL




#' demo_in_transit
#'
#' This dataset contains the detailed ETA and ETD for the current and next in transit, as well as the Transit Time for a defined DFU.
#' ETA stands for Estimated Time of Arrival.
#' ETD stands for Estimated Time of Departure.
#' There are 2 types of in transit : the current in transit and the next one, not yet shipped.
#' There are 6 variables in this dataset: a DFU, a Period, an ETA Current Goods In Transit, an ETD & ETA Next Goods In Transit, and a Transit Time.
#' Note that the diffrence between ETD and ETA is the Transit Time.
#' The idea is to use this dataset to project the Goods In Transit.
#' We can apply on this dataset the proj_git() function, it will calculate the Proj.GIT which gathers the current and next In Transit quantities.
#'
#' \itemize{
#'   \item DFU, a location and an item
#'   \item Period, a date in weekly bucket format
#'   \item ETA.Current, some quantities currently in transit displayed at their ETA date in units
#'   \item ETA.Next, some quantities to be shipped, not yet in transit, displayed at their ETA date in units
#'   \item ETD.Next, some quantities to be shipped, not yet in transit, displayed at their ETD date in units
#'   \item TLT, the Transit Lead Time, expressed in weeks, represents the difference between ETA and ETD dates
#'
#' }
#'
#'
#' @name demo_in_transit
#' @usage data(demo_in_transit)
#' @docType data
#' @author Nicolas Nguyen \email{nikonguyen@yahoo.fr}
#' @format A data frame with 447 rows and 6 variables
NULL

