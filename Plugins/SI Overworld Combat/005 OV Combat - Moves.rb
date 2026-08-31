#===============================================================================
# Move Calculations
#===============================================================================



class Pokemon
  
  def statStageAtMax?(stat)
     @stages[stat] >= 6
  end 
  
  def statStageAtMin?(stat)
     @stages[stat] <= -6
  end 
  
  def can_raise_stat_stage?(stat, user = nil, move = nil, failMessage = true, ignoreContrary = false)
      return false if fainted?
	  if self.hasAbility?(:CONTRARY) && !ignoreContrary && user && !user.hasAbility?(:MOLDBREAKER)
	    return can_lower_stat_stage?(stat, user, move, failMessage, true)
	  end 
	  if statStageAtMax?(stat)
	    if failMessage
		  sideDisplay(_INTL("{1}'s {2} won't go any higher!", @name, GameData::Stat.get(stat).name))
		end 
        return false
	  end 
      return true
  end 
  
  def can_lower_stat_stage?(stat, user = nil, move = nil, failMessage = true, ignoreContrary = false, ignoreMirrorArmor = false)
      return false if fainted?
      if user && !user.hasAbility?(:MOLDBREAKER)
	   if self.hasAbility?(:CONTRARY) && !ignoreContrary && user && !user.hasAbility?(:MOLDBREAKER)
	     return can_raise_stat_stage?(stat, user, move, failMessage, true)
	   end 
	   if self.hasAbility?(:MIRRORARMOR) && !ignoreMirrorArmor && user != self && !statStageAtMin?(stat)
	     return true
	   end 
	  end 
      if user && user!=self
	    
	  
	  end 
      if statStageAtMin?(stat)
        if failMessage
	 	  sideDisplay(_INTL("{1}'s {2} won't go any lower!", @name, GameData::Stat.get(stat).name))
        end
        return false
      end
      return true

  end 
  
  def raise_stat_stage_basic(stat, amt, user = nil, ignoreContrary = false)
    if user && !user.hasAbility?(:MOLDBREAKER)
	  if self.hasAbility?(:CONTRARY) && !ignoreContrary
	    return lower_stat_stage_basic(stat, amt, user, true)
	  end 
	  amt *= 2 if self.hasAbility?(:SIMPLE)
	end 
    amt = [amt, 6 - @stages[stat]].min
	if amt > 0
      stat_name = GameData::Stat.get(stat).name
      new = @stages[stat] + amt
	  @stages[stat] += amt
	end 
	return amt
  
  end 

  
  def lower_stat_stage_basic(stat, amt, user = nil, ignoreContrary = false)
    if user && !user.hasAbility?(:MOLDBREAKER)
	  if self.hasAbility?(:CONTRARY) && !ignoreContrary
	    return raise_stat_stage_basic(stat, amt, user, true)
	  end 
	  amt *= 2 if self.hasAbility?(:SIMPLE)
	end 
    amt = [amt, 6 - @stages[stat]].min
	if amt > 0
      stat_name = GameData::Stat.get(stat).name
      new = @stages[stat] - amt
	  @stages[stat] -= amt
	end 
	return amt
  
  end 


  def lower_stat_stage(stat, amt, user = nil, ignoreContrary = false, ignoreMirrorArmor = false)
      if user && !user.hasAbility?(:MOLDBREAKER)
	   if self.hasAbility?(:CONTRARY) && !ignoreContrary && user && !user.hasAbility?(:MOLDBREAKER)
	     return raise_stat_stage(stat, amt, user, true)
	   end 
	   if self.hasAbility?(:MIRRORARMOR) && !ignoreMirrorArmor && user != self && !statStageAtMin?(stat)
	     ret = false
		 if user.can_lower_stat_stage?(stat, self, nil, true, ignoreContrary, true)
		   ret = user.lower_stat_stage(stat, amt, self, ignoreContrary, true)
		 end
		 return ret 
	   end 
	  end 
      amt = lower_stat_stage_basic(stat, amt, user, ignoreContrary)
	  return false if amt <= 0
    arrStatTexts = [
      _INTL("{1}'s {2} fell!", self.name, GameData::Stat.get(stat).name),
      _INTL("{1}'s {2} harshly fell!", self.name, GameData::Stat.get(stat).name),
      _INTL("{1}'s {2} severely fell!", self.name, GameData::Stat.get(stat).name)
    ]
	sideDisplay(arrStatTexts[[amt - 1, 2].min])
    move = self.moves.find { |m| m.id == :LASHOUT }
    move ||= self.moves2.find { |m| m.id == :LASHOUT }
	if move && move.pp > 0 
	   attacker = self.event
	  if user && user!=self
        target = user.event
	  else 
	    enemies = opponents_in_range(target, pbOverworldCombat.OverworldCombat.sight_line(attacker))
		target = enemies.sample
	  end 
	   if target
	   
	   sideDisplay(_INTL("{1} lashes out!", attacker.pokemon.name))
       attacker.attacking=true if defined?(attacker.cannot_move)
	   distance = (attacker.x - target.x).abs + (attacker.y - target.y).abs
	   result = attacker.use_reaction_move(target, move)
	   end 
	end 

    return true 
  end 
  def raise_stat_stage(stat, amt, user = nil , ignoreContrary = false)
	  if self.hasAbility?(:CONTRARY) && !ignoreContrary && user && !user.hasAbility?(:MOLDBREAKER)
	    return lower_stat_stage(stat, amt, user, true)
	  end 
      amt = raise_stat_stage_basic(stat, amt, user, ignoreContrary)
	  return false if amt <= 0
    arrStatTexts = [
      _INTL("{1}'s {2} rose!", @name, GameData::Stat.get(stat).name),
      _INTL("{1}'s {2} rose sharply!", @name, GameData::Stat.get(stat).name),
      _INTL("{1}'s {2} rose drastically!", @name, GameData::Stat.get(stat).name)
    ]
	sideDisplay(arrStatTexts[[amt - 1, 2].min])
	target = self.event
	enemies = opponents_in_range(target, 7)
	enemies.each do |attacker|
	   next if !attacker.pokemon.hasMove?(:BURNINGJEALOUSY) && !attacker.pokemon.hasMove2?(:BURNINGJEALOUSY)
       move = attacker.pokemon.moves.find { |m| m.id == :BURNINGJEALOUSY }
      if !move
        move = attacker.pokemon.moves2.find { |m| m.id == :BURNINGJEALOUSY }
      end
      next if !move
	   sideDisplay(_INTL("{1}'s eyes enflame with jealousy!", attacker.pokemon.name))
       attacker.attacking=true if defined?(attacker.cannot_move)
	   distance = (attacker.x - target.x).abs + (attacker.y - target.y).abs
	   result = attacker.use_reaction_move(target, move)
	end 
	
    return true
  
  end 
  
