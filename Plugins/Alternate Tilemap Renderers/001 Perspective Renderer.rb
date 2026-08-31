class TilemapRenderer
 class TilesetBitmaps
    attr_reader :bitmap_wraps
 end 
  class AutotileBitmaps < TilesetBitmaps
    attr_reader :bitmap_wraps
  end


class TileSprite < Sprite
 alias old_set_bitmap_perspectile set_bitmap
 def set_bitmap(filename, tile_id, autotile, animated, priority, bitmap)
   
    old_set_bitmap_perspectile(filename, tile_id, autotile, animated, priority, bitmap)
	if CustomTilemaps::RENDERTYPE == 1
	#self.ox = DISPLAY_TILE_WIDTH/2
	#self.oy = DISPLAY_TILE_HEIGHT
	end 
 end 
end 
end 
class TilemapRenderer
class PerspectiveStrip < Sprite
  attr_accessor :map_y
    attr_accessor :need_refresh
  attr_accessor :layer
    def initialize(viewport)
      super(viewport)
      @map_y = 0
      @need_refresh = true
	  @layer = nil
    end

end


end 





class PerspectiveTilemapRenderer < TilemapRenderer
   MAX_PRIORITY = 5
   PITCH = 8
   STRIP_SIZE = 16
   CURVE = true
   def initialize(viewport)
     super(viewport)
	 @pitch = PITCH
	 @strip_size = STRIP_SIZE
	 @curve = CURVE
	 @bitmaps = []
      @strips = []
	@animated_tiles = []
	@autotile_rect_cache = {}
	@tile_sources = {}
	@layer_bitmaps = Array.new($game_map.zsize) do
     Array.new(MAX_PRIORITY + 1) do
      Bitmap.new(
        $game_map.width * DISPLAY_TILE_WIDTH + Graphics.width,
        $game_map.height * DISPLAY_TILE_HEIGHT + @strip_size
      )
     end
    end
     # @tiles_vertical_count.times do |j|
     #   @strips[j] = PerspectiveStrip.new(@viewport)
     # end
   end 

  # x and y are map coordinates
  def refresh_tile_coordinates(tile, sprite_x, sprite_y, tile_x, tile_y)
    screen_x = (sprite_x * DISPLAY_TILE_WIDTH) - @pixel_offset_x
    screen_y = (sprite_y * DISPLAY_TILE_HEIGHT) - @pixel_offset_y


  zoom = (screen_y - Graphics.height / 2.0) *
         (@pitch.to_f / (Graphics.height * 25)) + 1
  
  
  tile.x = screen_x#Graphics.width / 2 + (screen_x - Graphics.width / 2) * zoom

  tile.y = Graphics.height / 2 +
           (screen_y - Graphics.height / 2) * zoom

  tile.zoom_x = zoom
  tile.zoom_y = 1
  end
  def refresh_tile_bitmap(tile, map, tile_id)
   super(tile, map, tile_id)
  end 
  def refresh_tile_z(tile, map, y, layer, tile_id)
    super(tile, map, y, layer, tile_id)
  end

  def refresh_tile(tile, sprite_x, sprite_y, tile_x, tile_y, map, layer, tile_id)
   #puts [x, y, tile_id].to_s if tile_id > 0
   #puts [tile.bitmap, tile.visible, tile_id].to_s
    refresh_tile_bitmap(tile, map, tile_id)
    refresh_tile_coordinates(tile, sprite_x, sprite_y, tile_x, tile_y)
    refresh_tile_z(tile, map, sprite_y, layer, tile_id)
    tile.need_refresh = false
  end
  
  def get_visible_tiles(map)
  
  
  end 
  
  def get_tile_bitmap(map, tile_id)
  return nil if tile_id < TILES_PER_AUTOTILE

  single_autotile_start_id = TILESET_START_ID
  true_tileset_start_id = TILESET_START_ID
  extra_autotile_arrays = EXTRA_AUTOTILES[map.tileset_id]

  if extra_autotile_arrays
    large_autotile_count = extra_autotile_arrays[0].length
    single_autotile_count = extra_autotile_arrays[1].length
    single_autotile_start_id += large_autotile_count * TILES_PER_AUTOTILE
    true_tileset_start_id += large_autotile_count * TILES_PER_AUTOTILE
    true_tileset_start_id += single_autotile_count
  end

  if tile_id < true_tileset_start_id
    filename = ""

    if tile_id < TILESET_START_ID
      filename = map.autotile_names[(tile_id / TILES_PER_AUTOTILE) - 1]
    elsif tile_id < single_autotile_start_id
      filename = extra_autotile_arrays[0][(tile_id - TILESET_START_ID) / TILES_PER_AUTOTILE]
    else
      filename = extra_autotile_arrays[1][tile_id - single_autotile_start_id]
    end

    return @autotiles[filename]
  else
    return @tilesets[map.tileset_name]
  end
  end 
