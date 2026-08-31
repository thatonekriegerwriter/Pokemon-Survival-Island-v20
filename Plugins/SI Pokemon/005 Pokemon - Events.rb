class Pokemon
  attr_accessor :inworld
  attr_accessor :associatedevent
  attr_accessor :deselecttimer
  attr_accessor :stepcount

  alias _SI_Pokemon_Events_init initialize
  def initialize(*args)
    _SI_Pokemon_Events_init(*args)
    @inworld     = false
    @associatedevent     = nil
    @deselecttimer     = 0
    @stepcount  = 0
	
	
  end
   def stepcount
    @stepcount  = 0 if @stepcount.nil?
    @stepcount
   end 
   def inworld
   @inworld = false if @inworld.nil?
   return @inworld
   end
   
   def event
    return nil if @associatedevent.nil?
    $game_map.events[@associatedevent]
   end 
   alias ovevent event
   
   def associatedevent
   return @associatedevent
   end
   def associated_event=(value)
     @associatedevent = value 
   end 
   
   def associated_event
     self.associatedevent
   end 
   def deselecttimer
    @deselecttimer = 0 if @deselecttimer.nil?
	return @deselecttimer
   end

   def set_in_world(value,event_id=nil)
      event_id = event.id if event_id.is_a?(Game_PokeEventA)
	  self.in_world=value
	  self.associated_event= event_id if event_id
   end
   
   def get_in_world
	 return self.in_world, self.event
   end
   
   
   def in_world
    return @inworld
   end
   def in_world=(value)
    @inworld = value
   end

  def sanitize_in_world
    return unless associatedevent
	self.inworld = !$game_map.events[self.associatedevent].nil?
  end 
  def unavailable?
    return true if self.fainted?
    return true if self.egg?
    return true if self.dead?
    return false 
  end 

end 


EventHandlers.add(:on_step_taken, :pokemon_step_count,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
	next if event.map_id != $game_map.map_id 
    next unless $player.party.any? { |pkmn| pkmn&.event&.equal?(event) }
	pkmn = event.pokemon
	pkmn.stepcount += 1
    pkmn.stepcount &= 0x7FFFFFFF
  }
)