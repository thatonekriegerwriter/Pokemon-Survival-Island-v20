module VisibleEncounterTimeGate
  COOLDOWN_FRAMES = 120
  @progress = 0
  
  def self.add_progress(type,amount=1)
    case type
    when :frame
      @progress += 1 * amount
    when :turn
      @progress += 0.5 * amount
    when :step
      @progress += 30 * amount
    end
	#puts "Spawn Progress: #{@progress}>=#{COOLDOWN_FRAMES}"
  end
  
  
  def self.allow_spawn?(cooldown = COOLDOWN_FRAMES)
    @progress >= cooldown
  end

  def self.consume!
    @progress = 0
  end
  
  
end
class PokemonEncounters
  def any_encounters_on_map?
    terrain_tag = $game_map.terrain_tag($game_player.x, $game_player.y)
    return false if terrain_tag.ice
    return true if has_water_encounters?
    return true if has_cave_encounters?   # i.e. this map is a cave
    return true if has_land_encounters?
    return false
  end



end 
EventHandlers.remove(:on_player_change_direction, :trigger_encounter)

EventHandlers.add(:on_player_change_direction, :trigger_encounter,
  proc {
    next if $game_temp.in_menu
    next if $game_temp.no_natural_spawning
	next if !$PokemonEncounters.any_encounters_on_map?
    repel_active = ($PokemonGlobal.repel > 0)
    next if repel_active
	amt = is_grass? ? 2 : 1
	VisibleEncounterTimeGate.add_progress(:turn, amt)
    pbSpawnOnStepTaken(repel_active) if !$game_temp.in_menu 
	  
  }
)

EventHandlers.add(:on_frame_update, :automatic_spawning,
  proc {
    next if !$player
	 next if $game_temp.in_menu
	next if !$PokemonEncounters.any_encounters_on_map?
    repel_active = ($PokemonGlobal.repel > 0)
    next if repel_active
    next unless Graphics.frame_count % VisibleEncounterSettings::AUTO_SPAWN_SPEED == 0
	VisibleEncounterTimeGate.add_progress(:frame)
    pbSpawnOnStepTaken(repel_active) if !pbBattleOrSpawnOnStepTaken(repel_active) 
  }
)
EventHandlers.add(:on_player_step_taken, :progress_timegate,
  proc {
    next if !$player
	next if $game_temp.in_menu
	next if !$PokemonEncounters.any_encounters_on_map?
    repel_active = ($PokemonGlobal.repel > 0)
    next if repel_active
	amt = is_grass? ? 2 : 1
	VisibleEncounterTimeGate.add_progress(:step, amt)
  }
)

def is_grass?(x=$game_player.x,y=$game_player.y)
 terrain_tag = $game_map.terrain_tag(x, y)
 return true if [:Grass,:TallGrass,:UnderwaterGrass,:SootGrass].include?(terrain_tag.id)
 return false
end 

def pbOnStepTaken(eventTriggered)
  if $game_player.move_route_forcing || pbMapInterpreterRunning?
    EventHandlers.trigger(:on_step_taken, $game_player)
    return
  end
  $PokemonGlobal.stepcount = 0 if !$PokemonGlobal.stepcount
  $PokemonGlobal.stepcount += 1
  $PokemonGlobal.stepcount &= 0x7FFFFFFF
  repel_active = ($PokemonGlobal.repel > 0)
  EventHandlers.trigger(:on_player_step_taken)
  handled = [nil]
  EventHandlers.trigger(:on_player_step_taken_can_transfer, handled)
  return if handled[0]
  if !eventTriggered && !$game_temp.in_menu && !$game_temp.no_natural_spawning
    #if pbBattleOrSpawnOnStepTaken(repel_active)
    #  pbBattleOnStepTaken(repel_active) # STANDARD WILD BATTLE
    #end
      pbSpawnOnStepTaken(repel_active)  # OVERWORLD ENCOUNTERS
  end
  $game_temp.encounter_triggered = false   # This info isn't needed here
  
end

def pbBattleOrSpawnOnStepTaken(repel_active)
  if (rand(255) < 3) || pbPokeRadarOnShakingGrass
    return true
  else
    return false
  end
