# Import Census Data 

library(sf) 
# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# import Census data
censusDwellingRaw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Dwelling.csv", stringsAsFactors = FALSE)
censusFamilyRaw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Family.csv", stringsAsFactors = FALSE)
censusHouseholdRaw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Household.csv", stringsAsFactors = FALSE)
censusIndividual1Raw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Individual-Part-1.csv", stringsAsFactors = FALSE)
censusIndividual2Raw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Individual-Part-2.csv", stringsAsFactors = FALSE)
censusIndividual3ARaw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Individual-Part-3a.csv", stringsAsFactors = FALSE)
censusIndividual3BRaw <- read.csv("Data/2013-mb-dataset-Total-New-Zealand-Individual-Part-3b.csv", stringsAsFactors = FALSE)

sapply(censusDwellingRaw, class)
