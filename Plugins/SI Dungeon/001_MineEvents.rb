


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

 def invalid_mine_tiles(map_id)
  return [[9,8],[16,8],[9,15],[16,15],[11,15],[12,15],[13,15],[12,14]] if map_id==76 || map_id==18
  return [[9,15],[16,15],[16,8],[16,9],[16,10],[12,14],[15,15],[14,14],[14,15],[13,15]] if map_id==15
  
 
 
 end 
 
 
 
 
 def valid_mine_tiles(map_id)
   return [9,8]
 
 
 end
 
 def main_interior_mining_spots(index)
    return [16,21] if index==0 #6,7
    return [12,37] if index==0 #6,6
    return [20,58] if index==0 #14,12
    return [34,40] if index==0 #12,13
    return [47,51] if index==0 #7,9
    return [59,63] if index==0 #18,12
    return [46,12] if index==0 #10,8
    return [58,7] if index==0 #,11,23
 
 end

 def invalid_mine_tiles2
   return []
 
 
 end 
 
 
EventHandlers.add(:on_enter_map, :setup_mining_spots2,
  proc { |_old_map_id|
    maps = [31]
   next if !maps.include?($game_map.map_id)
   if $PokemonGlobal.mining_spot_timer[$game_map.map_id].nil?
    $PokemonGlobal.mining_spot_timer[$game_map.map_id] = pbGetTimeNow.to_i-3600
   end
   if (pbGetTimeNow.to_i - $PokemonGlobal.mining_spot_timer[$game_map.map_id]) < 3600
    puts "Skip out."
   next 
   end
   	amt = [rand(12),7].max
	amt+=2 if $player.is_it_this_class?(:HIKER)
	ore_type = [:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:GOLDORE,:SILVERORE,:COPPERORE,:COPPERORE,:COPPERORE,
	:COPPERORE,:COAL,:COAL,:COAL,:COAL,:COAL,:FIRESTONE,:WATERSTONE,:THUNDERSTONE,:LEAFSTONE,:MOONSTONE,:DAWNSTONE,:ICESTONE,:SUNSTONE,:OVALSTONE,:EVERSTONE,:LIGHTCLAY,:LIGHTCLAY,:THUNDERSTONE,:HARDSTONE,:EVIOLITE,:EVERSTONE,:STONE,:STONE,:STONE]
    8.times do |i|
    base_x, base_y = main_interior_mining_spots(i)
	 invalid_pos = invalid_mine_tiles2
	  tile = [0,0]
	amt.times do |x|
	  puts x
	 ore = ore_type[rand(ore_type.length)]
	    loop do
	   tile = [(base_x+rand(7)),(base_y+rand(7))]
	     break if !invalid_pos.include?(tile)
	    end
		if tile!=[0,0]
	 pbPlaceOre(tile[0],tile[1],ore) 
	 
	 invalid_pos << tile 
	  end
	end
     end
    $PokemonGlobal.mining_spot_timer[$game_map.map_id] = pbGetTimeNow.to_i
  }
)

EventHandlers.add(:on_enter_map, :setup_mining_spots,
  proc { |_old_map_id|
    maps = [76,15,18]
   next if !maps.include?($game_map.map_id)
   if $PokemonGlobal.mining_spot_timer[$game_map.map_id].nil?
    $PokemonGlobal.mining_spot_timer[$game_map.map_id] = pbGetTimeNow.to_i-3600
   end
   if (pbGetTimeNow.to_i - $PokemonGlobal.mining_spot_timer[$game_map.map_id]) < 3600
    puts "Skip out."
   next 
   end
   	amt = [rand(12),7].max
	amt+=2 if $player.is_it_this_class?(:HIKER)
	ore_type = [:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:IRONORE,:GOLDORE,:SILVERORE,:COPPERORE,:COPPERORE,:COPPERORE,
	:COPPERORE,:COPPERORE,:COPPERORE,:COAL,:COAL,:COAL,:COAL,:COAL,:COAL,:COAL,:COAL,:COAL,:COAL,:HARDSTONE,:HARDSTONE,:HARDSTONE,:HARDSTONE,:EVIOLITE,:EVERSTONE,:STONE,:STONE,:STONE]
    base_x, base_y = [9,8]
	 invalid_pos = invalid_mine_tiles($game_map.map_id)
	  tile = [0,0]
	amt.times do |x|
	 ore = ore_type[rand(ore_type.length)]
	    loop do
	   tile = [(base_x+rand(7)),(base_y+rand(7))]
	     break if !invalid_pos.include?(tile)
	    end
		if tile!=[0,0]
	 pbPlaceOre(tile[0],tile[1],ore) 
	 
	 invalid_pos << tile 
	  end
	end
    $PokemonGlobal.mining_spot_timer[$game_map.map_id] = pbGetTimeNow.to_i
  }
)


class PokemonGlobalMetadata
  attr_accessor :mining_spot_timer
  
  def mining_spot_timer
    @mining_spot_timer = {} if @mining_spot_timer.nil?
    return @mining_spot_timer
  end
  

end