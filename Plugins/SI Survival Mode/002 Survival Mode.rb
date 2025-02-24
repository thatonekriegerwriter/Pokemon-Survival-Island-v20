#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#                             Survival Mode                                    #
#                          By thatonekriegerwriter                             #
#                 Original Hunger Script by Maurili and Vendily                #
#                                                                              #
#                                                                              #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#Thanks Maurili and Vendily for the Original Hunger Script  

  EventHandlers.add(:on_map_transfer, :season_splash,
    proc { |_old_map_id|
  $game_temp.preventspawns=false
  $selection_arrows.clear_sprites
    }
  )
  



def pbPurify(pkmn, scene)
  return if !pkmn.shadowPokemon? || pkmn.heart_gauge != 0
  $stats.shadow_pokemon_purified += 1
  pkmn.shadow = false
  pkmn.hyper_mode = false
  pkmn.giveRibbon(:NATIONAL)
  GameData::Stat.each_main do |s|
    pkmn.raw_shadow_bonus[s.id]       = 0
  end
  pkmn.update_level_cap_for_shadow
  scene.pbDisplay(_INTL("{1} opened the door to its heart!", pkmn.name))
  old_moves = []
  pkmn.moves.each { |m| old_moves.push(m.id) }
  pkmn.update_shadow_moves
  pkmn.moves.each_with_index do |m, i|
    next if m.id == old_moves[i]
    scene.pbDisplay(_INTL("{1} regained the move {2}!", pkmn.name, m.name))
  end
  pkmn.record_first_moves
  if pkmn.saved_ev
    pkmn.add_evs(pkmn.saved_ev)
    pkmn.saved_ev = nil
  end
  pbDoLevelUps(pkmn)
  
	 if nuzlocke_has?(:NICKNAMES)
      nickname = ""
	    loop do
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", pkmn.speciesName),
                                    0, Pokemon::MAX_NAME_SIZE, "", pkmn.speciesName, true)
	    break if nickname.length>2
	    end
      pkmn.name = nickname
      @nicknamed = true
    elsif $PokemonSystem.givenicknames == 0 &&
     scene.pbConfirm(_INTL("Would you like to give a nickname to {1}?", pkmn.speciesName))
    newname = pbEnterPokemonName(_INTL("{1}'s nickname?", pkmn.speciesName),
                                 0, Pokemon::MAX_NAME_SIZE, "", pkmn)
    pkmn.name = newname
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

class Pokemon
  attr_accessor :happiness
  attr_accessor :loyalty
  attr_accessor :starter
  attr_accessor :water
  attr_accessor :food
  attr_accessor :sleep
  attr_accessor :age
  attr_accessor :maxage
  attr_accessor :lifespan
  attr_accessor :bait_eaten
  attr_accessor :status_turns
  attr_reader   :hue
  attr_accessor :inworld
  attr_accessor :attacking
  attr_accessor :inventory
  attr_accessor :height
  attr_accessor :weight
  attr_accessor :moves2
  attr_accessor :ovevent
  attr_accessor :random_attacking
  attr_accessor :attack_mode
  attr_accessor :autobattle
  attr_accessor :stages
  attr_accessor :effects
  attr_accessor :temporary
  attr_accessor :hits
  attr_accessor :iframes
  attr_accessor :associatedevent
  attr_accessor :deselecttimer
  attr_accessor :overworld_targets
  attr_accessor :stored_exp
  attr_accessor :level_cap
  attr_accessor :level_cap_basic
  attr_accessor :level_cap_bonus
  attr_accessor :raw_stat_bonus
  attr_accessor :raw_shadow_bonus
  attr_accessor :raw_purified_bonus
  attr_accessor :time_last_pet
  attr_accessor :time_last_brush
  attr_accessor :time_last_milk
  
  
  class Move
  
    def record_move_use(user, targets)
	 return if $player.pokedex.tasks[user.species.name].nil?
    $player.pokedex.tasks[user.species.name].each do |task|
      if task[:task] == "MOVE" && task[:move_item] == self.id.name
        $player.pokedex.increment_task_progress(task)
      end
    end
    end
  
  
  end
#alias _SI_Pokemon_species= species=
#def species=(species_id)
#  _SI_Pokemon_species=(species_id)
#end


