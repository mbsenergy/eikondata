#' Retrieve Daily Historical Market Data for a Given RIC
#'
#' @description
#' Fetches daily market data for a given Reuters Instrument Code (RIC) over a specified date range. The data is fetched from an external source using `get_timeseries()` and processed into a standardized `data.table`.
#'
#' @param rics A character string representing the RIC (identifier) for which historical data is to be retrieved.
#' @param from_date A Date object or character string specifying the start date for data retrieval. Defaults to 10 years before the current date.
#' @param to_date A Date object or character string specifying the end date for data retrieval. Defaults to the current date.
#'
#' @return A `data.table` containing the historical data for the specified RIC, with the following columns:
#' \itemize{
#'   \item \code{date} - The date of the observation (YYYY-MM-DD).
#'   \item \code{ric} - The RIC identifier.
#'   \item \code{value} - The closing price of the RIC.
#'   \item \code{volume} - The trading volume.
#' }
#'
#' If no data is available, the function returns an empty `data.table`.
#'
#' @details
#' This function:
#' \itemize{
#'   \item Calls `get_timeseries()` to fetch market data for the specified RIC.
#'   \item Removes unnecessary columns (`HIGH`, `LOW`, `OPEN`, `COUNT`).
#'   \item Converts the `DATE` column to the `YYYY-MM-DD` format.
#'   \item Orders the dataset by `DATE`.
#'   \item Prints a message summarizing the data retrieval.
#' }
#'
#' @examples
#' \dontrun{
#' data <- get_rics_d("TTFDA", from_date = "2020-01-01", to_date = "2023-01-01")
#' }
#'
#' @import data.table
#' @export
get_rics_d = function(rics, from_date = Sys.Date() - (365 * 10), to_date = Sys.Date()) {

  data_fields = c("TIMESTAMP", "CLOSE", "VOLUME")
  interval_field = 'daily'
  start_date = paste0(from_date, 'T00:00:00')
  end_date = paste0(to_date, 'T00:00:00')

  # Download Data
  db = lapply(rics, function(x) {
    result <- get_timeseries(
      rics = x,
      fields = data_fields,
      start_date = start_date,
      end_date = end_date,
      interval = interval_field
    )
    # print(result)
    Sys.sleep(2)
    return(result)
  })

  db = rbindlist(db, use.names = TRUE, fill = TRUE)

  # Rename and process columns
  colnames(db) = c('DATE', 'CLOSE','VOLUME', 'RIC')
  setDT(db)

  db[, DATE := substr(DATE, 1, 10)]

  colnames(db) = c('DATE', 'VALUE', 'VOLUME', 'RIC')
  db[, VALUE := as.numeric(VALUE)]
  db[, VOLUME := as.numeric(VOLUME)]
  setcolorder(db, c('DATE', 'RIC', 'VALUE', 'VOLUME'))

  # Order data
  data.table::setorderv(db, cols = c('DATE'), order = 1L)
  colnames(db) = tolower(names(db))

  # Print retrieval message
  rows_count = nrow(db)
  Sys.sleep(2)
  print_retrieval_message(rics = rics, from_date = from_date, to_date = to_date, nrows = rows_count)

  return(db)
}



#' Retrieve Hourly Time Series Data for a Given RIC
#'
#' @description
#' This function retrieves 24-hour time series data for a given Reuters Instrument Code (RIC) by fetching individual hourly data. It returns a `data.table` with structured hourly data for the specified date range.
#'
#' @param rics A character string representing the base RIC (without the hour suffix) for which the data is to be retrieved.
#' @param from_date A character or Date object representing the start date for data retrieval (default: 10 years ago).
#' @param to_date A character or Date object representing the end date for data retrieval (default: today).
#' @param interval A character string representing the data frequency. Defaults to `"daily"`, but is internally ignored for hourly data.
#' @param sleep A numeric value specifying the time (in seconds) to wait between API calls (default: 0).
#'
#' @return A `data.table` containing the 24-hour data for the specified RIC, with the following columns:
#' \itemize{
#'   \item \code{date} - Date of the observation (YYYY-MM-DD).
#'   \item \code{hour} - Hour of the day (integer from 1 to 24).
#'   \item \code{ric} - The base RIC identifier.
#'   \item \code{value} - The retrieved value for the RIC.
#'   \item \code{volume} - Trading volume or relevant metric.
#' }
#'
#' @details
#' This function constructs RICs for each of the 24 hours by appending `01` to `24` to the base RIC.
#' It retrieves the data, processes it into a unified table, and returns a `data.table` with hourly observations.
#' If not all 24 hours are present, a warning is issued.
#'
#' @note If not all 24 hours are present in the dataset, a warning is issued.
#'
#' @examples
#' \dontrun{
#' get_rics_h("HEEGRAUCH", from_date = "2020-01-01", to_date = "2023-01-01")
#' }
#'
#' @import data.table
#' @export
get_rics_h = function(rics, from_date = Sys.Date() - (365 * 10), to_date = Sys.Date()) {

  rics_id_24 = c('01','02','03','04','05','06','07','08','09','10','11','12',
                 '13','14','15','16','17','18','19','20','21','22','23','24')
  rics_id_h = paste0(rics, rics_id_24)

  # Format dates
  data_fields = c("TIMESTAMP", "CLOSE", "VOLUME")
  interval_field = 'daily'
  start_date = paste0(from_date, 'T00:00:00')
  end_date = paste0(to_date, 'T00:00:00')

  # Fetch data
  db = lapply(rics_id_h, function(x) {
    result <- get_timeseries(
      rics = x,
      fields = data_fields,
      start_date = start_date,
      end_date = end_date,
      interval = interval_field
    )
    # print(result)
    Sys.sleep(5)
    return(result)
  })

  # Combine results
  db_24h = rbindlist(db, use.names = TRUE, fill = TRUE)
  colnames(db_24h) = c('DATE', 'VALUE', 'VOLUME', 'RIC_H')

  db_24h[, DATE := substr(DATE, 1, 10)]
  db_24h[, HOUR := as.integer(substr(RIC_H, nchar(RIC_H) - 1, nchar(RIC_H)))]
  db_24h[, RIC := rics]
  db_24h[, RIC_H := NULL]
  db_24h[, VALUE := as.numeric(VALUE)]
  db_24h[, VOLUME := as.numeric(VOLUME)]

  setcolorder(db_24h, c('DATE', 'HOUR', 'RIC', 'VALUE', 'VOLUME'))

  # Order data
  data.table::setorderv(db_24h, cols = c('DATE','HOUR'), order = 1L)
  colnames(db_24h) = tolower(names(db_24h))

  # Check if all 24 hours are present
  if (uniqueN(db_24h$hour) < 24) {
    warning("Not all 24 hours are present in the data.")
  }

  # Print retrieval message
  rows_count = nrow(db_24h)
  Sys.sleep(5)
  print_retrieval_message(rics = rics, from_date = from_date, to_date = to_date, nrows = rows_count)

  return(db_24h)
}


