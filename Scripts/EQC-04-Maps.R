# Mapping figures 

#### Re attach portfolio lat longs 

library(dplyr)
library(grDevices)

load("~/insurance-and-climate/Data/EQC-event1-full.RData")
load("~/insurance-and-climate/Data/EQC-event2-full.RData")
load("~/insurance-and-climate/Data/EQC-event3-full.RData")

#source("~/EQC-01-imports-portfolios.r")

## Make spatial
# First copy the lat long columns 
#portfolios$lat <- portfolios$portfolioLatitude
#portfolios$long <- portfolios$portfolioLongitude
# Now define as an sf point object 
#portfolios <- st_as_sf(portfolios, coords = c("long", "lat"), crs = 4326) 

## Decide which subsets we're mapping:
# each of eventXFullXmin and eventXFullXminClaimed - as only points 
eventTwoPropertiesExposed<- select(eventTwoFull30, portfolioID)
eventTwoPropertiesDamaged<- select(eventTwoFull30Claimed, portfolioID)

eventOnePropertiesExposed<- select(eventOneFull50, portfolioID)
eventOnePropertiesDamaged<- select(eventOneFull50Claimed, portfolioID)

eventThreePropertiesExposed<- select(eventThreeFull50, portfolioID)
eventThreePropertiesDamaged<- select(eventThreeFull50Claimed, portfolioID)


#properties100 <- portfoliosClaimsVcsnNl1506precipOver100
#properties50 <- portfoliosClaimsVcsnNl1506precipOver50

#properties100 <- portfoliosClaimsVcsnNl1611precipOver100
#properties50 <- portfoliosClaimsVcsnNl1611precipOver50

#properties100 <- portfoliosClaimsVcsnNl1703precipOver100
#properties50 <- portfoliosClaimsVcsnNl1703precipOver50

####


library(leaflet)
#library("Map")

eventOneMAP<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=eventOnePropertiesExposed, group="damaged",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#ffc125") %>%
  #cadetblue4 = rgb #5f9ea0
  #steelblue4 = rgb #33648b
  
  addCircleMarkers(data=eventOnePropertiesDamaged, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "black") %>% 
  
  setView( lng = 173.2295
           , lat = -41.2728,
           zoom = 5.2) %>%
  
  addProviderTiles(providers$CartoDB.Positron)

eventOneMAP

eventOneMAP2<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=eventOneFull50, group="damaged",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#ffb90f") %>%
  #cadetblue4 = rgb #5f9ea0
  #steelblue4 = rgb #33648b
  
  addCircleMarkers(data=eventOneFull100, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#eead0e") %>% 
  
  addCircleMarkers(data=eventOneFull150, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#cd950c") %>% 
  
  setView( lng = 173.2295
           , lat = -41.2728,
           zoom = 5.2) %>%
  
  addProviderTiles(providers$CartoDB.Positron)

eventOneMAP2

####

eventTwoMAP<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=eventTwoPropertiesExposed, group="damaged",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#ffc125") %>%
  #cadetblue4 = rgb #5f9ea0
  #steelblue4 = rgb #33648b
  
  addCircleMarkers(data=eventTwoPropertiesDamaged, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "black") %>% 
  
  setView( lng = 173.2295
         , lat = -41.2728,
         zoom = 5.2) %>%

  addProviderTiles(providers$CartoDB.Positron)

#%>% 

  #addLegend(position = "bottomright", labels=c("over 50mm", "over 100mm"),
            #colors=c("#F5793A", "#A95AA1"), opacity=1)

eventTwoMAP

eventTwoMAP2<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=eventTwoFull30, group="damaged",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#ffb90f") %>%
  #cadetblue4 = rgb #5f9ea0
  #steelblue4 = rgb #33648b
  
  addCircleMarkers(data=eventTwoFull50, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#eead0e") %>% 
  
  addCircleMarkers(data=eventTwoFull100, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#cd950c") %>% 
  
  setView( lng = 173.2295
           , lat = -41.2728,
           zoom = 5.2) %>%
  
  addProviderTiles(providers$CartoDB.Positron)

eventTwoMAP2

###

eventThreeMAP<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=eventThreePropertiesExposed, group="damaged",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#ffc125") %>%
  #cadetblue4 = rgb #5f9ea0
  #steelblue4 = rgb #33648b
  
  addCircleMarkers(data=eventThreePropertiesDamaged, group="exposed",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "black") %>% 
  
  setView( lng = 173.2295
           , lat = -41.2728,
           zoom = 5.2) %>%
  
  addProviderTiles(providers$CartoDB.Positron)

eventThreeMAP

eventThreeMAP2<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=eventTwoFull50, group="50",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#ffb90f") %>%
  #cadetblue4 = rgb #5f9ea0
  #steelblue4 = rgb #33648b
  
  addCircleMarkers(data=eventThreeFull100, group="100",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#eead0e") %>% 
  
  addCircleMarkers(data=eventThreeFull150, group="150",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#cd950c") %>% 
  
  setView( lng = 173.2295
           , lat = -41.2728,
           zoom = 5.2) %>%
  
  addProviderTiles(providers$CartoDB.Positron)

eventThreeMAP2