def opponents_in_range(event, distance)
  if event.is_a?(Game_PokeEventA)
    pbOverworldCombat.participants_in_range(:ENEMIES, event, distance)
  else
    pbOverworldCombat.participants_in_range(:ALLIES, event, distance)
  end
end
  
  
  def totalMoves
    @moves + @moves2
  end 
end 
class Substitute
  attr_accessor :hp
  attr_reader :totalhp
  attr_reader :move
  def initialize(move, hp = 20)
    @move = move
    @hp = hp
    @totalhp = hp
  end 

end 


class OverworldCombat::Scoring
def self.get_ov_damage_score(score,move,user,target,skill)
	 atk = OverworldCombat.pbGetAttackStat2(user,move)
    dmg = ((move.base_damage+atk)/2).floor
    if move.function_code == "AttackAndSkipNextTurn"
	  dmg *= 2 / 3
	end
    damagePercentage = dmg * 100.0 / target.hp if target.is_a?(Pokemon)
    damagePercentage = dmg * 100.0 / $player.playerhealth if !target.is_a?(Pokemon)
	if target.is_a?(Pokemon)
    damagePercentage *= 1.2 if user.level - 10 > target.level
	else
    damagePercentage *= 1.2 if dmg - 10 > $player.equipmentdefbuff
	end
	if skill > 160
    damagePercentage = 120 if damagePercentage > 120   # Treat all lethal moves the same
    damagePercentage += 40 if damagePercentage > 100   # Prefer moves likely to be lethal
   end
    score += damagePercentage.to_i
    return score
end
def self.closer_score(attacker, distance)
  return 20 - distance
