module GameData
  class Species
    def legendary?
	  return has_flag?("Legendary")
	end 
    def mythical?
	  return has_flag?("Mythical")
	end 
    def milkable?
	  return has_flag?("Milkable")
	end 
    def shearable?
	  return has_flag?("Shearable")
	end 
    def bee?
	  return has_flag?("Bee")
	end 
  end
end 


EventHandlers.add(:on_player_step_taken, :hatch_eggs,
  proc {
    $player.party.each do |egg|
      next unless egg 
      next if egg.steps_to_hatch <= 0
      egg.steps_to_hatch -= 1
      $player.pokemon_party.each do |pkmn|
        next if !pkmn.ability&.has_flag?("FasterEggHatching")
        egg.steps_to_hatch -= 1
        break
      end
      if egg.steps_to_hatch <= 0
        egg.steps_to_hatch = 0
        pbHatch(egg)
      end
    end
  }
)


class Pokemon
  attr_accessor :water
  attr_accessor :food
  attr_accessor :sleep
  attr_accessor :maxage
  attr_accessor :lifespan
  attr_accessor :height
  attr_accessor :weight
  attr_accessor :birth_date
  attr_accessor :memory
  attr_writer :current_map
  attr_accessor :item_timer
  attr_accessor :stamina 


  def location
    @associatedevent.nil? ? @current_map : self.event.map_id
  end 
  
  def bee?
    self.species_data.bee?
  end 
  
#alias _SI_Pokemon_species= species=
#def species=(species_id)
#  _SI_Pokemon_species=(species_id)
#end
  

alias _SI_Pokemon_init initialize
def initialize(*args)
    _SI_Pokemon_init(*args)
	species_data = GameData::Species.get(species)
    @maxage          = species_data.maxage || 100
    @lifespan          = 100
    @starter          = false
    @food             = rand(50...100)
    @water            = rand(50...100)
    @stamina            = 7
	@handled_aging = false 
    @height = species_data.height + (rand(2).zero? ? -rand(1.0) : rand(1.0))
    @weight = species_data.weight * (1 + (rand(2).zero? ? -rand(0.06) : rand(0.06)))
	@memory       = _INTL("Press [ALT] to write more.")
    @shiny_leaf = 0
    @hidden_modifiers = []
	@handled_aging = false 
	@item_timer = pbGetTimeNow.to_i - 3600
	@last_interacted_with = pbGetTimeNow.to_i
	
	@birth_date = generate_birthday

