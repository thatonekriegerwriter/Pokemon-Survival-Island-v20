# Poison party Pokémon



EventHandlers.add(:on_end_battle, :evolve_and_black_out,
  proc { |decision, canLose|
    # Check for evolutions
    pbEvolutionCheck if Settings::CHECK_EVOLUTION_AFTER_ALL_BATTLES ||
                        (decision != 2 && decision != 5)   # not a loss or a draw
    $game_temp.party_levels_before_battle = nil
    $game_temp.party_critical_hits_dealt = nil
    $game_temp.party_direct_damage_taken = nil
    # Check for blacking out or gaining Pickup/Huney Gather items
    case decision
    when 1, 4   # Win, capture
      $player.pokemon_party.each do |pkmn|
        pbPickup(pkmn)
        pbHoneyGather(pkmn)
      end
    when 2, 5   # Lose, draw
      if !canLose
        $game_system.bgm_unpause
        $game_system.bgs_unpause
      end
    end
  }
)