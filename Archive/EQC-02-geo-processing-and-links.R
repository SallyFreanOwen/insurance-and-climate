# This file is the most important so far...

library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(SearchTrees)
library(devtools)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(haven)
library(stars)

#claims_portfolioLocated <- merge(claims, portfolios[,c("portfolioID","portfolioLatitude","portfolioLongitude")], by="portfolioID")
#claims <- merge(claims, claims_portfolioLocated[, c("portfolioLongitude", "portfolioLatitude", "portfolioID", "claimID")], by = "claimID", all.x = TRUE, no.dups = FALSE)
#claims <- mutate(claims, latitude = coalesce(claims$WGS84_latitude,claims$portfolioLatitude)) 
#claims <- mutate(claims, longitude = coalesce(claims$WGS84_longitude,claims$portfolioLongitude)) 
#claims <- claims[,c("claimID","sourceSystem","portfolioID","eqcPropertyGroup",
#                    "lossDate","eventMonth","eventYear",
#                    "claimStatus",
#                    "claimOpenDate","buildingClaimOpenDate","landClaimOpenDate",
#                    "latitude","longitude")]
#claims <- filter(claims, (is.na(claims$longitude)==FALSE) & (is.na(claims$latitude)==FALSE))

#portfoliosTest <- merge(claims[,c("latitude","longitude","claimID")], portfolios, by.x=c("latitude", "longitude"), by.y = c("portfolioLatitude", "portfolioLongitude"), all.y = TRUE)

### Make spatial: 

# First copy the lat long columns 
portfolios$lat <- portfolios$portfolioLatitude
portfolios$long <- portfolios$portfolioLongitude
# Now define as an sf point object 
portfolios <- st_as_sf(portfolios, coords = c("long", "lat"), crs = 4326) 
#note crs tells it the latlons are wgs84
# NB the new lat longs change to a list-column, called geometry, which is an sfc_POINT class.

# check projection
st_crs(portfolios)
# it is, but if it wasn't we'd want: 
#st_crs(ph_sf) <- 4326


###
claimsNoPortID <- filter(claimsNoPortID, (is.na(claimsNoPortID$longitude)==FALSE) & (is.na(claimsNoPortID$latitude)==FALSE))

claimsNoPortID$lat <- claimsNoPortID$latitude
claimsNoPortID$long <- claimsNoPortID$longitude

# Now define as an sf point object 
claimsNoPortID <- st_as_sf(claimsNoPortID, coords = c("long", "lat"), crs = 4326) #note crs tells it the latlons are wgs84


### Then, the precipID link:

# Finding indices of the two nearest points in A(rain) to each of the points in B(portfolios)
tree <- createTree(st_coordinates(vcsnWide))
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) # can be 2 or more

# Create a tibble of the index 
spatial <- tibble("vcsnPoint"=vcsnWide$geometry[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)
head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial))

# Splitting out the lat longs 
spatial$vcsnLongitude <- st_coordinates(spatial$vcsnPoint)[,1]
spatial$vcsnLatitude <- st_coordinates(spatial$vcsnPoint)[,2]

portfolioVcsnID <- spatial

rm(inds)
rm(spatial)
rm(tree)
#rm(vcsnWide)

#Drop the points (portfolio and precip sf points columns) 
portfolioVcsnID <- portfolioVcsnID[c("portfolioID", "vcsnLongitude", "vcsnLatitude")]

# Finding indices of the two nearest points in A(rain) to each of the points in B(portfolios)
tree <- createTree(st_coordinates(vcsnWide))
inds <- knnLookup(tree, newdat=st_coordinates(claimsNoPortID), k=1) # can be 2 or more

# Create a tibble of the index 
spatial <- tibble("vcsnPoint"=vcsnWide$geometry[inds[,1]],
                  "claimID"=claimsNoPortID$claimID,
                  "claimPoint"=claimsNoPortID$geometry)
head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial))

# Splitting out the lat longs 
spatial$vcsnLongitude <- st_coordinates(spatial$vcsnPoint)[,1]
spatial$vcsnLatitude <- st_coordinates(spatial$vcsnPoint)[,2]

claimsNoPortVcsnID <- spatial

rm(inds)
rm(spatial)
rm(tree)
#rm(vcsnWide)

#Drop the points 
claimsNoPortVcsnID <- claimsNoPortVcsnID[c("claimID", "vcsnLongitude", "vcsnLatitude")]

###############################

### Second, the claim link (attaching all claims)
claimsPortfolioVcsnID <- merge(claims, portfolioVcsnID, by = "portfolioID", all.y = TRUE)
claimsNoPortVcsnID <- merge(claims, claimsNoPortVcsnID, by = "claimID", all.y = TRUE)

