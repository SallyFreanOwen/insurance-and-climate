claimPortfolioVcsnNL2015Tidier <- read.csv("claimPortfolioVcsnNL2015Tidier.csv", stringsAsFactors = FALSE)

portfoliosMB <- merge(portfolios, portfolioMB, by.x = "portfolioID", by.y="portfolioi")
claimPortfolioMB <- merge(claims, portfoliosMB, by= "portfolioID", all=TRUE)
                          
claimPortfolioVcsnNL2015Tidier <- merge(claimPortfolioVcsnNL2015Tidier, claimPortfolioMB[,c("claimID","portfolioID","mb2013")], by=c("claimID", "portfolioID"))
                          
head(claimPortfolioVcsnNL2015Tidier)

claimPortfolioVcsnNL2015Tidier<- mutate(claimPortfolioVcsnNL2015Tidier,
                                        as.numeric(rain.y>100 | rain2.y>100 | rain3.y>100))
names(claimPortfolioVcsnNL2015Tidier)[26]<-c("extreme3")
claimPortfolioVcsnNL2015Tidier$extremeRain3 <-ifelse(claimPortfolioVcsnNL2015Tidier$extreme3==0,0,1)

head(claimPortfolioVcsnNL2015Tidier)
extreme3Only <- subset(claimPortfolioVcsnNL2015Tidier, claimPortfolioVcsnNL2015Tidier$extreme3 == "1")

extreme3Onlytest <- subset(extreme3Only, extreme3Only$eventYear == "2015")

linearMod <- lm(avg_rad_201508 ~ speed, data=extreme3Only)  # build linear regression model on full data
print(linearMod)