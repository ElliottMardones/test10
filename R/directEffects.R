
#' directEffects
#'
#' @param CC directEffects
#' @param CE directEffects
#' @param EE directEffects
#' @param thr directEffects
#' @param conf.level directEffects
#' @param reps directEffects
#' @param delete directEffects
#'
#' @return directEffects
#' @export
#' @examples
#' directEffects(CC = AA, CE = AB, EE = BB, thr = 0.5, conf.level=0.95, reps = 100, delete = FALSE)
directEffects <- function(CC, CE =NULL, EE=NULL, thr=0.5, conf.level=0.95, reps=10000, delete=FALSE){
  if( !is.null(CE) & !is.null(EE)){
    output <- wrapper.de.rect(CC = CC, CE = CE , EE = EE, thr =thr, conf.level =conf.level, reps =reps, delete =delete)
    return(output)
  }else{
    output <- wrapper.de.sq(CC = CC, thr = thr, conf.level = conf.level, reps =reps, delete =delete)
    return(output)
  }
}