claimsPortfolioVcsnID <- claimsPortfolioVcsnID[,c("claimID","sourceSystem","portfolioID","eqcPropertyGroup",
                                                "lossDate","eventMonth","eventYear",
                                                "claimStatus",
                                                "claimOpenDate","buildingClaimOpenDate","landClaimOpenDate",
                                                "buildingPaid", "landPaid",
                                                "vcsnLongitude", "vcsnLatitude")]
claimsPortfolioVcsnID$claimed <- ifelse(claimsPortfolioVcsnID$claimID=="NA", 0, 1)

claimsNoPortVcsnID <- claimsNoPortVcsnID[,c("claimID","sourceSystem","portfolioID","eqcPropertyGroup",
                                                  "lossDate","eventMonth","eventYear",
                                                  "claimStatus",
                                                  "claimOpenDate","buildingClaimOpenDate","landClaimOpenDate",
                                                  "buildingPaid", "landPaid",
                                                  "vcsnLongitude", "vcsnLatitude")]
claimsNoPortVcsnID$claimed <- ifelse(claimsNoPortVcsnID$claimID=="NA", 0, 1)

### Third, from the claim-precip link, attaching relevant rainfall... 

library(lubridate)

claimPortfolioVcsnID$eventMonth <- month(claimPortfolioVcsnID$lossDate)
#claimPortfolioVcsnID$eventPreMonth <- c(claimPortfolioVcsnID$eventMonth-1)
#claimPortfolioVcsnID$eventPostMonth <- c(claimPortfolioVcsnID$eventMonth+1)
# Note to self: fix the January/December link here! 
claimsPortfolioVcsnID$eventYear <- year(claimsPortfolioVcsnID$lossDate)
claimsPortfolioVcsnID <- mutate(claimsPortfolioVcsnID, claimsPortfolioVcsnID$lossDate+1)
claimsPortfolioVcsnID <- mutate(claimsPortfolioVcsnID, claimsPortfolioVcsnID$lossDate+2)
names(claimsPortfolioVcsnID)[14:15] <- c("lossDatePlusOne", "lossDatePlusTwo")

### Third, from the claim-precip link, attaching relevant rainfall... 
claimsNoPortVcsnID$eventMonth <- month(claimsNoPortVcsnID$lossDate)
#claimsNoPortVcsnID$eventPreMonth <- c(claimsNoPortVcsnID$eventMonth-1)
#claimsNoPortVcsnID$eventPostMonth <- c(claimsNoPortVcsnID$eventMonth+1)
# Note to self: fix the January/December link here! 
claimsNoPortVcsnID$eventYear <- year(claimsNoPortVcsnID$lossDate)
claimsNoPortVcsnID <- mutate(claimsNoPortVcsnID, claimsNoPortVcsnID$lossDate+1)
claimsNoPortVcsnID <- mutate(claimsNoPortVcsnID, claimsNoPortVcsnID$lossDate+2)
#names(claimNoPortVcsnID)[14:15] <- c("lossDatePlusOne", "lossDatePlusTwo")

claimsPortfolioVcsnID <- distinct(claimsPortfolioVcsnID)
claimsNoPortVcsnID <- distinct(claimsNoPortVcsnID) 
claimsNoPortVcsnID <- claimsNoPortVcsnID[,c("claimID", "portfolioID", "vcsnLatitude", "vcsnLongitude")]

#vcsn <- mutate(vcsn, vcsn$vcsnDay+1)
#vcsn <- mutate(vcsn, vcsn$vcsnDay+2)
#names(vcsn)[7:8] <- c("vcsnDay2", "vcsnDay3")
#vcsn$rain2 <- vcsn$rain
#vcsn$rain3 <- vcsn$rain

vcsnSubset <- filter(vcsn,
                     (eventYear==2015 & eventMonth>05 & eventMonth<09) | 
                       (eventYear==2016 & eventMonth>10) | 
                       (eventYear==2017 & eventMonth==1) | 
                       (eventYear==2017 & eventMonth>2 & eventMonth<6))

claimPortfolioVcsn <- merge(claimsPortfolioVcsnID, vcsnSubset[ , c("vcsnLatitude", "vcsnLongitude", "vcsnDay", "rain", "eventMonth")], by.x = c("lossDate", "vcsnLatitude", "vcsnLongitude", "eventMonth"), by.y = c("vcsnDay", "vcsnLatitude", "vcsnLongitude", "eventMonth"), all.x = TRUE, incomparables = NA)

