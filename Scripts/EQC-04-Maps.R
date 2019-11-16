# Mapping figures 

#### Re attach portfolio lat longs 

library(dplyr)
library(grDevices)
library(leaflet)
library(sf)
library(viridis)
library(scales)


#load("~/insurance-and-climate/Data/EQC-event3-full.RData")
 ### Portfolio spatial ##########

## Make spatial
# Note data deliberately not saved in wd - confidential, only want code in cloud (not data itself)
portfolioRaw <- read.csv("Data/Motu_EQC_Portfolio_2017.csv", stringsAsFactors = FALSE)

# Check columns type - numeric 
sapply(portfolioRaw, class)

portfolios <- portfolioRaw
portfolios <- select(portfolios, PortfolioID, WGS84Latitude, WGS84Longitude)

#sorting out ID
portfolios$portfolioID <- as.numeric(portfolioRaw$PortfolioID)

# First copy the lat long columns 
portfolios$lat <- portfolios$WGS84Latitude
portfolios$long <- portfolios$WGS84Longitude
# Now define as an sf point object 
portfolios <- st_as_sf(portfolios, coords = c("long", "lat"), crs = 4326) 
rm(portfolioRaw)

### Event One Mapping #########

###  Event one: 
load("~/insurance-and-climate/Data/EQC-event1-full.RData")

eventOneFull <- portfoliosClaimsVcsnNl15AllPrecip06171819202122
rm(portfoliosClaimsVcsnNl15AllPrecip06171819202122)
eventOneFull <- st_drop_geometry(eventOneFull)

eventOneFull <- dplyr::filter(eventOneFull, 
                              nldif10 != "NA" &
                                nldif31 != "NA" &
                                approved != "NA" & 
                                slope != "NA" & 
                                propDwellingNotOwned != "NA"
)

eventOneFull$rain50mm <- ifelse((eventOneFull$rain0617>50 | eventOneFull$rain0618>50 | eventOneFull$rain0619>50 | eventOneFull$rain0620>50 | eventOneFull$rain0621>50 | eventOneFull$rain0622>50),1,0)
eventOneFull$rain100mm <- ifelse((eventOneFull$rain0617>100 | eventOneFull$rain0618>100 | eventOneFull$rain0619>100 | eventOneFull$rain0620>100| eventOneFull$rain0621>100 | eventOneFull$rain0622>100),1,0)
eventOneFull$rain150mm <- ifelse((eventOneFull$rain0617>150 | eventOneFull$rain0618>150 | eventOneFull$rain0619>150 | eventOneFull$rain0620>150| eventOneFull$rain0621>150 | eventOneFull$rain0622>150),1,0)

