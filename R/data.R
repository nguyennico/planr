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
