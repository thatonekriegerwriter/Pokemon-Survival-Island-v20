


class Game_MineEvent < Game_Event
  attr_accessor :event
  attr_accessor :type

  def initialize(type, map_id, event, map=nil)
    super(map_id, event, map)
    @type  = type
  end
  def type=(value)
    @type = value
  end
  def type
    return @type
  end
end

 
  module MiningSpots
  
  class << self 
  
   def setup
     map_id = $game_map.map_id
	 minedata = GameData::Mine.try_get(map_id)
	 if minedata
       ensure_timer(minedata, map_id)
	   return if (pbGetTimeNow.to_i - $PokemonGlobal.mining_spot_timer[map_id]) < minedata.timer
	   max_spots = minedata.max_mining_spots
	   max_spots += 2 if $player.is_it_this_class?(:HIKER)
	   min_spots = minedata.min_mining_spots
	   minedata.area_amt.times do |i|
	      spots = ([[rand(minedata.roll_times) + 1, max_spots].min, min_spots].max).to_i
          base_x, base_y = minedata.offset_for(i)
          tile_distance = minedata.distance_for(i)
	      invalid_pos = []
	      tile = nil
	      spots.times do |j|
		    ore = get_ore(minedata)
			loop_amt = 0
            loop do
	         tile = [(base_x + rand(tile_distance)), (base_y + rand(tile_distance))]
		  	 next if !minedata.valid_tile?(tile[0], tile[1])
	         break if !invalid_pos.include?(tile)
			 break if loop_amt>50
			 loop_amt += 1
            end
            if tile
			  pbPlaceOre(tile[0], tile[1], ore) 
	          invalid_pos << tile 
			
			end 
		  end
	   end 
	    $PokemonGlobal.mining_spot_timer[map_id] = pbGetTimeNow.to_i + rand(-minedata.rnd_amt..minedata.rnd_amt)
	 end 
   end
 
  
  def ensure_timer(minedata, map_id)
   if $PokemonGlobal.mining_spot_timer[map_id].nil?
    $PokemonGlobal.mining_spot_timer[map_id] = pbGetTimeNow.to_i-minedata.timer
   end
 end 


  
  def get_ore(minedata)
	rarity = weighted_random([[:common_rewards, 70], [:uncommon_rewards, 25], [:rare_rewards, 5]])
	ores = minedata.send(rarity)
	return weighted_random(ores)
  end 

def weighted_random(weights)
  total = weights.sum { |_, weight| weight }
  roll = rand(total)

  weights.each do |item, weight|
    return item if roll < weight
    roll -= weight
  end
end
 end 
 end 
 
 
 

EventHandlers.add(:on_enter_map, :setup_mining_spots,
  proc { |_old_map_id|
    MiningSpots.setup
  }
)







if false
EventHandlers.add(:on_leave_map, :delete_mining_spots,
  proc { |new_map_id, new_map|
    maps = [71,76,15,18,31]
   next if !maps.include?($game_map.map_id)
  $DynamicEvents.delete_events_for_map
  }
)
end 

class PokemonGlobalMetadata
  attr_accessor :mining_spot_timer
  
  def mining_spot_timer
    @mining_spot_timer = {} if @mining_spot_timer.nil?
    return @mining_spot_timer
  end
  

end