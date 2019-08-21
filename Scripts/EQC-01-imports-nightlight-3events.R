### Note: to use this file first download data "Scripts/EQC-00-downloading-NL-3events.R" 

## To install stars package:
#devtools::install_github("r-spatial/stars")

# Working with NOAA/NASA nighttime light TIFs 
library(stars)
library(dplyr)
library(sf)
library(raster)

## open night-time light TIFs individually as stars, and crop these to the NZ property extent 

## create sf object of boundary box around portfolios in NZ 
#source("Scripts/EQC-02-portfolio-import.R") # if haven't already loaded eqc property data 
nzboundary <- st_bbox(portfolios)

# read in and crop first event: June 2015
nl201505raw <- read_stars("Data/SVDNB_npp_20150501-20150531_00N060E_vcmcfg_v10_c201506161325.avg_rade9h.tif")
nl201506raw <- read_stars("Data/SVDNB_npp_20150601-20150630_00N060E_vcmcfg_v10_c201508141522.avg_rade9h.tif")
nl201507raw <- read_stars("Data/SVDNB_npp_20150701-20150731_00N060E_vcmcfg_v10_c201509151839.avg_rade9h.tif")
nl201508raw <- read_stars("Data/SVDNB_npp_20150801-20150831_00N060E_vcmcfg_v10_c201509301759.avg_rade9h.tif")
nl201505 <- st_crop(x=nl201505raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201506 <- st_crop(x=nl201506raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201507 <- st_crop(x=nl201507raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201508 <- st_crop(x=nl201508raw, y=nzboundary, crop=TRUE, epsilon=0)
rm(nl201505raw)
rm(nl201506raw)
rm(nl201507raw)
rm(nl201508raw)

nl201610raw <- read_stars("Data/SVDNB_npp_20161001-20161031_00N060E_vcmcfg_v10_c201612011122.avg_rade9h.tif")
nl201611raw <- read_stars("Data/SVDNB_npp_20161101-20161130_00N060E_vcmcfg_v10_c201612191231.avg_rade9h.tif")
nl201612raw <- read_stars("Data/SVDNB_npp_20161201-20161231_00N060E_vcmcfg_v10_c201701271136.avg_rade9h.tif")
nl201701raw <- read_stars("Data/SVDNB_npp_20170101-20170131_00N060E_vcmcfg_v10_c201702241223.avg_rade9h.tif")
nl201610 <- st_crop(x=nl201610raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201611 <- st_crop(x=nl201611raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201612 <- st_crop(x=nl201612raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201701 <- st_crop(x=nl201701raw, y=nzboundary, crop=TRUE, epsilon=0)
rm(nl201610raw)
rm(nl201611raw)
rm(nl201612raw)
rm(nl201701raw)

nl201702raw <- read_stars("Data/SVDNB_npp_20170201-20170228_00N060E_vcmcfg_v10_c201703012030.avg_rade9h.tif")
nl201703raw <- read_stars("Data/SVDNB_npp_20170301-20170331_00N060E_vcmcfg_v10_c201705020851.avg_rade9h.tif")
nl201704raw <- read_stars("Data/SVDNB_npp_20170401-20170430_00N060E_vcmcfg_v10_c201705011300.avg_rade9h.tif")
nl201705raw <- read_stars("Data/SVDNB_npp_20170501-20170531_00N060E_vcmcfg_v10_c201706021500.avg_rade9h.tif")
nl201702 <- st_crop(x=nl201702raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201703 <- st_crop(x=nl201703raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201704 <- st_crop(x=nl201704raw, y=nzboundary, crop=TRUE, epsilon=0)
nl201705 <- st_crop(x=nl201705raw, y=nzboundary, crop=TRUE, epsilon=0)
rm(nl201702raw)
rm(nl201703raw)
rm(nl201704raw)
rm(nl201705raw)

#################

## Now combine, keeping filenames in data, with time as a third dimension: 

## NB: at work computer I probably need to add the below before combined will work:
#memory.limit(100000)

#eventually, here add in other layers (monthly to present)

## change newdimname to time 
#dimnames(nl_combined)[3]<-"time"


## crop to NZ boundary box 
#individually:
#nl_combined <- st_crop(x=nl_combined, y=nzboundary, crop=TRUE, epsilon=0)

## 

# next steps here:
# crop individually before combine
# add other NL layers to script 