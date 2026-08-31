class Disc
  attr_reader :file_path, :cache, :metadata
  attr_accessor :switches, :variables, :self_switches
  def initialize(file_path, data = nil)
    @file_path = file_path
    @cache = {}
    @metadata = nil

    if data
      @switches = data[:switches]
      @variables = data[:variables]
      @self_switches = data[:self_switches]
    else
      @switches = Game_Switches.new
      @variables = Game_Variables.new
      @self_switches = Game_SelfSwitches.new
    end
	
  end

	def save_values
  	{
  	  switches: @switches,
  	  variables: @variables,
  	  self_switches: @self_switches
 	 }  
	end 
end 


class DiskManager
   attr_reader :current_disk_id
   attr_reader :disks
   attr_accessor :first_load
   
   SYNCRONIZED_SWITCHES=[]
   
   SYNCRONIZED_VARIABLES=[]
   
  def initialize(data = nil)
    @disks = {}
	saved_disks = !data.nil? ? data.disks.transform_values(&:save_values) : {}
	find_disks(saved_disks)
    @current_disk_id = !data.nil? ? data.current_disk_id : 0
	@first_load = false 
  end
  def current_disk
    @disks[@current_disk_id]
  end 
  def find_disks(saved_disks = {})
     @disks[0] = Disc.new("Data/", saved_disks[0])
    Dir.glob("Data/disc*/").each do |folder|
      number = folder[/disc(\d+)/, 1]&.to_i
      @disks[number] = Disc.new(folder, saved_disks[number])
    end
  end 
  
  def mount(disk_id)
    raise "Unknown disk #{disk_id}" unless @disks.key?(disk_id)
    @current_disk_id = disk_id
    disc = @disks[@current_disk_id]
    $game_switches = disc.switches
    $game_variables = disc.variables
    $game_self_switches = disc.self_switches
	disc
  end
  def reloadData(disc = $disk_manager.current_disk)
    pbLoadTownMapData(true)
    pbLoadMapInfos(true)
	reloadTilesets
    GameData::Encounter.load
    GameData::Trainer.load
    GameData::MapMetadata.load
    GameData::DungeonTileset.load
    GameData::DungeonParameters.load
    MapFactoryHelper.clear
    MapFactoryHelper.getMapConnections
  end 
 # def [](key)
 #   get(key)
 # end
  
  def get(filename, disk_id = @current_disk_id)
    disc = @disks[disk_id]
    cache = disc.cache
    return cache[filename] if cache.key?(filename)

    cache[filename] = load(filename, disc)
  end
 
  
  def load(filename, disc = self.current_disk, additive = false)
    return load_additive(filename, disc) if additive
    file_dir = File.join(disc.file_path, filename)
    load_data(file_dir) #if pbRgssExists?(file_dir)
	#nil
  end
  
  def load_additive(filename, disc = self.current_disk)
  puts filename
  combined = {}
  @disks.each_value do |current_disc|
    file_dir = File.join(current_disc.file_path, filename)
    next unless pbRgssExists?(file_dir)

    data = load_data(file_dir)

    data.each do |key, value|
      if combined.key?(key)
        Console.echo_h2("Duplicate data while adding: #{filename} #{key} from #{current_disc.file_path} ignored", text: :red)
        next
      else
        combined[key] = value
      end
    end
  end
  end
  
  def save(data, filename, disc = self.current_disk)
    file_dir = File.join(disc.file_path, filename)
    save_data(data, path(file_dir, disc))
  end
 
  def save_values
    {
      current_disk_id: @current_disk_id,
      disks: @disks.transform_values(&:save_values)
    }
  end 

  def map_id(disc_id, real_map_id)
    raise "Invalid real map ID #{real_map_id}" if real_map_id <= 0
	return  real_map_id if real_map_id >= 1000
    disc_id * 1000 + real_map_id
  end 
  
  def disc(disc_id)
    raise "Unknown disc #{disc_id}" unless @disks.key?(disc_id)
    @disks[disc_id]
  end 
  
  def disc_id(map_id)
    map_id / 1000
  end

  def real_map_id(map_id)
    id = map_id % 1000
    raise "Invalid map ID #{map_id}" if id == 0
	id
  end

end 

SaveData.register(:disk_manager) do
  load_before_compile #load_before_compile?
  ensure_class :DiskManager
  save_value { $disk_manager }
  load_value { |value| $disk_manager = DiskManager.new(value) }
  new_game_value { DiskManager.new }
end

