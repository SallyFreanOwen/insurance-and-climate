#############

library(stargazer)
library(tidyverse)

load("~/insurance-and-climate/Data/EQC-event1-full-processed.RData")
load("~/insurance-and-climate/Data/EQC-event2-full-processed.RData")
load("~/insurance-and-climate/Data/EQC-event3-full-processed.RData")

# simplifying naming 
eventOneFull <- portfoliosClaimsVcsnNl15AllPrecip06181920
rm(portfoliosClaimsVcsnNl15AllPrecip06181920)
eventTwoFull <- portfoliosClaimsVcsnNl16AllPrecip11141516
rm(portfoliosClaimsVcsnNl16AllPrecip11141516)
eventThreeFull<- portfoliosClaimsVcsnNl17AllPrecip03070809
rm(portfoliosClaimsVcsnNl17AllPrecip03070809)

##############################################################

####### Event one working 

eventOneFull$medHHIncome <- eventOneFull$medianHHIncome/1000
eventOneFull$dRiver <- eventOneFull$distRiver/1000
eventOneFull$dCoast <- eventOneFull$distCoast/1000
eventOneFull$dLake <- eventOneFull$distLake/1000

eventOneFull <- select(eventOneFull, -medianHHIncome, -distRiver, -distCoast, -distLake)

eventOneFull <- filter(eventOneFull, 
                       nldif10 != "NA" & 
                         approved != "NA" & 
                         slope != "NA" & 
                         dRiver != "NA" & 
                         dLake != "NA" & 
                         dCoast != "NA" & 
                         medHHIncome != "NA" & 
                         propDwellingNotOwned != "NA"
                       )

# Summary statistics 
#eventOnePrecipOver50 <- filter(eventOneFull, rain0618 > 50 | rain0619 > 50 | rain0620 > 50)
#eventOnePrecipOver100 <- filter(eventOneFull, rain0618 > 100 | rain0619 > 100 | rain0620 > 100)
#eventOnePrecipOver150 <- filter(eventOneFull, rain0618 > 150 | rain0619 > 150 | rain0620 > 150)

# Statistics - first table: 
eventOneFull$rain50mm <- ifelse((eventOneFull$rain0618>50 | eventOneFull$rain0619>50 | eventOneFull$rain0620>50),1,0)
eventOneFull$rain100mm <- ifelse((eventOneFull$rain0618>100 | eventOneFull$rain0619>100 | eventOneFull$rain0620>100),1,0)
eventOneFull$rain150mm <- ifelse((eventOneFull$rain0618>150 | eventOneFull$rain0619>150 | eventOneFull$rain0620>150),1,0)

