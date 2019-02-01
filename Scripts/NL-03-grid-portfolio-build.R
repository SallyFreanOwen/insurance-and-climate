#NL 3 build portfolio spatial 

portfolioNLSpatial <- merge(portfolios, spatial, by = "portfolioID")

# Splitting out the lat longs 
portfolioNLSpatial$nlLongitude <- st_coordinates(portfolioNLSpatial$nlPoint)[,1]
portfolioNLSpatial$nlLatitude <- st_coordinates(portfolioNLSpatial$nlPoint)[,2]

# Subsetting - only the columns I actually want... 
portfolioNLSpatial_subset <- dplyr::select(portfolioNLSpatial,
                                         portfolioID, 
                                         portfolioLatitude, 
                                         portfolioLongitude, 
                                         nlLatitude, 
                                         nlLongitude)


#add NL to portfolio info 
portfolioNL <- merge(portfolioNLSpatial_subset, nl_combined, by = c("nlLongitude", "nlLatitude"))

# Add rainfall to claim info 
#claimPortfolioSpatialVCS <- merge(claimPortfolioSpatial06, vcsn, by = c("vcsnLongitude", "vcsnLatitude"))