end

def pbSpawnOnStepTaken(repel_active)
  return false if pbCountPokeEventInMap >= (PBDayNight.isNight? ? VisibleEncounterSettings::MAX_SPAWN : VisibleEncounterSettings::MAX_SPAWN_DAY)
  return if $game_temp.in_menu
  return if $game_system.menu_disabled
  return false if !VisibleEncounterTimeGate.allow_spawn?
  
  
  #First we choose a tile near the player
  pos = pbChooseTileOnStepTaken
  return if !pos
  encounter_type = $PokemonEncounters.encounter_type_on_tile(pos[0],pos[1])
  return if !encounter_type
  return if !$PokemonEncounters.encounter_triggered_on_tile?(encounter_type, repel_active, true)
  
  
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  $PokemonGlobal.creatingSpawningPokemon = true
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  
  
  if $PokemonEncounters.allow_encounter?(encounter, repel_active)
    pokemon = pbGenerateWildPokemon(encounter[0],encounter[1])
    # trigger event on spawning of pokemon
    EventHandlers.trigger(:on_wild_pokemon_created_for_spawning, pokemon)
	puts "Performing Spawn of Lv#{pokemon.level} #{pokemon.name} at #{pos[0]},#{pos[1]}"
    pbPlaceEncounter(pos[0],pos[1],pokemon)
	VisibleEncounterTimeGate.consume!
    # $PokemonEncounters.reset_step_count # added such that your encounter rate resets after spawning of an overworld pokemon 
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
  end
  
  
  $game_temp.force_single_battle = false
  EventHandlers.trigger(:on_wild_pokemon_created_for_spawning_end)
  $PokemonGlobal.creatingSpawningPokemon = false
  #EncounterModifier.triggerEncounterEndSpawn
  #EncounterModifier.triggerEncounterEnd # not use anymore in PEv20 ?
end

def pbChooseTileOnStepTaken
    px = $game_player.x
    py = $game_player.y
    min = VisibleEncounterSettings::MIN_SPAWN_RANGE
    max = VisibleEncounterSettings::SPAWN_RANGE
    attempts = VisibleEncounterSettings::NO_OF_CHOSEN_TILES 
	
	
    tried = {}
  attempts.times do
	i = rand(min..max-1) ** 1.25
    i = i.floor
    r = rand((i+1) * 8)

    next if tried[[i, r]]
    tried[[i, r]] = true

    if r <= (i+1)*2
      x = px - i - 1 + r
      y = py - i - 1
    elsif r <= (i+1)*6 - 2
      x = [px + i + 1, px - i - 1][r % 2]
      y = py - i + ((r - 1 - (i+1)*2) / 2).floor
    else
      x = px - i + r - (i+1)*6
      y = py + i + 1
    end
    if pbTileIsPossible(x, y)
     return [x, y] 
	end
  end
    return
end



def pbTileIsPossible(x,y)
  if !$game_map.valid?(x,y) #check if the tile is on the map
    return false
  else
    tile_terrain_tag = $game_map.terrain_tag(x,y)
  end
  for event in $game_map.events.values
    if event.x==x && event.y==y
      return false
    end
  end
  return false if !tile_terrain_tag
  #check if it's a valid grass, water or cave etc. tile
  return false if tile_terrain_tag.ice
  return false if tile_terrain_tag.ledge
  return false if tile_terrain_tag.waterfall
  return false if tile_terrain_tag.waterfall_crest
  return false if tile_terrain_tag.id == :Rock
  if VisibleEncounterSettings::RESTRICT_ENCOUNTERS_TO_PLAYER_MOVEMENT
    return false if !tile_terrain_tag.can_surf && 
              $PokemonGlobal && $PokemonGlobal.surfing
    return false if tile_terrain_tag.can_surf && 
              !($PokemonGlobal && $PokemonGlobal.surfing)
  end
  if tile_terrain_tag.can_surf
    for i in [2, 1, 0]
      tile_id = $game_map.data[x, y, i]
      return false if !tile_id || tile_id < 0
      next if tile_id == 0
      terrain = GameData::TerrainTag.try_get($game_map.terrain_tags[tile_id])
      passage = $game_map.passages[tile_id]
      priority = $game_map.priorities[tile_id]
      break if terrain.can_surf
      # Ignore if tile above water
      return false if passage!=0
      return false if priority==0 && !terrain.ignore_passability
    end
  else
    return false if !$game_map.passableStrict?(x, y, 0)
  end
  
  return false if !$PokemonEncounters.encounter_possible_here_on_tile?(x,y)
  
  return true
