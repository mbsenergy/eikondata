#' Safely Retrieve and Format RIC Time Series Data
#'
#' This function wraps `eikondata::get_rics_d()` with error handling and ensures
#' the returned data includes a complete daily sequence. It fills missing values
#' using last observation carried forward (LOCF) and standardizes column names.
#'
#' @param tk Character string. The RIC ticker to retrieve.
#' @param from_date Date. Start date of the time series.
#' @param to_date Date. End date of the time series.
#'
#' @return A `data.table` with columns: `TIMESTAMP`, `RIC`, `PRICE`, and `VOLUME`,
#'         or `NULL` if retrieval fails or no data is available.
#'
#' @export
safe_get_rics_d = function(tk, from_date, to_date) {
  tryCatch({
    dts = tryCatch({
      eikondata::get_rics_d(tk, from_date = from_date, to_date = to_date)
    }, error = function(e) {
      return(NULL)
    })

    if (is.null(dts) || nrow(dts) == 0) return(NULL)

    full_dates = data.table(date = seq(min(dts$date), max(dts$date), by = "day"))
    dtw = merge(full_dates, dts, by = "date", all.x = TRUE)

    dtw[, `:=`(
      volume = as.numeric(nafill(volume, type = "locf")),
      value  = as.numeric(nafill(value, type = "locf")),
      ric    = zoo::na.locf(ric, na.rm = FALSE)
    )]

    setnames(dtw, old = c("date", "ric", "value", "volume"),
             new = c("TIMESTAMP", "RIC", "PRICE", "VOLUME"))

    return(dtw)
  }, error = function(e) {
    return(NULL)
  })
}

#' Batch Retrieve and Format RIC Time Series Data
#'
#' Retrieves historical daily data for a list of RIC tickers using `safe_get_rics_d()`.
#' Each RIC is queried sequentially with a delay between calls. The result includes
#' complete daily time series with standardized columns.
#'
#' @param list_tickers Character vector. List of RIC tickers to retrieve.
#' @param start_date Date. Start date for retrieval (default: 5 years ago).
#' @param end_date Date. End date for retrieval (default: today).
#'
#' @return A list of `data.table`s (one per RIC) with columns:
#'         `TIMESTAMP`, `VOLUME`, `PRICE`, and `RIC`. Tickers with no data or errors return `NULL`.
#'
#' @export
merge_rics = function(list_tickers, start_date = Sys.Date() - (365 * 5), end_date = Sys.Date()) {

  dt_list = lapply(list_tickers, function(tk) {

    Sys.sleep(2)

    dt = safe_get_rics_d(tk, from_date = start_date, to_date = end_date)

    if (is.null(dt) || !all(c("TIMESTAMP", "RIC", "PRICE", "VOLUME") %in% names(dt))) {
      return(NULL)
    }

    setDT(dt)
    setcolorder(dt, c("TIMESTAMP", "VOLUME", "PRICE", "RIC"))
    return(dt)
  })

  # Filter out NULLs before binding
  dt_list = Filter(Negate(is.null), dt_list)

  if (length(dt_list) == 0) return(data.table())

  return(rbindlist(dt_list, use.names = TRUE, fill = TRUE))
}
