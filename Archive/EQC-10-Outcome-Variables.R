# EQC - Beginning to think about outcome variables 

## Download New Zealand monthly nightlight data, for entire monthly time-series (began April 2012) 

install.packages("Rnightlights")

library(Rnightlights)
library(reshape2)
library(lubridate)

pkgOptions(extractMethod="rast", numCores=4)
pkgOptions(downloadMethod = "aria", cropMaskMethod = "gdal", extractMethod = "gdal", deleteTiles = TRUE)

# Setting up so that alternate countries could be added. Note can check for correct codes as below.
#ctryNameToCode(“new zealand”)
ctry <- "NZL"

#download and process monthly VIIRS stats at the highest admin level
highestAdmLevelStats <- getCtryNlData(ctryCode = ctry, 
                                      admLevel = "highest",
                                      nlType = "VIIRS.M", 
                                      nlPeriods = nlRange("201204", "201810"), 
                                      nlStats = list("sum",na.rm=TRUE),
                                      ignoreMissing=FALSE)

## Visualise nightlight extract 

install.packages("ggplot2")
install.packages("plotly")
install.packages("lubridate")
install.packages("reshape2")

library(ggplot2)
library(reshape2)
library(lubridate)
library(plotly)

#melt the stats into key-value format for easy multi-line plotting with ggplot2
highestAdmLevelStats <- melt(highestAdmLevelStats,
                             id.vars = grep("NL_", names(highestAdmLevelStats), 
                                            invert=TRUE), 
                             variable.name = "nlPeriod", 
                             value.name = "radiancesum")

#extract date from the NL col names
highestAdmLevelStats$nlPeriod <- substr(highestAdmLevelStats$nlPeriod, 12, 17)

#format period as date
highestAdmLevelStats$nlPeriod <- ymd(paste0(substr(highestAdmLevelStats$nlPeriod, 1,4), 
                                            "-",substr(highestAdmLevelStats$nlPeriod, 5,6), "-01"))

#plot 2nd admin level sums for the year
g <- ggplot(data = highestAdmLevelStats, 
            aes(x=nlPeriod, y=radiancesum, 
                color=highestAdmLevelStats[[2]])) +
  scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m")+
  geom_line()+geom_point() + labs(color = names(highestAdmLevelStats)[2]) + 
  xlab("Month") + 
  ylab("Sum of Radiances") +
  ggtitle(paste0(unique(names(highestAdmLevelStats)[2]), " sum of radiances for ", ctry))

print(g)

#quick conversion to interactive map with plotly
ggplotly(g)

# Adapted from https://github.com/chrisvwn/Rnightlights
