#' @import stats
validations <- function(CC, CE, EE, thr, maxOrder){
  A <- if( missing(CC))( stop("Parameter CC is missing, its required."))else(flag <- "Ok")
  B <- if( missing(CE))( stop("Parameter CE is missing, its required."))else(flag <- "Ok")
  C <- if( missing(EE))( stop("Parameter EE is missing, its required."))else(flag <- "Ok")
  myFlag <- c(A,B,C)
  if( length(myFlag) == 3){
    if( ncol(CC) == nrow(CE)){
      if( ncol(CE) == nrow(EE )){
        if( maxOrder > 1){
          if( thr > 0 & thr < 1){
            return(flag <- TRUE)
          }else{
            stop("The thr parameter is outside the established ranges")
            return(NULL)
          }
        }else{
          stop("The maxOrder parameter must be greater than 1.")
          return(NULL)
        }

      }else{
        stop("The number of columns of CE is different from the number of rows of EE")
        return(flag <- FALSE)
      }
    }else{
      stop("The number of columns of CC is different from the number of rows of CE.")
      return(flag <- FALSE)
    }
  }else{
    return(flag <- FALSE)
  }
}


wrapper.FE_R <- function(AA,AB,BB, thr, order){
  AA <- data.matrix(AA, rownames.force = TRUE)
  AB <- data.matrix(AB, rownames.force = TRUE)
  BB <- data.matrix(BB, rownames.force = TRUE)
  if( (ncol(AA) == nrow(AB)) & ((ncol(AB)) == nrow(BB) )){
    I       <- wrapper.left.FE(AA, AB, thr, order)
    D       <- wrapper.right.FE(AB, BB, thr, order)
    Ilength <- length(I)
    Dlength <- length(D)
    vMax    <- max(Ilength, Dlength)
    newList <- list()
    for( r in seq_len(vMax)){
      if( (length(I) >= r)  & (length(D) >= r )){
        newList[[r]] <- rbind( I[[r]], D[[r]])
      }else{
        if( length(I) >= r){
          newList[[r]] <- I[[r]]
        }else{
          if( length(D) >= r ){
            newList[[r]] <- D[[r]]
          }
        }
      }
    }
  }else{
    return(NULL)
  }
  return(newList)
}

wrapper.FE_S <- function(AA, AB, thr, order){
  AA <- data.matrix(AA, rownames.force = TRUE)
  AB <- data.matrix(AB, rownames.force = TRUE)
  I  <- wrapper.left.FE(AA, AB, thr, order)
  #D <- wrapper.right.FE(AB, BB, thr, order) # in case it is ever needed
  return(I)
}

wrapper.indirectEffects_R <- function(CC,CE,EE, thr, maxOrder,reps, parallel, ncpus){
  flag <- validations(CC = CC, CE = CE, EE = EE, thr = thr, maxOrder = maxOrder)
  if( flag == TRUE){
    parallel      <- ifelse( length(parallel) != 1, "no", parallel)
    CC            <- if( is.list(CC) == TRUE)  listo_to_Array3D(CC) else CC
    CE            <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
    EE            <- if( is.list(EE) == TRUE)  listo_to_Array3D(EE) else EE
    listOfExperts <- vector(mode ="list" ,length = dim(CC)[3])
    for(i in seq_len(dim(CC)[3])){
      resultFE <- wrapper.FE_R(CC[,,i],CE[,,i],EE[,,i], thr, maxOrder)
      if( length(resultFE) == 0){
        warning("Expert number ", i," has no 2nd maxOrder or higher effects.")
      }else{
        listOfExperts[[i]] <- resultFE
        listOfExperts[[i]] <- putOrder(listOfExperts[[i]])
      }
    }
    # putExpert: Sets the value of the expert associated with their position in the list
    listOfExperts     <- putExpert(listOfExperts)
    IE_toOriDest      <- list()
    bootListOfExperts <- list()
    globalCountMax    <- maxOrder
    for( j in 2:(globalCountMax)){
      expertsSortedByLevel <- toOriDest(listOfExperts, order= j )
      if( nrow(expertsSortedByLevel) != 0){
        IE_toOriDest[[j]]      <- strsplit_function(expertsSortedByLevel)
        varibleStep            <- bootIE(expertsSortedByLevel, reps,parallel, ncpus)
        bootListOfExperts[[j]] <- strsplit_function(varibleStep)
      }
    }
    # putIE_order: Set the level for each expert
    IE_toOriDest      <- putIE_order(IE_toOriDest)
    bootListOfExperts <- putIE_order(bootListOfExperts)
    return(list( boot= bootListOfExperts, byExperts = IE_toOriDest))
  }else{
    return(NULL)
  }
}

validation_sq <- function(CC, thr, maxOrder){
  flag_sq <- if( missing(CC))( stop("Parameter CC is missing, its required."))else(flag <- TRUE)
  if( nrow(CC) == ncol(CC)){
    if( maxOrder > 1){
      if( thr > 0 & thr < 1){
        return(flag_sq)
      }else{
        stop("The thr parameter is outside the established ranges [0,1].")
        return(NULL)
      }
    }else{
      stop("The maxOrder parameter must be greater than 1.")
      return(NULL)
    }
  }else{
    stop("CC is not a square matrix.")
    return(NULL)
  }
}
wrapper.indirectEffects_S <- function(AA, AB, thr, maxOrder,reps, parallel, ncpus){
  flag_sq <- validation_sq(AA, thr, maxOrder)
  if( flag_sq){
    parallel      <- ifelse( length(parallel) != 1, "no", parallel)
    AA            <- if( is.list(AA) == TRUE)  listo_to_Array3D(AA) else AA
    AB            <- if( is.list(AB) == TRUE)  listo_to_Array3D(AB) else AB
    listOfExperts <- vector(mode ="list" ,length = dim(AA)[3])
    for(i in seq_len(dim(AA)[3])){
      ### wrapper.FE_S perform the forgotten effects calculation ###
      resultFE <- wrapper.FE_S(AA[,,i],AB[,,i], thr,maxOrder)
      if(length(resultFE) == 0){
        warning("Expert number ", i," has no 2nd order or higher effects.")
      }else{
        listOfExperts[[i]] <- resultFE
        listOfExperts[[i]] <- putOrder(listOfExperts[[i]])
      }
    }
    listOfExperts     <- putExpert(listOfExperts)
    #listOfExperts    <- listOfExperts[!sapply(listOfExperts,is.null)] # in case it is ever needed
    IE_toOriDest      <- list()
    bootListOfExperts <- list()
    globalCountMax    <-maxOrder
    for( j in 2:(globalCountMax)){
      expertsSortedByLevel <- toOriDest(listOfExperts, order = j )
      if( nrow(expertsSortedByLevel) != 0 ){
        IE_toOriDest[[j]]      <- strsplit_function(expertsSortedByLevel)
        varibleStep            <- bootIE(expertsSortedByLevel, reps,parallel, ncpus)
        bootListOfExperts[[j]] <- strsplit_function(varibleStep)
      }
    }
    bootListOfExperts <- putIE_order(bootListOfExperts)
    IE_toOriDest      <- putIE_order(IE_toOriDest)
    return(list(boot= bootListOfExperts, byExperts = IE_toOriDest))
  }else{
    return(NULL)
  }
}







