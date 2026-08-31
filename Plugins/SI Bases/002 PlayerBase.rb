class WorldBases
  def initialize
    @bases = {}
  end 
  
  def register(base)
    return nil if has?(base.id)
    @bases[base.id] = base
	return base
  end 
  
  def [](id)
    @bases[id]
  end 
  
  def has?(id)
    @bases.key?(id)
  end 
  
  def each(&block)
    @bases.each_value(&block)
  end
  
  def update
    @bases.each_value(&:update)
  end 
  
  def ongoing_raid?
    @bases.any? { |base| base.ongoing_raid? }
  end 
end 

SaveData.register(:world_bases) do
  ensure_class :WorldBases
  save_value { $bases }
  load_value { |value| $bases = value }
  new_game_value { WorldBases.new }
end

class PlayerBase
  attr_reader :id
  attr_reader :time_last_updated
  attr_reader :ongoing_raid
  attr_reader :pokemon
  attr_reader :blockdata

  def initialize(id)
    @id = id
    @pokemon = []
	@blockdata = []
	@ongoing_raid = nil
	@time_last_updated = pbGetTimeNow.to_i
  end
  
  def data
    GameData::Base.try_get(@id)
  end 
  def maps
    data.indoor_maps + data.outdoor_maps
  end
  def player_present?
   return true if maps.include?($game_player.map_id)
   return false
  end
  
  def can_start_raid?
    return false if player_present?
    return false if ongoing_raid?
	return true 
  end 
  
  def ongoing_raid?
    !@ongoing_raid.nil?
  end 
  
  def self.create(id)
    base = new(id)
    base = $bases.register(base)
    return base
  end 
  
  def begin_raid
     return unless can_start_raid?
  end 
  
  def end_raid
    @ongoing_raid.cleanup
    @ongoing_raid = nil
  end 

  def each_pokemon(&block)
    @pokemon.each(&block)
  end

  def add_pokemon(event_id)
    @pokemon << event_id unless @pokemon.include?(event_id)
  end

  def remove_pokemon(event_id)
    @pokemon.delete(event_id)
  end
  def add_block(event_id)
    @blockdata << event_id unless @blockdata.include?(event_id)
  end

  def remove_block(event_id)
    @blockdata.delete(event_id)
  end

  def each_block(&block)
    @blockdata.each(&block)
  end 
  def update_blockdata(time_delta)
    each_block do |blockdata|
	  blockdata.update(time_delta)
	end 
  end 
  def update_pokemon(time_delta)
    each_pokemon do |pokemon_event|
	  pokemon_event.update(time_delta)
	end 
  end 
  
  
  def update
    current_time = pbGetTimeNow.to_i
    time_delta = current_time - @time_last_updated
    return if time_delta <= 0
    @blockdata.update(time_delta)
    update_blockdata(time_delta)
    update_pokemon(time_delta)
    @ongoing_raid&.update(time_delta)
    @time_last_updated = current_time
  end 
  

end 

def pbWorldBasesAdd(id)
  return $bases[id] if $bases.has?[id]
  base = PlayerBase.new(id)
  $bases.register(base)
  base
end 

