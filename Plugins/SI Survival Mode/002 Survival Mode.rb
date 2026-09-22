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


class Game_Player < Game_Character
 def attack_opportunity

  return $player.attack_opportunity
 end
 
 def name
  return $player.name
 end 

 def damage(amount)
    pbOverworldCombat.damageTarget(self, amount)
 end 
 def id
  "GAME_PLAYER"
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
  attr_reader :status
  attr_writer :status_turns
  attr_accessor :punch_cooldown
  attr_accessor :weapon_cooldown
  attr_accessor :healthiness
  attr_accessor :disease
  attr_accessor :acting
  attr_accessor :iframes
  attr_accessor :running
  attr_accessor :run_pressed
  attr_accessor :stages
  attr_accessor :effects
  attr_accessor :potion_sickness
  
  attr_accessor :blocking
  
  attr_accessor :time_last_watered
  attr_accessor :time_last_food
  attr_accessor :time_last_slept
  attr_accessor :time_last_saturated
  attr_accessor :time_last_stamina
  attr_accessor :time_last_health
  attr_accessor :quick_access
  
  
  
  attr_reader :playerfoodmod  #205
  attr_reader :playersleepmod   #208
  attr_reader :playerhealthmod #225
  attr_reader :playerwatermod  #206
  attr_reader :playerstaminamod
  attr_reader :playermaxlevel

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
    @status     = :NONE    
	@status_turns = 0 
	@quick_access = :PUNCH
    @punch_cooldown     = 0     # Text input mode (0=PSID, 1=PSIA)
    @healthiness     = 100
    @disease     = []
	@active_state = OverworldCombat::PokemonActiveState.new
    @iframes     = 0
    @running     = false
    @stages      = getStages
	
    @playerstaminamod  = 0.0     # Speech frame
    @playerfoodmod  = 0.0     # Speech frame
    @playerwatermod  = 0.0     # Speech frame
    @playersleepmod  = 0.0     # Speech frame
    @playerhealthmod  = 0.0     # Speech frame
    @blocking  = false
	
  end
  
   def damage(amount)
     pbOverworldCombat.damageTarget($game_player, amount)
   end 
   def blocking
    @blocking = false if @blocking.nil?
	return @blocking 
   end 
   
   def begin_blocking
     return if self.blocking 
	 @blocking = true 
	 $scene.spriteset.addUserSprite(OWShieldSprite.new(Spriteset_Map.viewport))
   end 
   def stop_blocking
     return unless self.blocking 
	 @blocking = false 
   end 
   
   def active_state
    @active_state = OverworldCombat::PokemonActiveState.new if @active_state.nil?
	@active_state 
   end 
   
   def quick_access
     @quick_access = :PUNCH if @quick_access.nil?
    if @quick_access.is_a?(Pokemon)
      @quick_access = :PUNCH unless $player.party.include?(@quick_access)
    elsif @quick_access.is_a?(ItemData)
      @quick_access = :PUNCH unless $bag.has?(@quick_access)
    elsif @quick_access.is_a?(Pokemon::Move)
      @quick_access = :PUNCH unless $game_temp.current_pkmn_controlled && $game_temp.current_pkmn_controlled.able?
    end
	 return @quick_access
   end
   def equipped_item?
     @quick_access==:PUNCH ? nil : @quick_access
   end 
   def equipped_item
     @quick_access
   end 
    def equip(item)
    @quick_access = item
	end
    def unequip
    @quick_access = :PUNCH
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

   def total_health
     @playermaxhealth2
   end 
   def total_health=(value)
     @playermaxhealth2=value
   end 

  def active_party
    return @party.find_all { |p| p && p.inworld && p.associatedevent && !p.fainted? }
  end
  
  def base_damage
    base = 1
	base *= 2 if $player.is_it_this_class?(:BLACKBELT)
    return base
  end 
  
  
  def update
    self.party.each { |pokemon| pokemon.update if pokemon }
  end 

end


