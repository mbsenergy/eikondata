% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ric_generator.R
\name{generate_monthrics_pwr}
\alias{generate_monthrics_pwr}
\title{Generate Monthly RICs for Power Codes}
\usage{
generate_monthrics_pwr(selected_PWR_codes, time_range)
}
\arguments{
\item{selected_PWR_codes}{A character vector of selected power base codes (e.g., "PWRB").}

\item{time_range}{Numeric vector of years (e.g., 2024:2025).}
}
\value{
A data.table with columns `RIC` and `date` (YYYY-MM-01).
}
\description{
This function generates Reuters Instrument Codes (RICs) for monthly power contracts
based on the selected power codes and time range. It excludes quarterly and yearly codes.
}
\examples{
dt_monthly_rics <- generate_monthrics_pwr(c("PWRB"), 2025)
}