end
def self.adjacent_score(attacker, target)
  return 100 if OverworldCombat.attack_distance(attacker, target) == 1
  return 0
end
def self.sightline_score(attacker, distance)
  return 50 if OverworldCombat.sight_line(attacker) >= distance
  return -50 if OverworldCombat.sight_line(attacker) <= distance
  return 0
end
def self.hostility_score(attacker, target)
  return 75 if attacker.angry_at.include?(target) if attacker.is_a?(Game_PokeEvent)
  return 75 if attacker.targets.include?(target) if attacker.is_a?(Game_PokeEventA)
  return 0
end 
def self.player_score(attacker, target)
  return 100 if get_cur_player == target
  return 0
end 
def self.last_attacked_score(attacker, target)
  return 0 if attacker.last_attacked_by.nil?
  return 100 if attacker.last_attacked_by == target.id
  return 0
end 


def self.can_use_move_score(attacker, move, target)
  score = 0
    if move.projectile? || move.beam? || move.orbiting? || move.cone?#Projectiles like these care if an event is cardinal, and is within the moves range.
	  score += 20 if OverworldCombat.within_range?(attacker, target, move, OverworldCombat.sight_line(attacker))
	elsif move.cardinal? || move.disappearance? #These care about adjacency.
	   score += 50 if OverworldCombat.adjacent?(attacker, target)
	elsif move.rushdown? #Rushdown cares if an event is cardinal to them, but if its within the users sight cone.
	   score += 40 if OverworldCombat.within_cardinal_sight?(attacker, target)
	elsif move.ranged_target? || move.arc? #These really only care if you are within the users sightline at all.
	   score += 30 if OverworldCombat.within_sight?(attacker, target)
	elsif move.surrounding_user? #These care if you are within varying diamond shapes, so a 'nearby' is good.
	   score += 30 if OverworldCombat.within_sight?(attacker, target)
	elsif move.summoning? #These just wanna summon something.
	   score += 10
    end
  score
end 


def self.movement_penalty(attacker, move, target) #NOT DONE
  score = 0 

    if move.projectile? || move.beam? || move.orbiting? || move.cone?
      score -= 40 unless OverworldCombat.within_range?(attacker, target, move, OverworldCombat.sight_line(attacker))


    elsif move.ranged_target? || move.arc?
      score -= 60 unless OverworldCombat.adjacent?(attacker, target)

    elsif move.rushdown?
      score -= 60 unless OverworldCombat.within_cardinal_sight?(attacker, target)

    elsif move.cardinal? || move.disappearance?
      score -= 60 unless OverworldCombat.within_sight?(attacker, target)

    elsif move.surrounding_user?
      score -= 60 unless OverworldCombat.within_sight?(attacker, target)
    end


  score
end 

def self.type_match_score(attacker, target)
  score = 0
  attacker.pokemon.types.each do |type|
    value = Effectiveness.calculate(type, *target.pokemon.types)
    score += 50 if Effectiveness.super_effective?(value)
    score -= 50 if Effectiveness.not_very_effective?(value)
  end 
  return 0
end 


end



