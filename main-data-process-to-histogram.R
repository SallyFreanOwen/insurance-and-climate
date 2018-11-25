# Data processing and histogram of rain within claim's lossdate window 

## Using sf package:

#0 - for new machines (installing packages) 
#source("EQC-0.R")
# Also at this point, add the Data to a folder called Data in the project. #NB note data names etc. 

# 1 - eqc claims csv to r dataframe (including lossdate as an r date) 
source("EQC-1-claims-import.R")

# 2 - eqc portfolio csv to sf r data 
source("EQC-2-portfolio-import.R")

# 3 - vis portfolios 
source("EQC-3-portfolio-vis.R")

# 4 - vis claim locations 
source("EQC-4-claim-vis.R")
# NB would be nice to overlay onto the all portfolios map 

# 5 - niwa rain netcdf to r data (including day as r dates)
source("EQC-5-1-NIWA-rain-import.R") # necessary if working from raw rain-data netcdf files, otherwise progress to 5b
source("EQC-5-2-rain-import.R") 

# 6 - vis rain 
source("EQC-6-rain-vis.R")
## source("EQC-6b-Map-EQC-NIWA-points.R") # Mapped instead of plotted - NB Step 6b makes R crash on my work computer 

# 7 - geo process portfolio adding closest rain point 
install.packages("Imap")
install.packages("SearchTrees")
source("EQC-7-joining-grid-portfolio.R")
# plotting line segments portfolio to grid 
## source("EQC-7b-lines-between-neighbours.R")

# 8 - generate claim window 
source("EQC-8-gen-claim-window.R")