alias _SI_Pokemon_init initialize
def initialize(*args)
 _SI_Pokemon_init(*args)
    @hue = nil
    @happiness        = species_data.happiness || 100
    @loyalty          = species_data.loyalty || 70
    @starter          = false
    @food             = species_data.food || 100
    @water            = species_data.water || 100
    @sleep            = species_data.sleep || 100
    @maxage          = species_data.maxage || 100
    @lifespan          = species_data.lifespan || 100
    @bait_eaten            = 0 
    @status_turns            = 0 
    @inworld     = false     # Text input mode (0=PSID, 1=PSIA)
    @attacking     = false     # Text input mode (0=PSID, 1=PSIA)
    @inventory     = []     # Text input mode (0=PSID, 1=PSIA)
    @moves2     = []     # Text input mode (0=PSID, 1=PSIA)
    @height = species_data.height + (rand(2).zero? ? -rand(40) : rand(40))
    @weight = species_data.weight + (rand(2).zero? ? -rand(70) : rand(70))
    @ovevent = nil
    @storedmoveset = []
    @random_attacking = nil
    @attack_mode = nil
    @autobattle = nil
    @temporary = false
    @temporary_timer = 2
    @hits = 0
    @stages      = getStages
    @iframes     = 0
    @associatedevent     = nil
    @deselecttimer     = 0
    @stored_exp     = 0
    @level_cap_bonus     = 0
    @level_cap_bonus     = 0
	 @memory       = _INTL("Press [ALT] to write more.")
    @level_cap_basic     = pbPersonalLevelCap(self).to_i
    @level_cap = @level_cap_basic.to_i
    @overworld_targets = {}
    @raw_stat_bonus               = {}
    @raw_shadow_bonus               = {}
    @raw_purified_bonus               = {}
    @raw_temp_bonus               = {}
    GameData::Stat.each_main do |s|
      @raw_stat_bonus[s.id]       = 0
      @raw_shadow_bonus[s.id]       = 0
      @raw_purified_bonus[s.id]       = 0
      @raw_temp_bonus[s.id]       = [0,0]
    end
     @time_last_pet = pbGetTimeNow.to_i-3600
     @time_last_brush = pbGetTimeNow.to_i-3600
     @time_last_milk = pbGetTimeNow.to_i-3600
     @focus_style = Settings::FOCUS_STYLE_DEFAULT
    @shiny_leaf = 0
      @hidden_modifiers = []
    @starter          = false
    @trainer_ace = false
    @scale = rand(256)
    @tera_type = GameData::Species.get(args[0]).types.sample
    @terastallized = false
    @mastered_moves = []
    @dynamax_lvl  = 0
    @dynamax      = false
    @reverted     = false
    @gmax_factor  = false
    @dynamax_able = nil
    @onAdventure  = false
    @location      = nil
    @collectedItems      = []
    @encounterLog      = []
    @adventuringTypes      = ["None"]
    @chosenAdvType      = nil
    @travelswithEgg      = nil
    @travelingpartners      = nil
    @inDungeon      = false
    @advSteps      = 0
    @who_fighting      = nil
    @wait_time      = 0
    @just_arrived      = false
    @called_back      = false
    @called_back_map      = nil

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
   def time_last_pet
   @time_last_pet = pbGetTimeNow.to_i-3600 if @time_last_pet.nil?
   return @time_last_pet
   end
   
   def time_last_brush
   @time_last_brush = pbGetTimeNow.to_i-3600 if @time_last_brush.nil?
   return @time_last_brush
   end
   
   def time_last_milk
   @time_last_milk = pbGetTimeNow.to_i-3600 if @time_last_milk.nil?
   return @time_last_milk
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


   def update_level_cap
      @level_cap = @level_cap_basic + @level_cap_bonus
   end
   
   def update_level_cap_for_shadow
      cap = pbPersonalLevelCap(self)
	  if cap > @level_cap_basic
	   @level_cap_basic = cap
	  end
	  update_level_cap
   end
   
   def associatedevent
   return @associatedevent
   end

   def stored_exp
   @stored_exp = 0 if @stored_exp.nil?
   return @stored_exp
   end
   

   def level_cap
   @level_cap_basic = pbPersonalLevelCap(self) if @level_cap_basic.nil?
   @level_cap = @level_cap_basic if @level_cap.nil?
   return @level_cap
   end
   
   def inworld
   @inworld = false if @inworld.nil?
   return @inworld
   end

   def stages
   @stages = getStages if @stages.nil?
   return @stages
   end
   
   def effects
   if @effects.nil?
   @effects = [] 
   $PokemonGlobal.ov_combat.pbInitEffects(self)
   end
   return @effects
   end
  

     def getStages
    return {
	  :ATTACK => 0,
	  :DEFENSE => 0,
	  :SPECIAL_ATTACK => 0,
	  :SPECIAL_DEFENSE => 0,
	  :SPEED => 0,
	  :ACCURACY => 0,
	  :CRIT => 0
			}
   
   end

   def statusCount
	return @status_turns
   end
   def status_turns
    @status_turns = 0 if @status_turns.nil?
	return @status_turns
   end   
   def hits
    @hits = 0 if @hits.nil?
	return @hits
   end
   def deselecttimer
    @deselecttimer = 0 if @deselecttimer.nil?
	return @deselecttimer
   end
   def temporary
    @temporary = false if @temporary.nil?
	return @temporary
   end
   def temporary_timer
    @temporary_timer = false if @temporary_timer.nil?
	return @temporary_timer
   end
   def permadeath
    return @permaFaint
   end
   def dead?
    return @permaFaint==true
   end
   def iframes
    @iframes = 0 if !@iframes
    return @iframes
   end
   def set_in_world(value,event=nil)
	    @ovevent=event if !event.nil?
	    @inworld=value
   end
   
   def get_in_world
	 return @inworld,getOverworldPokemonfromPokemon(self)
   end
   def temporary
    @temporary = false if @temporary.nil?
    return @temporary
   end
   
   def in_world
    return @inworld
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
   return 0
  end
 
  def happiness
    @happiness = 100 if !@happiness
    return @happiness
  end
  def loyalty
    @loyalty = 70 if !@loyalty
    return @loyalty
  end
  def starter
    @starter = false if !@starter
    return @starter
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
  def inventory
    @inventory = [[@item,1]] if !@inventory
    if !@item.nil? && @inventory[0][0].nil?
	 @inventory[0][0]=@item
	end
    return @inventory
  end
  
  def inv_add(item,amt=1)
    amt=1 if amt.nil?
    if !@item.nil? && @inventory[0][0].nil?
	 @inventory[0][0]=@item
	end
    if @inventory.length+1<=7
     theitems = inv_has?(item)
    if theitems==true
	  @inventory[theitems][1]+=amt
	 else
    @inventory << [item,amt]
	 end
	return true
    else
	return false
	end
  end
  
  
  def inv_remove(item,amt=1)
    if !@item.nil? && @inventory[0][0].nil?
	 @inventory[0][0]=@item
	end
     inventory = @inventory.reverse
     theitems = inv_has?(item)
    if theitems!=false
	  @inventory[theitems][1]-=amt
	  if @inventory[theitems][1]==0
	   @inventory.delete_at(theitems)
	  end
	   return true
	 end
   return false
  end
  
  
  def inv_has?(item)
    if !@item.nil? && @inventory[0][0].nil?
	 @inventory[0][0]=@item
	end
     index2 = -1
    @inventory.each_with_index do |invitem,index|
	   next if invitem.nil?
      index2 = index if invitem[0]==item
	
	end
	 return true if index2!=-1
	 return false if index2==-1
	 return false
  end


def check_obedience(pkmn,directing=false)
  return disobeying(pkmn,directing) if rand(100)+1<= pkmn.calculate_disobedience_chance(pkmn.loyalty,pkmn.happiness)

end  
  
def disobeying_direction(pkmn)
     r = rand(256)
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness >= 200
      sideDisplay(("#{pkmn.name} wants you to praise it before it does anything!"))
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && pkmn.happiness >= 199
      sideDisplay(("#{pkmn.name} wants to play!"))
      return false 
    end
    case rand(4)
    when 0 then sideDisplay(("#{pkmn.name} won't obey!"))
    when 1 then sideDisplay(("#{pkmn.name} turned away!"))
    when 2 then sideDisplay(("#{pkmn.name} is loafing around!"))
    when 3 then sideDisplay(("#{pkmn.name} pretended not to notice!"))
    end
	return false
end  


def calculate_disobedience_chance(loyalty,happiness)
 amt = 0
  case loyalty
  when 0..10
    amt = 80
  when 11..50
    amt = 60
  when 51..64
    amt = 45
  when 65..149
    amt = 30
  when 150..224
    amt = 15
  else
    amt = 0
  end
  amt-= (happiness/20).floor
  amt = 0 if amt<0
  return amt
