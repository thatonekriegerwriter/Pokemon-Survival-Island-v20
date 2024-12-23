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
    @character_customization =UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT
    @base                  = nil
    @hair                  = nil
    @top                  = nil
    @bottom               = nil
    @headgear             = nil
    @accessory            = nil
    @bag                  = nil
    @contact              = nil
    @shoes                = nil
    @hairList             = [:BALD,:SHORT,:SHORT2,:MEDIUM,:LONG,:SPIKEY,:SPIKEY2,:SLICKEDBACK,:PONYTAIL]
    @topList              = [:SHIRTA,:SHIRTB,:SHIRTC]
    @bottomList           = [:BOTTOMA,:BOTTOMB]
    @headgearList         = [:BEANIE,:BONNET,:FEDORA,:GLASSES,:HAIRBAND,:HEADBAND,:MINERHELMET,:RIBBON,:SUNHAT,:YOUNGSTERCAP]
    @accessoryList        = [:BAG]
    @clothesUnlocking     = 0
	
	
	
    @bagList              = [:BAG]
    @contactList          = []
    @shoesList            = []
  end
  
  
def character_customization

@character_customization=UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT

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
@base = nil if @base=="None"
return @base
end

def base=(values)
@base=values
end
 
def hair
@hair = nil if @hair=="None"
return @hair
end
 
def hair=(values)
@hair=values
end

 
def hairList
@hairList = [:BALD,:SHORT,:SHORT2,:MEDIUM,:LONG,:SPIKEY,:SPIKEY2,:SLICKEDBACK,:PONYTAIL] if @hairList.nil? || @hairList.empty?
return @hairList
end
 
def top
@top = nil if @top=="None"
return @top
end

 
def topList
@topList = [:SHIRTA,:SHIRTB,:SHIRTC] if @topList.nil? || @topList.empty?
return @topList
end
 
def top=(values)
@top=values
end

 
def bottom
@bottom = nil if @bottom=="None"
return @bottom
end
 
def bottom=(values)
@bottom=values
end

 
def bottomList
@bottomList = [:BOTTOMA,:BOTTOMB] if @bottomList.nil? || @bottomList.empty?
return @bottomList
end
 
 
def headgear
@headgear = nil if @headgear=="None"
return @headgear
end
 
def headgear=(values)
@headgear=values
end
 
 
def headgearList
@headgearList = [:BEANIE,:BONNET,:FEDORA,:GLASSES,:HAIRBAND,:HEADBAND,:MINERHELMET,:RIBBON,:SUNHAT,:YOUNGSTERCAP] if @headgearList.nil? || @headgearList.empty?
return @headgearList
end
 
def accessory
@accessory = nil if @accessory=="None"
return @accessory
end
 
def accessoryList
@accessoryList = [:BAG] if @accessoryList.nil? || @accessoryList.empty?
return @accessoryList
end
 
 
def accessory=(values)
@accessory=values
end
 
#def clothesUnlocking
#return @clothesUnlocking
#end
end
class Game_Temp
attr_accessor :savedoutfit

alias :tempinitold :initialize
def initialize
tempinitold
@savedoutfit          = false
end

end













