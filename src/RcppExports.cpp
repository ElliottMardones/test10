// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// feRcpp
DataFrame feRcpp(NumericMatrix valueOverThreshold, NumericMatrix M1, NumericMatrix M2, NumericMatrix M3);
RcppExport SEXP _test10_feRcpp(SEXP valueOverThresholdSEXP, SEXP M1SEXP, SEXP M2SEXP, SEXP M3SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type valueOverThreshold(valueOverThresholdSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type M1(M1SEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type M2(M2SEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type M3(M3SEXP);
    rcpp_result_gen = Rcpp::wrap(feRcpp(valueOverThreshold, M1, M2, M3));
    return rcpp_result_gen;
END_RCPP
}
// maxminRcpp
NumericMatrix maxminRcpp(NumericMatrix matrix_1, NumericMatrix matrix_2);
RcppExport SEXP _test10_maxminRcpp(SEXP matrix_1SEXP, SEXP matrix_2SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type matrix_1(matrix_1SEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type matrix_2(matrix_2SEXP);
    rcpp_result_gen = Rcpp::wrap(maxminRcpp(matrix_1, matrix_2));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_test10_feRcpp", (DL_FUNC) &_test10_feRcpp, 4},
    {"_test10_maxminRcpp", (DL_FUNC) &_test10_maxminRcpp, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_test10(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