def transfer_disc(transfer_map_id = nil, transfer_x = nil, transfer_y = nil, transfer_direction = nil, disc_id =nil )
  # Setting disc_changing flag
     transfer_map_id ||= $game_map.map_id
   if disc_id
     transfer_map_id = $disk_manager.map_id(disc_id, transfer_map_id)
   else
     disc_id = $disk_manager.disc_id(transfer_map_id)
   end
   $game_temp.disc_changing = true
   disc = $disk_manager.mount(disc_id)
   puts $disk_manager.current_disk
   transfer_x ||= $game_player.x
   transfer_y ||= $game_player.y
   transfer_direction ||= $game_player.direction

  # Set transferring player flag
  $game_temp.player_transferring = true
  # Set player move destination
  $game_temp.player_new_map_id = $disk_manager.real_map_id(transfer_map_id)
  $game_temp.player_new_x = transfer_x
  $game_temp.player_new_y = transfer_y
  $game_temp.player_new_direction = transfer_direction
  
  # Force reload in case the new map ID matches the old one
  puts "Bend"
  puts "MAP ID = #{$game_map.map_id}"
  $disk_manager.reloadData
  #$game_map.refresh
  puts "End"
   $PokemonGlobal.reset_selected_pokemon
    $game_temp.player_transferring = false
    old_map_id = $game_map.map_id
    pbCancelVehicles($game_temp.player_new_map_id, true)
    $scene.autofade($game_temp.player_new_map_id)
    pbBridgeOff
    $scene.spritesetGlobal.playersprite.clearShadows
    if $game_map.map_id != $game_temp.player_new_map_id || $game_temp.disc_changing == true 
      $map_factory.setup($game_temp.player_new_map_id)
    end
    $game_temp.disc_changing=false
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y, true)
    case $game_temp.player_new_direction
    when 2 then $game_player.turn_down
    when 4 then $game_player.turn_left
    when 6 then $game_player.turn_right
    when 8 then $game_player.turn_up
    end
    $game_player.straighten
    $game_temp.followers.map_transfer_followers
    EventHandlers.trigger(:on_map_transfer, old_map_id)
    $game_map.update
    $scene.disposeSpritesets
    RPG::Cache.clear
    $scene.createSpritesets
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      Graphics.transition
    end
    $game_map.autoplay
    Graphics.frame_reset
    Input.update
end 







class Game_Temp
  attr_accessor :disc_changing
end

class Game_Map
  attr_writer :real_map_id
  attr_writer :map_id
  attr_reader :disc_id 
  
  def buildMapEvent(index)
    map_event = @map.events[index]
	if map_event.name[/BerryPlant/i] || map_event.name[/AncientStone/i]
	  type = map_event.name[/BerryPlant/i] ? :BERRYPLANT : :STATUE
      @events[index]          = Game_OVEvent.new(type, @map_id, map_event, self)
	else
      @events[index]          = Game_Event.new(@map_id, map_event, self)
	
	end 
  end 
  
  def setup(map_id, add = false)
   # puts "OLD MAP ID"
  #  puts map_id.to_s
    @real_map_id = $disk_manager.real_map_id(map_id)
	
    @global_map_id = $disk_manager.map_id($disk_manager.current_disk_id, map_id)
    @map_id = @real_map_id
   # puts "CURRENT DISK"
   # puts $disk_manager.current_disk_id
   # puts "MAP ID"
   # puts @map_id.to_s
   # puts "REAL MAP ID"
   # puts @real_map_id.to_s
	raise "Invalid map ID #{@real_map_id}" if @real_map_id == 0
    @map = $disk_manager.load(sprintf("Map%03d.rxdata", @real_map_id))
    @map.create_height_map if @map.height_map.nil?
    #puts @map.instance_variables
    tileset = $data_tilesets[@map.tileset_id]
    updateTileset
    @fog_ox               = 0
    @fog_oy               = 0
    @fog_tone             = Tone.new(0, 0, 0, 0)
    @fog_tone_target      = Tone.new(0, 0, 0, 0)
    @fog_tone_duration    = 0
    @fog_opacity_duration = 0
    @fog_opacity_target   = 0
    self.display_x        = 0
    self.display_y        = 0
    @need_refresh         = false
    EventHandlers.trigger(:on_game_map_setup, @map_id, @map, tileset)
    @events               = EventHash.new
    @map.events.each_key do |i|
      @events[i]          = buildMapEvent(i)
    end
    @common_events        = {}
    (1...$data_common_events.size).each do |i|
      @common_events[i]   = Game_CommonEvent.new(i)
    end
    @scroll_direction     = 2
    @scroll_rest          = 0
    @scroll_speed         = 4
	if add
	$DynamicEvents.events_for_map(map_id).each do |event|
	  next if event.map.object_id == self.object_id
	  event.map = self 
	  event.map_id = map_id
	end 
	end 
  end

  def name
    return pbGetMapNameFromId(@real_map_id)
  end

  def metadata
    return GameData::MapMetadata.try_get(@real_map_id)
  end
