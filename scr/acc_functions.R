# acceleration functions

vedba <- function(acc){
  acc$x0 <- roll_mean(acc$x, width = 25, na_restore = TRUE)
  acc$y0 <- roll_mean(acc$y, width = 25, na_restore = TRUE)
  acc$z0 <- roll_mean(acc$z, width = 25, na_restore = TRUE)
  
  acc$x1 <- acc$x - acc$x0
  acc$y1 <- acc$y - acc$y0
  acc$z1 <- acc$z - acc$z0
  
  acc$ODBA <- abs(acc$x1) + abs(acc$y1) + abs(acc$z1)
  acc$VeDBA <- sqrt((acc$x1)^2 + (acc$y1)^2 + (acc$z1)^2)
  return(acc)
}


