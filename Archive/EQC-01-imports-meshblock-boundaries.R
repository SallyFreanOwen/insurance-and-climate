# Importing meshblock boundaries 

library(sf)
library(dplyr)

shapefilename <- "Data/Meshblocks/ESRI_Census_Based_2013_NZTM/ESRI shapefile Output/2013 Digital Boundaries Generalised Full/AU2013_GV_Full.shp"
#"Data/Meshblocks/MB2016_GV_Clipped.shp"
auImportRaw <- st_read(shapefilename)
#check it worked: 
auImportRaw
#plot(meshblockImportRaw)

auBoundaries2013 <- select(auImportRaw, AU2013) 
auBoundaries2013 <- st_cast(auBoundaries2013, "POLYGON")
auBoundaries2013 <- st_transform(st_geometry(auBoundaries2013), crs = 4326)

portfolios_sf <- st_geometry(portfolios)
portfolios_wgs84 <- st_transform(portfolios_sf, crs = 4326)

st_crs(portfolios_wgs84)
st_crs(auBoundaries2013)

portfolioMbID <- st_join(st_buffer(portfolios_wgs84, dist = 5e4), auBoundaries2013)

rm(shapefilename) 

