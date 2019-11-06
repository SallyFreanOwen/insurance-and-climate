library(dplyr)
library(pastecs)
library(stargazer)
library(stars)
library(tidyr)
library(devtools)
options(digits=3)

# Tidy workspace (only require event data)

rm(nl201505)
rm(nl201506)
rm(nl201506sf)
rm(nl201507)
rm(nl201508)

rm(nl201702)
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

# keep only claims (within the month) from the event in question: 
claims201611 <- dplyr::filter(claims201611, 
                              lossDate > "2016-11-12" &
                                lossDate < "2016-11-18")

# generate time to payment:
claims201611$buildingTimeToPayment <- claims201611$buildingClaimCloseDate - claims201611$lossDate
claims201611$landTimeToPayment <- claims201611$landClaimCloseDate - claims201611$lossDate
claims201611$closedIn90days <- ifelse((claims201611$buildingTimeToPayment<91|claims201611$landTimeToPayment<91),1,0)

# generate precip window 
claims201611 <- mutate(claims201611, claims201611$lossDate+1)
claims201611 <- mutate(claims201611, claims201611$lossDate+2)
claims201611 <- mutate(claims201611, claims201611$lossDate-1)
claims201611 <- mutate(claims201611, claims201611$lossDate-2)
names(claims201611)[16:19] <- c("lossDatePlusOne", "lossDatePlusTwo", "lossDateMinusOne", "lossDateMinusTwo")

portfoliosClaims16 <- merge(portfolios, claims201611, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn16 <- merge(portfoliosClaims16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[34] <- "rain1"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[35] <- "rain2"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[36] <- "rain3"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDateMinusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[37] <- "rain-1"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDateMinusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[38] <- "rain-2"

# NL work... 

nl201610df = as.data.frame(nl201610)
nl201611df = as.data.frame(nl201611)
nl201612df = as.data.frame(nl201612)
nl201701df = as.data.frame(nl201701)
#nl201702df = as.data.frame(nl201702)
rm(nl201610)
rm(nl201611)
rm(nl201612)
rm(nl201701)
#rm(nl201702)

portfoliosClaimsVcsn16 <- portfoliosClaimsVcsn16[,c(
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
  "rain3",
  "rain-1",
  "rain-2"
)]

rm(claims201611)
rm(vcsn201611)
rm(portfoliosClaims16)

# attach NL information to all properties 
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsn16, nl201610df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[36] <- "nl0"

portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201611df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[37] <- "nl1"
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201612df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[38] <- "nl2"
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201701df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[39] <- "nl3"

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
names(portfoliosClaimsVcsnNl16)[41] <- c("nldif31")

portfoliosClaimsVcsnNl16 <- mutate(portfoliosClaimsVcsnNl16, nl1-nl0)
names(portfoliosClaimsVcsnNl16)[42] <- c("nldif10")

### Attaching alternate precip 

#Looks like we want LossDate/vcsnDay= 18th June or the next few days 
vcsn16 <- filter(vcsn, vcsn$vcsnDay > "2015-12-31", vcsn$vcsnDay < "2017-01-01")
vcsn1611 <- filter(vcsn16, vcsn16$eventMonth == "11")
rm(vcsn16)

vcsn20161113 <- filter(vcsn1611, vcsnDay=="2016-11-13")
vcsn20161113 <- vcsn20161113[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161113) #
vcsn20161114 <- filter(vcsn1611, vcsnDay=="2016-11-14")
vcsn20161114 <- vcsn20161114[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161114) # rain range 0-200
vcsn20161115 <- filter(vcsn1611, vcsnDay=="2016-11-15")
vcsn20161115 <- vcsn20161115[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161115)# rain range 0-200
vcsn20161116 <- filter(vcsn1611, vcsnDay=="2016-11-16")
vcsn20161116 <- vcsn20161116[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161116) # drops to 0-80 
vcsn20161117 <- filter(vcsn1611, vcsnDay=="2016-11-17")
vcsn20161117 <- vcsn20161117[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20161117) # 

#plot(vcsn1611$rain,vcsn1611$vcsnDay)
rm(vcsn)

portfoliosClaimsVcsnNl16AllPrecip1113 <- merge(portfoliosClaimsVcsnNl16, vcsn20161113, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip1113)[43] <- c("rain1113")
portfoliosClaimsVcsnNl16AllPrecip111314 <- merge(portfoliosClaimsVcsnNl16AllPrecip1113, vcsn20161114, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip111314)[44] <- c("rain1114")
portfoliosClaimsVcsnNl16AllPrecip11131415 <- merge(portfoliosClaimsVcsnNl16AllPrecip111314, vcsn20161115, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip11131415)[45] <- c("rain1115")
portfoliosClaimsVcsnNl16AllPrecip1113141516 <- merge(portfoliosClaimsVcsnNl16AllPrecip11131415, vcsn20161116, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip1113141516)[46] <- c("rain1116")
portfoliosClaimsVcsnNl16AllPrecip111314151617 <- merge(portfoliosClaimsVcsnNl16AllPrecip1113141516, vcsn20161117, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip111314151617)[47] <- c("rain1117")
#portfoliosClaimsVcsnNl16AllPrecip11131415161718 <- merge(portfoliosClaimsVcsnNl16AllPrecip111314151617, vcsn20161118, by = c("vcsnLongitude", "vcsnLatitude"))
#names(portfoliosClaimsVcsnNl16AllPrecip11131415161718)[48] <- c("rain1118")

rm(portfoliosClaimsVcsnNl16AllPrecip1113)
rm(portfoliosClaimsVcsnNl16AllPrecip111314)
rm(portfoliosClaimsVcsnNl16AllPrecip11131415)
rm(portfoliosClaimsVcsnNl16AllPrecip1113141516)
rm(vcsn20161113)
rm(vcsn20161117)
rm(vcsn1611)

# adjust "approved" variable to also be 0 for unclaimed properties:
# first - has it got a claim at all? 
portfoliosClaimsVcsnNl16AllPrecip111314151617$approved <- replace_na(portfoliosClaimsVcsnNl16AllPrecip111314151617$approved, 0)
portfoliosClaimsVcsnNl16AllPrecip111314151617$closedIn90days <- replace_na(portfoliosClaimsVcsnNl16AllPrecip111314151617$closedIn90days, 0)

# clean desk:
rm(claims)
rm(nl201610)
rm(nl201610df)
rm(portfolios)
rm(portfoliosClaimsVcsnNl16)
rm(vcsn20161114)
rm(vcsn20161115)
rm(vcsn20161116)
rm(nzboundary)

# save final set: 
save.image("~/insurance-and-climate/Data/EQC-event2-full.RData")