claimPortfolioVcsn <- merge(claimsPortfolioVcsnID, vcsnSubset[ , c("vcsnLatitude", "vcsnLongitude", "vcsnDay", "rain", "eventMonth")], by.x = c("lossDate", "vcsnLatitude", "vcsnLongitude", "eventMonth"), by.y = c("vcsnDay", "vcsnLatitude", "vcsnLongitude", "eventMonth"), all.x = TRUE, incomparables = NA)
claimPortfolioVcsn <- merge(claimsPortfolioVcsn, vcsnSubset[ , c("vcsnLatitude", "vcsnLongitude", "vcsnDay", "rain2")], by.x = c("lossDatePlusOne", "vcsnLatitude", "vcsnLongitude"), by.y = c("vcsnDay", "vcsnLatitude", "vcsnLongitude"), all.x = TRUE)
claimPortfolioVcsn <- merge(claimsPortfolioVcsn, vcsnSubset[ , c("vcsnLatitude", "vcsnLongitude", "vcsnDay", "rain3")], by.x = c("lossDatePlusTwo", "vcsnLatitude", "vcsnLongitude"), by.y = c("vcsnDay", "vcsnLatitude", "vcsnLongitude"), all.x = TRUE)

#claimPortfolioVcsn <- claimPortfolioVcsn[1:-1]
#claimPortfolioVcsnFull <- merge(claimPortfolioVcsnID, claimPortfolioVcsn, by = "claimID", all.x = TRUE)
#stat.desc(claimPortfolioVcsnFull[,sapply(claimPortfolioVcsnFull,is.numeric)], basic=F)

#claimPortfolioVcsn <- merge(claimPortfolioVcsnID, vcsn, by = c("vcsnDay", "vcsnLatitude", "vcsnLongitude", all.x = TRUE))

claimPortfolioVcsnMB <- merge(portfolioMB, claimPortfolioVcsn, by.x = "portfolioi", by.y = "portfolioID", all.x = TRUE)


#######
#rm(claimPortfolioVcsnID)
#rm(claimPortfolioVcsn)
rm(claim1114)
rm(claim1518)
rm(vcsn1114)
rm(vcsn1518)
rm(vcsntest)
rm(portfolioDatasetGeolocatedOriginal)

# only relevant VCSN - but attached to all portfolios for comparison:

vcsn2015Subset <- filter(vcsnSubset,
                         vcsnSubset$eventYear==2015)
plot(vcsn2015Subset$vcsnDay,vcsn2015Subset$rain)

vcsn201506 <- filter(vcsnSubset,
                         vcsnSubset$vcsnDay>"2015-06-15" & vcsnSubset$vcsnDay<"2015-06-19" )
vcsn201506Wide <- dcast(vcsn201506, vcsnLatitude + vcsnLongitude ~ vcsnDay, value.var="rain")

portfolioVcsn201506 <- merge(portfolioVcsnID, vcsn201506Wide, by = c("vcsnLongitude", "vcsnLatitude"))
names(portfolioVcsn201506)[4:6] <- c("rain", "rain2", "rain3")

claimPortfolioVcsn201506 <- merge(claimPortfolioVcsn, portfolioVcsn201506[ , c("portfolioID", "rain", "rain2", "rain3")], by.x = c("portfolioID"), by.y = c("portfolioID"), all.x = TRUE)

#claimPortfolioVcsn201506test<-claimPortfolioVcsn201506[,c("portfolioID", "lossDate", "claimed", "eventMonth", "eventYear", "mb2013", "regc2013", "rain1", "rain2", "rain3")]

#plot(vcsn$vcsnDay,vcsn$rain)

ggplot(data=vcsn2015Subset) +
  geom_point(vcsn2015Subset, 
           mapping = aes(
             x = vcsn2015Subset$vcsnDay, 
             y = vcsn2015Subset$rain)
  ) +
  labs(y = "precipitation in mm/day",
       x = "date")


### Third, NL to portfolios link 
nl201506sf <- st_as_sfc(nl201506, as_points=TRUE, na.rm=TRUE)

## Find indices of the nearest point in A to each of the points in B
tree <- createTree(st_coordinates(nl201506sf)) #A=nl
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) #B=portfolios #can be 2 or more

# Create a tibble of the index 
spatial <- tibble("nlPoint"=nl201506sf[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial)[1:2]) #dropping portfolioPoint (unnecessary now)

portfolioNLID <- spatial

rm(tree)
rm(inds)
rm(spatial)

# Splitting out the lat longs 
portfolioNLID$nlLongitude <- st_coordinates(portfolioNLID$nlPoint)[,1]
portfolioNLID$nlLatitude <- st_coordinates(portfolioNLID$nlPoint)[,2]

