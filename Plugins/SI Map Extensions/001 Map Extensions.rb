module RPG 
  class Map
    
    attr_accessor :height_map
    alias :original_initialize :initialize
	def initialize(width,height)
	  original_initialize(width,height)
      create_height_map
  
    end
	
	def create_height_map
      @height_map = Table.new(@width, @height, 9)
	
	end
  end
end

class Game_Map
  def tile_heights
    @map.create_height_map if @map.height_map.nil?
    return @map.height_map
  end
 
 def get_current_height(x,y,z=0)
    z = 0 if z.nil?
    z = z.clamp(0,2)
    return @map.height_map[x,y,z]
 end
end


class Bitmap
  def box_outline(x, y, width, height, color)
    # Top
    fill_rect(x, y, width, 1, color)
    # Bottom
    fill_rect(x, y + height - 1, width, 1, color)
    # Left
    fill_rect(x, y, 1, height, color)
    # Right
    fill_rect(x + width - 1, y, 1, height, color)
  end
end

class HeightMapEditor
  TILE_SIZE = 32

  def initialize
    if $game_map
      @map_id = $game_map.map_id
    else
      @map_id = ($data_system) ? $data_system.edit_map_id : 10
    end
    @viewport = Viewport.new(0, 0, Graphics.width + 576, Graphics.height + 576)
    @viewport.z = 99999
    @sprites = {}
    @tiles = []
	@height_storage = []
    @selmapid = -1
    @selected_tile = nil
	@camera_x = 0
    @camera_y = 0
	@selected_layer = 0
    @mapinfos = pbLoadMapInfos
    @sprites["background"] = ColoredPlane.new(Color.new(160, 208, 240), @viewport)
    @sprites["selsprite"] = SelectionSprite.new(@viewport)
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(_INTL("D: Help"), 0, Graphics.height + 506, Graphics.width, 64, @viewport)
    @sprites["title"].z = 2
    @sprites["information"] = Window_UnformattedTextPokemon.newWithSize(_INTL(""), Graphics.width + 294, Graphics.height + 506, Graphics.width, 64, @viewport)
    @sprites["information"].z = 2
    @sprites["curheight"] = Window_UnformattedTextPokemon.newWithSize(_INTL(""), Graphics.width, Graphics.height + 506, Graphics.width, 64, @viewport)
		  @sprites["curheight"].setTextToFit("Current Layer: #{@selected_layer}")
    @sprites["curheight"].z = 2
	update_chosen_map(@map_id)
	@old_tile = nil
    
  end

  def create_tile_sprites
  scale = 0.5  # 50% size
    (0...@map.width).each do |x|
      (0...@map.height).each do |y|
        sprite = Sprite.new(@viewport)
        sprite.bitmap = Bitmap.new(TILE_SIZE, TILE_SIZE)
	    height = create_height_sprite(x, y)
        draw_tile(sprite.bitmap, x, y, height)
        sprite.x = x * TILE_SIZE - @camera_x #* scale
        sprite.y = y * TILE_SIZE - @camera_y #* scale
        sprite.z = 1
        #sprite.zoom_x = scale
        #sprite.zoom_y = scale
        @tiles << { x: x, y: y, sprite: sprite, height: height }
      end
    end
  end
def update_tile_positions
  @tiles.each do |tile|
    sprite2 = tile[:height]
    sprite2.x = tile[:x] * TILE_SIZE - @camera_x
    sprite2.y = tile[:y] * TILE_SIZE - @camera_y
    sprite = tile[:sprite]
    sprite.x = tile[:x] * TILE_SIZE - @camera_x
    sprite.y = tile[:y] * TILE_SIZE - @camera_y
  end
