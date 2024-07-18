class Game_Map

  def generatePokemon(x,y,pokemon)
    mapId = $game_map.map_id
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    if $ExtraEvents.objects.nil?
	$ExtraEvents.objects = {}
	end 
	amtofkeysinroom = 0
    key_id = ((@events.keys.max)|| -1) + 1
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
    event.pages[0].move_speed = $game_player.move_speed
    event.pages[0].move_frequency = 4
    event.pages[0].move_type = 3
    event.pages[0].step_anime = true
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = false #Sets movement type.
    event.pages[0].trigger = 0 #Action Button    event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement"]
    #--- event commands of the event -------------------------------------
    #Compiler::push_script(event.pages[0].list,sprintf("self.pkmnmovement"))
    #Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
	
    gameEvent = Game_ObjectEvent.new(pokemon, mapId, event, self)
    gameEvent.id = key_id
    gameEvent.type = pokemon
	if $game_temp.preventspawns==false
    $ExtraEvents.special[key_id] = [mapId,event,pokemon,x,y]
	@events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	end
  end
end



EventHandlers.add(:on_player_interact, :pkmn_event,
  proc {
    
    facingEvent = $game_player.pbFacingEvent
    if facingEvent && facingEvent.name[/PlayerPkmn/i]
	  pkmninteraction(facingEvent)
	 
	
	end
  }
)


def get_events_in_range(eventa,eventb,distance)

	 sx = eventa.x + (eventa.width / 2.0) - (eventb.x + (eventb.width / 2.0))
    sy = eventa.y - (eventa.height / 2.0) - (eventb.y - (eventb.height / 2.0))
    return true if ( sx.abs <= distance || sy.abs  <= distance) 
	return false
end


def besidethis?(eventa,eventb)
return true if eventa.at_coordinate?(eventb.x+1,eventb.y)
return true if eventa.at_coordinate?(eventb.x-1,eventb.y)
return true if eventa.at_coordinate?(eventb.x,eventb.y+1)
return true if eventa.at_coordinate?(eventb.x,eventb.y-1)
return false
end


class Game_Event < Game_Character

  def pbSurroundingEvent(ignoreInterpreter = false)
    return nil if $game_temp.preventspawns==false
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter 
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
    $game_map.events.each_value do |event|
      next if besidethis?(self, event)==false
      next if event.jumping? || event.over_trigger?
      return event
    end
    return nil
  end

  def pbEventWithin(distance,ignoreInterpreter = false)
    distance = distance.to_i if distance.is_a? String
	theevents = []
    return nil if $game_temp.preventspawns==false
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter 
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
    $game_map.events.each_value do |event|
	  next if event.name != "PlayerPkmn"
      next if get_events_in_range(self, event,distance)==false
	  theevents << event
    end
	if get_events_in_range(self, $game_player,distance)==true
	  theevents << $game_player
	  theevents << $game_player
	end
    uniqueevent = theevents[rand(theevents.length)]
    return uniqueevent
  end


end


def pkmninteraction(event)
$game_temp.interactingwithpokemon=true
pbMoveRoute2(event, [PBMoveRoute::TurnTowardPlayer])
pbFollowerInteraction(true,event.type)
$game_temp.interactingwithpokemon=false
end

def pbPlacePokemon(x,y,pokemon)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if pbObjectIsPossible(x,y)
  if !$map_factory
    event = $game_map.generatePokemon(x,y,pokemon)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    event = spawnMap.generatePokemon(x,y,pokemon)
  end

  return true
  else
  pokemon.inworld=false
  end 
  pokemon.inworld=false
 # Play the pokemon cry of encounter
end

def toggle_in_world(pokemon)
  if pokemon.inworld==false
  pokemon.inworld=true
  else
  pokemon.inworld=false
  end
end

def get_overworld_pokemon_length
  potato = []
 $player.party.each do |b|
   if b.inworld==true
     potato << b
   end
 end

 return potato.length
end



def pbClosestHiddenItemPokemon(pokemon)
  result = []
  playerX = pokemon.x
  playerY = pokemon.y
  $game_map.events.each_value do |event|
    next if !event.name[/hiddenitem/i]
    next if (playerX - event.x).abs >= 8
    next if (playerY - event.y).abs >= 6
    next if $game_self_switches[[$game_map.map_id, event.id, "A"]]
    result.push(event)
  end
  return nil if result.length == 0
  ret = nil
  retmin = 0
  result.each do |event|
    dist = (playerX - event.x).abs + (playerY - event.y).abs
    next if ret && retmin <= dist
    ret = event
    retmin = dist
  end
  return ret
end



def get_an_inworld_pokemon
  potato = []
 $player.party.each do |b|
   if b.inworld==true
     potato << b
   end
 end
 if potato.length > 0
 return potato[rand(potato.length)]
 else
 return nil
end
end



def toggle_in_combat
  if $game_temp.in_combat==false
  $game_temp.in_combat=true
  $game_temp.preventspawns=true
  else
  $game_temp.in_combat=false
  $game_temp.preventspawns=false
  end
end


def getOverworldPokemonfromPokemon(pokemon)
if $game_temp.preventspawns==true
$game_map.events.each do |id,event|
  if event.name == "PlayerPkmn"
    if event.type == pokemon
	  return event.id
	end
  end
end
end
return nil
end

def getOverworldPokemonfromPokemonMap(pokemon,map)
if $game_temp.preventspawns==true
$map_factory.getMap(map).events.each do |id,event|
  if event.name == "PlayerPkmn"
    if event.type == pokemon
	  return event.id
	end
  end
