#NL 3 build portfolio spatial 

portfolioNLSpatial <- merge(portfolios, spatial, by = "portfolioID")

# EQC 6 - add rain data 

# Splitting out the lat longs 
PortfolioGridSpatial$vcsnLongitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,1]
claimPortfolioSpatial$vcsnLatitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,2]

# Subsetting - only the columns I actually want... 
claimPortfolioSpatial06 <- dplyr::select(claimPortfolioSpatial,
                                         claimID, 
                                         portfolioID, 
                                         lossDate, 
                                         portfolioLatitude, 
                                         portfolioLongitude, 
                                         vcsnLatitude, 
                                         vcsnLongitude)

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


