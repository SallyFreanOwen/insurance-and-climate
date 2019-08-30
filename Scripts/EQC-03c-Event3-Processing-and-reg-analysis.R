library(pastecs)
library(stargazer)
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(lubridate);
library(SearchTrees)
library(devtools)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(haven)
library(stars)
options(digits=3)

# Tidy workspace (only require event data)

rm(nl201505)
rm(nl201506)
rm(nl201506sf)
rm(nl201507)
rm(nl201508)

rm(nl201611)
rm(nl201612)
rm(nl201701)

############## 

portfolios <- portfolios[,c("portfolioID",
                            "mLandValueWithin8m", "mDwellingValue", "mDomesticContentsValue",
                            "slope", "distRiver", "distLake", "distCoast",
                            "meanNumHHMembers", "medianHHIncome","propDwellingNotOwned",
                            "nlLongitude.x", "nlLatitude.x",
                            "vcsnLongitude.x", "vcsnLatitude.x")
                         ]

names(portfolios)[12:15] <- c("nlLongitude", "nlLatitude", "vcsnLongitude", "vcsnLatitude")

# Event 3 - March 7th 2017

# Subset claim and rain info
#vcsn20150608 <- filter(vcsn, eventYear==2015 & eventMonth>05 & eventMonth<09) 
#claims20150608 <- filter(claims, eventYear==2015 & eventMonth>05 & eventMonth<09) 
vcsn201703 <- filter(vcsn, eventYear==2017 & eventMonth==03) 
claims201703 <- filter(claims, eventYear==2017 & eventMonth==03) 
claims201703 <- claims201703[,c("claimID","portfolioID",
                                "eventType","lossDate",
                                "buildingPaid","landPaid",
                                "claimStatus",
                                "buildingClaimCloseDate", "landClaimCloseDate",
                                "eventMonth","eventYear",
                                "approved")]

# generate time to payment:
claims201703$buildingTimeToPayment <- claims201703$buildingClaimCloseDate - claims201703$lossDate
claims201703$landTimeToPayment <- claims201703$landClaimCloseDate - claims201703$lossDate
claims201703$closedIn90days <- ifelse((claims201703$buildingTimeToPayment<91|claims201703$landTimeToPayment<91),1,0)

# generate precip window 
claims201703 <- mutate(claims201703, claims201703$lossDate+1)
claims201703 <- mutate(claims201703, claims201703$lossDate+2)
names(claims201703)[16:17] <- c("lossDatePlusOne", "lossDatePlusTwo")

