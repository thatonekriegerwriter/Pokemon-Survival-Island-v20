#==============================================================================#
#                              Map Exporter                                    #
#                                by Marin                                      #
#==============================================================================#
# Manually export a map using `pbExportMap(id)`, or go into the Debug menu and #
#            choose the `Export a Map` option that is now in there.            #
#                                                                              #
#  `pbExportMap(id, options)`, where `options` is an array that can contain:   #
#       - :events  ->  This will also export all events present on the map     #
#       - :player  ->  This will also export the player if they're on that map #
#  `id` can be nil, which case it will use the current map the player is on.   #
#==============================================================================#
#                    Please give credit when using this.                       #
#==============================================================================#

# This is where the map will be exported to once it has been created.
# If this file already exists, it is overwritten.
EXPORTED_FILENAME = "exported.png"

def pbExportAllTheMaps
 @temperate_forest = [5,4,243,300,7,349,350,8,9,13,45,54,47,282,44,68]
 @temperate_highlands=[16,24,31,19,30,29,28,17]
 @temperate_marsh=[33,34,35,109,26,218,233]
 @deep_marsh=[36,84,86,110,140,44,68]
 @frigid_highlands=[71,72,77,73,78,80,74,85,82]
 @deep_caves=[197,163,211]
 @tropical_coast=[111,130,131,158,138,132,159,142,133,160,161,134]
 @ssglittering=[101,102,103,116,117,118,119,120,121,122,123,125,126,127,128,129,124]
 @temperate_ocean=[48,62,38,39,58,59,57,60,61,53,234,235,236,42,144,137,43,385,387,392,396,397]
 @deep_forest=[200,201,204,202,203,244,205]
 @northern_highlands=[207,208,157,237,238,313,315,311,312,209]
 @western_shores=[205,295,296,308,302,310,307,309]
 @western_temperate=[318,319,320,323,325,326,330,331,327,328,329]
 @western_caves=[332,217,22,2]
 @western_jungle=[338,354,335,356,357]
 @oil_tanker=[141,143]
 @ravine=[81]
 @map_types = [@temperate_forest,@temperate_highlands,@temperate_marsh,@deep_marsh,@frigid_highlands,@deep_caves,@tropical_coast,@ssglittering,@temperate_ocean,@deep_forest,@northern_highlands,@western_shores,@western_temperate,
 @western_caves,@western_jungle,@oil_tanker,@ravine] 
	puts "======================================================="
 @map_types.each do |sub_type|
  sub_type.each do |map_id|
  MarinMapExporter.new(map_id, [:events])
  end
 end
 
	puts "FINISHED ENTIRELY."
end

def pbExportMap(id = nil, options = [])
  MarinMapExporter.new(id, options)
end


def pbExportAMap
  vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
  vp.z = 99999
  s = Sprite.new(vp)
  s.bitmap = Bitmap.new(Graphics.width, Graphics.height)
  s.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(0,0,0))
  mapid = pbListScreen(_INTL("Export Map"),MapLister.new(pbDefaultMap))
  if mapid > 0
    player = $game_map.map_id == mapid
    if player
      cmds = ["Export", "[  ] Events", "[  ] Player", "Cancel"]
    else
      cmds = ["Export", "[  ] Events", "Cancel"]
    end
    cmd = 0
    loop do
      cmd = pbShowCommands(nil,cmds,-1,cmd)
      if cmd == 0
        Graphics.update
        options = []
        options << :events if cmds[1].split("")[1] == "X"
        options << :player if player && cmds[2].split("")[1] == "X"
        msgwindow = Window_AdvancedTextPokemon.newWithSize(
            _INTL("Saving... Please be patient."),
            0, Graphics.height - 96, Graphics.width, 96, vp
        )
        msgwindow.setSkin(MessageConfig.pbGetSpeechFrame)
        Graphics.update
        pbExportMap(mapid, options)
        msgwindow.setText(_INTL("Successfully exported the map."))
        60.times { Graphics.update; Input.update }
        pbDisposeMessageWindow(msgwindow)
        break
      elsif cmd == 1
        if cmds[1].split("")[1] == " "
          cmds[1] = "[X] Events"
        else
          cmds[1] = "[  ] Events"
        end
      elsif cmd == 2 && player
        if cmds[2].split("")[1] == " "
          cmds[2] = "[X] Player"
        else
          cmds[2] = "[  ] Player"
        end
      elsif cmd == 3 || cmd == 2 && !player || cmd == -1
        break
      end
    end
  end
  s.bitmap.dispose
  s.dispose
  vp.dispose
end

