# save daily track data for firetail
library(data.table)
library(lubridate)
library(janitor)
library(stringr)
library(tidyverse)


bat_files <-  dir(path = "../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason/Lagruta/DDMT", pattern = "PH*", full.names = TRUE)
bats <- substr(bat_files, nchar(bat_files[1])-12, nchar(bat_files[1])-4) %>% unique
i = 1
for(i in 1:length(bat_files)){
  df <- fread(bat_files[i]) %>% clean_names()
  
  df <- df %>% mutate(., 
                      ID = bats[i],
                      timestamp,
                      x,y,z,
                      .keep = "used")
  fwrite(df, file = paste0("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/DrySeason/Movebank/", bats[i], "_ACC.csv"))  
}

df$sensor_raw[1:100]
df$sensor_raw %>% table

df[df$sensor_raw == 993,]
df$sensor_raw[!is.na(df$location_lat)] %>% table
df$activity %>% unique
