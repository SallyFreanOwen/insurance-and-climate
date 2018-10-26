# Data processing and histogram of rain within claim's lossdate window 

## Using sf package:
# 1 - eqc claims csv to r dataframe (including lossdate as an r date) 
source("EQC-1-claims-import.R")
# 2 - eqc portfolio csv to sf r data 
source("EQC-2-portfolio-import.R")
# 3 - vis portfolios 
source("EQC-3-portfolio-vis.R")
# 4 - vis claim locations 
source("EQC-4-claim-vis.R")
# 5 - niwa rain netcdf to r data (including day as r dates)
source("EQC-5-rain-import.R") 
# 6 - vis rain 
source("EQC-6-rain-vis")
# 7 - geo process portfolio adding closest rain point 
source("EQC-7-joining-grid-portfolio")
# 8 - line segments portfolio to rain 

# 9 - generate claim window 