end

def pbPlaceEncounter(x,y,pokemon,dir=false)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  ret = $DynamicEvents.spawnPokeEvent(x,y,pokemon,dir)
  pbPlayCryOnOverworld(pokemon.species, pokemon.form) if $game_switches[556]==false && rand(100)<26# Play the pokemon cry of encounter
   return ret
end



def pbOldPlaceEncounter(x,y,pokemon,dir=false)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if !$map_factory
    $game_map.spawnPokeEvent(x,y,pokemon,dir)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    ret = spawnMap.spawnPokeEvent(x,y,pokemon,dir)
  end
  pbPlayCryOnOverworld(pokemon.species, pokemon.form) if $game_switches[556]==false && rand(100)<26# Play the pokemon cry of encounter
   return ret
end

def pbPlacePokemonDungeon(index)

  if $game_temp.preventspawns == false

	if FollowingPkmn.get_pokemon == $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	  FollowingPkmn.toggle_off
	end
  start_coord=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y]
  landing_coord=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y]
  case $game_player.direction
  when 2; landing_coord[1]
  when 4; landing_coord[0]
  when 6; landing_coord[0]
  when 8; landing_coord[1]
  end
  
  $scene.spriteset.addUserSprite(OWBallThrowSprite.new([start_coord,landing_coord],index,$game_map,Spriteset_Map.viewport))
  $game_temp.pokemon_calling=false
  end

  end

alias original_pbPlaceEncounter pbPlaceEncounter
def pbPlaceEncounter(x,y,pokemon,dir=false)
  #Appear Animation
  encType = GameData::EncounterType.try_get($game_temp.encounter_type)
  if !encType
    # Show default animation
    $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_RUSTLE_ANIMATION_ID,x,y,true,1)
  else
    default_anim = true
    for anim in VisibleEncounterSettings::ENV_SPAWN_ANIMATIONS
      anim_type = anim[0]
      anim_id = anim[1]
      if encType.type  == anim_type && $data_animations[anim_id]
        # Show animation
        $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
        default_anim = false
      end
    end
    if default_anim == true
      # Show default grass rustling animation
      $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_RUSTLE_ANIMATION_ID,x,y,true,1)
    end
  end
  #Appear Encounter Animations
  for anim in VisibleEncounterSettings::Enc_Spawn_Animations
    anim_method = anim[0]
    anim_value = anim[1]
    anim_id = anim[2]
    if pokemon.method(anim_method).call == anim_value && $data_animations[anim_id]
      $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
    end
  end

  original_pbPlaceEncounter(x,y,pokemon,dir)
end




def pbShouldSpawn
    chance = rand(750)
  if (chance <= VisibleEncounterSettings::INSTANT_WILD_BATTLE_PROPABILITY) #&& $game_temp.preventspawns==false
    return true
  else
    return false
  end
end

