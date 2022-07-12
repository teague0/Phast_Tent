# save GPS data for movebank
library(data.table)
library(lubridate)
library(janitor)
library(stringr)


bat_files <-  dir(path = "../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason/Lagruta/DDMT", pattern = "PH*", full.names = TRUE)
bats <- substr(bat_files, nchar(bat_files[1])-12, nchar(bat_files[1])-4) %>% unique
i = 1
for(i in 1:length(bat_files)){
  df <- fread(bat_files[i]) %>% clean_names()
  gps <- df[!is.na(df$location_lat),]  
  fwrite(gps, file = paste0("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason/Movebank/", bats[i], ".csv"))  
}

bat_files <-  dir(path = "../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason/Movebank/", pattern = "PH*", full.names = TRUE)
bats <- substr(bat_files, nchar(bat_files[1])-12, nchar(bat_files[1])-4) %>% unique
bat <- data.table()
# merge into one big bat file
for(i in 1:length(bat_files)){
  df <- fread(bat_files[i]) %>% clean_names()
  df$timestamp <- dmy_hms(df$timestamp)
  df$ID <- bats[i]
  names(df)
  df_clean <- df[,c("tag_id","timestamp","activity","location_lat","location_lon","height_msl",
                    "ground_speed","satellites","hdop","signal_strength","sensor_raw","battery_v","ID")]
  bat <- rbind(bat, df_clean)
}

fwrite(bat, file = paste0("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason/Movebank/TechnosmartDry2022.csv"))  

