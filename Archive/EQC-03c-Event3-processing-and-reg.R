library(pastecs)
options(digits=3)

##############


portfolios <- portfolios[,c("portfolioID",
                            "mLandValueWithin8m", "mDwellingValue",
                            "slope", "distRiver", "distLake", "distCoast",
                            "nlLongitude", "nlLatitude",
                            "vcsnLongitude", "vcsnLatitude")
                         ]

# Event 3 - 03/2017
# to do: add map image of claimed upon properties 

# Subset claim and rain info
vcsn201703 <- filter(vcsn, eventYear==2017 & eventMonth == 3) 
claims201703 <- filter(claims, eventYear==2017 & eventMonth == 3)
## Drop eventYear and eventMonth columns ... 

claims201703 <- claims201703[,c("claimID","portfolioID",
                                "eventType","lossDate",
                                "buildingPaid","landPaid",
                                "claimStatus",
                                "buildingClaimCloseDate", "landClaimCloseDate",
                                "eventMonth","eventYear")]

## Eyeball : 

claims201703 <- mutate(claims201703, claims201703$lossDate+1)
claims201703 <- mutate(claims201703, claims201703$lossDate+2)

names(claims201703)[12:13] <- c("lossDatePlusOne", "lossDatePlusTwo")

#### 

plot(x = vcsn201703$vcsnDay, y = vcsn201703$rain)
plot(x = claims201703$lossDate, y = claims201703$landPaid)
plot(x = claims201703$lossDate, y = claims201703$buildingPaid)

# Attach to all portfolio data: 
portfoliosClaims17 <- merge(portfolios, claims201703, by = "portfolioID", all.x = TRUE)
portfoliosClaims17 <- as.data.frame(portfoliosClaims17[,c("portfolioID",
                                            "mLandValueWithin8m", 
                                            "mDwellingValue",
                                            "slope", 
                                            "distRiver", "distLake", "distCoast",
                                            "nlLongitude", "nlLatitude",
                                            "vcsnLongitude", "vcsnLatitude",
                                            "claimID",
                                            "eventType",
                                            "buildingPaid","landPaid",
                                            "claimStatus",
                                            "buildingClaimCloseDate", "landClaimCloseDate",
                                            "eventMonth","eventYear",
                                            "lossDate","lossDatePlusOne", "lossDatePlusTwo")
                                         ])
portfoliosClaims17 <- portfoliosClaims17[1:23]

