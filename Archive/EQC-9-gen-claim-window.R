# Step 9 

### Generate "claim window"

# claim$claimID->claim$claimLossDate->claim$PortfolioID->portfolio$portfoliolocation->precip$gridlocation->precip$rainfromday=LossDate-10today=LossDate+10 

# The plan: working backwards... 

# isolate grids that actually contain claims 
# for each of those gridIDs, attach necessary claim LossDates 
# claim windows: keep only grid-day combos that fall within claim windows 

# Output goal: dataframe below
# | claim ID | grid lat | grid lon | Lossdate | Precip t-10 through t+10 | 

