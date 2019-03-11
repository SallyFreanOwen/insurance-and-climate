#EQC 5 build claim portfolio spatial 

claimPortfolio <- merge(claims, portfolios, by = "portfolioID") 
claimPortfolioSpatial <- merge(claimPortfolio, spatial, by = "portfolioID")

