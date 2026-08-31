#===============================================================================
#
#===============================================================================
class MapBottomSprite < Sprite
  attr_reader :mapname, :maplocation

  TEXT_MAIN_COLOR   = Color.new(248, 248, 248)
  TEXT_SHADOW_COLOR = Color.new(0, 0, 0)

  def initialize(viewport = nil)
    super(viewport)
    @mapname     = ""
    @maplocation = ""
    @mapdetails  = ""
    self.bitmap = BitmapWrapper.new(Graphics.width + 90, Graphics.height + 90)
    pbSetSystemFont(self.bitmap)
    refresh
  end

  def mapname=(value)
    return if @mapname == value
    @mapname = value
    refresh
  end

  def maplocation=(value)
    return if @maplocation == value
    @maplocation = value
    refresh
  end

  # From Wichu
  def mapdetails=(value)
    return if @mapdetails == value
    @mapdetails = value
    refresh
  end

  def refresh
    bitmap.clear
    textpos = [
      [@mapname,                     18,   4, 0, TEXT_MAIN_COLOR, TEXT_SHADOW_COLOR],
      [@maplocation,                 18, 360, 0, TEXT_MAIN_COLOR, TEXT_SHADOW_COLOR],
      [@mapdetails, Graphics.width - 16, 360, 1, TEXT_MAIN_COLOR, TEXT_SHADOW_COLOR]
    ]
    pbDrawTextPositions(bitmap, textpos)
  end
end

#===============================================================================
#
#===============================================================================
class PokemonRegionMap_Scene
  LEFT          = 0
  TOP           = 0
  RIGHT         = 59
  BOTTOM        = 39
  SQUARE_WIDTH  = 8
  SQUARE_HEIGHT = 8

  def initialize(region = - 1, wallmap = true, statue=nil)
    @region  = region
    @wallmap = wallmap
	@statue = nil
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(as_editor = false, fly_map = false, teleport_map = false )
    @editor   = as_editor
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @map_data = pbLoadTownMapData
    @fly_map = fly_map
    @teleport_map = teleport_map
    @mode    = fly_map ? 1 : 0
	@mode    = 2 if @teleport_map
    map_metadata = $game_map.metadata
    playerpos = (map_metadata) ? map_metadata.town_map_position : nil
	puts "HELLO?"
    if @statue 
      mapindex = 0
	  statue_id = @statue.statue_id
	  statue_data = StatueCollection::STATUE_MAP_POSITIONS[statue_id]
      @map     = @map_data[0]
      @map_x   = statue_data[0]
      @map_y   = statue_data[1]
    elsif !playerpos
      mapindex = 0
      @map     = @map_data[0]
      @map_x   = LEFT
      @map_y   = TOP
    elsif @region >= 0 && @region != playerpos[0] && @map_data[@region]
      mapindex = @region
      @map     = @map_data[@region]
      @map_x   = LEFT
      @map_y   = TOP
    else
      mapindex = playerpos[0]
      @map     = @map_data[playerpos[0]]
      @map_x    = playerpos[1]
      @map_y    = playerpos[2]
      mapsize = map_metadata.town_map_size
      if mapsize && mapsize[0] && mapsize[0] > 0
        sqwidth  = mapsize[0]
        sqheight = (mapsize[1].length.to_f / mapsize[0]).ceil
        @map_x += ($game_player.x * sqwidth / $game_map.width).floor if sqwidth > 1
        @map_y += ($game_player.y * sqheight / $game_map.height).floor if sqheight > 1
      end
    end

	@regionname = pbGetMessage(MessageTypes::RegionNames, mapindex)	
	
	
    if !@map
      pbMessage(_INTL("The map data cannot be found."))
      return false
    end



    addBackgroundOrColoredPlane(@sprites, "background", "mapbg", Color.new(0, 0, 0), @viewport)
    @sprites["map"] = IconSprite.new(0, 0, @viewport)
	
    @sprites["map"].setBitmap("Graphics/Pictures/Maps/#{@map[1]}")
	
	
    @sprites["map"].x += (Graphics.width - @sprites["map"].bitmap.width) / 2
    @sprites["map"].y += (Graphics.height - @sprites["map"].bitmap.height) / 2
