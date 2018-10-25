# EQC 7 - joining nearest neighbours rain to portfolio 

# install.packages("nearest")
# st_nearest_points(x, y, ...)

portfolioSample <- portfolioSP[sample(nrow(portfolioSP), 50, replace=FALSE), ]


#didn't work v well 
#nearestNeighbours <- st_nearest_points(portfolioSample, precipOneDay)
