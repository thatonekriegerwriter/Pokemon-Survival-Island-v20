class Game_Player < Game_Character
  attr_accessor :youarealreadydead
  
  def youarealreadydead
   @youarealreadydead=false if @youarealreadydead.nil?
   return @youarealreadydead   
  end
end


#===============================================================================
# Core Combat Functions
#===============================================================================


class OverworldCombat
  attr_accessor :participants           
  attr_accessor :turn           
  attr_accessor :battle_rules           
  attr_accessor :currentlyinbattle           
  attr_accessor :change_move_direction           
  attr_accessor :target           
  attr_accessor :track           
  attr_accessor :opponent              
  attr_accessor :controlled           
  attr_accessor :other_participants           
  attr_accessor :pokemona           
  attr_accessor :hard_hitting         
  attr_accessor :youarealreadydead         
 #
#when 2 then event.move_down
#when 4 then event.move_left
#when 6 then event.move_right
#when 8 then event.move_up
   def initialize(opponent=nil)
	  @participants = []
	  @turn = 0
	  @battle_rules = []
	  @currentlyinbattle = false
	  @change_move_direction = false
	  @pokemona= nil
	  @hard_hitting= 0
	  @track = []
	  @participants = initializeParticipants
	  @youarealreadydead = false
	  @controlled = @participants[:PLAYER]
	  @track = []
	  @backattack = nil
	  @sideattack = nil
	  @baddir = nil
   end
   
def initializeParticipants
    return {
	  :PLAYER => $game_player,
	  :ENEMIES => {},
	  :ALLIES => {}
			}
end

def full_participants_array
  parti = []
  parti << getParticipants(:PLAYER)
  enemies = getParticipants(:ENEMIES)
  enemies.each do |key, value|
  parti << value
    
  end
  allies = getParticipants(:ALLIES)
  allies.each do |key, value|
  parti << value
  end
return parti
end

def getParticipantLength(type)
   return @participants[type].keys.length
end

def getParticipant(type)
   return @participants[type].keys
end

def getParticipants(type)
   return @participants[type]