class PokemonEncounters  
  def encounter_type_on_tile(x,y)
    time = pbGetTimeNow
    ret = nil
    if $game_map.terrain_tag(x,y).can_surf_freely
      ret = find_valid_encounter_type_for_time(:Water, time)
    else   # Land/Cave (can have both in the same map)
      if has_land_encounters? && $game_map.terrain_tag(x, y).land_wild_encounters
        ret = :BugContest if pbInBugContest? && has_encounter_type?(:BugContest)
        ret = find_valid_encounter_type_for_time(:Land, time) if !ret
      end
      if !ret && has_cave_encounters?
        ret = find_valid_encounter_type_for_time(:Cave, time)
      end
    end
    return ret
  end

  
  #===============================================================================
  # adding new method encounter_possible_here_on_tile? in class PokemonEncounters
  # in file 003_Overworld_WildEncounters.rb to check at arbitrary coordinates x
  # and y and not only at players position such as encounter_possible_here? does
  #===============================================================================
  def encounter_possible_here_on_tile?(x,y)
    tile_terrain_tag = $game_map.terrain_tag(x,y)
    if tile_terrain_tag.can_surf_freely
      if VisibleEncounterSettings::NO_SPAWN_ON_BORDER
        return false if !$game_map.terrain_tag(x+1,y).can_surf_freely
        return false if !$game_map.terrain_tag(x-1,y).can_surf_freely
        return false if !$game_map.terrain_tag(x,y+1).can_surf_freely
        return false if !$game_map.terrain_tag(x,y-1).can_surf_freely
      end
      return true
    end
    return true if tile_terrain_tag.can_surf_freely
    return false if tile_terrain_tag.ice
    return true if has_cave_encounters?   # i.e. this map is a cave
    return true if has_land_encounters? && tile_terrain_tag.land_wild_encounters
    return false
  end

  #===============================================================================
  # adding new Method encounter_triggered_on_tile? to Class PokemonEncounters
  # to returns whether a overworld wild encounter should happen, based on its encounter
  # chance. Called when taking a step. Add-ons may overwrite this method.
  #===============================================================================
  def encounter_triggered_on_tile?(enc_type, repel_active = false, triggered_by_step = true)
    return $PokemonEncounters.encounter_triggered?(enc_type, repel_active, true)
  end
  
  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
    
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
	
    return false if $game_system.encounter_disabled
    return false if !$player
    return false if $DEBUG && Input.press?(Input::CTRL)
    # Check if enc_type has a defined step chance/encounter table
    return false if !@step_chances[enc_type] || @step_chances[enc_type] == 0
    return false if !has_encounter_type?(enc_type)
	
	
    # Poké Radar encounters always happen, ignoring the minimum step period and
    # trigger probabilities
    return true if pbPokeRadarOnShakingGrass
	
	
    # Get base encounter chance and minimum steps grace period
    encounter_chance = @step_chances[enc_type].to_f
    min_steps_needed = (VisibleEncounterSettings::MAX_ENCOUNTER_REDUCED - (encounter_chance / 10)).clamp(0, 8).to_f
    # Apply modifiers to the encounter chance and the minimum steps amount
    
	
	
    stainfluance = $player.playerstamina/$player.playermaxstamina
    encounter_chance /= stainfluance
    min_steps_needed *= stainfluance
	
	
    if triggered_by_step
      encounter_chance += @chance_accumulator / 200
      encounter_chance *= 0.8 if $PokemonGlobal.bicycle
    end
	
	
	if $PokemonMap.blackFluteUsed
      encounter_chance /= 2 
      min_steps_needed *= 2
	end
	
	if $PokemonMap.whiteFluteUsed
      encounter_chance *= 1.5 
      min_steps_needed /= 2
	end
	
	if $player.is_it_this_class?(:TRIATHLETE)
      encounter_chance /= 3 
	end
	  
	  
	  
	  
	  
    first_pkmn = $player.first_pokemon
    if first_pkmn
      case first_pkmn.item_id
      when :CLEANSETAG
        encounter_chance *= 2.0 / 3
        min_steps_needed *= 4 / 3.0
      when :PUREINCENSE
        encounter_chance *= 2.0 / 3
        min_steps_needed *= 4 / 3.0
      else   # Ignore ability effects if an item effect applies
        case first_pkmn.ability_id
        when :STENCH, :WHITESMOKE, :QUICKFEET
          encounter_chance /= 2
          min_steps_needed *= 2
        when :INFILTRATOR
          if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SNOWCLOAK
          if GameData::Weather.get($game_screen.weather_type).category == :Hail
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SANDVEIL
          if GameData::Weather.get($game_screen.weather_type).category == :Sandstorm
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SWARM
          encounter_chance *= 1.5
          min_steps_needed /= 2
        when :ILLUMINATE, :ARENATRAP, :NOGUARD
          encounter_chance *= 2
          min_steps_needed /= 2
        end
      end
    end
    # Wild encounters are much less likely to happen for the first few steps
    # after a previous wild encounter
	
	
    if triggered_by_step && @step_count > min_steps_needed
	  if rand(100) <= encounter_chance * 5 / (@step_chances[enc_type] + (@chance_accumulator / 200))
       return true 
	  end
    end
    # Decide whether the wild encounter should actually happen
    return true if rand(50) < encounter_chance
    # If encounter didn't happen, make the next step more likely to produce one
    if triggered_by_step
      @chance_accumulator += @step_chances[enc_type]
      @chance_accumulator = 0 if repel_active
    end



    return false
  end



  #===============================================================================
  # adding new method have_double_wild_battle_on_tile? in class PokemonEncounters
  # Returns whether a wild encounter should be turned into a double wild encounter
  # similar to have_double_wild_battle but depends on tile.
  #===============================================================================
  def have_double_wild_battle_on_tile?(x, y, map_id)
    return false if $game_temp.force_single_battle
    return false if pbInSafari?
    return true if $PokemonGlobal.partner
    return false if $player.able_pokemon_count <= 1
    if $map_factory
      terrainTag = $map_factory.getTerrainTag(map_id,x,y)
    else
      terrainTag = $game_map.terrain_tag(x,y)
    end
    return true if terrainTag.double_wild_encounters && rand(100) < 30  
    return false
  end
