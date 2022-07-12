library(pacman)
p_load(data.table, janitor, lubridate)
op <- options(digits.secs=3)
setwd('C:/Users/Edward/Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason')
folders <- dir()[1:3]
i = 1
for(i in 1:length(folders)){
  files <- list.files(paste0(folders[i],"/DDMT/"))
  j = 1
  for(j in 1:length(files)){
    df <- fread(paste0(folders[i],"/DDMT/",files[j])) %>% clean_names()
    df <- df[!is.na(df$location_lat),]
    datetime <- dmy_hms(df$timestamp)
    gps <- data.table(Date = format(datetime, '%d/%m/%y'), 
                      Time = format(datetime, '%H:%M:%OS'),
                      Latitute = df$location_lat,
                      Longitude = df$location_lon,
                      Altitude = df$height_msl)
    fwrite(gps, file = paste0("GPS_data_", files[j]))
  }
  
}
