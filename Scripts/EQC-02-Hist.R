library(tidyverse);
library(sf);
library(rvest);
library(htmltools);
library(lubridate);
library(devtools)
library(ggplot2)
library(tidyr)
library(haven)
library(stars)

# clean workspace 

rm(nl201505)
rm(nl201506)
rm(nl201507)
rm(nl201508)
rm(nl201610)
rm(nl201611)
rm(nl201612)
rm(nl201701)
rm(nl201702)
rm(nl201703)
rm(nl201704)
rm(nl201705)
# Left with claims, portfolios, vcsn, vcsnWide, mbStats
rm(mbStats)
rm(vcsnWide)

### Reduce datasets to only information needed for histograms 
# (claims post 2011, rain post 2011, only dates, locations and keys)

# Claims:
claims <- claims[,c("claimID", "portfolioID", "lossDate", "eventDate")]
claims <- filter(claims, lossDate > "2011-01-01")

# Properties:
portfolios <- portfolios[,c("portfolioID","vcsnLongitude", "vcsnLatitude")]
#names(portfolios)[2:3] <- c("vcsnLongitude", "vcsnLatitude")

# Merge the property info to the claims
claimPortfolio <- merge(portfolios, claims, by = "portfolioID", all.y = TRUE)

# tidy workspace: 
rm(portfolios)
rm(claims)

# Make annual to streamline joining process 
vscn11 <- filter(vcsn, vcsn$vcsnDay > "2010-12-31", vcsn$vcsnDay < "2012-01-01")
vcsn12 <- filter(vcsn, vcsn$vcsnDay > "2011-12-31", vcsn$vcsnDay < "2013-01-01")
vcsn13 <- filter(vcsn, vcsn$vcsnDay > "2012-12-31", vcsn$vcsnDay < "2014-01-01")
vcsn14 <- filter(vcsn, vcsn$vcsnDay > "2013-12-31", vcsn$vcsnDay < "2015-01-01")
vcsn15 <- filter(vcsn, vcsn$vcsnDay > "2014-12-31", vcsn$vcsnDay < "2016-01-01")
vcsn16 <- filter(vcsn, vcsn$vcsnDay > "2015-12-31", vcsn$vcsnDay < "2017-01-01")
vcsn17 <- filter(vcsn, vcsn$vcsnDay > "2016-12-31", vcsn$vcsnDay < "2018-01-01")
vcsn18 <- filter(vcsn, vcsn$vcsnDay > "2017-12-31", vcsn$vcsnDay < "2019-01-01")

claim11 <- filter(claimPortfolio, claimPortfolio$lossDate > "2010-12-01", claimPortfolio$lossDate < "2012-01-01")
claim12 <- filter(claimPortfolio, claimPortfolio$lossDate > "2011-12-01", claimPortfolio$lossDate < "2013-01-01")
claim13 <- filter(claimPortfolio, claimPortfolio$lossDate > "2012-12-01", claimPortfolio$lossDate < "2014-01-01")
claim14 <- filter(claimPortfolio, claimPortfolio$lossDate > "2013-12-01", claimPortfolio$lossDate < "2015-01-01")
claim15 <- filter(claimPortfolio, claimPortfolio$lossDate > "2014-12-01", claimPortfolio$lossDate < "2016-01-01")
claim16 <- filter(claimPortfolio, claimPortfolio$lossDate > "2015-12-01", claimPortfolio$lossDate < "2017-01-01")
claim17 <- filter(claimPortfolio, claimPortfolio$lossDate > "2016-12-01", claimPortfolio$lossDate < "2018-01-01")
claim18 <- filter(claimPortfolio, claimPortfolio$lossDate > "2017-12-01", claimPortfolio$lossDate < "2019-01-01")

