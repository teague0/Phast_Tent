# Check test technosmart tag
library(data.table)
library(lubridate)
library(janitor)

df <- fread("F:/FlightCageBocas/PH_FC_02/PH_FC_02_S3.csv") %>% clean_names

df$datetime <- dmy_hms(paste0(df$date," ",df$time))

#plot(df$datetime, df$x)
idx <- which(is.na(df$location_lat))
with(df[-idx,], plot(location_lon, location_lat, type = "o"))
with(df[-idx,], plot(datetime, location_lat))
with(df, plot(datetime, battery_v))
with(df[1000000:1100000,], plot(datetime, x))
points(df$datetime, df$y, col = rgb(0,1,0,.2))
points(df$datetime, df$z, col = rgb(0,0,1,.2))
