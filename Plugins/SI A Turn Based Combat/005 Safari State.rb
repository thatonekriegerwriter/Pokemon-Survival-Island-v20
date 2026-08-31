
class SafariState
  attr_accessor :ballcount
  attr_accessor :captures
  attr_accessor :decision
  attr_accessor :steps

  def initialize
    @start      = nil
    @ballcount  = 0
    @captures   = 0
    @inProgress = false
    @steps      = 0
    @decision   = 0
  end

  def pbReceptionMap
    return @inProgress ? @start[0] : 0
  end

  def inProgress?
    return @inProgress
  end


  def pbStart(ballcount)
    @start      = [$game_map.map_id, $game_player.x, $game_player.y, $game_player.direction]
    @ballcount  = $bag.amtwithFlag?
    @inProgress = true
    @steps      = Settings::SAFARI_STEPS
  end

  def pbEnd
    @start      = nil
    @ballcount  = 0
    @captures   = 0
    @inProgress = false
    @steps      = 0
    @decision   = 0
    $game_map.need_refresh = true
  end
end






def pbLegendaryStarter3?(starter)
  return true if
    starter=="ARTICUNO" ||
    starter=="ZAPDOS" ||
    starter=="MOLTRES" ||
    starter=="MEWTWO" ||
    starter=="MEW" ||
    starter=="RAIKOU" ||
    starter=="ENTEI" ||
    starter=="SUICUNE" ||
    starter=="LUGIA" ||
    starter=="HOOH" ||
    starter=="CELEBI" ||
    starter=="REGIROCK" ||
    starter=="REGICE" ||
    starter=="REGISTEEL" ||
    starter=="LATIAS" ||
    starter=="LATIOS" ||
    starter=="KYOGRE" ||
    starter=="GROUDON" ||
    starter=="RAYQUAZA" ||
    starter=="JIRACHI" ||
    starter=="DEOXYS" ||
    starter=="UXIE" ||
    starter=="MESPRIT" ||
    starter=="AZELF" ||
    starter=="DIALGA" ||
    starter=="PALKIA" ||
    starter=="HEATRAN" ||
    starter=="REGIGIGAS" ||
    starter=="GIRATINA" ||
    starter=="CRESSELIA" ||
    starter=="MANAPHY" ||
    starter=="DARKRAI" ||
    starter=="SHAYMIN" ||
    starter=="ARCEUS" ||
    starter=="VICTINI" ||
    starter=="COBALION" ||
    starter=="TERRAKION" ||
    starter=="VIRIZION" ||
    starter=="TORNADUS" ||
    starter=="THUNDURUS" ||
    starter=="RESHIRAM" ||
    starter=="ZEKROM" ||
    starter=="LANDORUS" ||
    starter=="KYUREM" ||
    starter=="KELDEO" ||
    starter=="MELOETTA" ||
    starter=="GENESECT"||
    starter=="XERNEAS"||
    starter=="YVELTAL"||
    starter=="ZYGARDE"||
    starter=="TYPENULL"||
    starter=="SILVALLY"||
    starter=="TAPUBULU"||
    starter=="TAPUFINI"||
    starter=="TAPULELE"||
    starter=="TAPUKOKO"||
    starter=="COSMOG"||
    starter=="COSMOEM"||
    starter=="SOLGALEO"||
    starter=="LUNALA"||
    starter=="NECROZMA"||
    starter=="NIHILEGO"||
    starter=="ZACIAN"||
    starter=="ZAMAZENTA"||
    starter=="ETERNATUS"||
    starter=="KUBFU"||
    starter=="URSHIFU"||
    starter=="REGIELEKI"||
    starter=="REGIDRAGO"||
    starter=="GLASTRIER"||
    starter=="SPECTRIER"||
    starter=="CALYREX"
  return false
end

	
	def pbCanAttackPlayer2?(caller)
	  return false if GameData::MapMetadata.try_get($game_map.map_id)&.random_dungeon
	  return false if pbLegendaryStarter3?(caller.name.upcase)
      return false if caller.fainted?
      rate=15
      return false if rate==0
      rate*=2 if caller.shadowPokemon?
      rate*=3 if caller.hp>(caller.totalhp/4) && caller.hp<=(caller.totalhp/2)
      rate*=5 if caller.hp<=(caller.totalhp/4)
      rate*=1.5 if $player.playerstamina < 50 && $player.playerstamina > 25
      rate*=2 if $player.playerstamina < 25
      rate*=1.5 if $player.playerhealth < 50 && $player.playerhealth > 25
      rate*=2 if $player.playerhealth < 25
	#  puts "rate: #{rate}"
	  chance = rand(100)
	#  puts "chance: #{chance}"
	#  puts "chance<rate: #{chance<rate}"
      return chance>=rate.to_i
    end
    
	def pbAttackPlayer2(caller)
      rate=10
      return if rate==0 # should never trigger anyways but you never know.
	  return if GameData::MapMetadata.try_get($game_map.map_id)&.random_dungeon
      pbDisplay(_INTL("{1} lunged at {2} for an attack!", caller.name,pbPlayer.name))
      rate=rate.to_f # don't want to lose decimal points
      intimidate=false
      rate*=1.2 if intimidate

      rate*=4.0 if $player.playerstamina < 50 && $player.playerstamina > 25
      rate*=5.0 if $player.playerstamina < 25
      rate*2.0 if caller.speed > $player.shoespeed*2
      rate=rate.round # rounding it off.
  

  if rand<rate
	  if caller.shadowPokemon?
        injury = rand(50)+1
        pbDisplay(_INTL("The incoming attack hits {2} for {1} Damage!", injury, pbPlayer.name))
	  damagePlayer(injury)
      else
        injury = rand(40)+1
        pbDisplay(_INTL("The incoming attack hits {2} for {1} Damage!", injury, pbPlayer.name))
	  damagePlayer(injury)
	  end
  else
     pbDisplay(_INTL("Thankfully, it missed!!"))
  end
    end



