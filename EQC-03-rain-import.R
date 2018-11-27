#EQC-3-rain-import  

openandsave <- function(ncname) {
  
  ######
  #Reading in the data 
  
  library(ncdf4)
  
  ncfname <- paste(ncname, ".nc", sep="")
  dname <- "precipitation_amount"  # note: rain means precipitation amount in kg m-2 - full description: "virtual climate station rainfall in mm/day from 9am to 9 am recorded against day of start of period 
  
  ncin <- nc_open(ncfname)
  print(ncin)
  
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
  
  ###### 
  #Reshaping the data (with a bit of cleaning along the way) 
  # this piece first saving only one day against lat longs for each grid
  
  # load some necessary packages 
  library(lattice)
  library(RColorBrewer)
  library(raster)
  
  # Convert time -- split the time units string into fields
  tustr <- strsplit(tunits$value, " ")
  time_values <- as.Date(time,origin=as.Date(unlist(tustr)[3]))
  time_values_c <- as.character(time_values)
  time_values_df<-as.data.frame(time_values_c)
  
  # Replace netCDF fill values with NA's
  rain_array[rain_array==fillvalue$value] <- NA
  
  # get a single slice or layer (January)
  #m <- 1
  #rain_slice <- rain_array[,,m]
  #dim(rain_slice) #checking dimensions (verifyign this is what I think it is) 
  #rain_slice_r <- raster(t(rain_slice), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
  #plot(rain_slice_r) # quick map (again verifying this is what I think it is) 
  
  # create dataframe -- reshape data
  # matrix (nlon*nlat rows by 2 cols) of lons and lats
  lonlat <- as.matrix(expand.grid(lon,lat))
  dim(lonlat)
  
  # vector of `rain` values
  #rain_vec <- as.vector(rain_slice)
  #length(rain_vec)
  
  # create dataframe and add names
  #rain_df01 <- data.frame(cbind(lonlat,rain_vec))
  #names(rain_df01) <- c("lon","lat",paste(dname,as.character(m), sep="_"))
  #head(na.omit(rain_df01), 10)
  
  # set path and filename
  #csvname <- "rain_df_VCSN_Rain5k_1999_day1.csv"
  #csvfile <- paste(csvname, sep="")
  #write.table(na.omit(rain_df01),csvfile, row.names=FALSE, sep=",") 
  
  
  # Convert the whole array to a data frame 
  # this piece saves the whole first year of data 
  ###### 
  # Convert the whole array to a data frame 
  
  # reshape the array into vector
  rain_vec_long <- as.vector(rain_array)
  length(rain_vec_long)
  
  # reshape the vector into a matrix
  rain_mat <- matrix(rain_vec_long, nrow=nlon*nlat, ncol=nt)
  dim(rain_mat)
  #head(na.omit(rain_mat)) #<- this has a look at the data 
  
  # create a dataframe 
  lonlat <- as.matrix(expand.grid(lon,lat))
  rain_df02 <- na.omit(data.frame(cbind(lonlat,rain_mat)))
  names(rain_df02) <- c("lon","lat") # could rename variables to be rain on days 1-365 
  names(rain_df02)[3:ncol(rain_df02)]<- t(time_values_df)
  #head(na.omit(rain_df02, 10))
  
  #At this point we could add a variable containing summary statistics to each grid if we wanted 
  
  # Sense check - what size is this matrix? Should be 365 days of observations of rain + lat long variables 
  # Worked!
  
  # write out the dataframe as a .csv file
  csvfile <- paste(ncname, ".csv", sep="")
  write.table(rain_df02,csvfile, row.names=FALSE, sep=",")
  
  # create a dataframe without missing values (in case this is useful later)
  #rain_df03 <- na.omit(rain_df02)
  #head(rain_df03, 20)
  
  #Check what's in the current workspace now:
  #ls()
  
  
  # Some extra notes
  ######
  # Other notes:
  
  # This was the nicest example I found to work from:
  # http://geog.uoregon.edu/bartlein/courses/geog490/week04-netCDF.html 
}

# set path and filename
ncname <- "Data/VCSN_Rain5k_1999" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2000" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2001" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2002" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2003" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2004" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2005" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2006" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2007" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2008" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2009" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2010" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2011" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2012" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2013" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2014"
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2015" 
openandsave(ncname)
ncname <- "Data/VCSN_Rain5k_2016" 
openandsave(ncname)

######

# Now adding them all together: 