end
  
  

    

  def changeFood

  end
  
  def changeWater

  end
  
  def changeSleep

  end
  
  def changeLifespan(method,pkmn)
    if @lifespan.nil?
	 @lifespan = 50
	end
    gain = 0
    lifespan_range = @lifespan / 100
      case method
      when "age"
        gain = [-1, -1, -1][lifespan_range]
      when "dehydrated"
        gain = [-2, -1, -2][lifespan_range]
      when "starving"
        gain = [-2, -2, -1][lifespan_range]
      when "dehydratedbadly"
        gain = [-9, -10, -9][lifespan_range]
      when "starvingbadly"
        gain = [-9, -10, -9][lifespan_range]
	  end
    @lifespan = (@lifespan + gain).clamp(0, 100)
  end
  
  def changeAge
    if @age.nil?
	 @age = 1
	end
    gain = 0
    age_range = @age / 100
    gain = [1, 1, 1][age_range]
    @age = (@age + gain).clamp(0, 100)
  end
  
   def moves2
    @moves2 = [] if @moves2.nil?
    return @moves2
   end
  def learn_move2(move_id)
    move_data = GameData::Move.try_get(move_id)
    return if !move_data
    @moves2 = [] if @moves2.nil?
    # Check if self already knows the move; if so, move it to the end of the array
    @moves2.each_with_index do |m, i|
      next if m.id != move_data.id
      @moves2.push(m)
      @moves2.delete_at(i)
      return
    end
    # Move is not already known; learn it
    @moves2.push(Pokemon::Move.new(move_data.id))
    # Delete the first known move if self now knows more moves than it should
    @moves2.shift if numMoves2 > MAX_MOVES
  end

  def numMoves2
    return @moves2.length
  end
end
class Game_Player < Game_Character
 def attack_opportunity

  return $player.attack_opportunity
 end
end
class Player < Trainer
  attr_reader :playerwater
  attr_reader :playerfood
  attr_reader :playersleep
  attr_reader :playerbasewater
  attr_reader :playerbasefood
  attr_reader :playerbasesleep
  attr_reader :playermaxwater
  attr_reader :playermaxfood
  attr_reader :playermaxsleep
  attr_reader :playersaturation
  attr_reader :playerhealth
  attr_reader :playerbasehealth 
  attr_reader :playermaxhealth
  attr_reader :playermaxhealth2
  attr_reader :playerstamina
  attr_reader :playertemperature
  attr_reader :playerbasestamina
  attr_reader :playermaxstamina
  attr_reader :playershirt 
  attr_reader :playerpants
  attr_reader :playershoes  
  attr_reader :exp
  attr_reader :playerclass
  attr_reader :playerclasslevel
  attr_reader :playerstateffect
  attr_accessor :punch_cooldown
  attr_accessor :weapon_cooldown
  attr_accessor :healthiness
  attr_accessor :disease
  attr_accessor :acting
  attr_accessor :iframes
  attr_accessor :running
  attr_accessor :stages
  attr_accessor :effects
  attr_accessor :potion_sickness
  
  
  attr_accessor :time_last_watered
  attr_accessor :time_last_food
  attr_accessor :time_last_slept
  attr_accessor :time_last_saturated
  attr_accessor :time_last_stamina
  attr_accessor :time_last_health
  
  
  
  attr_reader :playerfoodmod  #205
  attr_reader :playersleepmod   #208
  attr_reader :playerhealthmod #225
  attr_reader :playerwatermod  #206
  attr_reader :playerstaminamod
  attr_reader :playermaxlevel
   def playermaxlevel
    @playermaxlevel = 20 if @playermaxlevel.nil?
    return @playermaxlevel
   end
   
   def time_last_watered
    @time_last_watered = pbGetTimeNow.to_i-rand(120)+1 if @time_last_watered.nil?
    return @time_last_watered
   end
   
   def time_last_food
    @time_last_food = pbGetTimeNow.to_i-rand(120)+1 if @time_last_food.nil?
    return @time_last_food
   end
   
   def time_last_slept
    @time_last_slept = pbGetTimeNow.to_i-rand(240)+1 if @time_last_slept.nil?
    return @time_last_slept
   end
  
   def time_last_saturated
    @time_last_saturated = pbGetTimeNow.to_i-rand(80)+1 if @time_last_saturated.nil?
    return @time_last_saturated
   end
  
   def time_last_stamina
    @time_last_stamina = pbGetTimeNow.to_i-rand(5)+1 if @time_last_stamina.nil?
    return @time_last_stamina
   end
  
   def time_last_health
    @time_last_health = pbGetTimeNow.to_i-rand(5)+1 if @time_last_health.nil?
    return @time_last_health
   end
   
   def attack_cooldowns
     return @weapon_cooldown, @punch_cooldown
   end

   def iframes
    @iframes = 0 if @iframes.nil?
    return @iframes
   end
  
   def running
    @running = false if @running.nil?
    return @running
   end
  def playersaturation=(value)
    validate value => Float
    @playersaturation = value.clamp(0, 100)
  end
  def playersleep=(value)
    validate value => Float
    @playersleep = value.clamp(0, 9999)
  end
  def playerwater=(value)
    validate value => Float
    @playerwater = value.clamp(0, 9999)
  end
  def playerfood=(value)
    validate value => Float
    @playerfood = value.clamp(0, 9999)
  end

  def playertemperature=(value)
    validate value => Float
    @playertemperature = value.clamp(0, 9999)
  end

  def fainted?
    return @playerhealth <= 0
  end

  def playerbasesleep=(value)
    validate value => Float
    @playerbasesleep = value.clamp(0, 200)
  end
  def playerbasewater=(value)
    validate value => Float
    @playerbasewater = value.clamp(0, 100)
  end
  def playerbasefood=(value)
    validate value => Float
    @playerbasefood = value.clamp(0, 100)
  end
  
  
  def attack_opportunity
    return @weapon_cooldown if @weapon_cooldown>0
    return @punch_cooldown if @punch_cooldown>0
	return 0
  end

  def playermaxwater=(value)
    validate value => Float
    @playermaxwater = value.clamp(0, 9999)
  end
  def playermaxsleep=(value)
    validate value => Float
    @playermaxsleep = value.clamp(0, 9999)
  end
  def playermaxfood=(value)
    validate value => Float
    @playermaxfood = value.clamp(0, 9999)
  end


  def playerhealth=(value)
    validate value => Float
    @playerhealth = value.clamp(0, 9999)
  end
  def playerbasehealth=(value)
    validate value => Float
    @playerbasehealth = value.clamp(0, 100)
  end
  def playermaxhealth=(value)
    validate value => Float
    @playermaxhealth = value.clamp(0, 9999)
  end
  def playermaxhealth2=(value)
    validate value => Float
    @playermaxhealth2 = value.clamp(0, 9999)
  end


  def playerstamina=(value)
    validate value => Float
    @playerstamina = value.clamp(0, 9999)
  end
  def playerbasestamina=(value)
    validate value => Float
    @playerstamina = value.clamp(0, 9999)
  end
  def playermaxstamina=(value)
    validate value => Float
    @playermaxstamina = value.clamp(0, 9999)
  end

  def playerclass=(value)
    @playerclass = value
  end
  def playerclasslevel=(value)
    validate value => Integer
    @playerclasslevel = value.clamp(0, 100)
  end
  def playershirt
    @playershirt = ItemData.new(@playershirt) if @playershirt.is_a?(Symbol)
	return @playershirt
  end
  def playerpants
    @playerpants = ItemData.new(@playerpants) if @playerpants.is_a?(Symbol)
	return @playerpants
  end
  def playershoes
    @playershoes = ItemData.new(@playershoes) if @playershoes.is_a?(Symbol)
	return @playershoes
  end
  
  def playershirt=(value)
    @playershirt = value
  end
  def playerpants=(value)
    @playerpants = value
  end
  def playershoes=(value)
    @playershoes = value
  end
  def punch_cooldown=(value)
    @punch_cooldown = value
  end
   def get_max_exp
    @playermaxlevel = 20 if @playermaxlevel.nil?
    return @playermaxlevel*100
   
   end

   def exp=(value)
    validate value => Integer
    @exp = value.clamp(0, get_max_exp)
  end
   
   
   
    def minimum_exp_for_level(level)
       @playermaxlevel = 20 if @playermaxlevel.nil?
      return ArgumentError.new("Level #{level} is invalid.") if !level || level <= 0
      level = [level, @playermaxlevel].min
      return level*100 if level < @playermaxlevel
	   return 100
    end

  def level_from_exp(exp)
       @playermaxlevel = 20 if @playermaxlevel.nil?
        max = @playermaxlevel
      return max if exp >= get_max_exp
      (1..max).each do |level|
        return level if exp < minimum_exp_for_level(level)
      end
      return max
  
  
  end
  
  def playerstateffect=(value)
    @playerstateffect = value
  end

  def playerstaminamod=(value)
    validate value => Float
    @playerstaminamod = value.clamp(0, 50)
  end
  def playerhealthmod=(value)
    validate value => Float
    @playerhealthmod = value.clamp(0, 9999)
  end
  def playerfoodmod=(value)
    validate value => Float
    @playerfoodmod = value.clamp(0, 9999)
  end

  def playersleepmod=(value)
    validate value => Float
    @playersleepmod = value.clamp(0, 9999)
  end 
  def playerwatermod=(value)
    validate value => Float
    @playerwatermod = value.clamp(0, 9999)
  end  
  
  
   def stages
   @stages = getStages if @stages.nil?
   return @stages
   end
   
   def effects
   if @effects.nil?
   @effects = [] 
   $PokemonGlobal.ov_combat.pbInitEffects(self)
   end
   return @effects
   end
   
   
     def getStages
    return {
	  :ATTACK => 0,
	  :DEFENSE => 0,
	  :SPECIAL_ATTACK => 0,
	  :SPECIAL_DEFENSE => 0,
	  :SPEED => 0,
	  :ACCURACY => 0,
	  :CRIT => 0
			}
   
   end
  
   alias _SI_Player_Init initialize
  def initialize(name, trainer_type)
    _SI_Player_Init(name, trainer_type)
    @playerpants           = ItemData.new(:NORMALPANTS)
    @playershirt           = ItemData.new(:NORMALSHIRT)
    @playershoes           = ItemData.new(:NORMALSHOES)
    @playerwater   = 100.0   # Text speed 
    @playerfood = 100.0     # Battle effects (animations) (0=on, 1=off)
    @playerhealth  = 100.0     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playersaturation = 200.0     # Battle style (0=switch, 1=set)
    @playersleep = 100.0     # Battle style (0=switch, 1=set)
    @playerstamina  = 50.0     # Speech frame
    @playerbasestamina  = 100.0     # Speech frame
    @playermaxstamina  = 100.0     # Speech frame
    @playermaxsleep  = 100.0     # Speech frame
    @playermaxhealth  = 100.0     # Speech frame
    @playermaxhealth2  = @playermaxhealth    # Speech frame
    @playertemperature  = 37.0   # Speech frame
    @playermaxfood  = 100.0   # Speech frame
    @playermaxwater  = 100.0     # Speech frame
    @playerbasesleep = 100.0     # Battle style (0=switch, 1=set)
    @playerbasewater   = 100.0   # Text speed 
    @playerbasefood = 100.0     # Battle effects (animations) (0=on, 1=off)
    @playerbasehealth  = 100.0     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playerclass           = nil
    @playerclasslevel                 = 1
    @exp     = 0 
    @playerstateffect     = "None"    
    @punch_cooldown     = 0     # Text input mode (0=PSID, 1=PSIA)
    @healthiness     = 100
    @disease     = []
    @iframes     = 0
    @running     = false
    @stages      = getStages
	
    @playerstaminamod  = 0.0     # Speech frame
    @playerfoodmod  = 0.0     # Speech frame
    @playerwatermod  = 0.0     # Speech frame
    @playersleepmod  = 0.0     # Speech frame
    @playerhealthmod  = 0.0     # Speech frame
	
  end
  
   
   
   def add_disease(disease_id,length=8,severity=:NORMAL)
      disease = GameData::Diseases.try_get(disease_id)
      return false if disease.nil?
	   index = has_disease?(disease_id)
	   if index==false
        @disease << Disease.new(disease,length,severity)
		else
		 curdisease = @disease[index]
		 curdisease.length += length
		 curdisease.severity += severity
		end
   end
   def remove_disease(disease_id)
      disease = GameData::Diseases.try_get(disease_id)
      return false if disease.nil?
	   index = has_disease?(disease_id)
	   if index!=false
        @disease.delete_at(index)
      end
   end
   def has_disease?(disease_id)
      @disease = [] if @disease.nil?
      @disease = [] if @disease == :NONE
      @disease.each_with_index do |disease,index|
	    next if disease.id!=disease_id
	     return index
	  end
     return false
   end



  def active_party
    return @party.find_all { |p| p && p.inworld && p.associatedevent && !p.fainted? }
  end



