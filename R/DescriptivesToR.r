#' 
#' 
#' 
#' @param file path of text file with spss crosstab syntax
#' @export 

descriptives_to_descmat <- function(file){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
  varsLoc <- grep("variables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  descVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
  
  statLoc <- grep("statistics\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[statLoc], (which(strsplit(x[statLoc], '')[[1]]=='=')+1), nchar(x[statLoc]))
  vars <- gsub("^\\s+|\\s+$", "", gsub("\\.", "", vars))
  stats <- paste(unlist(strsplit(vars, " ")), collapse = ", ")
  stats <- tolower(stats)
  stats <- gsub("stddev", "sd", stats)
  stats <- gsub("variance", "var", stats)
  if(grepl("all", stats) == TRUE){
    stats <- paste("mean", "semean", "sd", "var", "kurtosis", "skewness", "range", "min", "max",
                   "sum", sep = ", ")
  } 
  if(grepl("default", stats) == TRUE){
    stats <- paste("mean", "sd", "min", "max", sep = ", ")
  }
    
  if(grepl("skewness|kurtosis", stats) == TRUE){
    finMat <- matrix(ncol = 1, nrow = 4)
    finMat[1] <- "\\#x is the name of your data frame"
    finMat[2] <- paste('library(SPSStoR)', sep = '')
    finMat[3] <- paste('library(e1071)', sep = '')
    finMat[4] <- paste('with(x, descmat(x = list(', descVars, '), ', stats, '))', sep = '')
  } else {
    finMat <- matrix(ncol = 1, nrow = 3)
    finMat[1] <- "\\#x is the name of your data frame"
    finMat[2] <- paste('library(SPSStoR)', sep = '')
    finMat[3] <- paste('with(x, descmat(x = list(', descVars, '), ', stats, '))', sep = '')
  }
  
 finMat
  
}