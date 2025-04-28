
[![MBSENERGY](https://img.shields.io/badge/MBS-ENERGY-037f8c?style=for-the-badge)](mbsconsulting.com)
[![Made with R](https://img.shields.io/badge/Made%20with-rstats-88c0d0?style=for-the-badge&logo=r)](https://cran.r-project.org/)


# eikondata <a href="https://mbsconsulting.com"><img src="man/figures/eikondata.png" align="right" height="180" /></a>

**R wrapper for LSEG Eikon Data API**

---

## Overview  
`eikondata` provides a streamlined interface for retrieving financial data from the LSEG Eikon Data platform directly within `R`. The package wraps around the Eikon API, allowing users to access historical time series and forward market data efficiently in `data.table` format.

---

## Prerequisites  

To use this R package, you must have:

- ✅ **A valid LSEG Eikon license**  
  Get one at [LSEG Eikon](https://customers.thomsonreuters.com/eikon/)
  
- ✅ **LSEG Eikon 4 Desktop** _or_ the **LSEG Eikon API Proxy**  
  For more information: [Eikon Web and Scripting APIs](https://developers.thomsonreuters.com/eikon-apis/eikon-web-and-scripting-apis-limited-access)

---

## Installation

Install the package using `remotes`:

````r
install.packages("remotes")
remotes::install_github("mbsenergy/eikondata")
````


## Getting Started
### 1. Set up environment
Start the Eikon Desktop or API Proxy and configure the API access in `R`:


````r
library(eikondata)
set_proxy_port(9000L)  # If using the proxy
set_app_id(Sys.getenv("REUTERS_KEY"))
````
### 2. Retrieve Market Data

````r
get_timeseries(
  rics = "TTFDA",
  fields = c("TIMESTAMP", "CLOSE"),
  start_date = "2024-01-01T00:00:00",
  end_date = "2024-01-10T00:00:00"
)

get_rics_f("FDBMJ5", from_date = "2023-01-01", to_date = "2023-12-31")

````

## Documentation
Full documentation is generated with `roxygen2` and available in the `man/` directory after building the package. Run:

````r
?get_rics_d
?get_rics_h
?get_rics_f
````
