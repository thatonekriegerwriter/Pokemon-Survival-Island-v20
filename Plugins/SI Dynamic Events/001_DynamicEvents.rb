class Interpreter
  def setup_starting_event
    $game_map.refresh if $game_map.need_refresh
    # Set up common event if one wants to start
    if $game_temp.common_event_id > 0
      setup($data_common_events[$game_temp.common_event_id].list, 0)
      $game_temp.common_event_id = 0
      return
    end
    # Check all map events for one that wants to start, and set it up
    $game_map.events.each_value do |event|
      next if !event.starting
      if event.trigger < 3   # Isn't autorun or parallel processing
        event.lock
        event.clear_starting
      end
      setup(event.list, event.id, event.map.map_id)
      return
    end
    $DynamicEvents.each_value do |event|
      next if !event.starting
      if event.trigger < 3   # Isn't autorun or parallel processing
        event.lock
        event.clear_starting
      end
      setup(event.list, event.id, event.map.map_id)
      return
    end
    # Check all common events for one that is autorun, and set it up
    $data_common_events.compact.each do |common_event|
      next if common_event.trigger != 1 || !$game_switches[common_event.switch_id]
      setup(common_event.list, 0)
      return
    end
  end

 def update
    @loop_count = 0
    loop do
      @loop_count += 1
      if @loop_count > 100   # Call Graphics.update for freeze prevention
        Graphics.update
        @loop_count = 0
      end
      # If this interpreter's map isn't the current map or connected to it,
      # forget this interpreter's event ID
      if $game_map.map_id != @map_id && !$map_factory.areConnected?($game_map.map_id, @map_id)
        @event_id = 0
      end
      # Update child interpreter if one exists
      if @child_interpreter
        @child_interpreter.update
        @child_interpreter = nil if !@child_interpreter.running?
        return if @child_interpreter
      end
      # Do nothing if a message is being shown
      return if @message_waiting
      # Do nothing if any event or the player is in the middle of a move route
      if @move_route_waiting
        return if $game_player.move_route_forcing
        $game_map.events.each_value do |event|
          return if event.move_route_forcing
        end
        $DynamicEvents.each_value do |event|
          return if event.move_route_forcing
        end
        $game_temp.followers.each_follower do |event, follower|
          return if event.move_route_forcing
        end
        @move_route_waiting = false
      end
      # Do nothing while waiting
      if @wait_count > 0
        return if System.uptime - @wait_start < @wait_count
        @wait_count = 0
        @wait_start = nil
      end
      # Do nothing if the pause menu is going to open
      return if $game_temp.menu_calling
      # If there are no commands in the list, try to find something that wants to run
      if @list.nil?
        setup_starting_event if @main
        return if @list.nil?   # Couldn't find anything that wants to run
      end
      # Execute the next command
      return if execute_command == false
      # Move to the next @index
      @index += 1
    end
  end

  def command_end
    @list = nil
    end_follower_overrides
    # If main map event and event ID are valid, unlock event
    if @main 
	 if @event_id.is_a?(String) && @event_id.start_with?("MOB_") && $DynamicEvents.hostile_mobs[@event_id] && $DynamicEvents.hostile_mobs[@event_id].map_id == $game_map.map_id
      $DynamicEvents.hostile_mobs[@event_id].unlock
	 elsif @event_id.is_a?(String) && @event_id.start_with?("ALLY_") && $DynamicEvents.allied_mobs[@event_id] && $DynamicEvents.allied_mobs[@event_id].map_id == $game_map.map_id
      $DynamicEvents.allied_mobs[@event_id].unlock
	 elsif @event_id.is_a?(String) && @event_id.start_with?("BLOCK_") && $DynamicEvents.block_data[@event_id] && $DynamicEvents.block_data[@event_id].map_id == $game_map.map_id
      $DynamicEvents.block_data[@event_id].unlock
	 elsif @event_id.is_a?(String) && @event_id.start_with?("TEMP_") && $DynamicEvents.block_data[@event_id] && $DynamicEvents.block_data[@event_id].map_id == $game_map.map_id
      $DynamicEvents.temp_data[@event_id].unlock
	 elsif @event_id.is_a?(Integer) && @event_id > 0 && $game_map.events[@event_id]
      $game_map.events[@event_id].unlock
	 end 
    end
  end

  def get_character(parameter = 0)
    case parameter
    when -1   # player
      return $game_player
    when 0    # this event
      events = get_event_type_from_id
      return (events) ? events[@event_id] : nil
    else      # specific event
      events = get_event_type_from_id(parameter)
      return (events) ? events[parameter] : nil
    end
  end
 
  def get_event_type_from_id(parameter=@event_id)
    return $game_map.events if parameter.is_a?(Integer)
    return $DynamicEvents.hostile_mobs if parameter.is_a?(String) && parameter.start_with?("MOB_") && $DynamicEvents.hostile_mobs[@event_id] && $DynamicEvents.hostile_mobs[@event_id].map_id == $game_map.map_id
    return $DynamicEvents.allied_mobs if parameter.is_a?(String) && parameter.start_with?("ALLY_") && $DynamicEvents.allied_mobs[@event_id] && $DynamicEvents.allied_mobs[@event_id].map_id == $game_map.map_id
    return $DynamicEvents.block_data if parameter.is_a?(String) && parameter.start_with?("BLOCK_") && $DynamicEvents.block_data[@event_id] && $DynamicEvents.block_data[@event_id].map_id == $game_map.map_id
    return $DynamicEvents.temp_data if parameter.is_a?(String) && parameter.start_with?("TEMP_") && $DynamicEvents.temp_data[@event_id] && $DynamicEvents.temp_data[@event_id].map_id == $game_map.map_id
  
  end 

end 

