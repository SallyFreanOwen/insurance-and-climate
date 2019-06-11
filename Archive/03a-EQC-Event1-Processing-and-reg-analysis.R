
##############

# Event 1 - 06/2015
# to do: add map image of claimed upon properties 

# Subset claim and rain info
vcsn20150608 <- filter(vcsn, eventYear==2015 & eventMonth>05 & eventMonth<09) 
claims20150608 <- filter(claims, eventYear==2015 & eventMonth>05 & eventMonth<09) 

claims20150608 <- mutate(claims20150608, claims20150608$lossDate+1)
claims20150608 <- mutate(claims20150608, claims20150608$lossDate+2)
names(claims20150608)[54:55] <- c("lossDatePlusOne", "lossDatePlusTwo")

portfoliosClaims15 <- merge(portfolios, claims20150608, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn15 <- merge(portfoliosClaims15, vcsn20150608[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[73] <- "rain1"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn20150608[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[74] <- "rain2"
portfoliosClaimsVcsn15 <- merge(portfoliosClaimsVcsn15, vcsn20150608[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn15)[75] <- "rain3"

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
names(portfoliosClaimsVcsnNl15)[76] <- "nl0"

portfoliosClaimsVcsnNl15 <- as.data.frame(portfoliosClaimsVcsnNl15[1:76])

portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201506df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[77] <- "nl1"
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201507df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[78] <- "nl2"
portfoliosClaimsVcsnNl15 <- merge(portfoliosClaimsVcsnNl15, nl201508df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl15)[79] <- "nl3"

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

library(pastecs)
options(digits=3)
stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)

### Build correct variables for analysis:
portfoliosClaimsVcsnNl15 <- mutate(portfoliosClaimsVcsnNl15, nl3-nl0)
names(portfoliosClaimsVcsnNl15)[81] <- c("nldif03")

portfoliosClaimsVcsnNl15 <- mutate(portfoliosClaimsVcsnNl15, nl2-nl1)
names(portfoliosClaimsVcsnNl15)[82] <- c("nldif12")

#library(pastecs)
#options(digits=3)
#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)
#scatter.smooth(x=portfoliosClaimsVcsnNl15$claimed, y=portfoliosClaimsVcsnNl15$nldif0807)

linearMod <- lm(nldif03 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl15)  # build linear regression model on full data
summary(linearMod)

stargazer(linearMod)

### Attaching alternate precip 
plot(claims20150608$lossDate)

#Looks like we want LossDate/vcsnDay= 20th June or the next few days 

vcsn20150618 <- filter(vcsn, vcsnDay=="2015-06-18")
vcsn20150618 <- vcsn20150618[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20150618)
vcsn20150619 <- filter(vcsn, vcsnDay=="2015-06-19")
vcsn20150619 <- vcsn20150619[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20150619)
vcsn20150620 <- filter(vcsn, vcsnDay=="2015-06-20")
vcsn20150620 <- vcsn20150620[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20150620)
vcsn20150621 <- filter(vcsn, vcsnDay=="2015-06-21")
vcsn20150621 <- vcsn20150621[,c("vcsnLongitude", "vcsnLatitude", "rain")]
vcsn20150622 <- filter(vcsn, vcsnDay=="2015-06-22")
vcsn20150622 <- vcsn20150622[,c("vcsnLongitude", "vcsnLatitude", "rain")]

portfoliosClaimsVcsnNl15AllPrecip0618 <- merge(portfoliosClaimsVcsnNl15, vcsn20150618, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip0618)[83] <- c("rain0618")
portfoliosClaimsVcsnNl15AllPrecip061819 <- merge(portfoliosClaimsVcsnNl15AllPrecip0618, vcsn20150619, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip061819)[84] <- c("rain0619")
portfoliosClaimsVcsnNl15AllPrecip06181920 <- merge(portfoliosClaimsVcsnNl15AllPrecip061819, vcsn20150620, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl15AllPrecip06181920)[85] <- c("rain0620")

# check it is what you think it is...
#portfoliosClaimsVcsnNl15AllPrecip0620$correctLossDate <- 0
#portfoliosClaimsVcsnNl15AllPrecip0620test <- filter(portfoliosClaimsVcsnNl15AllPrecip0620, claimed==1)
#portfoliosClaimsVcsnNl15$correctLossDate <- ifelse(lossDate == "2015-06-20", 0, 1)

linearMod2 <- lm(nldif03 ~claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl15)  # build linear regression model on full data
summary(linearMod2)

linearMod3 <- lm(nldif03 ~ nldif12 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl15)  # build linear regression model on full data
summary(linearMod3)

stargazer(linearMod2, linearMod3, title="Results - spec 2&3")
stargazer(portfoliosClaimsVcsnNl15AllPrecip0618)

portfoliosClaimsVcsnNl1506precipOver50 <- filter(portfoliosClaimsVcsnNl15AllPrecip06181920, rain0618 > 50 | rain0619 > 50 | rain0620 > 50 )
portfoliosClaimsVcsnNl1506precipOver100 <- filter(portfoliosClaimsVcsnNl15AllPrecip06181920, rain0618 > 100 | rain0619 > 100 | rain0620 > 100 )

linearMod4 <- lm(nldif03 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver50)  # build linear regression model on full data
summary(linearMod4)

linearMod5 <- lm(nldif03 ~ nldif12 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver50)  # build linear regression model on full data
summary(linearMod5)

stargazer(linearMod4, linearMod5, title="Results - spec 4&5")
stargazer(portfoliosClaimsVcsnNl1506precipOver50)


linearMod6 <- lm(nldif03 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver100)  # build linear regression model on full data
summary(linearMod6)

linearMod7 <- lm(nldif03 ~ nldif12 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1506precipOver100)  # build linear regression model on full data
summary(linearMod7)

stargazer(linearMod6, linearMod7, title = "Results - spec 6&7")
stargazer(portfoliosClaimsVcsnNl1506precipOver100)
