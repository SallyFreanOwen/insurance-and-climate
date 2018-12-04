download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201204/vcmcfg/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",
  destfile="Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz"
)

download.file(
  "https://data.ngdc.noaa.gov/instruments/remote-sensing/passive/spectrometers-radiometers/imaging/viirs/dnb_composites/v10/201205/vcmcfg/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",
  destfile="Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz"
)

library(R.utils)
gunzip("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.tgz",destname="Data/S201204.tar")
gunzip("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.tgz",destname="Data/S201205.tar")

untar("Data/S201204.tar",exdir="Data")
untar("Data/S201205.tar",exdir="Data")

# note tifs in . not Data/
library(stars)
#s201404 <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif")

s <- read_stars(c("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.cf_cvg.tif",
                  "Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.cf_cvg.tif"))
                        
plot(s)
