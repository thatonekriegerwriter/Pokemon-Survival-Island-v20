#===============================================================================
# Automatic Level Scaling Event Handlers
# By Benitex
#===============================================================================

# Activates script when a wild pokemon is created
EventHandlers.add(:on_wild_pokemon_created, :automatic_level_scaling,
  proc { |pokemon|
    id = $game_variables[LevelScalingSettings::WILD_VARIABLE]
    if id != 0
      AutomaticLevelScaling.setDifficulty(id)
      AutomaticLevelScaling.setNewLevel(pokemon)
    end
  }
)

# Activates script when a trainer pokemon is created
EventHandlers.add(:on_trainer_load, :automatic_level_scaling,
  proc { |trainer|
    id = $game_variables[LevelScalingSettings::TRAINER_VARIABLE]
    if trainer && id != 0
      AutomaticLevelScaling.setDifficulty(id)
      avarage_level = 0
      trainer.party.each { |pokemon| avarage_level += pokemon.level }
      avarage_level /= trainer.party.length

      for pokemon in trainer.party do
        AutomaticLevelScaling.setNewLevel(pokemon, pokemon.level - avarage_level)
      end
    end
  }
)

# Updates partner's pokemon levels after battle
EventHandlers.add(:on_end_battle, :update_partner_levels,
  proc { |_decision, _canLose|
    if $PokemonGlobal.partner != nil
      avarage_level = 0
      $PokemonGlobal.partner[3].each { |pokemon| avarage_level += pokemon.level }
      avarage_level /= $PokemonGlobal.partner[3].length

      for pokemon in $PokemonGlobal.partner[3] do
        AutomaticLevelScaling.setNewLevel(pokemon, pokemon.level - avarage_level)
      end
    end
  }
)


EventHandlers.add(:on_player_step_taken_can_transfer, :effefefefefehhttj,
  proc {
  	   if wildBattle?
	      AutomaticLevelScaling.setSettings(update_moves:true, automatic_evolutions:false, proportional_scaling:false, only_scale_if_higher:false, only_scale_if_lower:true)
	   else
	      AutomaticLevelScaling.setSettings(update_moves:true, automatic_evolutions:true, proportional_scaling:true, only_scale_if_higher:false, only_scale_if_lower:true, first_evolution_level:20, second_evolution_level:40)
	   end
  })
  
  