end


def ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
  fname = GameData::Species.check_graphic_file("Graphics/Characters/", species, form, gender, shiny, shadow, "Followers")
  fname = "Graphics/Characters/Followers/000.png" if nil_or_empty?(fname)
  return fname
end

class Game_Temp
  attr_accessor :VOWERoamEncounter
  attr_accessor :VOWERoamerIndex
  attr_accessor :VOWENextBattleBGM
  attr_accessor :VOWEForceSingleBattle
  attr_accessor :VOWEEncounterType
end


def pbStoreTempForBattle()
  $game_temp.VOWERoamEncounter = $PokemonGlobal.roamEncounter
  $game_temp.VOWERoamerIndex = $game_temp.roamer_index_for_encounter
  $game_temp.VOWENextBattleBGM = $PokemonGlobal.nextBattleBGM 
  $game_temp.VOWEForceSingleBattle = $game_temp.force_single_battle
  $game_temp.VOWEEncounterType = $game_temp.encounter_type
end


def pbResetTempAfterBattle()
  $PokemonGlobal.roamEncounter = $game_temp.VOWERoamEncounter
  $game_temp.roamer_index_for_encounter = $game_temp.VOWERoamerIndex
  $PokemonGlobal.nextBattleBGM = $game_temp.VOWENextBattleBGM 
  $game_temp.force_single_battle = $game_temp.VOWEForceSingleBattle
  $game_temp.encounter_type = $game_temp.VOWEEncounterType
end


def pbCheckBattleAllowed()
  encType = GameData::EncounterType.try_get($game_temp.encounter_type)
  #the pokemon encounter battle won't happen if it is in the water and the player is not surfing
  return false if !$PokemonGlobal.surfing && encType.type == :water && VisibleEncounterSettings::BATTLE_WATER_FROM_SHORE == false
  return true
end


def pbSingleOrDoubleWildBattle(map_id,x,y,pokemon)
  if $game_temp.in_safari==true
    $PokemonGlobal.nextBattleBGM = "Normal Battle"
    pbSafariBattle(nil,nil,pokemon)
  else
  if $PokemonEncounters.have_double_wild_battle_on_tile?(x,y,map_id)
      encounter2 = $PokemonEncounters.choose_wild_pokemon($game_temp.encounter_type)
      EventHandlers.trigger(:on_wild_species_chosen, encounter2)
      setBattleRule("double")
      WildBattle.start(pokemon, encounter2, can_override: true)
  else
    WildBattle.start(pokemon, can_override: true)
  end
  end
  $game_temp.encounter_type = nil
  $game_temp.encounter_triggered = true