end


def pbLoadTownMapData(forced=false)
  $game_temp = Game_Temp.new if !$game_temp
  if !$game_temp.town_map_data || forced
    $game_temp.town_map_data = $disk_manager.load("town_map.dat")
  end
  return $game_temp.town_map_data
end


 def pbLoadMapInfos(forced=false)
  $game_temp = Game_Temp.new if !$game_temp
  if !$game_temp.map_infos || forced
    $game_temp.map_infos = $disk_manager.load("MapInfos.rxdata")
  end
  return $game_temp.map_infos
end

 def reloadTilesets
    $data_tilesets = $disk_manager.load("Tilesets.rxdata")
 
 end 

def pbClearData
  if $game_temp
    $game_temp.town_map_data                 = nil
    $game_temp.phone_messages_data           = nil
    $game_temp.regional_dexes_data           = nil
    $game_temp.battle_animations_data        = nil
    $game_temp.move_to_battle_animation_data = nil
    $game_temp.map_infos                     = nil
  end
  MapFactoryHelper.clear
  $PokemonEncounters.setup($game_map.map_id) if $game_map && $PokemonEncounters
  if pbRgssExists?("Data/Tilesets.rxdata")
    $data_tilesets = $disk_manager.load("Tilesets.rxdata")
  end
end



module MapFactoryHelper
  # Gets the height and width of the map with id
  def self.getMapDims(id)
    # Create cache if doesn't exist
    @@MapDims = [] if !@@MapDims
    # Add map to cache if can't be found
    if !@@MapDims[id]
      begin
        map = $disk_manager.load(sprintf("Map%03d.rxdata", $disk_manager.real_map_id(id)))
        @@MapDims[id] = [map.width, map.height]
      rescue
        @@MapDims[id] = [0, 0]
      end
    end
    # Return map in cache
    return @@MapDims[id]
  end
  def self.getMapConnections
    if !@@MapConnections
      @@MapConnections = []
      conns = $disk_manager.load(sprintf("map_connections.dat"))
      conns.each do |conn|
        # Ensure both maps in a connection are valid
		map_a = conn[0]
		map_b = conn[3]
        dimensions = getMapDims(map_a)
        next if dimensions[0] == 0 || dimensions[1] == 0
        dimensions = getMapDims(map_b)
        next if dimensions[0] == 0 || dimensions[1] == 0
        # Convert first map's edge and coordinate to pair of coordinates
        edge = getMapEdge(map_a, conn[1])
        case conn[1]
        when "N", "S"
          conn[1] = conn[2]
          conn[2] = edge
        when "E", "W"
          conn[1] = edge
        end
        # Convert second map's edge and coordinate to pair of coordinates
        edge = getMapEdge(map_b, conn[4])
        case conn[4]
        when "N", "S"
          conn[4] = conn[5]
          conn[5] = edge
        when "E", "W"
          conn[4] = edge
        end
        # Add connection to arrays for both maps
        @@MapConnections[map_a] = [] if !@@MapConnections[map_a]
        @@MapConnections[map_a].push(conn)
        @@MapConnections[map_b] = [] if !@@MapConnections[map_b]
        @@MapConnections[map_b].push(conn)
      end
    end
    return @@MapConnections
  end

  def self.eachConnectionForMap(id)
    conns = MapFactoryHelper.getMapConnections
    return if !conns[id]
    conns[id].each { |conn| yield conn }
  end

end 

