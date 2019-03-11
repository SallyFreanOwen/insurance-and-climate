# EQC claim vis  

# Summary statistics 
library(pastecs)
options(digits=3)
stat.desc(claims[,sapply(claims,is.numeric)], basic=F)

library(stargazer)
stargazer(claims)

# EQC - visualise the eqc property info (portfolio)

# assume have run scripts 1 and 2 
par(mar=c(1,1,1,1)) # (making margins large enough) 
plot(st_geometry(portfolios), main="All Portfolios", pch = 1, cex = 0.1, col = 1, bg = 1, type = "p")

# Summary statistics 
library(pastecs)
options(digits=3)
stat.desc(portfolios[,sapply(portfolios,is.numeric)], basic=F)

library(stargazer)
stargazer(portfolios)