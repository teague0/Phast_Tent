############Method 1, interactive################
#####View map interactively using Esri.WorldImagery earth
library(sp)
library(mapview)

##Example with a 500m window

###Pick the extent of your area in meters (UTM)
corners=data.frame(cbind(c(626000,626500),c(1012000,1012500)))

##Convert to long lat 
corners <- sp::SpatialPointsDataFrame(coords = corners[,c(1,2)], data = corners,
                                      proj4string=CRS("+proj=utm +zone=17 +datum=WGS84 +units=m +no_defs"))
corners <- sp::spTransform(corners, CRS("+proj=longlat +datum=WGS84"))

##plot
mapview::mapview(corners, map.types="Esri.WorldImagery")



##########################Method 2###################
### Use known window and plot in ggplot

library(OpenStreetMap)
library(raster)

##example with 200m window
corners=data.frame(cbind(c(626000,626200),c(1012000,1012200)))
corners <- SpatialPointsDataFrame(coords = corners[,c(1,2)], data = corners,
                                  proj4string=CRS("+proj=utm +zone=17 +datum=WGS84 +units=m +no_defs"))
corners <- spTransform(corners, CRS("+proj=longlat +datum=WGS84"))
corners=extent(corners)

map <- openmap(c(lat = corners[3], lon =corners[1]) ,
               c(lat = corners[4], lon = corners[2])  , minNumTiles = 2, type = "bing")
map2 <- raster::raster(map)
map2=raster::projectRaster(from=map2, crs = "+proj=utm +zone=17 +datum=WGS84 +units=m +no_defs")
library(ggplot2)
theme_set(theme_classic())
Island_map=RStoolbox::ggRGB(map2, r = 1, g = 2, b = 3,stretch="lin")
Island_map


###############Method 3##################
###Get large raster of entire study area and them zoom into different areas

####load raster of site###
library(OpenStreetMap)
library(raster)

##the tile size determines the pixel resolution. 256 should be roughly 9 m/pixel.
##16 would be 39 m/pixel, 64 would be 19 m/pixel, 1024 would be 4 m/pixel
map <- openmap(c(lat = 9.131616, lon =-79.87266 ) ,
               c(lat = 9.18339, lon = -79.81712)  , minNumTiles = 256, type = "bing")
###rasterize layer and reproject for to Panama's UTM zone for plotting###
map2 <- raster::raster(map)
map2=raster::projectRaster(from=map2, crs = "+proj=utm +zone=17 +datum=WGS84 +units=m +no_defs")

##save raster so you don't have to download it again.
raster::writeRaster(map2, filename="BCIopenmap.tif", format="GTiff", overwrite=TRUE)

detach("package:OpenStreetMap", unload = TRUE)

rm(map) #remove unprojected map from memory
gc()


#plot, make sure RStoolbox is installed

library(ggplot2)
theme_set(theme_classic())
Island_map=RStoolbox::ggRGB(map2, r = 1, g = 2, b = 3,stretch="lin")

##to zoom into a particular part of the map, use coord_cartesian()
Island_map+coord_cartesian(xlim=c(626000,626500),ylim=c(1012000,1012500))






