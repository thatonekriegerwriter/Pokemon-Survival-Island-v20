 #==================================================================================
# * Forcefully removing a sprite from the Cache, even if it's not meant to be deposed.
#==================================================================================
module RPG
  module Cache
      def self.forget(folder_name, filename = "", hue = 0)
	    path = folder_name + filename
        ret = fromCache(path)
        if ret
        @cache.delete(path)
		end
	  end
end
end

module GameData
  class Item
  

    def is_hair?;                 return has_flag?("Hair"); end
    def is_top?;                  return has_flag?("Top"); end
    def is_bottom?;               return has_flag?("Bottom"); end
    def is_headgear?;             return has_flag?("Headgear"); end
    def is_accessory?;            return has_flag?("Accessory"); end
    def is_bag?;                  return has_flag?("Bag"); end
    def is_contact?;              return has_flag?("Eye Contact"); end
    def is_shoes?;                return has_flag?("Shoes"); end
end
end


class Player < Trainer
attr_accessor :character_customization
attr_accessor :base
attr_accessor :hair
attr_accessor :top
attr_accessor :bottom
attr_accessor :headgear
attr_accessor :accessory
attr_accessor :bag
attr_accessor :contact
attr_accessor :shoes
attr_accessor :hairList
attr_accessor :topList
attr_accessor :bottomList
attr_accessor :headgearList
attr_accessor :accessoryList
attr_accessor :bagList
attr_accessor :contactList
attr_accessor :shoesList
attr_accessor :clothesUnlocking

   alias _CharaCust_Init initialize
  def initialize(name, trainer_type)
    _CharaCust_Init(name, trainer_type)
    @character_customization=UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT
    @base                 = "None"
    @hair                 = "None"
    @top                  = "None"
    @bottom               = "None"
    @headgear             = "None"
    @accessory            = "None"
    @bag                  = "None"
    @contact              = "None"
    @shoes                = "None"
    @hairList             = [:BALD,:SHORT,:SHORT2,:MEDIUM,:LONG,:SPIKEY,:SPIKEY2,:SLICKEDBACK,:PONYTAIL]
    @topList              = []
    @bottomList           = []
    @headgearList         = []
    @accessoryList        = [:BAG]
    @clothesUnlocking     = 0
	
	
	
    @bagList              = [:BAG]
    @contactList          = []
    @shoesList            = []
  end
  
  
def character_customization
if !@character_customization
@character_customization=UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT
end
return @character_customization
end

def character_customization=(boolean)
if boolean != true && boolean != false # Determining if object is a boolean
if $DEBUG
p "only $player.character_customization = true/false is valid!"
end
return
end
@character_customization=boolean
end

def base
if !@base
@base="None"
end
return @base
end

def base=(values)
@base=values
end
 
def hair
if !@hair
@hair="None"
end

return @hair
end
 
def hair=(values)
@hair=values
end

 
def top
if !@top
if ((TOP_ITEMS[0][1] == true) || (TOP_ITEMS[0][1] == false))
@top="None"
else
@top="None"
end
end
return @top
end
 
def top=(values)
@top=values
end

 
def bottom
if !@bottom
if ((BOTTOM_ITEMS[0][1] == true) || (BOTTOM_ITEMS[0][1] == false))
@bottom="None"
else
@bottom="None"
end
end
return @bottom
end
 
def bottom=(values)
@bottom=values
end
 
def headgear
if !@headgear
if ((HEADGEAR_ITEMS[0][1] == true) || (HEADGEAR_ITEMS[0][1] == false))
@headgear="None"
else
@headgear="None"
end
end
return @headgear
end
 
def headgear=(values)
@headgear=values
end
 
def accessory
if !@accessory
if ((ACCESSORY_ITEMS[0][1] == true) || (ACCESSORY_ITEMS[0][1] == false))
@accessory="None"
else
@accessory="None"
end
end
return @accessory
end
 
def accessory=(values)
@accessory=values
end
 
def clothesUnlocking

end
end
class Game_Temp
attr_accessor :savedoutfit

alias :tempinitold :initialize
def initialize
tempinitold
@savedoutfit          = false
end

end