class PokemonMapFactory
def map_offset(map_from, map_to)
  id_from = map_from.is_a?(Integer) ? map_from : map_from.map_id
  id_to   = map_to.is_a?(Integer) ? map_to : map_to.map_id

  offset_x = 0
  offset_y = 0

  MapFactoryHelper.eachConnectionForMap(id_from) do |conn|
    if conn[0] == id_from && conn[3] == id_to
      # map_from -> map_to
      offset_x = ((conn[4] - conn[1]) * Game_Map::REAL_RES_X)
      offset_y = ((conn[5] - conn[2]) * Game_Map::REAL_RES_Y)
      break
    elsif conn[3] == id_from && conn[0] == id_to
      # map_to -> map_from
      offset_x = ((conn[1] - conn[4]) * Game_Map::REAL_RES_X)
      offset_y = ((conn[2] - conn[5]) * Game_Map::REAL_RES_Y)
      break
    end
  end

  return offset_x, offset_y
end

end 

class Sprite_Multimap < RPG::Sprite
  attr_accessor :character

  def initialize(viewport, character = nil)
    super(viewport)
    @character    = character
    @oldbushdepth = 0
    @spriteoffset = false
    if !character || character == $game_player || (character.name[/reflection/i] rescue false)
      @reflection = Sprite_Reflection.new(self, character, viewport)
    end
    @surfbase = Sprite_SurfBase.new(self, character, viewport) if character == $game_player
    self.zoom_x = TilemapRenderer::ZOOM_X
    self.zoom_y = TilemapRenderer::ZOOM_Y
    update
  end
  
  def set_xy(x=nil,y=nil)
    self.x = x if !x.nil?
    self.y = y if !y.nil?
  end
  def set_x(x=nil)
    self.x = x if !x.nil?
  end
  def set_y(y=nil)
    self.y = y if !y.nil?
  end
  
  def groundY
    return @character.screen_y_ground
  end

  def visible=(value)
    super(value)
    @reflection.visible = value if @reflection
  end

  def dispose
    @bushbitmap&.dispose
    @bushbitmap = nil
    @charbitmap&.dispose
    @charbitmap = nil
    @reflection&.dispose
    @reflection = nil
    @surfbase&.dispose
    @surfbase = nil
    super
  end

  def update
    super
    if @tile_id != @character.tile_id ||
       @character_name != @character.character_name ||
       @character_hue != @character.character_hue ||
       @oldbushdepth != @character.bush_depth
      @tile_id        = @character.tile_id
      @character_name = @character.character_name
      @character_hue  = @character.character_hue
      @oldbushdepth   = @character.bush_depth
      @charbitmap&.dispose
      @charbitmap = nil
      @bushbitmap&.dispose
      @bushbitmap = nil
      if @tile_id >= 384
        @charbitmap = pbGetTileBitmap(@character.map.tileset_name, @tile_id,
                                      @character_hue, @character.width, @character.height)
        @charbitmapAnimated = false
        @spriteoffset = false
        @cw = Game_Map::TILE_WIDTH * @character.width
        @ch = Game_Map::TILE_HEIGHT * @character.height
        self.src_rect.set(0, 0, @cw, @ch)
        self.ox = @cw / 2
        self.oy = @ch
      elsif @character_name != ""
        @charbitmap = AnimatedBitmap.new(
          "Graphics/Characters/" + @character_name, @character_hue
        )
        RPG::Cache.retain("Graphics/Characters/", @character_name, @character_hue) if @character == $game_player
        @charbitmapAnimated = true
        @spriteoffset = @character_name[/offset/i]
        @cw = @charbitmap.width / 4
        @ch = @charbitmap.height / 4
        self.ox = @cw / 2
      else
        self.bitmap = nil
        @cw = 0
        @ch = 0
      end
      @character.sprite_size = [@cw, @ch]
    end
    return if !@charbitmap
    @charbitmap.update if @charbitmapAnimated
    bushdepth = @character.bush_depth
    if bushdepth == 0
      self.bitmap = (@charbitmapAnimated) ? @charbitmap.bitmap : @charbitmap
    else
      @bushbitmap = BushBitmap.new(@charbitmap, (@tile_id >= 384), bushdepth) if !@bushbitmap
      self.bitmap = @bushbitmap.bitmap
    end
    self.visible = !@character.transparent
    if @tile_id == 0
      sx = @character.pattern * @cw
      sy = ((@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      self.oy = (@spriteoffset rescue false) ? @ch - 16 : @ch
      self.oy -= @character.bob_height
    end
    if self.visible
      if @character.is_a?(Game_Event) && @character.name[/regulartone/i]
        self.tone.set(0, 0, 0, 0)
      else
        pbDayNightTint(self)
      end
    end
    this_x = @character.screen_x #- offset_x 
    this_x = ((this_x - (Graphics.width / 2)) * TilemapRenderer::ZOOM_X) + (Graphics.width / 2) if TilemapRenderer::ZOOM_X != 1
    self.x          = this_x
    this_y = @character.screen_y #- offset_y
    this_y = ((this_y - (Graphics.height / 2)) * TilemapRenderer::ZOOM_Y) + (Graphics.height / 2) if TilemapRenderer::ZOOM_Y != 1
    self.y          = this_y
    self.z          = @character.screen_z(@ch)
    self.opacity    = @character.opacity
    self.blend_type = @character.blend_type
	
	
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      animation(animation, true)
      @character.animation_id = 0
    end
    @reflection&.update
    @surfbase&.update
  end
end



class Spriteset_Global
  attr_reader :overworld_sprites
  #attr_reader :custom_berry_sprites
 alias original_initialize_de initialize

  def initialize
    @overworld_sprites = OverworldSprites.new(Spriteset_Map.viewport)
    original_initialize_de
  end 
  
  
  def overworld_sprites
    @overworld_sprites ||= OverworldSprites.new(Spriteset_Map.viewport)
	return @overworld_sprites
  end 
  
  
 alias original_dispose_de dispose
  def dispose
    @overworld_sprites.dispose
    @overworld_sprites = nil
    original_dispose_de
  end

 alias original_update_de update
  def update
    @overworld_sprites.update
    original_update_de
  end
  
  
end 

class Game_Player < Game_Character
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    super
    update_stop if $game_temp.in_menu && @stopped_last_frame
    update_screen_position(last_real_x, last_real_y)
    # Update dependent events
    if (!@moved_last_frame || @stopped_last_frame ||
       (@stopped_this_frame && $PokemonGlobal.sliding)) && (moving? || jumping?)
      $game_temp.followers.move_followers
    end
    $game_temp.followers.update
    if (!@moved_last_frame || @stopped_last_frame ||
       (@stopped_this_frame && $PokemonGlobal.sliding)) && (moving? || jumping?)
    end
    # Count down the time between allowed bump sounds
    @bump_se -= 1 if @bump_se && @bump_se > 0
    # Finish up dismounting from surfing
    if $game_temp.ending_surf && !moving?
      pbCancelVehicles
      $game_temp.surf_base_coords = nil
      $game_temp.ending_surf = false
    end
    update_event_triggering
  end
end

class OverworldSprites
  def initialize(viewport)
    @viewport    = viewport
    @sprites     = []
	@current_map = nil
    @last_update = nil
    @disposed    = false
  end

  def dispose
    return if @disposed
    @sprites.each { |sprite| sprite.dispose }
    @sprites.clear
    @disposed = true
  end
  
  def current_map
   @current_map = $game_map.map_id if @current_map.nil?
   return @current_map
  end 
  
  def disposed?
    return @disposed
  end

  def refresh
    existing = @sprites.map(&:character)
  $DynamicEvents.each_value_in_connected_map do |event, index|
    next if existing.include?(event) && !$map_factory.hasMap?(event.map_id)
    @sprites << Sprite_Multimap.new(@viewport, event)
  end
  visible = $DynamicEvents.events_for_connected_map($game_map.map_id)
  @sprites.delete_if do |sprite|
    keep = visible.include?(sprite.character)
    sprite.dispose unless keep && $map_factory.hasMap?(sprite.character.map_id)
    !keep
  end
  end

  def update
     @current_map = $game_map.map_id if @current_map.nil?
    if $DynamicEvents.last_update != @last_update || $game_temp.player_transferring || $game_map.map_id!=@current_map
      refresh
      @last_update = $DynamicEvents.last_update
    end
    @sprites.each do |sprite| 
	 sprite.update
	end
    @current_map = $game_map.map_id if $game_map.map_id!=@current_map
  end


end

class DynamicEventFactory
  attr_accessor   :hostile_mobs
  attr_reader   :allied_mobs
  attr_reader   :block_data
  attr_reader   :temp_data
  attr_reader :last_update
  attr_accessor   :last_update_frame
  def initialize
    @hostile_mobs   = {}
    @allied_mobs   = {}
    @block_data   = {}
    @temp_data   = {}
    @last_update = -1
    @last_update_frame = Graphics.frame_count
  end
  
  
  
  def update!
    @last_update ||= -1
    @last_update += 1
  end 
  
  def clear_temp!
    @temp_data   = {}
  end 
  
  def last_update
    @last_update ||= -1
	return @last_update
  end 
  
def testPokeSpawn(x,y,dir)
    species = pbChooseSpeciesList
    if species
      params = ChooseNumberParams.new
      params.setRange(1, GameData::GrowthRate.max_level)
      params.setInitialValue(5)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("Set the wild {1}'s level.",
                                          GameData::Species.get(species).name), params)
      if level > 0
	pokemon = Pokemon.new(species, level)
    # trigger event on spawning of pokemon
    EventHandlers.trigger(:on_wild_pokemon_created_for_spawning, pokemon)
    spawnPokeEvent(x,y,pokemon,dir)
    pbPlayCryOnOverworld(pokemon.species, pokemon.form)
    $PokemonEncounters.reset_step_count # added such that your encounter rate resets after spawning of an overworld pokemon 
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
      end
    end

end
  
  def spawnTempEvent(x,y,data,dir=false)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    mapId = $game_map.map_id
	amt = rand(3)+3
    event.name = "vanishingEncounter.surrounding(#{amt})" 

    #--- nessassary properties ----------------------------------------
	temp_key = highest_key(@temp_data) + 1
    key_id = "TEMP_#{temp_key.to_s}"
    event.id = key_id
    event.x = x
    event.y = y
	chance = rand(100)
	
	
    #--- Graphic of the event -----------------------------------------
	

    #--- movement of the event --------------------------------
	
    event.pages[0].step_anime = false
    event.pages[0].through = false
	
    event.pages[0].move_speed = 4
    event.pages[0].move_frequency = 4
    event.pages[0].trigger = 2
    event.pages[0].move_type = 3
	
	
	
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_TempEvent.new(mapId, event, data)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.direction = dir if dir!=false
	

    @temp_data[key_id] = gameEvent
	
    #--- updating the sprites --------------------------------------------------------
    if data.is_a?(Pokemon::Move)
	 move = GameData::Move.get(data.id)
	 if move.type == :FIRE 
	   pbAddParticleEffecttoEvent("fire",@temp_data[key_id]) 
	   pbAddLightEffecttoThisEvent(@temp_data[key_id])
	 elsif move.type == :WATER
	   pbAddParticleEffecttoEvent("water",@temp_data[key_id]) 
	 else 
	   pbAddParticleEffecttoEvent("smoke",@temp_data[key_id]) 
	#pbAddLightEffecttoEvent
	 end 
	end
	
    update!
	
	 return @temp_data[key_id]

  
  
  
end

  
  def spawnPokeEvent(x,y,pokemon,dir=false)
	if $game_switches[556]==true
		 $game_map.events.each do |event|
	      if event.is_a?(Array)
	       return if event[1].name == "tutorialvanishingEncounter" 
	      else
	       return if event.name == "tutorialvanishingEncounter" 
	      end
	 end
	end
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    mapId = $game_map.map_id
	amt = rand(3)+3
    event.name = "vanishingEncounter.surrounding(#{amt})" 
    event.name = "tutorialvanishingEncounter" if $game_switches[556]==true 

    #--- nessassary properties ----------------------------------------
    key_id = "MOB_#{pokemon.personalID}"
    event.id = key_id
    event.x = x
    event.y = y
	chance = rand(100)
	is_hidden_voltorb = (chance<26 || $PokemonGlobal.in_dungeon==true) && pokemon.species == :VOLTORB
	
	
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
	
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
	 fname = "Object Ball" if is_hidden_voltorb
    fname.gsub!("Graphics/Characters/","")
    event.pages[0].graphic.character_name = fname
	
	
    #--- movement of the event --------------------------------
	
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].through = false
    event.pages[0].through = true if pokemon.types.include?(:FLYING)
    event.pages[0].always_on_top = true if pokemon.types.include?(:FLYING)
	
	
    event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[0].move_frequency = 4
    event.pages[0].trigger = 2
    event.pages[0].move_type = 3

    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement2"]
	
	if $game_switches[556]==true || is_hidden_voltorb
    event.pages[0].move_type = 0
    event.pages[0].trigger = 0 if is_hidden_voltorb
	else
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement2"]
	
	
    for move in VisibleEncounterSettings::Enc_Movements do
      if pokemon.method(move[0]).call == move[1]
        event.pages[0].move_speed = move[2] if move[2]
        event.pages[0].move_frequency = move[3] if move[3]
      end
    end
    end
	
	
	if $game_switches[556]==true
     Compiler::push_script(event.pages[0].list,sprintf("tutorial_fight('#{key_id}')"))
	elsif is_hidden_voltorb
	  create_battle(event,key_id,mapId)
	else
    Compiler::push_script(event.pages[0].list,sprintf("pokeevent_functionality"))
	end
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
	
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(mapId, event, pokemon)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.direction = dir if dir!=false
	
	
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end

    @hostile_mobs[key_id] = gameEvent
	
    $ExtraEvents.pokemon[[mapId,key_id]] = StoredEvent.new(mapId,event,pokemon)
	$ExtraEvents.pokemon[[mapId,key_id]].eventdata = gameEvent
	
	
    #--- updating the sprites --------------------------------------------------------
	$player.pokedex.register(pokemon.species)
    $player.pokedex.set_seen(pokemon.species)
	pbAddParticleEffecttoEvent("soot",@hostile_mobs[key_id]) if pokemon.shadowPokemon?
    update!
	
	
	
	
	
	 return key_id

  
  
  