eventOneFull$rain50Claimed <- ifelse((eventOneFull$rain50mm == 1 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$rain50NotClaimed <- ifelse((eventOneFull$rain50mm == 1 & eventOneFull$claimed == 0), 1, 0)
eventOneFull$nRain50Claimed <- ifelse((eventOneFull$rain50mm == 0 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$nRain50NotClaimed <- ifelse((eventOneFull$rain50mm == 0 & eventOneFull$claimed == 0), 1, 0)

eventOneFull$rain100Claimed <- ifelse((eventOneFull$rain100mm == 1 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$rain100NotClaimed <- ifelse((eventOneFull$rain100mm == 1 & eventOneFull$claimed == 0), 1, 0)
eventOneFull$nRain100Claimed <- ifelse((eventOneFull$rain100mm == 0 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$nRain100NotClaimed <- ifelse((eventOneFull$rain100mm == 0 & eventOneFull$claimed == 0), 1, 0)

eventOneFull$rain150Claimed <- ifelse((eventOneFull$rain150mm == 1 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$rain150NotClaimed <- ifelse((eventOneFull$rain150mm == 1 & eventOneFull$claimed == 0), 1, 0)
eventOneFull$nRain150Claimed <- ifelse((eventOneFull$rain150mm == 0 & eventOneFull$claimed == 1), 1, 0)
eventOneFull$nRain150NotClaimed <- ifelse((eventOneFull$rain150mm == 0 & eventOneFull$claimed == 0), 1, 0)

nrow(eventOneFull[eventOneFull$rain50Claimed == 1,])
nrow(eventOneFull[eventOneFull$rain50NotClaimed == 1,])
nrow(eventOneFull[eventOneFull$nRain50Claimed == 1,])
nrow(eventOneFull[eventOneFull$nRain50NotClaimed == 1,])

nrow(eventOneFull[eventOneFull$rain100Claimed == 1,])
nrow(eventOneFull[eventOneFull$rain100NotClaimed == 1,])
nrow(eventOneFull[eventOneFull$nRain100Claimed == 1,])
nrow(eventOneFull[eventOneFull$nRain100NotClaimed == 1,])

nrow(eventOneFull[eventOneFull$rain100Claimed == 1,])
nrow(eventOneFull[eventOneFull$rain100NotClaimed == 1,])
nrow(eventOneFull[eventOneFull$nRain100Claimed == 1,])
nrow(eventOneFull[eventOneFull$nRain100NotClaimed == 1,])

eventOneFull <- filter(eventOneFull, rain50Claimed == 1 | rain50NotClaimed == 1)

#### Event One Regressions 

linearModOne50a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                      data=eventOneFull, subset = (rain50mm==1)) 
summary(linearModOne50a)

linearModOne50b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                      data=eventOneFull, subset=(rain0618 > 50 | rain0619 > 50 | rain0620 > 50)) 
summary(linearModOne50b)

linearModOne50c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                      data=eventOneFull, subset=(rain0618 > 50 | rain0619 > 50 | rain0620 > 50)) 
summary(linearModOne50c)

linearModOne100a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventOneFull, subset=(rain0618 > 100 | rain0619 > 100 | rain0620 > 100)) 
summary(linearModOne100a)

linearModOne100b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventOneFull, subset=(rain0618 > 100 | rain0619 > 100 | rain0620 > 100)) 
summary(linearModOne100b)

linearModOne100c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventOneFull, subset=(rain0618 > 100 | rain0619 > 100 | rain0620 > 100)) 
summary(linearModOne100c)

linearModOne150a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventOneFull, subset=(rain0618 > 150 | rain0619 > 150 | rain0620 > 150)) 
summary(linearModOne150a)

linearModOne150b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventOneFull, subset=(rain0618 > 150 | rain0619 > 150 | rain0620 > 150)) 
summary(linearModOne150b)

linearModOne150c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventOneFull, subset=(rain0618 > 150 | rain0619 > 150 | rain0620 > 150)) 
summary(linearModOne150c)

##############################################################

##### Event Two working 

eventTwoFull$medHHIncome <- eventTwoFull$medianHHIncome/1000
eventTwoFull$dRiver <- eventTwoFull$distRiver/1000
eventTwoFull$dCoast <- eventTwoFull$distCoast/1000
eventTwoFull$dLake <- eventTwoFull$distLake/1000

eventTwoFull <- select(eventTwoFull, -medianHHIncome, -distRiver, -distCoast, -distLake)

eventTwoFull <- filter(eventTwoFull, 
                       propDwellingNotOwned != "NA" 
                       & medHHIncome != "NA"
)

eventTwoPrecipOver50 <- filter(eventTwoFull, rain1114 > 50 | rain1115 > 50 | rain1116 > 50)
eventTwoPrecipOver100 <- filter(eventTwoFull, rain1114 > 100 | rain1115 > 100 | rain1116 > 50)

# Table 1 - Statistics 2: 
eventTwoFull$rain50mm <- ifelse((eventTwoFull$rain1114>50 | eventTwoFull$rain1115>50 | eventTwoFull$rain1116>50),1,0)
eventTwoFull$rain100mm <- ifelse((eventTwoFull$rain1114>100 | eventTwoFull$rain1115>100 | eventTwoFull$rain1116>100),1,0)

eventTwoFull$rainClaimed <- ifelse((eventTwoFull$rain50mm == 1 & eventTwoFull$claimed == 1), 1, 0)
eventTwoFull$rainNotClaimed <- ifelse((eventTwoFull$rain50mm == 1 & eventTwoFull$claimed == 0), 1, 0)
eventTwoFull$nRainClaimed <- ifelse((eventTwoFull$rain50mm == 0 & eventTwoFull$claimed == 1), 1, 0)
eventTwoFull$nRainNotClaimed <- ifelse((eventTwoFull$rain50mm == 0 & eventTwoFull$claimed == 0), 1, 0)

#eventTwoFull$rainClaimed <- ifelse((eventTwoFull$rain100mm == 1 & eventTwoFull$claimed == 1), 1, 0)
#eventTwoFull$rainNotClaimed <- ifelse((eventTwoFull$rain100mm == 1 & eventTwoFull$claimed == 0), 1, 0)
#eventTwoFull$nRainClaimed <- ifelse((eventTwoFull$rain100mm == 0 & eventTwoFull$claimed == 1), 1, 0)
#eventTwoFull$nRainNotClaimed <- ifelse((eventTwoFull$rain100mm == 0 & eventTwoFull$claimed == 0), 1, 0)

nrow(eventTwoFull[eventTwoFull$rainClaimed == 1,])
nrow(eventTwoFull[eventTwoFull$rainNotClaimed == 1,])
nrow(eventTwoFull[eventTwoFull$nRainClaimed == 1,])
nrow(eventTwoFull[eventTwoFull$nRainNotClaimed == 1,])

##### Event Two regressions 

linearModTwo50a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                      data=eventTwoFull, subset=(rain1114 > 50 | rain1115 > 50 | rain1116 > 50)) 
summary(linearModTwo50a)

