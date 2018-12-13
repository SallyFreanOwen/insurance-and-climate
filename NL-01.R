# Working with NOAA/NASA nighttime light TIFs 

library(stars)

## open test TIF
nl201204 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif")
str(nl201204) # print details 
plot(nl201204) #eyeball

## crop to box around NZ

# create sf object of boundary box around portfolios in NZ 
#source(EQC-02-portfolio-import.R) # if haven't already loaded eqc property data 
nzboundary <- st_bbox(portfolios)

# crop TIF to that sf object 
nl201204nzsqr <- st_crop(x=nl201204, y=nzboundary)
# eyeball
plot(nl201204nzsqr)

##extract coordinates 

#nlNzSqrPoints <- st_coordinates(nl201204nzsqr)
# set as sf object
#nlNzSqrPoints$lat <- nlNzSqrPoints$x
#nlNzSqrPoints$long <- nlNzSqrPoints$y
#nlNzSqrPointsSF <- st_as_sf(nlNzSqrPoints, coords = c("long", "lat"), crs = 4326)



#attach portfolio to nearest nlPoint 
#linkTest <- st_nearest_points(portfolios,nlNzSqrPointsSF, pairwise = FALSE)
# above not working yet: Error in CPL_geos_nearest_points(x, st_geometry(y), pairwise) :std::bad_alloc