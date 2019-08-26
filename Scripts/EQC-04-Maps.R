# Mapping figures 

####

#properties100 <- portfoliosClaimsVcsnNl1506precipOver100
#properties50 <- portfoliosClaimsVcsnNl1506precipOver50

properties100 <- portfoliosClaimsVcsnNl1611precipOver100
properties50 <- portfoliosClaimsVcsnNl1611precipOver50

#properties100 <- portfoliosClaimsVcsnNl1703precipOver100
#properties50 <- portfoliosClaimsVcsnNl1703precipOver50

####


library(leaflet)
#library("Map")

aMAP<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  #addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  
  addCircleMarkers(data=properties50, group="properties50",
                   stroke=FALSE, weight=0.2, radius=1,
                   fillOpacity = 0.7,
                   fillColor = "#F5793A") %>% 
  
  addCircleMarkers(data=properties100, group="properties10",
                 stroke=FALSE, weight=0.2, radius=1,
                 fillOpacity = 0.7,
                 fillColor = "#A95AA1") %>% 

  addLegend(position = "bottomright", labels=c("over 50mm", "over 100mm"),
            colors=c("#F5793A", "#A95AA1"), opacity=1)

aMAP