end
  def stamina
    @stamina = 7 if @stamina.nil?
    return @stamina
  end 
  def last_interacted_with
    @last_interacted_with = pbGetTimeNow.to_i if @last_interacted_with.nil?
    return @last_interacted_with
  end 
  def update_interacted
    @last_interacted_with = pbGetTimeNow.to_i
  end 
  
  def can_harvest?
	@item_timer ||= pbGetTimeNow.to_i - 3600
	time_now = pbGetTimeNow.to_i
    time_delta = time_now - @item_timer
    return time_delta >= 3600
  end 
  def harvest
	@item_timer = pbGetTimeNow.to_i
  end 
  def update
    if is_birthday? && @handled_aging==false
	
      age_ratio = self.age.to_f / @maxage
      if age_ratio >= 1.00
       changeLifespan("aging_wilderness")
      elsif age_ratio >= 0.85
       changeLifespan("aging_advancing")
      elsif age_ratio >= 0.70
       changeLifespan("aging_starting")
      end
      @handled_aging = true
	elsif !is_birthday? && @handled_aging==true
	  @handled_aging = false
	end 
  end
 
   
  def changeLifespan(method,pkmn=self)
    raise if pkmn
    gain = 0
    lifespan_range = @lifespan / 100
      case method
      when "aging_starting"
        gain = [-1, -1, -1][lifespan_range]
      when "aging_advancing"
        gain = [-2, -2, -2][lifespan_range]
      when "aging_wilderness"
        gain = [-9, -10, -9][lifespan_range]
      when "dehydrated"
        gain = [-2, -1, -2][lifespan_range]
      when "starving"
        gain = [-2, -2, -1][lifespan_range]
      when "dehydratedbadly"
        gain = [-9, -10, -9][lifespan_range]
      when "starvingbadly"
        gain = [-9, -10, -9][lifespan_range]
      when "mortally_wounded"
        gain = [-3, -4, -5][lifespan_range]
      when "suspo"
        gain = [100, 100, 100][lifespan_range]
	  end
    @lifespan = (@lifespan + gain).clamp(0, 100)
  end
  
  def die
    return unless lifespan_zero?
    data = Nuzlocke.rules; data = [] if data.nil?
	pbShowTipCardsGrouped(:DEATH) if !pbSeenTipCard?(:DOWNED)
    pkmn.hp = 0
	if $player.party.include?(pkmn)
	 pbSEPlay("DeathDQ")
	 puts "#{pkmn.name}'s lifespan is now #{pkmn.lifespan} wellness."
     pbMessage(_INTL("{1} died...", pkmn.name))
	end
    pkmn.permaFaint=true
	if data.include?(:PERMADEATH)
	  index = $player.party.index(pkmn)
      $player.party.delete_at(index)
	end 
  end 
  
  def lifespan_zero?
    return @lifespan<=0
  
  end 
  
    def get_lifespan
	  species_data.lifespan || 100
	
	end 
	def generate_birthday
       age = rand(1..100)
       days = rand(0..365)
       seconds = ((age * 365) + days) * 24 * 60 * 60
       pbGetTimeNow - seconds
	end 
	
	def set_birthday(time=pbGetTimeNow)
	   @birth_date = time
	end 
	
	def birth_date
	 @birth_date = generate_birthday if @birth_date.nil?
	 @birth_date
	end 
	def is_birthday?
 	 now = pbGetTimeNow
 	 now.month == self.birth_date.month && now.day == self.birth_date.day
	end
	
	def age
     now = pbGetTimeNow
     years = now.year - birth_date.year
     years -= 1 if now.month < birth_date.month ||
              (now.month == birth_date.month && now.day < birth_date.day)
     return years
    end
	

    def poke_ball
	   @poke_ball = @poke_ball.id if @poke_ball.is_a?(ItemData)
	  return @poke_ball
	 end
	def pokemon
	  return self
	end
	def gender_symbol
	  return "♂" if self.male?
	  return "♀" if self.female?
	  return ""
	end
	


   


   def permadeath
    return @permaFaint
   end
   def dead?
    return @permaFaint==true
   end
  # @return [Integer] the height of this Pokémon in decimetres (0.1 metres)
  def height
    @height = species_data.height + (rand(2).zero? ? -"#{0.rand(15)}".to_f : "#{0.rand(15)}".to_f) if @height.nil?
    return @height
  end

  # @return [Integer] the weight of this Pokémon in hectograms (0.1 kilograms)
  def weight
    @weight = species_data.weight + (rand(2).zero? ? -"#{0.rand(30)}".to_f : "#{0.rand(30)}".to_f) if @height.nil?
    return @weight
  end
 
  def stamina
   return 100
  end
 

  def food
    @food = 100 if !@food
    return @food
  end
  def water
    @water = 100 if !@water
    return @water
  end
  def sleep
    @sleep = 100 if !@sleep
    return @sleep
  end
  def maxage
    @maxage = 100 if !@maxage
    return @maxage
  end
  def lifespan
    @lifespan = 100 if !@lifespan
    return @lifespan
  end


  def changeFood

  end
  
  def changeWater

  end
  
  def changeSleep

  end

  def changeAge
    raise "Change Age Called"
    if @age.nil?
	 @age = 1
	end
    gain = 0
    age_range = @age / 100
    gain = [1, 1, 1][age_range]
    @age = (@age + gain).clamp(0, 100)
  end

 
