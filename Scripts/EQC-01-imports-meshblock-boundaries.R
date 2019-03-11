# Importing meshblock boundaries 

library(sf)

shapefilename <- "Data/Meshblocks/MB2016_GV_Clipped.shp"
testMeshblockImport <- st_read(shapefilename)
#check it worked: 
#plot(testMeshblockImport)
#yes it did - but need internet to figure out how to merge this with other sources... 



