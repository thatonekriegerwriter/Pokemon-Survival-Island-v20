module MusicLoops
  # Music looping: if a BGM file is listed here, the respective start and end
  # time will be used to loop the BGM after playing until the end once
  BGM = {
    #"035-Dungeon02" => [4.000110, 95.73355] # start, end (in seconds)
  }
end

class PokemonSystem
  attr_accessor :wildbattleMusic
  attr_accessor :trainerbattleMusic
  attr_accessor :leaderbattleMusic
  attr_accessor :bossbattleMusic
  attr_accessor :pokemoncenterMusic
  attr_accessor :bikeMusic
  attr_accessor :surfMusic
  attr_accessor :wildvictoryMusic
  attr_accessor :trainervictoryMusic
  attr_accessor :leadervictoryMusic
  attr_accessor :lowHPDing
  attr_accessor :lowHPMusic


alias _SI_System_init initialize
def initialize
 _SI_System_init
  @wildbattleMusic     = 1
  @trainerbattleMusic     = 1
  @leaderbattleMusic     = 1
  @bossbattleMusic     = 1
  @pokemoncenterMusic     = 1
  @bikeMusic     = 1
  @surfMusic     = 1
  @wildvictoryMusic     = 1
  @trainervictoryMusic     = 1
  @leadervictoryMusic     = 1
  @lowHPDing     = 1
  @lowHPMusic     = 0


end
end


#[_INTL("Default"), _INTL("Map BGM"), _INTL("Classic SI"), _INTL("Kanto"), _INTL("Johto"), _INTL("Hoenn"), _INTL("Sinnoh"), _INTL("Unova"), _INTL("Stadium"),_INTL("Colosseum")]
def pbGetWildBGM
case $PokemonSystem.wildbattleMusic
when 0
  return GameData::Metadata.get.wild_battle_BGM
when 1
  return $game_map.bgm.name
when 2
  return "Original SI Battle"
when 3
  return false
when 4
  return false
when 5
  return false
when 6
  return false
when 7
 return false
 when 8
 return false
 when 8
 return "Normal Battle"
else
 return GameData::Metadata.get.wild_battle_BGM
end

end

def pbGetTrainerBGM
case $PokemonSystem.trainerbattleMusic
when 0
 return GameData::Metadata.get.trainer_battle_BGM
when 1
 return GameData::Metadata.get.trainer_battle_BGM
when 2
 return GameData::Metadata.get.trainer_battle_BGM
when 3
 return GameData::Metadata.get.trainer_battle_BGM
when 4
 return GameData::Metadata.get.trainer_battle_BGM
when 5
 return GameData::Metadata.get.trainer_battle_BGM
when 6
 return GameData::Metadata.get.trainer_battle_BGM
when 7
 return GameData::Metadata.get.trainer_battle_BGM
else
 return GameData::Metadata.get.trainer_battle_BGM
end

end

def pbGetGymLeaderBGM
case $PokemonSystem.leaderbattleMusic
when 0
 return false
when 1
 return false
when 2
 return false
when 3
 return false
when 4
 return false
when 5
 return false
when 6
 return false

else
 return false
end

end


def pbGetBossBattleBGM
#[_INTL("Default"), _INTL("Map Theme"), _INTL("Wild Arms"), _INTL("Chrono Trigger"), _INTL("Stadium"),_INTL("Colosseum")]
case $PokemonSystem.bossbattleMusic
when 0
 return "002-Battle02x"
when 1
 return $game_map.bgm.name
when 2
 return false
when 3
 return false
when 4
 return false
when 5
 return false
when 6
 return false
else
 return false
end

end

def pbGetPokemonCenterBGM
case $PokemonSystem.bikeMusic
when 0
 return false
when 1
 return false
when 2
 return false
when 3
 return false
when 4
 return false
when 5
 return false
when 6
 return false

else
 return GameData::Metadata.get.bicycle_BGM
end

end

def pbGetBikeBGM
case $PokemonSystem.bikeMusic
when 0
 return GameData::Metadata.get.bicycle_BGM
when 1
 return false
when 2
 return false
when 3
 return false
when 4
 return false
when 5
 return false
when 6
 return false

else
 return GameData::Metadata.get.bicycle_BGM
end

end



