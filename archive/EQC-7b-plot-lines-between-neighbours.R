# EQC 8 

#memory.limit(size=50000)

# Number of total linestrings to be created
#n <- 1613035
n <- 100000

# Build info for linestrings
linestrings <- lapply(X = 1:n, FUN = function(x) {
  
  pair <- st_combine(c(pairs$point.1[x], pairs$point.2[x]))
  line <- st_cast(pair, "LINESTRING")
  return(line)
  
})

# Geo-process linestrings 
multilinestring <- st_multilinestring(do.call("rbind", linestrings))
plot(multilinestring)

# NB: modified using this ref:
# https://gis.stackexchange.com/questions/270725/r-sf-package-points-to-multiple-lines-with-st-cast/270894#270894 

### When using portfolioSP as the base data, and asking for all the nn lines (1613035), this error recieved:
### "Error: memory exhausted (limit reached?)
### Graphics error: Plot rendering error"
