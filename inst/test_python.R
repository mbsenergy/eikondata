devtools::load_all()
install_flux_lseg()

set_proxy_port(9000L)
PLEASE_INSERT_REUTERS_KEY = Sys.getenv('REUTERS_KEY')
set_app_id(as.character(PLEASE_INSERT_REUTERS_KEY[1]))

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
daily_data = get_rics_d(rics = "TTFDA", from_date = "2025-01-01", to_date = "2025-12-31")
print(daily_data)

r_daily_data = get_rics_d(rics = "TTFDA", from_date = "2025-01-01", to_date = "2025-12-31", legacy = TRUE)
print(r_daily_data)



# Hourly -----------------------------------------------------------

hourly_data <- get_rics_h(rics = "HEEGRAUCH", from_date = "2025-01-01", to_date = "2025-01-03")
print(hourly_data)

r_hourly_data <- get_rics_h(rics = "HEEGRAUCH", from_date = "2025-01-01", to_date = "2025-01-03", legacy = TRUE)
print(r_hourly_data)



# Forward -----------------------------------------------------------

forward_data <- get_rics_f(rics = "F7BMN5", from_date = "2024-01-01", to_date = "2025-12-31")
print(forward_data)

r_forward_data <- get_rics_f(rics = "F7BMN5", from_date = "2024-01-01", to_date = "2025-12-31", legacy = TRUE)
print(r_forward_data)


forward_data <- get_rics_f(rics = "TFMBYZ7^1", from_date = "2014-01-01", to_date = "2025-12-31")
print(forward_data)
