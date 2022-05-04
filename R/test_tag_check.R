# Check test technosmart tag
library(data.table)
library(lubridate)
library(janitor)

df <- fread("C:/Users/edwar/Desktop/FlightCageBocas/Test/PH_FC_05_S6.csv") %>% clean_names

df$datetime <- dmy_hms(paste0(df$date," ",df$time))

#plot(df$datetime, df$x)
idx <- which(is.na(df$location_lat))
with(df[-idx,], plot(location_lon, location_lat, type = "o"))
with(df[-idx,], plot(datetime, location_lat))
with(df, plot(datetime, battery_v))
