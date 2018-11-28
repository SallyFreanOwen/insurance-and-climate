#EQC 08 histograms 

#library(lattice)
#barchart(claimPortfolioSpatialVCS$offset)

library(ggplot2)
ggplot(data=claimPortfolioSpatialVCS) +
geom_col(claimPortfolioSpatialVCS, mapping = aes(x=claimPortfolioSpatialVCS$offset, y=claimPortfolioSpatialVCS$rain))

