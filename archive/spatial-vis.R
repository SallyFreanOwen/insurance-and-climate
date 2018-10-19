## Sally Owen
## EQC project, part two - community recovery 

## Re-importing/working in R with Git, for ability 
## to deal with spatial objects and analyse in 
## one script type - for reproducibility and to
## supply code upon publishing if necessary 

setwd("~/EQC-climate-change-part-two")

# This r script should: investigate visualisations  

####
## for import of external spatial formats:
# install.packages("rgdal") 
# install.packages("maptools")

### Map base data 

# Get coastal and country world maps as Spatial objects
#install.packages("rnaturalearth")
library(rnaturalearth)
coast_sp <- ne_coastline(scale = "medium")
countries_sp <- ne_countries(scale = "medium")

