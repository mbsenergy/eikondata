devtools::load_all()
# install_flux_lseg()

set_proxy_port(9000L)
PLEASE_INSERT_REUTERS_KEY = Sys.getenv('REUTERS_KEY')
set_app_id(as.character(PLEASE_INSERT_REUTERS_KEY[1]))

options(eikondata.legacy = FALSE)


# .flux_env = new.env(parent = emptyenv())

# load_flux_module = function() {
#   if (!exists("flux", envir = .flux_env)) {
#     reticulate::use_virtualenv("fluxenv", required = TRUE)
#     .flux_env$flux = reticulate::import("fluxlseg")
#     .flux_env$flux$open_session(LSEG_KEY='0df86b690b2c4ae2bf245680dbbfcc86bb041dc9')
#   }
#   .flux_env$flux
# }

daily_data = get_rics_d(
  rics = "TTFDA",
  from_date = "2025-01-01",
  to_date = "2025-12-31"
)
print(daily_data)

daily_data = get_rics_d(
  rics = "TTFDA",
  from_date = "2025-01-01",
  to_date = "2025-12-31"
)
print(daily_data)


# reticulate::use_virtualenv("fluxenv", required = TRUE)
# flux = reticulate::import("fluxlseg")
# flux$open_session(LSEG_KEY='0df86b690b2c4ae2bf245680dbbfcc86bb041dc9')
# set_proxy_port(9000L)
# PLEASE_INSERT_REUTERS_KEY = Sys.getenv('REUTERS_KEY')
# set_app_id(as.character(PLEASE_INSERT_REUTERS_KEY[1]))

# dts = flux$get_rics_h(rics = "HEEGRAUCH", from_date = "2025-01-01", to_date = "2025-01-03")
# data.table::setDT(dts)
# dts

# Daily -----------------------------------------------------------

r_daily_data = get_rics_d(
  rics = "TTFDA",
  from_date = "2025-01-01",
  to_date = "2025-12-31",
  legacy = TRUE
)
print(r_daily_data)


# Hourly -----------------------------------------------------------

hourly_data <- get_rics_h(
  rics = "HEEGRAUCH",
  from_date = "2025-01-01",
  to_date = "2025-01-03"
)
print(hourly_data)

r_hourly_data <- get_rics_h(
  rics = "HEEGRAUCH",
  from_date = "2025-01-01",
  to_date = "2025-01-03",
  legacy = TRUE
)
print(r_hourly_data)


# Forward -----------------------------------------------------------

forward_data <- get_rics_f(
  rics = "F7BMN5",
  from_date = "2024-01-01",
  to_date = "2025-12-31"
)
print(forward_data)

r_forward_data <- get_rics_f(
  rics = "F7BMN5",
  from_date = "2024-01-01",
  to_date = "2025-12-31",
  legacy = TRUE
)
print(r_forward_data)


forward_data <- get_rics_f(
  rics = "FDBMF4^2",
  from_date = "2014-01-01",
  to_date = "2025-12-31"
)
print(forward_data)


# Continuation -----------------------------------------------------------
commodity_basket = c('Germany', 'C02', 'TTF')
cont_data = retrieve_cont(
  list_continuation = commodity_basket,
  start_train = '2024-04-21',
  end_train = '2025-04-21',
  cont = 'c1',
  legacy = FALSE
)
print(cont_data)

r_cont_data = retrieve_cont(
  list_continuation = commodity_basket,
  start_train = '2024-04-21',
  end_train = '2025-04-21',
  cont = 'c1',
  legacy = TRUE
)
print(r_cont_data)
