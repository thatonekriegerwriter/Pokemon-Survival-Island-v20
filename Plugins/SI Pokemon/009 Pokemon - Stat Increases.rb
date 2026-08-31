class Pokemon
  attr_reader :raw_stat_bonus
  attr_reader :raw_shadow_bonus
  attr_reader :raw_purified_bonus


    alias _SI_Pokemon_Stat_Increase_init initialize
    def initialize(*args)
    _SI_Pokemon_Stat_Increase_init(*args)
      @raw_stat_bonus               = {}
      @raw_shadow_bonus               = {}
      @raw_purified_bonus               = {}
      @raw_temp_bonus               = {}
      GameData::Stat.each_main do |s|
        @raw_stat_bonus[s.id]       = 0
        @raw_shadow_bonus[s.id]       = 0
        @raw_purified_bonus[s.id]       = 0
        @raw_temp_bonus[s.id]       = 0
      end
	end

  def exp_fraction
    lvl = self.level
    return 0.0 if lvl >= GameData::GrowthRate.max_level
    g_rate = growth_rate
    start_exp = g_rate.minimum_exp_for_level(lvl)
    end_exp   = g_rate.minimum_exp_for_level(lvl + 1)
	@stored_exp = 0 if @stored_exp.nil?
    return ((@exp + @stored_exp) - start_exp).to_f / (end_exp - start_exp)
  end

   	
   def raw_stat_bonus
   if @raw_stat_bonus.nil?
   @raw_stat_bonus = {}
    GameData::Stat.each_main do |s|
      @raw_stat_bonus[s.id]       = 0
    end
   end
   return @raw_stat_bonus
   end

   
   def raw_shadow_bonus
   if @raw_shadow_bonus.nil?
   @raw_shadow_bonus = {}
    GameData::Stat.each_main do |s|
      @raw_shadow_bonus[s.id]       = 0
    end
   end
   return @raw_shadow_bonus
   end

   
   def raw_purified_bonus
   if @raw_purified_bonus.nil?
   @raw_purified_bonus = {}
    GameData::Stat.each_main do |s|
      @raw_purified_bonus[s.id]       = 0
    end
   end
   return @raw_purified_bonus
   end

   
   def raw_temp_bonus
   if @raw_temp_bonus.nil?
   @raw_temp_bonus = {}
    GameData::Stat.each_main do |s|
      @raw_temp_bonus[s.id]       = [0,0]
    end
   end
   return @raw_temp_bonus
   end




  # @return [Hash<Integer>] this Pokémon's base stats, a hash with six key/value pairs
  def baseStats
    this_base_stats = species_data.base_stats
    ret = {}
    GameData::Stat.each_main { |s| ret[s.id] = this_base_stats[s.id] }
    return ret
  end

  # Returns this Pokémon's effective IVs, taking into account Hyper Training.
  # Only used for calculating stats.
  # @return [Hash<Integer>] hash containing this Pokémon's effective IVs
  def calcIV
    this_ivs = self.iv
    ret = {}
    GameData::Stat.each_main do |s|
      ret[s.id] = (@ivMaxed[s.id]) ? IV_STAT_LIMIT : this_ivs[s.id]
    end
    return ret
  end


  # @return [Integer] the maximum HP of this Pokémon
  def calcHP(base, level, iv, ev, modifiers, shadow, pure, temp)
    return 1 + modifiers + shadow + pure + temp if base == 1   # For Shedinja
    return (((((base * 2) + iv + (ev / 4)) * level / 100).floor + level + 10) * dynamax_boost).ceil + modifiers + shadow + pure + temp
  end

  # @return [Integer] the specified stat of this Pokémon (not used for total HP)
  def calcStat(base, level, iv, ev, nat, modifiers, shadow, pure, temp)
    return (((((base * 2) + iv + (ev / 2)) * level / 100).floor + 5) * nat / 100).floor + modifiers + shadow + pure + temp
  end



  def calc_stats
    if should_force_revert?
      @reverted = true if dynamax?
      @dynamax = false
      @gmax_factor = false
    end
    base_stats = self.baseStats
    this_level = self.level
    this_IV    = self.calcIV
    # Format stat multipliers due to nature
    nature_mod = {}
    GameData::Stat.each_main { |s| nature_mod[s.id] = 100 }
    this_nature = self.nature_for_stats
    if this_nature
      this_nature.stat_changes.each { |change| nature_mod[change[0]] += change[1] }
    end
    # Calculate stats
    stats = {}
    GameData::Stat.each_main do |s|
      if s.id == :HP
        stats[s.id] = calcHP(base_stats[s.id], this_level, this_IV[s.id], @ev[s.id], self.raw_stat_bonus[s.id], self.raw_shadow_bonus[s.id], self.raw_purified_bonus[s.id], self.raw_temp_bonus[s.id][0])
      else
        stats[s.id] = calcStat(base_stats[s.id], this_level, this_IV[s.id], @ev[s.id], nature_mod[s.id], self.raw_stat_bonus[s.id], self.raw_shadow_bonus[s.id], self.raw_purified_bonus[s.id], self.raw_temp_bonus[s.id][0])
      end
    end
    hp_difference = stats[:HP] - @totalhp
    @totalhp = stats[:HP]
    self.hp = [@hp + hp_difference, 1].max if @hp > 0 || hp_difference > 0
    @attack  = stats[:ATTACK]
    @defense = stats[:DEFENSE]
    @spatk   = stats[:SPECIAL_ATTACK]
    @spdef   = stats[:SPECIAL_DEFENSE]
    @speed   = stats[:SPEED]
    # Resets remaining Dynamax attributes for ineligible Pokemon.
    if should_force_revert?
      @dynamax_lvl = 0
      @reverted = false
      @dynamax_able = false
    end
  end




end 


def pbIncreaseLevelCap(pkmn,stat,amt)
 pkmn.level_cap_bonus+=amt
end

def pbDecreaseLevelCap(pkmn,stat,amt)
 pkmn.level_cap_bonus-=amt
end

def pbIncreaseStat(pkmn,stat,amt)
 pkmn.raw_stat_bonus[stat]+=amt
end

def pbDecreaseStat(pkmn,stat,amt)
 pkmn.raw_stat_bonus[stat]-=amt
end

def pbDecreaseShadStat(pkmn,stat,amt)
 pkmn.raw_shadow_bonus[stat]-=amt
end

def pbDecreaseShadStat(pkmn,stat,amt)
 pkmn.raw_shadow_bonus[stat]-=amt
end

def pbDecreasePureStat(pkmn,stat,amt)
 pkmn.raw_purified_bonus[stat]-=amt
end

def pbDecreasePureStat(pkmn,stat,amt)
 pkmn.raw_purified_bonus[stat]-=amt
end

def pbDecreaseTempStat(pkmn,stat,amt)
 pkmn.raw_temp_bonus[stat]-=amt
end

def pbDecreaseTempStat(pkmn,stat,amt)
 pkmn.raw_temp_bonus[stat]-=amt
end
