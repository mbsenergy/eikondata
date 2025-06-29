.onLoad <- function(libname, pkgname) {
  # Suppress startup messages for specific packages
  suppressPackageStartupMessages({
    require(data.table)
    require(crayon)
  })

  # Create a colorful message
  cat(crayon::cyan("Eikon Data.\n"))
  cat(crayon::yellow("Version: 1.1.0\n"))
  cat(crayon::yellow("Author: Eleonora Gasparri & Alejandro Abraham\n"))
  cat(crayon::yellow("Reproduction and distribution are forbidden by license.\n"))

}

.flux_env = new.env(parent = emptyenv())

load_flux_module = function() {
  if (!exists("flux", envir = .flux_env)) {
    reticulate::use_virtualenv("fluxenv", required = TRUE)
    .flux_env$flux = reticulate::import("fluxlseg")
    .flux_env$flux$open_session(LSEG_KEY='0df86b690b2c4ae2bf245680dbbfcc86bb041dc9')
  }
  .flux_env$flux
}