end
end
return nil
end


def getOverworldPokemonfromIndex(id)
return $game_map.events[id].type
end

def hasOtherPokemon?

if $game_temp.preventspawns==true
$game_map.events.each do |id,event|
  if event.name[/vanishingEncounter/]
  end
end
end
return false
end



def getRandomOverworldOtherPokemon(thispkmn)
events=[]
if $game_temp.preventspawns==true
$game_map.events.each do |id,event|
if event.name[/vanishingEncounter/]
  events << event
end
end
end
return events[rand(events.length)]
  end

	
def pbReturnPokemon(event,message=false)
key_id = event
$game_temp.interactingwithpokemon=true
if message==true
pbMessage(_INTL("#{$game_map.events[key_id].type.name}, come back!"))
end
pbSEPlay("Battle recall")

$game_map.events[key_id].pokemon.set_in_world(false,$game_map.events[key_id])
deletefromSISData(key_id)
$game_map.events[key_id].removeThisEventfromMap
$game_temp.interactingwithpokemon=false
$game_temp.pokemon_calling=false
end

module FollowingPkmn

  def self.talk2(poke)
    return false if !$game_temp || $game_temp.in_battle || $game_temp.in_menu
    facing = pbFacingTile
    if !$game_map.passable?(facing[1], facing[2], $game_player.direction, $game_player)
      $game_player.straighten
      EventHandlers.trigger(:on_player_interact)
      return false
    end
    first_pkmn = poke
    GameData::Species.play_cry(first_pkmn)
    random_val = rand(6)
    if $PokemonGlobal&.follower_hold_item
      EventHandlers.trigger_2(:following_pkmn_item, first_pkmn, random_val)
    else
      EventHandlers.trigger_2(:following_pkmn_talk, first_pkmn, random_val)
    end
    return true
  end

end



class Game_Character


  def move_type_custom
    return if jumping? || moving?
	  
	@move_route_index = 0 if @move_route.list[0].code ==52879 && @move_route_index > 0
    while @move_route_index < @move_route.list.size
      command = @move_route.list[@move_route_index]
      if command.code == 0
        if @move_route.repeat
          @move_route_index = 0
        else
          if @move_route_forcing
            @move_route_forcing = false
            @move_route       = @original_move_route
            @move_route_index = @original_move_route_index
            @original_move_route = nil
          end
          @stop_count = 0
        end
        return
      end
	  if command.code == 52879
		eval(command.parameters[0])
        @move_route_index = 0
	  end
      if command.code <= 14
        case command.code
        when 1  then move_down
        when 2  then move_left
        when 3  then move_right
        when 4  then move_up
        when 5  then move_lower_left
        when 6  then move_lower_right
        when 7  then move_upper_left
        when 8  then move_upper_right
        when 9  then move_random
        when 10 then move_toward_player
        when 11 then move_away_from_player
        when 12 then move_forward
        when 13 then move_backward
        when 14 then jump(command.parameters[0], command.parameters[1])
        end
        @move_route_index += 1 if @move_route.skippable || moving? || jumping?
        return
      end
      if command.code == 15   # Wait
        @wait_count = (command.parameters[0] * Graphics.frame_rate / 20) - 1
        @move_route_index += 1
        return
      end
      if command.code >= 16 && command.code <= 26
        case command.code
        when 16 then turn_down
        when 17 then turn_left
        when 18 then turn_right
        when 19 then turn_up
        when 20 then turn_right_90
        when 21 then turn_left_90
        when 22 then turn_180
        when 23 then turn_right_or_left_90
        when 24 then turn_random
        when 25 then turn_toward_player
        when 26 then turn_away_from_player
        end
        @move_route_index += 1
        return
      end
      if command.code >= 27
        case command.code
        when 27
          $game_switches[command.parameters[0]] = true
          self.map.need_refresh = true
        when 28
          $game_switches[command.parameters[0]] = false
          self.map.need_refresh = true
        when 29 then self.move_speed = command.parameters[0]
        when 30 then self.move_frequency = command.parameters[0]
        when 31 then @walk_anime = true
        when 32 then @walk_anime = false
        when 33 then @step_anime = true
        when 34 then @step_anime = false
        when 35 then @direction_fix = true
        when 36 then @direction_fix = false
        when 37 then @through = true
        when 38 then @through = false
        when 39
          old_always_on_top = @always_on_top
          @always_on_top = true
          calculate_bush_depth if @always_on_top != old_always_on_top
        when 40
          old_always_on_top = @always_on_top
          @always_on_top = false
          calculate_bush_depth if @always_on_top != old_always_on_top
        when 41
          old_tile_id = @tile_id
          @tile_id = 0
          @character_name = command.parameters[0]
          @character_hue = command.parameters[1]
          if @original_direction != command.parameters[2]
            @direction = command.parameters[2]
            @original_direction = @direction
            @prelock_direction = 0
          end
          if @original_pattern != command.parameters[3]
            @pattern = command.parameters[3]
            @original_pattern = @pattern
          end
          calculate_bush_depth if @tile_id != old_tile_id
        when 42 then @opacity = command.parameters[0]
        when 43 then @blend_type = command.parameters[0]
        when 44 then pbSEPlay(command.parameters[0])
        when 45 then eval(command.parameters[0])
        end
        @move_route_index += 1
      end
    end
  end







end