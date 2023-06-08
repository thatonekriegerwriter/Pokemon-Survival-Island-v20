#==================================
# Settings
#==================================

module NatureSettings
    # Chance out of 10 that Rare natures are included in the pool when a new Pokemon's nature is determined.
    # Chance of a new Pokemon getting a specific Rare nature then becomes (RARE_NATURE_CHANCE/10)*(1/number of total natural natures)
    #   Example: if you have a total of 40 natural natures, and you have RARE_NATURE_CHANCE = 5, then the chance of a new Pokemon
    #            getting a specific Rare nature is 1.25%
    RARE_NATURE_CHANCE = 3 #Default = 3 (30%)
	
end