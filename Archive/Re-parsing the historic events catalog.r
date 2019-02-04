
### Public Insurance Project
### Sally Owen, David Fleming, Jacob Pastor Paz and Ilan Noy 

### Parsing XML data from NIWAs Historical Events Catalog into useable format 

# install.packages("xml")
# install.packages("plyr")
# install.packages("RCurl")

library(XML)
library(xml2)
library(plyr)
library(RCurl)

## Reading in the xml: 

# There was an issue with the link being https, using these versions seems to help 
curlVersion()$features
curlVersion()$protocol

# Then using getURL instead of the filename in the read_xml was necessary 
temp <- getURL("https://hwe.niwa.co.nz/search/summary/Startdate/2000-01-01/Enddate/2016-06-01/Regions/all/Hazards/all/Impacts/all/Keywords/none/numberOfEvents/30/page/1/xml", ssl.verifyPeer=FALSE)
allpage1 <- read_xml(temp)

## Now get all the <events>s to check it worked 
pg1_events <- xml_find_all(allpage1, "/events/*")

allpage1=xml_ns_strip(allpage1)

## This time pull out the elements for the first table I want - Identifier and Abtract elements: 
  pg1_Identifiers  <- xml_find_all(allpage1, "//*[local-name()='Identifier']")
  pg1_Abstract <- xml_find_all(allpage1, "//*[local-name()='Abstract']")
  # pg1_Title  <- xml_find_all(allpage1, "//*[local-name()='Title']") # this one was a little complicated

  # extracting and cleaning columns
  pg1_I <- trimws(xml_text(pg1_Identifiers))
  #pg1_T <- trimws(xml_text(pg1_Title))
  pg1_A <- trimws(xml_text(pg1_Abstract))

  # Building Identifier and Abtract Table
  test=do.call(rbind, Map(data.frame, Identifier=pg1_I, Abstract=pg1_A))

## Now thinking about the Regions table: 
  # Ideally want to iterate over identifiers/weather events for first region element
  for i in Identifier
  
pg1_RegionHazard  <- xml_find_all(allpage1, "/events/WeatherEvent[Identifier/text()=March_2016_New_Zealand_Storm]/*[local-name()='Regions']/")


# then assign the area name column to the data frame
dat$area_name <- labs

head(dat)
##   region area palmitic palmitoleic stearic oleic linoleic linolenic
## 1      1    1     1075          75     226  7823      672        NA
