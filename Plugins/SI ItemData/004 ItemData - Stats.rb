class ItemData
  attr_accessor :modifiers
  attr_reader :stats 
  #attr_reader :effects # a series of effects an item can undergo considering the materials it is created from and modified with via modifiers.
  
  alias old_init_stats initialize 
  def initialize(id, durability = nil, water = nil )
	old_init_stats(id, durability, water)
	
    @modifiers  = ItemModifiers.new(self)
	#@effects = []
	@stats = ItemStats.new(self)
  end 
  
  def initialize_copy(original)
    super
    @modifiers  = original.modifiers.dup
    @stats  = original.stats.dup
    @modifiers.item = self
    @stats.item     = self 
  
  end 
  
  def stats 
	@stats = ItemStats.new(self) if @stats.nil?
    return @stats 
  end 
    
	def effects
	  modifiers.effects 
	end 


    def modifiers
     @modifiers = ItemModifiers.new(self) if @modifiers.nil? || !@modifiers.is_a?(ItemModifiers)
	 return @modifiers
	end
	
    def quality
	  return stats.quality
	end
	
    def quality=(value)
	  stats.quality=value 
	end

end 



class ItemStats
  attr_accessor :item
  attr_reader :berry
  attr_reader :consumable
  attr_reader :pokeball
  attr_reader :capture_styler
  attr_reader :weapon
  
  attr_accessor :damage
  attr_accessor :defense
  attr_accessor :speed
  
  
  
  def initialize(item)
    @item = item
    @berry = BerryStats.new(item) if item.data.is_berry?
    @consumable = ConsumableStats.new(item) if item.data.is_berry? || item.data.is_foodwater?
    @pokeball = PokeBallStats.new(item) if item.data.is_pokeball?
    @capture_styler = CaptureStylerStats.new(item) if item.data.is_styler?
	@weapon = WeaponStats.new(item) if item.data.is_weapon?
	@damage = 0
	@defense = 0
	@speed = 0
  end 
  
  def initialize_copy(original)
    super 
    
    @berry          = original.berry.dup if original.berry
    @consumable     = original.consumable.dup if original.consumable
    @pokeball       = original.pokeball.dup if original.pokeball
    @capture_styler = original.capture_styler.dup if original.capture_styler
    @weapon = original.weapon.dup if original.weapon

    @berry.item          = self.item if @berry
    @consumable.item     = self.item if @consumable
    @pokeball.item       = self.item if @pokeball
    @capture_styler.item = self.item if @capture_styler
    @weapon.item = self.item if @weapon
  end
  
  def quality
    if @item.data.is_pokeball?
      return @pokeball.quality
	elsif @item.data.is_berry? || @item.data.is_foodwater?
	  return @consumable.quality
	else 
	  return 0
	end
  end 
  def quality=(value)
    if @item.data.is_pokeball?
      @pokeball.quality = value 
	elsif @item.data.is_berry? || @item.data.is_foodwater?
	  @consumable.quality = value 
	end
  end 
  
  def priority
    @consumable&.priority
  end 
  def servings
    @consumable&.servings
  end 
  def spoiling_rate
    @consumable&.spoiling_rate
  end 
  def restores
    @consumable&.restores
  end 
  def priority=(value)
    @consumable.priority=value
  end 
  def servings=(value)
    @consumable.servings=value
  end 
  def spoiling_rate=(value)
    @consumable.spoiling_rate=value
  end 
  def restores=(value)
    @consumable.restores=value
  end 
  
  def weapon 
    @weapon = WeaponStats.new(@item) if @weapon.nil?
	return @weapon 
  end 
  
  def stat_bonus=(value)
    weapon.stat_bonus=value
  end 
  def stat_bonus
    weapon.stat_bonus
  end 


  def growth
    @berry&.growth
  end 
  def resistance
    @berry&.resistance
  end 
  def flavor
    @berry&.flavor
  end 
  def gain
    @berry&.gain
  end 
  def growth=(value)
    @berry&.growth=value
  end 
  def resistance=(value)
    @berry&.resistance=value
  end 
  def flavor=(value)
    @berry&.flavor=value
  end 
  def gain=(value)
    @berry&.gain=value
  end 




  def catch_rate
    @pokeball&.catch_rate
  end 
  def recoverable
    @pokeball&.recoverable
  end 
  def ease_of_use
    @pokeball&.ease_of_use
  end 

  def catch_rate=(value)
    @pokeball&.catch_rate=value
  end 
  def recoverable=(value)
    @pokeball&.recoverable=value
  end 
  def ease_of_use=(value)
    @pokeball&.ease_of_use=value
  end 
  
  
  def health
    @capture_styler&.health
  end 
  def power
    @capture_styler&.power
  end 
  def line
    @capture_styler&.line
  end 
  def recovery
    @capture_styler&.recovery
  end 
  def fading
    @capture_styler&.fading
  end 
  def latent_power
    @capture_styler&.latent_power
  end 
  def health=(value)
    @capture_styler&.health=value
  end 
  def power=(value)
    @capture_styler&.power=value
  end 
  def line=(value)
    @capture_styler&.line=value
  end 
  def recovery=(value)
    @capture_styler&.recovery=value
  end 
  def fading=(value)
    @capture_styler&.fading=value
  end 
  def latent_power=(value)
    @capture_styler&.latent_power=value
  end 


  def assists
    @capture_styler&.assists
  end 


