library(dplyr)
library(pastecs)
library(stargazer)
library(stars)
library(tidyr)
library(devtools)
options(digits=3)

### Input: load("~/insurance-and-climate/Data/data-insurance-and-climate-post-processed.RData")

# Tidy workspace (only require event one data)

rm(nl201610)
rm(nl201611)
rm(nl201612)
rm(nl201701)

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

# Event 1 - 06/2015

# Subset claim and rain info
#vcsn20150608 <- filter(vcsn, eventYear==2015 & eventMonth>05 & eventMonth<09) 
#claims20150608 <- filter(claims, eventYear==2015 & eventMonth>05 & eventMonth<09) 
vcsn201506 <- filter(vcsn, eventYear==2015 & eventMonth==06) 
claims201506 <- filter(claims, eventYear==2015 & eventMonth==06) 
claims201506 <- claims201506[,c("claimID","portfolioID",
                                "eventType","lossDate",
                                "buildingPaid","landPaid",
                                "claimStatus",
                                "buildingClaimCloseDate", "landClaimCloseDate",
                                "eventMonth","eventYear",
                                "approved")]

# keep only claims (within the month) from the event in question: 
claims201506 <- dplyr::filter(claims201506, 
                              lossDate > "2015-06-16" &
                                lossDate < "2015-06-23")

# generate time to payment:
claims201506$buildingTimeToPayment <- claims201506$buildingClaimCloseDate - claims201506$lossDate
claims201506$landTimeToPayment <- claims201506$landClaimCloseDate - claims201506$lossDate
claims201506$closedIn90days <- ifelse((claims201506$buildingTimeToPayment<91|claims201506$landTimeToPayment<91),1,0)

# generate precip window 
claims201506 <- mutate(claims201506, claims201506$lossDate+1)
claims201506 <- mutate(claims201506, claims201506$lossDate+2)
claims201506 <- mutate(claims201506, claims201506$lossDate-1)
claims201506 <- mutate(claims201506, claims201506$lossDate-2)
names(claims201506)[16:19] <- c("lossDatePlusOne", "lossDatePlusTwo", "lossDateMinusOne", "lossDateMinusTwo")