MenuHandlers.add(:debug_menu, :exportmap, {
  "name"        => "Export a Map",
  "parent"      => :field_menu,
  "description" => "Choose a map to export it as a PNG.",
  "effect"      => proc { |sprites, viewport| pbExportAMap }
})

MenuHandlers.add(:debug_menu, :exportmap2, {
  "name"        => "Export all Map",
  "parent"      => :field_menu,
  "description" => "Choose a map to export it as a PNG.",
  "effect"      => proc { |sprites, viewport| pbExportAllTheMaps }
})

class MarinMapExporter
  def initialize(id = nil, options = [])
    @id = id || $game_map.map_id
	return if pbLoadMapInfos[id].nil?
	puts "BEGINNING EXPORT OF #{pbLoadMapInfos[@id].name.upcase} (#{@id})" 
    @options = options
    @data = load_data("Data/Map#{@id.to_digits}.rxdata")
    @tiles = @data.data
    @result = Bitmap.new(32 * @tiles.xsize, 32 * @tiles.ysize)
    @tilesetdata = load_data("Data/Tilesets.rxdata")
    tilesetname = @tilesetdata[@data.tileset_id].tileset_name
    @tileset = Bitmap.new("Graphics/Tilesets/#{tilesetname}")
    @autotiles = @tilesetdata[@data.tileset_id].autotile_names
        .filter { |e| e && e.size > 0 }
        .map { |e| Bitmap.new("Graphics/Autotiles/#{e}") }
    for z in 0..2
      for y in 0...@tiles.ysize
        for x in 0...@tiles.xsize
          id = @tiles[x, y, z]
          next if id == 0
          if id < 384 # Autotile
            build_autotile(@result, x * 32, y * 32, id)
          else # Normal tile
            @result.blt(x * 32, y * 32, @tileset,
                Rect.new(32 * ((id - 384) % 8),32 * ((id - 384) / 8).floor,32,32))
          end
        end
      end
    end
    if @options.include?(:events) && false
      keys = @data.events.keys.sort { |a, b| @data.events[a].y <=> @data.events[b].y }
      keys.each do |id|
        event = @data.events[id]
        page = pbGetActiveEventPage(event, @id)
        if page && page.graphic && page.graphic.character_name && page.graphic.character_name.size > 0
          bmp = Bitmap.new("Graphics/Characters/#{page.graphic.character_name}")
          if bmp
            bmp = bmp.clone
            bmp.hue_change(page.graphic.character_hue) unless page.graphic.character_hue == 0
            ex = bmp.width / 4 * page.graphic.pattern
            ey = bmp.height / 4 * (page.graphic.direction / 2 - 1)
            @result.blt(event.x * 32 + 16 - bmp.width / 8, (event.y + 1) * 32 - bmp.height / 4, bmp,
                Rect.new(ex, ey, bmp.width / 4, bmp.height / 4))
          end
          bmp = nil
        end
      end
    end
    if @options.include?(:player) && $game_map.map_id == @id && $game_player.character_name &&
       $game_player.character_name.size > 0 && false
      bmp = Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
      dir = $game_player.direction
      @result.blt($game_player.x * 32 + 16 - bmp.width / 8, ($game_player.y + 1) * 32 - bmp.height / 4,
          bmp, Rect.new(0, bmp.height / 4 * (dir / 2 - 1), bmp.width / 4, bmp.height / 4))
    end
	puts "FINISHING EXPORT OF #{pbLoadMapInfos[@id].name.upcase} (#{@id})"
    @result.save_to_png("maps/#{@id}.png")
	puts "FINISHED EXPORT OF #{pbLoadMapInfos[@id].name.upcase} (#{@id})" 
	puts "=======================================================" 
    Input.update
  end
  
  def build_autotile(bitmap, x, y, id)
    autotile = @autotiles[id / 48 - 1]
    return unless autotile
    if autotile.height == 32
      bitmap.blt(x,y,autotile,Rect.new(0,0,32,32))
    else
      id %= 48
      tiles = TileDrawingHelper::AUTOTILE_PATTERNS[id >> 3][id & 7]
      src = Rect.new(0,0,0,0)
      halfTileWidth = halfTileHeight = halfTileSrcWidth = halfTileSrcHeight = 32 >> 1
      for i in 0...4
        tile_position = tiles[i] - 1
        src.set((tile_position % 6) * halfTileSrcWidth,
           (tile_position / 6) * halfTileSrcHeight, halfTileSrcWidth, halfTileSrcHeight)
        bitmap.blt(i % 2 * halfTileWidth + x, i / 2 * halfTileHeight + y,
            autotile, src)
      end
    end
  end
end