portfoliosClaims17 <- merge(portfolios, claims201703, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn17 <- merge(portfoliosClaims17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[32] <- "rain1"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[33] <- "rain2"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[34] <- "rain3"

# NL work... 

nl201702df = as.data.frame(nl201702)
nl201703df = as.data.frame(nl201703)
nl201704df = as.data.frame(nl201704)
nl201705df = as.data.frame(nl201705)
rm(nl201702)
rm(nl201703)
rm(nl201704)
rm(nl201705)

portfoliosClaimsVcsn17 <- portfoliosClaimsVcsn17[,c(
  "vcsnLongitude",           
  "vcsnLatitude",                
  "lossDatePlusTwo",             
  "lossDatePlusOne",             
  "lossDate",                    
  "portfolioID",                 
  "mLandValueWithin8m",             
  "mDwellingValue",              
  "slope",    
  "distRiver",
  "distLake",
  "distCoast",
  "meanNumHHMembers",    
  "medianHHIncome",       
  "propDwellingNotOwned",
  "nlLongitude",                 
  "nlLatitude" ,                 
  "claimID",                     
  "eventType",                   
  "buildingPaid",                
  "landPaid",                    
  "claimStatus",                 
  "buildingClaimCloseDate",      
  "landClaimCloseDate",          
  "eventMonth",                  
  "eventYear",                   
  "approved",                    
  "closedIn90days",              
  "rain1",                       
  "rain2",                       
  "rain3" ,                      
  "geometry" 
)]

rm(claims201703)
rm(vcsn201703)
rm(portfoliosClaims17)

# attach NL information to all properties 
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsn17, nl201702df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[32] <- "nl0"

portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201703df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[33] <- "nl1"
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201704df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[34] <- "nl2"
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201705df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[35] <- "nl3"

# check it is what you think it is...
names(portfoliosClaimsVcsnNl17)

#Tidy workspace
rm(portfoliosClaimsVcsn17)

#create claimed
portfoliosClaimsVcsnNl17$claimed <- ifelse(is.na(portfoliosClaimsVcsnNl17$claimID),0,1)

# clear workspace 
rm(nl201702df)
rm(nl201703df)
rm(nl201704df)
rm(nl201705df)

### Build correct NL variables for analysis:
portfoliosClaimsVcsnNl17 <- mutate(portfoliosClaimsVcsnNl17, nl3-nl1)
names(portfoliosClaimsVcsnNl17)[37] <- c("nldif31")

portfoliosClaimsVcsnNl17 <- mutate(portfoliosClaimsVcsnNl17, nl1-nl0)
names(portfoliosClaimsVcsnNl17)[38] <- c("nldif10")

### Attaching alternate precip 
vcsn20170307 <- filter(vcsn, vcsnDay=="2017-03-07")
vcsn20170307 <- vcsn20170307[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20170314) # rain range 0-200
vcsn20170308 <- filter(vcsn, vcsnDay=="2017-03-08")
vcsn20170308 <- vcsn20170308[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20170315)# rain range 0-200
vcsn20170309 <- filter(vcsn, vcsnDay=="2017-03-09")
vcsn20170309 <- vcsn20170309[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20170316) # drops to 0-80 

portfoliosClaimsVcsnNl17AllPrecip0307 <- merge(portfoliosClaimsVcsnNl17, vcsn20170307, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip0307)[39] <- c("rain0307")
portfoliosClaimsVcsnNl17AllPrecip030708 <- merge(portfoliosClaimsVcsnNl17AllPrecip0307, vcsn20170308, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip030708)[40] <- c("rain0308")
portfoliosClaimsVcsnNl17AllPrecip03070809 <- merge(portfoliosClaimsVcsnNl17AllPrecip030708, vcsn20170309, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip03070809)[41] <- c("rain0309")

rm(portfoliosClaimsVcsnNl17AllPrecip0307)
rm(portfoliosClaimsVcsnNl17AllPrecip030708)

# adjust "approved" variable to also be 0 for unclaimed properties:
# first - has it got a claim at all? 
portfoliosClaimsVcsnNl17AllPrecip03070809$approved <- replace_na(portfoliosClaimsVcsnNl17AllPrecip03070809$approved, 0)
portfoliosClaimsVcsnNl17AllPrecip03070809$closedIn90days <- replace_na(portfoliosClaimsVcsnNl17AllPrecip03070809$closedIn90days, 0)

portfoliosClaimsVcsnNl1703precipOver50 <- filter(portfoliosClaimsVcsnNl17AllPrecip03070809, rain0307 > 50 | rain0308 > 50 | rain0309 > 50 )
portfoliosClaimsVcsnNl1703precipOver100 <- filter(portfoliosClaimsVcsnNl17AllPrecip03070809, rain0307 > 100 | rain0308 > 100 | rain0309 > 100 )


portfoliosClaimsVcsnNl1703precipOver50$medHHIncome <- portfoliosClaimsVcsnNl1703precipOver50$medianHHIncome/1000
portfoliosClaimsVcsnNl1703precipOver100$medHHIncome <- portfoliosClaimsVcsnNl1703precipOver100$medianHHIncome/1000

portfoliosClaimsVcsnNl1703precipOver50$dRiver <- portfoliosClaimsVcsnNl1703precipOver50$distRiver/1000
portfoliosClaimsVcsnNl1703precipOver50$dCoast <- portfoliosClaimsVcsnNl1703precipOver50$distCoast/1000
portfoliosClaimsVcsnNl1703precipOver50$dLake <- portfoliosClaimsVcsnNl1703precipOver50$distLake/1000
portfoliosClaimsVcsnNl1703precipOver100$dRiver <- portfoliosClaimsVcsnNl1703precipOver100$distRiver/1000
portfoliosClaimsVcsnNl1703precipOver100$dCoast <- portfoliosClaimsVcsnNl1703precipOver100$distCoast/1000
portfoliosClaimsVcsnNl1703precipOver100$dLake <- portfoliosClaimsVcsnNl1703precipOver100$distLake/1000

##

linearMod1 <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1703precipOver50)  # build linear regression model on full data
summary(linearMod1)

linearMod2 <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1703precipOver50)  # build linear regression model on full data
summary(linearMod2)

linearMod3 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1703precipOver50)  # build linear regression model on full data
summary(linearMod3)

#linearMod4 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1506precipOver50)  # build linear regression model on full data
#summary(linearMod4)

######

linearMod5 <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1703precipOver100)  # build linear regression model on full data
summary(linearMod5)

linearMod6 <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1703precipOver100)  # build linear regression model on full data
summary(linearMod6)

linearMod7 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1703precipOver100)  # build linear regression model on full data
summary(linearMod7)

#linearMod8 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1506precipOver100)  # build linear regression model on full data
#summary(linearMod8)

stat.desc(portfoliosClaimsVcsnNl1703precipOver100)

stat.desc(portfoliosClaimsVcsnNl1703precipOver50)

stargazer(linearMod1, linearMod2, linearMod3, title="Results - event three 50mm threshold")
#stargazer(portfoliosClaimsVcsnNl1506precipOver50)

stargazer(linearMod5, linearMod6, linearMod7, title = "Results - event three 100mm threshold")
#stargazer(portfoliosClaimsVcsnNl1506precipOver100)

