# Importing meshblock boundaries 

library(sf)

shapefilename <- "Data/Meshblocks/MB2016_GV_Clipped.shp"
meshblockImportRaw <- st_read(shapefilename)
#check it worked: 
#plot(testMeshblockImport)

rm(shapefilename) 
rm(testMeshblockImport)



