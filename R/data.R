#' blueprint
#'
#' This dataset contains the basic features to calculate projected inventories and coverages and also 2 additional info: a minimum and maximum targets of stock coverage.
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


