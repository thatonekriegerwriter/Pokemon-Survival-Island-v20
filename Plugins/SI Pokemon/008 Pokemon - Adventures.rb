class Pokemon
  attr_reader :adventure_log #An array that logs what the POKeMON has done while adventuring.
  attr_accessor :IQ #A list of learned types and focuses for how a POKeMON adventures.
  attr_accessor :chosenIQ #The chosen type in adventuringTypes
  attr_reader :traveling_partners
  attr_accessor :in_dungeon
  attr_accessor :steps_taken
  attr_accessor :on_adventure
  attr_accessor :time_spent
  attr_accessor :just_arrived #has another with it.
  attr_accessor :called_back #has another with it.
  attr_accessor :hidden_modifiers
  attr_accessor :called_back_map
  
  

  alias _SI_Adventures_init initialize
  def initialize(*args)
    _SI_Adventures_init(*args)
	@on_adventure = false 
	@adventure_log = []
    @IQ      = ["None"]
	@chosenIQ = 0
	@current_map = nil 
	@steps_taken = 0
    @traveling_partners = []
    @in_dungeon      = false
	@offscreen_fight = nil #Formally "Who Fighting" going to make a proper class to sim battles.
	@time_spent = 0
	@just_arrived = false
	@called_back = nil
  end
  
  def travels_with_egg?
    ret = false 
    @traveling_partners.each do |pkmn|
	  next if !pkmn.egg?
	  ret = true
	end 
	return ret 
  end 
  
  def in_fight?
    return !@offscreen_fight.nil?
  end 
  
  def current_fight
    @offscreen_fight
  end 

  def setup_fight(targets)
    return false if in_fight?
  end 
  
  def called_back?
    return !@called_back.nil?
  end 
  
   def called_back_map
    @called_back_map  = $game_map.map_id if @called_back_map.nil?
    return @called_back_map
   end
   
   def hidden_modifiers
    @hidden_modifiers = [] if @hidden_modifiers.nil?
    return @hidden_modifiers
   end
end