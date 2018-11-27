# Data processing and histogram of rain within claim's lossdate window 

## Using sf package:

#0 - for new machines (installing packages) 
#source("EQC-0.R")
# Also at this point, add the Data to a folder called Data in the project. #NB note data names etc. 

# 1 - eqc claims csv to r dataframe (including lossdate as an r date) 
source("EQC-01-claims-import.R")

# 2 - eqc portfolio csv to sf r data 
source("EQC-02-portfolio-import.R")

source("EQC-03-rain-import.R")

source("EQC-04-nearest-grid.R")

source("EQC-05-build-claimportfoliospatial.R")

source("EQC-06-build-claimtorain.R")