end

#===============================================================================
# adding new method pbPlayCryOnOverworld to load/play Pokémon cry files 
# SPECIAL THANKS TO "Ambient Pokémon Cries" - by Vendily
# actually it's not used, but that code helped to include the pkmn cries faster
#===============================================================================
def pbPlayCryOnOverworld(pokemon,form=0,volume=30,pitch=100) # default volume=90
  return if !pokemon || pitch <= 0
  form = 0 if form==nil
  if pokemon.is_a?(Pokemon)
    if !pokemon.egg?
      GameData::Species.play_cry_from_pokemon(pokemon,volume,pitch)
    end
  else
    GameData::Species.play_cry_from_species(pokemon,form,volume,pitch)
  end
end

#===============================================================================
# adding a new method attr_reader to the Class Spriteset_Map in Script
# Spriteset_Map to get access to the variable @character_sprites of a
# Spriteset_Map
#===============================================================================
class Spriteset_Map
  attr_reader :character_sprites
end

#===============================================================================
# adding a new method attr_reader to the Class Scene_Map in Script
# Scene_Map to get access to the Spriteset_Maps listed in the variable 
# @spritesets of a Scene_Map
#===============================================================================
class Scene_Map
  attr_reader :spritesets
end


          #########################################################
          #                                                       #
          #   2. PART: VANISH OVERWORLD ENCOUNTER AFTER BATTLE    #
          #                                                       #
          #########################################################

