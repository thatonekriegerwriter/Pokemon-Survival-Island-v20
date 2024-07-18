EventHandlers.add(:on_frame_update, :spawnonstep,
  proc {
    next if !$player
    repel_active = ($PokemonGlobal.repel > 0)
	if pbShouldSpawn
    pbSpawnOnStepTaken(repel_active)  # OVERWORLD ENCOUNTERS
	end
  }
)

def pbShouldSpawn
    chance = rand(750)
  if (chance <= VisibleEncounterSettings::INSTANT_WILD_BATTLE_PROPABILITY) && $game_temp.preventspawns==false
    return true
  else
    return false
  end
end