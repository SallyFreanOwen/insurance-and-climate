### Note: to use this file first download data using "NL-00-test-nightlight-import.R" or [insert name of terminal code to download all NOAA tifs here]

# Working with NOAA/NASA nighttime light TIFs 
library(stars)
library(dplyr)
library(sf)
library(raster)

## open test TIFs individually as stars
nl201204 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif")
nl201205 <- read_stars("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.avg_rade9h.tif")

#eyeball one layer:
nl201204 

## ideally we want time as a third dimension 

## NB: at work computer I need to add the below before combined will work:
#memory.limit(100000)

## stars can combine the tifs and create a third dim using their filenames as the new dimension values, but taking on i=[1,n]:
nl_combined <- c(c(nl201204,nl201205))
#eyeball combined:
nl_combined 

#eventually, here add in other layers (monthly to present)

## change newdimname to time 
dimnames(nl_combined)[3]<-"time"

# Crop to NZ property extent 

## create sf object of boundary box around portfolios in NZ 
source("Scripts/EQC-02-portfolio-import.R") # if haven't already loaded eqc property data 
nzboundary <- st_bbox(portfolios)

## crop to NZ boundary box 
#individually:
nl_combined <- st_crop(x=nl_combined, y=nzboundary, crop=TRUE, epsilon=0)

## 

# next steps here:
# crop individually before combine
# add other NL layers to script 