end






class Player < Trainer #SECONDARY DEFINITIONS
  
  def decrease_current_total_hp
    @playermaxhealth2-=(@playermaxhealth/4)
  end
  def is_dead
    return @playermaxhealth2<=0
  end
  
  def punch_cooldown
   @punch_cooldown = 0 if @punch_cooldown.nil?
   return @punch_cooldown
  end
  def weapon_cooldown
   @weapon_cooldown = 0 if @weapon_cooldown.nil?
   return @weapon_cooldown
  end
  def acting
   @acting = false if @acting.nil?
   return @acting
  end

  def status
   return @playerstateffect
  end



  def heal_self
    @playerhealth = @playermaxhealth
  end
  
  
  def shoespeed
    case @playershoes.id
     when :MAKESHIFTRUNNINGSHOES
	    return 40
     when :RUNNINGSHOES
	    return 60
     when :SEASHOES
	    return 80
     when :DASHBOOTS
	    return 100
    else
	    return 20
	end
  end 
  
  def equipmentatkbuff
    case @playershoes.id
     when :NORMALSHIRT
	    return 0
     when :SILKSHIRT
	    return 10
     when :WOOLENCLOAK
	    return 20
     when :LEATHERJACKET
	    return 25
     when :IRONARMOR
	    return 50
    else
	    return 0
	end
  end 
  
  def equipmentdefbuff
    case @playershoes.id
     when :NORMALSHIRT
	    return 0
     when :SILKSHIRT
	    return 0
     when :WOOLENCLOAK
	    return 0
     when :LEATHERJACKET
	    return 10
     when :IRONARMOR
	    return 20
    else
	    return 0
	end
  end 
  
  
  


  def speed
      bonus = 0
   @party.each do |pkmn|
     next if pkmn.egg?
    bonus += pkmn.speed
   end
   if bonus!=0
     bonus = (bonus/@party.length).to_i
   end
    return shoespeed + bonus
  end
  
  
  def current_total_hp
   @playermaxhealth2 = @playermaxhealth if @playermaxhealth2.nil?
   @playermaxhealth2 = @playermaxhealth2.to_f if @playermaxhealth2.is_a? Integer
   return @playermaxhealth2
  end
  
  
  def totalhp
   return @playermaxhealth
  end
  def hp
   return @playerhealth
  end
  def stamina
   return @playerstamina
  end
  def food
   return @playerfood
  end
  def water
   return @playerwater
  end
  def sleep
   return @playersleep
  end

  def types
   return [:NORMAL]
  end
  def class
   return @playerclass
  end

