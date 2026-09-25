module RPG 
  class Map
    
    attr_accessor :height_map
    alias :original_height_map_initialize :initialize
	def initialize(width,height)
	  original_height_map_initialize(width,height)
      create_height_map
  
    end

    # The number of stacked height layers each tile has (ground, object,
    # overlay, etc.) - this is the actual size of the height_map Table's
    # z-axis. It has nothing to do with the height *values* stored in each
    # layer, which range 0..HeightMapEditor::HEIGHT_LIMIT.
    HEIGHT_MAP_LAYERS = 3
	
def create_height_map
  return false if @height_map && @height_map.zsize == HEIGHT_MAP_LAYERS

  old_height_map = @height_map
  @height_map = Table.new(@width, @height, HEIGHT_MAP_LAYERS)

  if old_height_map
    copy_layers = [old_height_map.zsize, HEIGHT_MAP_LAYERS].min

    (0...@width).each do |x|
      (0...@height).each do |y|
        (0...copy_layers).each do |z|
          @height_map[x, y, z] = old_height_map[x, y, z]
        end
      end
    end
  end

  return true
end
  end
end

class Game_Map

  def tile_heights
    if @map.height_map.nil?
    expanded = @map.create_height_map
	$disk_manager.save(@map, sprintf("Map%03d.rxdata", @real_map_id)) if expanded
	end 
    return @map.height_map
  end
  
 def get_current_height(x, y, z = 0)
    z = 0 if z.nil?
    z = z.clamp(0, RPG::Map::HEIGHT_MAP_LAYERS - 1)
    return @map.height_map[x, y, z] || 0
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
  LAYER_COUNT = RPG::Map::HEIGHT_MAP_LAYERS
  HEIGHT_LIMIT = 31
  LAYER_DOWN_KEY = 0xBD # VK_OEM_MINUS
  LAYER_UP_KEY   = 0xBB # VK_OEM_PLUS

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
    @tile_lookup = {}
    @camera_x = 0
    @camera_y = 0
    @selected_layer = 0
    @mapinfos = pbLoadMapInfos
    @old_tile = nil
    @painting = false
    @paint_height = nil
    @clipboard_height = nil
    @clipboard_armed = false
    @clipboard_stroke_active = false
    @tool = :normal
    @rect_start = nil
    @rect_end = nil
    @rect_button = nil
	@dragging = false
    @drag_start = nil

    @sprites["background"] = ColoredPlane.new(
      Color.new(160, 208, 240), @viewport
    )

    @sprites["selsprite"] = SelectionSprite.new(@viewport)

    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("C: Help"), 0, Graphics.height + 506,
      Graphics.width, 64, @viewport
    )
    @sprites["title"].z = 2

    @sprites["information"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL(""), Graphics.width + 294, Graphics.height + 506,
      Graphics.width, 64, @viewport
    )
    @sprites["information"].z = 2

    @sprites["curheight"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL(""), Graphics.width, Graphics.height + 506,
      Graphics.width, 64, @viewport
    )
    @sprites["curheight"].setTextToFit("Current Layer: #{@selected_layer+1}")
    @sprites["curheight"].z = 2

    @sprites["clipboard"] = Window_UnformattedTextPokemon.newWithSize(_INTL(""), Graphics.width + 406, 64, 200, 64, @viewport)
    @sprites["clipboard"].z = 2

    @sprites["tool"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL(""), Graphics.width + 406, 0, 200, 64, @viewport
    )
    @sprites["tool"].z = 2
    update_tool_label

    @sprites["selection"] = Sprite.new(@viewport)
    @sprites["selection"].bitmap = Bitmap.new(
      Graphics.width + 576, Graphics.height + 576
    )
    @sprites["selection"].x = 0
    @sprites["selection"].y = 0
    @sprites["selection"].z = 1.5

    update_chosen_map(@map_id)
  end

  def create_tile_sprites
    (0...@map.width).each do |x|
      (0...@map.height).each do |y|
        sprite = Sprite.new(@viewport)
        sprite.bitmap = Bitmap.new(TILE_SIZE, TILE_SIZE)

        height = create_height_sprite(x, y)

        draw_tile(sprite.bitmap, x, y, height)

        sprite.x = x * TILE_SIZE - @camera_x
        sprite.y = y * TILE_SIZE - @camera_y
        sprite.z = 1

        tile = {
          x: x,
          y: y,
          sprite: sprite,
          height: height
        }

        @tiles << tile
        @tile_lookup[[x, y]] = tile
		puts [x, y].to_s
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

  def draw_tile(bitmap, x, y, height = nil)
    bitmap.clear

    (0..2).each do |z|
      id = @map.data[x, y, z]
      id = 0 if !id
      @helper.bltTile(bitmap, 0, 0, id)
    end

    height_val = @map.height_map[x, y, @selected_layer]

    bitmap.font.size = MessageConfig::FONT_SIZE

    if height.nil?
      tile = @tile_lookup[[x, y]]
      height = tile[:height]
      height.bitmap.clear
    end

    height.bitmap.draw_text(
      0, 0, TILE_SIZE, TILE_SIZE,
      (height_val + 1).to_s, 1
    )

    bitmap.box_outline(
      0, 0, TILE_SIZE, TILE_SIZE,
      Color.new(0, 0, 0)
    )
  end

  def draw_height_text(tile)
    x = tile[:x]
    y = tile[:y]
    height = tile[:height]

    height.bitmap.clear

    height_val = @map.height_map[x, y, @selected_layer]

    height.bitmap.draw_text(
      0, 0, TILE_SIZE, TILE_SIZE,
      (height_val + 1).to_s, 1
    )
  end

  def create_height_sprite(x, y)
    sprite = Sprite.new(@viewport)
    sprite.bitmap = Bitmap.new(TILE_SIZE, TILE_SIZE)
    sprite.x = x * TILE_SIZE
    sprite.y = y * TILE_SIZE
    sprite.z = 1.1
    return sprite
  end

  def initialize_height_map
    (0...@map.width).each do |x|
      (0...@map.height).each do |y|
        base_height = @map.height_map[x, y, 0] || 0

        (0...LAYER_COUNT).each do |z|
          @map.height_map[x, y, z] ||= base_height
        end
      end
    end
  end

