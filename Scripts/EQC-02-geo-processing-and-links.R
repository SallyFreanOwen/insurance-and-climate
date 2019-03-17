# This file: 
# 1) builds the spatial link between precip grids and portfolios
# 2) builds the spatial link between NL grids and portfolios 
# 3) merges these together to create a complete link from claims through portfolios to NL and precip IDs 

library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(SearchTrees)
library(devtools)

### First, the precip link:

# Finding indices of the two nearest points in A(rain) to each of the points in B(portfolios)
tree <- createTree(st_coordinates(vcsnWide))
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) # can be 2 or more

# Create a tibble of the index 
spatial <- tibble("vcsnPoint"=vcsnWide$geometry[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)
head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial))

# Splitting out the lat longs 
spatial$vcsnLongitude <- st_coordinates(spatial$vcsnPoint)[,1]
spatial$vcsnLatitude <- st_coordinates(spatial$vcsnPoint)[,2]

portfolioVcsnID <- spatial

rm(inds)
rm(spatial)
rm(tree)
rm(vcsnWide)

#Drop the points (portfolio and precip sf points columns) 
library(tidyr)
library(tidyverse)

portfolioVcsnID <- portfolioVcsnID[c("portfolioID", "vcsnLongitude", "vcsnLatitude")]

### Second, the claim link (attaching all claims)
claimPortfolioVcsnID <- merge(claims, portfolioVcsnID, by = "portfolioID", all.y = TRUE)
claimPortfolioVcsnID <- claimPortfolioVcsnID[c("claimID", "portfolioID", "eventDate", "lossDate", "numberofDwellingsInsured", "claimStatus", "buildingPaid", "landPaid", "vcsnLongitude", "vcsnLatitude")]
claimPortfolioVcsnID$claimed <- ifelse(claimPortfolioVcsnID$claimID=="NA", 0, 1)

### Third, from the claim-precip link, attaching relevant rainfall... 
claimPortfolioVcsnID$eventMonth <- month(claimPortfolioVcsnID$lossDate)
claimPortfolioVcsnID$eventPreMonth <- c(claimPortfolioVcsnID$eventMonth-1)
claimPortfolioVcsnID$eventPostMonth <- c(claimPortfolioVcsnID$eventMonth+1)
# Note to self: fix the January/December link here! 
claimPortfolioVcsnID$eventYear <- year(claimPortfolioVcsnID$lossDate)
claimPortfolioVcsnID$vcsnDay <- claimPortfolioVcsnID$lossDate
claimPortfolioVcsn <- merge(claimPortfolioVcsnID, vcsn, by = c("vcsnDay", "vcsnLatitude", "vcsnLongitude"))
#claimPortfolioVcsn <- claimPortfolioVcsn[1:-1]
claimPortfolioVcsnFull <- merge(claimPortfolioVcsnID, claimPortfolioVcsn, by = "claimID", all.x = TRUE)
stat.desc(claimPortfolioVcsnFull[,sapply(claimPortfolioVcsnFull,is.numeric)], basic=F)

#claimPortfolioVcsn <- merge(claimPortfolioVcsnID, vcsn, by = c("vcsnDay", "vcsnLatitude", "vcsnLongitude", all.x = TRUE))

### Third, NL to portfolios link 
nl201204sf <- st_as_sfc(nl201204, as_points=TRUE, na.rm=TRUE)

## Find indices of the nearest point in A to each of the points in B
tree <- createTree(st_coordinates(nl201204sf)) #A=nl
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) #B=portfolios #can be 2 or more

# Create a tibble of the index 
spatial <- tibble("nlPoint"=test[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial[1:2] <- as.data.frame((spatial)) #dropping portfolioPoint (unnecessary now)

# merge onto portfolio data
portfolioVcsnNlID <- merge(portfolioVcsnID, spatial, by = "portfolioID")

# Splitting out the lat longs 
portfolioVcsnNlID$nlLongitude <- st_coordinates(portfolioVcsnNlID$nlPoint)[,1]
portfolioVcsnNlID$nlLatitude <- st_coordinates(portfolioVcsnNlID$nlPoint)[,2]

head(portfolioVcsnNlID)

rm(inds)
rm(tree)
rm(spatial)