class OverworldCombat::Moves
 def self.valid_targets(attacker, move)
  target_data = OverworldCombat::Moves.target_data(move.id)
   puts target_data.id
   case target_data.id
  when :User
    return pbOverworldCombat.user(attacker)

  when :NearAlly
    return pbOverworldCombat.other_allies(attacker)

  when :UserOrNearAlly, :UserAndAllies, :AllAllies, :UserSide
    return pbOverworldCombat.ally(attacker)

  when :NearFoe, :RandomNearFoe, :Foe, :AllFoes, :FoeSide, :Other, :AllNearOthers, :NearOther, :AllNearFoes
    return pbOverworldCombat.foe(attacker)

  when :AllBattlers, :BothSides
   return pbOverworldCombat.ally(attacker) + pbOverworldCombat.foe(attacker)
  else
   raise 
  end
  return []
 end 
 
 def self.score_target(attacker, move, target, skill)
    if attacker.is_a?(Game_PokeEvent)
	  score = OverworldCombat::Opponent.score_target(attacker, move, target, skill)
	else
	  score = OverworldCombat::Ally.score_target(attacker, move, target, skill)
	end 
 end 
 

  def self.score_move(attacker, move, skill)
    user = attacker.pokemon
    score = 100
  if skill > 120

    if user.status == :SLEEP
      unless [:SNORE, :SLEEPTALK].any? { |m| user.moves.include?(m) }
        score -= 60
      end
    end

    if user.status == :FROZEN
      if move.flags.any? { |f| f[/^ThawsUser$/i] }
        score += 40
      elsif user.moves.any? { |m| m.flags.any? { |f| f[/^ThawsUser$/i] } }
        score -= 60
      end
    end

    if user.hp <= user.totalhp / 4
      if move.function_code == "FleeFromBattle" ||
         move.function_code == "SwitchOutUserStatusMove"
        score += 40
      elsif move.function_code == "SwitchOutUserDamagingMove"
        score += 60
      end
    end

  end


  if skill > 160
    score -= 100 if move.function_code.include?("SwitchOut")
    score += 30 if move.function_code == "TrapTargetInBattle"
    score += 80 if move.function_code == "PursueSwitchingFoe"
  end


  if skill > 200
    score += 30 if move.function_code == "DestroyTargetBerryOrGem"

    if move.function_code == "HealUserHalfOfTotalHP"
      score += 30
    end

    if ["FixedDamage20","FixedDamage40","FixedDamageHalfTargetHP","FixedDamageUserLevel"].include?(move.function_code)
      score += 80
    end
  end


  score -= 100 if move.function_code == "UserFaintsExplosive"

  score -= 40 if move.category == 2

  score 
  
  end 
  def self.choose_target(attacker, move)
    scored_targets = self.valid_targets(attacker, move)&.map do |target|
      score = score_target(attacker, move, target, 999)
      score += rand(-5..5) unless score.nil?
      [target, score]
    end
	if attacker.is_a?(Game_PokeEventA)
	puts scored_targets.nil?
	puts scored_targets.empty?
	end
    return nil if scored_targets.nil?
    return nil if scored_targets.empty?
   best_target = scored_targets&.reject { |_, score| score.nil? }&.max_by { |_, score| score }
   best_target&.first
  end 
  def self.choose_move(attacker, target)
  skill = (($PokemonSystem.difficulty + 1) * $PokemonSystem.difficultymodifier) + (rand(80) + 1)
  actions = []

  attacker.pokemon.totalMoves.each do |move|
    next unless OverworldCombat.can_choose_move?(attacker, move)

    move_score = score_move(attacker, move, skill)
    target_score = score_target(attacker, move, target, skill)
    next if target_score.nil?

    variance = skill > 200 ? 5 : 15
    score = move_score + target_score + rand(-variance..variance)

    actions << [move, target, score]
  end

  return nil if actions.empty?
  actions.max_by { |action| action[2] }
  
  
  
  
  end 
  
  def self.choose_action(attacker)
    skill=(($PokemonSystem.difficulty+1)*$PokemonSystem.difficultymodifier)+(rand(80)+1)	
    actions = []

    attacker.pokemon.totalMoves.each do |move|
    next unless OverworldCombat.can_choose_move?(attacker, move)
    move_score = score_move(attacker, move, skill)

    self.valid_targets(attacker, move)&.each do |target|
	  score = score_target(attacker, move, target, skill)
	 # puts "#{attacker.pokemon.name} targets #{target.pokemon.name} using #{move.name} - Score 1: #{score}"
	  next if score.nil?
      score += move_score
	  variance = skill > 200 ? 5 : 15
      score += rand(-variance..variance)
	#  puts "#{attacker.pokemon.name} targets #{target.pokemon.name} using #{move.name} - Score 2: #{score}"
      actions << [move, target, score]
    end
    end
    return nil if actions.nil?
    return nil if actions.empty?
	#puts "Returning action"
    actions.max_by { |action| action[2] }
  end 


def self.target_data(move_id)
   moveData = GameData::Move.get(move_id)
   GameData::Target.get(moveData.target)
end 

def self.targets_ally?(move_id)
  target_data = OverworldCombat::Moves.target_data(move_id)
  [:NearAlly, :UserOrNearAlly, :UserAndAllies, :AllAllies, :UserSide, :NearOther, :AllNearOthers, :Other, :AllBattlers, :BothSides].include?(target_data)

end 

