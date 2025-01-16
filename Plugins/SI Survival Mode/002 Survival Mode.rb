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
def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
 _SI_Pokemon_init(species, level, owner = $player, withMoves = true, recheck_form = true)
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
    @overworld_targets = {}

end

   def associatedevent
   return @associatedevent
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
  
  
  
  
  
  attr_reader :playerfoodmod  #205
  attr_reader :playersleepmod   #208
  attr_reader :playerhealthmod #225
  attr_reader :playerwatermod  #206
  attr_reader :playerstaminamod
  
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

   def exp=(value)
    validate value => Integer
    @exp = value.clamp(0, 100)
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
    @playerpants           = :NORMALPANTS
    @playershirt           = :NORMALSHIRT
    @playershoes           = :NORMALSHOES
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
    @disease     = :NONE
    @iframes     = 0
    @running     = false
    @stages      = getStages
	
    @playerstaminamod  = 0.0     # Speech frame
    @playerfoodmod  = 0.0     # Speech frame
    @playerwatermod  = 0.0     # Speech frame
    @playersleepmod  = 0.0     # Speech frame
    @playerhealthmod  = 0.0     # Speech frame
	
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
    case @playershoes
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
    case @playershoes
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
    case @playershoes
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
		deletefromSIData(key_id)
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
  $player.playersleep = $player.playersleep+(wari*9)
  end
  if $player.playersleep > 200.0
  $player.playersleep = 200.0  
  end
  if $player.playersleep < 0.0
  $player.playersleep = 0.0  
  end
#       FoodWater     #
 if $player.playersaturation==0
   $player.playerfood=$player.playerfood-(wari*2)
   $player.playerwater=$player.playerwater-(wari*2)
  else
   if $player.playersaturation-(wari*7) < 0
    potato = $player.playersaturation-(wari*7)
	$player.playersaturation=0
   $player.playerfood=$player.playerfood+(potato*2)
   $player.playerwater=$player.playerwater+(potato*2)
   else
   $player.playersaturation=$player.playersaturation-(wari*7)
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
				 pkmn.food=pkmn.food-(wari*2)
				 pkmn.water=pkmn.water-(wari*2)
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
pbMessage(_INTL("You offered {1} a {2}.",pkmn.name,GameData::Item.get(item).name))
$bag.remove(item)
pbMessage(_INTL("{1} takes it happily!",pkmn.name,GameData::Item.get(item).name))
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
$bag.add(:GLASSBOTTLE,1)

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
return true
$bag.add(:GLASSBOTTLE,1)

return true
when :LEMONADE
pkmn.water+=100
return true
$bag.add(:GLASSBOTTLE,1)

return true
when :HONEY
pkmn.water+=20
pkmn.food+=60
return true
when :MOOMOOMILK
pkmn.water+=100
$bag.add(:GLASSBOTTLE,1)

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
$bag.add(:GLASSBOTTLE,1)

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

 
 def pbEating(bag=nil,item=nil)
 if item.nil?
 item = 0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$bag)
item = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_foodwater? })
}
 end
pbSEPlay("eat")
$bag.remove(item)


case GameData::Item.get(item).id
when :WATER
increaseFood(10)
damagePlayer(7.0)
$bag.add(:GLASSBOTTLE,1)


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
increaseFood(4)
increaseWater(2.0)
$bag.add(:BOWL,1)
return true
when :FRESHWATER
increaseWater(20.0)
$bag.add(:GLASSBOTTLE,1)
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
$bag.add(:GLASSBOTTLE,1)
return true
when :LEMONADE
increaseFood(11)
increaseSaturation(10)
increaseSleep(7)
$bag.add(:GLASSBOTTLE,1)
return true
when :HONEY
increaseSaturation(20)
return true
when :MOOMOOMILK
increaseSaturation(10)
increaseWater(15)
$bag.add(:GLASSBOTTLE,1)
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
increaseWater(10)
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
$bag.add(:GLASSBOTTLE,1)
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



 def pbMedicine(bag=nil,item=nil)
return if $player.playerhealth == $player.playermaxhealth2
sideDisplay(_INTL("You used {1} to heal yourself.",GameData::Item.get(item).name))
$bag.remove(item)
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if GameData::Item.get(item).id == :POTION
increaseHealth(20)
return true
elsif GameData::Item.get(item).id == :SUPERPOTION
increaseHealth(40)
return true
elsif GameData::Item.get(item).id == :HYPERPOTION
increaseHealth(60)
return true
elsif GameData::Item.get(item).id == :FULLRESTORE
increaseHealth(100)
$player.status = :NONE if $player.status!=:NONE
return true
else
$bag.add(item,1)
return 0
#full belly
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
damagePlayer(1)
pbSEPlay("normaldamage")
$player.playerstamina=0.0
return true
elsif $player.playerstamina-amount<0 && $player.playerstamina<=0
damagePlayer(amount)
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

$player.playermaxhealth2+=amount.to_f
$player.playermaxhealth2=$player.playermaxhealth if $player.playermaxhealth2 > $player.playermaxhealth

end

def increaseHealthAndTotalHP(amt)
  increaseTotalHealth(amt)
  increaseHealth(amt)
end

def damagePlayer(amount,iframes=false)
  $player.playerhealth = $player.playerhealth.to_f if $player.playerhealth.is_a? Integer
  $player.playerhealth -= amount.to_f
  pbBGSPlay("Low HP Beep") if $player.hp<=$player.totalhp/4
  iframes=5 if iframes==true
  puts "#{$player.name}: #{$player.playerhealth}/#{$player.playermaxhealth2} - #{amount}"
end


MenuHandlers.add(:options_menu, :survivalmode, {
  "name"        => _INTL("Survival Mode"),
  "parent"      => :gameplay_menu2,
  "order"       => 37,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "condition"   => proc { next $player },
  "description" => _INTL("Choose whether or not you play in Survival Mode."),
  "get_proc"    => proc { next $PokemonSystem.survivalmode },
  "set_proc"    => proc { |value, scene| $PokemonSystem.survivalmode = value }
})

MenuHandlers.add(:options_menu, :temperature, {
  "name"        => _INTL("Ambient Temperature"),
  "parent"      => :gameplay_menu2,
  "order"       => 39,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether or not Survival Mode has Temperature Mechanics."),
  "condition"   => proc { next $PokemonSystem.survivalmode == 0 && $player},
  "get_proc"    => proc { next $PokemonSystem.temperature },
  "set_proc"    => proc { |value, scene| $PokemonSystem.temperature = value }
})

MenuHandlers.add(:options_menu, :nuzlockemode, {
  "name"        => _INTL("Nuzlocke Mode"),
  "parent"      => :gameplay_menu2,
  "order"       => 40,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "condition"   => proc { next $player },
  "description" => _INTL("Choose whether or not you play in Nuzlocke Mode."),
  "get_proc"    => proc { next $PokemonSystem.nuzlockemode },
  "set_proc"    => proc { |value, scene| $PokemonSystem.nuzlockemode = value 
  if $PokemonSystem.nuzlockemode == 0
    if Nuzlocke.definedrules? == true
      if Nuzlocke.on? == false
    scene.sprites["textbox"].text = ("Nuzlocke has been turned on.")
      Nuzlocke.toggle(true)
      end
    else 
    scene.sprites["textbox"].text = ("Nuzlocke has been started.")
      Nuzlocke.start
    end
  else
    if Nuzlocke.on? 
      Nuzlocke.toggle(false)
    scene.sprites["textbox"].text = ("Nuzlocke has been turned off.")
    end
  end}
})


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