portfoliosClaims15 <- merge(portfolios, claims201506, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn15 <- merge(portfoliosClaims15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[34] <- "rain1"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[35] <- "rain2"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[36] <- "rain3"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDateMinusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[37] <- "rain-1"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDateMinusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[38] <- "rain-2"

# NL work... 

nl201505df = as.data.frame(nl201505)
nl201506df = as.data.frame(nl201506)
nl201507df = as.data.frame(nl201507)
nl201508df = as.data.frame(nl201508)
rm(nl201505)
rm(nl201506)
rm(nl201507)
rm(nl201508)

portfoliosClaimsVcsn15 <- portfoliosClaimsVcsn15[,c(
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

rm(claims201506)
rm(vcsn201506)
rm(portfoliosClaims15)

# attach NL information to all properties 
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsn15, nl201505df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[36] <- "nl0"

portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201506df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[37] <- "nl1"
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201507df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[38] <- "nl2"
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201508df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[39] <- "nl3"

# check it is what you think it is...
names(portfoliosClaimsVcsnNl15)

#Tidy workspace
rm(portfoliosClaimsVcsn15)

#create claimed
portfoliosClaimsVcsnNl15$claimed <- ifelse(is.na(portfoliosClaimsVcsnNl15$claimID),0,1)

# clear workspace 
rm(nl201505df)
rm(nl201506df)
rm(nl201507df)
rm(nl201508df)

#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)

### Build correct NL variables for analysis:
portfoliosClaimsVcsnNl15 <- mutate(portfoliosClaimsVcsnNl15, nl3-nl1)
names(portfoliosClaimsVcsnNl15)[41] <- c("nldif31")

portfoliosClaimsVcsnNl15 <- mutate(portfoliosClaimsVcsnNl15, nl1-nl0)
names(portfoliosClaimsVcsnNl15)[42] <- c("nldif10")

#library(pastecs)
#options(digits=3)
#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)
#scatter.smooth(x=portfoliosClaimsVcsnNl15$claimed, y=portfoliosClaimsVcsnNl15$nldif0807)

### Attaching alternate precip 

# visualising payments 
#plot(x = claims201506$lossDate, y= claims201506$buildingPaid)
#plot(x = claims201506$lossDate, y= claims201506$landPaid)

#Looks like we want LossDate/vcsnDay= 18th June or the next few days 
vcsn15 <- filter(vcsn, vcsn$vcsnDay > "2014-12-31", vcsn$vcsnDay < "2016-01-01")
vcsn1506 <- filter(vcsn15, vcsn15$eventMonth == "6")
rm(vcsn15)

vcsn20150617 <- filter(vcsn1506, vcsnDay=="2015-06-17")
vcsn20150617 <- vcsn20150617[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20150618)
vcsn20150618 <- filter(vcsn1506, vcsnDay=="2015-06-18")
vcsn20150618 <- vcsn20150618[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20150618)
vcsn20150619 <- filter(vcsn1506, vcsnDay=="2015-06-19")
vcsn20150619 <- vcsn20150619[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20150619)
vcsn20150620 <- filter(vcsn1506, vcsnDay=="2015-06-20")
vcsn20150620 <- vcsn20150620[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20150620)
vcsn20150621 <- filter(vcsn1506, vcsnDay=="2015-06-21")
vcsn20150621 <- vcsn20150621[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#plot(vcsn20150621)
vcsn20150622 <- filter(vcsn1506, vcsnDay=="2015-06-22")
vcsn20150622 <- vcsn20150622[,c("vcsnLongitude", "vcsnLatitude", "rain")]

#plot(vcsn20150622)
#vcsn20150621 <- filter(vcsn, vcsnDay=="2015-06-21")
#vcsn20150621 <- vcsn20150621[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#vcsn20150622 <- filter(vcsn, vcsnDay=="2015-06-22")
#vcsn20150622 <- vcsn20150622[,c("vcsnLongitude", "vcsnLatitude", "rain")]

portfoliosClaimsVcsnNl15AllPrecip0617 <- merge(portfoliosClaimsVcsnNl15, vcsn20150617, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip0617)[43] <- c("rain0617")
portfoliosClaimsVcsnNl15AllPrecip061718 <- merge(portfoliosClaimsVcsnNl15AllPrecip0617, vcsn20150618, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip061718)[44] <- c("rain0618")
portfoliosClaimsVcsnNl15AllPrecip06171819 <- merge(portfoliosClaimsVcsnNl15AllPrecip061718, vcsn20150619, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip06171819)[45] <- c("rain0619")
portfoliosClaimsVcsnNl15AllPrecip0617181920 <- merge(portfoliosClaimsVcsnNl15AllPrecip06171819, vcsn20150620, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip0617181920)[46] <- c("rain0620")
portfoliosClaimsVcsnNl15AllPrecip061718192021 <- merge(portfoliosClaimsVcsnNl15AllPrecip0617181920, vcsn20150621, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip061718192021)[47] <- c("rain0621")
portfoliosClaimsVcsnNl15AllPrecip06171819202122 <- merge(portfoliosClaimsVcsnNl15AllPrecip061718192021, vcsn20150622, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip06171819202122)[48] <- c("rain0622")

rm(portfoliosClaimsVcsnNl15AllPrecip0617)
rm(portfoliosClaimsVcsnNl15AllPrecip061718)
rm(portfoliosClaimsVcsnNl15AllPrecip06171819)
rm(portfoliosClaimsVcsnNl15AllPrecip0617181920)
rm(portfoliosClaimsVcsnNl15AllPrecip061718192021)

rm(vcsn20150617)
rm(vcsn20150618)
rm(vcsn20150619)
rm(vcsn20150620)
rm(vcsn20150621)
rm(vcsn20150622)

# adjust "approved" variable to also be 0 for unclaimed properties:
# first - has it got a claim at all? 
portfoliosClaimsVcsnNl15AllPrecip06171819202122$approved <- replace_na(portfoliosClaimsVcsnNl15AllPrecip06171819202122$approved, 0)
portfoliosClaimsVcsnNl15AllPrecip06171819202122$closedIn90days <- replace_na(portfoliosClaimsVcsnNl15AllPrecip06171819202122$closedIn90days, 0)
#portfoliosClaimsVcsnNl15AllPrecip06181920$closedIn90days <- replace(portfoliosClaimsVcsnNl15AllPrecip06181920$closedIn90days,portfoliosClaimsVcsnNl15AllPrecip06181920$approved==0, 0)

# check it is what you think it is...
#portfoliosClaimsVcsnNl15AllPrecip0620$correctLossDate <- 0
#portfoliosClaimsVcsnNl15AllPrecip0620test <- filter(portfoliosClaimsVcsnNl15AllPrecip0620, claimed==1)
#portfoliosClaimsVcsnNl15$correctLossDate <- ifelse(lossDate == "2015-06-20", 0, 1)

#portfoliosClaimsVcsnNl15AllPrecip06171819202122 <- as.data.frame(portfoliosClaimsVcsnNl15AllPrecip06171819202122)

# clean desk:
rm(claims)
rm(nl201610)
rm(nl201702)
rm(nl201506sf)
rm(portfolios)
rm(portfoliosClaimsVcsnNl15)
rm(vcsn)
rm(vcsn1506)
rm(nzboundary)

# save final set: 
save.image("~/insurance-and-climate/Data/EQC-event1-full.RData")