#' Retrieve Forward Market Data for a Given RIC
#'
#' @description
#' Fetches forward market data for a specified RIC (identifier) within a given date range, processes it, and returns the data in a standardized `data.table`.
#'
#' @param rics A character string representing the RIC (identifier) whose forward market data is to be retrieved.
#' @param from_date A Date object or character string representing the start date for data retrieval. Defaults to 10 years before the current date.
#' @param to_date A Date object or character string representing the end date for data retrieval. Defaults to the current date.
#'
#' @return A `data.table` containing the forward market data, with the following columns:
#' \itemize{
#'   \item \code{date} - The date of the forward contract.
#'   \item \code{ric} - The RIC identifier.
#'   \item \code{value} - The forward contract price.
#'   \item \code{volume} - The trading volume.
#' }
#'
#' If no data is available, the function returns a `data.table` with `NA` values for `value` and `volume`.
#'
#' @details
#' This function:
#' \itemize{
#'   \item Fetches forward market data for the specified RIC using `get_timeseries()`.
#'   \item Handles cases where no data is found by returning a `data.table` filled with `NA` values.
#'   \item Renames and processes columns to standardize the format.
#'   \item Converts the `DATE` column to `YYYY-MM-DD` format.
#'   \item Orders the data chronologically by `DATE`.
#' }
#'
#' @examples
#' \dontrun{
#' data <- get_rics_f("FDBMJ5", from_date = "2023-01-01", to_date = "2023-12-31")
#' }
#'
#' @import data.table
#' @export
get_rics_f = function(rics, from_date = Sys.Date() - (365 * 10), to_date = Sys.Date()) {

  start_date = paste0(from_date, 'T00:00:00')
  end_date = paste0(to_date, 'T00:00:00')

  # Download Data
  db = get_timeseries(
    rics = list(rics),
    fields = list('TIMESTAMP', 'CLOSE', 'VOLUME'),
    start_date = start_date,
    end_date = end_date,
    interval = "daily"
  )

  if (is.null(db) || nrow(db) == 0 || all(is.na(db[[1]]))) {
    warning(sprintf("No valid data found for RIC: %s", rics))
    db = data.table(date = NA_character_, ric = rics, value = NA_real_, volume = NA_real_)
    print_retrieval_message(rics = rics, from_date = 'NO DATA', to_date = 'NO DATA', nrows = 'NO DATA')
  } else {

    # Rename and process columns
    colnames(db) = c('DATE', 'CLOSE', 'VOLUME', 'RIC')
    setDT(db)

    db[, DATE := substr(DATE, 1, 10)]

    colnames(db) = c('DATE', 'VALUE', 'VOLUME', 'RIC')
    db[, VALUE := as.numeric(VALUE)]
    db[, VOLUME := as.numeric(VOLUME)]
    setcolorder(db, c('DATE', 'RIC', 'VALUE', 'VOLUME'))

    # Order data
    data.table::setorderv(db, cols = c('DATE'), order = 1L)
    colnames(db) = tolower(names(db))

    # Print retrieval message
    rows_count = nrow(db)
    Sys.sleep(5)
    print_retrieval_message(rics = rics, from_date = from_date, to_date = to_date, nrows = rows_count)

  }

  return(db)

}
