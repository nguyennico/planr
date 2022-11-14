#' Blueprint DRP Dataset
#'
#' @format ## `blueprint_drp`
#' A tibble with 520 rows and 9 columns:
#' \describe{
#'   \item{DFU}{An item, a SKU (Storage Keeping Unit), or a SKU at a location, also called a DFU (Demand Forecast Unit)}
#'   \item{Period}{For example monthly or weekly buckets}
#'   \item{Demand}{Could be some sales forecasts, expressed in units}
#'   \item{Opening.Inventories}{What we hold as available inventories at the beginning of the horizon, expressed in units}
#'   \item{Supply.Plan}{The supplies that we plan to receive, expressed in units}
#'   \item{DRP.Grid}
#'   \item{SSCov}
#'   \item{DRPCovDur}
#'   \item{Reorder.Qty}
#'   ...
#' }
"blueprint_drp"

#' Blueprint DRP Light
#'
#' @format ## `blueprint_light`
#' A tibble with 520 rows and 5 columns:
#' \describe{
#'   \item{DFU}{An item, a SKU (Storage Keeping Unit), or a SKU at a location, also called a DFU (Demand Forecast Unit)}
#'   \item{Period}{For example monthly or weekly buckets}
#'   \item{Demand}{Could be some sales forecasts, expressed in units}
#'   \item{Opening.Inventories}{What we hold as available inventories at the beginning of the horizon, expressed in units}
#'   \item{Supply.Plan}{The supplies that we plan to receive, expressed in units}
#'   ...
#' }
"blueprint_light"

#' Blueprint
#'
#' @format ## `blueprint`
#' A tibble with 520 rows and 7 columns:
#' \describe{
#'   \item{DFU}{An item, a SKU (Storage Keeping Unit), or a SKU at a location, also called a DFU (Demand Forecast Unit)}
#'   \item{Period}{For example monthly or weekly buckets}
#'   \item{Demand}{Could be some sales forecasts, expressed in units}
#'   \item{Opening.Inventories}{What we hold as available inventories at the beginning of the horizon, expressed in units}
#'   \item{Supply.Plan}{The supplies that we plan to receive, expressed in units}
#'   \item{Min.Stocks.Coverage}
#'   ...
#' }
"blueprint_light"
