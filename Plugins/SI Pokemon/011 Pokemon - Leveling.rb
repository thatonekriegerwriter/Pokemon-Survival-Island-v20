class Pokemon 

  def gain_ev(defeated_pkmn, initial_item = nil)
    return if egg?
    ev_yield = defeated_pkmn.evYield.dup

    if !Battle::ItemEffects.triggerEVGainModifier(item, self, ev_yield)
      Battle::ItemEffects.triggerEVGainModifier(initial_item, self, ev_yield)
    end

    # Happiness bonus
    if happiness >= 200
      ev_yield.each_key { |stat| ev_yield[stat] += 1 }
    end

    if age <= 20
      ev_yield.each_key { |stat| ev_yield[stat] += 2 }
    elsif age <= 40
      ev_yield.each_key { |stat| ev_yield[stat] += 4 }
    elsif age <= 60
      ev_yield.each_key { |stat| ev_yield[stat] += 4 }
    elsif age <= 80
      ev_yield.each_key { |stat| ev_yield[stat] += 2 }
    else
      ev_yield.each_key { |stat| ev_yield[stat] += 1 }
    end

    # Pokérus
    if pokerusStage >= 1
      ev_yield.each_key { |stat| ev_yield[stat] *= 3 }
    end


    ev_total = 0
    GameData::Stat.each_main { |s| ev_total += ev[s.id] }

    if shadowPokemon? && saved_ev && level != 20
      saved_ev.each_value { |e| ev_total += e }

      GameData::Stat.each_main do |s|
        ev_gain = ev_yield[s.id].clamp(
          0,
          Pokemon::EV_STAT_LIMIT - ev[s.id] - saved_ev[s.id]
        )

        ev_gain *= 3
        ev_gain = ev_gain.clamp(0, Pokemon::EV_LIMIT - ev_total)

        saved_ev[s.id] += ev_gain
        ev_total += ev_gain
      end
    else
      GameData::Stat.each_main do |s|
        ev_gain = ev_yield[s.id].clamp(
          0,
          Pokemon::EV_STAT_LIMIT - ev[s.id]
        )

        ev_gain *= 1.5 if purifiedPokemon?
        ev_gain = ev_gain.clamp(0, Pokemon::EV_LIMIT - ev_total)

        ev[s.id] += ev_gain
        ev_total += ev_gain
      end
    end

    calc_stats
  end
  
  
def gain_exp_from_overworld(defeated_pkmn)
  participants = pbOverworldCombat.get_allied_pokemon
  return if participants.empty?

  num_partic = participants.count(&:able?)
  is_partic = participants.include?(self)

  exp_share = []
  unless $player.has_exp_all || $bag.has?(:EXPALL)
    $player.party.each_with_index do |pkmn, i|
      next unless participants.include?(pkmn)
      next unless pkmn.able?
      next unless pkmn.hasItem?(:EXPSHARE)
      exp_share << i
    end
  end

  exp_all = $player.has_exp_all || $bag.has?(:EXPALL)

  gain_exp(defeated_pkmn,is_partic,num_partic,exp_share,exp_all, nil, false, false, true)
