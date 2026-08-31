class ItemData
  attr_accessor :durability
  attr_accessor :max_durability
  attr_accessor :water
  attr_accessor :liquid_type
  DRINK_LOOKUP = {
    :WATER => 0.1,
    :MOOMOOMILK => 0.2,
    :BERRYJUICE => 0.5,
    :FRESHWATER => 0.5,
    :SITRUSJUICE => 0.8,
    :TEA => 1,
  
  }
  
  alias old_init_dura initialize 
  def initialize(id, durability = nil, water = nil )
	old_init_dura(id, durability, water)
    @durability  = durability
	@durability = 100 if durable? && durability.nil?
    @max_durability  = @durability
    @water      = water
    @water      = 0 if watering_can? && water.nil? || @id == :WATERBOTTLE
	@liquid_type = nil
  end
    def durability
	 @durability = nil if @durability==false 
	 return @durability 
	end 
	
	def durability=(value)
	  raise if value==false 
	  @durability = value 
	end 
	
    def increase_water(amt)
	 return false if @water >= 100
     @water+=amt
	 @water=100 if @water>100
	 return true 
    end
	
	def fill(liquid, amt)
	  return false unless DRINK_LOOKUP[liquid.id]
	  return false unless increase_water(amt)
	  @liquid_type = liquid.id
	  return true 
	end 
    
	def drink(amt)
	 if decrease_water(amt)
	  restore_amt = amt * DRINK_LOOKUP[@liquid_type]
	  increaseWater(restore_amt)
	  return true 
	 end 
	  @liquid_type = nil
	 return false 
	end 
	
    def decrease_water(amt)
     @water-=amt
	 if @water<0
	 @water=0
	 return false
	 end
	 return true
    end

    def increase_durability(amt)
     @durability+=amt
	 @durability=@max_durability if @durability>@max_durability
    end

    def decrease_durability(amt)
	 return false if @durability.nil?
	 #return false if @durability < amt && modified?
	 return false if broken?
     @durability = [@durability - amt, 0].max
	 return true
    end
	
    def broken?
	  @durability <= 0
	end 

	
	
    def max_durability 
	if @max_durability==false
	  @max_durability = nil
	end 
	 return @max_durability
	end	 



   def hp
    return @durability.to_i if @durability
    return 100 if @durability.nil?
   end
   
   def totalhp
    return @max_durability.to_i if @max_durability
    return 100 if @max_durability.nil?
   end

def default_durability_item?(item_id)
  item = GameData::Item.get(item_id)

  return true if item.is_berry? && !item.is_apricorn?
  return true if item.is_tool? && item_id != :STONE
  return true if [:WATERBOTTLE, :BOWL].include?(item_id)
  return true if item.is_foodwater? && !item.has_flag?("NoSpoiling") && !item.is_apricorn?

  false
end
  
  def dont_display_durability
    item = GameData::Item.get(@id)
	return true if item.is_pokeball?
    return true if @id == :CLOCK || @id == :CALENDAR
  
  end 
  
  def is_spoiling?
  item = GameData::Item.get(@id)
   return true if item.is_foodwater? && !item.has_flag?("NoSpoiling") && !item.is_apricorn?
   return true if item.is_berry? && !item.is_apricorn?
   return false 
  
  end 
  def durable?
    default_durability_item?(@id)
  end 
  def watering_can?
    (GameData::BerryPlant::WATERING_CANS.include?(@id) || @id == :WATERBOTTLE)
  end 
end 




def pbGetDurabilityMax(can)
    ret = Settings::BERRY_WATERING_USES_OVERRIDES[can] || Settings::BERRY_WATERING_USES_BEFORE_EMPTY
    return ret
end