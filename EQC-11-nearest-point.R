# EQC 11 build spatial link between VIIRS points and portfolios 

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
tree <- createTree(st_coordinates(r4p2))
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) # can be 2 or more

# Create a tibble of the index 
spatial <- tibble("viirsPoint"=r4p2$geometry[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial))

rm(inds)