end
  
  def gain_exp(defeated_pkmn, is_partic, num_partic, exp_share, exp_all, initial_item = nil, trainer_battle = false, internal_battle = false, show_messages = false, battle = nil)
    return if egg?

  growth = growth_rate
  return if exp >= growth.maximum_exp
  return if level == 20 && shadowPokemon?

  has_exp_share = exp_share.include?($player.party.index(self))

  level = defeated_pkmn.level
  base_exp = level * defeated_pkmn.base_exp
  exp = 0

  if exp_share.length > 0 && (is_partic || has_exp_share)
    if num_partic == 0
      exp = base_exp / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? exp_share.length : 1)
    elsif Settings::SPLIT_EXP_BETWEEN_GAINERS
      exp = base_exp / (2 * num_partic) if is_partic
      exp += base_exp / (2 * exp_share.length) if has_exp_share
    else
      exp = is_partic ? base_exp : base_exp / 2
    end
  elsif is_partic
    exp = base_exp / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? num_partic : 1)
  elsif exp_all
    exp = base_exp / 2
  end

  return if exp <= 0

  # Trainer battle modifier
  if Settings::MORE_EXP_FROM_TRAINER_POKEMON &&
     trainer_battle && !shadowPokemon?
    exp = (exp * 1.5).floor
  end

  # Scaled EXP
  if Settings::SCALED_EXP_FORMULA
    exp /= 5
    level_adjust = ((2 * level) + 10.0) / (self.level + level + 10.0)
    level_adjust = level_adjust**5
    level_adjust = Math.sqrt(level_adjust)
    exp *= level_adjust
    exp = exp.floor
    exp += 1 if is_partic || has_exp_share
  end

  # Outsider bonus
  is_outsider = (
    owner.id != $player.id ||
    (owner.language != 0 && owner.language != $player.language)
  )

  if is_outsider && !shadowPokemon?
    if owner.language != 0 && owner.language != $player.language
      exp = (exp * 1.7).floor
    else
      exp = (exp * 1.5).floor
    end
  end

  # EXP Charm
  exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)

  # Held item modifier
  modified_exp = Battle::ItemEffects.triggerExpGainModifier(item, self, exp)

  if modified_exp < 0
    modified_exp = Battle::ItemEffects.triggerExpGainModifier(
      initial_item, self, exp
    )
  end

  exp = modified_exp if modified_exp >= 0

  # High affection
  if internal_battle && happiness >= 240 && !mega?
    exp = exp * 6 / 5
  end

  # Shadow Pokémon
  exp /= 1.5 if shadowPokemon?

  # Overworld modifier
  if !internal_battle
    if $PokemonGlobal.fishing == true && $game_temp.in_safari == false
      exp /= 6
      exp /= 2 if exp > 1000
    else
      exp *= 1.5
    end
  end

  gain_exp_single(exp, internal_battle, is_outsider, show_messages, battle)
  end 


  def gain_exp_single(exp_amt, internal_battle = false, is_outsider = false, show_messages = false, battle = nil)
    return if egg?
    return if exp_amt <= 0

    growth = growth_rate
    old_exp = exp
    cur_level = level

    if level >= level_cap
    stored_gain = (exp_amt * 0.1).floor
    return if stored_gain <= 0

    self.stored_exp += stored_gain

    if show_messages
      if internal_battle && battle
        if is_outsider
          battle.pbDisplayPaused(
            _INTL("{1} got a boosted {2} Exp. Points!", name, stored_gain)
          )
        else
          battle.pbDisplayPaused(
            _INTL("{1} got {2} Exp. Points!", name, stored_gain)
          )
        end
      end
    end

    return [old_exp, exp, cur_level, cur_level, 0]
    end
    cap_exp = growth.minimum_exp_for_level(level_cap)
    exp_final = growth.add_exp(exp, exp_amt)
	exp_final = [exp_final, cap_exp].min
	
    exp_gained = exp_final - exp
    return if exp_gained <= 0
	
    if show_messages
	 if internal_battle && battle
      if is_outsider
        battle.pbDisplayPaused(_INTL("{1} got a boosted {2} Exp. Points!", name, exp_gained))
      else
        battle.pbDisplayPaused(_INTL("{1} got {2} Exp. Points!", name, exp_gained))
      end
	 else
	 
	 end 
    end

    new_level = growth.level_from_exp(exp_final)

    if new_level < cur_level
      debug_info = "Levels: #{cur_level}->#{new_level} | Exp: #{exp}->#{exp_final} | gain: #{exp_gained}"
      raise _INTL(
        "{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
        name,
        debug_info
      )
    end

    self.exp = exp_final
    $stats.total_exp_gained += exp_gained

    calc_stats
	apply_levels(show_messages, false, internal_battle, battle) unless battle 
	[old_exp, exp_final, cur_level, new_level, exp_gained]
  end

  def apply_levels(show_messages = false, statue = false, internal_battle = false, battle = nil)
  if level == 20 && shadowPokemon?
    if show_messages
      message = _INTL("{1} cannot go beyond this level because it is a Shadow Pokemon.", name)

      if internal_battle && battle
        battle.pbDisplayPaused(message)
      elsif statue
        pbMessage(message)
      else
        sideDisplay(message)
      end
    end
    return
  end

    exp_final = stored_exp + exp
    growth = growth_rate
    cur_level = level
    new_level = growth.level_from_exp(exp_final)
    learnedmoves = []
    new_level = [new_level, level_cap].min
    if cur_level >= level_cap
      return
    end
  if new_level <= cur_level
    if show_messages
      message = _INTL("{1} has not gained enough experience to level up.", name)

      if internal_battle && battle
        battle.pbDisplayPaused(message)
      elsif statue
        pbMessage(message)
      else
        sideDisplay(message)
      end
    end
    return false
  end
	
    loop do
      level_min_exp = growth.minimum_exp_for_level(cur_level)
      level_max_exp = growth.minimum_exp_for_level(cur_level + 1)
	  old_exp = exp
      temp_exp = [level_max_exp, exp_final].min

      self.exp = temp_exp
      self.stored_exp -= (temp_exp - old_exp)

      cur_level += 1

      if cur_level > new_level
        calc_stats
        break
      end

      old_total_hp = totalhp
      old_attack   = attack
      old_defense  = defense
      old_sp_atk   = spatk
      old_sp_def   = spdef
      old_speed    = speed

      if shadowPokemon?
        chance = case level
                when 12 then 5
                when 13 then 10
                when 14 then 15
                when 15 then 20
                when 16 then 25
                when 17 then 30
                when 18 then 35
                when 19 then 40
                when 20.. then 50
                else 0
                end

        self.nature = :HATEFUL if chance > 0 && rand(100) < chance
      end

      calc_stats

      moveList = getMoveList
      moveList.each do |m|
        learnedmoves << m[1] if m[0] == cur_level
      end

      if cur_level + 1 > level_cap
        calc_stats
        break
      end
    end

    if show_messages
      if internal_battle && battle
         battle.pbDisplayPaused(_INTL("{1} grew to Lv. {2}!", name, level))
      elsif statue
        pbMessage(_INTL("{1} grew to Lv. {2}!", name, level))
      else
        sideDisplay(_INTL("{1} grew to Lv. {2}!", name, level))
      end
    end
    if $player.party.include?(self) && (statue || internal_battle)
    learnedmoves.each do |move|
      pbLearnMove(self, move)
    end
    end 
    newspecies = check_evolution_on_level_up
    moves_to_learn = []
    if newspecies
      if $player.party.include?(self) && (statue || internal_battle)
        pbFadeOutInWithMusic(99999) {
          evo = PokemonEvolutionScene.new
          evo.pbStartScreen(self, newspecies)
          evo.pbEvolution
          evo.pbEndScreen
        }
      else
	   old_name = name
       moves_to_learn = evolve_to(newspecies)
	   if self.inworld && self.event && self.event.map_id == $game_map.map_id && !internal_battle && !statue 
        Pokemon.play_cry(newspecies, self.form)
        newspeciesname = GameData::Species.get(newspecies).name
        sideDisplay(_INTL("{1} evolved into {2}!", old_name, newspeciesname))
       end 
      end
    end

    self.stored_exp = 0 if self.stored_exp < 0
	if $player.party.include?(self) && (statue || internal_battle)
    moves_to_learn.each do |move|
      pbLearnMove(self, move, true)
    end
	end 
      changeHappiness("levelup", self)
      changeLoyalty("levelup", self)
    true
	
  end 




  def can_level_up?
    stored_exp > 0 && level < level_cap
  end
 

def evolve_to(newspecies)
  action_after_evolution(newspecies)

  was_fainted = fainted?
  self.species = newspecies
  self.hp = 0 if was_fainted
  calc_stats
  self.ready_to_evolve = false

  $player.pokedex.register(self)
  $player.pokedex.set_owned(newspecies)

  moves_to_learn = []
  movelist = getMoveList
  movelist.each do |i|
    next if i[0] != 0 && i[0] != level
    moves_to_learn.push(i[1])
  end

  $stats.evolution_count += 1
  if self.event 
   $scene.spriteset.addUserAnimation(7, self.event.x, self.event.y, true, 1) if self.event.map_id == $game_map.map_id 
   self.event.update_pokemon_sprite 
  end 
  return moves_to_learn
end

 
end 