#[_INTL("Default"),_INTL("Map Theme"),_INTL("Kanto"), _INTL("Johto"), _INTL("Hoenn"), _INTL("Sinnoh"), _INTL("Unova")]
def pbGetSurfBGM
case $PokemonSystem.surfMusic
when 0
 return GameData::Metadata.get.surf_BGM
when 1
 return $game_map.bgm.name
when 2
 return false
when 3
 return false
when 4
 return false
when 5
 return false
when 6
 return false

else
 return GameData::Metadata.get.surf_BGM
end

end


def pbGetBeepGM
case $PokemonSystem.surfMusic
when 0
 return false
when 1
 return "Low HP Beep"
when 2
 return "Low HP Battle"
when 3
 return false

else
 return false
end

end



def pbSurfacing
  return if !$PokemonGlobal.diving
  return false if $game_player.pbFacingEvent
  surface_map_id = nil
  GameData::MapMetadata.each do |map_data|
    next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
    surface_map_id = map_data.id
    break
  end
  return if !surface_map_id
  move = :DIVE
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_DIVE, false) || (!$DEBUG && !movefinder)
    pbMessage(_INTL("Light is filtering down from above. A Pokémon may be able to surface here."))
    return false
  end
  if pbConfirmMessage(_INTL("Light is filtering down from above. Would you like to use Dive?"))
    speciesname = (movefinder) ? movefinder.name : $player.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    pbFadeOutIn {
      $game_temp.player_new_map_id    = surface_map_id
      $game_temp.player_new_x         = $game_player.x
      $game_temp.player_new_y         = $game_player.y
      $game_temp.player_new_direction = $game_player.direction
      $PokemonGlobal.surfing = true
      $PokemonGlobal.diving  = false
      pbUpdateVehicle
      $scene.transfer_player(false)
      surfbgm = pbGetSurfBGM
      (surfbgm) ? pbBGMPlay(surfbgm) : $game_map.autoplayAsCue
      $game_map.refresh
    }
    return true
  end
  return false
end

def pbAutoplayOnTransition
  surfbgm = pbGetSurfBGM
  if $PokemonGlobal.surfing && surfbgm
    pbBGMPlay(surfbgm)
  else
    $game_map.autoplayAsCue
  end
end


def pbAutoplayOnSave
  surfbgm = pbGetSurfBGM
  if $PokemonGlobal.surfing && surfbgm
    pbBGMPlay(surfbgm)
  else
    $game_map.autoplay
  end
end


def pbSurf
  return false if $game_player.pbFacingEvent
  return false if !$game_player.can_ride_vehicle_with_follower?
  move = :SURF
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_SURF, false) || (!$DEBUG && !movefinder) || (!$bag.has?(:RAFT) && !movefinder) 
    return false
  end
  if pbConfirmMessage(_INTL("The water is a deep blue color... Would you like to use Surf on it?"))
    speciesname = (movefinder) ? movefinder.name : $player.name
    movename = (movefinder) ? move.name : "Raft"
    pbMessage(_INTL("{1} used {2}!", speciesname, movename))
    pbCancelVehicles
    pbHiddenMoveAnimation(movefinder)
    surfbgm = pbGetSurfBGM
    pbCueBGM(surfbgm, 0.5) if surfbgm
    pbStartSurfing
    return true
  end
  return false
end

HiddenMoveHandlers::UseMove.add(:SURF, proc { |move, pokemon|
  $game_temp.in_menu = false
  pbCancelVehicles
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!", pokemon.name, GameData::Move.get(move).name))
  end
  surfbgm = pbGetSurfBGM
  pbCueBGM(surfbgm, 0.5) if surfbgm
  pbStartSurfing
  next true
})


def pbMountBike
  return if $PokemonGlobal.bicycle
  $PokemonGlobal.bicycle = true
  $stats.cycle_count += 1
  pbUpdateVehicle
  bike_bgm = pbGetBikeBGM
  pbCueBGM(bike_bgm, 0.5) if bike_bgm
  pbPokeRadarCancel
end



