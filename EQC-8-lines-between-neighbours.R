# EQC 8 

library(devtools)
library(sf)

# Re-format neighbour link dataset from tibble to dataframe 
inds_df <- as.data.frame((inds_df))

# Add ID for each link 
inds_df$pairID <- 1:nrow(inds_df)

# Define group ID  
inds_df <- group_by(inds_df, inds_df$pairID) 
# Keep only point info and link ID 
pairs <- cbind.data.frame(inds_df$niwann_loc, inds_df$portfolionn_loc, inds_df$pairID)
names(pairs) <- c("point.1", "point.2", "pairID")
#pairsLongSample <- pairs[sample(nrow(pairs), 1000, replace=FALSE),]

# Reshape wide to long
## This bit below not working yet 
pairsLong <- reshape(pairs,  direction = "long", varying = 1:2, idvar = "pairID")

# pairsLong <- group_by(pairsLong, pairID) 
# Create linestrings 
pairsLong <- summarise(pairsLong)
pairsLong <- st_cast(pairsLong, "LINESTRING")

#
plot(pairsLong[, 1:2])
#inds_lines <- st_cast(inds_df, "LINESTRING") # not working yet 

