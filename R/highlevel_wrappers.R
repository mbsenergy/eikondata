## Eikon Wrappers -------------------------------------------------------------------------------------

#' Retrieve Spot Data for a Given Date Range
#'
#' @description This function retrieves spot data for a given RIC (identifier) and date range. It merges the data, performs necessary data cleaning and transformation.
#'
#' @param ric A string representing the RIC (identifier) for the spot data.
#' @param from_date A Date object or character string representing the start date of the data range.
#' @param to_date A Date object or character string representing the end date of the data range.
#' @param type Either PWR or GAS
#'
#' @return A data.table containing the spot price data (`date`, `smp`, and `RIC`) for the specified date range. The prices are cleaned by filling missing values.
#'
#'
#' @import data.table
#' @importFrom eikondata get_rics_d get_rics_h
#' @export
retrieve_spot = function(ric, from_date, to_date, type = 'PWR') {

  if(type == 'GAS') {

    rics_db = data.table::rbindlist(lapply(ric, eikondata::get_rics_d, from_date = from_date, to_date = to_date))
    data.table::setDT(rics_db)
    rics_db = rics_db[, .(date = as.Date(date), value = value, RIC = ric)]

    downloaded_spot = data.table::copy(rics_db)

    # Download and merge data for the given RIC
    # downloaded_spot = refenergy::merge_rics(ric)
    # downloaded_spot = downloaded_spot[, .(date = TIMESTAMP, trade_close = PRICE, RIC)]

    # Filter data from the 'from_date'
    history_gas_all_s = downloaded_spot[date >= from_date]
    data.table::setorderv(history_gas_all_s, cols = 'date', order = -1L)

    # Filter data until the 'to_date'
    history_gas_all_s = history_gas_all_s[date <= to_date]

    # Clean data (convert 'trade_close' to numeric and fill missing values)
    history_gas_all_s[, value := as.numeric(value)]
    history_gas_all_s[, value := data.table::nafill(value, 'locf'), by = 'RIC']
    history_gas_all_s[, value := data.table::nafill(value, 'nocb'), by = 'RIC']

    print_retrieval_done(message = 'Spot Gas retrieval finished.')

    return(history_gas_all_s)

  } else if(type == 'PWR') {

    rics_db = data.table::rbindlist(lapply(ric, eikondata::get_rics_h, from_date = from_date, to_date = to_date))
    data.table::setDT(rics_db)

    rics_db = rics_db[, .(date = as.Date(date), hour = hour, value = value, RIC = ric)]

    downloaded_spot = data.table::copy(rics_db)

    history_pwr_all_s = downloaded_spot[date >= from_date]
    data.table::setorderv(history_pwr_all_s, cols =c('date','hour'), order = -1L)

    history_pwr_all_s = history_pwr_all_s[date <= to_date]

    history_pwr_all_s[, value := as.numeric(value)]
    history_pwr_all_s[, value := data.table::nafill(value, 'locf'), by = 'RIC']
    history_pwr_all_s[, value := data.table::nafill(value, 'nocb'), by = 'RIC']

    history_pwr_all_s[, hour := as.numeric(hour)]
    history_pwr_all_s[, RIC := RIC]

    print_retrieval_done(message = 'Spot Power retrieval finished.')

    return(history_pwr_all_s)

  }

}


## Multiple Retrieve by Commodity Type -------------------------------------------------------------------------------------

