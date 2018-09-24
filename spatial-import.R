setwd("~/EQC-climate-change-part-two")

# install.packages("tidyverse")
library(sp)
library(tidyverse)

#precip_historic <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/From_Work_Computer/VCSN_Rain5k_1999-2016.csv")

portfolio_raw <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/From_Work_Computer/EQC_Portfolio_2017_Motu.csv")
head(portfolio_raw)

coordinates(portfolio_raw) <- portfolio_raw[c("WGS84Latitude", "WGS84Longitude")]

summary(portfolio_raw)

claim_raw <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Motu_EQC_LSF_claims_post_2000.csv")
head(claim_raw)

claims <- claim_raw %>% 
  group_by(PortfolioID) %>% 
  count() %>% 
  rename(PortfolioID = property) %>% 
  add_column(type = "property") %>% 
  ungroup()