class PokemonMapFactory
  def setMapsInRange
    return if @fixup
    @fixup = true
    id = $game_map.map_id
    MapFactoryHelper.eachConnectionForMap(id) do |conn|
		map_a = conn[0]
		map_b = conn[3]
      if map_a == id
        mapA = getMap(map_a)
        newdispx = ((conn[4] - conn[1]) * Game_Map::REAL_RES_X) + mapA.display_x
        newdispy = ((conn[5] - conn[2]) * Game_Map::REAL_RES_Y) + mapA.display_y
        if hasMap?(map_b) || MapFactoryHelper.mapInRangeById?(map_b, newdispx, newdispy)
          mapB = getMap(map_b)
          mapB.display_x = newdispx if mapB.display_x != newdispx
          mapB.display_y = newdispy if mapB.display_y != newdispy
        end
      else
        mapA = getMap(map_b)
        newdispx = ((conn[1] - conn[4]) * Game_Map::REAL_RES_X) + mapA.display_x
        newdispy = ((conn[2] - conn[5]) * Game_Map::REAL_RES_Y) + mapA.display_y
        if hasMap?(map_a) || MapFactoryHelper.mapInRangeById?(map_a, newdispx, newdispy)
          mapB = getMap(map_a)
          mapB.display_x = newdispx if mapB.display_x != newdispx
          mapB.display_y = newdispy if mapB.display_y != newdispy
        end
      end
    end
    @fixup = false
  end




end 

module ClassMethods
    def load
      const_set(:DATA, $disk_manager.load(self::DATA_FILENAME, $disk_manager.current_disk, self::ADDITIVE || false))
    end

    def save(disk = $disk_manager.current_disk_id)
	  $disk_manager.save(self::DATA, self::DATA_FILENAME)
    end
end 

module ClassMethodsSymbols
    def load
      const_set(:DATA, $disk_manager.load(self::DATA_FILENAME, $disk_manager.current_disk, self::ADDITIVE || false))
    end

    def save(disk = $disk_manager.current_disk_id)
	  $disk_manager.save(self::DATA, self::DATA_FILENAME)
    end

end
  module ClassMethodsIDNumbers
    def load
      const_set(:DATA, $disk_manager.load(self::DATA_FILENAME, $disk_manager.current_disk, self::ADDITIVE || false))
    end

    def save(disk = $disk_manager.current_disk_id)
	  $disk_manager.save(self::DATA, self::DATA_FILENAME)
    end
end 




def pbSetTextMessages
  Graphics.update
  begin
    t = Time.now.to_i
    texts = []
    $RGSS_SCRIPTS.each do |script|
      if Time.now.to_i - t >= 5
        t = Time.now.to_i
        Graphics.update
      end
      scr = Zlib::Inflate.inflate(script[2])
      pbAddRgssScriptTexts(texts, scr)
    end
    if safeExists?("Data/PluginScripts.rxdata")
      plugin_scripts = load_data("Data/PluginScripts.rxdata")
      plugin_scripts.each do |plugin|
        plugin[2].each do |script|
          if Time.now.to_i - t >= 5
            t = Time.now.to_i
            Graphics.update
          end
          scr = Zlib::Inflate.inflate(script[1]).force_encoding(Encoding::UTF_8)
          pbAddRgssScriptTexts(texts, scr)
        end
      end
    end
    # Must add messages because this code is used by both game system and Editor
    MessageTypes.addMessagesAsHash(MessageTypes::ScriptTexts, texts)
    commonevents = load_data("Data/CommonEvents.rxdata")
    items = []
    choices = []
    commonevents.compact.each do |event|
      if Time.now.to_i - t >= 5
        t = Time.now.to_i
        Graphics.update
      end
      begin
        neednewline = false
        lastitem = ""
        event.list.size.times do |j|
          list = event.list[j]
          if neednewline && list.code != 401
            if lastitem != ""
              lastitem.gsub!(/([^\.\!\?])\s\s+/) { |m| $1 + " " }
              items.push(lastitem)
              lastitem = ""
            end
            neednewline = false
          end
          if list.code == 101
            lastitem += list.parameters[0].to_s
            neednewline = true
          elsif list.code == 102
            list.parameters[0].length.times do |k|
              choices.push(list.parameters[0][k])
            end
            neednewline = false
          elsif list.code == 401
            lastitem += " " if lastitem != ""
            lastitem += list.parameters[0].to_s
            neednewline = true
          elsif list.code == 355 || list.code == 655
            pbAddScriptTexts(items, list.parameters[0])
          elsif list.code == 111 && list.parameters[0] == 12
            pbAddScriptTexts(items, list.parameters[1])
          elsif list.code == 209
            route = list.parameters[1]
            route.list.size.times do |k|
              if route.list[k].code == 45
                pbAddScriptTexts(items, route.list[k].parameters[0])
              end
            end
          end
        end
        if neednewline && lastitem != ""
          items.push(lastitem)
          lastitem = ""
        end
      end
    end
    if Time.now.to_i - t >= 5
      t = Time.now.to_i
      Graphics.update
    end
    items |= []
    choices |= []
    items.concat(choices)
    MessageTypes.setMapMessagesAsHash(0, items)
    mapinfos = pbLoadMapInfos
    mapinfos.each_key do |id|
      if Time.now.to_i - t >= 5
        t = Time.now.to_i
        Graphics.update
      end
      map = $disk_manager.load(sprintf("Map%03d.rxdata", $disk_manager.real_map_id(id)))
	  next unless map
      items = []
      choices = []
      map.events.each_value do |event|
        if Time.now.to_i - t >= 5
          t = Time.now.to_i
          Graphics.update
        end
        begin
          event.pages.size.times do |i|
            neednewline = false
            lastitem = ""
            event.pages[i].list.size.times do |j|
              list = event.pages[i].list[j]
              if neednewline && list.code != 401
                if lastitem != ""
                  lastitem.gsub!(/([^\.\!\?])\s\s+/) { |m| $1 + " " }
                  items.push(lastitem)
                  lastitem = ""
                end
                neednewline = false
              end
              if list.code == 101
                lastitem += list.parameters[0].to_s
                neednewline = true
              elsif list.code == 102
                list.parameters[0].length.times do |k|
                  choices.push(list.parameters[0][k])
                end
                neednewline = false
              elsif list.code == 401
                lastitem += " " if lastitem != ""
                lastitem += list.parameters[0].to_s
                neednewline = true
              elsif list.code == 355 || list.code == 655
                pbAddScriptTexts(items, list.parameters[0])
              elsif list.code == 111 && list.parameters[0] == 12
                pbAddScriptTexts(items, list.parameters[1])
              elsif list.code == 209
                route = list.parameters[1]
                route.list.size.times do |k|
                  if route.list[k].code == 45
                    pbAddScriptTexts(items, route.list[k].parameters[0])
                  end
                end
              end
            end
            if neednewline && lastitem != ""
              items.push(lastitem)
              lastitem = ""
            end
          end
        end
      end
      if Time.now.to_i - t >= 5
        t = Time.now.to_i
        Graphics.update
      end
      items |= []
      choices |= []
      items.concat(choices)
      MessageTypes.setMapMessagesAsHash(id, items)
      if Time.now.to_i - t >= 5
        t = Time.now.to_i
        Graphics.update
      end
    end
  rescue Hangup
  end
  Graphics.update