end

 def create_battle(event,key_id,mapId)

	if true
	if true
	 Compiler::push_script(event.pages[0].list,sprintf(" pbStoreTempForBattle()"))
    if $PokemonGlobal.roamEncounter!=nil # i.e. $PokemonGlobal.roamEncounter = [i,species,poke[1],poke[4]]
      parameter1 = $PokemonGlobal.roamEncounter[0].to_s
      parameter2 = $PokemonGlobal.roamEncounter[1].to_s
      parameter3 = $PokemonGlobal.roamEncounter[2].to_s
      $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
      parameter = " $PokemonGlobal.roamEncounter = ["+parameter1+",:"+parameter2+","+parameter3+","+parameter4+"] "
    else
      parameter = " $PokemonGlobal.roamEncounter = nil "
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.roamer_index_for_encounter!=nil) ? " $game_temp.roamer_index_for_encounter = "+$game_temp.roamer_index_for_encounter.to_s : " $game_temp.roamer_index_for_encounter = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonGlobal.nextBattleBGM!=nil) ? " $PokemonGlobal.nextBattleBGM = '"+$PokemonGlobal.nextBattleBGM.to_s+"'" : " $PokemonGlobal.nextBattleBGM = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.force_single_battle!=nil) ? " $game_temp.force_single_battle = "+$game_temp.force_single_battle.to_s : " $game_temp.force_single_battle = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.encounter_type!=nil) ? " $game_temp.encounter_type = :"+$game_temp.encounter_type.to_s : " $game_temp.encounter_type = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    #  - add a branch to check if player can battle water pokemon from ground
    Compiler::push_branch(event.pages[0].list,sprintf(" pbCheckBattleAllowed()"))
    #  - set $PokemonGlobal.battlingSpawnedPokemon = true
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = true"),1)    
    #  - add method pbSingleOrDoubleWildBattle for the battle
	end
    parameter = " pbMessage('\\ts[]' + (_INTL'It was a Voltorb!\\wtnp[15]')) "
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    parameter = "$game_temp.in_safari = true "
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    if !$map_factory
      parameter = " pbSingleOrDoubleWildBattle( $game_map.events[#{key_id}].map.map_id, $game_map.events[#{key_id}].x, $game_map.events[#{key_id}].y, $game_map.events[#{key_id}].pokemon )"
    else
      parameter = " pbSingleOrDoubleWildBattle( $map_factory.getMap("+mapId.to_s+").events[#{key_id}].map.map_id, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].x, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].y, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].pokemon )"
    end
	if true
    parameter = "$game_temp.in_safari = false "
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #   - set $PokemonGlobal.battlingSpawnedPokemon = false
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = false"),1) 
    #  - add a method to reset temporary data to previous state, must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type
    Compiler::push_script(event.pages[0].list,sprintf(" pbResetTempAfterBattle()"),1)
    #  - add method to remove this PokeEvent from map
    if !$map_factory
      parameter = "$game_map.removeThisEventfromMap(#{key_id})"
    else
      mapId = $game_map.map_id
      parameter = "$map_factory.getMap("+mapId.to_s+").removeThisEventfromMap(#{key_id})"
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
	end
   end




 end
 
  def spawnPokeBoss(x,y,pokemon,boss,view,dir=false)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    event.name = "vanishingEncounter.surrounding(#{view})" 
    #--- nessassary properties ----------------------------------------
    mapId = $game_map.map_id
    key_id = "MOB_#{pokemon.personalID}"
    event.id = key_id
    event.x = x
    event.y = y
	 chance = rand(100)
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")
	
	
    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].through = false
    event.pages[0].move_speed = 5
    event.pages[0].move_frequency = 4
    event.pages[0].move_type = 0
    event.pages[0].trigger = 0
	
	
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
      mapId = $game_map.map_id
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type

    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.bossfight($map_factory.getMap("+mapId.to_s+").events[#{key_id}],'#{boss}')"))
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.add_rule('No Player Damage')"))
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.add_rule('Catchless')"))
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.add_rule('Theftless')"))



    Compiler::push_script(event.pages[0].list,sprintf(" pbSetSelfSwitch($map_factory.getMap("+mapId.to_s+").events[#{key_id}], 'A', true)"))
    #  - add the end of branch
	
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
	 event.pages << RPG::Event::Page.new
   
     condition2 = RPG::Event::Page::Condition.new
	 condition2.self_switch_valid  = true
	 condition2.self_switch_ch = "A"
	 event.pages[1].condition = condition2
	 
    event.pages[1].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[1].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[1].through = false
    event.pages[1].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[1].move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
    event.pages[1].move_type = 0
    event.pages[1].trigger = 2
	
	
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type

    Compiler::push_script(event.pages[1].list,sprintf(" $PokemonGlobal.ov_combat.bossfight($map_factory.getMap("+mapId.to_s+").events[#{key_id}],'#{boss}')"))
    #  - add the end of branch
    #  - finally push end command
    Compiler::push_end(event.pages[1].list)
	
	




	
	

	
	
	
	
	
	
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(@map_id, event, pokemon)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.direction = dir if dir!=false
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end
	
	
    $ExtraEvents.pokemon[[mapId,key_id]] = StoredEvent.new(mapId,event,pokemon)
	 $ExtraEvents.pokemon[[mapId,key_id]].eventdata = gameEvent
	$player.pokedex.register(pokemon)
    $player.pokedex.set_seen(pokemon.species)
	
	
    @hostile_mobs[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------

	$player.pokedex.register(pokemon.species)
    $player.pokedex.set_seen(pokemon.species)
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
	update!
	# $game_temp.spawnqueue << [gameEvent,event]
  end
 
  def spawnPokeEventForChallenge(x,y,pokemon,spawn_now=false)
    
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
	amt = rand(3)+3
    event.name = "vanishingEncounter.surrounding(#{amt})" 
    #--- nessassary properties ----------------------------------------
	amtofkeysinroom = 0
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id if spawn_now
    event.x = x if spawn_now
    event.y = y if spawn_now
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")

    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].through = false
    event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[0].move_frequency = 4
    event.pages[0].trigger = 2
    event.pages[0].move_type = 3
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement2"]
	
	
	
	
	
	
    for move in VisibleEncounterSettings::Enc_Movements do
      if pokemon.method(move[0]).call == move[1]
        event.pages[0].move_speed = move[2] if move[2]
        event.pages[0].move_frequency = move[3] if move[3]
      end
    end

	
	
	
	
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
      mapId = $game_map.map_id
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type

    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.ov_combat_loop($map_factory.getMap("+mapId.to_s+").events[#{key_id}]) if !$map_factory.getMap("+mapId.to_s+").events[#{key_id}].nil?"))

    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(@map_id, event, pokemon)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end
	
	 return if $PokemonGlobal.cur_challenge.nil?
	 return if $PokemonGlobal.cur_challenge==false
	 if spawn_now==true #&& !$game_system.map_interpreter.running?
	     @hostile_mobs[key_id] = gameEvent
	     $PokemonGlobal.cur_challenge.opponent_events<<key_id
		  makeAggressive(@hostile_mobs[key_id]) #if !pkmn.is_aggressive?
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
		  else
	 $PokemonGlobal.cur_challenge.spawn_queue << [pokemon,event]
	   end
	
   # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets

update!

  end
  
  def highest_key(hash)
    return hash.keys
             .map { |k| k[/\d+/].to_i }
             .max || -1
  end 
  
  def generateEvent(x,y,object,aat=false,store=false,direction=nil)
    true_object = nil
    true_object = object if object.is_a?(ItemData)
    true_object = ItemStorageHelper.get_item_data(object) if object.is_a?(Symbol)
    object = object.id if object.is_a?(ItemData)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    key_id_r = highest_key(@block_data) + 1
    key_id = "BLOCK_#{key_id_r.to_s}"
    event.id = key_id
	if object == :PORTABLECAMP
    event.name = "Size(3,3).noshadow"
	elsif object == :BEDROLL
    event.name = "Size(1,2).noshadow"
	elsif object == :TORCH
    event.name = "playertorch(3,3)"
	elsif object == "CampsiteDoor"
    event.name = ".noshadow"
	else 
    event.name = ".noshadow"
	end
    image = getObjectImage(object)
	fname = "#{image}.png"
	if store==true && (object==:BEDROLL||object==:PORTABLECAMP||object==:HOME )
	fname = "Packed.png"
	end
	
	if !direction.nil?
	if object == :BEDROLL && (direction == 4 || direction == 6)
    case $game_player.direction
    when 2 #then event.move_down
	 x = $game_player.x
	 y = $game_player.y+1
    when 4 #then event.move_left
	 x = $game_player.x-1
	 y = $game_player.y
    when 6 #then event.move_right
	 x = $game_player.x+1
	 y = $game_player.y
    when 8 #then event.move_up
	 x = $game_player.x
	 y = $game_player.y-1
    end
    event.name = "Size(2,1).noshadow"
	fname = "bedsideways.png"
    event.x = x
    event.y = y
	end
    end
    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = 0 #Sets movement speed.
    event.pages[0].move_frequency = 0 #Sets movement frequency.
    event.pages[0].move_type = 0 #Sets movement type.
    event.pages[0].direction_fix = true
    event.pages[0].walk_anime = false #Sets movement type.
    event.pages[0].always_on_top = aat #Sets movement type.
    event.pages[0].through = aat #Sets movement type.
    event.pages[0].trigger = 0 if object != "CampsiteDoor"
    event.pages[0].trigger = 1 if object == "CampsiteDoor"
    #--- event commands of the event -------------------------------------
    mapId = $game_map.map_id
	if object == "CampsiteDoor"
    Compiler::push_script(event.pages[0].list,sprintf("campsiteDoorEntry"))
	elsif object == "OvPot"
	elsif object == "Egg"
    Compiler::push_script(event.pages[0].list,sprintf("leggomyeggo"))
	else
    Compiler::push_script(event.pages[0].list,("object = get_own_event"))
    Compiler::push_script(event.pages[0].list,("ItemHandlers.triggerUseFromEvent(object.type,'#{key_id}') if defined?(object.type)"))
    end
	
    #Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
	true_object = object if true_object.nil?
	
	if object == :PORTABLECAMP && store==true
    event.x = x-1
    event.y = y
	end
	
	
	true_object.crate_storage.active = true if true_object.crate_storage.respond_to?(:active)
    gameEvent = Game_OVEvent.new(true_object, mapId, event)
    gameEvent.id = key_id
    gameEvent.direction = direction if !direction.nil?
	if object == :PORTABLECAMP && store==true
    gameEvent.moveto(x-1,y)
	else 
    gameEvent.moveto(x,y)
	end
    #$ExtraEvents.objects[key_id] = [mapId,event,true_object,x,y]
	
	$ExtraEvents.objects[[mapId,key_id]] = StoredEvent.new(mapId,event,true_object)
	 $ExtraEvents.objects[[mapId,key_id]].eventdata = gameEvent
	@block_data[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
	
	
	
	
	
	update!
	if store==true
	$player.held_item_object = key_id
	$player.held_item = true_object
	$game_temp.position_calling = true
	$game_system.save_disabled = true
	end
	update!
	
	return key_id
  end

  def generateBerryPlant(x,y)
    event = $DynamicEvents.generateEvent(x,y,object,aat,store,direction)
	return event
    event = RPG::Event.new(x,y)
    event.name = "BerryPlant.center"
    key_id = (($game_map.events.keys.max)|| -1) + 1
    event.id = key_id
    mapId = $game_map.map_id
    event.x = x
    event.y = y
    event.pages[0].move_speed = 2 #Sets movement speed.
    event.pages[0].move_frequency = 2 #Sets movement frequency.
    event.pages[0].move_type = 0 #Sets movement type.
    event.pages[0].direction_fix = true
    event.pages[0].walk_anime = false #Sets movement type.
    event.pages[0].step_anime = true #Sets movement type.
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = true #Sets movement type.
    event.pages[0].trigger = 0
    Compiler::push_script(event.pages[0].list,sprintf("pbBerryPlant"))
    Compiler::push_end(event.pages[0].list)
	
    gameEvent = Game_OVEvent.new(:BERRYPLANT, @map_id, event)
    gameEvent.id = key_id
	$ExtraEvents.objects[[@map_id,key_id]] = StoredEvent.new(@map_id,event,:BERRYPLANT)
	 $ExtraEvents.objects[[@map_id,key_id]].eventdata = gameEvent
	@events[key_id] = gameEvent
    berry_plant = $PokemonGlobal.eventvars[[@map_id, key_id]]
    if !berry_plant
       berry_plant = BerryPlantData.new(@events[key_id])
       berry_plant.jit=true
	   berry_plant.beside_water=any_acceptable_water_tiles_for_hoe(x,y)
       $PokemonGlobal.eventvars[[@map_id, key_id]] = berry_plant
    end
	    map = @map_id
		 viewport = Spriteset_Map.viewport
        sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
        $scene.spritesets[self.map_id].character_sprites.push(sprite)
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantGroundSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantMoistureSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantMulchSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantWeedSprite.new(@events[key_id], map, viewport))
  
  
    return @events[key_id]
  end

  def generatePokemon(x,y,pokemon)
    #return spawnPokeEvent(x,y,pokemon)
    mapId = $game_map.map_id
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
	
    key_id = "ALLY_#{pokemon.personalID}"#((@events.keys.max)|| -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    event.name = "PlayerPkmn"
	
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")

    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = 3
    event.pages[0].move_frequency = 4
    event.pages[0].move_type = 3
    event.pages[0].step_anime = true
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = false #Sets movement type.
    #event.pages[0].always_on_top = true if pokemon.types.include?(:FLYING)
    #event.pages[0].through = true if pokemon.types.include?(:FLYING)
    event.pages[0].trigger = 0 #Action Button    event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement"]
    #--- event commands of the event -------------------------------------
    #Compiler::push_script(event.pages[0].list,sprintf("self.pkmnmovement"))
    #Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
	
    gameEvent = Game_PokeEventA.new(pokemon, mapId, event)
    gameEvent.id = key_id
    gameEvent.type = pokemon
    gameEvent.moveto(x,y)
	#if $game_temp.preventspawns==false
    $ExtraEvents.special[[mapId,key_id]] = StoredEvent.new(mapId,event,pokemon)
	$ExtraEvents.special[[mapId,key_id]].eventdata = gameEvent
	@allied_mobs[key_id] = gameEvent
    pokemon.associatedevent=key_id
    #--- updating the sprites --------------------------------------------------------
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
	#end
	update!
	return key_id
  end


  def generateMining(x,y,object)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
	temp_key = (@temp_data.keys.length || -1) + 1
    key_id = "TEMP_#{temp_key.to_s}"
    event.id = key_id
    event.x = x
    event.y = y
    event.name = "#{object}.noshadow"
    image = getObjectImage2(object)
	fname = "#{image}.png"
    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = 0 #Sets movement speed.
    event.pages[0].move_frequency = 0 #Sets movement frequency.
    event.pages[0].move_type = 0 #Sets movement type.
    event.pages[0].direction_fix = true
    event.pages[0].walk_anime = false #Sets movement type.
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = false #Sets movement type.
    event.pages[0].trigger = 0 #Action Button
    #--- event commands of the event -------------------------------------
    Compiler::push_script(event.pages[0].list,("object = get_own_event"))
    Compiler::push_script(event.pages[0].list,("ov_mining2(object.type) if defined?(object.type)"))
    Compiler::push_script(event.pages[0].list,("object.removeThisEventfromMap"))
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
    gameEvent = Game_OVEvent.new(object, @map_id, event, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.type = object
	@temp_data[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	update!
  end


  def each_enemy
    @hostile_mobs.values.each_with_index { |value, index| yield value, index }
  end 

  def each_ally
    @allied_mobs.values.each_with_index { |value, index| yield value, index }
  end 
  def each_temp
    @temp_data.values.each_with_index { |value, index| yield value, index }
  end 

  def each_object
    @block_data.values.each_with_index { |value, index| yield value, index }
  end 
  
  def each_value
    @temp_data   ||= {}
    data = @hostile_mobs.values + @allied_mobs.values + @block_data.values + @temp_data.values
    data.each_with_index { |value, index| yield value, index }
  end 
  
  def each_value_in_map(map_id = $game_map.map_id)
    data = events_for_map(map_id)
    data.each_with_index { |value, index| yield value, index }
  end 
  def each_value_in_connected_map(map_id = $game_map.map_id)
    data = events_for_connected_map(map_id)
    data.each_with_index { |value, index| yield value, index }
  end 
  
  def events
    @temp_data   ||= {}
    return @hostile_mobs.values + @allied_mobs.values + @block_data.values + @temp_data.values
  end 
  
  def events_for_map(map_id=$game_map.map_id)
    events.select { |event| event.map_id == map_id }
  end 
  def events_for_connected_map(map_id=$game_map.map_id)
    events.select { |event| $map_factory.areConnected?(event.map_id,map_id) && $map_factory.hasMap?(event.map_id)}
  end 
  
  
  def refresh
    @hostile_mobs.each_value do |event|
      event.refresh if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
    @allied_mobs.each_value do |event|
      event.refresh if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
    @block_data.each_value do |event|
      event.refresh if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
    @temp_data.each_value do |event|
      event.refresh if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
   
  end 
  
  def update
    return if @last_update_frame == Graphics.frame_count
    @last_update_frame = Graphics.frame_count
    @hostile_mobs.each_value do |event|
	    #event.map_id = $game_map.map_id if event.map_id!=$game_map.map_id
        event.update if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
    @allied_mobs.each_value do |event|
	 # puts event.id if event.map_id==$game_map.map_id
	    #event.map_id = $game_map.map_id if event.map_id!=$game_map.map_id
        event.update if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
    @block_data.each_value do |event|
	    #event.map_id = $game_map.map_id if event.map_id!=$game_map.map_id
        event.update if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
    end
    @temp_data.delete_if do |_, event|
     if $map_factory.areConnected?(event.map_id,$game_map.map_id) && $map_factory.hasMap?(event.map_id)
       event.update
       false
     else
      true
     end
    end
  end 
  
  
  
  
end 
#$DynamicEvents ||= DynamicEventFactory.new
SaveData.register(:dynamic_events) do
  ensure_class :DynamicEventFactory 
  save_value { $DynamicEvents  }
  load_value { |value| $DynamicEvents = value }
  new_game_value {
    DynamicEventFactory.new
  }
  reset_on_new_game
end

class Game_Character
  def passable?(x, y, d, strict = false)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    return false unless self.map.valid?(new_x, new_y)
    return true if @through
    if strict
      return false unless self.map.passableStrict?(x, y, d, self)
      return false unless self.map.passableStrict?(new_x, new_y, 10 - d, self)
    else
      return false unless self.map.passable?(x, y, d, self)
      return false unless self.map.passable?(new_x, new_y, 10 - d, self)
    end
    self.map.events.each_value do |event|
      next if self == event || !event.at_coordinate?(new_x, new_y) || event.through
	   return true if self == $game_player && event.name[/PlayerPkmn/]
      return false if self != $game_player || event.character_name != ""
    end
    $DynamicEvents.each_value_in_map do |event|
      next if self == event || !event.at_coordinate?(new_x, new_y) || event.through
	   return true if self == $game_player && event.name[/PlayerPkmn/]
      return false if self != $game_player || event.character_name != ""
    end
    if $game_player.x == new_x && $game_player.y == new_y &&
       !$game_player.through && @character_name != ""# && !
      return false
    end
    return true
  end
end
class EventHash
  def initialize(hash={})
    @hash = hash
  end

  def [](key)
    if key.is_a?(Integer)
      value = @hash[key]
	elsif key.is_a?(String) && key.start_with?("MOB_") && $DynamicEvents.hostile_mobs[key]
      value = $DynamicEvents.hostile_mobs[key]
	elsif key.is_a?(String) && key.start_with?("ALLY_") && $DynamicEvents.allied_mobs[key]
      value = $DynamicEvents.allied_mobs[key]
	elsif key.is_a?(String) && key.start_with?("BLOCK_") && $DynamicEvents.block_data[key]
      value = $DynamicEvents.block_data[key]
	end 
    return value
  end

  def []=(key, value)
    if key.is_a?(Integer)
      @hash[key] = value
	elsif @event_id.is_a?(String) && @event_id.start_with?("MOB_") 
      $DynamicEvents.hostile_mobs[key] = value
	elsif @event_id.is_a?(String) && @event_id.start_with?("ALLY_") 
      $DynamicEvents.allied_mobs[key] = value
	elsif @event_id.is_a?(String) && @event_id.start_with?("BLOCK_")
      $DynamicEvents.block_data[key] = value
	end 
  end
  
  def each(&block)
    @hash.each(&block)
  end
  def each_value(&block)
    @hash.each_value(&block)
  end
  def each_key(&block)
    @hash.each_key(&block)
  end
  
  def has_key?(key)
    @hash.has_key?(key)
  end 
  def keys
    @hash.keys
  end
  def values
    @hash.values
  end
  
  def length
    @hash.length
  end 
  
end
class Game_Map
  def passable?(x, y, d, self_event = nil)
    return false if !valid?(x, y)
    bit = (1 << ((d / 2) - 1)) & 0x0f
    @events.each_value do |event|
      next if event.tile_id <= 0
      next if event == self_event
      next if !event.at_coordinate?(x, y)
      next if event.through
      next if GameData::TerrainTag.try_get(@terrain_tags[event.tile_id]).ignore_passability
      passage = @passages[event.tile_id]
      return false if passage & bit != 0
      return false if passage & 0x0f == 0x0f
      return true if @priorities[event.tile_id] == 0
    end

	$DynamicEvents.each_value_in_map do |event|
      next if event.tile_id <= 0
      next if event == self_event
      next if !event.at_coordinate?(x, y)
      next if event.through
      next if GameData::TerrainTag.try_get(@terrain_tags[event.tile_id]).ignore_passability
      passage = @passages[event.tile_id]
      return false if passage & bit != 0
      return false if passage & 0x0f == 0x0f
      return true if @priorities[event.tile_id] == 0
	end 
	
    return playerPassable?(x, y, d, self_event) if self_event == $game_player
    # All other events
    newx = x
    newy = y
    case d
    when 1
      newx -= 1
      newy += 1
    when 2
      newy += 1
    when 3
      newx += 1
      newy += 1
    when 4
      newx -= 1
    when 6
      newx += 1
    when 7
      newx -= 1
      newy -= 1
    when 8
      newy -= 1
    when 9
      newx += 1
      newy -= 1
    end
    return false if !valid?(newx, newy)
    [2, 1, 0].each do |i|
      tile_id = data[x, y, i]
      terrain = GameData::TerrainTag.try_get(@terrain_tags[tile_id])
      # If already on water, only allow movement to another water tile
      if self_event && terrain.can_surf_freely
        [2, 1, 0].each do |j|
          facing_tile_id = data[newx, newy, j]
          next if facing_tile_id == 0
          return false if facing_tile_id.nil?
          facing_terrain = GameData::TerrainTag.try_get(@terrain_tags[facing_tile_id])
          if facing_terrain.id != :None && !facing_terrain.ignore_passability
            return facing_terrain.can_surf_freely
          end
        end
        return false
      # Can't walk onto ice
      elsif terrain.ice
        return false
      elsif self_event && self_event.x == x && self_event.y == y
        # Can't walk onto ledges
        [2, 1, 0].each do |j|
          facing_tile_id = data[newx, newy, j]
          next if facing_tile_id == 0
          return false if facing_tile_id.nil?
          facing_terrain = GameData::TerrainTag.try_get(@terrain_tags[facing_tile_id])
          return false if facing_terrain.ledge
          break if facing_terrain.id != :None && !facing_terrain.ignore_passability
        end
      end
      next if terrain&.ignore_passability
      next if tile_id == 0
      # Regular passability checks
      passage = @passages[tile_id]
      return false if passage & bit != 0 || passage & 0x0f == 0x0f
      return true if @priorities[tile_id] == 0
    end
    return true
  end
 
  
  def playerPassable?(x, y, d, self_event = nil)
    bit = (1 << ((d / 2) - 1)) & 0x0f
    [2, 1, 0].each do |i|
      tile_id = data[x, y, i]
      next if tile_id == 0
      terrain = GameData::TerrainTag.try_get(@terrain_tags[tile_id])
      passage = @passages[tile_id]
      if terrain
        # Ignore bridge tiles if not on a bridge
        next if terrain.bridge && $PokemonGlobal.bridge == 0
        # Make water tiles passable if player is surfing
        return true if $PokemonGlobal.surfing && terrain.can_surf && !terrain.waterfall
        # Prevent cycling in really tall grass/on ice
        return false if $PokemonGlobal.bicycle && terrain.must_walk
        # Depend on passability of bridge tile if on bridge
        if terrain.bridge && $PokemonGlobal.bridge > 0
          return (passage & bit == 0 && passage & 0x0f != 0x0f)
        end
      end
      next if terrain&.ignore_passability
      # Regular passability checks
      return false if passage & bit != 0 || passage & 0x0f == 0x0f
      return true if @priorities[tile_id] == 0
    end
    return true
  end

  # Returns whether the position x,y is fully passable (there is no blocking
  # event there, and the tile is fully passable in all directions)
  def passableStrict?(x, y, d, self_event = nil)
    return false if !valid?(x, y)
    events.each_value do |event|
      next if event == self_event || event.tile_id < 0 || event.through
      next if !event.at_coordinate?(x, y)
      next if GameData::TerrainTag.try_get(@terrain_tags[event.tile_id]).ignore_passability
      return false if @passages[event.tile_id] & 0x0f != 0
      return true if @priorities[event.tile_id] == 0
    end
    $DynamicEvents.each_value_in_map do |event|
      next if event == self_event || event.tile_id < 0 || event.through
      next if !event.at_coordinate?(x, y)
      next if GameData::TerrainTag.try_get(@terrain_tags[event.tile_id]).ignore_passability
      return false if @passages[event.tile_id] & 0x0f != 0
      return true if @priorities[event.tile_id] == 0
    end
    [2, 1, 0].each do |i|
      tile_id = data[x, y, i]
      next if tile_id == 0
      next if GameData::TerrainTag.try_get(@terrain_tags[tile_id]).ignore_passability
      return false if @passages[tile_id] & 0x0f != 0
      return true if @priorities[tile_id] == 0
    end
    return true
  end
  

end


class Game_TempEvent < Game_Event
  attr_accessor :event
  attr_accessor :id
  attr_accessor :counter
  def initialize(map_id, event, data, map=nil)
    super(map_id, event, map)
	@event = event
    @id  = event.id
    @map_id  = map_id
    @data  = data
	@counter = my_sight_line
  end
  def sight_line
    @counter
  end 

def my_sight_line
     counter_match = @event.name.match(/surrounding\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match

  return number.to_i if number
  return 3 
end
  def removeThisEventfromMap
	 if $DynamicEvents.temp_data.has_key?(@id) && $DynamicEvents.temp_data[@id]==self
	    pbRemoveParticleEffectfromEvent(self)
		pbRemoveLightEffectfromThisEvent(self)
        $DynamicEvents.temp_data.delete(@id)
	    $DynamicEvents.update!
	 end 
  end 

 end