def get_tileset_rect(map, tile_id, rect)
  rect.x = ((tile_id - TILESET_START_ID) % TILESET_TILES_PER_ROW) * SOURCE_TILE_WIDTH
  rect.y = ((tile_id - TILESET_START_ID) / TILESET_TILES_PER_ROW) * SOURCE_TILE_HEIGHT

  filename = map.tileset_name

  if @tilesets.bitmap_wraps[filename]
    height = @tilesets[filename].height
    col = (tile_id - TILESET_START_ID) * SOURCE_TILE_HEIGHT /
          (TILESET_TILES_PER_ROW * height)

    rect.x += col * TILESET_TILES_PER_ROW * SOURCE_TILE_WIDTH
    rect.y -= col * height
  end

  rect
end
def get_autotile_rect(filename, tile_id, rect, frame = nil)
  frame = @autotiles.current_frame(filename) if frame.nil?
  bitmap = @autotiles[filename]

  if bitmap.height == SOURCE_TILE_HEIGHT
    rect.x = frame * SOURCE_TILE_WIDTH
    rect.y = 0
    return rect
  end

  wraps = @autotiles.bitmap_wraps[filename]
  high_id = ((tile_id % TILES_PER_AUTOTILE) >= TILES_PER_AUTOTILE / 2)

  rect.x = 0
  rect.y = (tile_id % TILES_PER_AUTOTILE) * SOURCE_TILE_HEIGHT

  if wraps && high_id
    rect.x = SOURCE_TILE_WIDTH
    rect.y -= SOURCE_TILE_HEIGHT * TILES_PER_AUTOTILE / 2
  end

  rect.x += frame * SOURCE_TILE_WIDTH * (wraps ? 2 : 1)

  rect
end

def cache_autotile_rects(filename, tile_id)
  rects = []

  @autotiles.frame_count(filename).times do |frame|
    rects << get_autotile_rect(
      filename,
      tile_id,
      Rect.new(0, 0, SOURCE_TILE_WIDTH, SOURCE_TILE_HEIGHT),
      frame
    )
  end

  rects
end
  def get_tile_rect(map, tile_id)
    rect = Rect.new(0, 0, SOURCE_TILE_WIDTH, SOURCE_TILE_HEIGHT)


  single_autotile_start_id = TILESET_START_ID
  true_tileset_start_id = TILESET_START_ID
  extra_autotile_arrays = EXTRA_AUTOTILES[map.tileset_id]

  if extra_autotile_arrays
    large_autotile_count = extra_autotile_arrays[0].length
    single_autotile_count = extra_autotile_arrays[1].length
    single_autotile_start_id += large_autotile_count * TILES_PER_AUTOTILE
    true_tileset_start_id += large_autotile_count * TILES_PER_AUTOTILE
    true_tileset_start_id += single_autotile_count
  end

  if tile_id < true_tileset_start_id
    if tile_id < TILESET_START_ID
      filename = map.autotile_names[(tile_id / TILES_PER_AUTOTILE) - 1]
    elsif tile_id < single_autotile_start_id
      filename = extra_autotile_arrays[0][(tile_id - TILESET_START_ID) / TILES_PER_AUTOTILE]
    else
      filename = extra_autotile_arrays[1][tile_id - single_autotile_start_id]
    end
    return get_autotile_rect(filename, tile_id, rect)
  else
    return get_tileset_rect(map, tile_id, rect)
  end 
  
  end 
  
  def get_tile_source(map, tile_id)
    bitmap = get_tile_bitmap(map, tile_id)
    return [nil, nil] if bitmap.nil?
    rect = get_tile_rect(map, tile_id)
    return [bitmap, rect]
  end


def draw_tile(bitmap, map, x, y, layer, tile_id, source_bitmap, filename, rects)
  return if tile_id == 0
  frame = @autotiles.current_frame(filename)
  source_rect = rects[frame]
  return if source_bitmap.nil?


  bitmap.blt(
    x * DISPLAY_TILE_WIDTH,
    y * DISPLAY_TILE_HEIGHT,
    source_bitmap,
    source_rect
  )
end


  def refresh_animated_tiles(map)
  @animated_tiles.each do |x, y, layer, tile_id, priority, source_bitmap, filename, rects|
      bitmap = @layer_bitmaps[layer][priority]
  bitmap.clear_rect(
  x * DISPLAY_TILE_WIDTH,
  y * DISPLAY_TILE_HEIGHT,
  DISPLAY_TILE_WIDTH,
  DISPLAY_TILE_HEIGHT
)
    draw_tile(bitmap, map, x, y, layer, tile_id, source_bitmap, filename, rects)
  end