end


def createMinimap(mapid)
  map = $disk_manager.load(sprintf("Map%03d.rxdata", $disk_manager.real_map_id(mapid))) rescue nil
  return BitmapWrapper.new(32, 32) if !map
  bitmap = BitmapWrapper.new(map.width * 4, map.height * 4)
  black = Color.black
  tilesets = $data_tilesets
  tileset = tilesets[map.tileset_id]
  return bitmap if !tileset
  helper = TileDrawingHelper.fromTileset(tileset)
  map.height.times do |y|
    map.width.times do |x|
      3.times do |z|
        id = map.data[x, y, z]
        id = 0 if !id
        helper.bltSmallTile(bitmap, x * 4, y * 4, 4, 4, id)
      end
    end
  end
  bitmap.fill_rect(0, 0, bitmap.width, 1, black)
  bitmap.fill_rect(0, bitmap.height - 1, bitmap.width, 1, black)
  bitmap.fill_rect(0, 0, 1, bitmap.height, black)
  bitmap.fill_rect(bitmap.width - 1, 0, 1, bitmap.height, black)
  return bitmap
end

def getPassabilityMinimap(mapid)
  map = $disk_manager.load(sprintf("Map%03d.rxdata", $disk_manager.real_map_id(mapid))) rescue nil
  tileset = $data_tilesets[map.tileset_id]
  minimap = AnimatedBitmap.new("Graphics/UI/minimap_tiles")
  ret = Bitmap.new(map.width * 6, map.height * 6)
  passtable = Table.new(map.width, map.height)
  passages = tileset.passages
  map.width.times do |i|
    map.height.times do |j|
      pass = true
      [2, 1, 0].each do |z|
        if !passable?(passages, map.data[i, j, z])
          pass = false
          break
        end
      end
      passtable[i, j] = pass ? 1 : 0
    end
  end
  neighbors = TileDrawingHelper::NEIGHBORS_TO_AUTOTILE_INDEX
  map.width.times do |i|
    map.height.times do |j|
      next if passtable[i, j] != 0
      nb = TileDrawingHelper.tableNeighbors(passtable, i, j)
      tile = neighbors[nb]
      bltMinimapAutotile(ret, i * 6, j * 6, minimap.bitmap, tile)
    end
  end
  minimap.dispose
  return ret
