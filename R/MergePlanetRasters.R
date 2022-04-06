######## Merge Bocas Rasters

library(raster)
library(rgdal)

files <- list.files("H:/Bocas_2022_03_07_psscene_analytic_sr_udm2/files/", pattern = "*harmonized_clip.tif", 
                    full.names = TRUE)
Bocas <- list()
for(i in 1:length(files)){
  Bocas[i] <- stack(files[i])    
}

m <- do.call(merge, Bocas)
plot(m)
save(m, file = "H:/Bocas_2022_03_07_psscene_analytic_sr_udm2/bocas.robj")

?raster::merge

plot(Bocas[[1]])
plotRGB(Bocas[[1]], 
        r = 3, g = 2, b = 1, scale = 263)
