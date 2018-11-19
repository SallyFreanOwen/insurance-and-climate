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
#pairsample <- pairs[sample(nrow(pairs), 1000, replace=FALSE),]

# Reshape wide to long (manually as reshape not happy with the geometries)
#pairs1 <- cbind.data.frame(pairs$point.1, pairs$pairID)
#names(pairs1) <- c("point", "pairID")
#pairs2 <- cbind.data.frame(pairs$point.2, pairs$pairID)
#names(pairs2) <- c("point", "pairID")
#pairsLong <- rbind.data.frame(pairs1, pairs2)

#pairsST <- st_combine(c(pairs$point.1, pairs$point.2))

#memory.limit(size=50000)

# Number of total linestrings to be created
n <- 1613035

# Build info for linestrings
linestrings <- lapply(X = 1:n, FUN = function(x) {
  
  pair <- st_combine(c(pairs$point.1[x], pairs$point.2[x]))
  line <- st_cast(pair, "LINESTRING")
  return(line)
  
})

# Geo-process linestrings 
multilinestring <- st_multilinestring(do.call("rbind", linestrings))
plot(multilinestring)

# NB: modified using this ref:
# https://gis.stackexchange.com/questions/270725/r-sf-package-points-to-multiple-lines-with-st-cast/270894#270894 

### When using portfolioSP as the base data, and asking for all the nn lines (1613035), this error recieved:
### "Error: memory exhausted (limit reached?)
### Graphics error: Plot rendering error"
