# EQC 7 - joining nearest neighbours rain to portfolio 

suppressMessages({
  library(tidyverse);
  library(sf);
  library(rvest);
  library(SearchTrees);
  library(Imap);
  library(leaflet);
  library(htmltools);
  library(SearchTrees)
})


#precipOneDay <- st_as_sf(precipOneDay, coords = c("longitude", "latitude"), crs = 4326)

# filter to just a few for nicer visualization:
#portfolioSample <- portfolioSP[sample(nrow(portfolioSP), 1000, replace=FALSE), ]
#precipOneDaySample <- precipOneDay[sample(nrow(precipOneDay), 1000, replace=FALSE), ]

## Find indices of the two nearest points in A to each of the points in B
tree <- createTree(st_coordinates(precipOneDay))
inds <- knnLookup(tree, newdat=st_coordinates(portfolioSP), k=1) # can be 2 or more
# an experiment - trying to figure out the pairing issues:
#inds <- knnLookup(tree, newdat=st_coordinates(claimSP), k=1) # can be 2 or more

## Show that it worked
#plot(st_coordinates(precipOneDay), pch=1, cex=0.8)
#points(st_coordinates(portfolioSP), 
#     #bg=c("orange","maroon","purple","yellow", "green"), 
#     pch=22, col="forestgreen", cex=1.5)

## Plot nearest neighbour
#points(st_coordinates(precipOneDaySample)[4], pch=21, bg="orange", cex=3)
#points(st_coordinates(portfolioSP)[inds[4,],], pch=16, bg="orange", cex=3)

# Create a tibble of the index 
portfolioNearestGrid <- tibble("niwa_latlon"=precipOneDay$geometry[inds[,1]],
                  "PortfolioID"=portfolioSP$PortfolioID,
                  "portfolio_latlon"=portfolioSP$geometry)

head(portfolioNearestGrid)
tail(portfolioNearestGrid)

# format as dataframe 

library(devtools)
library(sf)

# Re-format neighbour link dataset from tibble to dataframe 
portfolioNearestGrid <- as.data.frame((portfolioNearestGrid))

#rm(inds)