linearModTwo50b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                      data=eventTwoFull, subset=(rain1114 > 50 | rain1115 > 50 | rain1116 > 50)) 
summary(linearModTwo50b)

linearModTwo50c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                      data=eventTwoFull, subset=(rain1114 > 50 | rain1115 > 50 | rain1116 > 50) ) 
summary(linearModTwo50c)

linearModTwo100a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventTwoFull, subset=(rain1114 > 100 | rain1115 > 100 | rain1116 > 100)) 
summary(linearModTwo100a)

linearModTwo100b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventTwoFull, subset=(rain1114 > 100 | rain1115 > 100 | rain1116 > 100)) 
summary(linearModTwo100b)

linearModTwo100c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                       data=eventTwoFull, subset=(rain1114 > 100 | rain1115 > 100 | rain1116 > 100)) 
summary(linearModTwo100c)

##############################################################



###### Event Three Working 

eventThreeFull$medHHIncome <- eventThreeFull$medianHHIncome/1000
eventThreeFull$dRiver <- eventThreeFull$distRiver/1000
eventThreeFull$dCoast <- eventThreeFull$distCoast/1000
eventThreeFull$dLake <- eventThreeFull$distLake/1000

eventThreeFull <- select(eventThreeFull, -medianHHIncome, -distRiver, -distCoast, -distLake)

eventThreeFull <- filter(eventThreeFull, 
                         propDwellingNotOwned != "NA" 
                         & medHHIncome != "NA"
)

#eventThreePrecipOver50 <- filter(eventThreeFull, rain0307 > 50 | rain0308 > 50 | rain0309 > 50)
#eventThreePrecipOver100 <- filter(eventThreeFull, rain0307 > 100 | rain0308 > 100 | rain0309 > 50)

# Table 1 - Statistics 2: 
eventThreeFull$rain50mm <- ifelse((eventThreeFull$rain0307>50 | eventThreeFull$rain0308>50 | eventThreeFull$rain0309>50),1,0)
eventThreeFull$rain100mm <- ifelse((eventThreeFull$rain0307>100 | eventThreeFull$rain0308>100 | eventThreeFull$rain0309>100),1,0)

eventThreeFull$rainClaimed <- ifelse((eventThreeFull$rain50mm == 1 & eventThreeFull$claimed == 1), 1, 0)
eventThreeFull$rainNotClaimed <- ifelse((eventThreeFull$rain50mm == 1 & eventThreeFull$claimed == 0), 1, 0)
eventThreeFull$nRainClaimed <- ifelse((eventThreeFull$rain50mm == 0 & eventThreeFull$claimed == 1), 1, 0)
eventThreeFull$nRainNotClaimed <- ifelse((eventThreeFull$rain50mm == 0 & eventThreeFull$claimed == 0), 1, 0)

nrow(eventThreeFull[eventThreeFull$rainClaimed == 1,])
nrow(eventThreeFull[eventThreeFull$rainNotClaimed == 1,])
nrow(eventThreeFull[eventThreeFull$nRainClaimed == 1,])
nrow(eventThreeFull[eventThreeFull$nRainNotClaimed == 1,])

#### Event Three Regressions 

linearModThree50a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                        data=eventThreeFull, subset=(rain0307 > 50 | rain0308 > 50 | rain0309 > 50)) 
summary(linearModThree50a)

linearModThree50b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                        data=eventThreeFull, subset=(rain0307 > 50 | rain0308 > 50 | rain0309 > 50)) 
summary(linearModThree50b)

linearModThree50c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                        data=eventThreeFull, subset=(rain0307 > 50 | rain0308 > 50 | rain0309 > 50)) 
summary(linearModThree50c)

linearModThree100a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                         data=eventThreeFull, subset=(rain0307 > 100 | rain0308 > 100 | rain0309 > 100)) 
summary(linearModThree100a)

