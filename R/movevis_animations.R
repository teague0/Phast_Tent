library(pacman)
p_load(moveVis,move, janitor, tidyverse, data.table, lubridate)

source("./../../movebank_login.R")

df <- fread("../../../Downloads/Greater spear-nosed bat (Phyllostomus hastatus) in Bocas del Toro 2021-2022 (1).csv") %>% clean_names

phast <- df2move(df = df, proj = "+proj=longlat +datum=WGS84 +no_defs", 
        x = 'location_long', y = 'location_lat', time = 'timestamp',
        track_id = 'tag_local_identifier')

# data("move_data", package = "moveVis") # move class object
# if your tracks are present as data.frames, see df2move() for conversion
# phast <- getMovebankData(study="Greater spear-nosed bat (Phyllostomus hastatus) in Bocas del Toro 2021-2022", 
#                          login=login)
# phast <- phast[phast$location_long>-85,]
plot(phast[[1]])

days <- unique(date(phast$time))
i=1
for(i in 2:length(days)){
  day_phast <- phast[date(phast$time) == days[i],]
  # plot(day_phast)
  
  # align move_data to a uniform time scale
  m <- {}
  m <- align_move(day_phast, res = 2, unit = "mins")
  # plot(m)
  
  # create spatial frames with a OpenStreetMap watercolour map
  frames <- {}
  frames <- frames_spatial(m, # path_colours = c("red", "green", "blue"),
                           map_service = "mapbox", map_type = "satellite", alpha = 0.5) %>%
    add_labels(x = "Longitude", y = "Latitude") %>% # add some customizations, such as axis labels
    # add_northarrow() %>%
    add_scalebar() %>%
    add_timestamps(m, type = "label") %>%
    add_progress()
  
  # frames[[100]] # preview one of the frames, e.g. the 100th frame
  
  # animate frames
  animate_frames(frames, out_file = paste0("Phast_",days[i], ".mp4"))  
}

