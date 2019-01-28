### Note: to use this file first download data using "NL-00-test-nightlight-import.R" or [insert name of terminal code to download all NOAA tifs here]

# Working with NOAA/NASA nighttime light TIFs 

library(stars)
library(dplyr)
library(sf)
library(raster)

## open test TIFs individually as stars

nl201204 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif")
nl201205 <- read_stars("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.avg_rade9h.tif")

nl201204 ####  should return: 
#stars object with 2 dimensions and 1 attribute
#attribute(s), summary of first 1e+05 cells:
#  SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif 
#Min.   :-0.39000                                                            
#1st Qu.: 0.00000                                                            
#Median : 0.07000                                                            
#Mean   : 0.08977                                                            
#3rd Qu.: 0.17000                                                            
#Max.   : 5.80000                                                            
#dimension(s):
#  from    to     offset       delta                       refsys point values    
#x    1 28800    59.9979  0.00416667 +proj=longlat +datum=WGS8... FALSE   NULL [x]
#y    1 15600 0.00208333 -0.00416667 +proj=longlat +datum=WGS8... FALSE   NULL [y]
### unfortunately doesn't seem to have time or date information stored in the stars object created direct from the .tif 

### Stars functionality for time:
## ideally we want time as a third dimension 

## NB: at work computer I need to add the below before combined will work:
#memory.limit(100000)

## stars can combine the tifs and create a third using their filenames:
nl_combined <- c(c(nl201204,nl201205))

## next steps? 
# simplify filenames to only the relevant time characters
# figure out how to change newdimname to time 