end


  def unstoppableAbility?(abil = nil)
    abil = @ability_id if !abil
    abil = GameData::Ability.try_get(abil)
    return false if !abil
    ability_blacklist = [
      # Form-changing abilities
      :BATTLEBOND,
      :DISGUISE,
#      :FLOWERGIFT,                                        # This can be stopped
#      :FORECAST,                                          # This can be stopped
      :GULPMISSILE,
      :ICEFACE,
      :MULTITYPE,
      :POWERCONSTRUCT,
      :SCHOOLING,
      :SHIELDSDOWN,
      :STANCECHANGE,
      :ZENMODE,
      # Abilities intended to be inherent properties of a certain species
      :ASONECHILLINGNEIGH,
      :ASONEGRIMNEIGH,
      :COMATOSE,
      :RKSSYSTEM
    ]
    return ability_blacklist.include?(abil.id)
  end

  def pbInitEffects(battler,batonPass=false)
    if batonPass
      # These effects are passed on if Baton Pass is used, but they need to be
      # reapplied
      battler.effects[PBEffects::LaserFocus] = (battler.effects[PBEffects::LaserFocus] > 0) ? 2 : 0
      battler.effects[PBEffects::LockOn]     = (battler.effects[PBEffects::LockOn] > 0) ? 2 : 0
      if battler.effects[PBEffects::PowerTrick]
        battler.attack, battler.defense = battler.defense, battler.attack
      end
      # These effects are passed on if Baton Pass is used, but they need to be
      # cancelled in certain circumstances anyway
      battler.effects[PBEffects::Telekinesis] = 0 if battler.isSpecies?(:GENGAR) && battler.mega?
      battler.effects[PBEffects::GastroAcid]  = false if unstoppableAbility?(battler.ability)
    else
      # These effects are passed on if Baton Pass is used
      #GameData::Stat.each { |stat| @stages[stat.id] = 0 }
      battler.effects[PBEffects::AquaRing]          = false
      battler.effects[PBEffects::Confusion]         = 0
      battler.effects[PBEffects::Curse]             = false
      battler.effects[PBEffects::Embargo]           = 0
      battler.effects[PBEffects::FocusEnergy]       = 0
      battler.effects[PBEffects::GastroAcid]        = false
      battler.effects[PBEffects::HealBlock]         = 0
      battler.effects[PBEffects::Ingrain]           = false
      battler.effects[PBEffects::LaserFocus]        = 0
      battler.effects[PBEffects::LeechSeed]         = -1
      battler.effects[PBEffects::LockOn]            = 0
      battler.effects[PBEffects::LockOnPos]         = -1
      battler.effects[PBEffects::MagnetRise]        = 0
      battler.effects[PBEffects::PerishSong]        = 0
      battler.effects[PBEffects::PerishSongUser]    = -1
      battler.effects[PBEffects::PowerTrick]        = false
      battler.effects[PBEffects::Substitute]        = 0
      battler.effects[PBEffects::Telekinesis]       = 0
    end
    battler.effects[PBEffects::Attract]             = -1
	
	
    battler.effects[PBEffects::BanefulBunker]       = false
    battler.effects[PBEffects::BeakBlast]           = false
    battler.effects[PBEffects::Bide]                = 0
    battler.effects[PBEffects::BideDamage]          = 0
    battler.effects[PBEffects::BideTarget]          = -1
    battler.effects[PBEffects::BurnUp]              = false
    battler.effects[PBEffects::Charge]              = 0
    battler.effects[PBEffects::ChoiceBand]          = nil
    battler.effects[PBEffects::Counter]             = -1
    battler.effects[PBEffects::CounterTarget]       = -1
    battler.effects[PBEffects::Dancer]              = false
    battler.effects[PBEffects::DefenseCurl]         = false
    battler.effects[PBEffects::DestinyBond]         = false
    battler.effects[PBEffects::DestinyBondPrevious] = false
    battler.effects[PBEffects::DestinyBondTarget]   = -1
    battler.effects[PBEffects::Disable]             = 0
    battler.effects[PBEffects::DisableMove]         = nil
    battler.effects[PBEffects::Electrify]           = false
    battler.effects[PBEffects::Encore]              = 0
    battler.effects[PBEffects::EncoreMove]          = nil
    battler.effects[PBEffects::Endure]              = false
    battler.effects[PBEffects::FirstPledge]         = nil
    battler.effects[PBEffects::FlashFire]           = false
    battler.effects[PBEffects::Flinch]              = false
    battler.effects[PBEffects::FocusPunch]          = false
    battler.effects[PBEffects::FollowMe]            = 0
    battler.effects[PBEffects::Foresight]           = false
    battler.effects[PBEffects::FuryCutter]          = 0
    battler.effects[PBEffects::GemConsumed]         = nil
    battler.effects[PBEffects::Grudge]              = false
    battler.effects[PBEffects::HelpingHand]         = false
    battler.effects[PBEffects::HyperBeam]           = 0
    battler.effects[PBEffects::Illusion]            = nil
    #if hasActiveAbility?(:ILLUSION)
    #  idxLastParty = @battle.pbLastInTeam(@index)
    #  if idxLastParty >= 0 && idxLastParty != @pokemonIndex
    #    battler.effects[PBEffects::Illusion]        = @battle.pbParty(@index)[idxLastParty]
    #  end
    #end
    battler.effects[PBEffects::Imprison]            = false
    battler.effects[PBEffects::Instruct]            = false
    battler.effects[PBEffects::Instructed]          = false
    battler.effects[PBEffects::JawLock]             = -1
    battler.effects[PBEffects::KingsShield]         = false
    battler.effects[PBEffects::LockOn]    = 0
    battler.effects[PBEffects::LockOnPos] = -1
    battler.effects[PBEffects::MagicBounce]         = false
    battler.effects[PBEffects::MagicCoat]           = false
    battler.effects[PBEffects::MeanLook]            = -1
    battler.effects[PBEffects::MeFirst]             = false
    battler.effects[PBEffects::Metronome]           = 0
    battler.effects[PBEffects::MicleBerry]          = false
    battler.effects[PBEffects::Minimize]            = false
    battler.effects[PBEffects::MiracleEye]          = false
    battler.effects[PBEffects::MirrorCoat]          = -1
    battler.effects[PBEffects::MirrorCoatTarget]    = -1
    battler.effects[PBEffects::MoveNext]            = false
    battler.effects[PBEffects::MudSport]            = false
    battler.effects[PBEffects::Nightmare]           = false
    battler.effects[PBEffects::NoRetreat]           = false
    battler.effects[PBEffects::Obstruct]            = false
    battler.effects[PBEffects::Octolock]            = -1
    battler.effects[PBEffects::Outrage]             = 0
    battler.effects[PBEffects::ParentalBond]        = 0
    battler.effects[PBEffects::PickupItem]          = nil
    battler.effects[PBEffects::PickupUse]           = 0
    battler.effects[PBEffects::Pinch]               = false
    battler.effects[PBEffects::Powder]              = false
    battler.effects[PBEffects::Prankster]           = false
    battler.effects[PBEffects::PriorityAbility]     = false
    battler.effects[PBEffects::PriorityItem]        = false
    battler.effects[PBEffects::Protect]             = false
    battler.effects[PBEffects::ProtectRate]         = 1
    battler.effects[PBEffects::Quash]               = 0
    battler.effects[PBEffects::Rage]                = false
    battler.effects[PBEffects::RagePowder]          = false
    battler.effects[PBEffects::Rollout]             = 0
    battler.effects[PBEffects::Roost]               = false
    battler.effects[PBEffects::SkyDrop]             = -1
    battler.effects[PBEffects::SlowStart]           = 0
    battler.effects[PBEffects::SmackDown]           = false
    battler.effects[PBEffects::Snatch]              = 0
    battler.effects[PBEffects::SpikyShield]         = false
    battler.effects[PBEffects::Spotlight]           = 0
    battler.effects[PBEffects::Stockpile]           = 0
    battler.effects[PBEffects::StockpileDef]        = 0
    battler.effects[PBEffects::StockpileSpDef]      = 0
    battler.effects[PBEffects::TarShot]             = false
    battler.effects[PBEffects::Taunt]               = 0
    battler.effects[PBEffects::ThroatChop]          = 0
    battler.effects[PBEffects::Torment]             = false
    battler.effects[PBEffects::Toxic]               = 0
    battler.effects[PBEffects::Transform]           = false
    battler.effects[PBEffects::TransformSpecies]    = nil
    battler.effects[PBEffects::Trapping]            = 0
    battler.effects[PBEffects::TrappingMove]        = nil
    battler.effects[PBEffects::TrappingUser]        = -1
    battler.effects[PBEffects::Truant]              = false
    battler.effects[PBEffects::TwoTurnAttack]       = nil
    battler.effects[PBEffects::Type3]               = nil
    battler.effects[PBEffects::Unburden]            = false
    battler.effects[PBEffects::Uproar]              = 0
    battler.effects[PBEffects::WaterSport]          = false
    battler.effects[PBEffects::WeightChange]        = 0
    battler.effects[PBEffects::Yawn]                = 0
  end




