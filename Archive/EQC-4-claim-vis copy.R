# EQC - 4 visualise only portfolios that have made claims 

claimWorking <- merge(claimWorking, portfolioWorking, by = "PortfolioID") 
claimSP <- st_as_sf(claimWorking, coords = c("WGS84Longitude", "WGS84Latitude"), crs = 4326)

plot(st_geometry(claimSP), main = "Portfolios that have made EQC claims", pch = 1, cex = 0.1, col = 1, bg = 1, type = "p")
