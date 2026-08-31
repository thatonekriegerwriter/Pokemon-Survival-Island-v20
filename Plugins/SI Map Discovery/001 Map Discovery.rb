module GameData
  class MapMetadata
    attr_reader :map_start
    attr_reader :map_end
    attr_reader :map_radius
	SCHEMA["MapStart"] = [25, "uu"]
	SCHEMA["MapEnd"] = [26, "uu"]
	SCHEMA["MapRadius"] = [27, "u"]
	alias old_init_mapmetadata initialize
	def initialize(hash)
	  old_init_mapmetadata(hash)
      @map_start   = hash[:map_start]
      @map_end             = hash[:map_end]
      @map_radius      = hash[:map_radius] || 4
	  
	  
	end 
	
	def world_x1
	  @map_start[0]
	end 
	def world_y1
	  @map_start[1]
	end 
	def world_x2
	  @map_end[0]
	end 
	def world_y2
	  @map_end[1]
	end 
	
	def get_world_map_data
	{
       :world_x1 => @map_start[0],
       :world_y1 => @map_start[1],
       :world_x2 => @map_end[0],
       :world_y2 => @map_end[1],
       :radius   => 6#@map_radius
     }
	end 
  end
  
  
end 

#===============================================================================
# World Map Discovery
#===============================================================================
module WorldMapDiscovery
  WIDTH  = 480
  HEIGHT = 320

  #   5 => {
  #     :world_x1 => 213,
   #    :world_y1 => 246,
  #     :world_x2 => 230,
   #    :world_y2 => 264,
  #     :radius   => 2
  #   }
  #--------------------------------------------------------------------------
  # Get the discovery definition for the current map.
  #--------------------------------------------------------------------------
  def self.map_data(map_id)
     map = GameData::MapMetadata.try_get(map_id)
     return nil if !map
     return nil if !map.map_start || !map.map_end
	 return map.get_world_map_data
  end

  #--------------------------------------------------------------------------
  # Convert the player's position on the current game map into a position
  # on the 480x320 world map.
  #--------------------------------------------------------------------------
  def self.player_world_position
    data = map_data($game_map.map_id)
    return nil if !data

    # Fixed-position maps, such as interiors.
    if data[:world_x] && data[:world_y]
      return [data[:world_x], data[:world_y]]
    end

    # Maps which occupy a rectangle on the world map.
    return nil if !data[:world_x1] || !data[:world_y1]
    return nil if !data[:world_x2] || !data[:world_y2]

    map_width  = [$game_map.width - 1, 1].max
    map_height = [$game_map.height - 1, 1].max

    ratio_x = $game_player.x.to_f / map_width
    ratio_y = $game_player.y.to_f / map_height

    world_x = data[:world_x1] +
              ((data[:world_x2] - data[:world_x1]) * ratio_x)

    world_y = data[:world_y1] +
              ((data[:world_y2] - data[:world_y1]) * ratio_y)

    return [world_x.floor, world_y.floor]
  end

  #--------------------------------------------------------------------------
  # Reveals a circular area around a world-map position.
  #--------------------------------------------------------------------------
  def self.reveal(x, y, radius)
    discovery = $PokemonGlobal.world_map_discovery
    radius_sq = radius * radius

    min_x = [x - radius, 0].max
    max_x = [x + radius, WIDTH - 1].min
    min_y = [y - radius, 0].max
    max_y = [y + radius, HEIGHT - 1].min

    (min_y..max_y).each do |py|
      (min_x..max_x).each do |px|
        dx = px - x
        dy = py - y
        next if (dx * dx + dy * dy) > radius_sq

        discovery[py][px] = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # Reveals the player's current location.
  #--------------------------------------------------------------------------
  def self.discover_player_position
    position = player_world_position
    return if !position

    data = map_data($game_map.map_id)
    return nil if !data
    radius = data[:radius] || 4

    reveal(position[0], position[1], radius)
  end

  #--------------------------------------------------------------------------
  # Build the visual mask used by the map screen.
  #--------------------------------------------------------------------------
  def self.create_mask(bitmap)
  sepia = Bitmap.new("Graphics/Pictures/Maps/islandSepia")
  bitmap.clear
  bitmap.blt(
    0, 0,
    sepia,
    Rect.new(0, 0, WIDTH, HEIGHT)
  )

  sepia.dispose
  
    discovery = $PokemonGlobal.world_map_discovery
    return bitmap if !discovery

        HEIGHT.times do |y|
      WIDTH.times do |x|
        next if !discovery[y][x]

        bitmap.set_pixel(
          x,
          y,
          Color.new(120, 100, 70, 0)
        )
      end
    end


    return bitmap
  end
end

class PokemonGlobalMetadata
  attr_accessor :world_map_discovery

  alias world_map_discovery_initialize initialize
  def initialize
    world_map_discovery_initialize
    @world_map_discovery = Array.new(WorldMapDiscovery::HEIGHT) do
      Array.new(WorldMapDiscovery::WIDTH, false)
    end
  end
  
  def world_map_discovery
   if @world_map_discovery.nil?
   
    @world_map_discovery = Array.new(WorldMapDiscovery::HEIGHT) do
      Array.new(WorldMapDiscovery::WIDTH, false)
    end
   end
   @world_map_discovery
  end 
end