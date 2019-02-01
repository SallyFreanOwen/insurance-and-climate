#NL-02-grid-to-portfolio-join 

library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(SearchTrees)
library(devtools)

test <- st_as_sfc(nl_combined, as_points=TRUE, na.rm=TRUE)

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
