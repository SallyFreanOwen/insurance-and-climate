claimPortfolioSpatialVCS <- claimPortfolioSpatialVCS0004

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[10] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw <= 10)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw >= -10)

#EQC 08 histograms 

library(ggplot2)
ggplot(data=claimPortfolioSpatialVCS) +
  geom_col(claimPortfolioSpatialVCS, 
           mapping = aes(
             x = claimPortfolioSpatialVCS$offset, 
             y = claimPortfolioSpatialVCS$rain
           )
  )

claimPortfolioSpatialVCS <- claimPortfolioSpatialVCS0508

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[10] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw <= 10)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw >= -10)

#EQC 08 histograms 

library(ggplot2)
ggplot(data=claimPortfolioSpatialVCS) +
  geom_col(claimPortfolioSpatialVCS, 
           mapping = aes(
             x = claimPortfolioSpatialVCS$offset, 
             y = claimPortfolioSpatialVCS$rain
           )
  )


claimPortfolioSpatialVCS <- claimPortfolioSpatialVCS0912

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[10] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw <= 10)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw >= -10)

#EQC 08 histograms 

library(ggplot2)
ggplot(data=claimPortfolioSpatialVCS) +
  geom_col(claimPortfolioSpatialVCS, 
           mapping = aes(
             x = claimPortfolioSpatialVCS$offset, 
             y = claimPortfolioSpatialVCS$rain
           ) 
  )

claimPortfolioSpatialVCS <- claimPortfolioSpatialVCS1316

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[10] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw <= 10)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw >= -10)

#EQC 08 histograms 

library(ggplot2)
ggplot(data=claimPortfolioSpatialVCS) +
  geom_col(claimPortfolioSpatialVCS, 
           mapping = aes(
             x = claimPortfolioSpatialVCS$offset, 
             y = claimPortfolioSpatialVCS$rain
           )
  )




