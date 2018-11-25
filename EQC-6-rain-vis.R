# EQC 6 - niwa data vis 

#setwd("~/EQC-climate-change-part-two")

library(sf)
library(tidyverse)
library(viridis)
library(rvest)
library(dplyr)
library(ggplot2)

# Part one - points 
precipOneDay <- filter(precipWorking, day == "1999-01-01")
precipOneDay <- st_as_sf(precipOneDay, coords = c("longitude", "latitude"), crs = 4326)
plot(precipOneDay, main="NIWA grid points") 

# Part Two - series 
precipOneCell <- filter(precipWorking, longitude == first(precipWorking$longitude, order_by = NULL, default = default_missing(x)) & latitude == first(precipWorking$latitude, order_by = NULL, default = default_missing(x)))
precipOneCell <- st_as_sf(precipOneCell, coords = c("longitude", "latitude"), crs = 4326)
plot(precipOneCell$rain)

theme_set(theme_bw()) # Change the theme to my preference
ggplot(aes(x = day, y = rain), data = precipOneCell) + geom_point()
# nice to add: which grid is this? 
