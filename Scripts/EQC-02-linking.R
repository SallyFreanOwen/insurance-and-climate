# THis file builds the spatial link between grids and portfolios 

library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(SearchTrees)
library(devtools)

## Find indices of the two nearest points in A to each of the points in B
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

# Build claim portfolio spatial 

claimPortfolio <- merge(claims, portfolios, by = "portfolioID") 
claimPortfolioSpatial <- merge(claimPortfolio, spatial, by = "portfolioID")

# Add rain data 

# Splitting out the lat longs 
claimPortfolioSpatial$vcsnLongitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,1]
claimPortfolioSpatial$vcsnLatitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,2]

# Subsetting - only the columns I actually want... 
claimPortfolioSpatial <- dplyr::select(claimPortfolioSpatial,
                                         claimID, 
                                         portfolioID, 
                                         lossDate, 
                                         portfolioLatitude, 
                                         portfolioLongitude, 
                                         vcsnLatitude, 
                                         vcsnLongitude)