## Attach the year's rain information to each claim 
merge12 <- merge(claim12, vcsn12, by = c("vcsnLongitude", "vcsnLatitude"))
merge13 <- merge(claim13, vcsn13, by = c("vcsnLongitude", "vcsnLatitude"))
merge14 <- merge(claim14, vcsn14, by = c("vcsnLongitude", "vcsnLatitude"))
merge15 <- merge(claim15, vcsn15, by = c("vcsnLongitude", "vcsnLatitude"))
merge16 <- merge(claim16, vcsn16, by = c("vcsnLongitude", "vcsnLatitude"))
merge17 <- merge(claim17, vcsn17, by = c("vcsnLongitude", "vcsnLatitude"))
merge18 <- merge(claim18, vcsn18, by = c("vcsnLongitude", "vcsnLatitude"))

### Add rainfall to claim info 
claimPortfolioSpatialVCS <- merge12
# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)
# keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)
merge12 <- claimPortfolioSpatialVCS

########

### 

claimPortfolioSpatialVCS <- merge13

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)

merge13 <- claimPortfolioSpatialVCS

### 

claimPortfolioSpatialVCS <- merge14

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)
# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)

merge14 <- claimPortfolioSpatialVCS

### 

claimPortfolioSpatialVCS <- merge15

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)

merge15 <- claimPortfolioSpatialVCS

###

claimPortfolioSpatialVCS <- merge16

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)

merge16 <- claimPortfolioSpatialVCS

###

claimPortfolioSpatialVCS <- merge17

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)

merge17 <- claimPortfolioSpatialVCS

###

claimPortfolioSpatialVCS <- merge18

# Add "offset" - days from loss date 
claimPortfolioSpatialVCS <- mutate(claimPortfolioSpatialVCS, 
                                   lossDate-vcsnDay)
names(claimPortfolioSpatialVCS)[11] <- c("offsetRaw")
claimPortfolioSpatialVCS$offset <- as.double(claimPortfolioSpatialVCS$offsetRaw)

# Keep only claims from 1999 or 2000 
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate >= "2000-01-01")
# claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, lossDate <= "2004-12-01")

# Keep if offset is fewer than 10 or greater than -10 
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw < 11)
claimPortfolioSpatialVCS <- filter(claimPortfolioSpatialVCS, offsetRaw > -11)

merge18 <- claimPortfolioSpatialVCS

### append 

claimPortfolioVcsnOffset <- rbind(merge12, merge13)
claimPortfolioVcsnOffset <- rbind(claimPortfolioVcsnOffset, merge14)
claimPortfolioVcsnOffset <- rbind(claimPortfolioVcsnOffset, merge15)
claimPortfolioVcsnOffset <- rbind(claimPortfolioVcsnOffset, merge16)
claimPortfolioVcsnOffset <- rbind(claimPortfolioVcsnOffset, merge17)
claimPortfolioVcsnOffset <- rbind(claimPortfolioVcsnOffset, merge18)

# Plots: 

p <- ggplot(claimPortfolioVcsnOffset, aes(offset, rain)) 

#p + geom_boxplot(aes(group=offset))
#p + geom_boxplot(aes(group=offset)) + coord_flip()
p + geom_boxplot(aes(group=offset), 
                 fill = "lightblue", 
                 colour = "lightblue4", 
                 outlier.shape = NA) + 
  xlab("days from properties' Loss Date") + 
  ylab("daily rainfall at VCSN nearest property") + 
  theme_minimal() + 
  coord_cartesian(ylim = c(0, 175), 
                  expand = TRUE, 
                  default = FALSE, 
                  clip = "on")



#ggplot(data=claimPortfolioVcsnOffset) +
#  geom_point(claimPortfolioVcsnOffset, 
#           mapping = aes(
#             x = offset, 
#             y = rain
#           )
#  )

#ggplot(data=claimPortfolioVcsnOffset) +
#  geom_histogram(claimPortfolioVcsnOffset, 
#             mapping = aes(
#               x = rain
#             )
#  )

#ggplot(data=claimPortfolioVcsnOffset) +
#  geom_col(claimPortfolioVcsnOffset, 
#           mapping = aes(
#             x = offset, 
#             y = rain
#           )
#  )

#ggplot(claimPortfolioVcsnOffset, aes(offset, rain)) +
 # geom_col()

#ggplot(claimPortfolioVcsnOffset, aes(offset, rain)) +
 # geom_point()

