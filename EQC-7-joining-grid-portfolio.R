# EQC 7 - joining nearest neighbours rain to portfolio 

# install.packages("nearest")
# st_nearest_points(x, y, ...)


suppressMessages({
  library(tidyverse);
  library(sf);
  library(rvest);
  library(SearchTrees);
  library(Imap)
})

suppressPackageStartupMessages({
  library(leaflet)
  library(htmltools)
})

library(SearchTrees)
#precipOneDay <- st_as_sf(precipOneDay, coords = c("longitude", "latitude"), crs = 4326)

# filter to just a few for nicer visualization:
portfolioSample <- portfolioSP[sample(nrow(portfolioSP), 1000, replace=FALSE), ]
precipOneDaySample <- precipOneDay[sample(nrow(precipOneDay), 1000, replace=FALSE), ]

## Find indices of the two nearest points in A to each of the points in B
tree <- createTree(st_coordinates(precipOneDaySample))
inds <- knnLookup(tree, newdat=st_coordinates(portfolioSample), k=1) # can be 2 or more

## Show that it worked
plot(st_coordinates(precipOneDaySample), pch=1, cex=0.8)
points(st_coordinates(portfolioSample), # randomly selected pts
     #bg=c("orange","maroon","purple","yellow", "green"), 
     pch=22, col="forestgreen", cex=1.5)


## Plot nearest neighbour
#points(st_coordinates(precipOneDaySample)[4], pch=21, bg="orange", cex=3)
#points(st_coordinates(precipOneDaySample)[inds[4,],], pch=16, bg="orange", cex=3)

# Create a dataframe of the index 
inds_df <- tibble("niwann"=inds[,1], 
                  "niwann_ID"=precipOneDaySample$geometry[inds[,1]],
                  "portfolio_nn"=portfolioSample$PortfolioID,
                  "portfolionn_ID"=portfolioSample$geometry)
head(inds_df)

#didn't work v well 
#nearestNeighbours <- st_nearest_points(portfolioSample, precipOneDay)
