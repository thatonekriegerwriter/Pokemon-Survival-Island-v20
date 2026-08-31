class MouseTrail
  attr_accessor :styler_on
  attr_accessor :user_styler
  attr_accessor :styler_dead
  attr_accessor :max_trail_length
  attr_accessor :trail_fade_speed
  attr_accessor :trigger_cooldown
  attr_accessor :target_hits_f
  attr_accessor :styler_health
  
  
  
  def initialize(viewport = nil)
    @viewport = viewport || Viewport.new(0, 0, Graphics.width, Graphics.height)
	 placeholder_styler = ItemData.new(:CAPTURESTYLUS)
	 set_styler(placeholder_styler)
    @trail_sprites = []
    @trail_locations = {}
    @most_recent_trail = nil
    @styler_on = false
    @styler = create_styler
    @min_x = 999
    @max_x = 0
    @min_y = 999
    @max_y = 0
    @trigger_cooldown = 0
    @stamina_cooldown = 0
    @target_hits_f = 0
    @disposed = false
    @styler_dead = false
	 @stamina_cooldown_target = 40
	 @lastsound = 0
	
	
	
  end
 
  def set_styler(styler)
      @user_styler = styler
      @styler_health = @user_styler.stats.health
      power = @user_styler.stats.power
      line = @user_styler.stats.line
      recovery = @user_styler.stats.recovery
      latent_power = @user_styler.stats.latent_power
      fading = @user_styler.stats.fading
	  
	  
      @max_trail_length = 40 + line # Maximum number of trail segments, 25 too low
      @trail_fade_speed = 1.5 + fading  # Speed of fading, lower is slower
	   @trigger_target = 60 - latent_power
       @power = power+1
	   @recovery = recovery+1
    #  @assists = @user_styler.capture_styler_stats["Assists"]
  end
  
  
  def are_two_trails_touching(given_key)
     
     given_value = @trail_locations[given_key]
	 return if given_value.nil?  
     @trail_locations.each do |key, coords|
	   #puts "Coords: #{[coords[0],coords[1]].to_s}"
       @min_x = [@min_x, coords[0]].min
       @max_x = [@max_x, coords[0]].max

       @min_y = [@min_y, coords[1]].min
       @max_y = [@max_y, coords[1]].max
	  # puts "Mins: #{[@min_x,@min_y].to_s} Maxs: #{[@max_x,@max_y].to_s}"
	    next if key == given_key  # Skip the given key itself
       coord_pair = coords # Combine x and y into an array for easy comparison
       if coord_pair == given_value
	    if [@min_x, @min_y] == [@max_x, @max_y]
         return false
	    end
	     	spriteindex = @trail_sprites.index(key)
	     	if !spriteindex.nil?
			 if !@trail_sprites[spriteindex].disposed?
	     	 if spriteindex >= (@trail_sprites.length/1.85)
		        return false
		     end
            end
	       end
		  return true
       end
	   
	   
     end
    return false
  end
  
  def dispose
    @trail_sprites.each do |sprite|
       sprite.dispose
    end
	@styler.dispose
	@disposed=true
  end
  
  def view_styler
  
  
  end

  def get_tile_line_on(x1,y1)
     x = (((x1 * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).round
     y = (((y1 * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).round
     return x,y
  end


  def update
    return if $game_temp.in_menu
    return if @disposed
    @styler = create_styler if !@styler || @styler && @styler.disposed?
    if $PokemonGlobal.ball_hud_enabled==true && $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]!=:CAPTURESTYLER
	 @styler.visible = false if @styler.visible==true
    @trail_sprites.each_with_index do |sprite, index|
      sprite.opacity -= @trail_fade_speed
      if sprite.opacity <= 0
	    @trail_locations.delete(sprite)
        sprite.dispose
        @trail_sprites.delete_at(index)
      end
    end
	 return 
	end
    if @styler_on==false
	 @styler.visible = false if @styler.visible==true
    @trail_sprites.each_with_index do |sprite, index|
      sprite.opacity -= @trail_fade_speed
      if sprite.opacity <= 0
	    @trail_locations.delete(sprite)
        sprite.dispose
        @trail_sprites.delete_at(index)
      end
    end
	 return 
	 else 
	 @styler.visible = true if @styler.visible==false
	end
    
	 update_styler
	 triggered=false

    @trail_sprites.each_with_index do |sprite, index|
    sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light.png") if index <= (@trail_sprites.length/1.85)
	sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light_unsafe.png") if index >= (@trail_sprites.length/1.85)
	  sprite.visible =true
      sprite.opacity -= @trail_fade_speed
	  
      if sprite.opacity <= 0
	    @trail_locations.delete(sprite)
        sprite.dispose
        @trail_sprites.delete_at(index)
      end
    end
	 if Input.press?(Input::MOUSELEFT) && Input.mouse_in_window? 
	 if Input.mouse_in_window? && @styler_dead==false 
	
	 pbBGSPlay("charge_loop",75) 
	 if @stamina_cooldown==0 && !($DEBUG && Input.press?(Input::CTRL))
	   decreaseStamina(1.8) 
	   @stamina_cooldown=@stamina_cooldown_target
	 else
	   @stamina_cooldown-=1 if @stamina_cooldown>0
	 end

	 else
	   pbBGSFade(1.0)
	 end
    # Create a new trail segment at the current mouse position
	 most_recent_trail = nil
    most_recent_trail = create_trail_segment if Input.mouse_in_window? && @styler_dead==false
    @most_recent_trail = most_recent_trail if !most_recent_trail.nil?
    # Update and fade existing trail segments
	if @trigger_cooldown==0 && @styler_dead==false
    if are_two_trails_touching(@most_recent_trail)
	   
	  if @min_x!=@max_x && @min_y!=@max_y
      (@min_x..@max_x).each do |x|
		     next if triggered==true
         (@min_y..@max_y).each do |y|
		     next if triggered==true
	        #puts "Coordinates: #{[x,y].to_s}}"
            event_id = $game_map.check_event(x,y)
	           if $game_map.events[event_id]
	            #puts "event_id: #{[event_id].to_s}}"
  				    if $game_map.events[event_id].name[/vanishingEncounter/]
				      triggered=true
				      event = $game_map.events[event_id]
	                 event.remaining_steps+=10
				      pkmn = event.pokemon
				      pkmn.hits+=@power
					  makeAggressive(event) if !pkmn.is_aggressive?
					   target_hits = get_target_hits(pkmn)
					   #puts "Target Hits: #{target_hits}"
					   #puts "Hits: #{pkmn.hits}"
					   extra = ""
					   extra = " Only halfway to go!" if pkmn.hits==(target_hits/2).to_i
					   extra = " Almost There!" if pkmn.hits+10>=target_hits
	                 sideDisplay("#{pkmn.hits} hits on #{pkmn.name}!#{extra}") if pkmn.hits<target_hits
					    #puts "sound_index_calc: #{(pkmn.hits / (target_hits / 8.0)).floor.round}"
					    sound_index = [(pkmn.hits / (target_hits / 8.0)).floor, 7].min
						if @lastsound == sound_index && sound_index!=7
						  sound_index += rand(2)==0 ? 1 : -1
						  sound_index = 0 if sound_index<0 && @lastsound != 0
						  sound_index = 1 if sound_index<0 && @lastsound != 1
						  @lastsound = sound_index
						else
						 @lastsound = sound_index
						end
					    #puts "sound_index: #{sound_index}"
					    #puts sound_index
                     sound_filename = "Stylus#{sound_index + 1}"
					   pbSEPlay(sound_filename)
					   @styler_health+=@recovery
					  if pkmn.hits>=target_hits
                     pbPlayerEXP(pkmn,$player.able_party)
		              pkmn.poke_ball = :POKEBALLC
		              pkmn.calc_stats
					   if $game_map.map_id!=11
					    if true
	                 sideDisplay("#{pkmn.name} has been caught!")
                     $scene.spriteset.addUserAnimation(7, event.x, event.y, true, 1)
					   pbHeldItemDropOW(pkmn)
					   pkmnAnim(pkmn)
                     pbAddPokemonSilent(pkmn)
                     event.removeThisEventfromMap
					     end
					   elsif $game_map.map_id == 11 && (pokemon = get_form_for_species(pkmn))
					    $game_temp.preventspawns=false
						$PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false
	                 sideDisplay("#{pkmn.name} has been defeated!")
					    x=event.x
						y=event.y
                     event.removeThisEventfromMap
					    pbPlaceEncounter(x,y,pokemon,2)
					   else
						$PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false
	                 sideDisplay("#{pkmn.name} has been defeated!")
					   pbHeldItemDropOW(pkmn,true)
					    event.removeThisEventfromMap
					   end
					  end

					   @trigger_cooldown=@trigger_target
				   end
                 
               
			   end
         end
      end
   	  end

   end
   else
    @trigger_cooldown-=1
   end
    @min_x = 999
    @max_x = 0
    @min_y = 999
    @max_y = 0
	end
     if Input.release?(Input::USE)
	   pbBGSFade(1.0)
	 end
  end
   def screen_x
    ret = ((@real_x.to_f - self.map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += @width * Game_Map::TILE_WIDTH / 2
    ret += self.x_offset
    return ret
   end
   
   def screen_y
    ret = ((@real_y.to_f - self.map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
   end
   def get_form_for_species(pkmn)
     if pkmn.species == :GIRATINA && pkmn.form == 0
			pokemon = Pokemon.new(:GIRATINA, pkmn.level)
			pokemon.item = :GRISEOUSORB
			pokemon.form = 1
			pokemon.shiny = true
        
		
		
     elsif pkmn.species == :MEWTWO && pkmn.form == 0
			pokemon = Pokemon.new(:MEWTWO, pkmn.level)
			pokemon.form = 1
			pokemon.shiny = true
     elsif pkmn.species == :MEWTWO && pkmn.form == 1
			pokemon = Pokemon.new(:MEWTWO, pkmn.level)
			pokemon.form = 2
			pokemon.shiny = true
	 
	 
	 else
	    return false
	 end
	   return pokemon
   end
  
  def get_target_hits(pkmn)
	target_hits = pkmn.hp/4
	target_hits = 50 if target_hits > 50 
	target_hits = 10 if target_hits < 10
    target_hits = @target_hits_f if @target_hits_f!=0
    return target_hits
  end



  def remove_oldest_trail
    sprite = @trail_sprites[0]
	@trail_locations.delete(sprite)
    @trail_sprites.shift.dispose
  end


  def update_styler
   return if @styler_dead==true
   if @user_styler
    if @styler_health<=0
	   @styler_dead=true
      @styler.setBitmap("Graphics/Plugins/Capture Styler/loss.gif")
	  @styler.bitmap.looping=false
	end
   end
   return if @styler_dead==true
   @styler.x = Input.mouse_x
   @styler.y = Input.mouse_y + 5
  end
  
  def create_styler
   styler = IconSprite.new(@viewport)
   
   styler.setBitmap("Graphics/Plugins/Capture Styler/capture styler.gif")
   styler.ox = styler.bitmap.width/2
   styler.oy = styler.bitmap.height/2
   styler.x = Input.mouse_x
   styler.y = Input.mouse_y + 5
   styler.z = 99999
  
   return styler
  end
  
  private
  

  def create_trail_segment
    amt = 8
    sprite = IconSprite.new(@viewport)
    sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light.png") if @trail_sprites.length <= (@trail_sprites.length/1.85)
	sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light_unsafe.png") if @trail_sprites.length >= (@trail_sprites.length/1.85)
    sprite.ox = sprite.bitmap.width/2
    sprite.oy = sprite.bitmap.height/2
    sprite.x = @styler.x
    sprite.y = @styler.y+amt
    sprite.z = 99998  # Ensure it's on top
	 sprite.visible = false
	sprite.call_id = @trail_sprites.length
    @trail_sprites.push(sprite)
    @trail_locations[sprite]=get_tile_line_on(sprite.x,sprite.y-amt-5)
    # Limit the number of trail segments
    if @trail_sprites.size > @max_trail_length
	  remove_oldest_trail
    end
	 return sprite
  end





end