def self.targets_user?(move_id)
  target_data = OverworldCombat::Moves.target_data(move_id)
  [:User, :UserOrNearAlly, :UserAndAllies, :UserSide, :NearOther, :AllNearOthers, :Other, :AllBattlers, :BothSides].include?(target_data)

end 

def self.targets_foe?(move_id)
  target_data = OverworldCombat::Moves.target_data(move_id)
  [:NearFoe, :RandomNearFoe, :AllNearFoes, :FoeSide, :Foe, :AllFoes, :NearOther, :AllNearOthers, :Other, :AllBattlers, :BothSides].include?(target_data)

end 
  def self.pbTypes(target, withType3 = false)
    ret = target.types.uniq
    # Burn Up erases the Fire-type.
   # ret.delete(:FIRE) if @effects[PBEffects::BurnUp]
    # Roost erases the Flying-type. If there are no types left, adds the Normal-
    # type.
   # if @effects[PBEffects::Roost]
   #   ret.delete(:FLYING)
   #   ret.push(:NORMAL) if ret.length == 0
  #  end
    # Add the third type specially.
   # if withType3 && @effects[PBEffects::Type3] && !ret.include?(@effects[PBEffects::Type3])
   #   ret.push(target.effects[PBEffects::Type3])
   # end
    return ret
  end

  #=============================================================================
  # Type effectiveness calculation
  #=============================================================================
  def self.type_mod_single(moveType, defType, user, target)
    ret = Effectiveness.calculate_one(moveType, defType)
    if Effectiveness.ineffective_type?(moveType, defType)
      # Ring Target
    #  if target.hasActiveItem?(:RINGTARGET)
    #    ret = Effectiveness::NORMAL_EFFECTIVE_ONE
    #  end
      # Foresight
      if (user.hasAbility?(:SCRAPPY) || target.effects[PBEffects::Foresight]) &&
         defType == :GHOST
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Miracle Eye
      if target.effects[PBEffects::MiracleEye] && defType == :DARK
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
    elsif Effectiveness.super_effective_type?(moveType, defType)
      # Delta Stream's weather
      if $game_screen.weather_type == :StrongWinds && defType == :FLYING
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
    end
    # Grounded Flying-type Pokémon become susceptible to Ground moves
    #if !target.airborne? && defType == :FLYING && moveType == :GROUND
    #  ret = Effectiveness::NORMAL_EFFECTIVE_ONE
    #end
    return ret
  end

  def self.type_mod(moveType, user, target)
    return Effectiveness::NORMAL_EFFECTIVE if !moveType
    return Effectiveness::NORMAL_EFFECTIVE if moveType == :GROUND &&
                                              target.pbHasType?(:FLYING) &&
                                              target.hasActiveItem?(:IRONBALL)
    # Determine types
    tTypes = self.pbTypes(target, true)
    # Get effectivenesses
    typeMods = [Effectiveness::NORMAL_EFFECTIVE_ONE] * 3   # 3 types max
    if moveType == :SHADOW
      if target.shadowPokemon?
        typeMods[0] = Effectiveness::NOT_VERY_EFFECTIVE_ONE
      else
        typeMods[0] = Effectiveness::SUPER_EFFECTIVE_ONE
      end
    else
      tTypes.each_with_index do |type, i|
        typeMods[i] = self.type_mod_single(moveType, type, user, target)
      end
    end
    # Multiply all effectivenesses together
    ret = 1
    typeMods.each { |m| ret *= m }
    #ret *= 2 if target.effects[PBEffects::TarShot] && moveType == :FIRE
	#puts ret
    return ret
  end
end 

class OverworldCombat #Move Calculations

def self.num_hits(move, user, target)
 if user.hasAbility?(:PARENTALBOND) && move.category != 2 && !OverworldCombat.chargingattack?(move)
  user.effects[PBEffects::ParentalBond] = 3
  return move.num_hits + 1
 else
  return move.num_hits
 end 
end 

def self.chargingattack?(move)
  false 
end 

