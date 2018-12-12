# EQC nightlight vis  

library(raster)
library(sf)

# note tifs in . not Data/

##Obtain a list of TIF files, load in the first file in list
tifs = list.files("Data", pattern = "\\.tif")
rast1 <- raster(paste("Data", "/", tifs[1], sep=""))
rast2 <- raster(paste("Data", "/", tifs[3], sep=""))
# taking only the avg nighttime light, not the number of observations TIFS 
#rast3 <- raster(paste("Data", "/", tifs[2], sep=""))
#rast4 <- raster(paste("Data", "/", tifs[4], sep=""))

# testing different aggregation options 
stack1 <- stack(rast1, rast2)
#brick1 <- brick(rast1, rast2, rast3, rast4) #couldn't allocate memory 

##Specify WGS84 as the projection of the raster file
wgs84 <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
projection(rast4) <- CRS(wgs84)

plot(rast1)
#plot(stack1)

## crop to NZ only 

#Define crop by min/max from portfolio locations 
#min(portfolios$portfolioLatitude, na.rm=T)
#min(portfolios$portfolioLongitude, na.rm=T)
#max(portfolios$portfolioLatitude, na.rm=T)
#max(portfolios$portfolioLongitude, na.rm=T)
e <- extent(164,178,-47,-35)

# Crop to box around NZ 
test <- crop(rast1, e)

plot(test,
     box = FALSE,
     axes = FALSE,
     main = "First look")

breakpoints <- c(0,1,5,10,20,24)

colors <- c("white", grey.colors(4,start = 0.1,end=0.9), "white")

testr <- ratify(test)

plot(testr,
     breaks=breakpoints,
     box = FALSE,
     axes = FALSE,
     col=colors)

# Convert from raster to points
#spts <- rasterToPoints(test, spatial = TRUE)

# Create simple feature object: 
#nightlighttest <- st_as_sf(spts, crs = 4326)

#######

library(rgdal)
#shape1 <- readOGR(dsn = "Data", layer = "meshblock-2018-generalised")
#shape2 <- read_sf(dsn = "Data", layer = "meshblock-2018-generalised")

#enz <- extent(shape1)

# Crop to around NZ 
#testnz <- crop(rast1, enz)

#Cropping by NZ 

library(maptools)  ## For wrld_simpl
library(raster)

## Example shape of NZ as SpatialPolygonsDataFrame
data(wrld_simpl)
SPDF <- subset(wrld_simpl, NAME=="New Zealand")

plot(SPDF)

## crop and mask
r2 <- crop(rast1, extent(SPDF))
r3 <- mask(r2, SPDF)

#plot(r3)
#plot(SPDF, add=TRUE, lwd=2)

#plot, check it worked:
plot(r3)

e <- extent(164,178,-48,-33)
r4<-crop(r3, e)

plot(r4)

#e2 <- extent(174.72,174.86,-41.33,-41.26)
# Crop to box around welly 
#test2 <- crop(rast1, e2)

#using cropped raster, converting to points (idea being to recreate nearest neighbour method from niwa grid to portfolio link)
r4p <- rasterToPoints(r4, spatial = TRUE)
r4p2 <- st_as_sf(r4p, crs = 4326)

#basic vis:
# Plot one month's "points"
par(mar=c(1,1,1,1)) # (making margins large enough) 
plot(st_geometry(r4p2))
# Plot one month's nightlight values
plot(r4p2$SVDNB_npp_20120401.20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h)

# print summary stats for this data:
#install.packages("stargazer") #needed if working via rocker geospatial
#library(stargazer)
#stargazer(r4p2)

#### Alternately - could use stars 

#library(stars)
#s201404 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif")

#s <- read_stars(c("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif", "Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.cf_cvg.tif"))

#plot(s) #Error: cannot allocate vector of size 3.3 Gb
