# Extracting coordinates for Jacob and David, 
# of the girds from the shapefile sent to Jacob (the grids from a 
# single timeslice of Abha's CCII data) ')

# Sally Owen
# December 2017 

library(raster)
library(sp)

require(rgda1)

# Set working directory
getwd()
setwd("R:/Agriculture/Deep_South_Challenge_2017/R code")

# read in the shapefile sent to Jacob
full_grid <- readOGR(dsn = "R:/Agriculture/Deep_South_Challenge_2017/R code", layer = "TotalPrecip")

# Have a look at the dataframe (includes meta data etc)
View(full_grid)
# Have a look at the map 
plot(full_grid)

#extract coordinates
# coordinates(full_grid) (this didn't really work when tryign to export)

lin_full <- as(full_grid, "SpatialLinesDataFrame") 
pts_full <- as.data.frame(as(lin_full, "SpatialPointsDataFrame"))
write.csv(pts_full, "LayerID_with_coordinates_full_grid.csv")

# and now just the grids which have properties...
# This is the file  emailed to Jacob and David 
grids_with_properties <- readOGR(dsn = "R:/Agriculture/Deep_South_Challenge_2017/R code", layer = "properties_per_grid_cell__")
#Have a look
plot(grids_with_properties)
# This has all the properties - need to drop the zeroes

lin_properties <- as(grids_with_properties, "SpatialLinesDataFrame") 
pts_properties <- as.data.frame(as(lin_properties, "SpatialPointsDataFrame"))
write.csv(pts_properties, "LayerID_with_coordinates_full_grid_w_num_properties.csv")
