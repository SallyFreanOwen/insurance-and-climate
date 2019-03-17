# Importing meshblock boundaries 

library(sf)

shapefilename <- "Data/Meshblocks/ESRI_Census_Based_2013_NZTM/ESRI shapefile Output/2013 Digital Boundaries Generalised Full/MB2013_GV_Full.shp"
  #"Data/Meshblocks/MB2016_GV_Clipped.shp"
meshblockImportRaw <- st_read(shapefilename)
#check it worked: 
meshblockImportRaw
#plot(meshblockImportRaw)

meshblockImportRaw %>% 
st_transform(crs = "+proj=moll +datum=WGS84")

meshblockImportTest2 <- st_cast(meshblockImportRaw$geometry, "POLYGON")
meshblockImportTest2

#plot(meshblockImportRaw$mb2016)

rm(shapefilename) 




