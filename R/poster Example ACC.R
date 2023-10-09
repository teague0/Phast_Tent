
library(pacman)
p_load(lubridate, data.table, tidyverse, dplyr, accelerateR, roll, randomForest, vcd)

acc <- fread("./data/PH_FC_02.csv")
  
acc$time <- dmy_hms(acc$timestamp)
acc$localtime <- acc$time - 5*3600

vedba <- function(acc){
  acc$x0 <- roll_mean(acc$x, width = 25, na_restore = TRUE)
  acc$y0 <- roll_mean(acc$y, width = 25, na_restore = TRUE)
  acc$z0 <- roll_mean(acc$z, width = 25, na_restore = TRUE)
  
  acc$x1 <- acc$x - acc$x0
  acc$y1 <- acc$y - acc$y0
  acc$z1 <- acc$z - acc$z0
  
  acc$ODBA <- abs(acc$x1) + abs(acc$y1) + abs(acc$z1)
  acc$VeDBA <- sqrt((acc$x1)^2 + (acc$y1)^2 + (acc$z1)^2)
  return(acc)
}

acc <- vedba(acc)

bolt$ODBA[1:100000] %>% plot(type = "l")
with(bolt[1:100000], plot(ODBA, VeDBA))


options(digits.secs = 3)
txBoc <- fread("~/Desktop/Bocas 2023 GPS tags/Phyl28_S1.csv")
txBoc$time <- dmy_hms(txBoc$Timestamp)
txBoc$localtime <- txBoc$time - 5*3600

txBoc %>% filter(localtime > "2023-08-15 06:00:00 UTC")

p <- txBoc %>% filter(date(time) == "2023-08-14") %>% 
  ggplot()+
  geom_path(aes(x = time, y = Z), color = "blue")+
  theme_bw()

library(plotly)

ggplotly(p)


flight <- txBoc %>% filter(time > "2023-08-15 02:13:48" & time < "2023-08-15 02:13:52") %>% 
  ggplot()+
  geom_path(aes(x = time, y = Z), color = "blue")+
  geom_path(aes(x = time, y = X), color = "red")+
  geom_path(aes(x = time, y = Y), color = "green")+
  labs(y = "Acceleration (g)")+
  theme_bw()

flight  
ggsave("./flightACCPhyl28.png")


forage <- txBoc %>% filter(time > "2023-08-14 00:00:00" & time < "2023-08-14 00:42:00") %>% 
  ggplot()+
  geom_path(aes(x = time, y = Z), color = "blue")+
  geom_path(aes(x = time, y = X), color = "red", alpha = 0.5)+
  geom_path(aes(x = time, y = Y), color = "green", alpha = 0.5)+
  labs(y = "Acceleration (g)")+
  theme_bw()

forage  
ggsave("./forageACCPhyl28.png")