nl201506df = as.data.frame(nl201506)
nl201507df = as.data.frame(nl201507)
nl201508df = as.data.frame(nl201508)

portfolioNL201506 <-merge(nl201506df,portfolioNLID, by.x = c("x","y"), by.y = c("nlLongitude","nlLatitude"))
portfolioNL201507 <-merge(nl201507df,portfolioNLID, by.x = c("x","y"), by.y = c("nlLongitude","nlLatitude"))
portfolioNL201508 <-merge(nl201508df,portfolioNLID, by.x = c("x","y"), by.y = c("nlLongitude","nlLatitude"))

#head(portfolioNL201506)
#names(portfolioNL2015)
names(portfolioNL201506)[3] <- c("avg_rad_201506")
names(portfolioNL201507)[3] <- c("avg_rad_201507")
names(portfolioNL201508)[3] <- c("avg_rad_201508")

portfolio2015NL <- merge(portfolios[,c("portfolioID")], portfolioNL201506[,c("portfolioID", "avg_rad_201506")], by = "portfolioID", all = TRUE)
portfolio2015NL <- merge(portfolio2015NL, portfolioNL201507[,c("portfolioID", "avg_rad_201507")], by = "portfolioID", all = TRUE)
portfolio2015NL <- merge(portfolio2015NL, portfolioNL201508[,c("portfolioID", "avg_rad_201508")], by = "portfolioID", all = TRUE)
head(portfolio2015NL)

# merge onto other data:
claimPortfolioVcsnNL2015 <- merge(claimPortfolioVcsn201506, portfolio2015NL[,c("portfolioID", "avg_rad_201506", "avg_rad_201507", "avg_rad_201508")], by = "portfolioID")
head(claimPortfolioVcsnNL2015)

#create extreme rain indicator:
#claimPortfolioVcsnNL2015 <- mutate(claimPortfolioVcsnNL2015,
#                                   as.numeric(rain>500|rain2.x>500|rain3.x>500))
claimPortfolioVcsnNL2015Tidier <- claimPortfolioVcsnNL2015[,c("portfolioID", "lossDate","claimID","eventDate","claimStatus","buildingPaid","landPaid","claimed","eventMonth","eventYear","rain.y","rain2.y","rain3.y","avg_rad_201506","avg_rad_201507","avg_rad_201508")]

claimPortfolioVcsnNL2015Tidier<- mutate(claimPortfolioVcsnNL2015Tidier,
                                        as.numeric(is.na(claimPortfolioVcsnNL2015Tidier$claimID)))
names(claimPortfolioVcsnNL2015Tidier)[17]<-c("EQCclaimant")
claimPortfolioVcsnNL2015Tidier$claimant <- ifelse(claimPortfolioVcsnNL2015Tidier$EQCclaimant=="FALSE", 0, 1)

claimPortfolioVcsnNL2015Tidier<- mutate(claimPortfolioVcsnNL2015Tidier,
                                        as.numeric(claimPortfolioVcsnNL2015Tidier$claimStatus=="Declined"|is.na(claimPortfolioVcsnNL2015Tidier$claimStatus)))
names(claimPortfolioVcsnNL2015Tidier)[19]<-c("approvedClaim")
claimPortfolioVcsnNL2015Tidier$approved <- ifelse(claimPortfolioVcsnNL2015Tidier$approvedClaim=="FALSE", 0, 1)

claimPortfolioVcsnNL2015Tidier<- mutate(claimPortfolioVcsnNL2015Tidier,
                                        as.numeric(rain.y>250 | rain2.y>250 | rain3.y>250))
names(claimPortfolioVcsnNL2015Tidier)[21]<-c("extreme")
claimPortfolioVcsnNL2015Tidier$extremeRain <-ifelse(claimPortfolioVcsnNL2015Tidier$extreme==0,0,1)

portfoliosMB <- merge(portfolios, portfolioMB, by.x = "portfolioID", by.y="portfolioi")
claimPortfolioMB <- merge(claims, portfoliosMB, by("portfolioID", all=TRUE))

claimPortfolioVcsnNL2015Tidier <- merge(claimPortfolioVcsnNL2015Tidier)

head(claimPortfolioVcsnNL2015Tidier)

# write out this dataframe as a .csv file
csvfile <- paste("Data/claimPortfolioVcsnNL2015Tidier", ".csv", sep="")
write.table(claimPortfolioVcsnNL2015Tidier,csvfile, row.names=FALSE, sep=",")

rm(nl201506)
rm(nl201506sf)
rm(nl201507)
rm(nl201507df)
rm(nl201508)
rm(nl201508df)
rm(nl201506df)