def getTracks(opponent)
	return [[10,7],[10,27]] if opponent.pokemon.species == :STEELIX && opponent.pokemon.form == 2
end


def hasAlly?(key,value)
   if getParticipant(:ALLIES).include?(key)
	  if @participants[:ALLIES][key] == value
	      return true
	  end
   end
  return false
end

def addAlly(key,value)
  return false if @battle_rules.include?("Only-One-Mon") && getParticipantLength(:ALLIES)==1
   if !getParticipant(:ALLIES).include?(key)
	  @participants[:ALLIES][key] = value
	  return true
   end

  return false
end


def hasEnemy?(key,value)
   if getParticipant(:ENEMIES).include?(key)
	  if @participants[:ENEMIES][key] == value
	      return true
	  end
   end
  return false
end

def addEnemy(key,value)
   if !getParticipant(:ENEMIES).include?(key)
	  @participants[:ENEMIES][key] = value
	  return true
   end
  return false
end

def removeAlly(key)
  return getParticipantLength(:ALLIES)==0
   if getParticipant(:ALLIES).include?(key)
	  @participants[:ALLIES][key] = value
	  return true
   end

  return false
end

def removeEnemy(key)
  return getParticipantLength(:ENEMIES)==0
   if getParticipant(:ENEMIES).include?(key)
	  @participants[:ENEMIES].delete(key)
	  return true
   end
  return false
end


def add_rule(rule)
 if @battle_rules.include?(rule)
 else
 @battle_rules << rule
 end
end


def physics_update

end

def any_enemies?
  return @participants[:ENEMIES].keys.length>0
end
def any_allies?
  return @participants[:ALLIES].keys.length>0
end
def get_player_and_allies
  potato = []
  potato << @participants[:PLAYER] 
  @participants[:ALLIES].each_value do |value|
     potato << value
  end
  return potato
end
def controlled_pokemon?
  return @participants[:PLAYER].pokemon.is_a?(Pokemon)
end

def get_distance(unit)
 distances = []
    targets = get_player_and_allies
	targets.compact!
	 targets.each do |event|
	 distances << pbDetectTargetPokemon(unit,event)
	 end
     minimum = distances.min
     max_index = distances.index(minimum)
     target = targets[max_index]
     distance = distances[max_index]

 
  return target,distance
end

def get_overworld_pokemon
$player.party.each_with_index do |pkmn,index|
 next if $game_temp.current_pkmn_controlled !=false && index==0
 next if $game_temp.current_pkmn_controlled !=false && index>2
 next if pkmn.inworld==false
 next if pkmn.associatedevent.nil?
 addAlly(pkmn.associatedevent,$game_map.events[pkmn.associatedevent])
