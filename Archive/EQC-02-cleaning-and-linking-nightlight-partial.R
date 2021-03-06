
#NL-02-grid-to-portfolio-join 

#install.packages("SearchTrees")
#install.packages("Imap")

library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(devtools)

test <- st_as_sfc(nl201204, as_points=TRUE, na.rm=TRUE)

## Find indices of the nearest point in A to each of the points in B
tree <- createTree(st_coordinates(test)) #A=nl
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) #B=portfolios #can be 2 or more

# Create a tibble of the index 
spatial <- tibble("nlPoint"=test[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial))

rm(inds)

#NL 3 build portfolio spatial 

portfolioNLSpatial <- merge(portfolios, spatial, by = "portfolioID")

# Splitting out the lat longs 
portfolioNLSpatial$nlLongitude <- st_coordinates(portfolioNLSpatial$nlPoint)[,1]
portfolioNLSpatial$nlLatitude <- st_coordinates(portfolioNLSpatial$nlPoint)[,2]

# Subsetting - only the columns I actually want... 
portfolioNLSpatial_subset <- dplyr::select(portfolioNLSpatial,
                                           portfolioID, 
                                           portfolioLatitude, 
                                           portfolioLongitude, 
                                           nlLatitude, 
                                           nlLongitude)


# Add NL to portfolio info 
claimPortfolioSpatialTestVCSN <- merge(x = claimPortfolioSpatialTestVCSN, y = spatial, by = portfolioID)


 


