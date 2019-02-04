# Extracting the whole grid for Jacob 

setwd("R:/Agriculture/Deep_South_Challenge_2017/5 Raw Data/NIWA Climate projections/Precip")
library(ncdf4)
ncname = "Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_2006-2099_RCP6.0"
ncfname <- paste(ncname, ".nc", sep="")

ncin <- nc_open(ncfname)
print(ncin)

dname <- "rain"  # note: rain means precipitation amount in kg m-2 - full description: "virtual climate station rainfall in mm/day from 9am to 9 am recorded against day of start of period 

# These files are raster "bricks" organised by longitude,latitude,time
# So, first we read in the metadata for each of those dimensions 

## get longitude and latitude
lon <- ncvar_get(ncin,"longitude")
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncin,"latitude")
nlat <- dim(lat)
head(lat)

print(c(nlon,nlat)) 

# get time
time <- ncvar_get(ncin,"time")
head(time)

tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt

# Print the time units string. Note the structure of the time units attribute: The object tunits has two components hasatt (a logical variable), and tunits$value, the actual "time since" string.
tunits

# Now that that is under control, we can collect the actual observatiosn we're interested in (while being confident we can trace back against the metadata to know what we're looking at)

# get rain 
rain_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(rain_array)

# get global attributes
CDO <- ncatt_get(ncin,0,"CDO")
description <- ncatt_get(ncin,0,"description")
# also may be a third - updates info - ignored in this case 

#Check you got them all (print current workspace):
ls()

# load some necessary packages 
library(chron)
library(lattice)
library(RColorBrewer)
library(raster)

# Convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
time_values <- chron(time,origin=c(tmonth, tday, tyear))
head(time_values)
time_values_c <- as.character(time_values)
time_values_df<-as.data.frame(time_values_c)
head(time_values_df)

# Replace netCDF fill values with NA's
#rain_array[rain_array==fillvalue$value] <- NA

# get a single slice or layer (January)
m <- 1
rain_slice <- rain_array[,,m]
dim(rain_slice) #checking dimensions (verifyign this is what I think it is) 
rain_slice_r <- raster(t(rain_slice), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
library(rgdal)
rain_slice_polygons=rasterToPolygons(rain_slice_r, fun=NULL, n=4, na.rm=FALSE, digits=12, dissolve=FALSE)
writeOGR(rain_slice_polygons, dsn='.',layer='precip_shapes',driver="ESRI Shapefile") # exporting the whole grid for Jacob 
plot(rain_slice_polygons)