end

  def draw_position(layer, map, x, y, priority)
      bitmap = @layer_bitmaps[layer][priority]
      tile_id = map.data[x, y, layer]
	  return if tile_id == 0
	  
      source_bitmap, source_rect = get_tile_source(map, tile_id)#get_tile_bitmap(map, tile_id) 
	  if true 
      single_autotile_start_id = TILESET_START_ID
      true_tileset_start_id = TILESET_START_ID
      extra_autotile_arrays = EXTRA_AUTOTILES[map.tileset_id]
      if extra_autotile_arrays
        large_autotile_count = extra_autotile_arrays[0].length
        single_autotile_count = extra_autotile_arrays[1].length
        single_autotile_start_id += large_autotile_count * TILES_PER_AUTOTILE
        true_tileset_start_id += large_autotile_count * TILES_PER_AUTOTILE
        true_tileset_start_id += single_autotile_count
      end
      if tile_id < true_tileset_start_id
    if tile_id < TILESET_START_ID
      filename = map.autotile_names[(tile_id / TILES_PER_AUTOTILE) - 1]
    elsif tile_id < single_autotile_start_id
      filename = extra_autotile_arrays[0][(tile_id - TILESET_START_ID) / TILES_PER_AUTOTILE]
    else
      filename = extra_autotile_arrays[1][tile_id - single_autotile_start_id]
    end
        if @autotiles.animated?(filename)
		 key = [filename, tile_id]

         rects = (@autotile_rect_cache[key] ||= cache_autotile_rects(filename, tile_id))
        @animated_tiles << [x, y, layer, tile_id, priority, source_bitmap, filename, rects]
        end
	  end 
	  end
      return if source_bitmap.nil?

      bitmap.blt(
        x * DISPLAY_TILE_WIDTH,
        y * DISPLAY_TILE_HEIGHT,
        source_bitmap,
        source_rect
      )

  end 
  
  def refresh_strip_bitmap(map, layer, priority)

      bitmap = @layer_bitmaps[layer][priority]
  bitmap.clear

  @animated_tiles.clear if layer == 0 && priority == 0
  map.width.times do |x|
    map.height.times do |y|
      draw_position(layer, map, x, y, priority)
    end
  end
  
  
  
  end 
  
  
def build_strips(map)
  @strips ||= []
  @strips.each(&:dispose)
  @strips.clear
    3.times do |layer|
     (0..MAX_PRIORITY).each do |priority|
      bitmap = @layer_bitmaps[layer][priority]
      refresh_strip_bitmap(map, layer, priority)
      camera_x = (map.display_x / Game_Map::X_SUBPIXELS).round
      camera_y = (map.display_y / Game_Map::Y_SUBPIXELS).round
  # draw tiles into bitmap here

  (0...(bitmap.height / @strip_size)).each do |i|
    strip = PerspectiveStrip.new(@viewport)
    strip.bitmap = bitmap
    strip.src_rect.set(
      camera_x,
      camera_y + (i * @strip_size),
      Graphics.width* 2,
      @strip_size * 2
    )
   
    strip.map_y = i
	
    strip.layer = layer
    strip.x = 0#Graphics.width / 2
    strip.ox = 0#bitmap.width / 2
#strip.y = 
    strip.z = priority#(strip.map_y * SOURCE_TILE_HEIGHT * 2) + priority
    strip.y = (i * @strip_size)#(i * @strip_size) - @pixel_offset_y#(i * @strip_size) - @oy
    @strips << strip
  end
     end 
    end 

end

def update_strips(map)
  camera_x = (map.display_x / Game_Map::X_SUBPIXELS).round
  camera_y = (map.display_y / Game_Map::Y_SUBPIXELS).round

  @strips.each_with_index do |strip, j|
    strip.src_rect.set(
      camera_x - Graphics.width / 2,
      camera_y + (strip.map_y * @strip_size),
      Graphics.width * 2,
      @strip_size * 2
    )
    zoom_x = 1.0
    zoom_y = 1.0
	
    if true 
    y = strip.map_y * @strip_size


    unless @pitch == 0
      zoom_x = (y - Graphics.height / 2.0) *
               (@pitch.to_f / (Graphics.height * 25))

      zoom_x += 1

      if @curve
        zoom_y = zoom_x

        yadd = @strip_size * 1.0 * (1 - zoom_y) *
               ((1 - zoom_y) /
               (2 * ((@pitch.to_f / 100) /
               (Graphics.height.to_f / (@strip_size * 2)))) + 0.5)

        y += yadd
      end
    end
    end
    strip.x = Graphics.width / 2
    strip.ox = Graphics.width
    strip.y = y
	strip.oy = @strip_size
    strip.zoom_x = zoom_x
    strip.zoom_y = zoom_y
  end


