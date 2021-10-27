#' @title Forgotten Effects For Complete Graphs
#' @aliases fe.sq
#' @name fe.sq
#'
#' @description Perform the forgotten effects calculation proposed by Kaufmann and Gil-Aluja (1988)
#'  with multiple key informants. Parameters allow you to specify the significant
#'   degree of truth and the order of incidence that is required to be calculated
#'   for complete multi-expert graphs. The function returns the frequency of appearance
#'    of the forgotten effect, its mean incidence, the confidence intervals and the
#'    standard error in each order.
#'
#' @param CC Three-dimensional matrix, where each submatrix along the z-axis is a square and reflective incidence matrix, or a list of data.frames containing square and reflective incidence matrices.

#' @param thr Real within [0,1]. Defines the significant degree of truth.

#' @param maxOrder Positive integer greater than 1: defines the maximum order of the forgotten effects. By default maxOrder = 2.

#' @param reps Number of bootstrap replicas. By default reps = 10,000.

#' @param parallel The type of parallel operation that is used (if applicable). The options are "multicore", "snow" and "no". By default parallel = "no".

#' @param ncpus Integer. Number of processes that are used in the parallel implementation. By default ncpus = 1.

#'
#' @details The function extends the theory of forgotten effects proposed by Kaufman and Gil-Aluja
#' (1988), to find indirect cause-effect relationships from direct cause-effect relationships, in the case of multiple experts. Indirect cause-effect relationships are classified according to the order to which they correspond. The parallel and ncpus options are not available on Windows operating systems.

#' @return Returns two lists:
#' boot: List of data.frame for each of the generated orders, contains the following components
#' \item{From}{Indicates the origin of the forgotten effects relationships.}
#' \item{Through_x}{Dynamic field representing the intermediate relationships of the forgotten effects. For example, for order n there will be "though_1" up to "though_ <n-1>".}
#' \item{To}{Indicates the end of the forgotten effects relationships.}
#' \item{Count}{Counter representing the number of times the forgotten effect is repeated.}
#' \item{Mean}{Medium effect of the forgotten effect.}
#' \item{LCI}{Lower Confidence Intervals.}
#' \item{UCI}{Upper Confidence Intervals.}
#' \item{SE}{Standard error.}
#'
#'byExperts: List of data.frames for each of the generated orders that contains the incidence values for each of the relationships found by the expert, the components are:
#' \item{From}{Indicates the origin of the forgotten effects relationships.}
#' \item{Through_x}{Dynamic field representing the intermediate relationships of the forgotten effects. For example, for order n there will be "though_1" up to "though_ <n-1>".}
#' \item{To}{Indicates the end of the forgotten effects relationships.}
#' \item{Count}{Counter representing the number of times the forgotten effect is repeated.}
#' \item{Expert_x}{Dynamic field that represent each of the entered experts.}
#'
#' @references
#'
#' Kaufmann, A., & Aluja, J. G. (1988). Modelos para la investigación de efectos olvidados. Milladoiro.
#'
#' Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R package version 1.3-28.
#'
#' Csardi G, Nepusz T (2006). “The igraph software package for complex network research.” InterJournal, Complex Systems, 1695
#'
#' Eddelbuettel D, François R (2011). “Rcpp: Seamless R and C++ Integration.” Journal of Statistical Software, 40(8), 1–18.
#'
#' Eddelbuettel D (2013). Seamless R and C++ Integration with Rcpp. Springer, New York.
#'
#' Eddelbuettel D, Balamuta JJ (2018). “Extending extitR with extitC++: A Brief Introduction to extitRcpp.” The American Statistician, 72(1), 28-36.
#'
#' @export
#' @examples
#' fe.sq( CC = AA, thr = 0.5, maxOrder = 2, reps = 100, parallel = "no", ncpus = 1)
fe.sq <- function(CC, thr = 0.5, maxOrder = 2, reps = 10000, parallel = c("multicore","snow","no"), ncpus = 1){
  output <- wrapper.indirectEffects_S(AA =CC, AB = CC, thr=thr, maxOrder=maxOrder,reps=reps, parallel=parallel, ncpus=ncpus)
  return(output)
}

#' @title Forgotten Effects For Bipartite Graphs
#' @aliases fe.rect
#' @name fe.rect
#'
#' @description Performs the forgotten effects calculation proposed by Kaufman and Gil-Aluja (1988) with multiple experts. The parameters allow you to specify the significant degree of truth and the order of incidence that is required to be calculated for rectangular matrices.
#'
#' @param CC Three-dimensional matrix, where each submatrix along the z-axis is a square and reflective incidence matrix, or a list of data.frames containing square and reflective incidence matrices.

#' @param CE Three-dimensional matrix, where each submatrix along the z-axis is a reflective rectangular incidence matrix, or a list of data.frames containing reflective and rectangular incidence matrices.

#' @param EE Three-dimensional matrix, where each submatrix along the z-axis is a square and reflective incidence matrix, or a list of data.frames containing square and reflective incidence matrices.

#' @param thr Real within [0,1]. Defines the significant degree of truth.

#' @param maxOrder Positive integer greater than 1: defines the maximum order of the forgotten effects. By default maxOrder = 2.

#' @param reps Number of bootstrap replicas. By default reps = 10,000.

#' @param parallel The type of parallel operation that is used (if applicable). The options are "multicore", "snow" and "no". By default parallel = "no"
#' @param ncpus Integer, Number of processes that are used in the parallel implementation. By default ncpus = 1.

#'
#' @details The function extends the theory of forgotten effects proposed by Kaufman and Gil-Aluja (1988), to find indirect cause-effect relationships from direct cause-effect relationships, in the case of multiple experts. Indirect cause-effect relationships are classified according to the order to which they correspond.
#' The parallel and ncpus options are not available on Windows operating systems.

#'
#' @return asd
#' @export
#' @examples
#' fe.rect( CC = AA, CE = AB, EE = BB, thr = 0.5, maxOrder = 2, reps = 100, parallel = "no", ncpus = 1)
fe.rect <- function(CC, CE, EE, thr = 0.5, maxOrder = 2, reps = 10000, parallel = c("multicore","snow","no"), ncpus = 1){
  output <- wrapper.indirectEffects_R(CC = CC, CE = CE, EE = EE, thr = thr, maxOrder =maxOrder,reps =reps, parallel =parallel, ncpus = ncpus)
  return(output)
}