linearModThree100b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                         data=eventThreeFull, subset=(rain0307 > 100 | rain0308 > 100 | rain0309 > 100)) 
summary(linearModThree100b)

linearModThree100c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                         data=eventThreeFull, subset=(rain0307 > 100 | rain0308 > 100 | rain0309 > 100)) 
summary(linearModThree100c)

linearModThree150a <- lm(nldif31 ~ nldif10 + claimed + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                         data=eventThreeFull, subset=(rain0307 > 150 | rain0308 > 150 | rain0309 > 150)) 
summary(linearModThree150a)

linearModThree150b <- lm(nldif31 ~ nldif10 + approved + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                         data=eventThreeFull, subset=(rain0307 > 150 | rain0308 > 150 | rain0309 > 150)) 
summary(linearModThree150b)

linearModThree150c <- lm(nldif31 ~ nldif10 + closedIn90days + slope + dRiver + dLake + dCoast + medHHIncome + propDwellingNotOwned, 
                         data=eventThreeFull, subset=(rain0307 > 150 | rain0308 > 150 | rain0309 > 150)) 
summary(linearModThree150c)

###############################


stargazer(linearModOne50a, linearModOne50b, linearModOne50c, title="Results - event One 50mm threshold")
stargazer(linearModOne100a, linearModOne100b, linearModOne100c, title = "Results - event one 100mm threshold", star.char = c("*", "**", "***"), star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
stargazer(linearModOne150a, linearModOne150b, linearModOne150c, title = "Results - event one 150mm threshold", star.char = c("*", "**", "***"), star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
#stargazer(linearModOne200a, linearModOne200b, linearModOne200c, title = "Results - event one 200mm threshold", star.char = c("*", "**", "***"), star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)

stargazer(linearModTwo50a, linearModTwo50b, linearModTwo50c, title="Results - event two 50mm threshold")
stargazer(linearModTwo100a, linearModTwo100b, linearModTwo100c, title = "Results - event two 100mm threshold", star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
#stargazer(linearModTwo150a, linearModTwo150b, linearModTwo150c, title = "Results - event two 150mm threshold", star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
#stargazer(linearModTwo200a, linearModTwo200b, linearModTwo200c, title = "Results - event two 200mm threshold", star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)

stargazer(linearModThree50a, linearModThree50b, linearModThree50c, title="Results - event Three 50mm threshold")
stargazer(linearModThree100a, linearModThree100b, linearModThree100c, title = "Results - event three 100mm threshold", star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
stargazer(linearModThree150a, linearModThree150b, linearModThree150c, title = "Results - event three 150mm threshold", star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
#stargazer(linearModThree200a, linearModThree200b, linearModThree200c, title = "Results - event three 200mm threshold", star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)

stargazer(linearModOne50a, linearModOne50b, linearModOne50c, linearModOne100a, linearModOne100b, linearModOne100c, linearModOne150a, linearModOne150b, linearModOne150c, star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
stargazer(linearModTwo50a, linearModTwo50b, linearModTwo50c, linearModTwo100a, linearModTwo100b, linearModTwo100c, star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)
stargazer(linearModThree50a, linearModThree50b, linearModThree50c, linearModThree100a, linearModThree100b, linearModThree100c, linearModThree150a, linearModThree150b, linearModThree150c, star.cutoffs = c(0.05, 0.01, 0.001), notes = c("$*=p<0.05; **=p<0.01; ***=p<0.001$"), notes.append = F)

############









eventThreePrecipOver50 <- filter(eventThreeFull, (rain0307 > 50 | rain0308 > 50 | rain0309 > 50))
eventThreePrecipOver100 <- filter(eventThreeFull, (rain0307 > 100 | rain0308 > 100 | rain0309 > 100))
eventThreePrecipOver150 <- filter(eventThreeFull, (rain0307 > 150 | rain0308 > 150 | rain0309 > 150))

# Statistics 3: 

########### in summary ...

stargazer(eventOnePrecipOver50, eventOnePrecipOver100, eventOnePrecipOver150, summary.stat = c("n", "mean", "median", "sd"))
stargazer(eventTwoPrecipOver50, eventTwoPrecipOver100, summary.stat = c("n", "mean", "median", "min", "max"))
stargazer(eventThreePrecipOver50, eventThreePrecipOver100, eventThreePrecipOver150, summary.stat = c("n", "mean", "median", "min", "max"))

stargazer(eventOneFull)
stargazer(eventTwoFull)
stargazer(eventThreeFull)