# attach to claimed upon properties:
portfoliosClaimsVcsn17 <- merge(portfoliosClaims17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[24] <- "rain1"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[25] <- "rain2"
portfoliosClaimsVcsn17 <- merge(portfoliosClaimsVcsn17, vcsn201703[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn17)[26] <- "rain3"

# NL work... 

nl201702df = as.data.frame(nl201702)
nl201703df = as.data.frame(nl201703)
nl201704df = as.data.frame(nl201704)
nl201705df = as.data.frame(nl201705)
rm(nl201702)
rm(nl201703)
rm(nl201704)
rm(nl201705)

# attach NL information to all properties 
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsn17, nl201702df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[27] <- "nl0"

portfoliosClaimsVcsnNl17 <- as.data.frame(portfoliosClaimsVcsnNl17[1:27])

portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201703df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[28] <- "nl1"
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201704df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[29] <- "nl2"
portfoliosClaimsVcsnNl17 <- merge(portfoliosClaimsVcsnNl17, nl201705df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl17)[30] <- "nl3"

# check it is what you think it is...
names(portfoliosClaimsVcsnNl17)
portfoliosClaimsVcsnNl17$claimed <- 0
portfoliosClaimsVcsnNl17$claimed <- ifelse(is.na(portfoliosClaimsVcsnNl17$claimID),0,1)

# clear workspace 

rm(nl201611)
rm(nl201612)
rm(nl201701)

rm(nl201703)
rm(nl201704)
rm(nl201705)

rm(nl201611df)
rm(nl201612df)
rm(nl201701df)

rm(nl201703df)
rm(nl201704df)
rm(nl201705df)

rm(portfolioNlID)
rm(portfolioVcsnID)
rm(portfoliosClaims15)
rm(portfoliosClaimsVcsn15)

rm(vcsnWide)


#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)

### Build correct variables for analysis:
portfoliosClaimsVcsnNl17 <- mutate(portfoliosClaimsVcsnNl17, nl3-nl1)
names(portfoliosClaimsVcsnNl17)[32] <- c("nldif31")

portfoliosClaimsVcsnNl17 <- mutate(portfoliosClaimsVcsnNl17, nl1-nl0)
names(portfoliosClaimsVcsnNl17)[33] <- c("nldif10")

#library(pastecs)
#options(digits=3)
#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)
#scatter.smooth(x=portfoliosClaimsVcsnNl15$claimed, y=portfoliosClaimsVcsnNl15$nldif0807)



#Looks like we want LossDate/vcsnDay = XXXX or the next few days 

vcsn20170307 <- filter(vcsn201703, vcsnDay=="2017-03-07")
vcsn20170307 <- vcsn20170307[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170307) # rain range 0-170ish
vcsn20170308 <- filter(vcsn201703, vcsnDay=="2017-03-08")
vcsn20170308 <- vcsn20170308[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170308) # rain range 0-170ish
vcsn20170309 <- filter(vcsn201703, vcsnDay=="2017-03-09")
vcsn20170309 <- vcsn20170309[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170309) # rain range 0-170ish
vcsn20170310 <- filter(vcsn201703, vcsnDay=="2017-03-10")
vcsn20170310 <- vcsn20170310[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170310) # rain range 0-170ish
vcsn20170311 <- filter(vcsn201703, vcsnDay=="2017-03-11")
vcsn20170311 <- vcsn20170311[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170311) # rain range 0-170ish
vcsn20170312 <- filter(vcsn201703, vcsnDay=="2017-03-12")
vcsn20170312 <- vcsn20170312[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170312) # rain range 0-170ish
vcsn20170313 <- filter(vcsn201703, vcsnDay=="2017-03-13")
vcsn20170313 <- vcsn20170313[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20170313) # rain range 0-170ish

portfoliosClaimsVcsnNl17AllPrecip0307 <- merge(portfoliosClaimsVcsnNl17, vcsn20170307, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip0307)[34] <- c("rain0307")
portfoliosClaimsVcsnNl17AllPrecip030708 <- merge(portfoliosClaimsVcsnNl17AllPrecip0307, vcsn20170308, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip030708)[35] <- c("rain0308")
portfoliosClaimsVcsnNl17AllPrecip03070809 <- merge(portfoliosClaimsVcsnNl17AllPrecip030708, vcsn20170309, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl17AllPrecip03070809)[36] <- c("rain0309")
rm(portfoliosClaimsVcsnNl17AllPrecip0307, portfoliosClaimsVcsnNl17AllPrecip030708)

# check it is what you think it is...
#portfoliosClaimsVcsnNl15AllPrecip0620$correctLossDate <- 0
#portfoliosClaimsVcsnNl15AllPrecip0620test <- filter(portfoliosClaimsVcsnNl15AllPrecip0620, claimed==1)
#portfoliosClaimsVcsnNl15$correctLossDate <- ifelse(lossDate == "2015-06-20", 0, 1)

linearMod1 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl17AllPrecip03070809)  # build linear regression model on full data
summary(linearMod1)

linearMod2 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl17AllPrecip03070809)  # build linear regression model on full data
summary(linearMod2)

# Print latex tables: regression then summary statistics of data: 
#stargazer(linearMod1, linearMod2, title="Results - spec 1&2")
#stargazer(portfoliosClaimsVcsnNl17AllPrecip03070809)

portfoliosClaimsVcsnNl1711precipOver50 <- filter(portfoliosClaimsVcsnNl17AllPrecip03070809, rain0307 > 50 | rain0308 > 50 | rain0309 > 50)
portfoliosClaimsVcsnNl1711precipOver100 <- filter(portfoliosClaimsVcsnNl17AllPrecip03070809, rain0307 > 100 | rain0308 > 100 | rain0309 > 100)

linearMod3 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1711precipOver50)  # build linear regression model on full data
summary(linearMod3)

linearMod4 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1711precipOver50)  # build linear regression model on full data
summary(linearMod4)

# Print reg results: 
#stargazer(linearMod3, linearMod4, title="Results - spec 3&4")
#stargazer(portfoliosClaimsVcsnNl1711precipOver50)

linearMod5 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1711precipOver100)  # build linear regression model on full data
summary(linearMod5)

linearMod6 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1711precipOver100)  # build linear regression model on full data
summary(linearMod6)

#stargazer(linearMod5, linearMod6, title = "Results - spec 5&6")
#stargazer(portfoliosClaimsVcsnNl1711precipOver100)

stargazer(linearMod1, linearMod2, linearMod3, linearMod4, linearMod5, linearMod6, title= "Event 3")
stargazer(portfoliosClaimsVcsnNl17AllPrecip03070809, portfoliosClaimsVcsnNl1711precipOver50, portfoliosClaimsVcsnNl1711precipOver100)

library(ggplot2)
ggplot(data=vcsn201703) +
  geom_point(vcsn201703, 
           mapping = aes(
             x = vcsn201703$vcsnDay, 
             y = vcsn201703$rain)
  ) +
  labs(title = "Event Three - 2017-03", 
       y = "precipitation in mm/day",
       x = "date")
