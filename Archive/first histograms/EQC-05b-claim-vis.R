# EQC 5 b 

# visualise the claims

plot(st_geometry(st_as_sf(claimPortfolio)), main = "Portfolios that have made EQC claims", pch = 1, cex = 0.1, col = 1, bg = 1, type = "p")