end
  def draw_tile(bitmap, x, y, height=nil)
    bitmap.clear
	base_height = @map.height_map[x, y, 0] || 0

    (0..2).each do |z|
	  puts [x,y,z].to_s
      id = @map.data[x, y, z]
      id = 0 if !id
      @helper.bltTile(bitmap, 0, 0, id)
    end
    (0..9).each do |z|
      @map.height_map[x, y, z] ||= base_height
	end
    height_val = @map.height_map[x, y, @selected_layer]
    bitmap.font.size = MessageConfig::FONT_SIZE
	if height.nil?
	tile = @tiles.find { |t| t[:x] == x && t[:y] == y } 
	height = tile[:height]
	height.bitmap.clear
	end
    height.bitmap.draw_text(0, 0, TILE_SIZE, TILE_SIZE, height_val.to_s, 1)
    bitmap.box_outline(0, 0, TILE_SIZE, TILE_SIZE, Color.new(0, 0, 0))
  end
  
  def draw_height_text(tile)
    x = tile[:x]
	y = tile[:y]
    height = tile[:height]
    height.bitmap.clear
	base_height = @map.height_map[x, y, 0] || 0
	@map.height_map[x, y, @selected_layer] ||= base_height
    height_val = @map.height_map[x, y, @selected_layer]
    height.bitmap.draw_text(0, 0, TILE_SIZE, TILE_SIZE, height_val.to_s, 1)
  end
  
def create_height_sprite(x, y)
  sprite = Sprite.new(@viewport)
  sprite.bitmap = Bitmap.new(TILE_SIZE, TILE_SIZE)
  sprite.x = x * TILE_SIZE
  sprite.y = y * TILE_SIZE
  sprite.z = 1.1  
  return sprite
