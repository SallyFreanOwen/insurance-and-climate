
# EQC portfolio import  

setwd("~/EQC-climate-change-part-two")

library(sf) 
# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# Note data deliberately not saved in wd - confidential, only want code in cloud (not data itself)
portfolioRaw <- read.csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/From_Work_Computer/EQC_Portfolio_2017_Motu.csv", stringsAsFactors = FALSE)

# Check columns type - numeric 
sapply(portfolioRaw, class)

portfolioWorking <- portfolioRaw

#sorting out ID
portfolioWorking$PortfolioID <- as.numeric(portfolioRaw$PortfolioID)

rm(portfolioRaw)