end 

  def update
    # Update tone
    if @old_tone != @tone
      @tiles.each do |col|
        col.each do |coord|
          coord.each { |tile| tile.tone = @tone }
        end
      end
      @old_tone = @tone.clone
    end
    # Update color
    if @old_color != @color
      @tiles.each do |col|
        col.each do |coord|
          coord.each { |tile| tile.color = @color }
        end
      end
      @old_color = @color.clone
    end
    # Recalculate autotile frames
    @tilesets.update
    @autotiles.update
    if @autotiles.changed && !@strips.empty?
     refresh_animated_tiles($game_map)
    end
    do_full_refresh = @need_refresh
    if @viewport.ox != @old_viewport_ox || @viewport.oy != @old_viewport_oy
      @old_viewport_ox = @viewport.ox
      @old_viewport_oy = @viewport.oy
      do_full_refresh = true
    end
    # Check whether the screen has moved since the last update
    @screen_moved = false
    @screen_moved_vertically = false
    if $PokemonGlobal.bridge != @bridge
      @bridge = $PokemonGlobal.bridge
      @screen_moved_vertically = true   # To update bridge tiles' z values
    end
    do_full_refresh = true if check_if_screen_moved
    # Update all tile sprites
    visited = []
    @tiles_horizontal_count.times do |i|
      visited[i] = []
      @tiles_vertical_count.times { |j| visited[i][j] = false }
    end
	
	
	
	
  #$map_factory.maps.each do |map|
	if @need_refresh
    build_strips($game_map)
	end 
	if @screen_moved || @screen_moved_vertically
	update_strips($game_map)
	
	end 
 # end
	
	if false
	
    $map_factory.maps.each do |map|
      # Calculate x/y ranges of tile sprites that represent them
      map_display_x = (map.display_x.to_f / Game_Map::X_SUBPIXELS).round
      map_display_x = ((map_display_x + (Graphics.width / 2)) * ZOOM_X) - (Graphics.width / 2) if ZOOM_X != 1
      map_display_y = (map.display_y.to_f / Game_Map::Y_SUBPIXELS).round
      map_display_y = ((map_display_y + (Graphics.height / 2)) * ZOOM_Y) - (Graphics.height / 2) if ZOOM_Y != 1
      map_display_x_tile = map_display_x / DISPLAY_TILE_WIDTH
      map_display_y_tile = map_display_y / DISPLAY_TILE_HEIGHT
	  
	  
	  
	  
	  
	  
      start_x = [-map_display_x_tile, 0].max
      start_y = [-map_display_y_tile, 0].max
      end_x = @tiles_horizontal_count - 1
      end_x = [end_x, map.width - map_display_x_tile - 1].min
      end_y = @tiles_vertical_count - 1
      end_y = [end_y, map.height - map_display_y_tile - 1].min
	  
	  
	  
	  
	  
      next if start_x > end_x || start_y > end_y || end_x < 0 || end_y < 0
      # Update all tile sprites representing this map
      (start_x..end_x).each do |i|
        tile_x = i + map_display_x_tile
		
		
        (start_y..end_y).each do |j|
          tile_y = j + map_display_y_tile
		  
          sprite_x = i
          sprite_y = j	  
          @tiles[sprite_x][sprite_y].each_with_index do |tile, layer|
            tile_id = map.data[tile_x, tile_y, layer]
            if do_full_refresh || tile.need_refresh || tile.tile_id != tile_id
              refresh_tile(tile, sprite_x, sprite_y, tile_x, tile_y, map, layer, tile_id)
            else
              refresh_tile_frame(tile, tile_id) if tile.animated && @autotiles.changed
              # Update tile's x/y coordinates
              refresh_tile_coordinates(tile, sprite_x, sprite_y, tile_x, tile_y) if @screen_moved
              # Update tile's z value
              refresh_tile_z(tile, map, sprite_y, layer, tile_id) if @screen_moved_vertically
            end
          end
          # Record x/y as visited
          visited[sprite_x][sprite_y] = true
        end
      end
    end
	
	
	
	
	
	
	
	
	
    # Clear all unvisited tile sprites
    @tiles.each_with_index do |col, i|
      col.each_with_index do |coord, j|
        next if visited[i][j]
        coord.each do |tile|
          tile.set_bitmap("", 0, false, false, 0, nil)
          tile.shows_reflection = false
          tile.bridge           = false
        end
      end
    end
   end  
 @need_refresh = false
    @autotiles.changed = false
  end



end 