end


class Player < Trainer #PARTNERS
  attr_reader :playermode
  attr_reader :playerwrath
  attr_reader :playerharmony
  attr_reader :playermoral
  attr_reader :partner1 #207
  attr_reader :partner2 #207
  attr_reader :partner3 #207
  attr_reader :partner4 #207
  attr_reader :partner5 #207
  attr_reader :partner6 #207
  attr_reader :partner7 #207
  attr_reader :partner8 #207
  attr_reader :partner1affinity #207
  attr_reader :partner2affinity #207
  attr_reader :partner3affinity #207
  attr_reader :partner4affinity #207
  attr_reader :partner5affinity #207
  attr_reader :partner6affinity #207
  attr_reader :partner7affinity #207
  attr_reader :partner8affinity #207
  attr_reader :blueaffinity #207
  attr_reader :redaffinity #207
  attr_reader :runpartner1 #207
  attr_reader :runpartner2 #207
  attr_reader :runpartner3 #207
  attr_reader :runpartner4 #207
  attr_reader :runpartner5 #207
  attr_reader :runpartner6 #207
  attr_reader :runpartner7 #207
  attr_reader :demotimer #207
  attr_accessor :rocket_unlocked
  attr_accessor :chapter2_unlocked
  attr_reader :rocketplaythrough
  attr_reader :rocketbadges
  attr_reader :rocketstealing
  attr_reader :rocketstealcount

  def playermode=(value)
    @playermode = value
  end
  
  def partner1=(value)
    @partner1 = value
  end
  def partner2=(value)
    @partner2 = value
  end
  def partner3=(value)
    @partner3 = value
  end
  def partner4=(value)
    @partner4 = value
  end
  def partner5=(value)
    @partner5 = value
  end
  def partner6=(value)
    @partner6 = value
  end
  def partner7=(value)
    @partner7 = value
  end
  def partner8=(value)
    @partner8 = value
  end
  def partner1affinity=(value)
    validate value => Integer
    @partner1affinity = value.clamp(0, 100)
  end
  def partner2affinity=(value)
    validate value => Integer
    @partner2affinity = value.clamp(0, 100)
  end
  def partner3affinity=(value)
    validate value => Integer
    @partner3affinity = value.clamp(0, 100)
  end
  def partner4affinity=(value)
    validate value => Integer
    @partner4affinity = value.clamp(0, 100)
  end
  def partner5affinity=(value)
    validate value => Integer
    @partner5affinity = value.clamp(0, 100)
  end
  def partner6affinity=(value)
    validate value => Integer
    @partner6affinity = value.clamp(0, 100)
  end
  def partner7affinity=(value)
    validate value => Integer
    @partner7affinity = value.clamp(0, 100)
  end
  def partner8affinity=(value)
    validate value => Integer
    @partner7affinity = value.clamp(0, 100)
  end
  def blueaffinity=(value)
    validate value => Integer
    @blueaffinity = value.clamp(0, 100)
  end
  def redaffinity=(value)
    validate value => Integer
    @redaffinity = value.clamp(0, 100)
  end
  def runpartner1=(value)
    @runpartner1 = value
  end
  def runpartner2=(value)
    @runpartner2 = value  
  end
  def runpartner3=(value)
    @runpartner2 = value  
  end
  def runpartner4=(value)
    @runpartner4 = value
  end
  def runpartner5=(value)
    @runpartner5 = value
  end
  def runpartner6=(value)
    @runpartner6 = value
  end
  def runpartner7=(value)
    @runpartner7 = value
  end

  def demotimer=(value)
    validate value => Integer
    @demotimer = value.clamp(0, 691200)
  end
    
  def playermoral=(value)
    validate value => Integer
    @playermoral = value.clamp(0, 9999)
  end
  def playerharmony=(value)
    validate value => Integer
    @playerharmony = value.clamp(0, 9999)
  end
  def playerwrath=(value)
    validate value => Integer
    @playerwrath = value.clamp(0, 9999)
  end
  def rocketplaythrough=(value)
    validate value => Integer
    @rocketplaythrough = value.clamp(0, 1)
  end
  def rocketbadges=(value)
    validate value => Integer
    @rocketbadges = 0
  end
  def rocketstealing=(value)
    validate value => Integer
    @rocketstealing = 0
  end
  def rocketstealcount=(value)
    validate value => Integer
    @rocketstealcount = value.clamp(0, 9999)
  end
  
   alias _SI_Player_InitP initialize
  def initialize(name, trainer_type)
    _SI_Player_InitP(name, trainer_type)
    @rocket_unlocked = false
    @chapter2_unlocked = false
    @rocketplaythrough                  = 0
    @rocketbadges                  = 0
    @rocketstealing                 = 0
    @rocketstealcount                 = 0
    @playerwrath                 = 0
    @playerharmony                 = 0
    @playermoral                 = 0
    @partner1          = 1
    @partner2          = 2
    @partner3          = 3
    @partner4          = 4
    @partner5          = 5
    @partner6          = 6
    @partner7          = 7
    @partner8          = 8
    @partner1affinity          = 50
    @partner2affinity          = 50
    @partner3affinity          = 50
    @partner4affinity          = 50
    @partner5affinity          = 50
    @partner6affinity          = 50
    @partner7affinity          = 50
    @partner8affinity          = 50
    @blueaffinity          = 50
    @redaffinity          = 50
    @runpartner1          = 0
    @runpartner2          = 0
    @runpartner3          = 0
    @runpartner4          = 0
    @runpartner5          = 0
    @runpartner6          = 0
    @runpartner7          = 0 
    @runpartner6          = 0
    @runpartner7          = 0 
    @demotimer            = 691200 
    @playermode     = 1     # Text input mode (0=PSID, 1=PSIA)
  end
  
