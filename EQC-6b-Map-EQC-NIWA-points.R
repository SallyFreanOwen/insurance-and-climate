library(leaflet)
library(map)

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
  addCircleMarkers(data=portfolioSP, group="Portfolio sample",
                   stroke=TRUE, weight=0.3, radius=4,
                   fillOpacity = 0.7,
                   fillColor = "orange") %>% 
                   #popup=paste0("USGS Site: ", gages_ca$STANAME, 
                    #            "<br>","SiteNo: ", gages_ca$STAID,
                     #           "<br>", "Ecoregion: ", gages_ca$AGGECOREGI,
                      #          "<br>", "Drainage Area (sqkm): ", gages_ca$DRAIN_SQKM)) 
  #clusterOptions = markerClusterOptions(),
  #clusterId = "gagesCluster") %>%
  
  # add samples
  addCircleMarkers(data=precipOneDay, group="Rain on first day",
                   opacity = 0.8, 
                   #popup=paste0("CDEC Site: ", df_locs$ID, "<br>",
                    #            "Station Name: ", df_locs$station, "<br>",
                     #           "Elev_ft: ", df_locs$elev_ft, "<br>",
                      #          "Operator: ",df_locs$Operator),
                   weight=0.6,radius=1, stroke=TRUE,
                   fillColor = "blue") %>%
  #hideGroup("GW Localities") %>% 
  
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial"),
    overlayGroups = c("Rain on first day", "Portfolio sample"),
    options = layersControlOptions(collapsed = T)) %>% 
  
  addLegend(position = "bottomright", labels=c("precip", "properties"),
            colors=c("blue", "orange"), opacity=1)

aMAP

# Map of precip (one day only) and portfolios  
