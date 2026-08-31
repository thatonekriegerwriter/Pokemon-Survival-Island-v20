class Game_Player < Game_Character
  attr_accessor :youarealreadydead
  
  def youarealreadydead
   @youarealreadydead=false if @youarealreadydead.nil?
   return @youarealreadydead   
  end
end

def pbGetTargetInDirection(unit, direction, target)
   raise unit if unit.is_a?(Integer)
   amt = OverworldCombat.sight_line(unit)
   px, py = unit.x, unit.y
  (1..amt).each do |i|
    landing_coord = case direction
    when 2 then [px, py + i]
    when 4 then [px - i, py]
    when 6 then [px + i, py]
    when 8 then [px, py - i]
    end
	
	
    return i if target.x == landing_coord[0] && target.y == landing_coord[1]
  end
   return nil
end

def pbDetectTargetPokemon(source,target=$game_player)
  potato=false
  carrot=0
  amt = OverworldCombat.sight_line(source)
  amt.times do |i|
  start_coord=[source.x,source.y]
  landing_coord=[source.x,source.y]
  case source.direction
  when 2; landing_coord[1]+=i+1
  when 4; landing_coord[0]-=i+1
  when 6; landing_coord[0]+=i+1
  when 8; landing_coord[1]-=i+1
  end
   if !target.nil?
	if target.x==landing_coord[0] && target.y==landing_coord[1]
      carrot=i+1
	end
   end
  end


  return carrot
end
class OverworldCombat
end
class OverworldCombat::ActiveState
  attr_reader :effects
  attr_accessor :defaultTerrain
  attr_accessor :terrain
  attr_accessor :terrainDuration
  def initialize
    @effects = {}
  end 
  
  def init_effects
    #Active Field
    @effects[:AmuletCoin]      = false
    @effects[:FairyLock]       = 0
    @effects[:FusionBolt]      = false
    @effects[:FusionFlare]     = false
    @effects[:Gravity]         = 0
    @effects[:HappyHour]       = false
    @effects[:IonDeluge]       = false
    @effects[:MagicRoom]       = 0
    @effects[:MudSportField]   = 0
    @effects[:PayDay]          = 0
    @effects[:TrickRoom]       = 0
    @effects[:WaterSportField] = 0
    @effects[:WonderRoom]      = 0
    #Active Position
    @effects[:FutureSightCounter]        = 0
    @effects[:FutureSightMove]           = nil
    @effects[:FutureSightUserIndex]      = -1
    @effects[:FutureSightUserPartyIndex] = -1
    @effects[:HealingWish]               = false
    @effects[:LunarDance]                = false
    @effects[:Wish]                      = 0
    @effects[:WishAmount]                = 0
    @effects[:WishMaker]                 = -1
	
	#Active Side 
    @effects[:AuroraVeil]                = 0
    @effects[:CraftyShield]              = false
    @effects[:EchoedVoiceCounter]        = 0
    @effects[:EchoedVoiceUsed]           = false
    @effects[:LastRoundFainted]          = -1
    @effects[:LightScreen]               = 0
    @effects[:LuckyChant]                = 0
    @effects[:MatBlock]                  = false
    @effects[:Mist]                      = 0
    @effects[:QuickGuard]                = false
    @effects[:Rainbow]                   = 0
    @effects[:Reflect]                   = 0
    @effects[:Round]                     = false
    @effects[:Safeguard]                 = 0
    @effects[:SeaOfFire]                 = 0
    @effects[:Spikes]                    = 0
    @effects[:StealthRock]               = false
    @effects[:StickyWeb]                 = false
    @effects[:Swamp]                     = 0
    @effects[:Tailwind]                  = 0
    @effects[:ToxicSpikes]               = 0
    @effects[:WideGuard]                 = false
    @defaultTerrain  = :None
    @terrain         = :None
    @terrainDuration = 0
  end 
  
  
  def [](key)
    @effects[key]
  end

  def []=(key, value)
    @effects[key] = value
  end

