library(pastecs)
options(digits=3)

##############

portfolios <- portfolios[,c("portfolioID",
                            "mLandValueWithin8m", "mDwellingValue",
                            "slope", "distRiver", "distLake", "distCoast",
                            "nlLongitude", "nlLatitude",
                            "vcsnLongitude", "vcsnLatitude")
                         ]

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
                                "eventMonth","eventYear")]

# generate # months to payment:
claims201506$buildingTimeToPayment <- claims201506$buildingClaimCloseDate - claims201506$lossDate

claims201506 <- mutate(claims201506, claims201506$lossDate+1)
claims201506 <- mutate(claims201506, claims201506$lossDate+2)
names(claims201506)[12:13] <- c("lossDatePlusOne", "lossDatePlusTwo")

portfoliosClaims15 <- merge(portfolios, claims201506, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn15 <- merge(portfoliosClaims15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[24] <- "rain1"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[25] <- "rain2"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn201506[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[26] <- "rain3"

# NL work... 

nl201505df = as.data.frame(nl201505)
nl201506df = as.data.frame(nl201506)
nl201507df = as.data.frame(nl201507)
nl201508df = as.data.frame(nl201508)
rm(nl201505)
rm(nl201506)
rm(nl201507)
rm(nl201508)

# attach NL information to all properties 
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsn15, nl201505df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[27] <- "nl0"

portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201506df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[28] <- "nl1"
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201507df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[29] <- "nl2"
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201508df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[30] <- "nl3"

# check it is what you think it is...
names(portfoliosClaimsVcsnNl15)
portfoliosClaimsVcsnNl15$claimed <- 0
portfoliosClaimsVcsnNl15$claimed <- ifelse(is.na(portfoliosClaimsVcsnNl15$claimID),0,1)

# clear workspace 
rm(nl201505df)
rm(nl201506df)
rm(nl201507df)
rm(nl201508df)

rm(nl201611)
rm(nl201612)
rm(nl201701)

rm(nl201703)
rm(nl201704)
rm(nl201705)

rm(nl201506df)
rm(nl201507df)
rm(nl201508df)

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
portfoliosClaimsVcsnNl15 <- mutate(portfoliosClaimsVcsnNl15, nl3-nl1)
names(portfoliosClaimsVcsnNl15)[32] <- c("nldif31")

portfoliosClaimsVcsnNl15 <- mutate(portfoliosClaimsVcsnNl15, nl1-nl0)
names(portfoliosClaimsVcsnNl15)[33] <- c("nldif10")

#library(pastecs)
#options(digits=3)
#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)
#scatter.smooth(x=portfoliosClaimsVcsnNl15$claimed, y=portfoliosClaimsVcsnNl15$nldif0807)

### Attaching alternate precip 
plot(x = claims201506$lossDate, y= claims201506$buildingPaid)
plot(x = claims201506$lossDate, y= claims201506$landPaid)

#Looks like we want LossDate/vcsnDay= 18th June or the next few days 

vcsn20150618 <- filter(vcsn, vcsnDay=="2015-06-18")
vcsn20150618 <- vcsn20150618[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20150618)
vcsn20150619 <- filter(vcsn, vcsnDay=="2015-06-19")
vcsn20150619 <- vcsn20150619[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20150619)
vcsn20150620 <- filter(vcsn, vcsnDay=="2015-06-20")
vcsn20150620 <- vcsn20150620[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20150620)
#vcsn20150621 <- filter(vcsn, vcsnDay=="2015-06-21")
#vcsn20150621 <- vcsn20150621[,c("vcsnLongitude", "vcsnLatitude", "rain")]
#vcsn20150622 <- filter(vcsn, vcsnDay=="2015-06-22")
#vcsn20150622 <- vcsn20150622[,c("vcsnLongitude", "vcsnLatitude", "rain")]

portfoliosClaimsVcsnNl15AllPrecip0618 <- merge(portfoliosClaimsVcsnNl15, vcsn20150618, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip0618)[34] <- c("rain0618")
portfoliosClaimsVcsnNl15AllPrecip061819 <- merge(portfoliosClaimsVcsnNl15AllPrecip0618, vcsn20150619, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip061819)[35] <- c("rain0619")
portfoliosClaimsVcsnNl15AllPrecip06181920 <- merge(portfoliosClaimsVcsnNl15AllPrecip061819, vcsn20150620, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip06181920)[36] <- c("rain0620")

# check it is what you think it is...
#portfoliosClaimsVcsnNl15AllPrecip0620$correctLossDate <- 0
#portfoliosClaimsVcsnNl15AllPrecip0620test <- filter(portfoliosClaimsVcsnNl15AllPrecip0620, claimed==1)
#portfoliosClaimsVcsnNl15$correctLossDate <- ifelse(lossDate == "2015-06-20", 0, 1)

linearMod1 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl15)  # build linear regression model on full data
summary(linearMod1)

linearMod2 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl15)  # build linear regression model on full data
summary(linearMod2)

stargazer(linearMod1, linearMod2, title="Results - spec 1&2")
stargazer(portfoliosClaimsVcsnNl15AllPrecip0618)

portfoliosClaimsVcsnNl1506precipOver50 <- filter(portfoliosClaimsVcsnNl15AllPrecip06181920, rain0618 > 50 | rain0619 > 50 | rain0620 > 50 )
portfoliosClaimsVcsnNl1506precipOver100 <- filter(portfoliosClaimsVcsnNl15AllPrecip06181920, rain0618 > 100 | rain0619 > 100 | rain0620 > 100 )

linearMod3 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver50)  # build linear regression model on full data
summary(linearMod3)

linearMod4 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver50)  # build linear regression model on full data
summary(linearMod4)

stargazer(linearMod3, linearMod4, title="Results - spec 3&4")
stargazer(portfoliosClaimsVcsnNl1506precipOver50)


linearMod5 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver100)  # build linear regression model on full data
summary(linearMod5)

linearMod6 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver100)  # build linear regression model on full data
summary(linearMod6)

stargazer(linearMod5, linearMod6, title = "Results - spec 5&6")
stargazer(portfoliosClaimsVcsnNl1506precipOver100)

stargazer(linearMod1, linearMod2, linearMod3, linearMod4, linearMod5, linearMod6, title= "Event 1")
stargazer(portfoliosClaimsVcsnNl15AllPrecip06181920, portfoliosClaimsVcsnNl1506precipOver50, portfoliosClaimsVcsnNl1506precipOver100)

# to do: add map image of claimed upon properties 
ggplot(data=vcsn201506) +
  geom_point(vcsn201506, 
             mapping = aes(
               x = vcsn201506$vcsnDay, 
               y = vcsn201506$rain)
  ) +
  labs(title = "Event One - 2015-06", 
       y = "precipitation in mm/day",
       x = "date"
)
