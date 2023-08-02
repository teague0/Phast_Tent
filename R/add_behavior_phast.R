
library(pacman)
p_load(lubridate, data.table, tidyverse, dplyr, accelerateR, 
       roll, randomForest, xts,
       foreach, doParallel, doSNOW)

source("./scr/acc_functions.R")

saved_cores <- 10
sampling_rate <- 25

# get timestamp with milliseconds
op <- options(digits.secs=3)

# # set up parallelization
# cores=detectCores()
# cl <- makeCluster(cores[1]-saved_cores) #not to overload your computer
# registerDoSNOW(cl)
#registerDoParallel(cl)

# load the heart model
load("./../../../Dropbox/MPI/Phyllostomus/BORIS/heart.rf.robj")

# read foraging data
bats <- list.files("./../../../ownCloud/Firetail/Phyllostomushastatus/Model_tag_7CE02AF_main/", 
                   pattern = "*annotated-bursts-gps.csv", full.names = TRUE)
j = 1
for(j in 1:length(bats)){
  print(bats[j])
  d <- fread(bats[j])
  
  d$rf_behavior <- "resting"
  d$rf_behavior[d$annotation_layer_commuting != ""] <- "commuting"
  d$rf_behavior[d$annotation_layer_foraging != ""] <- "foraging"
  
  iterations <- nrow(d)
  # pb <- txtProgressBar(max = iterations, style = 3)
  # progress <- function(n) setTxtProgressBar(pb, n)
  # opts <- list(progress = progress)
  # db <- foreach(ii = 1:iterations, 
  #               .combine = rbind,
  #               .options.snow = opts) %dopar% {
  db <- data.table()
  for(ii in 1:iterations){
    temp <- {}
    x <- NA
    y <- NA
    z <- NA
    time <- NA
    burst <- NA
    
    temp <- bat$eobs_accelerations_raw[ii] |> 
      strsplit(" ") |>
      unlist() |>
      as.numeric()
    
    if(length(temp) > 0){
      x <- temp[seq(1, length(temp), 3)]
      y <- temp[seq(2, length(temp), 3)]
      z <- temp[seq(3, length(temp), 3)]
      temp_time <- seq.POSIXt(from = bat$timestamp[ii],
                              to = bat$timestamp[ii]+length(temp)/sampling_rate/3,
                              length.out = length(temp)/3)
      time <- format(temp_time, "%Y-%m-%d %H:%M:%OS3") |> as.character()
      burst <- rep(ii, length(time))
    }
    
    temp_df <- data.frame(x,y,z,time,burst)
    temp_df$behavior <- bat$rf_behavior[ii]
    
    db <- rbind(db, temp_df)
    # return(temp_df)
  }
  # close(pb)
  
  db <- na.omit(db)
  d$burst <- 1:nrow(d)
  db$behavior <- d$rf_behavior[match(db$burst, d$burst)]
  
  db <- vedba(db)
  
  
  # save(db, file = "temp.robj")
  # load("temp.robj")
  df <- db %>% group_by(burst, behavior) %>% 
    summarise(time = time[1],
              odba = sum(ODBA, na.rm = TRUE) %>% round(1),
              vedba = sum(VeDBA, na.rm = TRUE) %>% round(1))
  
  db$rf_behavior <- predict(heart.rf, newdata = db)
  
  # Group db by burst and calculate the count of each behavior within each burst
  behavior_counts <- db %>%
    group_by(burst, rf_behavior) %>%
    summarize(count = n()) %>%
    ungroup()
  
  # Find the behavior with the maximum count for each burst
  most_common_behavior <- behavior_counts %>%
    group_by(burst) %>%
    filter(count == max(count))
  
  # Merge the most_common_behavior with df based on the "burst" column
  df <- left_join(df, most_common_behavior, by = "burst")
  
  # resting <- which(df$behavior == "resting")
  
  df$time <- d$timestamp[df$burst]
  df$lat <- d$location_lat[df$burst]
  df$lon <- d$location_long[df$burst]
  df$bat <- substr(bats[j], 85, 91)
  
  fwrite(df, file = paste0("./../../../Dropbox/MPI/Phyllostomus/BORIS/rf_bats/rf_", df$bat[1], ".csv"))
}
# stopCluster(cl)
