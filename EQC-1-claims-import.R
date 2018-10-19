
# EQC claims import  

setwd("~/EQC-climate-change-part-two")

library(sf) 
# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# import claim data
claimRaw <- read.csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Motu_EQC_LSF_claims_post_2000.csv", stringsAsFactors = FALSE)
# check variable "types"
sapply(claimRaw, class)
head(claimRaw$EventDate)

claimWorking <- claimRaw

sapply(claimWorking, class)

#Sorting out dates
claimWorking$EventDate <- as.Date(claimRaw$EventDate, format = "%Y-%m-%d")
claimWorking$LossDate <- as.Date(claimRaw$LossDate, format = "%Y-%m-%d")
claimWorking$ClaimOpenDate <- as.Date(claimRaw$ClaimOpenDate, format = "%Y-%m-%d")

#sorting out IDs
claimWorking$PortfolioID <- as.numeric(claimRaw$PortfolioID)

rm(claimRaw) 



