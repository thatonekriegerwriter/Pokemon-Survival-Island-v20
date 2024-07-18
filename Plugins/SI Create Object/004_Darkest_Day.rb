$ball_order=[]

class PokemonGlobalMetadata
    attr_accessor :collection_maps
    attr_accessor :collection_maps_count
    attr_accessor :water_playing
	 
	def collection_maps
	@collection_maps = {} if @collection_maps.nil?
	return @collection_maps
	end
	def collection_maps_count
	@collection_maps_count = 0 if @collection_maps_count.nil?
	return @collection_maps_count
	end
	def water_playing
	@water_playing = false if @water_playing.nil?
	return @water_playing
	end	
end



class OWBallThrowSprite
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,ball_used,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @map.nil?
	@map=$game_map
	end
    @ball_used=ball_used
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
	 if @landing_coord!=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y] && $PokemonGlobal.in_dungeon==false
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
	end
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end

  def pokeball_ov_behavior
    case @phase
    when 0 # flying to landing point
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y
    when 1 # is there an event here?
      @frames=0
      @ball.src_rect.x=0
      event_id=@map.check_event(*@end_coord)
	  if event_id.is_a?(Integer)
      if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
		pbSEPlay("Battle ball hit")
        @event=@map.events[event_id]
		@pkmn = @event.pokemon #pbMapInterpreter.execute_script(script)
		
		@pkmn = @event.pokemon
		
		
		
		@pkmn.status_turns=0 if @pkmn.status_turns.nil?
		@pkmn.status_turns-=1 if  @pkmn.status_turns>0
		@pkmn.status=:NONE if @pkmn.status_turns==0
		if @pkmn.fainted?
        @event.removeThisEventfromMap
        pbPlayerEXP(@pkmn)
        pbHeldItemDropOW(@pkmn,true)
        @phase = 5
		else 
        @phase = 2
		if @event.ov_battle.nil?
		  @event.ov_battle=OverworldCombat.new(@event)			    
		end
		thefight = @event.ov_battle
		@catch=thefight.capture_calcs(@event,@item_used,@dir)
		thefight=nil
        $scene.spriteset.addUserAnimation(BALL_CATCH_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
		end
      else
        @phase = 5
	  end
      else
        @phase = 5
	  end
    when 2
      @frames+=1
      @phase=(@catch ? 3 : 4) if @frames>=BALL_CATCH_WAIT_FRAMES
    when 3
	   pbSEPlay("Battle catch click")
        pbPlayerEXP(@pkmn)
		@pkmn = @event.pokemon #pbMapInterpreter.execute_script(script)
		 @pkmn.calc_stats
        pbAddPokemonSilent(@pkmn)
        $scene.spriteset.addUserAnimation(BALL_SUCCESS_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
        pbHeldItemDropOW(@pkmn)
        pkmnAnim(@pkmn)
        OverworldPBEffects.onCatch(@ball_used,@pkmn)
        @event.removeThisEventfromMap
        @phase=5
    when 4
		pbSEPlay("Battle recall")
      $scene.spriteset.addUserAnimation(BALL_RELEASE_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
	  makeAggressive(@event)
      @phase=5
    when 5
      self.dispose
      return
    end

  
  end
  
  
  
  
  def update
    return if !@ball || @disposed
    @ball.update
	pokeball_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
    $game_temp.pokemon_calling=false
  end





  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end



class OWThrowSpriteEgg
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,ball_used,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @map.nil?
	@map=$game_map
	end
    @ball_used=ball_used
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
    graphic = pbResolveBitmap("Graphics/Characters/#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end

  def pokeball_ov_behavior
    case @phase
    when 0 # flying to landing point
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y
    when 1 # is there an event here?
      @frames=0
      @ball.src_rect.x=0
	  $player.place(*@end_coord)
    when 5
      self.dispose
      return
    end

  
  end
  
  
  
  
  def update
    return if !@ball || @disposed
    @ball.update
	pokeball_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
    $game_temp.pokemon_calling=false
  end





  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end




class OWPokemonReleaseSprite
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,pokemon,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @map.nil?
	@map=$game_map
	end
    @pokemon=pokemon
	ball_used= @pokemon.poke_ball
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
	 if @landing_coord!=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y] && $PokemonGlobal.in_dungeon==false
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
	end
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end
  

  def pokemon_ov_behavior
    case @phase
    when 0 # flying to landing point
	
	
	
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y


    when 1 # is there an event here?
	
	
	
      @frames=0
      @ball.src_rect.x=0
      event_id=@map.check_event(*@end_coord)
	  @phase = 5 if $game_temp.preventspawns==true



	  if event_id.is_a?(Integer) && @phase != 5 
         if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
		 pbSEPlay("Battle ball hit")
         @event=@map.events[event_id]
		 @pkmn = @event.pokemon 
         pbStoreTempForBattle()
         if $PokemonGlobal.roamEncounter!=nil # i.e. $PokemonGlobal.roamEncounter = [i,species,poke[1],poke[4]]
      parameter1 = $PokemonGlobal.roamEncounter[0].to_s
      parameter2 = $PokemonGlobal.roamEncounter[1].to_s
      parameter3 = $PokemonGlobal.roamEncounter[2].to_s
      $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
      $PokemonGlobal.roamEncounter = ["+parameter1+",:"+parameter2+","+parameter3+","+parameter4+"]
    else
      $PokemonGlobal.roamEncounter = nil
    end
	     $PokemonGlobal.battlingSpawnedPokemon = true
         @phase = 5
	    if @pkmn.status==:PARALYSIS||@pkmn.status==:SLEEP||@pkmn.status==:FROZEN
	  pbMessage("\\ts[]" + (_INTL"#{user_pkmn.name} got a quick hit on #{@pkmn.name}!\\wtnp[10]"))
	  damage = getDamager(user_pkmn,1,:TACKLE,false)
	  @pkmn.hp-= damage
	  end
	  
		if @pkmn.fainted?
        @event.removeThisEventfromMap
        pbPlayerEXP(@pkmn)
        pbHeldItemDropOW(@pkmn,true)
        @phase = 5
		else
	  pbSingleOrDoubleWildBattle( @map.map_id, @event.x, @event.y, @pkmn )
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  @event.removeThisEventfromMap
	  pbResetTempAfterBattle()
		end
      else
	    $game_temp.pokemon_calling=false
        @phase = 5
	  end
      else
	    $game_temp.pokemon_calling=false
		pbSEPlay("Battle recall")
	    pbPlacePokemon(@end_coord[0], @end_coord[1],@pokemon)
		
		@pokemon.set_in_world(true,@map.events[getOverworldPokemonfromPokemon(@pokemon)])
        @phase = 5
	  end


    when 5
      self.dispose
      return
    end

  
  end

  
  
  def update
    return if !@ball || @disposed
    @ball.update
	pokemon_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
   
	  $game_temp.pokemon_calling=false
  end

  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end




class OWItemUseSprite
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,ball_used,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @running == true
    @running=false
	end
    @running=false
	if @map.nil?
	@map=$game_map
	end
    @item_used=ball_used
	
	
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    
    itm = GameData::Item.get(@item_used)
	@itm = itm
    @jump_peak = 0 if @item_used == :MACHETE || itm.is_placeitem? || (itm.is_tool? && !itm.is_pokeball? && @item_used != :BAIT && @item_used != :STONE)
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8 if @item_used != :MACHETE || itm.is_placeitem? || (itm.is_tool? && !itm.is_pokeball? && @item_used != :BAIT && @item_used != :STONE)  # 3/4 of tile for ledge jumping
	
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
	
	 if @landing_coord!=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y] && $PokemonGlobal.in_dungeon==false
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
	end

    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    @ball.opacity = 0 if itm.is_placeitem? || (itm.is_tool? && !itm.is_pokeball? && @item_used != :BAIT && @item_used != :STONE)
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end

  
  def itemeffect
    item = @item_used
    item_data=GameData::Item.get(@item_used)
	 facingEvent = $game_player.pbFacingEvent
    if item_data.is_tool?
     case @item_used
     when :MACHETE
	  if facingEvent
	   if facingEvent.name[/cuttree/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
	   end
	  end

     when :IRONPICKAXE

	  if facingEvent
	   if facingEvent.name[/smashrock/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
	   end
	  end


     when :IRONAXE
	  if facingEvent
	   if facingEvent.name[/berryplant/i]
         $stats.cut_count += 1
         #pbSmashEvent(facingEvent)
	   end
	  end
     when :IRONHAMMER
	  if facingEvent
	  end
     when :POLE
	   case $game_player.direction
	     when 2 then jump(0, 3)   # down
	     when 4 then jump(-3, 0)    # left
	     when 6 then jump(3, 0)   # right
	     when 8 then jump(0, -3)    # up
	   end
     when :WOODENPAIL

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		      when :DAMPMULCH
      berry_plant.water(20)
    when :DAMPMULCH2
      berry_plant.water(40)
	else
      berry_plant.water(10)
		        end
		  
		  end
	   end
	  end

	 when :SQUIRTBOTTLE
	 
	 
	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		          when :DAMPMULCH
		            berry_plant.water(50)
		          when :DAMPMULCH2
		            berry_plant.water(75)
		      	else
 		           berry_plant.water(25)
		        end
		  
		  end
	   end
	  end



	 when :SPRAYDUCK

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		      when :DAMPMULCH
		          berry_plant.water(40)
		        when :DAMPMULCH2
		          berry_plant.water(60)
		    	else
		          berry_plant.water(20)
		        end
		  
		  end
	   end
	  end


	 when :WAILMERPAIL

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		          when :DAMPMULCH
      berry_plant.water(60)
    when :DAMPMULCH2
      berry_plant.water(90)
	else
      berry_plant.water(30)
		        end
		  
		  end
	   end
	  end


	 when :SPRINKLOTAD
	 
	 
	 

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		          when :DAMPMULCH
      berry_plant.water(70)
    when :DAMPMULCH2
      berry_plant.water(100)
	else
      berry_plant.water(35)
		        end
		  
		  end
	   end
	  end


	  
	  
	 when :SHOVEL
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
	 coords = [facing[1],facing[2]]
    terrain = $game_map.terrain_tag(facing[1], facing[2], true)
	  if !pbSeenTipCard?(:SHOVEL)
	    pbShowTipCard(:SHOVEL)
	  end
	  
	  
	  if !facingEvent.nil? && facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		  berry = berry_plant.berry_id
    if berry_plant.growing? && berry_plant.growth_stage == 1
        if pbConfirmMessage(_INTL("You may be able to dig up the berry. Dig up the {1}?", GameData::Item.get(berry).name))
            berry_plant.reset
            if rand(100) < 50
                $bag.add(berry)
                pbMessage(_INTL("The dug up {1} was in good enough condition to keep.",GameData::Item.get(berry).name))
            else
                pbMessage(_INTL("The dug up {1} broke apart in your hands.",GameData::Item.get(berry).name))
            end
        end
    end
         end
	   
     elsif terrain.can_dig
	 
	 if $PokemonGlobal.collection_maps[$game_map.map_id].nil?
	  $PokemonGlobal.collection_maps[$game_map.map_id] = []
	 end
	 if !$PokemonGlobal.collection_maps[$game_map.map_id].include?(coords)
	  pbSEPlay("shovel")
      pbCollectionMain2
      pbItemBall(:SOFTSAND)
	  $PokemonGlobal.collection_maps[$game_map.map_id] << coords
	 else
	  pbSEPlay("shovelhittingrock")
	 
    end


     else
	 puts "whomp2"
	  end
	 
	  
	  
	 when :OLDROD
  itm = GameData::Item.get(:OLDROD)
      self.dispose
        ItemHandlers.triggerUseInField(itm) 
  return true
	 when :GOODROD
  itm = GameData::Item.get(:GOODROD)
      self.dispose
        ItemHandlers.triggerUseInField(itm) 
  return true
	 when :SUPERROD
  itm = GameData::Item.get(:SUPERROD)
      self.dispose
        ItemHandlers.triggerUseInField(itm) 
		
  return true
	 
	 
	 
	 
     end
	else
    end

  return true
  end
  


  def item_ov_behavior
    case @phase
    when 0 # flying to landing point
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y
      @phase = 1 if @item_used == :MACHETE || @itm.is_placeitem? || (@itm.is_tool? && !@itm.is_pokeball? && @item_used != :BAIT && @item_used != :STONE)
	  
	  
    when 1 # is there an event here?
	  @phase = 5
	    @running = true
      @frames=0
      @ball.src_rect.x=0
      event_id=@map.check_event(*@end_coord)
	  if event_id.is_a?(Integer)
      if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
	    pbSEPlay("Battle ball hit") if @item_used!=:MACHETE
        @event=@map.events[event_id]
		@pkmn = @event.pokemon
		if @event.ov_battle.nil?
		  @event.ov_battle=OverworldCombat.new(@event)			    
		end
		thefight = @event.ov_battle
		thefight.player_action(@event,@item_used,@dir)
		#player_pokemonattack($game_temp.current_pkmn_controlled,event,pkmn.moves[$PokemonGlobal.hud_selector], distance)
        @phase = 5
      else
	    itemeffect
        @phase = 5
	  end
      else
	    itemeffect
        @phase = 5
	  end

	  
    when 5
	
      self.dispose
	@running = true
      return
	  
    end

	
  end
  

  
  def update
    return if !@ball || @disposed
    @ball.update
	item_ov_behavior if @running==false
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	else
	@running = true
	end
    $game_temp.pokemon_calling=false
	return
  end





  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end

















def pbThrowOWBall
  active_ball=$ball_order[$PokemonGlobal.ball_hud_index]
  
  
  
  if $bag.quantity(active_ball)<=0
    pbPlayBuzzerSE
    return
  end
  
  
  $bag.remove(active_ball)
  
  
  
  
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
  
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
  
  $scene.spriteset.addUserSprite(OWBallThrowSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))
end


def pbThrowPokemon
   if $ball_order[$PokemonGlobal.ball_hud_index].inworld.nil?
  $ball_order[$PokemonGlobal.ball_hud_index].set_in_world(false)
    end
  return if $game_temp.preventspawns == true
  if $ball_order[$PokemonGlobal.ball_hud_index].inworld==true
  
  
  
  
  
  
  if true
   $game_temp.preventspawns=true
   event = getOverworldPokemonfromPokemon($ball_order[$PokemonGlobal.ball_hud_index])
   
   
   
   if !event.nil?
   $game_temp.following_ov_pokemon=false if $game_temp.following_ov_pokemon!=false
   pbReturnPokemon(event,true)
   else
   
   $ball_order[$PokemonGlobal.ball_hud_index].set_in_world(false)  if !defined?($ball_order[$PokemonGlobal.ball_hud_index].inworld)
   end
  $game_temp.pokemon_calling=false
   
   end
   
   
   
   
   
  else
  
  active_ball=$ball_order[$PokemonGlobal.ball_hud_index].poke_ball
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
  FollowingPkmn.toggle_off if FollowingPkmn.get_pokemon == $ball_order[$PokemonGlobal.ball_hud_index]
	
	
	
	
	
	
	
	
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  
  
  
  
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
   pokemon = $ball_order[$PokemonGlobal.ball_hud_index]
  $scene.spriteset.addUserSprite(OWPokemonReleaseSprite.new([start_coord,landing_coord],pokemon,$game_map,Spriteset_Map.viewport))
  
  
  end






  $game_temp.pokemon_calling=false
end


def overworld_item_behavior(active_ball)
  itm = GameData::Item.get(active_ball)
  pbSEPlay("Battle throw") if itm.is_pokeball? || @item_used == :BAIT || @item_used == :STONE || itm.is_dart?
  pbSEPlay("Sword") if active_ball==:MACHETE
  
  
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  amt = 1 
  amt = 3 if itm.is_dart? || active_ball==:STONE
  case $game_player.direction
  when 2; landing_coord[1]+=amt
  when 4; landing_coord[0]-=amt
  when 6; landing_coord[0]+=amt
  when 8; landing_coord[1]-=amt
  end
	can_do = reduceStaminaBasedOnItem(active_ball)
	puts can_do
    return false if can_do==false
  
  
  $scene.spriteset.addUserSprite(OWItemUseSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))


end

def bait_is_a_special 
  active_ball=:BAIT
  if Input.trigger?(Input::SHIFT)
  ItemHandlers.triggerUseFromBag(itm)
  else
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
  
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
  
  $scene.spriteset.addUserSprite(OWBallThrowSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))
  end
end


def pbgetOWEffect
  active_ball=$ball_order[$PokemonGlobal.ball_hud_index]
  pbPlayBuzzerSE if $bag.quantity(active_ball)<=0
  return if $bag.quantity(active_ball)<=0
  itm = GameData::Item.get(active_ball)
  $bag.remove(active_ball) if itm.is_dart? || active_ball == :STONE || active_ball == :BAIT
  ItemHandlers.triggerUseFromBag(itm) if itm.is_placeitem?
  overworld_item_behavior(active_ball) if itm.is_overworld?
  bait_is_a_special if active_ball==:BAIT
  if active_ball!=:BAIT && !itm.is_overworld? && !itm.is_placeitem? 
   if decreaseStamina(5)
  ItemHandlers.triggerUseFromBag(itm) 
   end
  end
  return
end