#' Retrieve FWD Data for a Given Date Range
#'
#' @description This function retrieves gas spot data for a given RIC (identifier) and date range. It merges the data using `refenergy::merge_rics()` and performs necessary data cleaning and transformation.
#'
#' @param ric A string representing the RIC (identifier) for the spot data.
#' @param from_date A Date object or character string representing the start date of the data range.
#' @param to_date A Date object or character string representing the end date of the data range.
#'
#' @return A data.table containing the spot price data (`date`, `smp`, and `RIC`) for the specified date range. The prices are cleaned by filling missing values.
#'
#' @import data.table
#' @importFrom eikondata get_rics_f
#' @export
retrieve_fwd = function(ric, from_date, to_date) {

  rics_db = data.table::rbindlist(lapply(ric, eikondata::get_rics_f, from_date = from_date, to_date = to_date))
  data.table::setDT(rics_db)
  rics_db = rics_db[, .(date = as.Date(date), value, RIC = ric)]

  downloaded_fwd = data.table::copy(rics_db)

  # downloaded_RICS = refenergy::merge_rics(lst_rics)
  downloaded_fwd = downloaded_fwd[!(is.na(RIC)) & !(is.na(value))]
  downloaded_fwd = downloaded_fwd[downloaded_fwd[, .I[date == max(date)], by = RIC]$V1]

  print_retrieval_done(message = 'FWD retrieval finished.')

  return(downloaded_fwd)

}



## Continuation -------------------------------------------------------------------------------------

#' Retrieve Historical Continuation RICs from Eikon
#'
#' This function fetches daily historical time series data (close, volume) for a list of commodity continuation RICs
#' between specified dates using the `eikondata` package, and joins the results with metadata.
#'
#' @param list_continuation A character vector of basket commodities to include.
#' @param start_train Start date in 'YYYY-MM-DD' format.
#' @param end_train End date in 'YYYY-MM-DD' format.
#' @param cont c1 or c2.
#'
#' @return A data.table containing daily historical close and volume data for each continuation RIC with metadata.
#' @export
#'
#' @import data.table
retrieve_cont = function(list_continuation, start_train, end_train, cont = 'c1') {

  # Set Eikon API config
  # Filter continuation RICs by commodity
  list_cont_codes = eikondata::products_continuation[
    COMMODITY %in% list_continuation
  ]

  # Fetch time series per continuation RIC
  if(cont == 'c1') {cond_codes = list_cont_codes$c1} else {cond_codes = list_cont_codes$c2}

  list_cont = lapply(cond_codes, function(x) {
    tryCatch({
      DT = eikondata::get_timeseries(
        rics = x,
        fields = c("TIMESTAMP", "CLOSE", "VOLUME"),
        start_date = paste0(start_train, "T00:00:00"),
        end_date = paste0(end_train, "T00:00:00"),
        interval = "daily"
      )
      print_retrieval_message(rics = x, from_date = start_train, to_date = end_train, nrows = nrow(DT))
      setDT(DT)
    }, error = function(e) {
      message(sprintf("Failed to retrieve data for RIC: %s - %s", x, e$message))
      return(NULL)
    })
  })

  # Combine results
  dt_cont = rbindlist(list_cont, use.names = TRUE, fill = TRUE)
  colnames(dt_cont) = c("DATE", "VALUE", "VOLUME", "RIC")

  # Clean and convert columns
  dt_cont[, DATE := as.Date(sub("T.*", "", DATE))]
  dt_cont[, VALUE := as.numeric(VALUE)]
  dt_cont[, VOLUME := as.numeric(VOLUME)]

  # Join with metadata
  dt_cont = merge(
    melt(list_cont_codes, id.vars = "COMMODITY", variable.name = "TYPE", value.name = "RIC"),
    dt_cont,
    by = "RIC",
    all.y = TRUE
  )

  print_retrieval_done(message = 'Continuation retrieval finished.')

  return(dt_cont)

}




## Commenting -------------------------------------------------------------------------------------

#' Print Gas Retrieval Completion Message with Colors
#'
#' @description This function prints a message indicating that gas retrieval has finished. The message is formatted with colors using the `crayon` package.
#' @param message A character string representing the message to display after the ✔ symbol.
#'
#' @return Prints a formatted message to the console but does not return a value.
#'
#' @import crayon
#' @importFrom glue glue
#' @export
print_retrieval_done = function(message) {
  formatted_message = glue::glue("{crayon::green('✔')} {crayon::green$bold(message)}")
  cat(formatted_message, "\n")
}