if @regionname == "The Island"
  @sprites["discovery"] = BitmapSprite.new(WorldMapDiscovery::WIDTH,WorldMapDiscovery::HEIGHT,@viewport)

  @sprites["discovery"].x = @sprites["map"].x
  @sprites["discovery"].y = @sprites["map"].y
  WorldMapDiscovery.create_mask(@sprites["discovery"].bitmap)
end
	create_map_grid
    Settings::REGION_MAP_EXTRAS.each do |graphic|
      next if graphic[0] != mapindex || !location_shown?(graphic)
      if !@sprites["map2"]
        @sprites["map2"] = BitmapSprite.new(480, 320, @viewport)
        @sprites["map2"].x = @sprites["map"].x
        @sprites["map2"].y = @sprites["map"].y
      end
      pbDrawImagePositions(
        @sprites["map2"].bitmap,
        [["Graphics/Pictures/#{graphic[4]}", graphic[2] * SQUARE_WIDTH, graphic[3] * SQUARE_HEIGHT]]
      )
    end
	
	
	
    @sprites["mapbottom"] = MapBottomSprite.new(@viewport)
    @sprites["mapbottom"].mapname     = pbGetMessage(MessageTypes::RegionNames, mapindex)
	if @sprites["mapgrid"]&.visible
      @sprites["mapbottom"].maplocation = "#{@map_x}, #{@map_y}"
	else
      @sprites["mapbottom"].maplocation = pbGetMapLocation(@map_x, @map_y)
      @sprites["mapbottom"].mapdetails  = pbGetMapDetails(@map_x, @map_y)
	end 
    @sprites["mapbottom"].y -= 10
	
	
    if playerpos && mapindex == playerpos[0]
      @sprites["player"] = IconSprite.new(0, 0, @viewport)
      @sprites["player"].setBitmap(GameData::TrainerType.player_map_icon_filename($player.trainer_type))
      @sprites["player"].x = point_x_to_screen_x(@map_x)
      @sprites["player"].y = point_y_to_screen_y(@map_y)
    end
 

    k = 0
    (LEFT..RIGHT).each do |i|
      (TOP..BOTTOM).each do |j|
        healspot = pbGetHealingSpot(i, j)
        teleportspot = pbGetStatueSpot(i, j)
		if @mode == 1
          next if !healspot || !$PokemonGlobal.visitedMaps[healspot[0]]
        elsif @mode == 2
          next if !teleportspot && (!healspot || !$PokemonGlobal.visitedMaps[healspot[0]])
        else
         next
        end
		graphic = teleportspot ? "Graphics/Pictures/Maps/mapTeleport" : "Graphics/Pictures/Maps/mapFly"
        @sprites["point#{k}"] = AnimatedSprite.create(graphic, 2, 16)
        @sprites["point#{k}"].viewport = @viewport
        @sprites["point#{k}"].x        = point_x_to_screen_x(i) - 4
        @sprites["point#{k}"].y        = point_y_to_screen_y(j) - 4
        @sprites["point#{k}"].visible  = @mode == 1 || @mode == 2
        @sprites["point#{k}"].play
        k += 1
      end
    end




    @sprites["help"] = BitmapSprite.new(Graphics.width, 32, @viewport)
    pbSetSystemFont(@sprites["help"].bitmap)
    refresh_fly_screen
    @changed = false
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end


  def pbMapScene
    x_offset = 0
    y_offset = 0
    new_x    = 0
    new_y    = 0
    dist_per_frame = 8 * 20 / Graphics.frame_rate
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.mouse_x >= @sprites["map"].x &&
         Input.mouse_x < @sprites["map"].x + @sprites["map"].bitmap.width &&
         Input.mouse_y >= @sprites["map"].y &&
         Input.mouse_y < @sprites["map"].y + @sprites["map"].bitmap.height

        @map_x = screen_x_to_point_x(Input.mouse_x).round
        @map_y = screen_y_to_point_y(Input.mouse_y).round

        @map_x = [[@map_x, LEFT].max, RIGHT].min
        @map_y = [[@map_y, TOP].max, BOTTOM].min
      end
    
	  if @sprites["mapgrid"]&.visible
        @sprites["mapbottom"].maplocation = "#{@map_x}, #{@map_y}"
	  else
        @sprites["mapbottom"].maplocation = pbGetMapLocation(@map_x, @map_y)
        @sprites["mapbottom"].mapdetails  = pbGetMapDetails(@map_x, @map_y)
	  end 
	  if Input.trigger?(Input::CTRL) && $DEBUG
       @sprites["mapgrid"].visible = !@sprites["mapgrid"].visible
      end
      if Input.trigger?(Input::BACK)
        if @editor && @changed
          pbSaveMapData if pbConfirmMessage(_INTL("Save changes?")) { pbUpdate }
          break if pbConfirmMessage(_INTL("Exit from the map?")) { pbUpdate }
        else
          break
        end
      elsif Input.trigger?(Input::USE) && @sprites["mapgrid"].visible
        Input.clipboard = "#{@map_x}, #{@map_y}"
		puts "#{@map_x}, #{@map_y} copied to clipboard."
      elsif Input.trigger?(Input::USE) && @mode == 1    # Choosing an area to fly to
        healspot = pbGetHealingSpot(@map_x, @map_y)
        if healspot && ($PokemonGlobal.visitedMaps[healspot[0]] ||
           ($DEBUG && Input.press?(Input::CTRL)))
          return healspot if @fly_map
          name = pbGetMapNameFromId(healspot[0])
          return healspot if pbConfirmMessage(_INTL("Would you like to use Fly to go to {1}?", name)) { pbUpdate }
        end
      elsif Input.trigger?(Input::USE) && @mode == 2
        healspot = pbGetStatueSpot(@map_x, @map_y)
		if healspot 
		healspot[2] += 1
		return healspot if healspot && @teleport_map
		end 
      elsif Input.trigger?(Input::USE) && @editor   # Intentionally after other USE input check
        pbChangeMapLocation(@map_x, @map_y)
      elsif Input.trigger?(Input::ACTION) && !@wallmap && !@fly_map && pbCanFly?
        pbPlayDecisionSE
        @mode = (@mode == 1) ? 0 : 1
        refresh_fly_screen
      end
    end
    pbPlayCloseMenuSE
    return nil
  end

  def refresh_fly_screen
    return if @fly_map || !Settings::CAN_FLY_FROM_TOWN_MAP || !pbCanFly?
    @sprites["help"].bitmap.clear
    text = (@mode == 0) ? _INTL("ACTION: Fly") : _INTL("ACTION: Cancel Fly")
    pbDrawTextPositions(
      @sprites["help"].bitmap,
      [[text, Graphics.width - 16, 4, 1, Color.new(248, 248, 248), Color.new(0, 0, 0)]]
    )
    @sprites.each do |key, sprite|
      next if !key.include?("point")
      sprite.visible = (@mode == 1)
      sprite.frame   = 0
    end
  end