# read in new data as R object
VCSN_Rain5k_1999 <- read.csv("Data/VCSN_Rain5k_1999.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2000 <- read.csv("Data/VCSN_Rain5k_2000.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2001 <- read.csv("Data/VCSN_Rain5k_2001.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2002 <- read.csv("Data/VCSN_Rain5k_2002.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2003 <- read.csv("Data/VCSN_Rain5k_2003.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2004 <- read.csv("Data/VCSN_Rain5k_2004.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2005 <- read.csv("Data/VCSN_Rain5k_2005.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2006 <- read.csv("Data/VCSN_Rain5k_2006.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2007 <- read.csv("Data/VCSN_Rain5k_2007.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2008 <- read.csv("Data/VCSN_Rain5k_2008.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2009 <- read.csv("Data/VCSN_Rain5k_2009.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2010 <- read.csv("Data/VCSN_Rain5k_2010.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2011 <- read.csv("Data/VCSN_Rain5k_2011.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2012 <- read.csv("Data/VCSN_Rain5k_2012.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2013 <- read.csv("Data/VCSN_Rain5k_2013.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2014 <- read.csv("Data/VCSN_Rain5k_2014.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2015 <- read.csv("Data/VCSN_Rain5k_2015.csv", stringsAsFactors = FALSE)
VCSN_Rain5k_2016 <- read.csv("Data/VCSN_Rain5k_2016.csv", stringsAsFactors = FALSE)

VCSN_Rain5k_working <- merge(VCSN_Rain5k_1999, VCSN_Rain5k_2000, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2001, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2002, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2003, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2004, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2005, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2006, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2007, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2008, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2009, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2010, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2011, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2012, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2013, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2014, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2015, by=c("lon", "lat"))
#VCSN_Rain5k_working <- merge(VCSN_Rain5k_working, VCSN_Rain5k_2016, by=c("lon", "lat"))

# write out the dataframe as a .csv file
#csvfile <- paste("Data/VCSN_Rain5k_1999_2016", ".csv", sep="")
#write.table(VCSN_Rain5k_working, csvfile, row.names=FALSE, sep=",")
csvfile <- paste("Data/VCSN_Rain5k_1999_2000", ".csv", sep="")
write.table(VCSN_Rain5k_working, csvfile, row.names=FALSE, sep=",")

# clean up workspace:
rm(VCSN_Rain5k_1999)
rm(VCSN_Rain5k_2000)
rm(VCSN_Rain5k_2001)
rm(VCSN_Rain5k_2002)
rm(VCSN_Rain5k_2003)
rm(VCSN_Rain5k_2004)
rm(VCSN_Rain5k_2005)
rm(VCSN_Rain5k_2006)
rm(VCSN_Rain5k_2007)
rm(VCSN_Rain5k_2008)
rm(VCSN_Rain5k_2009)
rm(VCSN_Rain5k_2010)
rm(VCSN_Rain5k_2011)
rm(VCSN_Rain5k_2012)
rm(VCSN_Rain5k_2013)
rm(VCSN_Rain5k_2014)
rm(VCSN_Rain5k_2015)
rm(VCSN_Rain5k_2016)
rm(VCSN_Rain5k_working)

# EQC 5 - niwa data import 

# setwd("~/EQC-climate-change-part-two")

# load the ncdf4 package
library(sf)

# Inputing rain data as csv (output from EQC-5a)
#precip_table <- read.csv("Data/VCSN_Rain5k_1999_2016.csv", sep=",", stringsAsFactors = FALSE)
#names(precip_table) <- gsub("X", "precip", names(precip_table))
#names(precip_table) <- gsub(".", "", names(precip_table))
precip_table <- read.csv("Data/VCSN_Rain5k_1999_2000.csv", sep=",", stringsAsFactors = FALSE)
names(precip_table) <- gsub("X", "precip", names(precip_table))


# This has columns for lat & lon, then a column for each day, containing rainfall 
# Note the "centroid" is not actually a centroid (just NIWA's coordinates for each grid)

precipWorking <- as.data.frame(precip_table)

rm(precip_table)

head(names(precipWorking))

# prefer a "point / day / rain" column format for processing later on, with 
library(reshape2)

## If you're on an old machine, may be a problem with below - slow 
precipWorking <- melt(precipWorking, id=c("lon","lat"))
head(precipWorking)
names(precipWorking) <- c("longitude", "latitude", "day", "rain")
head(precipWorking)
sapply(precipWorking, class)
precipWorking$day <- gsub("precip", "", precipWorking$day)
head(precipWorking)
precipWorking$day <- as.Date(precipWorking$day, format = "%Y.%m.%d")
sapply(precipWorking,class)

rm(csvfile)
rm(ncname)

vcsn <- precipWorking 
names(vcsn) <- c("vcsnLongitude", "vcsnLatitude", "vcsnDay", "rain")


vcsnWide <- dcast(vcsn, vcsnLatitude + vcsnLongitude ~ vcsnDay, value.var="rain")
vcsnWide$long <- vcsnWide$vcsnLongitude
vcsnWide$lat <- vcsnWide$vcsnLatitude

vcsnWide <- st_as_sf(vcsnWide, coords = c("long", "lat"), crs = 4326) #note crs tells it the latlons are wgs84

#vcsnWorking <- melt(vcsnWide, id=c("vcsnLatitude", "vcsnLongitude"))

rm(precipWorking)
