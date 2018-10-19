# insurance-and-climate

Plan: Data processing and histogram of rain within claim's lossdate window 
Each step below has a numbered r script. They are together called by the "main" script. 

 Using sf package: 
 1 - eqc claims csv to r dataframe (including lossdate as an r date) 
 2 - eqc portfolio csv to sf r data 
 3 - vis portfolios 
 4 - vis claim locations 
 5 - niwa rain netcdf to r data (including day as r dates)
 6 - vis rain 
 7 - geo process portfolio adding closest rain point 
 8 - line segments portfolio to rain 
 9 - generate claim window 