def create_map_grid
  width  = (RIGHT - LEFT + 1) * SQUARE_WIDTH
  height = (BOTTOM - TOP + 1) * SQUARE_HEIGHT

  @sprites["mapgrid"] = BitmapSprite.new(width, height, @viewport)

  bitmap = @sprites["mapgrid"].bitmap

  # Vertical lines
  (0..(RIGHT - LEFT + 1)).each do |i|
    x = i * SQUARE_WIDTH

    bitmap.fill_rect(
      x,
      0,
      1,
      height,
      Color.new(255, 0, 0, 100)
    )
  end

  # Horizontal lines
  (0..(BOTTOM - TOP + 1)).each do |i|
    y = i * SQUARE_HEIGHT

    bitmap.fill_rect(
      0,
      y,
      width,
      1,
      Color.new(255, 0, 0, 100)
    )
  end

  @sprites["mapgrid"].x = @sprites["map"].x - (SQUARE_WIDTH / 2)
  @sprites["mapgrid"].y = @sprites["map"].y - (SQUARE_HEIGHT / 2)
  @sprites["mapgrid"].z = @sprites["map"].z + 10
  @sprites["mapgrid"].visible = false
end

  def point_x_to_screen_x(x)
    return (-SQUARE_WIDTH / 2) + (x * SQUARE_WIDTH) + ((Graphics.width - @sprites["map"].bitmap.width) / 2)
  end

  def point_y_to_screen_y(y)
    return (-SQUARE_HEIGHT / 2) + (y * SQUARE_HEIGHT) + ((Graphics.height - @sprites["map"].bitmap.height) / 2)
  end
  
  def screen_x_to_point_x(sx)
    return (sx - ((Graphics.width - @sprites["map"].bitmap.width) / 2) + (SQUARE_WIDTH / 2)) / SQUARE_WIDTH
  end

  def screen_y_to_point_y(sy)
    return (sy - ((Graphics.height - @sprites["map"].bitmap.height) / 2) + (SQUARE_HEIGHT / 2)) / SQUARE_HEIGHT
  end



  def location_shown?(point)
    return point[5] if @wallmap
    return point[1] > 0 && $game_switches[point[1]]
  end

  def pbSaveMapData
    File.open("PBS/town_map.txt", "wb") { |f|
      Compiler.add_PBS_header_to_file(f)
      @map_data.length.times do |i|
        map = @map_data[i]
        next if !map
        f.write("\#-------------------------------\r\n")
        f.write(sprintf("[%d]\r\n", i))
        f.write(sprintf("Name = %s\r\n", Compiler.csvQuote(map[0])))
        f.write(sprintf("Filename = %s\r\n", Compiler.csvQuote(map[1])))
        map[2].each do |loc|
          f.write("Point = ")
          Compiler.pbWriteCsvRecord(loc, f, [nil, "uussUUUU"])
          f.write("\r\n")
        end
      end
    }
  end

  def pbGetMapLocation(x, y)
    $PokemonGlobal.active_statues.each do |statue_id, statue|
      map_x, map_y, statue_name, point_of_interest = StatueCollection::STATUE_MAP_POSITIONS[statue_id]
      next if map_x != x || map_y != y
      return statue_name
    end
    return "" if !@map[2]
    @map[2].each do |point|
      next if point[0] != x || point[1] != y
      return "" if point[7] && (@wallmap || point[7] <= 0 || !$game_switches[point[7]])
      name = pbGetMessageFromHash(MessageTypes::PlaceNames, point[2])
      return (@editor) ? point[2] : name
    end
    return ""
  end

  def pbChangeMapLocation(x, y)
    return "" if !@editor || !@map[2]
    map = @map[2].select { |loc| loc[0] == x && loc[1] == y }[0]
    currentobj  = map
    currentname = (map) ? map[2] || "" : ""
    currentname = pbMessageFreeText(_INTL("Set the name for this point."), currentname, false, 250) { pbUpdate }
    if currentname
      if currentobj
        currentobj[2] = currentname
      else
        newobj = [x, y, currentname, ""]
        @map[2].push(newobj)
      end
      @changed = true
    end
  end

  def pbGetMapDetails(x, y)   # From Wichu, with my help
    $PokemonGlobal.active_statues.each do |statue_id, statue|
      map_x, map_y, statue_name, point_of_interest = StatueCollection::STATUE_MAP_POSITIONS[statue_id]
      next if map_x != x || map_y != y
      return point_of_interest
    end
    return "" if !@map[2]
    @map[2].each do |point|
      next if point[0] != x || point[1] != y
      return "" if point[7] && (@wallmap || point[7] <= 0 || !$game_switches[point[7]])
      mapdesc = pbGetMessageFromHash(MessageTypes::PlaceDescriptions, point[3])
      return (@editor) ? point[3] : mapdesc
    end
    return ""
  end

  def pbGetHealingSpot(x, y)
    return nil if !@map[2]
    @map[2].each do |point|
      next if point[0] != x || point[1] != y
      return nil if point[7] && (@wallmap || point[7] <= 0 || !$game_switches[point[7]])
      return (point[4] && point[5] && point[6]) ? [point[4], point[5], point[6]] : nil
    end
    return nil
  end
  
