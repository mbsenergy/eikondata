
# SETUP ----------------------------------------------------

box::use(data.table[...],
         magrittr[...])

devtools::load_all()


eikondata::set_proxy_port(9000L)
eikondata::set_app_id(as.character(Sys.getenv('REUTERS_KEY')))



# 0. Reuters  General ----------------------------------------
ric = 'GMEIT20'

dt_rics_d = eikondata::get_timeseries(ric, start_date = Sys.Date() - (365 * 10), end_date = Sys.Date(), interval = 'daily')


# 1. SPOT ----------------------------------------------------

## GAS ----------------
vec_gas = c("TTFDA", "TRITPSVDA", "TRGBNBPD1", "TRDENCGDA", "TRDENCBRM")
lst_spot_gas = lapply(vec_gas, retrieve_spot, from_date = '2017-01-01', to_date = '2024-12-31', type = 'GAS')
dt_spot_gas = rbindlist(lst_spot_gas)

saveRDS(dt_spot_gas, file = "data-raw/dt_spot_gas.rds")
usethis::use_data(dt_spot_gas, overwrite = TRUE)


## PWR ----------------
vec_pwr = c("HEEGRAUCH", "EHLDE", "HPXH", "PNX", "OMELES", "EHLGB", "GMEIT", "OPCOMRTR", "OTECZEUR")
lst_spot_pwr = lapply(vec_pwr, retrieve_spot, from_date = '2017-01-01', to_date = '2024-12-31', type = 'PWR')
dt_spot_pwr = rbindlist(lst_spot_pwr)

saveRDS(dt_spot_pwr, file = "data-raw/dt_spot_pwr.rds")
usethis::use_data(dt_spot_pwr, overwrite = TRUE)



# 1. FWD ----------------------------------------------------

time_range = as.numeric(data.table::year(as.Date('2017-01-01'))):as.numeric(data.table::year(as.Date('2024-12-31')))
calendar = eikondata::calendar_holidays
calendar[,`:=` (year = as.character(data.table::year(date)), quarter = as.character(data.table::quarter(date)), month = as.character(data.table::month(date)))]


## GAS ----------------
lst_rics_gas = eikondata::generate_rics_gas(unique(eikondata::gas_products_full$products_GAS_code), time_range = time_range)
dt_fwds_gas = eikondata::retrieve_fwd(ric = lst_rics_gas, from_date = '2017-01-01', to_date = '2024-12-31')

saveRDS(dt_fwds_gas, file = "data-raw/dt_fwds_gas.rds")
usethis::use_data(dt_fwds_gas, overwrite = TRUE)


## PWR ----------------
lst_rics_pwr = eikondata::generate_rics_pwr(eikondata::pwr_products_full$countries, time_range = time_range)
dt_fwds_pwr = eikondata::retrieve_fwd(ric = lst_rics_pwr, from_date = '2017-01-01', to_date = '2024-12-31')

saveRDS(dt_fwds_pwr, file = "data-raw/dt_fwds_pwr.rds")
usethis::use_data(dt_fwds_pwr, overwrite = TRUE)
