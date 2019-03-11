# HW - 02 Initial investigation HWEC 

histWeatherRaw <- read.csv("Data/HistoricEventsCatalog.csv", stringsAsFactors = FALSE)

library(dplyr)
library(lubridate)
library(reshape2)

histWeather <- histWeatherRaw

# Formatting names 
first.letter  <- tolower(substring(names(histWeatherRaw),1, 1))
other.letters <- substring(names(histWeatherRaw), 2)
newnames      <- paste(first.letter, other.letters, sep="")
names(histWeather) <- newnames

# sorting out the ID 
histWeather$identifier <- as.numeric(histWeather$identifier)

# sorting out dates:
histWeather$startDate <- as.Date(histWeather$startDate, format = "%Y-%m-%d")

rm(histWeatherRaw)

