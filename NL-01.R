# Working with NOAA/NASA nighttime light TIFs 

library(stars)
library(dplyr)
library(sf)
library(raster)

## open test TIFs individually as stars

nl201204 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif")
nl201205 <- read_stars("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.avg_rade9h.tif")
memory.limit(100000)
plot(nl201204) #eyeball
plot(nl201205)
#par(mar = rep(0,4))
#image(y, col = grey((4:10)/10))

##testing multiple layers into stars:
x=c(
  "Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif",
  "Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.avg_rade9h.tif"
  )
y=read_stars(x, quiet=TRUE) 
y

## crop to box around NZ

## create sf object of boundary box around portfolios in NZ 
source("EQC-02-portfolio-import.R") # if haven't already loaded eqc property data 
nzboundary <- st_bbox(portfolios)

## crop TIF to NZ boundary box 
#individually:
nl201204nzsqr <- st_crop(x=nl201204, y=nzboundary)
nl201205nzsqr <- st_crop(x=nl201205, y=nzboundary)
# eyeball
plot(nl201204nzsqr)
plot(nl201205nzsqr)
# as a set of two:
y2 <- st_crop(x=y, y=nzboundary)
#plot(y2)

##extract coordinates 
#nlNzSqrPoints <- st_coordinates(nl201204nzsqr)

## set as sf object
#nlNzSqrPoints$lat <- nlNzSqrPoints$x
#nlNzSqrPoints$long <- nlNzSqrPoints$y
#nlNzSqrPointsSF <- st_as_sf(nlNzSqrPoints, coords = c("long", "lat"), crs = 4326)

##attach portfolio to nearest nlPoint 
#linkTest <- st_nearest_points(portfolios,nlNzSqrPointsSF, pairwise = FALSE)
# above not working yet: Error in CPL_geos_nearest_points(x, st_geometry(y), pairwise) :std::bad_alloc

#--

#Other thoughts: Load the data frames into a list so I can access them by numeric or named index... example:
#  fnames = list.files(path = getwd()) 
## preallocating the list for efficiency (execution speed) 
#dtalist <- vector( "list", length(fnames) ) 
#for (i in seq_len(length(fnames))){ 
#  dtalist[[i]] <- read.csv.sql(fnames[i], sql = "select * from file where V3 == 'XXX' and V5=='YYY'",header = FALSE, sep= '|', eol ="\n")) 
#dtalist[[i]]$date <-  substr(fnames[i],1,8)) 
#} 
#names(dtalist) <- fnames 
## now you can optionally refer to dtalist$file20120424.csv or dtalist[["file20120424"]] if you wish. 

# Ideally would include the gsub of the file's name with the date in it somewhere.. 
