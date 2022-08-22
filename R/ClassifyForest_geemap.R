library(pacman)
p_load(tidyverse, ggplot2, raster, dplyr, sp, sf, 
       leaflet, leaflet.esri, ggpubr)


c.sf <- st_read("../../../Dropbox/MPI/Phyllostomus/")
# c <- raster("C:/Users/Edward/Downloads/cluster_kmeans_k12.tif")
c <- raster("C:/Users/Edward/Downloads/cluster_kmeans.tif")
n <- raster::brick("C:/Users/Edward/Downloads/nicfi_changuinola.tif")
proj4string(c)

crs(c) <- CRS("+init=epsg:4326")
crs(n) <- CRS("+init=epsg:4326")
plot(c)
plot(n)

e <- as(extent(-82.53, -82.48, 9.4, 9.45), "SpatialPolygons")
# e <- as(extent(-9185000, -9170000,1048000, 1055000), "SpatialPolygons")


r <- crop(c, e)
r
values(r) %>% table
r[which(values(r) != 3)] <- NA
# r[which(values(r) != 6 & values(r) != 9)] <- NA
plot(r)
# 

# sr = "+proj=longlat +datum=WGS84"
# pr <- projectRaster(r, crs = sr)
# plot(pr)
pal = colors()[1:30]
leaflet() %>% addTiles() %>%
  addEsriBasemapLayer(esriBasemapLayers$Imagery) %>%
  addRasterImage(r, colors = "red", 
                 opacity = 0.3) 


  # addLegend(pal = pal, 
  #           values = values(r),
  #           title = "Clusters")

i = 1
V <- data.frame()
for(i in 0:15){
  xy <- coordinates(c)[which(values(c) == i),]
  v <- extract(n, xy, cellnumbers = F)
  v <- as.data.frame(v)
  v$category <- i
  V <- rbind(V, v)
}
table(V$category)

p1 <- ggplot(V, aes(x = as.factor(category), y = nicfi_changuinola.1))+
  geom_violin()
p2 <- ggplot(V, aes(x = as.factor(category), y = nicfi_changuinola.2))+
  geom_violin()
p3 <- ggplot(V, aes(x = as.factor(category), y = nicfi_changuinola.3))+
  geom_violin()
p4 <- ggplot(V, aes(x = as.factor(category), y = nicfi_changuinola.4))+
  geom_violin()

ggarrange(p1,p2,p3,p4)

ggplot(V, aes(log(nicfi_changuinola.1), log(nicfi_changuinola.4), 
              col = as.factor(category)))+
  #geom_point(alpha = 0.3)+
  stat_ellipse()

V_sum <- V %>% group_by(category) %>% 
  summarise(n1 = median(nicfi_changuinola.1),
            n2 = median(nicfi_changuinola.2),
            n3 = median(nicfi_changuinola.3),
            n4 = median(nicfi_changuinola.4))
V_sum

plot(V_sum$n1, V_sum$n4)
