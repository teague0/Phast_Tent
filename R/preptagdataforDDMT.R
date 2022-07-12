# Check test technosmart tag
library(data.table)
library(lubridate)
library(janitor)
library(stringr)

bat_files <-  dir(path = "F:/TrackingDryseason/Muddycave/", pattern = "PH*", full.names = TRUE)
bats <- substr(bat_files, 32, 40) %>% unique
bat_files[1]
nchar("F:/TrackingDryseason/Muddycave/PH_ST_049")
i = 1
for(i in 2:length(bats)){
  idx <- which(str_detect(bat_files, pattern = bats[i]) & str_detect(bat_files, pattern = ".csv"))
  bat <- data.table()
  if(length(idx) == 0) print(bats[i])
  if(length(idx) > 0){
    for(j in 1:length(idx)){
      df <- fread(bat_files[idx[j]]) %>% clean_names()
      bat <- rbind(bat, df)
    }
    fwrite(bat, file = paste0("F:/TrackingDryseason/Muddycave/DDMT/", bats[i], ".csv"))  
  }
}

unique(substr(bat$timestamp, 1,10))

df <- fread("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/FlightCage/PH_FC_04.csv") %>% clean_names

df$datetime <- dmy_hms(df$timestamp)
df$datetime %>% date %>% unique

#plot(df$datetime, df$x)
idx <- which(is.na(df$location_lat))
with(df[-idx,], plot(location_lon, location_lat, type = "o"))
with(df[-idx,], plot(datetime, location_lat))
with(df, plot(datetime, battery_v))
with(df[1000000:1100000,], plot(datetime, x))
points(df$datetime, df$y, col = rgb(0,1,0,.2))
points(df$datetime, df$z, col = rgb(0,0,1,.2))

?fwrite
fwrite(df[,c("x","y","z")], sep = "\t",
       file = "F:/FlightCageBocas/PH_FC_02/PH_FC_02_S3_DDMT.txt",
       col.names = FALSE, row.names = FALSE)
