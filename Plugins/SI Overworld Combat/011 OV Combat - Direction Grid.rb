class OverworldGrid
  DISPLAY_TILE_WIDTH      = Game_Map::TILE_WIDTH rescue 32
  DISPLAY_TILE_HEIGHT     = Game_Map::TILE_HEIGHT rescue 32
  SOURCE_TILE_WIDTH       = 32
  SOURCE_TILE_HEIGHT      = 32
  ZOOM_X                  = DISPLAY_TILE_WIDTH / SOURCE_TILE_WIDTH
  ZOOM_Y                  = DISPLAY_TILE_HEIGHT / SOURCE_TILE_HEIGHT
  def initialize(viewport)
    @viewport = viewport
    @sprites = {}
    @disposed = false
    @disabled = false
	@last_display_x = nil
    @last_display_y = nil
    @tiles_horizontal_count = (Graphics.width.to_f / Game_Map::TILE_WIDTH).ceil + 1
    @tiles_vertical_count   = (Graphics.height.to_f / Game_Map::TILE_HEIGHT).ceil + 1
  end
  

  
  def disposed?
   return @disposed
  end
  
  def update
    return if $DEBUG==false
    return if @disposed
    return if @disabled
    if Input.press?(Input::SHOWGRID) && !$game_player.moving?
	 draw_grid
	elsif !@sprites.empty?
	 pbDisposeSpriteHash(@sprites)
	 @last_display_x = nil
     @last_display_y = nil
	end
  end
  def draw_grid
     return if @last_display_x == $game_map.display_x &&
            @last_display_y == $game_map.display_y

      @last_display_x = $game_map.display_x
      @last_display_y = $game_map.display_y

      map = $game_map
      map_display_x = (map.display_x.to_f / Game_Map::X_SUBPIXELS).round
      map_display_x = ((map_display_x + (Graphics.width / 2)) * ZOOM_X) - (Graphics.width / 2) if ZOOM_X != 1
      map_display_y = (map.display_y.to_f / Game_Map::Y_SUBPIXELS).round
      map_display_y = ((map_display_y + (Graphics.height / 2)) * ZOOM_Y) - (Graphics.height / 2) if ZOOM_Y != 1
      map_display_x_tile = map_display_x / Game_Map::TILE_WIDTH
      map_display_y_tile = map_display_y / Game_Map::TILE_HEIGHT
      start_x = [-map_display_x_tile, 0].max
      start_y = [-map_display_y_tile, 0].max
      end_x = @tiles_horizontal_count - 1
      end_x = [end_x, map.width - map_display_x_tile - 1].min
      end_y = @tiles_vertical_count - 1
      end_y = [end_y, map.height - map_display_y_tile - 1].min
      return if start_x > end_x || start_y > end_y || end_x < 0 || end_y < 0
    color = Color.new(-255, -255, -255, 128)
      # Update all tile sprites representing this map
      (start_x..end_x).each do |i|
        tile_x = i + map_display_x_tile
        (start_y..end_y).each do |j|
          tile_y = j + map_display_y_tile
		  screen_x,screen_y = get_screen_from_tile_pos(tile_x,tile_y)
        next if @sprites.key?("#{tile_x}_#{tile_y}")
		  
        draw(screen_x.to_i, screen_y.to_i, tile_x, tile_y, Game_Map::TILE_WIDTH, Game_Map::TILE_HEIGHT, color)
        end
      end


  end
  def draw(x, y, tilex, tiley, width, height, color)
	if @sprites["#{tilex}_#{tiley}"].nil?
    @sprites["#{tilex}_#{tiley}"] = Sprite.new(@viewport) if !@sprites.key?("#{tilex}_#{tiley}")
    @sprites["#{tilex}_#{tiley}"].bitmap = Bitmap.new("Graphics/UI/OV HUD/bitmap.png")
    @sprites["#{tilex}_#{tiley}"].x = x
    @sprites["#{tilex}_#{tiley}"].y = y
    @sprites["#{tilex}_#{tiley}"].z = 10
    @sprites["#{tilex}_#{tiley}"].visible = true
	end
  end

def get_tile_from_screen_pos2(screen_x,screen_y)
   x = (((screen_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X)
   y = (((screen_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y)
   return x,y
 end

def get_screen_from_tile_pos(x, y)
   screen_x = ((x * Game_Map::REAL_RES_X - $game_map.display_x) / Game_Map::X_SUBPIXELS).to_f
   screen_y = ((y * Game_Map::REAL_RES_Y - $game_map.display_y) / Game_Map::Y_SUBPIXELS).to_f
   return screen_x, screen_y
end

end

