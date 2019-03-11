
#if you're on a slow computer: create subsets 
claim0004 <- filter(claimPortfolioSpatial06, 
                    claimPortfolioSpatial06$lossDate > "1999-12-31", 
                    claimPortfolioSpatial06$lossDate < "2005-01-01")
claim0508 <- filter(claimPortfolioSpatial06, 
                    claimPortfolioSpatial06$lossDate > "2004-12-31", 
                    claimPortfolioSpatial06$lossDate < "2009-01-01")
claim0912 <- filter(claimPortfolioSpatial06, 
                    claimPortfolioSpatial06$lossDate > "2008-12-31", 
                    claimPortfolioSpatial06$lossDate < "2013-01-01")
claim1316 <- filter(claimPortfolioSpatial06, 
                    claimPortfolioSpatial06$lossDate > "2012-12-01", 
                    claimPortfolioSpatial06$lossDate < "2017-01-01")
vcsn0004 <- filter(vcsn, 
                   vcsn$vcsnDay > "1999-12-31",
                   vcsn$vcsnDay < "2005-01-01")
vcsn0508 <- filter(vcsn, 
                   vcsn$vcsnDay > "2004-12-31",
                   vcsn$vcsnDay < "2009-01-01")
vcsn0912 <- filter(vcsn, 
                   vcsn$vcsnDay > "2008-12-31",
                   vcsn$vcsnDay < "2013-01-01")
vcsn1316 <- filter(vcsn, 
                   vcsn$vcsnDay > "2012-12-31",
                   vcsn$vcsnDay < "2017-01-01")

#add rainfall to claim info (subsets)
claimPortfolioSpatialVCS0004 <- merge(claim0004, vcsn0004, by = c("vcsnLongitude", "vcsnLatitude"))
claimPortfolioSpatialVCS0508 <- merge(claim0508, vcsn0508, by = c("vcsnLongitude", "vcsnLatitude"))
claimPortfolioSpatialVCS0912 <- merge(claim0912, vcsn0912, by = c("vcsnLongitude", "vcsnLatitude"))
claimPortfolioSpatialVCS1316 <- merge(claim1316, vcsn1316, by = c("vcsnLongitude", "vcsnLatitude"))

# Add rainfall to claim info 
#claimPortfolioSpatialVCS <- merge(claimPortfolioSpatial06, vcsn, by = c("vcsnLongitude", "vcsnLatitude"))

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

