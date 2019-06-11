### Downloading two test files via R 

# Note full set can be downloaded directly through the terminal - using url codes in the urls.txt file 
# (very large - just using these two for WIP when working remotely)

library(R.utils)

### Event 1: June 2015 Storm, all NZ 

# Download raw data from site:
download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201505/vcmcfg/SVDNB_npp_20150501-20150531_00N060E_vcmcfg_v10_c201506161325.tgz",
  destfile="Data/SVDNB_npp_20150501-20150531_00N060E_vcmcfg_v10_c201506161325.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201506/vcmcfg/SVDNB_npp_20150601-20150630_00N060E_vcmcfg_v10_c201508141522.tgz",
  destfile="Data/SVDNB_npp_20150601-20150630_00N060E_vcmcfg_v10_c201508141522.tgz"
)

download.file(
  " https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201507/vcmcfg/SVDNB_npp_20150701-20150731_00N060E_vcmcfg_v10_c201509151839.tgz",
  destfile="Data/SVDNB_npp_20150701-20150731_00N060E_vcmcfg_v10_c201509151839.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201508/vcmcfg/SVDNB_npp_20150801-20150831_00N060E_vcmcfg_v10_c201509301759.tgz",
  destfile="Data/SVDNB_npp_20150801-20150831_00N060E_vcmcfg_v10_c201509301759.tgz"
)

gunzip("Data/SVDNB_npp_20150501-20150531_00N060E_vcmcfg_v10_c201506161325.tgz",
       destname="Data/S201505.tar")
untar("Data/S201505.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20150601-20150630_00N060E_vcmcfg_v10_c201508141522.tgz",
       destname="Data/S201506.tar")
untar("Data/S201506.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20150701-20150731_00N060E_vcmcfg_v10_c201509151839.tgz",
       destname="Data/S201507.tar")
untar("Data/S201507.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20150801-20150831_00N060E_vcmcfg_v10_c201509301759.tgz",
       destname="Data/S201508.tar")
untar("Data/S201508.tar", exdir="Data")


### Event 2: 

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201610/vcmcfg/SVDNB_npp_20161001-20161031_00N060E_vcmcfg_v10_c201612011122.tgz",
  destfile="Data/SVDNB_npp_20161001-20161031_00N060E_vcmcfg_v10_c201612011122.tgz"
  )

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201611/vcmcfg/SVDNB_npp_20161101-20161130_00N060E_vcmcfg_v10_c201612191231.tgz",
  destfile="Data/SVDNB_npp_20161101-20161130_00N060E_vcmcfg_v10_c201612191231.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201612/vcmcfg/SVDNB_npp_20161201-20161231_00N060E_vcmcfg_v10_c201701271136.tgz",
  destfile="Data/SVDNB_npp_20161201-20161231_00N060E_vcmcfg_v10_c201701271136.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201701/vcmcfg/SVDNB_npp_20170101-20170131_00N060E_vcmcfg_v10_c201702241223.tgz",
  destfile="Data/SVDNB_npp_20170101-20170131_00N060E_vcmcfg_v10_c201702241223.tgz"
)

gunzip("Data/SVDNB_npp_20161001-20161031_00N060E_vcmcfg_v10_c201612011122.tgz",
       destname="Data/S201610.tar")
untar("Data/S201610.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20161101-20161130_00N060E_vcmcfg_v10_c201612191231.tgz",
       destname="Data/S201611.tar")
untar("Data/S201611.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20161201-20161231_00N060E_vcmcfg_v10_c201701271136.tgz",
       destname="Data/S201612.tar")
untar("Data/S201612.tar", exdir="Data")

gunzip("SVDNB_npp_20170101-20170131_00N060E_vcmcfg_v10_c201702241223.tgz",
       destname="Data/S201701.tar")
untar("Data/S201701.tar", exdir="Data")

### Event 3:

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201702/vcmcfg/SVDNB_npp_20170201-20170228_00N060E_vcmcfg_v10_c201703012030.tgz",
  destfile="Data/SVDNB_npp_20170201-20170228_00N060E_vcmcfg_v10_c201703012030.tgz"
  )

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201703/vcmcfg/SVDNB_npp_20170301-20170331_00N060E_vcmcfg_v10_c201705020851.tgz",
  destfile="Data/SVDNB_npp_20170301-20170331_00N060E_vcmcfg_v10_c201705020851.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201704/vcmcfg/SVDNB_npp_20170401-20170430_00N060E_vcmcfg_v10_c201705011300.tgz",
  destfile="Data/SVDNB_npp_20170401-20170430_00N060E_vcmcfg_v10_c201705011300.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201705/vcmcfg/SVDNB_npp_20170501-20170531_00N060E_vcmcfg_v10_c201706021500.tgz",
  destfile="Data/SVDNB_npp_20170501-20170531_00N060E_vcmcfg_v10_c201706021500.tgz"
)

gunzip("Data/SVDNB_npp_20170201-20170228_00N060E_vcmcfg_v10_c201703012030.tgz",
       destname="Data/S201702.tar")
untar("Data/S201702.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20170301-20170331_00N060E_vcmcfg_v10_c201705020851.tgz",
       destname="Data/S201703.tar")
untar("Data/S201703.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20170401-20170430_00N060E_vcmcfg_v10_c201705011300.tgz",
       destname="Data/S201704.tar")
untar("Data/S201704.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20170501-20170531_00N060E_vcmcfg_v10_c201706021500.tgz",
       destname="Data/S201705.tar")
untar("Data/S201705.tar", exdir="Data")


######### 4:

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201706/vcmcfg/SVDNB_npp_20170601-20170630_00N060E_vcmcfg_v10_c201707021700.tgz",
  destfile="Data/SVDNB_npp_20170601-20170630_00N060E_vcmcfg_v10_c201707021700.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201707/vcmcfg/SVDNB_npp_20170701-20170731_00N060E_vcmcfg_v10_c201708061230.tgz",
  destfile="Data/SVDNB_npp_20170701-20170731_00N060E_vcmcfg_v10_c201708061230.tgz"
)
gunzip("Data/SVDNB_npp_20170601-20170630_00N060E_vcmcfg_v10_c201707021700.tgz",
       destname="Data/S201706.tar")
untar("Data/S201706.tar", exdir="Data")

gunzip("Data/SVDNB_npp_20170701-20170731_00N060E_vcmcfg_v10_c201708061230.tgz",
       destname="Data/S201707.tar")
untar("Data/S201707.tar", exdir="Data")
