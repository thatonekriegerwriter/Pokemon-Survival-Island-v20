module GameData
  class Item
  
      TOOLS = [:IRONPICKAXE,:SHOVEL,:MACHETE,:IRONAXE,:IRONHAMMER,:POLE,:OLDROD,:GOODROD,:SUPERROD,:RAFT,:PARAGLIDER]

  
    def decreaseDurability(amt)
     @durability-=amt
	 $bag.remove(self,1)
	 if @durability==0
	 $bag.remove(self,1)
	 return false
	 end
	 return true
    end
    def increaseDurability(amt)
     @durability+=amt
    end





    def spoiling(storage) #$bag, $PokemonGlobal.pcItemStorage, Other
     @durability-=1
	 if @durability==0
	 
	 
	 storage.remove(self,1)
	 potatoes = [:GROWTHMULCH,:DAMPMULCH,:STABLEMULCH,:GOOEYMULCH]
	 storage.add(potatoes[rand(potatoes.length)],amt)
	 
	 
	 end
	 
	 
	 
	
	end

  end
end

def pbGetDurabilityMax(can)
    ret = Settings::BERRY_WATERING_USES_OVERRIDES[can] || Settings::BERRY_WATERING_USES_BEFORE_EMPTY
    return ret
end


class PokemonBag
  def isToolinInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_tool? || itm.id == :PORTABLECAMP
      items << item
	  end
	end
	end
    return items
  end
  def isPlacableinInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_placeitem? && item!=:PORTABLECAMP
      items << item
	  end
	end
	end
    return items
  end

end















 def create_new_icebox(origin)
  $PokemonGlobal.iceboxes << PCItemStorage.new
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue
       statue = $PokemonGlobal.iceboxes.last
       interp.setVariable(statue)
    end
 
 
 end

 def create_new_gstorage(origin)
  $PokemonGlobal.generalstorage << PCItemStorage.new
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue
       statue = $PokemonGlobal.generalstorage.last
       interp.setVariable(statue)
    end
 
 
 end



class PokemonGlobalMetadata
  attr_accessor :iceboxes
  attr_accessor :generalstorage

  def iceboxes
  @iceboxes = [] if iceboxes.nil?
  return @iceboxes
  end
  def generalstorage
  @generalstorage = [] if generalstorage.nil?
  return @generalstorage
  end

end

