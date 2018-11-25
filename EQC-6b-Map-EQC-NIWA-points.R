library(leaflet)
#library("Map")

aMAP<-leaflet() %>% #width = "100%", height="100%"
  addTiles() %>% 
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  
  # add scale bar
  addMeasure(position = "topright",
             primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters",
             activeColor = "#3D535D",
             completedColor = "#7D4479") %>%
  
  # all CA gages
  addCircleMarkers(data=claimSP, group="Portfolios - claimed sample",
                   stroke=TRUE, weight=0.3, radius=2,
                   fillOpacity = 0.7,
                   fillColor = "orange") %>%
  
  # add samples
  addCircleMarkers(data=precipOneDay, group="Rain on first day",
                   opacity = 0.8, 
                   weight=0.6,
                   radius=1, 
                   stroke=TRUE,
                   fillColor = "blue") %>%
  
  # add layer control
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial"),
    overlayGroups = c("Rain on first day", "Portfolios - claimed sample"),
    options = layersControlOptions(collapsed = T)) %>% 
  
  addLegend(position = "bottomright", labels=c("precip", "properties"),
            colors=c("blue", "orange"), opacity=1)

aMAP

# Map of grids (one day only) and claimed portfolios  
