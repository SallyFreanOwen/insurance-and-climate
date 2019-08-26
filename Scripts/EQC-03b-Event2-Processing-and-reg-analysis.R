library(pastecs)
library(stargazer)
options(digits=3)

# Tidy workspace (only require event data)

rm(nl201505)
rm(nl201506)
rm(nl201507)
rm(nl201508)

rm(nl201703)
rm(nl201704)
rm(nl201705)

############## 

portfolios <- portfolios[,c("portfolioID",
                            "mLandValueWithin8m", "mDwellingValue", "mDomesticContentsValue",
                            "slope", "distRiver", "distLake", "distCoast",
                            "meanNumHHMembers", "medianHHIncome","propDwellingNotOwned",
                            "nlLongitude.x", "nlLatitude.x",
                            "vcsnLongitude.x", "vcsnLatitude.x")
                         ]

names(portfolios)[12:15] <- c("nlLongitude", "nlLatitude", "vcsnLongitude", "vcsnLatitude")

# Event 2 - 11/16

# Subset claim and rain info
#vcsn20150608 <- filter(vcsn, eventYear==2015 & eventMonth>05 & eventMonth<09) 
#claims20150608 <- filter(claims, eventYear==2015 & eventMonth>05 & eventMonth<09) 
vcsn201611 <- filter(vcsn, eventYear==2016 & eventMonth==11) 
claims201611 <- filter(claims, eventYear==2016 & eventMonth==11) 
claims201611 <- claims201611[,c("claimID","portfolioID",
                                "eventType","lossDate",
                                "buildingPaid","landPaid",
                                "claimStatus",
                                "buildingClaimCloseDate", "landClaimCloseDate",
                                "eventMonth","eventYear",
                                "approved")]

# generate time to payment:
claims201611$buildingTimeToPayment <- claims201611$buildingClaimCloseDate - claims201611$lossDate
claims201611$landTimeToPayment <- claims201611$landClaimCloseDate - claims201611$lossDate
claims201611$closedIn90days <- ifelse((claims201611$buildingTimeToPayment<91|claims201611$landTimeToPayment<91),1,0)

# generate precip window 
claims201611 <- mutate(claims201611, claims201611$lossDate+1)
claims201611 <- mutate(claims201611, claims201611$lossDate+2)
names(claims201611)[16:17] <- c("lossDatePlusOne", "lossDatePlusTwo")

