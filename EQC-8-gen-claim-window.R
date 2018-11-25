# Step 8

### Generate "claim window"

# Output goal 1: dataframe below
# | claim ID | LossDate | portfolioID | portfolio_latlon | niwa_latlon | niwa_day | rain | 

# suppressing extra data?

claimPortfolioGrid <- merge(claimWorking, portfolioNearestGrid, by = "PortfolioID")

# Adding geometry column to rain
#precipSP <- st_as_sf(precipWorking, coords = c("longitude", "latitude"), crs = 4326)
#claimPortfolioGridRain <- merge(claimPortfolioGrid, precipSP, by.x = "niwa_latlon", by.y = "geometry")

# Splitting out the lat longs 
portfolioNearestGrid$niwa_lon <- st_coordinates(portfolioNearestGrid$niwa_latlon)[,1]
portfolioNearestGrid$niwa_lat <- st_coordinates(portfolioNearestGrid$niwa_latlon)[,2]
#note rounded to 3dp

portfolioGridRain <- merge(portfolioNearestGrid, precipWorking, by.x = c("niwa_lon", "niwa_lat"), by.y = c("longitude", "latitude"), allow.cartesian = TRUE)

claimPortfolioGridWorking8 <- c(claimPortfolioGrid$claimID, claimPortfolioGrid$LossDate, claimPortfolioGrid$PortfolioID, claimPortfolioGrid$WGS84Longitude, claimPortfolioGrid$WGS84Latitude)

# goal 2: 
# add column "offset_day" from -10 to 10 which is niwaday-lossdate 
# add t-10 to t+10 rain



