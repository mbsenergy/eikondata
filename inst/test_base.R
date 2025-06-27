library(data.table)
devtools::load_all()


# set_proxy_port(9000L)
# PLEASE_INSERT_REUTERS_KEY = Sys.getenv('REUTERS_KEY')
# set_app_id(as.character(PLEASE_INSERT_REUTERS_KEY[1]))

# cat(blue$bold("\nRunning tests for get_timeseries()...\n"))

# # Test 1: Basic function call
# cat(blue("\nTest 1: Basic function call with valid parameters...\n"))
# result <- get_timeseries(
#   rics = "TTFDA",
#   fields = c("TIMESTAMP", "CLOSE", "VOLUME"),
#   start_date = "2024-01-01T00:00:00",
#   end_date = "2024-01-10T00:00:00",
#   interval = "daily"
# )

# print(result)

# if (is.data.frame(result)) {
#   cat(green("✔ Test 1 passed: Function returned a data frame.\n"))
# } else {
#   cat(red("✖ Test 1 failed: Expected a data frame.\n"))
# }

# # Test 1: Basic function call
# cat(blue("\nTest 1: Basic function call with valid parameters...\n"))
# result <- get_timeseries(
#   rics = "HEEGRAUCH03",
#   fields = c("TIMESTAMP", "CLOSE", "VOLUME"),
#   start_date = "2020-01-01T00:00:00",
#   end_date = "2024-01-10T00:00:00",
#   interval = "daily"
# )

# print(result)

# if (is.data.frame(result)) {
#   cat(green("✔ Test 1 passed: Function returned a data frame.\n"))
# } else {
#   cat(red("✖ Test 1 failed: Expected a data frame.\n"))
# }

# # Test 2: Raw JSON output
# cat(blue("\nTest 2: Raw JSON output...\n"))
# result_json <- get_timeseries(
#   rics = "FDBYc1",
#   fields = c("TIMESTAMP", "CLOSE"),
#   start_date = "2024-01-01T00:00:00",
#   end_date = "2024-01-10T00:00:00",
#   interval = "daily",
#   raw_output = TRUE
# )

# print(result_json)

# if (is.character(result_json)) {
#   cat(green("✔ Test 2 passed: Raw output is a JSON string.\n"))
# } else {
#   cat(red("✖ Test 2 failed: Expected JSON format.\n"))
# }

# cat(blue$bold("\nAll tests completed.\n"))



cat(blue$bold("\nRunning tests for lowlevel()...\n"))

# Test 1: Retrieve Daily Historical Market Data
cat("\nTest 1: Retrieve Daily Historical Market Data\n")
daily_data <- get_rics_d(rics = "TTFDA", from_date = "2020-01-01", to_date = "2023-01-01")
print(daily_data)
# fwrite(daily_data, 'daily_data.csv')


# Test 2: Retrieve Hourly Time Series Data
cat("\nTest 2: Retrieve Hourly Time Series Data\n")
hourly_data <- get_rics_h(rics = "HEEGRAUCH", from_date = "2025-01-01", to_date = "2025-01-03")
print(head(hourly_data))
# fwrite(hourly_data, 'hourly_data.csv')


# Test 3: Retrieve Forward Market Data
cat("\nTest 3: Retrieve Forward Market Data\n")
forward_data <- get_rics_f(rics = "FDBMJ5", from_date = "2024-01-01", to_date = "2025-12-31")
print(forward_data)
# fwrite(forward_data, 'forward_data.csv')



cat(blue$bold("\nRunning tests for highlevel...\n"))

# Test 1: Retrieve Spot Gas Historical Market Data
cat("\nTest 1: Retrieve Spot Gas Historical Market Data\n")
spot_gas_data <- retrieve_spot(ric = "TTFDA", from_date = "2020-01-01", to_date = "2023-01-01", type = "GAS")
print(head(spot_gas_data))

# Test 2: Retrieve Spot Power Historical Market Data
cat("\nTest 2: Retrieve Spot Power Historical Market Data\n")
spot_pwr_data <- retrieve_spot(ric = "GMEIT", from_date = "2020-01-01", to_date = "2023-01-01", type = "PWR")
print(head(spot_pwr_data))

# Test 3: Retrieve Spot Power Historical Market Data
cat("\nTest 3: Retrieve FWD Data\n")
time_range = as.numeric(data.table::year(as.Date('2024-01-01'))):as.numeric(data.table::year(as.Date('2025-12-31')))
calendar = eikondata::calendar_holidays
calendar[,`:=` (year = as.character(data.table::year(date)), quarter = as.character(data.table::quarter(date)), month = as.character(data.table::month(date)))]

lst_rics_pwr = eikondata::generate_rics_pwr('Italy', time_range = time_range)

spot_fwd_data = eikondata::retrieve_fwd(ric = lst_rics_pwr, from_date = '2024-01-01', to_date = '2025-12-31')
print(head(spot_fwd_data))




# Test 4: Retrieve Continuation Historical Market Data
cat("\nTest 3: Retrieve Cont Data\n")
start_train = '2024-04-21'
end_train = '2025-04-21'

commodity_main = 'Italy'
commodity_basket = c('Germany', 'C02', 'TTF')
list_continuation = c(commodity_main, commodity_basket)
