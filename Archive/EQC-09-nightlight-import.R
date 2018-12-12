<<<<<<< HEAD


# Downloading:
download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201204/vcmcfg/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
  destfile="Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz"
)
download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201205/vcmcfg/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
  destfile="Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz"
)

# Unzipping raw downloads: 
library(R.utils)

gunzip("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
       destname="Data/S201204.tar")
gunzip("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
       destname="Data/S201205.tar")
untar("Data/S201204.tar", exdir="Data")
untar("Data/S201205.tar", exdir="Data")


# Note full set downloaded directly through the terminal - using url codes in the urls.txt file 
=======


# Downloading:
download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201204/vcmcfg/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
  destfile="Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz"
)
download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201205/vcmcfg/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
  destfile="Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz"
)

# Unzipping raw downloads: 
library(R.utils)

gunzip("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
       destname="Data/S201204.tar")
gunzip("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
       destname="Data/S201205.tar")
untar("Data/S201204.tar", exdir="Data")
untar("Data/S201205.tar", exdir="Data")

library(raster)
library(sf)

# note tifs in . not Data/

##Obtain a list of TIF files, load in the first file in list
tifs = list.files("Data", pattern = "\\.tif")
rast1 <- raster(paste("Data", "/", tifs[1], sep=""))
rast2 <- raster(paste("Data", "/", tifs[2], sep=""))
rast3 <- raster(paste("Data", "/", tifs[3], sep=""))
rast4 <- raster(paste("Data", "/", tifs[4], sep=""))

# testing different aggregation options 
stack1 <- stack(rast1, rast2, rast3, rast4)
#brick1 <- brick(rast1, rast2, rast3, rast4) #couldn't allocate memory 

##Specify WGS84 as the projection of the raster file
wgs84 <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
projection(rast4) <- CRS(wgs84)

#plot(rast1)
#plot(stack1)

## crop to NZ only 

#Define crop by min/max from portfolio locations 
#min(portfolios$portfolioLatitude, na.rm=T)
#min(portfolios$portfolioLongitude, na.rm=T)
#max(portfolios$portfolioLatitude, na.rm=T)
#max(portfolios$portfolioLongitude, na.rm=T)
e <- extent(165,179,-48,-34)

# Crop to box around NZ 
test <- crop(rast1, e)

plot(test,
     box = FALSE,
     axes = FALSE,
     main = "First look")

# Convert from raster to points
spts <- rasterToPoints(test, spatial = TRUE)

# Create simple feature object: 
nightlighttest <- st_as_sf(spts, crs = 4326)

# Seem to have way too many - could ask for only positive values, or crop to NZ shape? 
nightlighttest2 <- filter(nightlighttest, 
                          nightlighttest$SVDNB_npp_20120401.20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg>1, 
                          nightlighttest$SVDNB_npp_20120401.20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg<24)

#######

e2 <- extent(174.72,174.86,-41.33,-41.26)
# Crop to box around welly 
test2 <- crop(rast1, e2)

plot(test2,
     box = FALSE,
     col=grey(1:100/100),
     main = "First look")


#### Alternately - could use stars 

#library(stars)
#s201404 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif")

#s <- read_stars(c("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif", "Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.cf_cvg.tif"))

#plot(s) #Error: cannot allocate vector of size 3.3 Gb



>>>>>>> 9788d298414bde8ee35a2a76e4ffe52989580d3e
