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

# If we had read in, for example, a raster time series such as a netcdf with x, y, and time dimensions, 
# stars would return an object that had a third "dimension", such as this example (below) from 
# https://www.r-spatial.org/r/2017/11/23/stars1.html#reading-a-satellite-image, which has "time" with units and time steps

# prec
## stars object with 3 dimensions and 4 attributes
## attribute(s), of first 1e+05 cells:
##   p [(mm/day)]    sd [(mm/day)]       ek [%]       s [gauges per gridcell]
##  Min.   :  0.00   Min.   : 0.00   Min.   :  1.02   Min.   :-99999         
##  1st Qu.:  0.00   1st Qu.: 0.00   1st Qu.: 15.38   1st Qu.:-99999         
##  Median :  0.10   Median : 0.16   Median : 24.70   Median :-99999         
##  Mean   :  1.71   Mean   : 1.74   Mean   : 29.72   Mean   :-65915         
##  3rd Qu.:  0.97   3rd Qu.: 1.14   3rd Qu.: 40.20   3rd Qu.:     0         
##  Max.   :133.53   Max.   :73.51   Max.   :100.00   Max.   :   101         
##  NA's   :66000    NA's   :66000   NA's   :66000                           
## dimension(s):
##      from  to     offset  delta  refsys point values
## x       1 360       -180      1      NA    NA   NULL
## y       1 180         90     -1      NA    NA   NULL
## time    1 365 2013-01-01 1 days POSIXct    NA   NULL

## This being the case, we would ideally like to add a dimension that holds the information from the filename

###For a stars object each dimension has a name
###The meaning of the fields in a single dimension are:

#field:	  meaning:
#from	    the origin index (1)
#to	      the final index (dim(x)[i])
#offset	  the start value for this dimension
#delta	  the step size for this dimension
#refsys	  the reference system, or proj4string
#point	  logical; whether cells refer to points, or intervals
#values	  the sequence of values for this dimension (e.g., geometries)

### So, I'd like to create date, with a monthly time step, and inputing the data from the filename 
# date 
# from=1 to=N offset=2012-04-01 delta=1month refsys=POSIXct? 

# may be a tidier solution in here: https://cran.r-project.org/web/packages/stars/stars.pdf 

#######

#Alternately... 
## 1) Manually add time to a stars object 
mutate(nl201204, time=201204) # adds an attribute containing "time" which is fixed in all grids 
mutate(nl201205, time=201205) # adds an attribute containing "time" which is fixed in all grids 

#then recreate as a raster.. .
r_nl201204 <- as.raster(nl201204)
r_nl201205 <- as.raster(nl201205)

# then reopen as stars... 
test <- read_stars(c(r_nl201204,r_nl201205))

#testing above with smaller object... (requires nl_01 be run first) 
mutate(wgtn201204nzsqr, time=201204) # adds an attribute containing "time" which is fixed in all grids 
mutate(wgtn201205nzsqr, time=201205) # adds an attribute containing "time" which is fixed in all grids 
#and then joining:

# 2) Save data from filename as text string and use this to automate method above 

# Questions to think about later:
# - why/how are avgrad values sometimes negative? 


### 
tif = system.file("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif", package = "stars")
x = read_stars(tif)
(new = c(x, x))
c(new) # collapses two arrays into one with an additional dimension
c(x, x, along = 3)