end
end






  def fainted_check(event)
    pkmn = event.pokemon
    if pkmn.fainted?
	 $PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false && event.is_a?(Game_PokeEvent)
     event.removeThisEventfromMap
	 if @youarealreadydead==false
     pbPlayerEXP(pkmn) 
     pbHeldItemDropOW(pkmn,true)
     if $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
         pbBGMFade(0.8)
        $game_system.bgm_pause
       $game_system.bgm_position = $game_temp.memorized_bgm_position
       $game_system.bgm_resume($game_temp.memorized_bgm)
		$game_temp.memorized_bgm = nil
		$game_temp.memorized_bgm_position = nil
	 end
	 
     @youarealreadydead=true
	 
	 end
	 return true
	else
	 return false
	end
  
  end


end





def get_target_player(source)

event, distance = pbDetectTarget(source,false)
if !event.nil?
if event.is_a? Array
 return nil
end
return event, distance
else
return nil
end
end


def makeUnparalyzed(event)
#event.event.move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
end
def makeParalyzed(event)
return if $game_temp.bossfight==true
#event.event.move_frequency = event.move_frequency-1 if event.move_frequency>1
end
def makeSleep(event)
return if $game_temp.bossfight==true
event.movement_type = :IMMOBILE 
end
def makeFrozen(event)
return if $game_temp.bossfight==true
event.movement_type = :IMMOBILE 
end
def cureStatus(event)
#event.event.move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
end




def makeAggressive(event,target=$game_player)
makeAggressiveAtPokemon(event,target)
end

def makeExtraAggressive(event)
 makeAggressive(event)
end

def makeUnaggressive(event,requester)
return if $game_temp.bossfight==true
return if (event.pokemon.status == :SLEEP || event.pokemon.status == :FROZEN)
event.angry_at.delete(requester)
if event.angry_at.empty?
event.pokemon.aggressive=false
event.pokemon.chasing = false 
event.movement_type = :WANDER 
end
end


def makeAggressiveAtPokemon(event,target)
return if $game_temp.bossfight==true
return if (event.pokemon.status == :SLEEP || event.pokemon.status == :FROZEN)
event.pokemon.aggressive=true
event.pokemon.chasing = true 
event.movement_type = :CHASE 
event.angry_at << target if !event.angry_at.include?(target)

$scene.spriteset.addUserAnimation(VisibleEncounterSettings::AGG_ANIMATIONS[0],event.x,event.y,true,1)




end

  
EventHandlers.add(:on_step_taken, :overworldpkmnpoison,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
	next if !event.is_a?(Game_PokeEvent) && !event.is_a?(Game_PokeEventA)
	next if !event.pokemon.is_a?(Pokemon)
	pkmn=event.pokemon
	   if pkmn.status==:SLEEP && $game_temp.bossfight!=true
        event.movement_type = :IMMOBILE if event.movement_type != :IMMOBILE
	   end
	   if pkmn.status==:FROZEN && $game_temp.bossfight!=true
        event.movement_type = :IMMOBILE if event.movement_type != :IMMOBILE
	   end
		if pkmn.status==:BURN && event.steps_taken % 4 == 0
		  dmg = (Settings::MECHANICS_GENERATION >= 7) ? pkmn.totalhp / 16 : pkmn.totalhp / 8
          dmg = (dmg / 2.0).round if pkmn.hasAbility?(:HEATPROOF)
	   if event.is_a?(Game_PokeEventA)
        pkmn.changeHappiness("damaged",pkmn)
        pkmn.changeLoyalty("damaged",pkmn)
		end
		 if pkmn.hp-dmg>1
		  pkmn.hp-=dmg
		 end
		end
		if pkmn.status==:POISON && event.steps_taken % 4 == 0
    flashed = false
      if !flashed && event.is_a?(Game_PokeEventA)
        pbFlash(Color.new(255, 0, 0, 128), 8)
        flashed = true
	     pbSEPlay("SFX_POISONED")
      end
	   if event.is_a?(Game_PokeEventA)
        pkmn.changeHappiness("damaged",pkmn)
        pkmn.changeLoyalty("damaged",pkmn)
		end
		dmg = 1
		  pkmn.hp-=dmg
		 
      if pkmn.hp > 0 && rand(100)<1
        pkmn.status = :NONE
        sideDisplay(_INTL("{1} survived the poisoning.\\nThe poison faded away!\1", pkmn.name)) if event.is_a?(Game_PokeEventA)
      else
		  if pkmn.fainted? && event.is_a?(Game_PokeEvent)
		  $PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false
        event.removeThisEventfromMap
        pbPlayerEXP(pkmn)
        pbHeldItemDropOW(pkmn,true)
		  end
		  
		  if pkmn.fainted? && event.is_a?(Game_PokeEventA)
		  
        pkmn.changeHappiness("faint",pkmn)
        pkmn.status = :NONE
	    sideDisplay("#{pkmn.name} fainted from poison!")
        event.removeThisEventfromMap
		  
		  end
      end
		end

  }
)