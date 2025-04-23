library(data.table)
library(crayon)
library(jsonlite)
devtools::load_all()

set_proxy_port(9000L)
PLEASE_INSERT_REUTERS_KEY = Sys.getenv('REUTERS_KEY')
set_app_id(as.character(PLEASE_INSERT_REUTERS_KEY[1]))

cat(blue$bold("\nRunning tests for get_timeseries()...\n"))

# Test 1: Basic function call
cat(blue("\nTest 1: Basic function call with valid parameters...\n"))
result <- get_timeseries(
  rics = "TTFDA",
  fields = c("TIMESTAMP", "CLOSE", "VOLUME"),
  start_date = "2024-01-01T00:00:00",
  end_date = "2024-01-10T00:00:00",
  interval = "daily"
)

print(result)

if (is.data.frame(result)) {
  cat(green("✔ Test 1 passed: Function returned a data frame.\n"))
} else {
  cat(red("✖ Test 1 failed: Expected a data frame.\n"))
}

# Test 1: Basic function call
cat(blue("\nTest 1: Basic function call with valid parameters...\n"))
result <- get_timeseries(
  rics = "HEEGRAUCH03",
  fields = c("TIMESTAMP", "CLOSE", "VOLUME"),
  start_date = "2020-01-01T00:00:00",
  end_date = "2024-01-10T00:00:00",
  interval = "daily"
)

print(result)

if (is.data.frame(result)) {
  cat(green("✔ Test 1 passed: Function returned a data frame.\n"))
} else {
  cat(red("✖ Test 1 failed: Expected a data frame.\n"))
}

# Test 2: Raw JSON output
cat(blue("\nTest 2: Raw JSON output...\n"))
result_json <- get_timeseries(
  rics = "FDBYc1",
  fields = c("TIMESTAMP", "CLOSE"),
  start_date = "2024-01-01T00:00:00",
  end_date = "2024-01-10T00:00:00",
  interval = "daily",
  raw_output = TRUE
)

print(result_json)

if (is.character(result_json)) {
  cat(green("✔ Test 2 passed: Raw output is a JSON string.\n"))
} else {
  cat(red("✖ Test 2 failed: Expected JSON format.\n"))
}

cat(blue$bold("\nAll tests completed.\n"))



# Test 1: Retrieve Daily Historical Market Data
cat("\nTest 1: Retrieve Daily Historical Market Data\n")
daily_data <- get_rics_d(rics = "TTFDA", from_date = "2020-01-01", to_date = "2023-01-01")
print(head(daily_data))

# Test 2: Retrieve Hourly Time Series Data
cat("\nTest 2: Retrieve Hourly Time Series Data\n")
hourly_data <- get_rics_h(rics = "HEEGRAUCH", from_date = "2020-01-01", to_date = "2020-01-03")
print(head(hourly_data))

# Test 3: Retrieve Forward Market Data
cat("\nTest 3: Retrieve Forward Market Data\n")
forward_data <- get_rics_f(rics = "FDBMJ5", from_date = "2023-01-01", to_date = "2023-12-31")
print(head(forward_data))