end



  
   def pokemonEVs(pkmn, target)
   
    evYield = target.evYield
    # Num of effort points pkmn already has
    evTotal = 0
    GameData::Stat.each_main { |s| evTotal += pkmn.ev[s.id] }
    # Modify EV yield based on pkmn's held item
   # if !Battle::ItemEffects.triggerEVGainModifier(pkmn.item, pkmn, evYield)
   #   Battle::ItemEffects.triggerEVGainModifier(@initialItems[0][idxParty], pkmn, evYield)
  #  end
    # Double EV gain because of Pokérus
    if pkmn   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 1.1 }
    end
    if pkmn.happiness>=200   # Infected or cured
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.age.nil?
      pkmn.age=rand(50)+1
    end
    if pkmn.age>=1 && pkmn.age<=20
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>20 && pkmn.age<=40
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>40 && pkmn.sleep<=60
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>60 && pkmn.age<=80
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>80
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.pokerusStage >= 1   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 3 }
    end
    # Gain EVs for each stat in turn
    if pkmn.shadowPokemon? && pkmn.saved_ev && pkmn.level!=20
      pkmn.saved_ev.each_value { |e| evTotal += e }
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id] - pkmn.saved_ev[s.id])
        evGain = evGain*3
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.saved_ev[s.id] += evGain
        evTotal += evGain
      end
    else
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id])
        if pkmn.purifiedPokemon?
        evGain = evGain*1.5
        end
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.ev[s.id] += evGain
        evTotal += evGain
      end
    end


    end
  
  def pokemonEXP(participants,caughtmon,pkmn)
    growth_rate = pkmn.growth_rate
      return if pkmn.egg?
    expAll = $player.has_exp_all || $bag.has?(:EXPALL)
      numPartic = 0
      participants.each do |partic|
        next unless partic.able?
        numPartic += 1
      end
	
      expShare = []
      if !expAll
        $player.party.each_with_index do |pkmn, i|
          next if !pkmn.able?
          next if !pkmn.hasItem?(:EXPSHARE)
          expShare.push(i)
        end
      end
	

    # Don't bother calculating if gainer is already at level cap
	if pkmn.level>=pkmn.level_cap
     pkmn.stored_exp = 0
	  if pkmn.level>pkmn.level_cap
     levelMinExp = growth_rate.minimum_exp_for_level(pkmn.level_cap)
	  pkmn.exp = levelMinExp
	  end
      pkmn.calc_stats   # To ensure new EVs still have an effect
    return
	end
	
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end
    isPartic    = participants.include?(pkmn)
    hasExpShare = expShare.include?(pkmn)
    level = caughtmon.level
	level_cap = caughtmon.level_cap
	if level_cap.nil?
    level_cap = $PokemonSystem.level_caps == 0 ? Level_Cap::LEVEL_CAP[$game_system.level_cap] : Settings::MAXIMUM_LEVEL 
	end
	level_cap = Settings::MAXIMUM_LEVEL if $player.is_it_this_class?(:EXPERT,false)
	if !growth_rate.exp_values[level_cap]
    level_cap_gap = growth_rate.exp_values[level_cap] - pkmn.exp
	else
    level_cap_gap = growth_rate.exp_values[4] - pkmn.exp
	end
    # Main Exp calculation
    exp = 0
    a = level * caughtmon.base_exp
    if expShare.length > 0 && (isPartic || hasExpShare)
      if numPartic == 0   # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a / (2 * numPartic) if isPartic
        exp += a / (2 * expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a / 2
      end
    elsif isPartic && numPartic>1  # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a / 2
	 else
      exp = a / 1
    end
    return if exp <= 0
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = ((2 * level) + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != $player.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != $player.language))
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != $player.language
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Exp. Charm increases Exp gained
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    # Modify Exp gain based on pkmn's held item
    i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    if i < 0
      i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    end
    exp = i if i >= 0
    # Boost Exp gained with high affection
    if pkmn.happiness >= 240 && !pkmn.mega?
      exp = exp * 6 / 5
      isOutsider = true   # To show the "boosted Exp" message
    end
    # Make sure Exp doesn't exceed the maximum
	 if $PokemonGlobal.fishing==true && $game_temp.in_safari == false
	 exp/=6 
	  if exp>1000
	    exp/=2
	  end
	 else
	 
	exp *= 1.5
	 end
    expFinal = growth_rate.add_exp(pkmn.exp, exp)
	  puts pkmn.name
	  puts "pkmn.stored_exp: #{pkmn.stored_exp}"
	  puts "exp: #{exp}"
    pkmn.stored_exp += exp if exp>=0
	  puts "pkmn.stored_exp: #{pkmn.stored_exp}"
    expGained = expFinal - pkmn.exp
    return if expGained <= 0
    # "Exp gained" message
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    if newLevel < curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
                  pkmn.name, debugInfo)
    end
    # Give Exp
      
    $stats.total_exp_gained += expGained
	

 end  

