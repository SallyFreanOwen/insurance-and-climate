library(pastecs)
library(stargazer)
library(leaflet);
library(htmltools);
library(lubridate);
library(devtools)
library(tidyr)
library(tidyverse)
library(stars)
options(digits=3)

# Tidy workspace (only require event data)

rm(nl201505)
rm(nl201506)
rm(nl201506sf)
rm(nl201507)
rm(nl201508)

rm(nl201610)
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

# keep only claims (within the month) from the event in question: 
claims201703 <- dplyr::filter(claims201703, 
                              lossDate > "2017-03-05" &
                                lossDate < "2017-03-11")

# generate time to payment:
claims201703$buildingTimeToPayment <- claims201703$buildingClaimCloseDate - claims201703$lossDate
claims201703$landTimeToPayment <- claims201703$landClaimCloseDate - claims201703$lossDate
claims201703$closedIn90days <- ifelse((claims201703$buildingTimeToPayment<91|claims201703$landTimeToPayment<91),1,0)

# generate precip window 
claims201703 <- mutate(claims201703, claims201703$lossDate+1)
claims201703 <- mutate(claims201703, claims201703$lossDate+2)
claims201703 <- mutate(claims201703, claims201703$lossDate-1)
claims201703 <- mutate(claims201703, claims201703$lossDate-2)
names(claims201703)[16:19] <- c("lossDatePlusOne", "lossDatePlusTwo", "lossDateMinusOne", "lossDateMinusTwo")

portfoliosClaims17 <- merge(portfolios, claims201703, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn17 <- merge(portfoliosClaims17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[34] <- "rain1"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[35] <- "rain2"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[36] <- "rain3"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDateMinusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[37] <- "rain-1"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDateMinusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[38] <- "rain-2"

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
  "lossDateMinusOne", 
  "lossDateMinusTwo", 
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
  "rain-1",
  "rain-2"
)]

rm(claims201703)
rm(vcsn201703)
rm(portfoliosClaims17)

# attach NL information to all properties 
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsn17, nl201702df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[36] <- "nl0"

portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201703df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[37] <- "nl1"
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201704df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[38] <- "nl2"
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201705df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[39] <- "nl3"

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
names(portfoliosClaimsVcsnNl17)[41] <- c("nldif31")

portfoliosClaimsVcsnNl17 <- mutate(portfoliosClaimsVcsnNl17, nl1-nl0)
names(portfoliosClaimsVcsnNl17)[42] <- c("nldif10")

### Attaching alternate precip 
vcsn17 <- filter(vcsn, vcsn$vcsnDay > "2016-12-31", vcsn$vcsnDay < "2018-01-01")
vcsn1703 <- filter(vcsn17, vcsn17$eventMonth == "3")
rm(vcsn17)

vcsn20170306 <- filter(vcsn1703, vcsnDay=="2017-03-06")
vcsn20170306 <- vcsn20170306[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot 
vcsn20170307 <- filter(vcsn1703, vcsnDay=="2017-03-07")
vcsn20170307 <- vcsn20170307[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20170314) # rain range 0-200
vcsn20170308 <- filter(vcsn1703, vcsnDay=="2017-03-08")
vcsn20170308 <- vcsn20170308[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20170315)# rain range 0-200
vcsn20170309 <- filter(vcsn1703, vcsnDay=="2017-03-09")
vcsn20170309 <- vcsn20170309[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20170316) # drops to 0-80 
vcsn20170310 <- filter(vcsn1703, vcsnDay=="2017-03-10")
vcsn20170310 <- vcsn20170310[,c("vcsnLongitude", "vcsnLatitude", "rain")]

#vcsn20170311 <- filter(vcsn1703, vcsnDay=="2017-03-11")
#vcsn20170311 <- vcsn20170311[,c("vcsnLongitude", "vcsnLatitude", "rain")]

#
rm(vcsn)

portfoliosClaimsVcsnNl17AllPrecip0306 <- merge(portfoliosClaimsVcsnNl17, vcsn20170306, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip0306)[43] <- c("rain0306")
portfoliosClaimsVcsnNl17AllPrecip030607 <- merge(portfoliosClaimsVcsnNl17AllPrecip0306, vcsn20170307, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip030607)[44] <- c("rain0307")
portfoliosClaimsVcsnNl17AllPrecip03060708 <- merge(portfoliosClaimsVcsnNl17AllPrecip030607, vcsn20170308, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip03060708)[45] <- c("rain0308")
portfoliosClaimsVcsnNl17AllPrecip0306070809 <- merge(portfoliosClaimsVcsnNl17AllPrecip03060708, vcsn20170309, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip0306070809)[46] <- c("rain0309")
portfoliosClaimsVcsnNl17AllPrecip030607080910 <- merge(portfoliosClaimsVcsnNl17AllPrecip0306070809, vcsn20170310, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip030607080910)[47] <- c("rain0310")
#portfoliosClaimsVcsnNl17AllPrecip0306070809 <- merge(portfoliosClaimsVcsnNl17AllPrecip03060708, vcsn20170309, by = c("vcsnLongitude", "vcsnLatitude"))
#names(portfoliosClaimsVcsnNl17AllPrecip0306070809)[48] <- c("rain0311")

rm(portfoliosClaimsVcsnNl17AllPrecip0306)
rm(portfoliosClaimsVcsnNl17AllPrecip030607)
rm(portfoliosClaimsVcsnNl17AllPrecip03060708)
rm(portfoliosClaimsVcsnNl17AllPrecip0306070809)
rm(vcsn20170306)
rm(vcsn20170307)
rm(vcsn20170308)
rm(vcsn20170309)
rm(vcsn20170310)
rm(vcsn1703)

# adjust "approved" variable to also be 0 for unclaimed properties:
# first - has it got a claim at all? 
portfoliosClaimsVcsnNl17AllPrecip030607080910$approved <- replace_na(portfoliosClaimsVcsnNl17AllPrecip030607080910$approved, 0)
portfoliosClaimsVcsnNl17AllPrecip030607080910$closedIn90days <- replace_na(portfoliosClaimsVcsnNl17AllPrecip030607080910$closedIn90days, 0)

# clean desk:
rm(claims)
rm(nl201610)
rm(portfolios)
rm(portfoliosClaimsVcsnNl17)
rm(nzboundary)

# save final set: 
save.image("~/insurance-and-climate/EQC-event3-full.RData")