#===============================================================================
#
#===============================================================================
EventHandlers.add(:on_enter_map, :end_safari_game,
  proc { |_old_map_id|
  }
)

EventHandlers.add(:on_player_step_taken_can_transfer, :safari_game_counter,
  proc { |handled|
  }
)

#===============================================================================
#
#===============================================================================
EventHandlers.add(:on_calling_wild_battle, :safari_battle,
  proc { |species, level, handled|
    # handled is an array: [nil]. If [true] or [false], the battle has already
    # been overridden (the boolean is its outcome), so don't do anything that
    # would override it again
    next if !handled[0].nil?
    next if !pbInSafari?
	
  encounter_type = $PokemonEncounters.encounter_type_on_tile(pos[0],pos[1])
  return if !encounter_type
  return if !$PokemonEncounters.encounter_triggered_on_tile?(encounter_type, repel_active, true)
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  pkmn = pbGenerateWildPokemon(encounter[0],encounter[1])
    handled[0] = pbSafariBattle(nil,nil,pkmn)
  }
)
#===============================================================================
#
#===============================================================================


def pbInSafari?
  return true if $player.able_pokemon_count == 0
  return true if $game_temp.in_safari==true
  return false
end

def pbSafariState
  $PokemonGlobal.safariState = SafariState.new if !$PokemonGlobal.safariState
  return $PokemonGlobal.safariState
end

=begin



    ##### Main damage calculation #####
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=1 && target.pbOwnedByPlayer? && type == :DRAGON #BOSS 1
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=1 && target.pbOwnedByPlayer? && type == :GROUND #BOSS 1
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[255]>=2 && target.pbOwnedByPlayer? && type == :FAIRY	#BOSS 2
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[255]>=2 && target.pbOwnedByPlayer? && type == :FIRE	#BOSS 2
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=3 && target.pbOwnedByPlayer? && type == :ICE	#BOSS 3
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=3 && target.pbOwnedByPlayer? && type == :STEEL	#BOSS 3
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=4 && target.pbOwnedByPlayer? && type == :WATER	#BOSS 4
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=4 && target.pbOwnedByPlayer? && type == :DARK	#BOSS 4
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=5 && target.pbOwnedByPlayer? && type == :PSYCHIC	#BOSS 5
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=5&& target.pbOwnedByPlayer? && type == :NORMAL	#BOSS 5		
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=6 && target.pbOwnedByPlayer? && type == :FLYING	#BOSS 6
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=6 && target.pbOwnedByPlayer? && type == :FIGHTING	#BOSS 6
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=7 && target.pbOwnedByPlayer? && type == :GRASS	#BOSS 7
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=7 && target.pbOwnedByPlayer? && type == :ELECTRIC	#BOSS 7
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=8 && target.pbOwnedByPlayer? && type == :CRYSTAL	#BOSS 8
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=8 && target.pbOwnedByPlayer? && type == :BUG	#BOSS 8
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=9 && target.pbOwnedByPlayer? && type == :ROCK	#BOSS 9
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=9 && target.pbOwnedByPlayer? && type == :POISON	#BOSS 9
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=10&& target.pbOwnedByPlayer? && type == :WIND	#BOSS 10	
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=10 && target.pbOwnedByPlayer? && type == :GHOST	#BOSS 10	
    
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((2.0 * user.level / 5) + 2).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
    # "AI-specific calculations below"
    # Increased critical hit rates
    if skill >= PBTrainerAI.mediumSkill
      c = 0
      # Ability effects that alter critical hit rate
      if c >= 0 && user.abilityActive?
        c = Battle::AbilityEffects.triggerCriticalCalcFromUser(user.ability, user, target, c)
      end
      if skill >= PBTrainerAI.bestSkill && c >= 0 && !moldBreaker && target.abilityActive?
        c = Battle::AbilityEffects.triggerCriticalCalcFromTarget(target.ability, user, target, c)
      end



=end




MenuHandlers.add(:debug_menu, :killme, {
  "name"        => _INTL("Kill me!"),
  "parent"      => :player_menu,
  "description" => _INTL("Kill the Player."),
  "effect"      => proc {
    $player.playerhealth = 0.0
  }
})
