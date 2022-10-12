module ReincarnationConfig
# The item you want to use as a magic stone.
MAGIC_STONE_HP 		= :GOLDSTONE
MAGIC_STONE_ATK 	= :REDSTONE
MAGIC_STONE_DEF 	= :BLUESTONE
MAGIC_STONE_SATK 	= :BLACKSTONE
MAGIC_STONE_SDEF 	= :WHITESTONE
MAGIC_STONE_SPEED	= :GREENSTONE	  
MAGIC_STONE_INHERIT = :RAINBOWSTONE

#The items you want to use as a Boon.

BOON_ATK 			= :REDMARK
BOON_DEF 			= :BLUEMARK
BOON_SATK 			= :BLACKMARK
BOON_SDEF 			= :WHITEMARK
BOON_SPEED			= :GREENMARK	
BOON_NEUTRAL		= :GREYMARK	

#The items you want to use as a Bane. 


BANE_ATK 			= :REDMARK
BANE_DEF 			= :BLUEMARK
BANE_SATK 			= :BLACKMARK
BANE_SDEF 			= :WHITEMARK
BANE_SPEED			= :GREENMARK	
BANE_NEUTRAL		= :GREYMARK	


# If you want your reincarnation to cost an item, defined in COST_ITEM, and the amount of that item, COST_AMOUNT

REINCARNATION_HAS_COST 		= false
COST_ITEM 					= :MAGFRAG
COST_AMOUNT 				= 1

# If you want the Magic Stones or Boon/Bane to be taken away from use.
#  Options:
# TAKE_FROM_BAG = "STONES"
# TAKE_FROM_BAG = "BOON/BANE"
# TAKE_FROM_BAG = "NEITHER"
# TAKE_FROM_BAG = "BOTH"

TAKE_FROM_BAG 				= "NEITHER"

#Custom Music for the Menu, has to be in BGM Folder.
CUSTOM_MUSIC 				= "Unexpected Visitor"
CUSTOM_REINCARNME 			= "Evo Complete"
CUSTOM_BG 					= "Graphics/Pictures/Reincarnation/ReincarnationBG"


#After reincarnation set Pokemon to this level, if nil, will not change level.
SET_TO_LEVEL 				= Settings::EGG_LEVEL # Default: 1
REVERT_EVOLUTION            = true
REVERT_MOVES                = false
#Nuzlocke X Support 
#Reincarnation can only be used if a Pokémon is fainted.
#This only works if autoremove is off.


NUZLOCKE_REINCARNATION = true

end