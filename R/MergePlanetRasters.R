######## Merge Bocas Rasters

library(raster)
library(rgdal)
library(rgeos)

# turn off factors
options(stringsAsFactors = FALSE)

# files <- list.files("H:/Bocas_2022_03_07_psscene_analytic_sr_udm2/files/", pattern = "*harmonized_clip.tif", 
#                     full.names = TRUE)
# Bocas <- list()
# for(i in 1:length(files)){
#   Bocas[i] <- stack(files[i])    
# }
# 
# m <- do.call(merge, Bocas)

# save(m, file = "H:/Bocas_2022_03_07_psscene_analytic_sr_udm2/bocas.robj")
m <- brick("../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Bocas.tif")
plot(m)
<<<<<<< HEAD

outfile <- writeRaster(m, filename='../../../Dropbox/MPI/Phyllostomus/Fieldwork/Data/Bocas.tif', 
                       format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))

save(m, file = "H:/Bocas_2022_03_07_psscene_analytic_sr_udm2/bocas.robj")
=======
>>>>>>> 5872c8892fb7b11f65e1b38572cb25985f53b4aa

names(m)
#par(col.axis = "white", col.lab = "white", tck = 0)
plotRGB(m,
        r = 3, g = 2, b = 1,
        stretch = "lin",
        axes = TRUE,
        main = "RGB composite image\n Landsat Bands 4, 3, 2")
box(col = "white")


