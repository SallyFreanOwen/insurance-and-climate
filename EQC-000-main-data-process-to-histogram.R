# Data processing and histogram of rain within claim's lossdate window 

## Using sf package:

#0 - for new machines (installing packages) 
#source("EQC-0.R")
# Also at this point, add the Data to a folder called Data in the project. #NB note data names etc. 

# 1 - eqc claims csv to r dataframe (including lossdate as an r date) 
source("EQC-01-claims-import.R")

# 2 - eqc portfolio csv to sf r data 
source("EQC-02-portfolio-import.R")

# 3 - niwa virtual-climate-station rain data netcdf to csv to RData 
source("EQC-03-rain-import.R")

# 4 - spatial link portfolios to nearest vcs  
source("EQC-04-nearest-grid.R")

# 5 - attaching spatial portfolio and claim
source("EQC-05-build-claimportfoliospatial.R")

# 6 - add all rain to claims
source("EQC-06-build-claimtorain.R")

# 7 - subset
source("EQC-07-creating-hist-inputs.R")

# 8 - build barcharts 
source("EQC-08-histogram.R")


