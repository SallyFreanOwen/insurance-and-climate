
claimPortfolio <- merge(claims, portfolios, by = "portfolioID") 
claimPortfolioSpatialVIIRS <- merge(claimPortfolio, spatial, by = "portfolioID")
