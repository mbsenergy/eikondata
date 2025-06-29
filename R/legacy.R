#' Download and Clean Time Series for RICs
#'
#' Downloads historical daily data for a list of RICs using `eikondata::get_rics_d()`,
#' fills missing calendar dates, and applies last observation carried forward (LOCF)
#' for missing values. Returns a unified data.table.
#'
#' @param list_tickers Character vector of RICs to download.
#' @param start_date Start date (`Date`) for the time series. Defaults to 5 years before today.
#' @param end_date End date (`Date`) for the time series. Defaults to today.
#'
#' @return A `data.table` with columns: `TIMESTAMP`, `VOLUME`, `PRICE`, and `RIC`, containing
#' merged and cleaned historical data for all requested tickers.
#'
#' @import data.table
#' @importFrom zoo na.locf
#' @export
#'
get_rics_cont = function(list_tickers, start_date = Sys.Date() - (365 * 5), end_date = Sys.Date()) {

  dt_list = lapply(list_tickers, function(tk) {

    Sys.sleep(2)

    dtw = eikondata::get_rics_d(tk, from_date = start_date, to_date = end_date)

    if (is.null(dtw) || nrow(dtw) == 0) return(NULL)

    full_dates = data.table(date = seq(min(dtw$date), max(dtw$date), by = "day"))

    dtw = merge(full_dates, dtw, by = "date", all.x = TRUE)

    dtw[, `:=`(
      volume = as.numeric(nafill(volume, type = "locf")),
      value  = as.numeric(nafill(value, type = "locf")),
      ric    = zoo::na.locf(ric, na.rm = FALSE)
    )]

    setnames(dtw, old = c("date", "ric", "value", "volume"),
             new = c("TIMESTAMP", "RIC", "PRICE", "VOLUME"))

    return(dtw)

  })

  dt = rbindlist(dt_list, use.names = TRUE, fill = TRUE)
  setDT(dt)

  setcolorder(dt, c("TIMESTAMP", "VOLUME", "PRICE", "RIC"))

  return(dt)

}
