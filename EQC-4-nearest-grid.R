# EQC 4 build spatial link between grids and portfolios 


  library(tidyverse);
  library(sf);
  library(rvest);
  library(SearchTrees);
  library(Imap);
  library(leaflet);
  library(htmltools);
  library(SearchTrees)


## Find indices of the two nearest points in A to each of the points in B
tree <- createTree(st_coordinates(vcsnWide))
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) # can be 2 or more

# Create a tibble of the index 
spatial <- tibble("vcsnPoint"=vcsnWide$geometry[inds[,1]],
                               "PortfolioID"=portfolios$portfolioID,
                               "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# format as dataframe 

library(devtools)
library(sf)

# Re-format neighbour link dataset from tibble to dataframe 
portfolioNearestGrid <- as.data.frame((portfolioNearestGrid))

#rm(inds)
