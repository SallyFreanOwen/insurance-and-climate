### Downloading two test files via R 

# Note full set downloaded directly through the terminal - using url codes in the urls.txt file 
# (very large - just using these two for WIP when working remotely)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201204/vcmcfg/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
  destfile="Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz"
)
download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201205/vcmcfg/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
  destfile="Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz"
)

# Unzipping raw downloads: 
library(R.utils)

gunzip("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
       destname="Data/S201204.tar")
gunzip("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
       destname="Data/S201205.tar")
untar("Data/S201204.tar", exdir="Data")
untar("Data/S201205.tar", exdir="Data")

