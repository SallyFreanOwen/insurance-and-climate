

## Using sf package:

#0 - for new machines (installing packages) 
#source("EQC-0.R")

# - add the Data to a folder called Data in the project. #NB note data names etc. 

# Data processing and histogram of rain within claim's lossdate window 

# 1 - eqc claims csv to r dataframe (including lossdate as an r date) 
source("Scripts/EQC-01-claims-import.R")

# 2 - eqc portfolio csv to sf r data 
source("Scripts/EQC-02-portfolio-import.R")

# 3 - niwa virtual-climate-station rain data netcdf to csv to RData 
source("Scripts/EQC-03-rain-import.R")

# 4 - spatial link portfolios to nearest vcs  
source("Scripts/EQC-04-nearest-grid.R")

# 5 - attaching spatial portfolio and claim
source("Scripts/EQC-05-build-claimportfoliospatial.R")

# 6 - add all rain to claims
source("Scripts/EQC-06-build-claimtorain.R")

# 7 - subset and build barcharts 
source("Scripts/EQC-07-four-rain-to-lossdate-barcharts.R")

### Import and clean up NIWA data - Historic Weather Events Catalog  

source("Scripts/HW-01.R")

#### Import and process night time light ata:

# 8 - import nighttime light satelite .tifs 
source("Scripts/NL-01-import-stars.R")

# 9 - 
source("Scripts/NL-02-grid-portfolio-link.R")

# 10 - 
source("Scripts/NL-03-grid-portfolio-build.R")