class Player < Trainer

   
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
    @time_last_stamina = 0+rand(5)+1 if @time_last_stamina.nil?
    return @time_last_stamina
   end
  
   def time_last_health
    @time_last_health = pbGetTimeNow.to_i-rand(5)+1 if @time_last_health.nil?
    return @time_last_health
   end
   def potion_sickness
    @potion_sickness = pbGetTimeNow.to_i-900 if @potion_sickness.nil?
    return @potion_sickness
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
   def run_pressed
    @run_pressed = false if @run_pressed.nil?
    return @run_pressed
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
  
  def playermaxsaturation
    return 100.0
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
      raise ArgumentError.new("Level #{level} is invalid.") if !level || level <= 0
      level = [level, @playermaxlevel].min
      return (level - 1) * 100
    end
   
    def maximum_exp_for_level(level)
       @playermaxlevel = 20 if @playermaxlevel.nil?
      raise ArgumentError.new("Level #{level} is invalid.") if !level || level <= 0
      level = [level, @playermaxlevel].min
      return level*100 if level <= @playermaxlevel
    end

  def level_from_exp(exp)
       @playermaxlevel = 20 if @playermaxlevel.nil?
        max = @playermaxlevel
      return max if exp >= get_max_exp
      (1..max).each do |level|
        return level if exp < maximum_exp_for_level(level)
      end
      return max
  
  
  end
  
  def status=(value)
    @status = value
  end
  def status
    @status = :NONE if @status.nil? || @status == "None"
    return @status
  end
  def statusCount
	return status_turns
  end
  def status_turns
    @status_turns = 0 if @status_turns.nil?
	return @status_turns
  end 
  alias playerstateffect status
  alias playerstateffect= status=

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
  


  def party_in_world
    return @party.find_all { |p| p && !p.egg? && !p.fainted? && p.in_world && p.event && p.event.map_id ==  $game_map.map_id }
  end 



end 


class Player < Trainer #SECONDARY DEFINITIONS
  
  def decrease_current_total_hp
    @playermaxhealth2-=(@playermaxhealth/4)
  end
  def restore_total_hp
    @playermaxhealth2= @playermaxhealth
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
    @playerhealth = @playermaxhealth2
  end
  
  
  def shoespeed
    @playershoes = ItemData.new(@playershoes) if @playershoes.is_a?(Symbol)
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
    return 0
  end 
  
  def equipmentdefbuff
    @playershirt = ItemData.new(@playershirt) if @playershirt.is_a?(Symbol)
    case @playershirt.id
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
  
  
  


  def speed
    return shoespeed 
  end
  
  
  def current_total_hp
   @playermaxhealth2 = @playermaxhealth if @playermaxhealth2.nil?
   @playermaxhealth2 = @playermaxhealth2.to_f if @playermaxhealth2.is_a? Integer
   return @playermaxhealth2
  end
  
  
  def totalhp
   return @playermaxhealth2
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










def pbSleepRestore(wari,vari=nil)
  wari = wari.to_f
##########PLAYER###################
#       Stamina   #
  $player.playerstamina = $player.playermaxstamina
#       Sleep     #
  if !vari.nil?
  $player.playersleep = $player.playersleep-(wari*9)
  else
  
	 rain_delta = pbCurrentTime.to_i - $player.time_last_slept
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



 
 
 if $player.playersaturation==0
   $player.playerfood=$player.playerfood-(wari*3.25)
   $player.playerwater=$player.playerwater-(wari*3.25)
  else
   if $player.playersaturation-(wari * 1.25) < 0.0
    potato = ($player.playersaturation-wari) * 1.25
	$player.playersaturation=0.0
    $player.playerfood=$player.playerfood-(potato*3.25)
    $player.playerwater=$player.playerwater-(potato*3.25)
   else
    $player.playersaturation=$player.playersaturation-(wari*1.25)
   end
 end


  
