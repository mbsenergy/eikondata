devtools::load_all()
# library(eikondata)
# install_flux_lseg()
#
# reticulate::use_virtualenv("fluxenv", required = TRUE)
# flux = reticulate::import("fluxlseg")
# flux$open_session(LSEG_KEY='0df86b690b2c4ae2bf245680dbbfcc86bb041dc9')
# set_proxy_port(9000L)
# PLEASE_INSERT_REUTERS_KEY = Sys.getenv('REUTERS_KEY')
# set_app_id(as.character(PLEASE_INSERT_REUTERS_KEY[1]))

dts = get_rics_f(rics = "FDBMM5", from_date = "2025-01-01", to_date = "2025-12-31", legacy = FALSE)
dts
