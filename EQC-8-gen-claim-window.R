# Step 8

### Generate "claim window"

# Output goal 1: dataframe below
# | claim ID | LossDate | portfolioID | portfolio_latlon | niwa_latlon | niwa_day | rain | 

# suppressing extra data?

claimPortfolioGrid <- merge(claimWorking, portfolioNearestGrid, by = "PortfolioID")

# Adding geometry column to rain
precipSP <- st_as_sf(precipWorking, coords = c("longitude", "latitude"), crs = 4326)

claimPortfolioGridRain <- merge(claimPortfolioGrid, precipSP, by.x = "niwa_latlon", by.y = "geometry")

# goal 2: 
# add column "offset_day" from -10 to 10 which is niwaday-lossdate 
# add t-10 to t+10 rain



