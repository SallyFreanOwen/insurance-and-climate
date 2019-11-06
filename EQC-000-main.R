######################################

# Deep South Project - EQC and Climate Change Part 2 
# Community recovery post-landslip/storm/flooding events 
# Authors: Ilan Noy, Sally Owen, David Fleming

# Master code - calls other files

# Code scripted by: Sally

######################################

setwd("~/EQC-climate-change-part-two")

######################################

### If working on a new computer:

##0a) R package installation:
#source("EQC-00.r")
##
## 0b) Nightlight data collection:
#source("EQC-00-downloading-NL-3events.r")
##
## 0c) Parsing Niwa Historic Events Catalog:
#source("EQC-00-parsing-HW-catalog.r")

######################################

### Importing and pre-processing data: 

#1a) CLAIMS
source("Scripts/EQC-01-imports-claims.r")
# Inputs: EQC claims dataset and publically available street names geo-coding
# Outputs: claims.Rdata 

#1b) PORTFOLIOS
source("Scripts/EQC-01-imports-portfolio.r")
# Inputs: EQC portfolio data, and Jacob's hydrology and slope data 
# Outputs: portfolios.Rdata

#1c) RAIN
source("Scripts/EQC-01-imports-rain.r")
# Inputs: NIWA's netcdf files from 2011 (can do from 1999) to 2018 
# Outputs: vcsn.Rdata and vcsnWide.Rdata

#1d) NIGHT_TIME LIGHT
#source("Scripts/EQC-00-downloading-NL-3events.r")
source("Scripts/EQC-01-imports-nightlight-3events.r")
# Inputs: full nl tifs for months around three major events 
# Outputs: twelve stars objects named as "nlYYYYMM" saved as .rData 

#1e) CENSUS DATA
source("Scripts/EQC-01-imports-meshblock-data.r")
# Inputs: StatsNZ 2013 HH census variables, EQC portfolios, 
# Outputs: MBStats.r (portfolioIDs with mb level census data) 

#1f) HISTORIC WEATHER CATALOG 
#source("Scripts/EQC-00-parsing-HW-catalog.r")
source("Scripts/EQC-01-imports-HW-catalog.r")

#save.image("~/insurance-and-climate/Data/data-insurance-and-climate.RData")

######################################

### Linking and geo-processing: 
source("Scripts/EQC-02-processing.r")
# makes portfolios spatial 
# matches each to nearest rain grid coordinate 
# attaches rain grid lat and lon as vars to each portfolio 
# repeats process above for nightlight data 
# Inputs: portfolios.rData, vcsn.Rdata, nlYYYYMM set of .rData, 
# Outputs: as before, but with portfolios.rData (vcsn and NL latlon ids appended) 

#load("~/insurance-and-climate/Data/data-insurance-and-climate.RData"))

#save.image("~/insurance-and-climate/data-insurance-and-climate-post-processed.RData"))

######################################

# Alternate short inputs: 
# load("~/insurance-and-climate/Data/data-insurance-and-climate.RData"))

### Box plots 
source("Scripts/EQC-02-graphic.R")
#Inputs: data-insurance-and-climate.RData)
# NB save plot  at this stage 
# Output: Figures/"Rplot - rain boxplots by loss date offset.png"

# load("~/insurance-and-climate/Data/data-insurance-and-climate.RData))
# load("~/insurance-and-climate/Data/data-insurance-and-climate-post-processed.RData))

##########################

### Processsing and regression analysis per event: 
source("Scripts/EQC-03a-Event1-Processing-and-reg-analysis.r")
source("Scripts/EQC-03b-Event2-processing-and-reg.r")
source("Scripts/EQC-03a-Event3-processing-and-reg.r")
