library(pastecs)
options(digits=3)

##############

# Event 2 - 11/2016
# to do: add map image of claimed upon properties 

# Subset claim and rain info
vcsn201610201701 <- filter(vcsn, 
                           (eventYear==2016 & 
                              (eventMonth == 10 | eventMonth == 11 | eventMonth == 12)) 
                           | (eventYear == 2017 & eventMonth == 1 )
                            )
claims201610201701 <- filter(claims,      
                             (eventYear==2016 & 
                                (eventMonth == 10 | eventMonth == 11 | eventMonth == 12)) 
                             | (eventYear == 2017 & eventMonth == 1 )
                            )

vcsn201611 <- filter(vcsn, eventYear==2016 & eventMonth == 11) 
claims201611 <- filter(claims, eventYear==2016 & eventMonth == 11)
## Drop eventYear and eventMonth columns ... 

## Eyeball : 

claims201611 <- mutate(claims201611, claims201611$lossDate+1)
claims201611 <- mutate(claims201611, claims201611$lossDate+2)

names(claims201611)[54:55] <- c("lossDatePlusOne", "lossDatePlusTwo")

#### 

plot(x = vcsn201610201701$vcsnDay, y = vcsn201610201701$rain)
plot(x = claims201610201701$lossDate, y = claims201610201701$landPaid)
plot(x = claims201610201701$lossDate, y = claims201610201701$buildingPaid)

# Attach to all portfolio data: 
portfoliosClaims16 <- merge(portfolios, claims201611, by = "portfolioID", all.x = TRUE)

# attach to claimed upon properties:
portfoliosClaimsVcsn16 <- merge(portfoliosClaims16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDate"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[75] <- "rain1"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusOne"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[76] <- "rain2"
portfoliosClaimsVcsn16 <- merge(portfoliosClaimsVcsn16, vcsn201611[,c("vcsnLongitude","vcsnLatitude","vcsnDay","rain")], by.x = c("vcsnLongitude", "vcsnLatitude", "lossDatePlusTwo"), by.y = c("vcsnLongitude","vcsnLatitude","vcsnDay"), all.x = TRUE)
names(portfoliosClaimsVcsn16)[77] <- "rain3"

# NL work... 

nl201610df = as.data.frame(nl201610)
nl201611df = as.data.frame(nl201611)
nl201612df = as.data.frame(nl201612)
nl201701df = as.data.frame(nl201701)
rm(nl201610)
rm(nl201611)
rm(nl201612)
rm(nl201701)

# attach NL information to all properties 
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsn16, nl201610df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[78] <- "nl0"

portfoliosClaimsVcsnNl16 <- as.data.frame(portfoliosClaimsVcsnNl16[1:78])

portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201611df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[79] <- "nl1"
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201612df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[80] <- "nl2"
portfoliosClaimsVcsnNl16 <- merge(portfoliosClaimsVcsnNl16, nl201701df, by.x = c("nlLongitude","nlLatitude"), by.y = c("x","y"), all.x = TRUE)
names(portfoliosClaimsVcsnNl16)[81] <- "nl3"

# check it is what you think it is...
names(portfoliosClaimsVcsnNl16)[82] <- c("claimed")
portfoliosClaimsVcsnNl16$claimed <- 0
portfoliosClaimsVcsnNl16$claimed <- ifelse(is.na(portfoliosClaimsVcsnNl16$claimID),0,1)

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
portfoliosClaimsVcsnNl16 <- mutate(portfoliosClaimsVcsnNl16, nl3-nl1)
names(portfoliosClaimsVcsnNl16)[83] <- c("nldif31")

portfoliosClaimsVcsnNl16 <- mutate(portfoliosClaimsVcsnNl16, nl1-nl0)
names(portfoliosClaimsVcsnNl16)[84] <- c("nldif10")

#library(pastecs)
#options(digits=3)
#stat.desc(portfoliosClaimsVcsnNl15[,sapply(portfoliosClaimsVcsnNl15,is.numeric)], basic=T)
#scatter.smooth(x=portfoliosClaimsVcsnNl15$claimed, y=portfoliosClaimsVcsnNl15$nldif0807)


########### UP TO HERE 


linearMod <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl16)  # build linear regression model on full data
summary(linearMod)

