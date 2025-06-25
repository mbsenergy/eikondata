#' Install the `flux_lseg` Python Package in a Virtual Environment
#'
#' Installs the bundled `flux_lseg` Python package (provided as a `.tar.gz` file
#' under `inst/python/`) into a Python virtual environment using the `reticulate` package.
#'
#' @param env Optional. The name or path of an existing Python virtual environment.
#' If `NULL`, a new virtual environment named `"fluxenv"` is created using the default Python.
#'
#' @return No return value. The function performs the installation as a side effect and prints a success message.
#'
#' @details
#' The function expects the `flux_lseg` Python package archive (`fluxlseg-0.1.0.tar.gz`) to be
#' included in the R package under `inst/python/`. It uses `reticulate::virtualenv_install()` to
#' install the package via `pip`.
#'
#' Python 3 must be available. You can specify the Python path by setting the `RETICULATE_PYTHON`
#' environment variable or using `reticulate::use_python()` prior to calling this function.
#'
#' @importFrom reticulate virtualenv_create virtualenv_install
#' @export
install_flux_lseg <- function(env = NULL) {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    stop("The 'reticulate' package is required.")
  }

  pkg_path = system.file("python/fluxlseg-0.2.0.tar.gz", package = "eikondata")

  if (pkg_path == "") {
    stop("fluxlseg tar.gz not found in installed package. Ensure it exists in inst/python/")
  }

  if (is.null(env)) {
    env = reticulate::virtualenv_create("fluxenv")
  }

  print('OK')

  reticulate::virtualenv_install(env, packages = pkg_path)
  message("flux_lseg installed in virtualenv: ", env)
}
