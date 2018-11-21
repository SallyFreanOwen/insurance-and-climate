# Step 9 

### Generate "claim window"

# claim$claimID->claim$claimLossDate->claim$PortfolioID->portfolio$portfoliolocation->precip$gridlocation->precip$rainfromday=LossDate-10today=LossDate+10 

# The plan: working backwards... 

# isolate grids that actually contain claims 
# for each of those gridIDs, attach necessary claim LossDates 
# claim windows: keep only grid-day combos that fall within claim windows 

# Output goal: dataframe below
# | claim ID | grid lat | grid lon | Lossdate | Precip t-10 through t+10 | 

named_pairs <- cbind.data.frame(inds_df$niwann, inds_df$niwann_loc, inds_df$portfolionn_loc, inds_df$pairID, inds_df$portfolionn_ID)
names(named_pairs) <- c("niwa_grid", "niwa_loc", "pairID", "PortfolioID")

claimWorking <- merge(claimWorking, named_pairs, by = "PortfolioID")

# Building a histogram for one claim 

claimExample <- claimWorking[1,]


g = claimExample$niwa_grid

tryingsomethingout <- filter(precipWorking, precipWorking$day == claimExample$LossDate)

test <- subset(precipWorking, day > "2007-12-19" & day < "2007-12-21")
# Noticed issue here - working in theory - but precip day stops :/ 

precipWorking %>%
  group_by()