end

#===============================================================================
# Blacking out animation
#===============================================================================
def pbStartOver(gameover = false)
  if pbInBugContest?
    pbBugContestStartOver
    return
  end
  $stats.blacked_out_count += 1
  $player.heal_party
  if $PokemonGlobal.pokecenterMapId && $PokemonGlobal.pokecenterMapId >= 0
    if gameover
      pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]After your defeat, you scurry back to the nearest shelter."))
    else
      pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]After you got away, you run back to the nearest shelter."))
    end
    pbCancelVehicles
    Followers.clear
    $game_switches[Settings::STARTING_OVER_SWITCH] = true
    $game_temp.player_new_map_id    = $PokemonGlobal.pokecenterMapId
    $game_temp.player_new_x         = $PokemonGlobal.pokecenterX
    $game_temp.player_new_y         = $PokemonGlobal.pokecenterY
    $game_temp.player_new_direction = $PokemonGlobal.pokecenterDirection
    pbDismountBike
    $scene.transfer_player if $scene.is_a?(Scene_Map)
    $game_map.refresh
  else
    homedata = GameData::PlayerMetadata.get($player.character_ID)&.home
    homedata = GameData::Metadata.get.home if !homedata
    if gameover
      pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]After you got away, you run back to the nearest shelter."))
    else
      pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]After you got away, you run back to the nearest shelter."))
    end
    if homedata
      pbCancelVehicles
      Followers.clear
      $game_switches[Settings::STARTING_OVER_SWITCH] = true
      $game_temp.player_new_map_id    = homedata[0]
      $game_temp.player_new_x         = homedata[1]
      $game_temp.player_new_y         = homedata[2]
      $game_temp.player_new_direction = homedata[3]
      pbDismountBike
      $scene.transfer_player if $scene.is_a?(Scene_Map)
      $game_map.refresh
    else
      $player.heal_party
    end
  end
  pbEraseEscapePoint
end
#===============================================================================
# Method to get phone call data.
#===============================================================================
def pbLoadPhoneData
  $game_temp = Game_Temp.new if !$game_temp
  if !$game_temp.phone_messages_data && pbRgssExists?("Data/phone.dat")
    $game_temp.phone_messages_data = $disk_manager.load("phone.dat", $disk_manager.current_disc, true)
  end
  return $game_temp.phone_messages_data
end


module GameData
  class Type
    ADDITIVE = true
  end 
  class Ability
    ADDITIVE = true
  end 
  class Move
    ADDITIVE = true
  end 
  class Item
    ADDITIVE = true
  end 
  class BerryPlant
    ADDITIVE = true
  end 
  class Species
    ADDITIVE = true
  end 
  class SpeciesMetrics
    ADDITIVE = true
  end 
  class ShadowPokemon
    ADDITIVE = true
  end 
  class Ribbon
    ADDITIVE = true
  end 
  class TrainerType
    ADDITIVE = true
  end 

end 

module Game
  def self.initialize
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $data_animations    = load_data("Data/Animations.rxdata")
    $data_tilesets      = $disk_manager.load("Tilesets.rxdata")
    $data_common_events = $disk_manager.load("CommonEvents.rxdata")
    $data_system        = load_data("Data/System.rxdata")
    pbLoadBattleAnimations
    GameData.load_all
    map_file = $disk_manager.load(sprintf("Map%03d.rxdata", $data_system.start_map_id))
    if $data_system.start_map_id == 0
      raise _INTL("No starting position was set in the map editor.")
    end


end 
end

class Scene_Map
  def autofade(mapid)
    playingBGM = $game_system.playing_bgm
    playingBGS = $game_system.playing_bgs
    return if !playingBGM && !playingBGS
	map = $disk_manager.load(sprintf("Map%03d.rxdata", $disk_manager.real_map_id(mapid)))
    if playingBGM && map.autoplay_bgm
      if (PBDayNight.isNight? && FileTest.audio_exist?("Audio/BGM/" + map.bgm.name + "_n") &&
         playingBGM.name != map.bgm.name + "_n") || playingBGM.name != map.bgm.name
        pbBGMFade(0.8)
      end
    end
    if playingBGS && map.autoplay_bgs && playingBGS.name != map.bgs.name
      pbBGMFade(0.8)
    end
    Graphics.frame_reset
  end
end