#===============================================================================
# Load various wild battle music
#===============================================================================
def pbGetWildBattleBGM(_wildParty)   # wildParty is an array of Pokémon objects
  if $PokemonGlobal.nextBattleBGM
    return $PokemonGlobal.nextBattleBGM.clone
  end
  ret = nil
  $game_temp.bossfight- false if $game_temp.bossfight.nil?
  if  $game_temp.bossfight==false
  if !ret
    # Check map metadata
    music = pbGetWildBGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check map metadata
    music = $game_map.metadata&.wild_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.wild_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  else
  if !ret
    # Check map metadata
    music = pbGetBossBattleBGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check map metadata
    music = pbGetWildBGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check map metadata
    music = $game_map.metadata&.wild_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.wild_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  end
  ret = pbStringToAudioFile("Battle wild") if !ret
  return ret
end

def pbGetWildVictoryBGM
  if $PokemonGlobal.nextBattleVictoryBGM
    return $PokemonGlobal.nextBattleVictoryBGM.clone
  end
  ret = nil
  # Check map metadata
  music = $game_map.metadata&.wild_victory_BGM
  ret = pbStringToAudioFile(music) if music && music != ""
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.wild_victory_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  ret = pbStringToAudioFile("Battle victory") if !ret
  ret.name = "../../Audio/BGM/" + ret.name
  return ret
end

def pbGetWildCaptureME
  if $PokemonGlobal.nextBattleCaptureME
    return $PokemonGlobal.nextBattleCaptureME.clone
  end
  ret = nil
  if !ret
    # Check map metadata
    music = $game_map.metadata&.wild_capture_ME
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.wild_capture_ME
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  ret = pbStringToAudioFile("Battle capture success") if !ret
  ret.name = "../../Audio/ME/" + ret.name
  return ret
end

#===============================================================================
# Load/play various trainer battle music
#===============================================================================
def pbPlayTrainerIntroBGM(trainer_type)
  trainer_type_data = GameData::TrainerType.get(trainer_type)
  return if nil_or_empty?(trainer_type_data.intro_BGM)
  bgm = pbStringToAudioFile(trainer_type_data.intro_BGM)
  if !$game_temp.memorized_bgm
    $game_temp.memorized_bgm = $game_system.getPlayingBGM
    $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
  end
  pbBGMPlay(bgm)
end

def pbGetTrainerBattleBGM(trainer)   # can be a Player, NPCTrainer or an array of them
  if $PokemonGlobal.nextBattleBGM
    return $PokemonGlobal.nextBattleBGM.clone
  end
  ret = nil
  music = nil
  trainerarray = (trainer.is_a?(Array)) ? trainer : [trainer]
  trainerarray.each do |t|
    trainer_type_data = GameData::TrainerType.get(t.trainer_type)
    music = trainer_type_data.battle_BGM if trainer_type_data.battle_BGM
  end
  ret = pbStringToAudioFile(music) if music && music != ""
  if !ret
    # Check map metadata
    music = $game_map.metadata&.trainer_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.trainer_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  ret = pbStringToAudioFile("Battle trainer") if !ret
  return ret
end

def pbGetTrainerBattleBGMFromType(trainertype)
  if $PokemonGlobal.nextBattleBGM
    return $PokemonGlobal.nextBattleBGM.clone
  end
  trainer_type_data = GameData::TrainerType.get(trainertype)
  ret = trainer_type_data.battle_BGM if trainer_type_data.battle_BGM
  if !ret
    # Check map metadata
    music = $game_map.metadata&.trainer_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.trainer_battle_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  ret = pbStringToAudioFile("Battle trainer") if !ret
  return ret
end

def pbGetTrainerVictoryBGM(trainer)   # can be a Player, NPCTrainer or an array of them
  if $PokemonGlobal.nextBattleVictoryBGM
    return $PokemonGlobal.nextBattleVictoryBGM.clone
  end
  music = nil
  trainerarray = (trainer.is_a?(Array)) ? trainer : [trainer]
  trainerarray.each do |t|
    trainer_type_data = GameData::TrainerType.get(t.trainer_type)
    music = trainer_type_data.victory_BGM if trainer_type_data.victory_BGM
  end
  ret = nil
  ret = pbStringToAudioFile(music) if music && music != ""
  if !ret
    # Check map metadata
    music = $game_map.metadata&.trainer_victory_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  if !ret
    # Check global metadata
    music = GameData::Metadata.get.trainer_victory_BGM
    ret = pbStringToAudioFile(music) if music && music != ""
  end
  ret = pbStringToAudioFile("Battle victory") if !ret
  ret.name = "../../Audio/BGM/" + ret.name
  return ret
end