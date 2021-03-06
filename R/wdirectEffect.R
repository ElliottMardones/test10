#' @import wBoot

validations_de_rect <- function(CC, CE, EE){
  A <- if( missing(CC))( warning("Parameter CC is missing, its required."))else(flag <- "Ok")
  B <- if( missing(CE))( warning("Parameter CE is missing, its required."))else(flag <- "Ok")
  C <- if( missing(EE))( warning("Parameter EE is missing, its required."))else(flag <- "Ok")
  myFlag <- c(A,B,C)
  if( length(myFlag) == 3){
    if( ncol(CC) == nrow(CE)){
      if( ncol(CE) == nrow(EE )){
        return(flag <- TRUE)
      }else{
        warning("The number of columns of CE is different from the number of rows of EE")
        return(flag <- FALSE)
      }
    }else{
      warning("The number of columns of CC is different from the number of rows of CE.")
      return(flag <- FALSE)
    }
  }else{
    return(flag <- FALSE)
  }
}

wrapper.de.sq <- function(CC, thr, conf.level, reps, delete){
  if( missing(CC)){
    message("Parameter CC is missing, its required.")
    return(NULL)
  }else{
    if(is.list(CC)){
      CC <- listo_to_Array3D(CC)
    }
    bootCC <- data.frame(From = character(), To = character(), Mean = numeric(), UCI= numeric(), p.value = numeric())
    numdim  <- (dim(CC)[1] * dim(CC)[2] - dim(CC)[2] ) * dim(CC)[3]
    rownamesData <- rownames(CC[,,1])
    colnamesData <- colnames(CC[,,1])
    vector_Value  <- numeric()
    for(x in seq_len(dim(CC)[1]) ){
      for( y in seq_len(dim(CC)[2]) ){
        if( x != y){
          vector_Value <- CC[x,y,]
          valuesFromArrays <- (as.numeric(vector_Value))
          Data.CI<- boot.one.bca(valuesFromArrays,mean,null.hyp = thr, alternative = "less",R=reps, conf.level = conf.level)#agrege conf.level a boot.one.bca
          bootCC <- rbind( bootCC, data.frame(From = rownamesData[x],
                                              To = colnamesData[y],
                                              Mean = mean(valuesFromArrays),
                                              UCI= Data.CI$Confidence.limits[1],
                                              p.value = Data.CI$p.value))

        }
      }
    }
    if( delete){
      conf.level <- 1 - conf.level
      borrar <-  which(bootCC$p.value < conf.level | ( bootCC$Mean < thr & is.nan(bootCC$p.value)))
      temp <- bootCC[borrar, ]
      for( ii in seq_len(nrow(temp)) ){
        From <- temp[ii, 1]
        To <- temp[ii, 2]
        From <- which(rownamesData == From)
        To <- which(colnamesData == To)
        CC[From, To, ] <- 0
      }
      if(length(borrar > 0)){
        message("deleting data...")
        bootCC <- bootCC[-borrar, ]
        rownames(bootCC) <- seq_len(nrow(bootCC))
        return(list(Data=CC,DirectEffects=bootCC ))
      }else{
        message("There is no data to delete...")
        rownames(bootCC) <- seq_len(nrow(bootCC))
        return(list(Data=CC,DirectEffects=bootCC ))
      }

    }else{
      rownames(bootCC) <- seq_len(nrow(bootCC))
      return(list(DirectEffects=bootCC ))
    }
  }
}
wrapper.de.rect <- function( CC, CE, EE, thr, conf.level, reps, delete){
  flag <- validations_de_rect(CC = CC, CE = CE, EE=EE)
  if( flag == TRUE){
    CCdata <- wrapper.de.sq(CC= CC, reps= reps, conf.level =conf.level, thr=thr,delete =delete)
    CEdata <- wrapper.de.sq(CC= CE, reps= reps, conf.level =conf.level, thr=thr,delete =delete)
    EEdata <- wrapper.de.sq(CC= EE, reps= reps, conf.level =conf.level, thr=thr,delete =delete)
    DirectEffects_CC <- CCdata$DirectEffects
    DirectEffects_CE <- CEdata$DirectEffects
    DirectEffects_EE <- EEdata$DirectEffects
    output_AllDirecEffects <- rbind(DirectEffects_CC, DirectEffects_CE)
    output_AllDirecEffects <- rbind(output_AllDirecEffects,DirectEffects_EE)
    if(delete == TRUE){
      return(list(CC = CCdata$Data,
                  CE = CEdata$Data,
                  EE = EEdata$Data,
                  DirectEffects = output_AllDirecEffects))
    }else{
      return(list(DirectEffects = output_AllDirecEffects ))
    }
  }
}