end
  
  def update_chosen_map(map_id)
     @tiles.each { |t| t[:sprite].dispose }
     @tiles.each { |t| t[:height].dispose }
     @tiles = []
     @map_id = map_id
     @map = load_data(sprintf("Data/Map%03d.rxdata", @map_id))
     @map.create_height_map if @map.height_map.nil?
     @tileset_data = $data_tilesets[@map.tileset_id]
	 @helper = TileDrawingHelper.fromTileset(@tileset_data)
     create_tile_sprites
  
  end
  
  def helpWindow
    helptext = _INTL("LMB: Increase Tile Height.\r\n")
    helptext += _INTL("RMB: Decrease Tile Height.\r\n")
    helptext += _INTL("S: Go to another map\r\n")
    helptext += _INTL("Arrow keys/drag canvas: Move around canvas")
    title = Window_UnformattedTextPokemon.newWithSize(
      helptext, 0, 0, Graphics.width * 8 / 10, Graphics.height, @viewport
    )
    title.z = 2
    loop do
      Graphics.update
      Input.update
      break if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
    end
    Input.update
    title.dispose
  end


  def chooseMapScreen(title, currentmap)
    return pbListScreen(title, MapLister.new(currentmap))
  end

  def get_tile_at(mouse_x, mouse_y)
    tx = (mouse_x + @camera_x) / TILE_SIZE
    ty = (mouse_y + @camera_y) / TILE_SIZE

    tx = tx.floor
    ty = ty.floor

    return nil if tx < 0 || ty < 0 || tx >= @map.width || ty >= @map.height
    @tiles.find { |t| t[:x] == tx && t[:y] == ty }
  end

  def edit_tile_height(tile, delta)
    x, y = tile[:x], tile[:y]
	base_height = @map.height_map[x, y, 0] || 0
	@map.height_map[x, y, @selected_layer] ||= base_height
    @map.height_map[x, y, @selected_layer] += delta if @map.height_map[x, y, @selected_layer] + delta < 3 && @map.height_map[x, y, @selected_layer] + delta > -1
    if @selected_layer == 0
      (1..9).each do |z|
       if @map.height_map[x, y, z] == base_height || @map.height_map[x, y, z].nil?
         @map.height_map[x, y, z] = @map.height_map[x, y, 0]
       end
      end
    end
    return if tile[:sprite].nil?
    draw_tile(tile[:sprite].bitmap, x, y)
  end

  def update
    Graphics.update
    Input.update
    if Input.mouse_in_window?
      mouse_pos = Mouse.getMousePos
      if mouse_pos
        tile = get_tile_at(mouse_pos[0], mouse_pos[1])
		@old_tile ||= tile
        if tile
		  @sprites["information"].setTextToFit("Location: #{tile[:x]},#{tile[:y]},#{@selected_layer} - Height: #{@map.height_map[tile[:x], tile[:y], @selected_layer]}")
          if Input.trigger?(Input::MOUSELEFT)
              if Input.press?(Input::SHIFT)
                 for x in 0...@map.width
                   for y in 0...@map.height
                     edit_tile_height(@tiles.find { |t| t[:x] == x && t[:y] == y }, +1)
                   end
                 end
             else
               edit_tile_height(tile, +1)
            end
          elsif Input.trigger?(Input::MOUSERIGHT)
              if Input.press?(Input::SHIFT)
                 for x in 0...@map.width
                   for y in 0...@map.height
                     edit_tile_height(@tiles.find { |t| t[:x] == x && t[:y] == y }, -1)
                   end
                 end
             else
               edit_tile_height(tile, -1)
            end
          
        elsif Input.triggerex?(0xBD)
		  @selected_layer -= 1 if @selected_layer-1>=0
		  update_for_layer
		  @sprites["curheight"].setTextToFit("Current Layer: #{@selected_layer}")
		elsif Input.triggerex?(0xBB)
		  @selected_layer += 1 if @selected_layer+1<10
		  update_for_layer
		  @sprites["curheight"].setTextToFit("Current Layer: #{@selected_layer}")
		end
        @old_tile = tile
        end
        if Input.triggerex?(:S)
            id = chooseMapScreen(_INTL("Go to Map"), @map_id)
            if id > 0
                @sprites["selsprite"].othersprite = nil
                @selmapid = -1
				update_chosen_map(id)
            end

        elsif Input.triggerex?(:D)
            helpWindow
		end

	    update_camera
      end
    end
  end
  
  def update_for_layer
    @tiles.each do |tile|
	  draw_height_text(tile)
    end
  end
  
  def update_camera
  moved = false
    amt = 4
	amt=amt*2 if Input.press?(Input::SHIFT)
  if Input.pressex?(:LEFT)
    @camera_x -= amt
    moved = true
  elsif Input.pressex?(:RIGHT)
    @camera_x += amt
    moved = true
  end
  if Input.pressex?(:UP)
    @camera_y -= amt
    moved = true
  elsif Input.pressex?(:DOWN)
    @camera_y += amt
    moved = true
  end
  update_tile_positions if moved
  end
  
  def main
    loop do
      update
      pbUpdateSpriteHash(@sprites)
      if Input.trigger?(Input::BACK) && !Input.trigger?(Input::MOUSERIGHT)
        if pbConfirmMessage(_INTL("Save changes?"))
          save_data(@map, sprintf("Data/Map%03d.rxdata", @map_id))
	    
		end
        break if pbConfirmMessage(_INTL("Exit from the editor?"))
	  end
    end
    dispose
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
    @tiles.each { |t| t[:sprite].dispose }
    @viewport.dispose
  end
end


def pbHeightMapEditor
  pbCriticalCode {
    Graphics.resize_screen(Settings::SCREEN_WIDTH + 576, Settings::SCREEN_HEIGHT + 576)
    pbSetResizeFactor(1)
    mapscreen = HeightMapEditor.new
    mapscreen.main
    Graphics.resize_screen(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
    pbSetResizeFactor($PokemonSystem.screensize)
  }
end

MenuHandlers.add(:debug_menu, :set_map_height, {
  "name"        => _INTL("Edit Map Heights"),
  "parent"      => :editors_menu,
  "description" => _INTL("Edit map height data using a visual interface."),
  "effect"      => proc {
    pbFadeOutIn { pbHeightMapEditor }
  }
})
