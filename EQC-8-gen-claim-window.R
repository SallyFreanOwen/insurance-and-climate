# Step 8

### Generate "claim window"

# Output goal 1: dataframe below
# | claim ID | LossDate | portfolioID | portfolio_latlon | niwa_latlon | niwa_day | rain | 

claimPortfolioGrid <- merge(claimWorking, portfolioNearestGrid, by = "PortfolioID")
# goal 2: 
# add column "offset_day" from -10 to 10 which is niwaday-lossdate 
# add t-10 to t+10 rain? 