##########POKEMON###################

	party = $player.party
    for i in 0...party.length
	  pkmn = party[i]
	  pkmn.sleep = 100 if pkmn.sleep.nil?
	  pkmn.sleep=pkmn.sleep+(wari*9)
	  pkmn.sleep= 100 if pkmn.sleep > 100
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
 item = pbChooseEdiable
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
$bag.add(object,1) if object.durability!=0

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
$bag.add(object,1) if object.durability!=0
return true

return true
when :LEMONADE
pkmn.water+=100
object = item.bottle_type
object.decrease_durability(1)
$bag.add(object,1) if object.durability!=0
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
$bag.add(object,1) if object.durability!=0

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
$bag.add(object,1) if object.durability!=0

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
  $bag.remove(item) if item && pbNeoEating(item)
end

def pbNeoEating(item)
  idate = GameData::Item.get(item)
  effects = item.stats.consumable
  has_effect = false
  if effects.food && $player.playerfood < $player.playermaxfood
    has_effect = true
  end
  if effects.water && $player.playerwater < $player.playermaxwater
    has_effect = true
  end
  if effects.saturation && $player.playersaturation < $player.playermaxsaturation
    has_effect = true
  end
  if effects.sleep && $player.playersleep < $player.playermaxsleep
    has_effect = true
  end
  if effects.health && $player.playerhealth < $player.playermaxhealth2
    has_effect = true
  end
  
  return false unless has_effect
  
  action = idate.is_water? ? "drink" : "eat"
  pbSEPlay(action)
  sideDisplay(_INTL("You {2} {1}.", idate.name, action),true,-9)


  increaseFood(effects.food)              if effects.food
  increaseWater(effects.water)            if effects.water
  increaseSaturation(effects.saturation)  if effects.saturation
  increaseSleep(effects.sleep)            if effects.sleep
  increaseHealth(effects.health)          if effects.health && effects.health > 0 
  damagePlayer(effects.health.abs)          if effects.health && effects.health < 0 
  pbSEPlay(effects.se)                    if effects.se
  
  if effects.has_bottle?
    bottle = item.bottle_type
    bottle.decrease_durability(1) if bottle
    $bag.add(bottle, 1) if bottle
  end
  
  if effects.feast?
    sideDisplay(_INTL("You feasted on the {1}.", idate.name),true,-9)
    @party.each do |pokemon|
      effects.feast_boosts.each do |stat, amt|
        next unless pokemon.ev.key?(stat)
        pokemon.ev[stat] += amt
      end
    end
  end
  
  
  return true
end 

def pbNeoMedicine(item)
 return false if $player.playerhealth == $player.playermaxhealth2
 time_now   = pbGetTimeNow
 time_delta = time_now.to_i - $player.potion_sickness
 
 if time_delta >= 300
    idate = GameData::Item.get(item)
    effects = item.stats.consumable
    sideDisplay(_INTL("You used {1} to heal yourself.", item.name),true,-9)
	
	if effects.health && effects.health > 0 
	 restoreHP = effects.health
	 $player.restore_total_hp if restoreHP >= 9999 && $player.is_it_this_class?(:NURSE,false) && $player.playerclasslevel >= 20
     restoreHP *= 1.5 if $player.is_it_this_class?(:NURSE)
     increaseHealth(restoreHP)    
    end 	
    damagePlayer(effects.health.abs)          if effects.health && effects.health < 0 
	$player.status      = effects.status if effects.status
	$player.healthiness = [$player.healthiness + effects.healthiness,100].min if effects.healthiness
	
    if effects.has_bottle?
      bottle = item.bottle_type
      bottle.decrease_durability(1)
      $bag.add(bottle, 1)
    end
	$player.potion_sickness = time_now.to_i
	return true
 else
  sideDisplay(_INTL("You used a Potion too recently."),true,-9)
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

