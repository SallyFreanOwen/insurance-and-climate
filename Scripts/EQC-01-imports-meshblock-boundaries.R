# Importing meshblock boundaries 

library(sf)
library(dplyr)

shapefilename <- "Data/Meshblocks/ESRI_Census_Based_2013_NZTM/ESRI shapefile Output/2013 Digital Boundaries Generalised Full/MB2013_GV_Full.shp"
#"Data/Meshblocks/MB2016_GV_Clipped.shp"
meshblockImportRaw <- st_read(shapefilename)
#check it worked: 
meshblockImportRaw
#plot(meshblockImportRaw)

mbBoundaries2013 <- select(meshblockImportRaw, MB2013) 
mbBoundaries2013 <- st_cast(mbBoundaries2013, "POLYGON")
mbBoundaries2013 <- st_transform(st_geometry(mbBoundaries2013), crs = 4326)

portfolios_sf <- st_geometry(portfolios)
portfolios_wgs84 <- st_transform(portfolios_sf, crs = 4326)

st_crs(portfolios_wgs84)
st_crs(mbBoundaries2013)

portfolioMbID <- st_join(st_buffer(portfolios_wgs84, dist = 5e4), mbBoundaries2013)
