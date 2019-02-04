# Public Insurance Project 
# November 2017 
# Sally Owen 

### This code opens, collapses and saves a netcdf file into a csv file 

# Installing ncdf4 packages:
install.packages("ncdf4")
install.packages("ncdf.tools")
install.packages("ncdf.tools")
install.packages("RNetCDF")
install.packages("chron")
install.packages("RColorBrewer")
install.packages("lattice")
install.packages("reshape2")
install.packages("dplyr")
install.packages("raster") # package for raster manipulation
install.packages("rgdal") # package for geospatial analysis
install.packages("ggplot2")
install.packages("RSAGA")
install.packages("GISTools")
install.packages("arrayhelpers")

# Calling them all 
library(ncdf.tools)
library(ncdf4)
library(ncdf4.helpers)
library(RNetCDF)#Loading other helpful things: 
library(chron)
library(RColorBrewer)
library(lattice)
library(reshape2)
library(dplyr) # More helpful things:
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(RSAGA)
library(ggplot2) # package for plotting
library(GISTools)
library(arrayhelpers)

# Setting working directory 
setwd("R:/Agriculture/Deep South Challenge 2017/DATA/CCII/Precip/")

#filename <- list.files(pattern="nc")

filename <- "Mon_TotalPrecipCorr_VCSN_BCC-CSM1_1_2006-2120_RCP8_5.nc"
filename

  openandsave <- function(filename) {
      raindata <- nc_open(filename, write=FALSE, readunlim=TRUE, verbose=FALSE, auto_GMT=TRUE, suppress_dimvals=FALSE)
      #raindata <- nc_open("Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_2006-2120_RCP8.5.nc", write=FALSE, readunlim=TRUE, verbose=FALSE, auto_GMT=TRUE, suppress_dimvals=FALSE)
      #print(raindata) # looking at the metadata 
      #print(paste("The file has",raindata$nvars,"variables"))
      lon <- ncvar_get(raindata, "longitude")
      lat <- ncvar_get(raindata, "latitude")
      t <- ncvar_get(raindata, "time")
      rain_array <- ncvar_get(raindata, "rain") # store the data in a 3-dimensional array
      fillvalue <- ncatt_get(raindata, "rain", "_FillValue") # check the fillvalue
      #fillvalue # (print fillvalue) 
      # Replacing fillvalue with NA 
      rain_array[rain_array == fillvalue$value] <- NA # -9999 for NA 
      # Creating new ID (joining lat & long to create an ID for each gridblock)
      rain_matrix=array2df(rain_array, matrix=TRUE,label.x = "value", na.rm = TRUE)
      write.csv(rain_matrix, file = paste(filename, ".csv", sep=""))
      nc_close(raindata)
      
  }
  
  openandsave(filename)
  
  for(f in filename){
    openandsave(f)
  }
  
  

    ## Exporting as Polygon  
    #rainpolygons <- rasterToPolygons(r)
    #writeOGR(obj=rainpolygons, dsn="tempdir", layer="TotalPrecip", driver="ESRI Shapefile") # this is in geographical projection (this is the file sent to Jacob)

    #lat_df=data.frame(lat)
    #write.csv(lat_df,file="Precip/latitudes.csv")
    #lon_df=data.frame(lon)
    #write.csv(lon_df,file="Precip/longitudes.csv")
    #t_df=data.frame(t)
    #write.csv(t_df,file="Precip/time.csv")
    
    rain_array <- ncvar_get(raindata, "rain") # store the data in a 3-dimensional array
    dim(rain_array) 
    
    # Checking the missing variables: 
    fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
    fillvalue
    # Replacing fillvalue with NA 
    rain_array[rain_array == fillvalue$value] <- NA # -9999 for NA 
    
    ### Pulling out one timeslice 
    #rain_tslice <- rain_array[, , 1] 
    #dim(rain_tslice)
    
    ## Saving this as a raster 
    #rain_tslice_r <- raster(t(rain_tslice), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
    #plot( rain_tslice_r)
    
    # Creating new ID (joining lat & long to create an ID for each gridblock)
    rain_matrix=array2df(rain_array, matrix=TRUE,label.x = "value", na.rm = TRUE)
    write.csv(rain_matrix,file="[filenames(i,1)]_mat.csv")
}

varsize <- rain$varsize
ndims   <- rain$ndims
nt      <- varsize[ndims]  # Remember timelike dim is always the LAST dimension!


for( i in 1:nt ) {
  # Initialize start and count to read one timestep of the variable.
    start <- rep(1,ndims)	# begin with start=(1,1,1,...,1)
    start[ndims] <- 1	# change to start=(1,1,1,...,i) to read timestep i
    count <- varsize	# begin w/count=(nx,ny,nz,...,nt), reads entire var
    count[ndims] <- 1	# change to count=(nx,ny,nz,...,1) to read 1 tstep
  data <- ncvar_get(raindata, rain, start=start, count=count)
  # Now read in the value of the timelike dimension
  timeval <- ncvar_get( raindata, rain$dim[[ndims]]$name, start=i, count=i)
  #print(paste("Data for variable",rain$name,"at timestep",i,"(time value=",timeval,rain$dim[[ndims]]$units,"):"))
  #print(data)
  }

nc_close(raindata)
