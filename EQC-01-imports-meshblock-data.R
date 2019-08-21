
# Census data (cleaned from thesis project) inporting  

#setwd("~/EQC-climate-change-part-two")

library(sf) 
library(lubridate)
# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# import portfolio-meshblock linked data
meshblockRaw <- read.csv("Data/thesis_data.csv", stringsAsFactors = FALSE)
portfoliodMbID <- meshblockRaw[,c("portfolioid", "mb2013")]
rm(meshblockRaw)

#import meshblock-level census vars 
censusRaw <- read.csv("Data/thesis_census_data.csv", stringsAsFactors = FALSE)
mbCensusStats <- censusRaw[,c("mb2013", "Mean_Num_HH_Members_2013", "Median_HH_Income_2013", "Median_Weekly_Rent_Paid_2013", "Prop_Dwelling_Not_Owned_2013")]

rm(censusRaw)

mbStats <- merge(mbCensusStats, portfoliodMbID, by = "mb2013")

rm(mbCensusStats)
rm(portfoliodMbID)
