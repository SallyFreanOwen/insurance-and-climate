# EQC 3 - visualise the eqc property info (portfolio)

library(sf)

# Make spatial 
portfolioSP <- st_as_sf(portfolioWorking, coords = c("WGS84Longitude", "WGS84Latitude"), crs = 4326) #note crs tells it the latlons are wgs84
# NB the only change is the addition of a list-column to our dataframe, called geometry, which is an sfc_POINT class.

# check "projected"
st_crs(portfolioSP)
# it is, but if it wasn't we'd want: 
#st_crs(ph_sf) <- 4326

# assume have run steps 1 and 2 
par(mar=c(1,1,1,1)) # (making margins large enough) 
plot(st_geometry(portfolioSP), main="All Portfolios", pch = 1, cex = 0.1, col = 1, bg = 1, type = "p")
