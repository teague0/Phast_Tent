# plot tracks per bat, color by day
library(pacman)
p_load(move, janitor, data.table, lubridate, tidyverse, moveVis, basemaps)

source("./../../movebank_login.R")

#set_defaults(map_service = "mapbox", map_type = "satellite", map_token = token)

df <- fread("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/Greater spear-nosed bat (Phyllostomus hastatus) in Bocas del Toro 2021-2022 (1).csv") %>% clean_names

# phast <- df2move(df = df, proj = "+proj=longlat +datum=WGS84 +no_defs",
#                  x = 'location_long', y = 'location_lat', time = 'timestamp',
#                  track_id = 'tag_local_identifier')
phast <- getMovebankData(study="Greater spear-nosed bat (Phyllostomus hastatus) in Bocas del Toro 2021-2022", login=login, removeDuplicatedTimestamps = TRUE)
# sensors <- getMovebankSensorsAttributes(study="Greater spear-nosed bat (Phyllostomus hastatus) in Bocas del Toro 2021-2022", login=login)

plot(phast[[1]], col = date(phast[[1]]$time))

bats <- unique(phast@trackId)
bats <- unique(phast$tag_local_identifier)
bats <- bats[order(bats)]
i = 1
phast <- phast[phast$location_lat > 5,]

DF <- as.data.frame(phast)
i = 55
pdf(file = "foraging_by_indiv.pdf")
for(i in 1:length(bats)){
  df <- {}
  df <- DF[DF$tag_local_identifier == bats[i],]
  plot(DF$location_long, DF$location_lat, asp = 1, col = 0,
       xlab = "Lon", ylab = "Lat",
       main = paste0(bats[i], ": ", 
                     min(date(df$timestamp)), " to ", 
                     max(date(df$timestamp))))
  points(df$location_long, df$location_lat, col = date(df$timestamp))
  legend("bottomleft", pch = rep(1, length(unique(date(df$timestamp)))),
         legend = unique(date(df$timestamp)),
         col = unique(date(df$timestamp)))
}
dev.off()

harems <- paste(DF$comments, DF$tag_local_identifier, DF$sex) %>% unique
harems[order(harems)]

ggplot(data = , aes(x,y,col = time))+geom_point()
+facet_wrap(~date(time))