end 
class OverworldCombat::DamageState
  attr_accessor :typeMod         # Type effectiveness
  attr_accessor :unaffected
  attr_accessor :protected
  attr_accessor :magicCoat
  attr_accessor :magicBounce
  attr_accessor :totalHPLost     # Like hpLost, but cumulative over all hits
  attr_accessor :fainted         # Whether battler was knocked out by the move

  attr_accessor :missed          # Whether the move failed the accuracy check
  attr_accessor :affection_missed
  attr_accessor :invulnerable    # If the move missed due to two turn move invulnerability
  attr_accessor :calcDamage      # Calculated damage
  attr_accessor :hpLost          # HP lost by opponent, inc. HP lost by a substitute
  attr_accessor :critical        # Critical hit flag
  attr_accessor :affection_critical
  attr_accessor :substitute      # Whether a substitute took the damage
  attr_accessor :focusBand       # Focus Band used
  attr_accessor :focusSash       # Focus Sash used
  attr_accessor :sturdy          # Sturdy ability used
  attr_accessor :disguise        # Disguise ability used
  attr_accessor :iceFace         # Ice Face ability used
  attr_accessor :endured         # Damage was endured
  attr_accessor :affection_endured
  attr_accessor :berryWeakened   # Whether a type-resisting berry was used

  def initialize; reset; end

  def reset
    @typeMod          = Effectiveness::INEFFECTIVE
    @unaffected       = false
    @protected        = false
    @missed           = false
    @affection_missed = false
    @invulnerable     = false
    @magicCoat        = false
    @magicBounce      = false
    @totalHPLost      = 0
    @fainted          = false
    resetPerHit
  end

  def resetPerHit
    @calcDamage         = 0
    @hpLost             = 0
    @critical           = false
    @affection_critical = false
    @substitute         = false
    @focusBand          = false
    @focusSash          = false
    @sturdy             = false
    @disguise           = false
    @iceFace            = false
    @endured            = false
    @affection_endured  = false
    @berryWeakened      = false
  end


end 
class OverworldCombat::PokemonActiveState
    def initialize; reset; end
    def reset
      @lastAttacker          = []
      @lastFoeAttacker       = []
      @lastHPLost            = 0
      @lastHPLostFromFoe     = 0
      @droppedBelowHalfHP    = false
      @statsDropped          = false
      @tookDamageThisRound   = false
      @tookPhysicalHit       = false
      @statsRaisedThisRound  = false
      @statsLoweredThisRound = false
      @canRestoreIceFace     = false
      @lastMoveUsed          = nil
      @lastMoveUsedType      = nil
      @lastRegularMoveUsed   = nil
      @lastRegularMoveTarget = -1
      @lastRoundMoved        = -1
      @lastMoveFailed        = false
      @lastRoundMoveFailed   = false
      @movesUsed             = []
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
  attr_reader :active_state
  attr_reader :damage_state
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
	  @active_state = ActiveState.new
	  @damage_state = DamageState.new
   end
   def active_state 
	@active_state = ActiveState.new if @active_state.nil?
    return @active_state
   end
   def damage_state 
	@damage_state = DamageState.new if @damage_state.nil?
    return @damage_state
   end
   def self.update_package
     Graphics.update           # Updates the screen and game visuals
     Input.update              # Checks for player input
     $scene.update
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
	  @participants[:ALLIES].delete(key)
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
def remove_rule(rule)
 if @battle_rules.include?(rule)
 @battle_rules.delete(rule)
 end
end

def reset_rules
 @battle_rules = []
end

def pbEndOverworldBattle
  return_normal_bgm
  
 return if $game_temp.in_temple==true
 return if @participants[:ENEMIES].keys.length>0
   reset_rules
end

def physics_update

end

def get_enemies
getParticipants(:ENEMIES).values.select do |event|
    next false if event.map_id != $game_map.map_id

end 

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
  $player.party.each do |pkmn|
    next unless pkmn.associatedevent
	event = $game_map.events[pkmn.associatedevent]
	next if event.map_id!=$game_map.map_id 
	addAlly(pkmn.associatedevent, event)
  end 
  @participants[:ALLIES].delete_if { |key, value| value.pokemon.associatedevent.nil? && value.pokemon.inworld==false }
  @participants[:ALLIES].each_value do |value|
     next if value.pokemon.associatedevent.nil? && value.pokemon.inworld==false
	 next if value.map_id != $game_map.map_id 
     potato << value
  end
  return potato
end

def angry_at_here(attacker)
  attacker.angry_at.select do |event|
    next false if event.map_id != $game_map.map_id
  end
end 

def nearby_hostile_events(attacker)
  events = $DynamicEvents.hostile_mobs.values

  results = events.select do |event|
    next false if event == attacker
    next false if event.map_id != $game_map.map_id
	next false if attacker.is_a?(Game_PokeEvent) && angry_at_here(attacker).include?(event)
    #next false if pbOverworldCombat.hasEnemy?(event.id, event)
    
    OverworldCombat.within_range?(attacker, event, nil, OverworldCombat.sight_line(attacker))
  end
  #puts results.to_s
  return results 
end

def get_allies
  potato = []
  @participants[:ALLIES].delete_if { |key, value| value.pokemon.inworld == false }
  @participants[:ALLIES].each_value do |value|
     potato << value
  end
  return potato
end
def get_allied_pokemon
  potato = []
  get_allies.each do |event|
     potato << event.pokemon
  end

end
def controlled_pokemon?
  return @participants[:PLAYER].pokemon.is_a?(Pokemon)
