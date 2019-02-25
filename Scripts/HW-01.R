# HW - 02 Initial investigation HWEC 

histWeather_raw <- read.csv("Data/HistoricEventsCatalog.csv")

library(dplyr)
library(lubridate)
library(reshape2)

claims <- mutate(claims, eventMonth=month(eventDate))
claims <- mutate(claims, eventYear=year(eventDate))

