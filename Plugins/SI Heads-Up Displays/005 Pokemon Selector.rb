

class SelectionDisplay
  SELECTION_DRAG_DELAY = 18
  def initialize(viewport)
    @viewport = viewport
	@sprites = {}
   @sprites["square"] = IconSprite.new(@viewport)
    @sprites["square"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
   @sprites["square"].z = 99999
    @mouse_start_x = nil  # X position where the left-click started
    @mouse_start_y = nil  # Y position where the left-click started
    @mouse_end_x = nil  # X position where the left-click is
    @mouse_end_y = nil  # Y position where the left-click is
    @drawing = false  # To track whether we are currently drawing
    @line_width = 1  # Width of the outline
    @color = Color.new(255, 0, 0)  # Color of the square outline (red)
    @disposed = false
    @prior_mode = nil
  end
 
  def dispose
	pbDisposeSpriteHash(@sprites)
	@disposed=true
  end
  
  def hide
   @sprites.each_key do |i|
	@sprites.visible=false
   end
  end
  
  def show
   @sprites.each_key do |i|
	@sprites.visible=true
   end
  end
  
  def disposed?
   return @disposed
  end
  
  def draw_square(x1, y1, x2, y2)
    @sprites["square"].bitmap.clear  # Clear previous drawings
    # Calculate square's dimensions
    width = (x2 - x1).abs
    height = (y2 - y1).abs
    x = [x1, x2].min  # Get the top-left corner
    y = [y1, y2].min  # Get the top-left corner

    # Draw the hollow square (four sides)
    @sprites["square"].bitmap.fill_rect(x, y, width, @line_width, @color)  # Top side
    @sprites["square"].bitmap.fill_rect(x, y, @line_width, height, @color)  # Left side
    @sprites["square"].bitmap.fill_rect(x + width - @line_width, y, @line_width, height, @color)  # Right side
    @sprites["square"].bitmap.fill_rect(x, y + height - @line_width, width, @line_width, @color)  # Bottom side
  end

  def prior_mode(mode)
    @prior_mode = mode
  end
  def check_events_in_square
    x1,y1 = get_tile_from_screen_pos2(@mouse_start_x, @mouse_start_y)
    x2,y2 = get_tile_from_screen_pos2(@mouse_end_x, @mouse_end_y)
  
    start_x = [x1, x2].min
    start_y = [y1, y2].min
    end_x = [x1, x2].max
    end_y = [y1, y2].max


    followers = $DynamicEvents.allied_mobs_for_map
    return if followers.empty?
    followers.each do |event|
	   pkmn = event.pokemon
	   next if event.nil?
       if event.x.between?(start_x, end_x) && event.y.between?(start_y, end_y)
         puts "#{pkmn.name} (#{event.id}) is inside the square!"
         pbSelectThisPokemon(pkmn)
	   else 
	     pbDeselectThisPokemon(pkmn)
       end
	  
	  
    end
  end

  def mouse_tile_has_pokemon?
   event_id = $game_map.check_event(*get_tile_mouse_on)
   ($game_map.events[event_id] && $game_map.events[event_id].is_a?(Game_PokeEventA)) || event_id == $game_player
  end
  
  def update
    return if @disposed
     bonus = 2 
	# if Input.press?(Input::ALTERNATEMOUSEMODE) && $mouse.current_mode!=:FOLLOW
	#  @prior_mode = $mouse.current_mode if $mouse.current_mode!=:FOLLOW
	#  $mouse.set_mode(:FOLLOW)
	# elsif Input.release?(Input::ALTERNATEMOUSEMODE) && @drawing==false && @prior_mode!=:FOLLOW
	#  $mouse.set_mode(@prior_mode)
	# end
    if Input.held_for?(Input::TOGGLETYPE) >= SELECTION_DRAG_DELAY && !@drawing && !mouse_tile_has_pokemon? && 
     @mouse_start_x = Input.mouse_x + bonus
     @mouse_start_y = Input.mouse_y + bonus
     @drawing = true
	  @prior_mode = $mouse.current_mode if $mouse.current_mode!=:SQUARE
	  $mouse.set_mode(:SQUARE)
    end
    if Input.held_for?(Input::TOGGLETYPE) >= SELECTION_DRAG_DELAY  && @drawing
      @mouse_end_x = Input.mouse_x + bonus
      @mouse_end_y = Input.mouse_y + bonus
      draw_square(@mouse_start_x, @mouse_start_y, @mouse_end_x, @mouse_end_y)  # Draw the square based on mouse positions
	  check_events_in_square
    end 
    if Input.release?(Input::TOGGLETYPE) && @drawing
      reset_square
    end 
	 
  end

  def update_egj
    return if @disposed
     bonus = 2 
	 
     if ((Input.time?(Input::MOUSELEFT) >= 1 && $mouse.current_mode!=:FOLLOW) || Input.trigger?(Input::MOUSELEFT) && $mouse.current_mode==:SQUARE  ) && @drawing==false && !($game_map.check_event(*get_tile_mouse_on)).is_a?(Integer)
      @mouse_start_x = Input.mouse_x + bonus
      @mouse_start_y = Input.mouse_y + bonus
      @drawing = true
	  @prior_mode = $mouse.current_mode if $mouse.current_mode!=:SQUARE
	  $mouse.set_mode(:SQUARE)
     end
     if ((Input.time?(Input::MOUSELEFT) >= 1 && $mouse.current_mode!=:FOLLOW) || Input.press?(Input::MOUSELEFT) && $mouse.current_mode==:SQUARE )  && @drawing==true
      @mouse_end_x = Input.mouse_x + bonus
      @mouse_end_y = Input.mouse_y + bonus
      draw_square(@mouse_start_x, @mouse_start_y, @mouse_end_x, @mouse_end_y)  # Draw the square based on mouse positions
	  check_events_in_square
    end  
     if Input.release?(Input::MOUSELEFT) && @drawing==true
      reset_square
     end   
  end





  def reset_square
    @sprites["square"].bitmap.clear 
	  $mouse.set_mode(:DEFAULT)
    @mouse_start_x = nil
    @mouse_start_y = nil
    @mouse_end_x = nil
    @mouse_end_y = nil
    @drawing = false
  end

end




class SelectionBaseDisplay
  attr_reader :sprites
  def initialize(viewport)
    @viewport = viewport
	@sprites = {}
	@sprites2 = nil
    @disposed = false
  end
 
  def dispose
	pbDisposeSpriteHash(@sprites)
	pbDisposeSpriteHash(@sprites2)
	@disposed=true
  end
  
  def hide
   @sprites.each_key do |i|
	@sprites.visible=false
   end
   @sprites2.each_key do |i|
	@sprites2.visible=false
   end
  end
  
  def show
   @sprites.each_key do |i|
	@sprites.visible=true
   end
   @sprites2.each_key do |i|
	@sprites2.visible=true
   end
  end
  
  def disposed?
   return @disposed
  end
  
  def remove_sprite(sprite)
	   if !@sprites[sprite].nil?
	   if !@sprites[sprite].disposed?
	    @sprites[sprite].visible=false
	    @sprites[sprite].dispose
		@sprites.delete(sprite)
		end
		end
		
  end
  
  def create_consistant_sizes(width,height)
     case [width,height]
	  when [256,256]
	    return 128,128
	  when [128,128]
	    return 128,128
	  when [32,32]
	    return 128,128
      else
	    return 128,128
      end
  end
  
  def get_graphic_size(event)
         
	     graphic = event.pages[0].graphic.character_name if defined?(event.pages)
	     graphic = event.event.pages[0].graphic.character_name if defined?(event.event)
		 
         fname = pbResolveBitmap("Graphics/Characters/#{graphic}")
		 if fname
        potato = Bitmap.new(fname) 
        return potato.width,potato.height
		else
        return 32,32
		
		end
  end 
  
  def clear_lock_on
    return if @sprites2.nil?
    $game_temp.lockontarget=false
	 @sprites2.visible=false
	 @sprites2.dispose
	 @sprites2 = nil
  
  end
  def clear_sprites
    clear_lock_on
   @sprites.each_key do |sprite|
     remove_sprite(sprite)
   end
	
  end
  def update
    return if @disposed
	 if $game_temp.lockontarget!=false
	   event = $game_temp.lockontarget
	   if !event.nil? 
	   event_id = event.id
	   
	   if @sprites2.nil?
	    @sprites2 = IconSprite.new(@viewport)
		@sprites2.setBitmap("Graphics/UI/Cursor/selectede.png")
	   end
       if !@sprites2.disposed?
	    width,height = get_graphic_size(event)
	    width,height = create_consistant_sizes(width,height)
       @sprites2.x = ScreenPosHelper.pbScreenX(event) - 17
       @sprites2.y = ScreenPosHelper.pbScreenY(event) - (height/2) - 6
       @sprites2.z = ScreenPosHelper.pbScreenZ(event) + 1
	   end


	   
	   end
     elsif !@sprites2.nil?
	   clear_lock_on 
	 end

	 
	   filtered_pokemon = $PokemonGlobal.selected_pokemon_cleaned

	 filtered_pokemon.each do |pkmn|
	   next if pkmn==0
	   next if !defined?(pkmn.associatedevent)
	   next if pkmn.is_a?(Symbol)
	   next if pkmn.associatedevent.nil?
	   event_id = pkmn.associatedevent
	   if event_id.nil? && pkmn.in_world==true
	    event_id = getOverworldPokemonfromPokemon(pkmn)
		 pkmn.associatedevent=event_id
	   end
	   next if event_id.nil?
	   event = $game_map.events[event_id]
	   if event.is_a?(Game_PokeEventA)
	   if !event.nil?
	   if @sprites["Arrow#{event_id}#{event.pokemon.name}"].nil?
	    @sprites["Arrow#{event_id}#{event.pokemon.name}"] = IconSprite.new(@viewport)
		@sprites["Arrow#{event_id}#{event.pokemon.name}"].setBitmap("Graphics/UI/Cursor/selected2.png")
	   end
	   
         if !@sprites["Arrow#{event_id}#{event.pokemon.name}"].disposed?
	    width,height = get_graphic_size(event)
	    width,height = create_consistant_sizes(width,height)
       @sprites["Arrow#{event_id}#{event.pokemon.name}"].x = ScreenPosHelper.pbScreenX(event) - 17
       @sprites["Arrow#{event_id}#{event.pokemon.name}"].y = ScreenPosHelper.pbScreenY(event) - (height/2) - 6
       @sprites["Arrow#{event_id}#{event.pokemon.name}"].z = ScreenPosHelper.pbScreenZ(event) + 1
	     end


	   else
	   
	   if !@sprites["Arrow#{event_id}#{pkmn.name}"].nil? && !@sprites["Arrow#{event_id}#{pkmn.name}"].disposed?
	    @sprites["Arrow#{event_id}#{pkmn.name}"].visible=false
	    @sprites["Arrow#{event_id}#{pkmn.name}"].dispose
		@sprites.delete("Arrow#{event_id}#{pkmn.name}")
	   end

	   end
	   else
	   
	   end
	   
	 end
	 
	 
	 
   if filtered_pokemon.length < @sprites.length
     $player.party.each do |pkmn|
	    next if pkmn.in_world==false
	   event_id = pkmn.associatedevent
	   if event_id.nil?
	    event_id = getOverworldPokemonfromPokemon(pkmn)
	   end
	   next if event_id.nil?
	   event = $game_map.events[event_id]
	   if !event.nil?
	   if @sprites["Arrow#{event_id}#{pkmn.name}"].nil?
	    @sprites["Arrow#{event_id}#{pkmn.name}"] = IconSprite.new(@viewport)
		@sprites["Arrow#{event_id}#{pkmn.name}"].setBitmap("Graphics/UI/Cursor/selected2.png")
	   end
         if !@sprites["Arrow#{event_id}#{pkmn.name}"].disposed?
	    width,height = get_graphic_size(event)
	    width,height = create_consistant_sizes(width,height)
       @sprites["Arrow#{event_id}#{pkmn.name}"].x = ScreenPosHelper.pbScreenX(event) - 17
       @sprites["Arrow#{event_id}#{pkmn.name}"].y = ScreenPosHelper.pbScreenY(event) - (height/2) - 6
       @sprites["Arrow#{event_id}#{pkmn.name}"].z = ScreenPosHelper.pbScreenZ(event) + 1
	   #puts $PokemonGlobal.selected_pokemon.to_s
	     end
	   else
		 
	 	if !@sprites["Arrow#{event_id}#{pkmn.name}"].nil? && !@sprites["Arrow#{event_id}#{pkmn.name}"].disposed?
	    @sprites["Arrow#{event_id}#{pkmn.name}"].visible=false
	    @sprites["Arrow#{event_id}#{pkmn.name}"].dispose
		@sprites.delete("Arrow#{event_id}#{pkmn.name}")
	   end
	  end
	 
	 end
   
   
   end



  end



end

  EventHandlers.add(:on_map_transfer, :clear_selection_sprites,
    proc { |_old_map_id|
  $selection_arrows.clear_sprites
    }
  )