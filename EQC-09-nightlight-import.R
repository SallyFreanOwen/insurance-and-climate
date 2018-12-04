download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10//201204/vcmcfg/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
  destfile="Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz"
  )
library(R.utils)
gunzip("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",destname="Data/temp.tar")
untar("Data/temp.tar")
# note tifs in . not Data/
library(stars)
s <- read_stars("SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif")
plot(s)
