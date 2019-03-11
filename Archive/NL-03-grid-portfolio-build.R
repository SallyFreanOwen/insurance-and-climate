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


# Add NL to portfolio info 
claimPortfolioSpatialTestVCSN <- merge(x = claimPortfolioSpatialTestVCSN, y = spatial, by = portfolioID)

