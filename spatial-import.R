setwd("~/EQC-climate-change-part-two")

# install.packages("sp")
# install.packages("tidyverse")
library(sp)
library(tidyverse)

## for import of external spatial formats:
# install.packages("rgdal") 
# install.packages("maptools")

#precip_historic <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/From_Work_Computer/VCSN_Rain5k_1999-2016.csv")

portfolio_raw <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/From_Work_Computer/EQC_Portfolio_2017_Motu.csv")
head(portfolio_raw)
# Set coordinates (in doing so promote argument from dataframe to SpatialPointsDataFrame)
coordinates(portfolio_raw) <- portfolio_raw[c("WGS84Longitude", "WGS84Latitude")]

# Eyeballing the data
summary(portfolio_raw)
#dimensions(portfolio_raw)
#class(portfolio_raw)
str(portfolio_raw)
plot(portfolio_raw)

claim_raw <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Motu_EQC_LSF_claims_post_2000.csv")
head(claim_raw)

claim_geo <- merge(claim_raw, portfolio_raw, by="PortfolioID")
coordinates(claim_geo) <- claim_geo[c("WGS84Longitude", "WGS84Latitude")]
plot(claim_geo)

# Get coastal and country world maps as Spatial objects
install.packages("rnaturalearth")
library(rnaturalearth)
coast_sp <- ne_coastline(scale = "medium")
countries_sp <- ne_countries(scale = "medium")




