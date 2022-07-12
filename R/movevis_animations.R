library(pacman)
p_load(move, janitor, data.table, lubridate, tidyverse, moveVis, basemaps)

source("./../../movebank_login.R")

#set_defaults(map_service = "mapbox", map_type = "satellite", map_token = token)

df <- fread("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Tracking/Greater spear-nosed bat (Phyllostomus hastatus) in Bocas del Toro 2021-2022 (1).csv") %>% clean_names

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
i=2
for(i in 7:length(days)){
  print(i)
  day_phast <- phast[date(phast$time) == days[i],]
  day_phast <- day_phast[day_phast@trackId != names(which(day_phast@trackId %>% table < 2)),]
  # plot(day_phast)
  
  use_multicore(n_cores = 10)
  
  # align move_data to a uniform time scale
  m <- {}
  m <- align_move(day_phast, res = 2, unit = "mins")
  # plot(m)
  
  # create spatial frames with a OpenStreetMap watercolour map
  frames <- {}
  frames <- frames_spatial(m,  # path_colours = c("red", "green", "blue"),
                           map_token = token,
                           map_service = "mapbox", map_type = "satellite", alpha = 1) %>%
    add_labels(x = "Longitude", y = "Latitude") %>% # add some customizations, such as axis labels
    # add_northarrow() %>%
    add_gg(expr(list(guides(colour = guide_legend(ncol = 2))))) %>% 
    add_scalebar() %>%
    add_timestamps(m, type = "label") %>%
    add_progress()
    
  
  # frames[[10]] # preview one of the frames, e.g. the 100th frame
  
  # animate frames
  try(animate_frames(frames, 
                     out_file = paste0("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Plots/Phast_sat_",
                                       days[i], ".mp4")))  
}

