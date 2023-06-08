#===============================================================================
# * Upgradeable Maps - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It copies tiles of map chunks from a
# map into other map when a switch is ON.
#
#== INSTALLATION ===============================================================
#
# Put it above main OR convert into a plugin. Before first line 
# 'tileset = $data_tilesets[@map.tileset_id]' at Game_Map script section, add 
# line 'UpgradeableMaps.process(@map, map_id)'
#
#=== HOW TO USE ================================================================
#
# Add more entries following the examples at 'def self.getAllChunks' below.
#
#===============================================================================

if defined?(PluginManager) && !PluginManager.installed?("Upgradeable Maps")
  PluginManager.register({                                                 
    :name    => "Upgradeable Maps",                                        
    :version => "1.1",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=496862",             
    :credits => "FL"
  })
end

module UpgradeableMaps
  # Add map entries here
  def self.getAllChunks
    return [
      # Entry.new(map id, increment version map id, switch, x range, y range),
      # The below code line means Oak Lab will be copied into Daisy's House when 
      # switch 80 was ON.
      Chunk.new(DAISY_HOUSE, OAK_LAB, 80, 0..1, 0..2),
      # The below line means same thing, but using other coordinates
      Chunk.new(DAISY_HOUSE, OAK_LAB, 80, 11..12, 0..2),
    ]
  end

  # I suggest putting the Map IDs here, to make easier to edit but this is
  # optional
  OAK_LAB = 4
  DAISY_HOUSE = 8

  class Chunk
    attr_reader :to_paste_map_id
    attr_reader :to_copy_map_id
    attr_reader :switch_number

    def initialize(to_paste_map_id,to_copy_map_id,switch_number,x_range,y_range)
      @to_paste_map_id = to_paste_map_id
      @to_copy_map_id = to_copy_map_id
      @switch_number = switch_number
      @x_range = x_range
      @y_range = y_range
    end

    def add_tiles(to_paste_map, to_copy_map)
      for x in @x_range
        for y in @y_range
          for l in [2, 1, 0]
            to_paste_map.data[x,y,l] = to_copy_map.data[x,y,l] 
          end
        end
      end
    end
  end

  def self.process(map, map_id)
    extra_map_hash = {}
    for chunk in getAllChunks
      next if map_id != chunk.to_paste_map_id
      next if !$game_switches[chunk.switch_number]
      if !extra_map_hash.has_key?(chunk.to_copy_map_id)
        extra_map_hash[chunk.to_copy_map_id] = load_data(
          sprintf("Data/Map%03d.rxdata", chunk.to_copy_map_id)
        )
      end
      chunk.add_tiles(map, extra_map_hash[chunk.to_copy_map_id])
    end
  end
end