end
def turn_left(direction)
  case direction
  when 2 then 4
  when 4 then 8
  when 6 then 2
  when 8 then 6
  end
end

def turn_right(direction)
  case direction
  when 2 then 6
  when 4 then 2
  when 6 then 8
  when 8 then 4
  end
end
  def self.player_side?(unit)
    unit.is_a?(Game_PokeEventA) || unit == $game_player
  end

def get_distance(unit)
    distances = []
	considered_targets = []
    directions_needed = []
    targets = get_player_and_allies + unit.angry_at
	targets.compact!
	targets.uniq!
	  min_distance = nil
      best_dir = nil
	targets.each do |event|
	  directions_to_check = [unit.direction, turn_left(unit.direction), turn_right(unit.direction)]
	  directions_to_check.each do |dir|
	   amt = pbGetTargetInDirection(unit,dir,event)
       if amt && amt > 0
	     if min_distance.nil? || amt < min_distance
          min_distance = amt
		  best_dir = dir
		 end
       end
      if min_distance
        distances << min_distance
        considered_targets << event
        directions_needed << best_dir
      end
	  end 
	end
	return nil, nil, nil if distances.empty?
	min_dist = distances.min
	index = distances.index(min_dist)
	target = considered_targets[index]
    needed_direction = directions_needed[index]
	return target, min_dist, needed_direction
end

def tiles_in_cone(unit, max_range)
  px, py = unit.x, unit.y
  tiles = []

  (1..max_range).each do |i|
    case unit.direction
    when 2  # down
      tiles << [px, py+i]            # center
      tiles << [px-1, py+i]          # left
      tiles << [px+1, py+i]          # right
    when 4  # left
      tiles << [px-i, py]            # center
      tiles << [px-i, py-1]          # up
      tiles << [px-i, py+1]          # down
    when 6  # right
      tiles << [px+i, py]            # center
      tiles << [px+i, py-1]          # up
      tiles << [px+i, py+1]          # down
    when 8  # up
      tiles << [px, py-i]            # center
      tiles << [px-1, py-i]          # left
      tiles << [px+1, py-i]          # right
    end
  end

  tiles
end
def manhattan_distance(a,b)
  (a.x - b.x).abs + (a.y - b.y).abs
end

def get_distance_alt(unit)
  targets = get_player_and_allies + unit.angry_at
  targets.compact!
  targets.uniq!
  max_range = amt = OverworldCombat.sight_line(unit)
  cone_tiles = tiles_in_cone(unit, max_range)
  targets.compact.uniq!

  visible = []

  cone_tiles.each_with_index do |(tx, ty), idx|
    targets.each do |target|
      next if target.x != tx || target.y != ty
      # Priority: center tiles first, then left/righ
      priority = idx % 3 == 0 ? 1 : 2
      distance = manhattan_distance(unit, target)
      visible << [target, distance, priority]
    end
  end

  return nil, nil if visible.empty?

  visible.sort_by! { |target,distance,priority| [priority, distance] }

  target, distance, _ = visible.first
  return target, distance
end
 
 def in_battle?(unit)
    optionsa = get_enemies
    optionsb = nearby_hostile_events(unit).uniq
    options = optionsa + optionsb
    return options.length>0
 end 

 def foe(unit)
   if OverworldCombat.player_side?(unit)
    options = get_enemies + nearby_hostile_events(unit).uniq
	puts options.to_s
    return options
   else
    return get_player_and_allies + angry_at_here(unit).uniq
   end 
 
 end 
 
 def ally(unit)
   if OverworldCombat.player_side?(unit)
    return get_player_and_allies + angry_at_here(unit).uniq
   else
    return get_enemies + nearby_hostile_events(unit).uniq
   end 
 end 
def other_allies(unit)
  ally(unit).reject { |target| target == unit }
end
 def user(unit)
   return [unit]
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






  def self.fainted_check(event)
    return if event == $game_player
    pkmn = event.pokemon
    if pkmn.fainted?
	 if event.is_a?(Game_PokeEvent)
	 $PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false 
     EventHandlers.trigger(:on_wild_ovbattle_end, pkmn, pkmn.level, 1)
     pbPlayerEXP(pkmn,$player.party_in_world) 
     pbHeldItemDropOW(pkmn,true)
	 pbOverworldCombat.removeEnemy(event.id)
	 elsif  event.is_a?(Game_PokeEventA)
	 pbOverworldCombat.removeAlly(event.id)
	 end 
     event.removeThisEventfromMap
	 return true
	else
	 return false
	end
  
  end


end


EventHandlers.add(:on_map_transfer, :clear_state,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next unless pbOverworldCombat.any_enemies?
	pbOverworldCombat.participants[:ENEMIES] = {}
}
)






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
        pbPlayerEXP(pkmn,$player.party_in_world)
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