end

class Player < Trainer #HELD ITEM

  attr_reader :held_item
  attr_reader :held_item_object
  attr_reader :equipped_item
  
  
     alias _SI2_Player_Init initialize
  def initialize(name, trainer_type)
    _SI2_Player_Init(name, trainer_type)
    @held_item           = nil
    @held_item_object = nil
    @equipped_item = nil
  end


    def held_item=(value)
       @held_item = value
    end
    def held_item_object=(value)
       @held_item_object = value
    end


    def hold(item)
    if !@held_item
        @held_item=item
	  if !pbSeenTipCard?(:OVERWORLDITEMS)
	    pbShowTipCard(:OVERWORLDITEMS)
	  end
        pbHoldingObject($game_player.x,$game_player.y-1,item,true)
		return true
	end
    return false
    end
    
    def equip(item)
    @equipped_item = item
	end
    def unequip
    @equipped_item = nil
	end

    def place(x,y)
    if !@held_item.nil?
	
	    item = @held_item
		key_id = @held_item_object
		direction = $game_map.events[key_id].direction
		if pbPlaceObject(x,y,item,false,direction)
		if !$map_factory
           $game_map.removeThisEventfromMap(key_id)
        else
           mapId = $game_map.map_id
           $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
        end
		deletefromSIData(key_id,$game_map.map_id)
        @held_item=nil
		@held_item_object=nil
           return true
	    else
           return false
	    end
    else
      return false
    end
    end


end










def pbSleepRestore(wari,vari=nil)
  wari = wari.to_f
##########PLAYER###################
#       Stamina   #
  $player.playerstamina = $player.playermaxstamina
#       Sleep     #
  if !vari.nil?
  $player.playersleep = $player.playersleep-(wari*9)
  else
  
	 rain_delta = pbGetTimeNow.to_i - $player.time_last_slept
	  time = rain_delta/3600
	  time = [time,1].max
  $player.playersleep = $player.playersleep+(wari*9)+(8 * time)
  end
  if $player.playersleep > 200.0
  $player.playersleep = 200.0  
  end
  if $player.playersleep < 0.0
  $player.playersleep = 0.0  
  end
#       FoodWater     #
 if false
 if $player.playersaturation==0
   $player.playerfood=$player.playerfood-(wari*1.25)
   $player.playerwater=$player.playerwater-(wari*1.25)
  else
   if $player.playersaturation-(wari*7) < 0.0
    potato = $player.playersaturation-(wari*2)
	$player.playersaturation=0.0
   $player.playerfood=$player.playerfood+(potato*1.25)
   $player.playerwater=$player.playerwater+(potato*1.25)
   else
   $player.playersaturation=$player.playersaturation-(wari*2)
   end
 end
  end
##########POKEMON###################

				party = $player.party
                 for i in 0...party.length
				pkmn = party[i]
				if pkmn.sleep.nil?
				 pkmn.sleep = 100
				end
				 pkmn.sleep=pkmn.sleep+(wari*9)
				 if pkmn.sleep > 100
				 pkmn.sleep= 100  
				 end
				 pkmn.food=pkmn.food-(wari*1.25)
				 pkmn.water=pkmn.water-(wari*1.25)
				 end
#       Daycare     #
  deposited = DayCare.count
  if deposited==2 && $PokemonGlobal.daycareEgg==0
    $PokemonGlobal.daycareEggSteps = 0 if !$PokemonGlobal.daycareEggSteps
    $PokemonGlobal.daycareEggSteps += (1*wari*10)
  end
 end
 

 def pbEatingPkmn(pkmn,item=nil)
 if item.nil?
 item = 0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$bag)
item = screen.pbChooseItemScreen(proc { |item| (GameData::Item.get(item).is_foodwater? || GameData::Item.get(item).is_berry?) && !GameData::Item.get(item).is_apricorn? && item!=:ACORN })
}
 end


if item
$bag.remove(item)
case item
when :ORANBERRY
pkmn.food+=25
pkmn.water+=25
return true
when :LEPPABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :CHERIBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :CHESTOBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :PECHABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :RAWSTBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :ASPEARBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :PERSIMBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :LUMBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :FIGYBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :WIKIBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :MAGOBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :AGUAVBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :IAPAPABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :IAPAPABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :SITRUSBERRY
pkmn.food+=50
pkmn.water+=10
return true
when :BERRYJUICE
pkmn.food+=25
pkmn.water+=100
return true
when :FRESHWATER
pkmn.water+=100
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)

return true
when :ATKCURRY
pkmn.food+=80
return true
when :SATKCURRY
pkmn.food+=80
return true
when :SPEEDCURRY
pkmn.food+=80
return true
when :SPDEFCURRY
pkmn.food+=80
return true
when :ACCCURRY
pkmn.food+=80
return true
when :DEFCURRY
pkmn.food+=80
return true
when :CRITCURRY
pkmn.food+=80
return true
when :GSCURRY
pkmn.food+=80
return true
when :RAGECANDYBAR #chocolate
pkmn.food+=100
return true
when :SWEETHEART #chocolate
pkmn.food+=100
return true
when :SODAPOP
pkmn.water-=100
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true

return true
when :LEMONADE
pkmn.water+=100
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true

return true
when :HONEY
pkmn.water+=20
pkmn.food+=60
return true
when :MOOMOOMILK
pkmn.water+=100
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)

return true
when :CSLOWPOKETAIL
pkmn.food+=100
return true
when :BAKEDPOTATO
pkmn.water+=40
pkmn.food+=70
return true
when :APPLE
pkmn.water+=30
pkmn.food+=30
return true
when :CHOCOLATE
pkmn.food+=70
return true
when :LEMON
pkmn.water+=30
pkmn.food+=40
return true
when :OLDGATEAU
pkmn.water+=20
pkmn.food+=60
return true
when :LAVACOOKIE
pkmn.food+=60
return true
when :CASTELIACONE
pkmn.water+=70
pkmn.food+=70
return true
when :LUMIOSEGALETTE
pkmn.food+=60
return true
when :SHALOURSABLE
pkmn.food+=80
return true
when :BIGMALASADA
pkmn.food+=80
return true
when :ONION
pkmn.water+=30
pkmn.food+=30
return true
when :COOKEDORAN
pkmn.water+=10
pkmn.food+=60
return true
when :CARROT
pkmn.water+=30
pkmn.food+=30
return true
when :BREAD
pkmn.food+=70
return true
when :TEA
pkmn.water+=80
pkmn.food+=20
return true
when :CARROTCAKE
pkmn.water+=100
pkmn.food+=100
return true
when :COOKEDMEAT
pkmn.food+=100
return true
when :SITRUSJUICE
pkmn.water+=100
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)