def update_mouse_pan
  mouse_pos = Mouse.getMousePos
  return if !mouse_pos

  if Input.trigger?(Input::MOUSEMIDDLE)
    @dragging = true
    @drag_start = mouse_pos
  end

  if @dragging && Input.press?(Input::MOUSEMIDDLE)
    dx = mouse_pos[0] - @drag_start[0]
    dy = mouse_pos[1] - @drag_start[1]

    @camera_x -= dx
    @camera_y -= dy

    @drag_start = mouse_pos
    update_tile_positions
  end

  unless Input.press?(Input::MOUSEMIDDLE)
    @dragging = false
    @drag_start = nil
  end
end

  def update_chosen_map(map_id)
    @tiles.each { |t| t[:sprite].dispose }
    @tiles.each { |t| t[:height].dispose }

    @tiles = []
    @tile_lookup = {}
    @old_tile = nil

    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rxdata", @map_id))

    expanded = @map.create_height_map
    save_data(@map, sprintf("Data/Map%03d.rxdata", @map_id)) if expanded

    initialize_height_map

    @tileset_data = $data_tilesets[@map.tileset_id]
    @helper = TileDrawingHelper.fromTileset(@tileset_data)

    create_tile_sprites
  end

  def helpWindow
    helptext = _INTL("LMB: Increase Tile Height.\r\n")
    helptext += _INTL("RMB: Decrease Tile Height.\r\n")
    helptext += _INTL("Hold LMB/RMB + drag: Paint height.\r\n")
    helptext += _INTL("Ctrl+C: Copy hovered tile's height to paint with.\r\n")
    helptext += _INTL("F: Toggle Flood Fill tool (LMB/RMB fills contiguous same-height area).\r\n")
    helptext += _INTL("R: Toggle Rectangle Select tool (drag LMB/RMB, release to fill).\r\n")
    helptext += _INTL("Mouse Wheel: Change Layer.\r\n")
    helptext += _INTL("Shift + LMB: Increase entire map.\r\n")
    helptext += _INTL("Shift + RMB: Decrease entire map.\r\n")
    helptext += _INTL("Shift + LMB/RMB after Ctrl+C: Fill entire map with copied height.\r\n")
    helptext += _INTL("+/-/Mouse Wheel: Change Layer.\r\n")
    helptext += _INTL("Arrow keys/Mouse Middle: Move around canvas\r\n")
    helptext += _INTL("Z: Go to another map")

    title = Window_UnformattedTextPokemon.newWithSize(
      helptext, 0, 0,
      Graphics.width * 8 / 10,
      Graphics.height + 80,
      @viewport
    )

    title.z = 2

    loop do
      Graphics.update
      Input.update
      break if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE) || Input.triggerex?(:C)
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

    return nil if tx < 0 || ty < 0
    return nil if tx >= @map.width || ty >= @map.height

    return @tile_lookup[[tx, ty]]
  end

  def edit_tile_height(tile, delta)
    x = tile[:x]
    y = tile[:y]

    height = @map.height_map[x, y, @selected_layer] || 0
    new_height = height + delta

    return if new_height > HEIGHT_LIMIT || new_height <= -1

    @map.height_map[x, y, @selected_layer] = new_height

    if @selected_layer == 0
      (1...LAYER_COUNT).each do |z|
        if @map.height_map[x, y, z] == height
          @map.height_map[x, y, z] = new_height
        end
      end
    end

    return if tile[:height].nil?

    draw_height_text(tile)
  end

  def edit_all_tiles(delta)
    @tiles.each do |tile|
      edit_tile_height(tile, delta)
    end
  end

  # Stamps every tile on the map with a fixed height value in one go -
  # handy for flattening a whole map to a single height.
  def paint_all_tiles(value)
    @tiles.each do |tile|
      paint_tile_height(tile, value)
    end
  end

  # Stamps a tile with a fixed height value instead of an increment - used
  # while dragging so every tile painted over matches the tile the drag
  # started from. Reuses edit_tile_height so bounds-checking and the
  # layer-0 propagation behave identically to a normal edit.
  def paint_tile_height(tile, value)
    current = @map.height_map[tile[:x], tile[:y], @selected_layer] || 0
    delta = value - current
    edit_tile_height(tile, delta) if delta != 0
  end


  def consume_clipboard!
    @clipboard_armed = false
    @sprites["clipboard"].setTextToFit("")
  end

  def update_tool_label
    label = case @tool
            when :flood_fill  then "Tool: Fill"
            when :rect_select then "Tool: Select"
            else "Tool: Normal"
            end
    @sprites["tool"].setTextToFit(label)
  end

  # The normal single-tile click/hold/drag/shift-fill behavior, used when
  # no special tool is active.
  def handle_normal_paint_input(tile)
    if Input.press?(Input::MOUSELEFT)
      if @clipboard_armed && Input.press?(Input::SHIFT)
        if Input.trigger?(Input::MOUSELEFT)
          @clipboard_stroke_active = true
          paint_all_tiles(@clipboard_height)
        end
      elsif @clipboard_armed
        @clipboard_stroke_active = true
        paint_tile_height(tile, @clipboard_height)
      elsif Input.press?(Input::SHIFT)
        edit_all_tiles(+1) if Input.trigger?(Input::MOUSELEFT) || Input.repeat?(Input::MOUSELEFT)
      elsif Input.trigger?(Input::MOUSELEFT)
        edit_tile_height(tile, +1)
      elsif tile != @old_tile && @old_tile 
        unless @painting
          @painting = true
          @paint_height = @map.height_map[@old_tile[:x], @old_tile[:y], @selected_layer]
        end
        paint_tile_height(tile, @paint_height)
      elsif !@painting && Input.repeat?(Input::MOUSELEFT)
        edit_tile_height(tile, +1)
      end

    elsif Input.press?(Input::MOUSERIGHT)
      if @clipboard_armed && Input.press?(Input::SHIFT)
        if Input.trigger?(Input::MOUSERIGHT)
          @clipboard_stroke_active = true
          paint_all_tiles(@clipboard_height)
        end
      elsif @clipboard_armed
        @clipboard_stroke_active = true
        paint_tile_height(tile, @clipboard_height)
      elsif Input.press?(Input::SHIFT)
        edit_all_tiles(-1) if Input.trigger?(Input::MOUSERIGHT) || Input.repeat?(Input::MOUSERIGHT)
      elsif Input.trigger?(Input::MOUSERIGHT)
        edit_tile_height(tile, -1)
      elsif tile != @old_tile && @old_tile
        unless @painting
          @painting = true
          @paint_height = @map.height_map[@old_tile[:x], @old_tile[:y], @selected_layer]
        end
        paint_tile_height(tile, @paint_height)
      elsif !@painting && Input.repeat?(Input::MOUSERIGHT)
        edit_tile_height(tile, -1)
      end
    end
  end

  # Bucket-fill: click a tile and every orthogonally-contiguous tile
  # sharing its current height (on the selected layer) is set to the
  # target height. Target is the copied clipboard value if one's loaded,
  # otherwise +/-1 from the height you clicked on.
  def handle_flood_fill_input(tile)
    if Input.trigger?(Input::MOUSELEFT)
      origin_height = @map.height_map[tile[:x], tile[:y], @selected_layer] || 0
      target_height = @clipboard_armed ? @clipboard_height : origin_height + 1
      flood_fill(tile, target_height)
      consume_clipboard! if @clipboard_armed
    elsif Input.trigger?(Input::MOUSERIGHT)
      origin_height = @map.height_map[tile[:x], tile[:y], @selected_layer] || 0
      target_height = @clipboard_armed ? @clipboard_height : origin_height - 1
      flood_fill(tile, target_height)
      consume_clipboard! if @clipboard_armed
    end
  end

  def flood_fill(start_tile, target_height)
    match_height = @map.height_map[start_tile[:x], start_tile[:y], @selected_layer] || 0
    return if match_height == target_height

    visited = {}
    stack = [start_tile]

    until stack.empty?
      current = stack.pop
      key = [current[:x], current[:y]]
      next if visited[key]
      visited[key] = true

      current_height = @map.height_map[current[:x], current[:y], @selected_layer] || 0
      next if current_height != match_height

      paint_tile_height(current, target_height)

      [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
        neighbor = @tile_lookup[[current[:x] + dx, current[:y] + dy]]
        stack.push(neighbor) if neighbor && !visited[[neighbor[:x], neighbor[:y]]]
      end
    end
  end

  # Drag out a rectangle; the fill is applied on mouse release (see
  # `update`), using the copied clipboard value if one's loaded, otherwise
  # +/-1 depending on which button started the drag.
  def handle_rect_select_input(tile)
    if Input.trigger?(Input::MOUSELEFT)
      @rect_start = tile
      @rect_end = tile
      @rect_button = :left
    elsif Input.trigger?(Input::MOUSERIGHT)
      @rect_start = tile
      @rect_end = tile
      @rect_button = :right
    elsif @rect_start && (Input.press?(Input::MOUSELEFT) || Input.press?(Input::MOUSERIGHT))
      @rect_end = tile
    end
  end

  def apply_rect_fill(start_tile, end_tile, button)
    min_x, max_x = [start_tile[:x], end_tile[:x]].minmax
    min_y, max_y = [start_tile[:y], end_tile[:y]].minmax

    (min_x..max_x).each do |x|
      (min_y..max_y).each do |y|
        rect_tile = @tile_lookup[[x, y]]
        next unless rect_tile

        if @clipboard_armed
          paint_tile_height(rect_tile, @clipboard_height)
        else
          edit_tile_height(rect_tile, button == :left ? +1 : -1)
        end
      end
    end

    consume_clipboard! if @clipboard_armed
  end

  def update_selection_overlay
    bitmap = @sprites["selection"].bitmap
    bitmap.clear

    return unless @tool == :rect_select && @rect_start && @rect_end

    min_x, max_x = [@rect_start[:x], @rect_end[:x]].minmax
    min_y, max_y = [@rect_start[:y], @rect_end[:y]].minmax

    screen_x = min_x * TILE_SIZE - @camera_x
    screen_y = min_y * TILE_SIZE - @camera_y
    width = (max_x - min_x + 1) * TILE_SIZE
    height = (max_y - min_y + 1) * TILE_SIZE

    bitmap.fill_rect(screen_x, screen_y, width, height, Color.new(255, 255, 0, 80))
    bitmap.box_outline(screen_x, screen_y, width, height, Color.new(255, 255, 0, 255))
  end

  def change_layer(delta)
    new_layer = @selected_layer + delta

    return if new_layer < 0
    return if new_layer >= LAYER_COUNT

    @selected_layer = new_layer

    update_for_layer

    @sprites["curheight"].setTextToFit(
      "Current Layer: #{@selected_layer+1}"
    )
  end

  def update
    Graphics.update
    Input.update

    tile = nil
    if Input.mouse_in_window?
      mouse_pos = Mouse.getMousePos

      if mouse_pos
        tile = get_tile_at(mouse_pos[0], mouse_pos[1])

        if tile
          if Input.press?(Input::CTRL) && Input.triggerex?(:C)
            @clipboard_height = @map.height_map[tile[:x], tile[:y], @selected_layer]
            @clipboard_armed = true
            @sprites["clipboard"].setTextToFit("Clipboard: #{@clipboard_height + 1}")
          end
          case @tool
          when :flood_fill
            handle_flood_fill_input(tile)
          when :rect_select
            handle_rect_select_input(tile)
          else
            handle_normal_paint_input(tile)
          end
        end

        @old_tile = tile if Input.press?(Input::MOUSELEFT) ||
                            Input.press?(Input::MOUSERIGHT)

        if !Input.press?(Input::MOUSELEFT) &&
           !Input.press?(Input::MOUSERIGHT)
          if @tool == :rect_select && @rect_start && @rect_end
            apply_rect_fill(@rect_start, @rect_end, @rect_button)
          end
          @rect_start = nil
          @rect_end = nil
          @rect_button = nil

          consume_clipboard! if @clipboard_stroke_active
          @clipboard_stroke_active = false
          @old_tile = nil
          @painting = false
          @paint_height = nil
        end



      end
    end

    if tile
      info = "Location: #{tile[:x]},#{tile[:y]},#{@selected_layer+1} - " \
             "Height: #{@map.height_map[tile[:x], tile[:y], @selected_layer] + 1}"
      @sprites["information"].setTextToFit(info)
	  @sprites["information"].visible = true
    else
      @sprites["information"].setTextToFit("")
	  @sprites["information"].visible = false
    end

    update_selection_overlay

    if Input.triggerex?(:F)
      @tool = (@tool == :flood_fill) ? :normal : :flood_fill
      @rect_start = nil
      @rect_end = nil
      update_tool_label
    elsif Input.triggerex?(:R)
      @tool = (@tool == :rect_select) ? :normal : :rect_select
      @rect_start = nil
      @rect_end = nil
      update_tool_label
    end

    if Input.triggerex?(:Z)
      id = chooseMapScreen(_INTL("Go to Map"), @map_id)

      if id > 0
        @sprites["selsprite"].othersprite = nil
        update_chosen_map(id)
      end

    elsif Input.triggerex?(:C) && !Input.press?(Input::CTRL)
      helpWindow
    end

    if Input.triggerex?(LAYER_DOWN_KEY) || (Input.jumping_down? && !Input.triggerex?(:DOWN))
      change_layer(-1)
    elsif Input.triggerex?(LAYER_UP_KEY) || (Input.jumping_up? && !Input.triggerex?(:UP))
      change_layer(+1)
    end

	@sprites["clipboard"].visible = @clipboard_armed
    update_mouse_pan
    update_camera
  end

  def update_for_layer
    @tiles.each do |tile|
      draw_height_text(tile)
    end
  end

  def update_camera
    moved = false

    amt = 6
    amt = amt * 2 if Input.press?(Input::SHIFT)

    if Input.pressex?(:LEFT) || Input.press?(Input::LEFT)
      @camera_x -= amt
      moved = true
    elsif Input.pressex?(:RIGHT) || Input.press?(Input::RIGHT)
      @camera_x += amt
      moved = true
    end

    if Input.pressex?(:UP) || Input.press?(Input::UP)
      @camera_y -= amt
      moved = true
    elsif Input.pressex?(:DOWN) || Input.press?(Input::DOWN)
      @camera_y += amt
      moved = true
    end

    update_tile_positions if moved
  end

  def main
    loop do
      update
      pbUpdateSpriteHash(@sprites)

      if Input.trigger?(Input::BACK) &&
         !Input.trigger?(Input::MOUSERIGHT)

        if pbConfirmMessage(_INTL("Save changes?"))
	      $disk_manager.save(@map, sprintf("Map%03d.rxdata", @map_id)) 
          pbMessage(_INTL("To ensure that the changes remain, close and reopen RPG Maker XP."))
        end

        break if pbConfirmMessage(
          _INTL("Exit from the editor?")
        )
      elsif Input.press?(Input::CTRL) && Input.triggerex?(:S)
		  
        if pbConfirmMessage(_INTL("Save changes?"))
	      $disk_manager.save(@map, sprintf("Map%03d.rxdata", @map_id)) 
          pbMessage(_INTL("To ensure that the changes remain, close and reopen RPG Maker XP."))
        end
	  end 
    end

    dispose
  end

  def dispose
    pbDisposeSpriteHash(@sprites)

    @tiles.each do |t|
      t[:sprite].dispose
    end

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

class Game_Character
  attr_accessor :height_level
end 

EventHandlers.add(:on_step_taken, :update_height_level,
  proc { |event|
    map = event.map 
	map = $game_map unless map 
	return unless map 
	x = event.x
	y = event.y 
	event.height_level = map.get_current_height(x,y)
  }
)