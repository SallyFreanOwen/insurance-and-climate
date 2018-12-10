# Night time light 

library(raster)

# Set directory path
dirpath = "Data"

# Obtain list of names of TIFs 
nightTifs = list.files(dirpath, pattern = "\\.tif")

# Load first not-avg file in list as raster 
nightR <- raster(paste(dirpath,"/",nightTifs[2],sep=""))

# Specify WGS84 as projection 
wgs84 <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
projection(nightR) <- CRS(wgs84)

plot(nightR)

library(stars)

nightS <- read_stars(paste(dirpath,"/",nightTifs[2],sep=""))