def pbGetStatueSpot(x, y)
  $PokemonGlobal.active_statues.each do |statue_id, statue|
    map_x, map_y, statue_name, point_of_interest = StatueCollection::STATUE_MAP_POSITIONS[statue_id]
    next if map_x != x || map_y != y
    return [statue[:map_id], statue[:x], statue[:y]]
  end
  return nil
end
def pbGetStatueSpot1(x, y)
  $PokemonGlobal.active_statues.each do |id, statue|
    map_x, map_y, statue_name, point_of_interest = StatueCollection::STATUE_MAP_POSITIONS[statue_id]
    next if map_x != x || map_y != y
    return [statue[:map_id], statue[:x], statue[:y]]
  end
  return nil
end
end

#===============================================================================
#
#===============================================================================
class PokemonRegionMapScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartFlyScreen
    @scene.pbStartScene(false, true)
    ret = @scene.pbMapScene
    @scene.pbEndScene
    return ret
  end

  def pbStartTeleportScreen
    @scene.pbStartScene(false, false, true)
    ret = @scene.pbMapScene
    @scene.pbEndScene
    return ret
  end

  def pbStartScreen
    @scene.pbStartScene($DEBUG)
    ret = @scene.pbMapScene
    @scene.pbEndScene
    return ret
  end