def self.sight_line(seer)
  return seer.counter.to_i if defined?(seer.counter)
     counter_match = seer.name.match(/surrounding\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match

  return number.to_i if number
  return 3 
end

def participants_in_range(type, source, range)
  pbOverworldCombat.getParticipants(type).values.select do |event|
    next false unless event.map_id == source.map_id

    dx = (event.x - source.x).abs
    dy = (event.y - source.y).abs

    dx + dy <= range
  end
end

def self.can_choose_move?(event,move,showMessages=false)
  pkmn = event.pokemon
  if move.pp == 0 && move.total_pp > 0
	  sideDisplay("There's no PP left for this move!") if showMessages
	#pbMessage("\\ts[]" + (_INTL"There's no PP left for this move!\\wtnp[30]")) if showMessages
    return false
  end
  if event.effects[PBEffects::Encore]>0
    return false
  end
  if event.effects[PBEffects::Disable]>0
    return false
  end
  if event.effects[PBEffects::Taunt] >0
    return false
  end
  if pkmn.status == :FROZEN
    return false
  end
  if pkmn.status == :PARALYSIS
    return false
  end
  if pkmn.status == :SLEEP
    return false
  end
  return true
end
def self.adjacent?(a, b)
   dx = (a.x - b.x).abs
   dy = (a.y - b.y).abs
  (dx + dy) == 1
end


def self.within_cardinal_sight?(attacker, target)
  dx = (attacker.x - target.x).abs
  dy = (attacker.y - target.y).abs
  (dx == 0 || dy == 0) && dx + dy <= OverworldCombat.sight_line(attacker)
end
def self.within_sight?(attacker, target)
  dx = (attacker.x - target.x).abs
  dy = (attacker.y - target.y).abs
  Math.sqrt(dx * dx + dy * dy) <= OverworldCombat.sight_line(attacker)
end
def self.target_in_front?(attacker, target)
  case attacker.direction
  when 2 # down
    target.x == attacker.x && target.y == attacker.y + 1
  when 4 # left
    target.x == attacker.x - 1 && target.y == attacker.y
  when 6 # right
    target.x == attacker.x + 1 && target.y == attacker.y
  when 8 # up
    target.x == attacker.x && target.y == attacker.y - 1
  else
    false
  end
end

def self.tile_in_front(event)
  x = event.x
  y = event.y

  case event.direction
  when 2 # down
    y += 1
  when 4 # left
    x -= 1
  when 6 # right
    x += 1
  when 8 # up
    y -= 1
  end

  return x, y
end

 
  def self.within_range?(user, target, move, distance=OverworldCombat.sight_line(user))
	 pbAbsoluteDistance(target.x,target.y,user.x,user.y) <= distance
  end

def execute_move(attacker, move, target)
  context = { :user => attacker, :target => target, :move => move }
  results = OverworldCombat::MoveExecution.apply(context)
  return false if results.nil?
  targets = results.compact.select do |result|
    next false if result.is_a?(Symbol)
    !outSpeeds?(attacker, result, move)
  end
  return false if targets.empty?
  hit_targets = []
  targets.each do |target|
      next unless target

      accuracy = move.accuracy
      accbonus = 0

      # TODO: accuracy stages later
      # accbonus += attacker.stages[:ACCURACY]
       
      if target == $game_player
        will_hit = rand(100) + ($player.shoespeed / 2) < (accuracy + accbonus)
      else
        will_hit = rand(100) < (accuracy + accbonus)
      end
        will_hit = true if accuracy == 0
      next unless will_hit

      hit_targets << target
  end
  return false if hit_targets.empty?
  move.pp -= 1 if move.pp>0
  start_glow(attacker)
  sound_from_move(move.id,attacker.pokemon)
  sideDisplay("#{attacker.pokemon.name} used #{move.name}!")
  hit_targets.each do |target|
      move.record_move_use(attacker.pokemon, target.pokemon)
      resolve_move(attacker, target, move)
  end
  return true
end

def resolve_move(attacker, target, move)
  if move.category == 2
    resolve_status_move(attacker, target, move)
    return
  end
  
  directionals = getdirissues(attacker, target)
  backattack, sideattack, baddir = directionals 
  multiplier = 1
  multiplier = 1.5 if backattack
  multiplier = 1.25 if sideattack
  damage = getDamager(attacker, target, move, multiplier)
  
  if backattack
    pbSEPlay("Battle damage super")
  elsif sideattack
    pbSEPlay("Battle damage normal")
  else
    pbSEPlay("Battle damage weak")
  end
  
  effects = OverworldCombat::MoveEffects.apply_secondary({
    move: move,
    user_event: attacker,
    target_event: target,
    user: attacker.pokemon,
    target: target.pokemon,
    damage: damage
  })
  attacker.battle_timer = attacker.extend_battle_timer if attacker.respond_to?(:extend_battle_timer)
  attacker.attack_opportunity = attacker.attack_opportunity + rand(Graphics.frame_rate) + 30 if attacker.respond_to?(:attack_opportunity)
  attacker.attack_cooldowns.map! do |cooldown|
    [cooldown - move.priority * 10, 20].max
  end if defined?(attacker.attack_cooldowns) && move.priority != 0
  effects = OverworldCombat::MoveOverworldState.apply({
    move: move,
    user_event: attacker,
    target_event: target,
    user: attacker.pokemon,
    target: target.pokemon,
    damage: damage
  })
  damage = effects[:damage_changes] if effects && effects[:damage_changes]
  
 #  puts "#{attacker.pokemon.name} Lv#{attacker.pokemon.level} uses #{move.category}. #{move.name} and does #{damage} damage."
  resolve_attack(damage, target, attacker, move, directionals)
  
  if attacker.is_a?(Game_PokeEventA) &&
     (target.nil? || target.pokemon.nil? || target.pokemon.fainted?)
    attacker.last_attacked = false
  end
end 

def resolve_status_move(attacker, target, move)
  result = OverworldCombat::MoveEffects.apply_primary({
    move: move,
    user_event: attacker,
    target_event: target,
    user: attacker.pokemon,
    target: target.pokemon
  })
  result 
end 


def resolve_attack(damage, target, attacker, move, directionals)
  if target == $game_player
    attacking_the_player(damage, attacker, move, directionals)
  else
    attacking_whatever_else(damage, target, attacker, move)
  end
end 



  def health_exclaimation(damage)
	pbWait(6)
    pbExclaim($game_player,17) if $player.playerhealth-damage >= 80
    pbExclaim($game_player,16) if $player.playerhealth-damage >= 50 && $player.playerhealth-damage < 80
    pbExclaim($game_player,15) if $player.playerhealth-damage >= 25 && $player.playerhealth-damage < 50
    pbExclaim($game_player,14) if $player.playerhealth-damage <= 24
  end 
  

  def attacking_the_player(damage, attacker, move, directionals)
        backattack, sideattack, baddir = directionals 
		if $player.blocking && !backattack && !sideattack
         current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
		 if current_selection.is_a?(ItemData)
		  pbSEPlay("Anim/Knock")
		  reduced_damage = damage/2
		  current_selection.decrease_durability(reduced_damage)
		  return 
		 end
		end
        damage *= 1.5
		health_exclaimation(damage)
		damagePlayer(damage, true)
		if should_knock_down_player?(damage, move)
		  get_knocked_down(attacker)
		end

  end
  def should_knock_down_player?(damage, move)
    return false if $game_temp.bossfight
    return false if $player.fainted?
    return true if move.base_damage >= 100
    return false
  end
  
  def attacking_whatever_else(damage, target, attacker, move)
	  target.turn_toward_target(attacker)
	  start_attacked_glow(target,attacker)
	  target.angry_at << attacker if defined?(target.angry_at) && !target.angry_at.include?(attacker)
	  target.add_target(attacker.id, attacker) if defined?(target.add_target) && !target.targets.keys.include?(attacker.id)
	  target.last_attacked_by = attacker.id
	  damagePokemon(target,damage)
  end



  def get_knocked_down(attacker)
	      sideDisplay("#{attacker.pokemon.name} knocked #{$player.name} down!")
		   
	      if pbOverworldCombat.battle_rules.include?("Catchless")
	       setBattleRule("disablepokeballs")
	      end
	      $game_temp.encounter_type = $game_temp.encounter_type
	      pbStoreTempForBattle()
	      $PokemonGlobal.battlingSpawnedPokemon = true
		  pbSafariBattle(nil,nil,attacker.pokemon)
	      #pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	      $PokemonGlobal.battlingSpawnedPokemon = false
	      pbResetTempAfterBattle()
          attacker.removeThisEventfromMap if attacker.is_a?(Game_PokeEvent)
  end
  




def self.pbGetAttackStat2(user,move)
    if move.category == 1 
      return user.pokemon.spatk
    end
    return user.pokemon.attack
  end



end