theitem = GameData::Item.get(item).id
case theitem
 when :WEAKPOTION
   increaseHealth(10)
   $bag.remove(item)
 when :POTION
   increaseHealth(20)
   $bag.remove(item)
 when :SUPERPOTION
   increaseHealth(40)
   $bag.remove(item)
 when :HYPERPOTION
   increaseHealth(60)
   $bag.remove(item)
 when :FULLRESTORE
   amt = $player.playermaxhealth2-$player.playerhealth
   increaseHealth(amt)
   $player.status = :NONE if $player.status!=:NONE
   $player.healthiness = 100
   $bag.remove(item)
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
return "HI THERE"
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


def increaseStamina(amount)
 amount = amount.to_f 
 $player.playerstamina = $player.playerstamina.to_f if $player.playerstamina.is_a? Integer
 amount/=1.5 if $player.is_it_this_class?(:TRIATHLETE)
 ret = true 
 $player.playerstamina = [$player.playerstamina+amount, $player.playermaxstamina].min
 return ret 
end

def decreaseStamina(amount)
 amount = amount.to_f 
 $player.playerstamina = $player.playerstamina.to_f if $player.playerstamina.is_a? Integer
 amount/=1.5 if $player.is_it_this_class?(:TRIATHLETE)
 ret = true 
 ret = false if $player.playerstamina<=0
 $player.playerstamina = [$player.playerstamina-amount, 0.0].max
 return ret 
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

def totalhp
$player.playermaxhealth2
end 
def hp
$player.playerhealth
end 
def hp=(value)
$player.playerhealth=value
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

  #ADD EVS
  def pbPlayerEXP(caughtmon,pkmnless=[])
    $player.playerclasslevel = 1 if $player.playerclasslevel == 0

    exp = (caughtmon.level * caughtmon.base_exp) / 2
    exp /= 7
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    exp_final = ($player.exp + exp).clamp(0, $player.get_max_exp)
    exp_gained = exp_final - $player.exp
    puts "expGained: #{exp_gained}"
	new_level = $player.playerclasslevel
	
  if exp_gained > 0
    cur_level = $player.playerclasslevel
    new_level = $player.level_from_exp(exp_final)

    if new_level > cur_level
      loop do
        cur_level += 1
        level_max_exp = $player.maximum_exp_for_level(cur_level)
        temp_exp2 = [level_max_exp, exp_final].min
        puts temp_exp2

        $player.exp = temp_exp2
        pbSEPlay("Pkmn exp gain")

        break if cur_level >= new_level
      end

      sideDisplay(_INTL("#{$player.name} leveled up to #{new_level}!")) if $player.playerclasslevel != new_level
    end
  end

  $player.exp = exp_final
  $player.playerclasslevel = new_level

  if !pkmnless.empty?
    pkmnless.compact!
    pkmnless = pkmnless.uniq { |person| person.pokemon.personalID }
  end

  pkmnless.each do |pokemon_event|
    pokemon = pokemon_event.pokemon
    pokemon.gain_ev(caughtmon)
    pokemon.gain_exp_from_overworld(caughtmon)
  end
  end

  def pbPlayerEXPPassive(exp)
    $player.playerclasslevel = 1 if $player.playerclasslevel == 0
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    exp_final = ($player.exp + exp).clamp(0, $player.get_max_exp)
    exp_gained = exp_final - $player.exp
    puts "expGained: #{exp_gained}"
	new_level = $player.playerclasslevel
	
  if exp_gained > 0
    cur_level = $player.playerclasslevel
    new_level = $player.level_from_exp(exp_final)

    if new_level > cur_level
      loop do
        cur_level += 1
        level_max_exp = $player.maximum_exp_for_level(cur_level)
        temp_exp2 = [level_max_exp, exp_final].min
        puts temp_exp2

        $player.exp = temp_exp2
        pbSEPlay("Pkmn exp gain")

        break if cur_level >= new_level
      end

      sideDisplay(_INTL("#{$player.name} leveled up to #{new_level}!")) if $player.playerclasslevel != new_level
    end
  end

  $player.exp = exp_final
  $player.playerclasslevel = new_level
  end


