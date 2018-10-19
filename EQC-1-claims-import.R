
# EQC claims import  

setwd("~/EQC-climate-change-part-two")

library(sf) 
# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# import claim data
claimRaw <- read.csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Motu_EQC_LSF_claims_post_2000.csv")
# check variable "types"
sapply(claimRaw, class)
head(claimRaw$EventDate)

claimWorking <- claimRaw
sapply(claimWorking, class)
claimWorking$EventDate <- as.Date(claimWorking$EventDate, format = "%Y-%m-%d")