eventOneFull$rain50Claimed <- ifelse((eventOneFull$rain50mm == 1 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$rain50NotClaimed <- ifelse((eventOneFull$rain50mm == 1 & eventOneFull$claimed == 0), 1, 0)

eventOneFull <- filter(eventOneFull, 
                       rain50mm==1)

eventOneFull <- select(eventOneFull, 
                       portfolioID, 
                       claimed, approved, closedIn90days, 
                       nldif31, nldif10,
                       rain50mm, rain100mm, rain150mm,
                       rain50Claimed, rain50NotClaimed)

eventOneFull$raincat[eventOneFull$rain50mm == 1 & eventOneFull$rain100mm != 1 & eventOneFull$rain150mm != 1] <- "1: 50mm"
eventOneFull$raincat[eventOneFull$rain50mm == 1 & eventOneFull$rain100mm == 1 & eventOneFull$rain150mm != 1] <- "2: 100mm"
eventOneFull$raincat[eventOneFull$rain50mm == 1 & eventOneFull$rain100mm == 1 & eventOneFull$rain150mm == 1] <- "3: 150mm"

#eventOneFull50 <- filter(eventOneFull, rain50mm==1)
#eventOneFull50Claimed <- filter(eventOneFull, rain50Claimed==1)
#eventOneFull50nClaimed <- filter(eventOneFull, rain50NotClaimed==1)
#eventOneFull100 <- filter(eventOneFull, rain100mm==1)
#eventOneFull150 <- filter(eventOneFull, rain150mm==1)

eventOneSpatial <- merge(eventOneFull, portfolios, by.x="portfolioID", by.y="PortfolioID", all.x=TRUE)

# Choosing colours
show_col(viridis_pal()(4))
#codes: 
# #440154ff (purple)
# #31688eff (blue)
# #35b779ff (teal) 
# fde725ff (yellow)

library(viridis) # My favorite palette for maps

wardpal <- colorFactor(c("#fde725ff", "#440154ff"), eventOneSpatial$claimed) 

eventOneMAP<-leaflet(data=eventOneSpatial) %>% #width = "100%", height="100%"
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  addCircleMarkers(lat = eventOneSpatial$WGS84Latitude, 
                   lng = eventOneSpatial$WGS84Longitude,
                   fillColor = ~wardpal(eventOneSpatial$claimed),
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7) %>%
  
  addLegend("bottomright", 
            pal = wardpal, 
            values = ~eventOneFull$claimed,
            title = "claimed") %>%
  
  setView( lng = 173.2295, 
           lat = -41.2728,
           zoom = 5.2) 

eventOneMAP

wardpal <- colorFactor(c("#fde725ff", "#35b779ff", "#31688eff"), eventOneSpatial$raincat) 

eventOneMAP2<-leaflet(data=eventOneSpatial) %>% #width = "100%", height="100%"
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  addCircleMarkers(lat = eventOneSpatial$WGS84Latitude, 
                   lng = eventOneSpatial$WGS84Longitude,
                   fillColor = ~wardpal(eventOneSpatial$raincat),
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7) %>%
  
  addLegend("bottomright", 
            pal = wardpal, 
            values = ~eventOneFull$raincat,
            title = "rainfall by property") %>%
  
  setView( lng = 173.2295, 
           lat = -41.2728,
           zoom = 5.2) 

eventOneMAP2

### Event Two Mapping #### 
###  Event two: 
load("~/insurance-and-climate/Data/EQC-event2-full.RData")

eventTwoFull <- portfoliosClaimsVcsnNl16AllPrecip111314151617
rm(portfoliosClaimsVcsnNl16AllPrecip111314151617)
eventTwoFull <- st_drop_geometry(eventTwoFull)

eventTwoFull <- dplyr::filter(eventTwoFull, 
                              nldif10 != "NA" &
                                nldif31 != "NA" &
                                approved != "NA" & 
                                slope != "NA" & 
                                propDwellingNotOwned != "NA"
)

eventTwoFull$rain30mm <- ifelse((eventTwoFull$rain1113 > 30 | eventTwoFull$rain1114 >30 | eventTwoFull$rain1115>30 | eventTwoFull$rain1116>30 | eventTwoFull$rain1117 >30),1,0)
eventTwoFull$rain50mm <- ifelse((eventTwoFull$rain1113 > 50 | eventTwoFull$rain1114 >50 | eventTwoFull$rain1115>50 | eventTwoFull$rain1116>50 | eventTwoFull$rain1117 >50),1,0)
eventTwoFull$rain100mm <- ifelse((eventTwoFull$rain1113 > 100 | eventTwoFull$rain1114>100 | eventTwoFull$rain1115>100 | eventTwoFull$rain1116>100 | eventTwoFull$rain1117 >100),1,0)

eventTwoFull$rain30Claimed <- ifelse((eventTwoFull$rain30mm == 1 & eventTwoFull$claimed == 1), 1, 0)
eventTwoFull$rain30NotClaimed <- ifelse((eventTwoFull$rain30mm == 1 & eventTwoFull$claimed == 0), 1, 0)

eventTwoFull <- filter(eventTwoFull, 
                       rain30mm==1)

eventTwoFull <- select(eventTwoFull, 
                       portfolioID, 
                       claimed, approved, closedIn90days, 
                       nldif31, nldif10,
                       rain30mm, rain50mm, rain100mm,
                       rain30Claimed, rain30NotClaimed)

eventTwoFull$raincat[eventTwoFull$rain30mm == 1 & eventTwoFull$rain50mm != 1 & eventTwoFull$rain100mm != 1] <- "1: 30mm"
eventTwoFull$raincat[eventTwoFull$rain30mm == 1 & eventTwoFull$rain50mm == 1 & eventTwoFull$rain100mm != 1] <- "2: 50mm"
eventTwoFull$raincat[eventTwoFull$rain30mm == 1 & eventTwoFull$rain50mm == 1 & eventTwoFull$rain100mm == 1] <- "3: 100mm"

eventTwoSpatial <- merge(eventTwoFull, portfolios, by.x="portfolioID", by.y="PortfolioID", all.x=TRUE)

# Choosing colours
show_col(viridis_pal()(4))
#codes: 
# #440154ff (purple)
# #31688eff (blue)
# #35b779ff (teal) 
# fde725ff (yellow)

library(viridis) # My favorite palette for maps

wardpal <- colorFactor(c("#fde725ff", "#440154ff"), eventTwoSpatial$claimed) 

eventTwoMAP<-leaflet(data=eventTwoSpatial) %>% #width = "100%", height="100%"
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  addCircleMarkers(lat = eventTwoSpatial$WGS84Latitude, 
                   lng = eventTwoSpatial$WGS84Longitude,
                   fillColor = ~wardpal(eventTwoSpatial$claimed),
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7) %>%
  
  addLegend("bottomright", 
            pal = wardpal, 
            values = ~eventTwoFull$claimed,
            title = "claimed") %>%
  
  setView( lng = 173.2295, 
           lat = -41.2728,
           zoom = 5.2) 

eventTwoMAP

wardpal <- colorFactor(c("#fde725ff", "#35b779ff", "#31688eff"), eventTwoSpatial$raincat) 

eventTwoMAP2<-leaflet(data=eventTwoSpatial) %>% #width = "100%", height="100%"
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  addCircleMarkers(lat = eventTwoSpatial$WGS84Latitude, 
                   lng = eventTwoSpatial$WGS84Longitude,
                   fillColor = ~wardpal(eventTwoSpatial$raincat),
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7) %>%
  
  addLegend("bottomright", 
            pal = wardpal, 
            values = ~eventTwoFull$raincat,
            title = "rainfall by property") %>%
  
  setView( lng = 173.2295, 
           lat = -41.2728,
           zoom = 5.2) 

eventTwoMAP2

 
### Event Three Mapping ########

###  Event three: 
load("~/insurance-and-climate/Data/EQC-event3-full.RData")

eventThreeFull<- portfoliosClaimsVcsnNl17AllPrecip030607080910
rm(portfoliosClaimsVcsnNl17AllPrecip030607080910)

eventThreeFull <- st_drop_geometry(eventThreeFull)

eventThreeFull <- dplyr::filter(eventThreeFull, 
                              nldif10 != "NA" &
                                nldif31 != "NA" &
                                approved != "NA" & 
                                slope != "NA" & 
                                propDwellingNotOwned != "NA"
)

eventThreeFull$rain50mm <- ifelse((eventThreeFull$rain0306>50 | eventThreeFull$rain0307>50 | eventThreeFull$rain0308>50 | eventThreeFull$rain0309>50 | eventThreeFull$rain0310>50),1,0)
eventThreeFull$rain100mm <- ifelse((eventThreeFull$rain0306>100 | eventThreeFull$rain0307>100 | eventThreeFull$rain0308>100 | eventThreeFull$rain0309>100 | eventThreeFull$rain0310>100),1,0)
eventThreeFull$rain150mm <- ifelse((eventThreeFull$rain0306 > 150 | eventThreeFull$rain0307>150 | eventThreeFull$rain0308>150 | eventThreeFull$rain0309>150 | eventThreeFull$rain0310 >150),1,0)

eventThreeFull$rain50Claimed <- ifelse((eventThreeFull$rain50mm == 1 & eventThreeFull$claimed == 1), 1, 0)
eventThreeFull$rain50NotClaimed <- ifelse((eventThreeFull$rain50mm == 1 & eventThreeFull$claimed == 0), 1, 0)

eventThreeFull <- filter(eventThreeFull, 
                       rain50mm==1)

eventThreeFull <- select(eventThreeFull, 
                       portfolioID, 
                       claimed, approved, closedIn90days, 
                       nldif31, nldif10,
                       rain50mm, rain100mm, rain150mm,
                       rain50Claimed, rain50NotClaimed)

eventThreeFull$raincat[eventThreeFull$rain50mm == 1 & eventThreeFull$rain100mm != 1 & eventThreeFull$rain150mm != 1] <- "1: 50mm"
eventThreeFull$raincat[eventThreeFull$rain50mm == 1 & eventThreeFull$rain100mm == 1 & eventThreeFull$rain150mm != 1] <- "2: 100mm"
eventThreeFull$raincat[eventThreeFull$rain50mm == 1 & eventThreeFull$rain100mm == 1 & eventThreeFull$rain150mm == 1] <- "3: 150mm"

eventThreeSpatial <- merge(eventThreeFull, portfolios, by.x="portfolioID", by.y="PortfolioID", all.x=TRUE)

# Choosing colours
show_col(viridis_pal()(4))
#codes: 
# #440154ff (purple)
# #31688eff (blue)
# #35b779ff (teal) 
# fde725ff (yellow)

library(viridis) # My favorite palette for maps

wardpal <- colorFactor(c("#fde725ff", "#440154ff"), eventThreeSpatial$claimed) 

eventThreeMAP<-leaflet(data=eventThreeSpatial) %>% #width = "100%", height="100%"
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  addCircleMarkers(lat = eventThreeSpatial$WGS84Latitude, 
                   lng = eventThreeSpatial$WGS84Longitude,
                   fillColor = ~wardpal(eventThreeSpatial$claimed),
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7) %>%
  
  addLegend("bottomright", 
            pal = wardpal, 
            values = ~eventThreeFull$claimed,
            title = "claimed") %>%
  
  setView( lng = 173.2295, 
           lat = -41.2728,
           zoom = 5.2) 

eventThreeMAP

wardpal <- colorFactor(c("#fde725ff", "#35b779ff", "#31688eff"), eventThreeSpatial$raincat) 

eventThreeMAP2<-leaflet(data=eventThreeSpatial) %>% #width = "100%", height="100%"
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  addCircleMarkers(lat = eventThreeSpatial$WGS84Latitude, 
                   lng = eventThreeSpatial$WGS84Longitude,
                   fillColor = ~wardpal(eventThreeSpatial$raincat),
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7) %>%
  
  addLegend("bottomright", 
            pal = wardpal, 
            values = ~eventThreeFull$raincat,
            title = "rainfall by property") %>%
  
  setView( lng = 173.2295, 
           lat = -41.2728,
           zoom = 5.2) 

eventThreeMAP2
