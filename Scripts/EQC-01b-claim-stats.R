# 1b claim vis  

# Summary statistics 
library(pastecs)
options(digits=3)
stat.desc(claims[,sapply(claims,is.numeric)], basic=F)

library(stargazer)
stargazer(claims)

