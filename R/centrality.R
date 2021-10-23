#' centrality
#'
#' @param CC centrality
#' @param CE ce
#' @param EE ee
#' @param model centrality
#' @param reps centrality
#' @param conf centrality
#' @param parallel centrality
#' @param ncpus centrality
#'
#' @return centrality
#' @export
#' @examples
#' c1 <- centrality( CC = AA, model = "median", reps = 100, parallel = "no", ncpus = 1)
#' c2 <- centrality( CC = AA, model = "conpl", reps = 100, parallel = "no", ncpus = 1)
#' c3 <- centrality( CC = AA, model = "conlnorm", reps = 100, parallel = "no", ncpus = 1)
centrality <- function(CC, CE = NULL, EE = NULL, model = c("conpl", "conlnorm","median") , reps = 10000, conf = 0.95, parallel=c("multicore","snow","no") , ncpus = 1){
  output <- bootCent( CC = CC, CE = CE, EE = EE, model = model, reps =reps, conf = conf, parallel = parallel, ncpus = ncpus)
  return(output)
}