portfoliosClaims16 <- merge(portfolios, claims201611, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn16 <- merge(portfoliosClaims16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[32] <- "rain1"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[33] <- "rain2"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[34] <- "rain3"

# NL work... 

nl201611df = as.data.frame(nl201611)
nl201612df = as.data.frame(nl201612)
nl201701df = as.data.frame(nl201701)
nl201702df = as.data.frame(nl201702)
rm(nl201611)
rm(nl201612)
rm(nl201701)
rm(nl201702)

portfoliosClaimsVcsn16 <- portfoliosClaimsVcsn16[,c(
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

rm(claims201611)
rm(vcsn201611)
rm(portfoliosClaims16)

# attach NL information to all properties 
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsn16, nl201611df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[32] <- "nl0"

portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201612df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[33] <- "nl1"
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201701df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[34] <- "nl2"
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201702df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[35] <- "nl3"

# check it is what you think it is...
names(portfoliosClaimsVcsnNl16)

#Tidy workspace
rm(portfoliosClaimsVcsn16)

#create claimed
portfoliosClaimsVcsnNl16$claimed <- ifelse(is.na(portfoliosClaimsVcsnNl16$claimID),0,1)

# clear workspace 
rm(nl201611df)
rm(nl201612df)
rm(nl201701df)
rm(nl201702df)

### Build correct NL variables for analysis:
portfoliosClaimsVcsnNl16 <- mutate(portfoliosClaimsVcsnNl16, nl3-nl1)
names(portfoliosClaimsVcsnNl16)[37] <- c("nldif31")

portfoliosClaimsVcsnNl16 <- mutate(portfoliosClaimsVcsnNl16, nl1-nl0)
names(portfoliosClaimsVcsnNl16)[38] <- c("nldif10")

### Attaching alternate precip 
vcsn20161114 <- filter(vcsn, vcsnDay=="2016-11-14")
vcsn20161114 <- vcsn20161114[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161114) # rain range 0-200
vcsn20161115 <- filter(vcsn, vcsnDay=="2016-11-15")
vcsn20161115 <- vcsn20161115[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161115)# rain range 0-200
vcsn20161116 <- filter(vcsn, vcsnDay=="2016-11-16")
vcsn20161116 <- vcsn20161116[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161116) # drops to 0-80 

portfoliosClaimsVcsnNl16AllPrecip1114 <- merge(portfoliosClaimsVcsnNl16, vcsn20161114, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip1114)[39] <- c("rain1114")
portfoliosClaimsVcsnNl16AllPrecip111415 <- merge(portfoliosClaimsVcsnNl16AllPrecip1114, vcsn20161115, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip111415)[40] <- c("rain1115")
portfoliosClaimsVcsnNl16AllPrecip11141516 <- merge(portfoliosClaimsVcsnNl16AllPrecip111415, vcsn20161116, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip11141516)[41] <- c("rain1116")

rm(portfoliosClaimsVcsnNl16AllPrecip1114)
rm(portfoliosClaimsVcsnNl16AllPrecip111415)

# adjust "approved" variable to also be 0 for unclaimed properties:
# first - has it got a claim at all? 
portfoliosClaimsVcsnNl16AllPrecip11141516$approved <- replace_na(portfoliosClaimsVcsnNl16AllPrecip11141516$approved, 0)
portfoliosClaimsVcsnNl16AllPrecip11141516$closedIn90days <- replace_na(portfoliosClaimsVcsnNl16AllPrecip11141516$closedIn90days, 0)

portfoliosClaimsVcsnNl1611precipOver50 <- filter(portfoliosClaimsVcsnNl16AllPrecip11141516, rain1114 > 50 | rain1115 > 50 | rain1116 > 50 )
portfoliosClaimsVcsnNl1611precipOver100 <- filter(portfoliosClaimsVcsnNl16AllPrecip11141516, rain1114 > 100 | rain1115 > 100 | rain1116 > 100 )

linearMod1 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver50)  # build linear regression model on full data
summary(linearMod1)

linearMod2 <- lm(nldif31 ~ nldif10 + approved + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver50)  # build linear regression model on full data
summary(linearMod2)

linearMod3 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver50)  # build linear regression model on full data
summary(linearMod3)

linearMod4 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + distRiver + distLake + distCoast + medianHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1611precipOver50)  # build linear regression model on full data
summary(linearMod4)

stat.desc(portfoliosClaimsVcsnNl1611precipOver50)

stargazer(linearMod1, linearMod2, linearMod3, linearMod4, title="Results - event two 50mm threshold")
#stargazer(portfoliosClaimsVcsnNl1506precipOver50)


linearMod5 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver100)  # build linear regression model on full data
summary(linearMod5)

linearMod6 <- lm(nldif31 ~ nldif10 + approved + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver100)  # build linear regression model on full data
summary(linearMod6)

linearMod7 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver100)  # build linear regression model on full data
summary(linearMod7)

linearMod8 <- lm(nldif31 ~ nldif10 + closedIn90days + slope + distRiver + distLake + distCoast + medianHHIncome + propDwellingNotOwned, data=portfoliosClaimsVcsnNl1611precipOver100)  # build linear regression model on full data
summary(linearMod8)

stat.desc(portfoliosClaimsVcsnNl1611precipOver100)

###

stargazer(linearMod1, linearMod2, linearMod3, linearMod4, title="Results - event two 50mm threshold")
#stargazer(portfoliosClaimsVcsnNl1506precipOver50)

stargazer(linearMod5, linearMod6, linearMod7, linearMod8,title = "Results - event two 100mm threshold")
#stargazer(portfoliosClaimsVcsnNl1506precipOver100)

stargazer(linearMod3, linearMod4, linearMod7, linearMod8, title= "Event 2")
#stargazer(portfoliosClaimsVcsnNl15AllPrecip06181920, portfoliosClaimsVcsnNl1506precipOver50, portfoliosClaimsVcsnNl1506precipOver100)