end

#===============================================================================
#
#===============================================================================
def pbShowMap(region = -1, wallmap = true)
  pbFadeOutIn {
    scene = PokemonRegionMap_Scene.new(region, wallmap)
    screen = PokemonRegionMapScreen.new(scene)
    ret = screen.pbStartScreen
    $game_temp.fly_destination = ret if ret && !wallmap
  }
end

def pbShowFlyMap(region = -1, wallmap = true)
  pbFadeOutIn {
    scene = PokemonRegionMap_Scene.new(region, wallmap)
    screen = PokemonRegionMapScreen.new(scene)
    ret = screen.pbStartFlyScreen
    $game_temp.fly_destination = ret if ret && !wallmap
  }
end

def pbShowTeleportMap(statue = nil, region = -1, wallmap = false)
  pbFadeOutIn {
    scene = PokemonRegionMap_Scene.new(region, wallmap, statue)
    screen = PokemonRegionMapScreen.new(scene)
    ret = screen.pbStartTeleportScreen
    $game_temp.fly_destination = ret if ret && !wallmap
  }
end

def getUncoveredMapAmt
  return "B" if $PokemonGlobal.visitedMaps[3] == true
  return "C" if $PokemonGlobal.visitedMaps[5] == true
  return "D" if $PokemonGlobal.visitedMaps[9] == true
  return "E" if $PokemonGlobal.visitedMaps[24] == true
  return "F" if $PokemonGlobal.visitedMaps[33] == true || $PokemonGlobal.visitedMaps[72] == true
  return "G" if $PokemonGlobal.visitedMaps[36] == true
  return "H" if $PokemonGlobal.visitedMaps[111] == true
  return "I" if $PokemonGlobal.visitedMaps[207] == true
  return "J" if $PokemonGlobal.visitedMaps[307] == true
  return "K" if $PokemonGlobal.visitedMaps[338] == true
  return "A"


end