#-------------------------------------------------------------------
# adding new Method removeThisEventfromMap in Class Game_Map 
# to let an overworld pokemon disappear after battling
#-------------------------------------------------------------------
class Game_Map
  def removeThisEventfromMap(id)
    if @events.has_key?(id)
	   event = @events[id]
	    if event.is_a?(Game_PokeEvent)
        if event.pokemon.fainted?
	      pbSEPlay("faint")
	     end
	     pbOverworldCombat.removeEnemy(id)
	     $selection_arrows.clear_lock_on if $game_temp.lockontarget==event
	     $ExtraEvents.removethisEvent(:POKEMON,id,@map_id)
	      pbRemoveParticleEffectfromEvent(event)
		 elsif event.is_a?(Game_PokeEventA)
		  event.type.associatedevent=nil
		  if event.type.inworld && event.type.fainted?
		    sideDisplay(_INTL("{1} has fainted!",  event.type.name))
		    event.type.changeHappiness("faintbad",event.type)
		    event.type.changeLoyalty("faintbad",event.type)
		    pbSEPlay("faint")
		  end
		  pbOverworldCombat.removeAlly(id)
		  $selection_arrows.remove_sprite("Arrow#{id}#{event.type.name}")
		  $hud.removeaChargeBar(id)
		  event.type.inworld=false
		  pbDeselectThisPokemon(event.type)
		  pbRemoveParticleEffectfromEvent(event)
		  $ExtraEvents.removethisEvent(:SPECIAL,id,@map_id)
		 elsif event.is_a?(Game_OVEvent)
		$ExtraEvents.removethisEvent(:OBJECT,id,@map_id)
		 else
		 end
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[@map_id].character_sprites
          if sprite.character == @events[id]
            $scene.spritesets[@map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
      @events.delete(id)
    end
  end
end


class PokemonGlobalMetadata
  attr_accessor :creatingSpawningPokemon
  attr_accessor :battlingSpawnedPokemon

  alias original_initialize initialize
  def initialize
    @creatingSpawningPokemon = false
    @battlingSpawnedPokemon = false
    original_initialize
  end
end

def pbRoamingMethodAllowed(roamer_method)
  enc_type = $game_temp.encounter_type # $game_temp.encounter_type stores the encounter type of the chosen tile
  type = GameData::EncounterType.get(enc_type).type
  case roamer_method
  when 0   # Any step-triggered method (except Bug Contest)
    return [:land, :cave, :water].include?(type)
  when 1   # Walking (except Bug Contest)
    return [:land, :cave].include?(type)
  when 2   # Surfing
    return type == :water
  when 3   # Fishing
    return type == :fishing
  when 4   # Water-based
    return [:water, :fishing].include?(type)
  end
  return false
end

#-------------------------------------------------------------------------------
# adding a process to the EncounterModifier TriggerEncounterEnd For roaming
# encounters. We have to set roamed_already to true after one roamer spawned.
#-------------------------------------------------------------------------------  
EventHandlers.add(:on_wild_pokemon_created_for_spawning_end, :roamer_spawned, proc{
  if $game_temp.roamer_index_for_encounter != nil &&  $PokemonGlobal.roamEncounter != nil
    $PokemonGlobal.roamEncounter = nil
    $PokemonGlobal.roamedAlready = true
    $game_temp.roamer_index_for_encounter = nil
   end
})


EventHandlers.add(:on_wild_pokemon_created_for_spawning, :evolve_high_leveled_spawning_pokemon, proc { |pkmn| 
if rand(100) > 85
  loop do
    next if !pkmn || pkmn.egg?
    new_species = pkmn.check_evolution_on_level_up
    break if new_species.nil?
    # Evolve Pokémon if possible
    pkmn.species = new_species
    pkmn.calc_stats
    pkmn.ready_to_evolve = false
    # See and own evolved species
    moves_to_learn = []
    movelist = pkmn.getMoveList
    movelist.each do |i|
      next if i[0] != 0 && i[0] != pkmn.level   # 0 is "learn upon evolution"
      moves_to_learn.push(i[1])
    end
    # Learn moves upon evolution for evolved species
    moves_to_learn.each do |move|
      # Pokémon already knows the move
      next if pkmn.hasMove?(move)
      # Pokémon has space for the new move; just learn it
      if pkmn.numMoves < Pokemon::MAX_MOVES
        pkmn.learn_move(move)
        next
      end
      # Pokémon already knows the maximum number of moves; try to forget one to learn the new move
      forgetMove =  rand(Pokemon::MAX_MOVES) 
      pkmn.moves[forgetMove] = Pokemon::Move.new(move)   # Replaces current/total PP
    end
  end
end

})


class PokemonGlobalMetadata
  attr_accessor :blackFluteUsed
  attr_accessor :whiteFluteUsed
  attr_accessor :fluteTimer

  alias original_initialize23 initialize
  def initialize
    @blackFluteUsed = false
    @whiteFluteUsed = false
    @fluteTimer = pbGetTimeNow.to_i-3600
    original_initialize23
  end
  
  def blackFluteUsed
    @blackFluteUsed = false if @blackFluteUsed.nil?
	return @blackFluteUsed
  end
  
  def whiteFluteUsed
    @whiteFluteUsed = false if @whiteFluteUsed.nil?
	return @whiteFluteUsed
  end
  
  def fluteTimer
    @fluteTimer = pbGetTimeNow.to_i-3600 if @fluteTimer.nil?
	return @fluteTimer
  end
end


ItemHandlers::UseInField.add(:BLACKFLUTE, proc { |item|
  pbUseItemMessage(item)
  
    time_delta = pbGetTimeNow.to_i - @fluteTimer
  if time_delta < 3600
  pbMessage(_INTL("Wild Pokémon will be repelled."))
  $PokemonGlobal.blackFluteUsed = true
  $PokemonGlobal.whiteFluteUsed = false
  $PokemonGlobal.fluteTimer = pbGetTimeNow.to_i
  next true
  else
  pbMessage(_INTL("You've played a flute recently, it won't have an effect."))
  next false
  end
})

ItemHandlers::UseInField.add(:WHITEFLUTE, proc { |item|
  pbUseItemMessage(item)
    time_delta = pbGetTimeNow.to_i - @fluteTimer
  if time_delta < 3600
  pbMessage(_INTL("Wild Pokémon will be lured."))
  $PokemonGlobal.blackFluteUsed = false
  $PokemonGlobal.whiteFluteUsed = true
  $PokemonGlobal.fluteTimer = pbGetTimeNow.to_i
  next true
  else
  pbMessage(_INTL("You've played a flute recently, it won't have an effect."))
  next false
  end
})

