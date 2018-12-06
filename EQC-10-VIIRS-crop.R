
# EQC - working on looking at the nightlight rasters.... 

library(raster)

# Set directory path
dirpath = "Data"

# Obtain list of names of TIFs 
tifs = list.files(dirpath, pattern = "\\.tif")

# Load first not-avg file in list as raster 
rastertest <- raster(paste(dirpath,"/",tifs[2],sep=""))

# Specify WGS84 as projection 
wgs84 <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
projection(rastertest) <- CRS(wgs84)

plot(rastertest)

