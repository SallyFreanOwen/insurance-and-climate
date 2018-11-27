
# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[10] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw <= 10)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw >= -10)


