library(pacman)
p_load(data.table, lubridate, dplyr)

# muddycave

folder <- "D:/TrackingDryseason/Muddycave/"
files <- list.files(folder, pattern = "*.csv", full.names = FALSE)
dir.create(paste0(folder, "movebankfiles"))

for(i in 1:length(files)){
  print(files[i])
  dt <- fread(paste0(folder, files[i]))
  summary(dt)
  
  idx_acc <- which(dt$`location-lat` %>% is.na)
  
  gps <- dt[-c(idx_acc),]  
  fwrite(gps, file = paste0(folder, "movebankfiles/", substr(files[i], 1, nchar(files[i])-4), "_gps.csv"))
  
  acc <- dt
  acc$`location-lat`[idx_acc] <- ""
  acc$`location-lon`[idx_acc] <- ""
  fwrite(acc, file = paste0(folder, "movebankfiles/", substr(files[i], 1, nchar(files[i])-4), "_acc.csv"))
  
  # if(nrow(gps) > 10){
  #   with(gps, plot(X,Y, asp = 1, pch = 16, col = rgb(0, (0:length(X))/length(X), (length(X):0)/length(X),1)))  
  # }
}


# check that everything copied well