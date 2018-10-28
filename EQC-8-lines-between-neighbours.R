# EQC 8 

library(devtools)
library(sf)

test <- str(st_linestring(rbind(inds_df$niwann_loc, inds_df$portfolionn_loc)))
# Map a few nearest neighbours (a sense check) 
#inds_lines <- st_cast(inds_df, "LINESTRING") # not working yet 