stargazer(linearMod)

### Attaching alternate precip 
plot(x=claims201611$lossDate, y=claims201611$buildingPaid)
plot(x=claims201611$lossDate, y=claims201611$landPaid)

#Looks like we want LossDate/vcsnDay = 14 November or the next few days 

vcsn20161114 <- filter(vcsn, vcsnDay=="2016-11-14")
vcsn20161114 <- vcsn20161114[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20161114) # rain range 0-200
vcsn20161115 <- filter(vcsn, vcsnDay=="2016-11-15")
vcsn20161115 <- vcsn20161115[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20161115)# rain range 0-200
vcsn20161116 <- filter(vcsn, vcsnDay=="2016-11-16")
vcsn20161116 <- vcsn20161116[,c("vcsnLongitude", "vcsnLatitude", "rain")]
plot(vcsn20161116) # drops to 0-80 

portfoliosClaimsVcsnNl16AllPrecip1114 <- merge(portfoliosClaimsVcsnNl16, vcsn20161114, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip1114)[85] <- c("rain1114")
portfoliosClaimsVcsnNl16AllPrecip111415 <- merge(portfoliosClaimsVcsnNl16AllPrecip1114, vcsn20161115, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfoliosClaimsVcsnNl16AllPrecip111415)[86] <- c("rain1115")

# check it is what you think it is...
#portfoliosClaimsVcsnNl15AllPrecip0620$correctLossDate <- 0
#portfoliosClaimsVcsnNl15AllPrecip0620test <- filter(portfoliosClaimsVcsnNl15AllPrecip0620, claimed==1)
#portfoliosClaimsVcsnNl15$correctLossDate <- ifelse(lossDate == "2015-06-20", 0, 1)

linearMod1 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl16AllPrecip111415)  # build linear regression model on full data
summary(linearMod1)

linearMod2 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl16AllPrecip111415)  # build linear regression model on full data
summary(linearMod2)

# Print latex tables: regression then summary statistics of data: 
stargazer(linearMod1, linearMod2, title="Results - spec 1&2")
stargazer(portfoliosClaimsVcsnNl16AllPrecip111415)

portfoliosClaimsVcsnNl1611precipOver50 <- filter(portfoliosClaimsVcsnNl16AllPrecip111415, rain1114 > 50 | rain1115 > 50)
portfoliosClaimsVcsnNl1611precipOver100 <- filter(portfoliosClaimsVcsnNl16AllPrecip111415, rain1114 > 100 | rain1115 > 100)

linearMod3 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver50)  # build linear regression model on full data
summary(linearMod3)

linearMod4 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver50)  # build linear regression model on full data
summary(linearMod4)

# Print reg results: 
stargazer(linearMod3, linearMod4, title="Results - spec 3&4")
stargazer(portfoliosClaimsVcsnNl1611precipOver50)

linearMod5 <- lm(nldif31 ~ claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver100)  # build linear regression model on full data
summary(linearMod5)

linearMod6 <- lm(nldif31 ~ nldif10 + claimed + slope + distRiver + distLake + distCoast, data=portfoliosClaimsVcsnNl1611precipOver100)  # build linear regression model on full data
summary(linearMod6)

stargazer(linearMod5, linearMod6, title = "Results - spec 5&6")
stargazer(portfoliosClaimsVcsnNl1611precipOver100)

stargazer(linearMod1, linearMod2, linearMod3, linearMod4, linearMod5, linearMod6, title= "Event 2")
stargazer(portfoliosClaimsVcsnNl16AllPrecip111415, portfoliosClaimsVcsnNl1611precipOver50, portfoliosClaimsVcsnNl1611precipOver100)

library(ggplot2)
ggplot(data=vcsn201611) +
  geom_point(vcsn201611, 
             mapping = aes(
               x = vcsn201611$vcsnDay, 
               y = vcsn201611$rain)
  ) +
  labs(title = "Event Two - 2016-11", 
       y = "precipitation in mm/day",
       x = "date")
