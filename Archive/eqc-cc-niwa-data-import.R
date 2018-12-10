setwd("~/EQC-climate-change-part-two")

### Weather data import take two 

# load the ncdf4 package
library(ncdf4)
# and for using the ncdf4 package:
library(ncdf.tools)

# read in one of the original .nc files from niwa (note this is only one model, and just the historic, 1971-2005)
raindata <- nc_open("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Precip/Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_1971-2005_RCPpast.nc")

# info on the data:
print(raindata)
# print(paste("The file has",raindata$nvars,"variables"))

precip_table <- read.csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Precip/VCSN_Rain5k_1999-2016.csv", sep=";", )
