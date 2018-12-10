# Experimenting w diferent night light approaches:

# 1) download all three R (sf) options for New Zealand 
# Available from: https://gadm.org/download_country_v3.html 

# 2) open:
gadm36_NZL_0_sf <- readRDS("C:/Users/sally.owen/OneDrive - Motu Economic and Public Policy Research Trust/Sally/insurance-and-climate/Data/gadm36_NZL_0_sf.rds") 
gadm36_NZL_1_sf <- readRDS("C:/Users/sally.owen/OneDrive - Motu Economic and Public Policy Research Trust/Sally/insurance-and-climate/Data/gadm36_NZL_1_sf.rds") 
gadm36_NZL_2_sf <- readRDS("C:/Users/sally.owen/OneDrive - Motu Economic and Public Policy Research Trust/Sally/insurance-and-climate/Data/gadm36_NZL_2_sf.rds") 

devtools::install_github("walshc/nightlights")
require(nightlights) 

# 3) Figure out which tile we want...

# The Earth Observations Group (EOG) at NOAA/NCEI is producing a version 1 suite of average radiance composite images using nighttime data from the Visible Infrared Imaging Radiometer Suite (VIIRS) Day/Night Band (DNB). 
# The version 1 products span the globe from 75N latitude to 65S. The products are produced in 15 arc-second geographic grids and are made available in geotiff format as a set of 6 tiles. The tiles are cut at the equator and each span 120 degrees of latitude. Each tile is actually a set of images containing average radiance values and numbers of available observations. 
# Above from: README for Version 1 Nighttime VIIRS Day/Night Band Composites, updated 20171218

# Think we want Tile 4 

# 4) Download one test file - one month of tile 4 
# From: https://ngdc.noaa.gov/eog/viirs/download_dnb_composites.html 

downloadNightLights(years = 1999:2000, directory = "night-lights")
