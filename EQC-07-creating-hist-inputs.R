
# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[10] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2000-12-01")
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "1999-01-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw <= 10)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw >= -10)