return true
when :BERRYMASH
pkmn.water+=50
pkmn.food+=50
return true
when :LARGEMEAL
pkmn.water+=500#206 is Thirst
pkmn.food+=500#205 is Hunger
party = $player.party
 for i in 0...party.length
   pkmn = party[i]
   pkmn.ev[:DEFENSE] += 1
   pkmn.ev[:HP] += 1
 end
return true
else
$bag.add(item,1)
return false
end
end
end

 
 def pbEating(bag=nil,item=nil,scene=nil)
 if item.nil?
 item = 0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$bag)
item = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_foodwater? })
}
 end
 idate = GameData::Item.get(item)
  action = "eat" if !idate.is_water?
  action = "drink" if idate.is_water?
pbSEPlay(action) 
$bag.remove(item)
scene.pbDisplay(_INTL("You {2} {1}.", GameData::Item.get(item).name, action)) if !scene.nil?
sideDisplay(_INTL("You {2} {1}.",GameData::Item.get(item).name, action)) if scene.nil?


case GameData::Item.get(item).id
when :WATER
increaseWater(10)
damagePlayer(10.0)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)


return true


when :MEAT
increaseFood(15)
damagePlayer(7.0)
		pbSEPlay("normaldamage")
return true


when :BIRDMEAT
increaseFood(10)
damagePlayer(7.0)
		pbSEPlay("normaldamage")
return true
when :POISONOUSMEAT
increaseFood(10)
damagePlayer(25.0)
		pbSEPlay("normaldamage")
return true


when :ROCKYMEAT
increaseFood(10)
damagePlayer(10.0)
		pbSEPlay("normaldamage")
return true



when :BUGMEAT
increaseFood(2)
damagePlayer(2.0)
		pbSEPlay("normaldamage")
return true



when :STEELYMEAT
increaseFood(3)
damagePlayer(10.0)
		pbSEPlay("normaldamage")
return true



when :SUSHI
increaseFood(15)
damagePlayer(6.0)
		pbSEPlay("normaldamage")
return true
when :LEAFYMEAT
increaseFood(10)
damagePlayer(6.0)
		pbSEPlay("normaldamage")
return true
when :FROZENMEAT
increaseFood(6)
damagePlayer(15.0)
		pbSEPlay("normaldamage")
return true
when :DRAGONMEAT
increaseFood(20)
damagePlayer(15.0)
		pbSEPlay("normaldamage")
return true
when :EDIABLESCRYSTAL
increaseFood(6)
damagePlayer(15.0)
		pbSEPlay("normaldamage")
return true
when :ORANBERRY
increaseFood(1)
increaseHealth(1.0)
return true
when :LEPPABERRY
increaseFood(1)
return true
when :CHERIBERRY
increaseFood(1)
return true
when :CHESTOBERRY
increaseFood(1)
return true
when :PECHABERRY
increaseFood(1)
return true
when :RAWSTBERRY
increaseFood(1)
return true
when :ASPEARBERRY
increaseFood(1)
return true
when :PERSIMBERRY
increaseFood(1)
return true
when :LUMBERRY
increaseFood(1)
return true
when :FIGYBERRY
increaseFood(1)
return true
when :WIKIBERRY
increaseFood(1)
return true
when :MAGOBERRY
increaseFood(1)
return true
when :AGUAVBERRY
increaseFood(1)
return true
when :IAPAPABERRY
increaseFood(1)
return true
when :IAPAPABERRY
increaseFood(1)
return true
when :SITRUSBERRY
increaseFood(1)
increaseHealth(1.0)
return true
when :BERRYJUICE
increaseFood(2.0)
increaseWater(8.0)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true
when :FRESHWATER
increaseWater(20.0)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true
#You can add more if you want
when :ATKCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :SATKCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :SPEEDCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :SPDEFCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :ACCCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :DEFCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :CRITCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :GSCURRY
increaseFood(8)
increaseSaturation(15)
decreaseWater(7)
return true
when :RAGECANDYBAR #chocolate
increaseFood(10)
increaseSaturation(3)
increaseSleep(7)
return true
when :SWEETHEART #chocolate
increaseFood(10)
increaseSaturation(3)
increaseSleep(7)
return true
when :SODAPOP
increaseFood(11)
increaseSaturation(30)
increaseSleep(25)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true
when :LEMONADE
increaseFood(11)
increaseSaturation(10)
increaseSleep(7)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true
when :HONEY
increaseSaturation(20)
return true
when :MOOMOOMILK
increaseSaturation(10)
increaseWater(20)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true
when :CSLOWPOKETAIL
increaseFood(20)
increaseSaturation(20)
return true
when :BAKEDPOTATO
increaseFood(7)
increaseSaturation(10)
increaseWater(4)
return true
when :APPLE
increaseFood(1)
increaseWater(1)
return true
when :CHOCOLATE
increaseFood(10)
increaseSaturation(3)
increaseSleep(7)
return true
when :LEMON
increaseFood(1)
return true
when :OLDGATEAU
increaseFood(10)
increaseSaturation(3)
increaseSleep(7)
return true
when :LAVACOOKIE
increaseFood(6)
increaseSaturation(5)
increaseWater(3)
return true
when :CASTELIACONE
increaseWater(7)
increaseFood(7)
return true
when :LUMIOSEGALETTE
increaseFood(6)
increaseSaturation(5)
return true
when :SHALOURSABLE
increaseFood(8)
increaseSaturation(8)
return true
when :BIGMALASADA
increaseFood(8)
increaseSaturation(8)
return true
when :ONION
increaseWater(1)
increaseFood(1)
return true
when :COOKEDORAN
increaseFood(3)
increaseHealth(2)
increaseSaturation(2)
return true
when :CARROT
increaseWater(1)
increaseFood(1)
increaseSaturation(6)
return true
when :BREAD
increaseFood(10)
increaseSaturation(10)
return true
when :TEA
increaseWater(15)
increaseSaturation(15)
return true
when :CARROTCAKE
increaseFood(10)
increaseWater(1)
increaseSaturation(15)
return true
when :COOKEDMEAT
increaseFood(20)
increaseSaturation(40)
return true
when :SITRUSJUICE
increaseFood(6)
increaseHealth(25)
increaseSaturation(20)
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
return true
when :BERRYMASH
increaseFood(1)
increaseWater(1)
increaseHealth(10)
increaseSaturation(5)
return true
when :LARGEMEAL
pbMessage(_INTL("You feasted on the {1}.",GameData::Item.get(item).name))
increaseFood(50)
increaseWater(50)
increaseSaturation(50)
 @party.each do |i|
  i.ev[:DEFENSE] += 1
  i.ev[:HP] += 1
 end