end 
class WeaponStats
  attr_accessor :item
  attr_accessor :stat_bonus 
  def initialize(item)
    @item = @item
    @stat_bonus = 0
  
  
  
  
  end 
  def initialize_copy(original)
    super
  end



end 

class BerryStats
  attr_accessor :item
  attr_accessor :growth # effects the growth rate of plants
  attr_accessor :resistance # effects how resistant the plant is to weeds, and pests, rang: 0-4
  attr_accessor :flavor #effects how a pokemon likes a berry
  attr_accessor :season #effects the season the plant has an affinity for, 0-3
  attr_accessor :gain # effects the number of fruits that the plant will yield, rang 0-4
  attr_accessor :quality #effects it's price, and the amount of food/water restored by it, or in something with it, rang: 1-5
  def initialize(item)
    @item = item 
    @growth = berry_data.hours_per_stage
	@resistance = 0
	@flavor = berry_data.flavor
	@season = berry_data.season
	@gain = 0
	@quality = 1
  end 
  def initialize_copy(original)
    super
  end
  
  def berry_data
    GameData::BerryPlant.get(@item.id)
  end 
end 


class ConsumableStats
  attr_accessor :item
  attr_accessor :spoiling_rate 
  attr_accessor :priority 
  attr_accessor :servings 
  attr_accessor :restores 
  
  def initialize(item)
    @item = item 
    @spoiling_rate = 1 # effects the rate the food spoils, rang: 1-5
	@priority = 1 # effects how much this as an ingredient changes the food, rang: 1-5
	@servings = 1 # effects how many times the food can be eaten, rang: 1-3
	@flavor = [0,0,0,0,0] #effects how a pokemon likes the food
	@restores = 0 # effects how much the food restores, range: negative to postive
	@quality = 1 #  effects it's price, and the amount of food/water restored by it, rang: 1-5
  end 
  def initialize_copy(original)
    super
    @flavor = original.instance_variable_get(:@flavor).dup
  end
  
  def quality
    if @item.data.is_berry?
	  return @item.stats.berry.quality 
	else
	 return @quality
	end 
  end 
  
  def flavor
    if @item.data.is_berry?
	  return @item.stats.berry.flavor 
	else
	 return @flavor
	end 
  end 
  
  def quality=(value)
    if @item.data.is_berry?
	  @item.stats.berry.quality = value 
	else
	 @quality = value 
	end 
    
  end 
  
  def flavor=(value)
    if @item.data.is_berry?
	  @item.stats.berry.flavor = value 
	else
	 @flavor = value 
	end 
  end 
  
  
end 

class PokeBallStats
  attr_accessor :item
  attr_accessor :catch_rate # effects the catch rate of the POKeBALL
  attr_accessor :recoverable # effects if the POKeBALL can be recovered after being thrown, percentage chance of recovery.
  attr_accessor :ease_of_use # effects if this POKeBALL takes up your turn to use while in a Command Battle, and the stamina use on the Overworld, percentage chance of occurance.
  attr_accessor :quality #effects it's price, and the happiness of the POKeMON inside.
  def initialize(item)
    @item = item 
    @catch_rate = get_catch_rate
	@recoverable = 0
	@ease_of_use = 0
	@quality = 1
  end 
  def initialize_copy(original)
    super
  end
    def get_catch_rate
	  return 1 if @item.id==:POKEBALLC
	  return 1.5 if @item.id==:GREATBALLC
	  return 2 if @item.id==:ULTRABALLC
	end
end 


class CaptureStylerStats
  attr_accessor :item
  attr_accessor :health # effects the health of the Capture Styler. If damaged, the durability will decrease and the player will take damage.
  attr_accessor :power # effects the strength of the Capture Styler. The damage inflicted upon the Pokémon for each successful rotation is increased.
  attr_accessor :line # effects  the possible length of the line your Capture Styler leaves behind. The longer the line, the bigger the circles you can use to capture the Pokémon.
  attr_accessor :recovery # effects how much you heal from successfully looping around a Pokemon
  attr_accessor :fading #  makes the line fade slower
   attr_accessor :latent_power  #  effects trigger amount when the Player is low hp (cap at 20)
  #attr_accessor :assists # possible effects for the styler based on pokemon in the team
  def initialize(item)
    @health = 100
    @power = 0
	@line = 0
	@recovery = 0
	@fading = 0
	@latent_power = 0
  end 
  
  def initialize_copy(original)
    super
  end
  def assists
  
  
  end 
end 
