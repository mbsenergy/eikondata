% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{products_continuation}
\alias{products_continuation}
\title{Continuation Codes for Power and Gas Commodities}
\format{
A `data.table` with 17 rows and 3 columns:
\describe{
  \item{COMMODITY}{Name of the commodity or market (character)}
  \item{c1}{Reuters front-month continuation ticker (character)}
  \item{c2}{Reuters second-month continuation ticker (character)}
}
}
\usage{
data(products_continuation)
}
\description{
Mapping of commodity names to their Reuters continuation ticker symbols for front-month (`c1`) and second-month (`c2`) futures contracts.
}
\details{
These continuation codes are used to retrieve continuous time series for futures contracts in Reuters/Eikon data services.
Includes both power markets (e.g., Germany, France) and gas markets (e.g., TTF, PSV, NBP).
}
\keyword{datasets}