return true
when :COOKEDBIRDMEAT
increaseFood(12)
increaseSaturation(25)
return true
when :COOKEDROCKYMEAT
increaseFood(12)
increaseSaturation(25)
return true
when :COOKEDBUGMEAT
increaseFood(12)
increaseSaturation(25)
return true
when :COOKEDSTEELYMEAT
increaseFood(12)
increaseSaturation(25)
return true
when :COOKEDSUSHI
increaseFood(6)
increaseWater(6)
increaseSaturation(10)
return true
when :COOKEDLEAFYMEAT
increaseFood(24)
increaseSaturation(5)
return true
when :COOKEDDRAGONMEAT
increaseFood(10)
increaseSaturation(100)
return true
when :COOKEDEDIABLESCRYSTAL
increaseFood(10)
increaseSaturation(10)
return true
when :MEATSANDWICHBIRD
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHSLOWPOKETAIL
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHROCKY
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHBUG
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHSTEELY
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHSUS
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHLEAFY
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHMJ
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICHCRYSTAL
increaseFood(30)
increaseSaturation(40)
return true
when :MEATSANDWICH
increaseFood(30)
increaseSaturation(40)
return true
when :EGGEDIBLE
increaseFood(1)
increaseSaturation(20)
return true
when :CHERUBIBALL
increaseFood(7)
increaseWater(7)
increaseSaturation(1)
return true
when :POTATOSTEW
increaseFood(20)
increaseWater(20)
increaseSaturation(1)
return true
when :MEATKABOB
increaseFood(24)
increaseWater(8)
increaseSaturation(1)
return true
when :FISHSOUP
increaseFood(30)
increaseWater(40)
increaseSaturation(1)
return true
















else
$bag.add(item,1)
return false
end

end



 def pbMedicine(bag=nil,item=nil,scene=nil)
return if $player.playerhealth == $player.playermaxhealth2
time_now = pbGetTimeNow
time_delta = time_now.to_i - $player.potion_sickness
if time_delta < 1800
scene.pbDisplay(_INTL("You used {1} to heal yourself.", GameData::Item.get(item).name)) if !scene.nil?
sideDisplay(_INTL("You used {1} to heal yourself.",GameData::Item.get(item).name)) if scene.nil?
$bag.remove(item)
theitem = GameData::Item.get(item).id
case theitem
 when :WEAKPOTION
   increaseHealth(10)
 when :POTION
   increaseHealth(20)
 when :SUPERPOTION
   increaseHealth(40)
 when :HYPERPOTION
   increaseHealth(60)
 when :FULLRESTORE
   amt = $player.playermaxhealth2-$player.playerhealth
   increaseHealth(amt)
   $player.status = :NONE if $player.status!=:NONE
   $player.healthiness = 100
 else
  $bag.add(item,1)
end

object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1)
else
scene.pbDisplay(_INTL("You used a Potion too recently.")) if !scene.nil?
sideDisplay(_INTL("You used a Potion too recently.")) if scene.nil?
end
end



def checkSeconds(seconds)
  timeNow= pbGetTimeNow
  timeSeconds = seconds
  return true if timeNow >= timeSeconds
end

def pbGeneralCheck
  if pbGetTimeNow-$PokemonGlobal.generalTime>=24*60*60
   return true
  else 
   return false
  end
end

def checkHours(hour) # Hour is 0..23
  timeNow = pbGetTimeNow.hour
  timeHour = hour
  return true if timeNow == timeHour 
end

def increaseSaturation(amount)
 $player.playersaturation = $player.playersaturation.to_f if $player.playersaturation.is_a? Integer
 $player.playersaturation+=amount.to_f
 if $player.playersaturation > 200
   $player.playersaturation=200
 end
end

def increaseFood(amount)
if $player.playerfood.is_a? Integer
    $player.playerfood = $player.playerfood.to_f
end
 $player.playerfood+=amount.to_f
 if $player.playerfood > $player.playermaxfood
   $player.playerfood=$player.playermaxfood
 end
end

def increaseWater(amount)
if $player.playerwater.is_a? Integer
    $player.playerwater = $player.playerwater.to_f
end
 $player.playerwater+=amount.to_f
 if $player.playerwater > $player.playermaxwater
   $player.playerwater=$player.playermaxwater
 end
end


def increaseSleep(amount)
 $player.playersleep = $player.playersleep.to_f if $player.playersleep.is_a? Integer
 $player.playersleep+=amount.to_f
 if $player.playersleep > $player.playermaxsleep
   $player.playersleep=$player.playermaxsleep
 end
end

def decreaseSaturation(amount)
if $player.playersaturation.is_a? Integer
    $player.playersaturation = $player.playersaturation.to_f
end
   $player.playersaturation-=amount.to_f

end

def decreaseWater(amount)
if $player.playerwater.is_a? Integer
    $player.playerwater = $player.playerwater.to_f
end
   $player.playerwater-=amount.to_f

end
def decreaseFood(amount)
if $player.playerfood.is_a? Integer
    $player.playerfood = $player.playerfood.to_f
end
   $player.playerfood-=amount.to_f

end

def decreaseSleep(amount)
if $player.playersleep.is_a? Integer
    $player.playersleep = $player.playersleep.to_f
end
   $player.playersleep-=amount.to_f

end



def decreaseStamina(amount)
 $player.playerstamina = $player.playerstamina.to_f if $player.playerstamina.is_a? Integer
 amount/=1.5 if $player.is_it_this_class?(:TRIATHLETE)

if $player.playerstamina-amount<0 && $player.playerstamina>0
pbSEPlay("normaldamage")
$player.playerstamina=0.0
return true
elsif $player.playerstamina-amount<0 && $player.playerstamina<=0
pbSEPlay("normaldamage")
return false
else
$player.playerstamina-=amount.to_f

end



return true
end
#TODO: Update the entirety of this script

def increaseHealth(amount)

$player.playerhealth = $player.playerhealth.to_f if $player.playerhealth.is_a? Integer
$player.playerhealth+=amount.to_f
$player.playerhealth=$player.playermaxhealth2 if $player.playerhealth > $player.playermaxhealth2

end
def increaseTotalHealth(amount)
  return if $player.playerfood < 0.75 * $player.playermaxfood
  return if $player.playerwater < 0.75 * $player.playermaxwater
$player.playermaxhealth2+=amount.to_f
$player.playermaxhealth2=$player.playermaxhealth if $player.playermaxhealth2 > $player.playermaxhealth

end

def increaseHealthAndTotalHP(hours)
  increaseTotalHealth((hours*3.125))
  increaseHealth((hours*4.25))
end

def damagePlayer(amount,iframes=false)
  $player.playerhealth = $player.playerhealth.to_f if $player.playerhealth.is_a? Integer
  $player.playerhealth -= amount.to_f
  pbBGSPlay("Low HP Beep") if $player.hp<=$player.totalhp/4
  iframes=5 if iframes==true
  puts "#{$player.name}: #{$player.playerhealth}/#{$player.playermaxhealth2} - #{amount}"
end


def togglescaling
  $game_switches[140]=false if $game_switches[140]==true
  $game_switches[140]=true if $game_switches[140]==false
end

def turn_scaling_on
  $game_switches[140]=true
end
def turn_scaling_off
  $game_switches[140]=false
end