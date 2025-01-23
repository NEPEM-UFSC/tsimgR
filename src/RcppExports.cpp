// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// tsimg_gif_rcpp
RawVector tsimg_gif_rcpp(const std::vector<std::string>& image_paths, int frame_delay, bool debug, bool reverse);
RcppExport SEXP _tsimgR_tsimg_gif_rcpp(SEXP image_pathsSEXP, SEXP frame_delaySEXP, SEXP debugSEXP, SEXP reverseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type image_paths(image_pathsSEXP);
    Rcpp::traits::input_parameter< int >::type frame_delay(frame_delaySEXP);
    Rcpp::traits::input_parameter< bool >::type debug(debugSEXP);
    Rcpp::traits::input_parameter< bool >::type reverse(reverseSEXP);
    rcpp_result_gen = Rcpp::wrap(tsimg_gif_rcpp(image_paths, frame_delay, debug, reverse));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_tsimgR_tsimg_gif_rcpp", (DL_FUNC) &_tsimgR_tsimg_gif_rcpp, 4},
    {NULL, NULL, 0}
};

RcppExport void R_init_tsimgR(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
