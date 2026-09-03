class EventWorkers
  attr_accessor :event_id
  attr_reader :workers


  def initialize(event_id)
    @workers = []
	@event_id = event_id 
  end 
  
  def length
    @workers.length
  end 
  
  def current_length
    current_workers.length
  end 
  
  def event
    $game_map.events[@event_id]
  end 
  
  def current_workers
     @workers.select do |id|
      worker = $game_map.events[id]
     worker && event.cardinal?(worker) && worker.pokemon && worker.pokemon.is_a?(Pokemon) && worker.pokemon.stamina > 0
    end
  end 
  
  def grant_worker_exp(exp)
    current_workers.each do |id|
      worker = $game_map.events[id]
      worker.pokemon.gain_exp_single(exp)
    end
  end

  def add(id)
    @workers << id 
  end
  
  def remove(id)
    @workers.delete(id)
  end 
  
  def update
  
  end 

end 

class Game_OVEvent < Game_Event
  attr_accessor :event
  attr_writer :type
  attr_accessor :moveable
  attr_accessor :attackable
  attr_accessor :x
  attr_accessor :workers 
  attr_accessor :y
  attr_accessor :spawn_map_id
  attr_accessor :map_id # contains the map_id
  attr_writer :map # contains the original map 

  def initialize(type, map_id, event, map=nil)
    super(map_id, event, map)
    @type  = type
	@event = event
	@spawn_map_id = map_id 
	@map_id = map_id 
	@moveable = false
	@workers = EventWorkers.new(@event.id)
	@attackable = false
  end
  
  def workers
    @workers = EventWorkers.new(@event.id) if @workers.nil?
	return @workers 
  end 
  
  def grant_worker_exp(exp)
    @workers = EventWorkers.new(@event.id) if @workers.nil?
    @workers.grant_worker_exp(exp)
  end
  def station_name
    return "Statue" if @type==:STATUE
    return "Berry Plant" if @type==:BERRYPLANT
	return @type.name if @type.is_a?(ItemData)
	raise 
  end 
  
  def truetype
    @type 
  end 
  
  def internal_data
   return self.variable if @type==:BERRYPLANT || @type==:STATUE
   @type = ItemData.new(@type) if !@type.is_a?(ItemData)
   return @type.internal_data
  
  end 
  
  def pokemon
   return self.variable if @type==:BERRYPLANT || @type==:STATUE
   @type = ItemData.new(@type) if !@type.is_a?(ItemData)
   return @type if @type.is_a?(ItemData)
  end
  alias type pokemon 

  def removeThisEventfromMap
	 if $DynamicEvents.block_data.has_key?(@id) && $DynamicEvents.block_data[@id]==self
	    pbRemoveParticleEffectfromEvent(self)
		pbRemoveLightEffectfromThisEvent(self)
        $DynamicEvents.block_data.delete(@id)
	    $DynamicEvents.update!
	 end 
  end
  
  
  def update
   super
    if $game_map.map_id == self.map_id
    data = internal_data
    if data
	  data.event_id = @event.id if data.event_id.nil? || data.event_id!=@event.id
	  data.update if data.respond_to?(:update)
	end
	workers.event_id = @event.id if workers.event_id.nil? || workers.event_id!=@event.id
	workers.update 
	end 
  end
end


 def get_surrounding_terrain(x,y)
 directions = [
  [-1,  0],  # West
  [ 1,  0],  # East
  [ 0, -1],  # North
  [ 0,  1],  # South
  [-1, -1],  # North-West
  [ 1, -1],  # North-East
  [-1,  1],  # South-West
  [ 1,  1],  # South-East
]
terrain_tags_with_coords = directions.map do |dx, dy|
  sx, sy = x + dx, y + dy
  if $game_map.valid?(sx, sy)
    terrain_tag = $game_map.terrain_tag(sx, sy, true)
    [[sx, sy], terrain_tag]
  else
    nil
  end
end.compact
 return terrain_tags_with_coords
 end

 def any_acceptable_water_tiles_for_hoe(x,y)
  terrains = get_surrounding_terrain(x,y)
   terrains.each do |terrain|
      return true if terrain[1].id == :DeepWater || terrain[1].id == :StillWater || terrain[1].id == :Water
   
   
   end 
 
 
   return false
 end


def pbPlaceBerryPlant(x,y)
  if pbObjectIsPossible(x,y)
  event = $DynamicEvents.generateBerryPlant(x,y)
  return event
  else
  pbMessage(_INTL("You can't farm there!"))
  return nil
  end 
end


class Game_Map


  def generateBerryPlant(x,y)
    event = $DynamicEvents.generateEvent(x,y,object,aat,store,direction)
	return event
  end
  def generateEvent(x,y,object,aat=false,store=false,direction=nil)
    event = $DynamicEvents.generateEvent(x,y,object,aat,store,direction)
	return event.id
  end


end


