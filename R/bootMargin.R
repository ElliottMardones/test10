#' bootMargin
#'
#' @param CC bootMargin
#' @param CE CE
#' @param EE EE
#' @param thr bootMargin
#' @param reps bootMargin
#' @param conf.level conf.level
#' @param delete bootMargin
#' @param plot bootMargin
#'
#' @return bootMargin
#' @export
#' @examples
#' bootMargin(CC = AA, CE = AB, EE = BB, thr = 0.5,
#'  reps = 1000, conf.level = 0.05,
#'   delete = FALSE, plot = FALSE)
bootMargin <-function(CC, CE= NULL, EE= NULL,  thr = 0.5, reps=10000, conf.level = 0.95, delete=FALSE, plot = FALSE){
  output <- wrapper.BootMargin(CC = CC, CE = CE, EE = EE, thr=thr, reps=reps, conf.level =conf.level, delete=delete, plot=plot)
  return(output)
}

