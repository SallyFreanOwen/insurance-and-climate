
# EQC claims import  

# Clear workspace before beginning:
rm(list=ls())

#setwd("~/EQC-climate-change-part-two")

library(sf) 
library(lubridate)

# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# import claim data
claimRaw <- read.csv("Data/Motu_EQC_claims_post_2000.csv", stringsAsFactors = FALSE)
# check variable "types"
sapply(claimRaw, class)
head(claimRaw$EventDate)
names(claimRaw)[1] <- "ClaimID" # first name issue: 

claims <- claimRaw

#Updating names to standard lowerUpper format 
first.letter  <- tolower(substring(names(claims),1, 1))
other.letters <- substring(names(claims), 2)
newnames      <- paste(first.letter, other.letters, sep="")
names(claims) <- newnames

#Sorting out dates
sapply(claims, class)
claims$eventDate <- as.Date(claimRaw$EventDate, format = "%Y-%m-%d")
claims$lossDate <- as.Date(claimRaw$LossDate, format = "%Y-%m-%d")
claims$claimOpenDate <- as.Date(claimRaw$ClaimOpenDate, format = "%Y-%m-%d")
claims$buildingClaimOpenDate <- as.Date(claimRaw$BuildingClaimOpenDate, format = "%Y-%m-%d")
claims$landClaimOpenDate <- as.Date(claimRaw$LandClaimOpenDate, format = "%Y-%m-%d")
claims$contentsClaimOpenDate <- as.Date(claimRaw$ContentsClaimOpenDate, format = "%Y-%m-%d")
claims$buildingClaimCloseDate <- as.Date(claimRaw$BuildingClaimCloseDate, format = "%Y-%m-%d")
claims$landClaimCloseDate <- as.Date(claimRaw$LandClaimCloseDate, format = "%Y-%m-%d")
claims$contentsClaimCloseDate <- as.Date(claimRaw$ContentsClaimCloseDate, format = "%Y-%m-%d")
#claims$latestAssessmentDate <- as.Date(claimRaw$LatestAssessmentDate, format = "%Y-%m-%d")
claims$buildingCoverStartDate <- as.Date(claimRaw$BuildingCoverStartDate , format = "%Y-%m-%d")
claims$buildingCoverEndDate <- as.Date(claimRaw$BuildingCoverEndDate, format = "%Y-%m-%d")

#sorting out IDs
claims$portfolioID <- as.numeric(claimRaw$PortfolioID)
claims$claimID <- as.numeric(claimRaw$ClaimID)

# check other columns 
sapply(claims, class) # note mostly character 
# converting other columns to numeric
claims[12:17] <- lapply(claims, function(x) as.numeric(as.character(x)))
claims[28:31] <- lapply(claims, function(x) as.numeric(as.character(x)))
claims[40] <- lapply(claims, function(x) as.numeric(as.character(x)))
claims[42] <- lapply(claims, function(x) as.numeric(as.character(x)))
# re-check: 
sapply(claims, class)

# keep only landslip / storm / flood claims
claims <- filter(claims, claims$eventType == "Landslip/Storm/Flood")
# and only post-2000 events 
claims <- filter(claims, claims$eventDate > "1999-12-31")
# and only those which can be linked to portfolios 
claims <- filter(claims, claims$portfolioID != "NULL")

claims$eventMonth <- month(claims$eventDate)
claims$eventYear <- year(claims$eventDate)
                           
rm(claimRaw) 
rm(first.letter)
rm(other.letters)
rm(newnames)
