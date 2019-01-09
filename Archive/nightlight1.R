library(doParallel)
library(foreach)
library(raster)
library(sp)
library(rgdal)
library(ggmap)
library(plotly)

##Set directory path
imagery = "imagery"

##Obtain a list of TIF files, load in the first file in list
tifs = list.files(imagery, pattern = "\\.tif")
rast <- raster(paste(imagery,"/",tifs[1],sep=""))
rast2 <- raster(paste(imagery,"/",tifs[2],sep=""))
rast3 <- raster(paste(imagery,"/",tifs[3],sep=""))
rast4 <- raster(paste(imagery,"/",tifs[4],sep=""))

##Specify WGS84 as the projection of the raster file
wgs84 <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
projection(rast4) <- CRS(wgs84)

library(raster)
plot(rast)

##Draw down NZ boundary Shapefile
library(rgdal)
nz_shp <- readOGR("nz-island-polygons-topo-150k.shp")
projection(nz_shp) <- CRS(wgs84)

# set up the graph layout with no margins (mai), with 7 rows and 5 columns (mfrow), with a navy blue background (bg).
par(mai=c(0,0,0,0),mfrow = c(7,5),bg='#001a4d', bty='n') 

ggplot(nz_shp)

library(maps)
  nz <- map_data("nz")
  # Prepare a map of NZ
  nzmap <- ggplot(nz, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "white", colour = "black")
  
  nzmap
  
  coords <- data.frame() ##place holder
  
 