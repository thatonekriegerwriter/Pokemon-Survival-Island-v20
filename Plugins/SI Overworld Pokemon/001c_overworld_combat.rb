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
 #
#when 2 then event.move_down
#when 4 then event.move_left
#when 6 then event.move_right
#when 8 then event.move_up
   def initialize(opponent)
	  @participants = []
	  @turn = 0
	  @battle_rules = []
	  @currentlyinbattle = false
	  @change_move_direction = false
	  @pokemona= nil
	  @hard_hitting= 0
	  @track = []
	  getParticipants(opponent)
	  
	  
     @opponent = @participants[0]
	 @controlled = @participants[1]
	 @other_participants = @participants[2..-1]
	 @player_stuff = @participants[1..-1]
	  getTracks
   end
   

def getTracks
	@track << [[10,7],[10,27]] if @opponent.pokemon.species == :STEELIX && @opponent.pokemon.form == 2
end
def getParticipants(opponent)
    @participants << opponent
    @participants << $game_player if $game_temp.current_pkmn_controlled==false
	@participants << $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled !=false
end

def addParticipant(newpart)
 if @battle_rules.include?("Only-One-Mon") && @participants==2
  return false
 end
   if !@participants.include?(newpart)
	  @participants << newpart
	  return true
	end

  return false
end




def update
     return if @participants.empty?
     return if @opponent.nil?
     return if @controlled.nil?
	 @backattack,@sideattack,@baddir = getdirissues
     @pokemonspeed = @opponent.pokemon.speed
     @playerspeed = @controlled.pokemon.speed
end

def wild_should_attack?
 backattack = @opponent.direction == @controlled.direction
 return false if @opponent.attacked_last_call==true
 return false if @opponent.battle_timer>0 && backattack==false
 return true if $game_temp.bossfight==true
 attack_chance = rand(100)
 rate = 36
 rate*=1.5 if backattack
 rate*=1.5 if @opponent.pokemon.is_aggressive?
 
 return attack_chance<=rate
end

def get_distance
 distances = []
	 @player_stuff.each do |event|
	 distances << pbDetectTargetPokemon(@opponent,event)
	 end
     minimum = distances.min
     max_index = distances.index(minimum)
     target = @player_stuff[max_index]
     distance = distances[max_index]

 
  return target,distance
end
def set_bgm
     if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
       $game_system.bgm_pause
       $game_temp.memorized_bgm = $game_system.getPlayingBGM
       $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
     end
      testbgm = pbGetBossBattleBGM
	  if testbgm && testbgm!=$game_system.getPlayingBGM
         bgm = pbStringToAudioFile(testbgm) if testbgm
         pbBGMPlay(bgm) if testbgm
	   end
	 sx = @opponent.x + (@opponent.width / 2.0) - ($game_player.x + ($game_player.width / 2.0))
    sy = @opponent.y - (@opponent.height / 2.0) - ($game_player.y - ($game_player.height / 2.0))
    if ( sx.abs >= 8 || sy.abs  >= 8) && $game_temp.bossfight==true
    
     if $game_temp.memorized_bgm && $game_system.is_a?(Game_System) 
        $game_system.bgm_pause
       $game_system.bgm_position = $game_temp.memorized_bgm_position
       $game_system.bgm_resume($game_temp.memorized_bgm)
		$game_temp.memorized_bgm = nil
		$game_temp.memorized_bgm_position = nil
	 end  

    end	




end

def ov_combat_loop
 	 return if status_checks(@opponent)==true
 	 return if @currentlyinbattle==true
    return if $PokemonGlobal.fishing == true
    return if $game_temp.in_menu == true
    return if $game_temp.message_window_showing == true
	theresult = false
    set_bgm if false
	if wild_should_attack?
 	 @currentlyinbattle = true
 	 get_overworld_pokemon
 	 update
 	 target,distance = get_distance
 	 return if target.nil?
 	 theresult = opponentChoice(@opponent,target,distance)
 	 @turn+=1
 	 return if status_checks(@opponent)
	 @opponent.times_not_attacking=0
	 if theresult==true
	 @opponent.attacked_last_call=true
 	 @opponent.battle_timer=rand(10)+5
	 @opponent.remaining_steps+=1
	 end
	elsif @opponent.attacked_last_call==true
	 @opponent.attacked_last_call=false
	 @opponent.battle_timer-=1
 	 @turn+=1
 	 return if status_checks(@opponent)
	elsif @opponent.attacked_last_call==false
	 @opponent.times_not_attacking+=1
	 @opponent.battle_timer-=@opponent.times_not_attacking
	 @opponent.battle_timer= 0 if @opponent.battle_timer<0
 	 @turn+=1
 	 return if status_checks(@opponent)
	 
	end
end

def get_overworld_pokemon
$player.party.each_with_index do |pkmn,index|
 next if $game_temp.current_pkmn_controlled !=false && index==0
 next if $game_temp.current_pkmn_controlled !=false && index>2
 next if pkmn.inworld==false
 if addParticipant($game_map.events[getOverworldPokemonfromPokemon(pkmn)])
 elsif @participants.include?($game_map.events[getOverworldPokemonfromPokemon(pkmn)])
 end
end
end



def opponentChoice(attacker,target,distance,bonus=0)
potato = 0
result = false
@hard_hitting =  bonus
loop do
  break if potato==2
  if pbShouldAttack?(attacker,target)
	 start_glow(@opponent,bonus) if attacker==@opponent
    move = chooseMove(attacker,target,distance)
	 if move!=false && !move.nil?
     if move.category == 0
	  if distance==1 
	   result = move_physical_close(attacker,target,move)
	  elsif $game_temp.bossfight=true
	   result = move_physical_close(attacker,target,move)
	  else
	   result = move_physical(attacker,target,move)
	  end
	 elsif move.category == 1
	   result = move_special(attacker,target,move,distance)
	 else
	   result = move_other(attacker,target,move)
	 end
     end

	 #end_glow(@opponent) if attacker==@opponent
     break
  else
   target,distance = changeTarget(attacker,target)
   potato+=1
  end
end
return result
end

def start_glow(attacker,bonus=0)
 sprite=nil
 $scene.spriteset.character_sprites.each do |character_sprite|
  if character_sprite.character == attacker
    sprite = character_sprite
  end
 end
fadeTime = Graphics.frame_rate * 4 / 10
toneDiff = (255.0 / fadeTime).ceil
if Settings::TIME_SHADING && $game_map.metadata&.outdoor_map
   basetone = PBDayNight.getTone
else
   basetone = Tone.new(0, 0, 0, 0)
end

(1..fadeTime).each do |i|
   next if sprite.nil?
  sprite.tone.set(((i+bonus) * toneDiff) + basetone.red, basetone.green, basetone.blue, basetone.gray)
      Graphics.update
      Input.update
      pbUpdateSceneMap
end


end

def end_glow(attacker,bonus=0)
 return if attacker.sprite.nil?
fadeTime = Graphics.frame_rate * 4 / 10
toneDiff = (255.0 / fadeTime).ceil
if Settings::TIME_SHADING && $game_map.metadata&.outdoor_map
   basetone = PBDayNight.getTone
else
   basetone = Tone.new(0, 0, 0, 0)
end
(1..fadeTime).each do |i|
  attacker.sprite.tone.set(255 - ((i+bonus) * toneDiff) + basetone.red, basetone.green, basetone.blue, basetone.gray)
      Graphics.update
      Input.update
      pbUpdateSceneMap
end



end

def movement_attack(attacker,target,distance)
 	 return if @currentlyinbattle==true
	 result = false
 	 @currentlyinbattle=true
 	 get_overworld_pokemon
 	 update
 	 turning_prep(attacker,target)
 	 result = opponentChoice(attacker,target,distance,3)
 	 @currentlyinbattle=false
	 return result
end


def turning_prep(attacker,target)
  return if $game_temp.bossfight==true
  pbTurnTowardEvent(attacker,target) 
end


def move_physical(attacker,target,move)
      turning_prep(attacker,target)
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} is rearing back!\\wtnp[10]"))
      pbMoveRoute(target, [PBMoveRoute::Wait, 30])

	  if outSpeeds? #Player Outspeeds
	    dir = staminaManagement(attacker,target) if target == $game_player
	    dir = inputDetection(attacker,target) if target != $game_player
		
		if can_move_there?(attacker,dir)
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) #PBMoveRoute::Wait, 2
			
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) if dir == @baddir
		 
		 
		 
		 if target == $game_player
	      if advanced_shoes2(target)
	         decreaseStamina(15)
		  elsif dir == @baddir
	         decreaseStamina(15)
		  elsif default_sta2(target)
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			 pbExclaim(target,48)
	         return offensive_turn_finishing(attacker,target,move)
		  end
         else
			pbExclaim(target,48)
	        return offensive_turn_finishing(attacker,target,move)
		 end







       else
	    return offensive_turn_finishing(attacker,target,move)
		end






	  else
	  
	    pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} was outsped by #{pkmn.name}!\\wtnp[30]"))
	    pbSEPlay("phenomenon_grass")
	    return offensive_turn_finishing(attacker,target,move)
		
     end

end


def move_physical_close(attacker,target,move)
     turning_prep(attacker,target)
	  if outSpeeds? #Player Outspeeds
	    dir = staminaManagement(attacker,target) if target == $game_player
	    dir = inputDetection(attacker,target) if target != $game_player
		
		
		
		if can_move_there?(attacker,dir)
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) #PBMoveRoute::Wait, 2
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) if dir == @baddir
		 
		 
		 

		 if target == $game_player
	      if advanced_shoes2(target)
	         decreaseStamina(15)
		  elsif dir == @baddir
	         decreaseStamina(15)
		  elsif default_sta2(target)
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			 pbExclaim(target,48)
	         return offensive_turn_finishing(attacker,target,move)
		  end
         else
			pbExclaim(target,48)
	       return offensive_turn_finishing(attacker,target,move)
		 end



       else
	    return offensive_turn_finishing(attacker,target,move)
       end
	  else
	    pbMessage("\\ts[]" + (_INTL"#{target.pokemon.name} was outsped by #{attacker.pokemon.name}!\\wtnp[30]"))
	    pbSEPlay("phenomenon_grass")
	    return offensive_turn_finishing(attacker,target,move)
     end


end


def move_special(attacker,target,move,distance)
     turning_prep(attacker,target)
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} is gathering energy!\\wtnp[10]"))
	  timepass = 0
	  loop do 
        timepass+=1

	    break if timepass > 29
	  end



	  if outSpeeds? #Player Outspeeds
	    dir = staminaManagement(attacker,target) if target == $game_player
	    dir = inputDetection(attacker,target) if target != $game_player
		if can_move_there?(@opponent,dir)
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) #PBMoveRoute::Wait, 2
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) if dir == @baddir
		 
		 
		 
		 if target == $game_player
	      if advanced_shoes2(target)
	         decreaseStamina(15)
		  elsif dir == @baddir
	         decreaseStamina(15)
		  elsif default_sta2(target)
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			 pbExclaim(target,48)
	         return offensive_turn_finishing(attacker,target,move)
		  end
         else
			pbExclaim(target,48)
	        return offensive_turn_finishing(attacker,target,move)
		 end




       else
	        return offensive_turn_finishing(attacker,target,move)
       end

	  else
	    pbMessage("\\ts[]" + (_INTL"#{target.pokemon.name} was outsped by #{attacker.pokemon.name}!\\wtnp[30]"))
	    pbSEPlay("phenomenon_grass")
	    return offensive_turn_finishing(attacker,target,move)
     end

	  
	  




end


def move_other(attacker,target,move)
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} focused!\\wtnp[10]"))
      return false
end






def offensive_turn_finishing(attacker,target,move,evasionbonus=0)
   accuracy   = move.accuracy
   accbonus=0
   if attacker.stages.key?(:ACCURACY)
    
   end
	pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} used #{move.name}!\\wtnp[10]"))
    will_hit = rand(100)+($player.shoespeed/2) < (accuracy+accbonus) if target == $game_player
    will_hit = rand(100)+evasionbonus < (accuracy+accbonus) if target != $game_player
   
    move.record_move_use(attacker.pokemon, target.pokemon)
	if will_hit==true
       is_hitting(attacker,target,move)
	   return true
    else
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} missed!\\wtnp[10]"))
	  return false
    end
   
   
   
   
   @currentlyinbattle = false

end




def get_events_in(move_distance,cur_x,cur_y)
  results = []

  # Checking horizontal and vertical movements
  (-move_distance..move_distance).each do |i|
    if cur_x != cur_x + i && cur_y != cur_y + i
     event = @map.check_event(cur_x + i,cur_y + i)
	 if event.is_a?(Integer) && event!=0
	 results << event
	 end
	end
  end 
  if move_distance>1
  movedistancedia=(move_distance/2)+1
  # Checking diagonal movements
  (-movedistancedia..movedistancedia).each do |i|
    if cur_x != cur_x + i && cur_y != cur_y + i
     event = @map.check_event(cur_x + i,cur_y + i)
	 if event.is_a?(Integer) && event!=0
	 results << event
	 end
    
	end
  end
  end



  return results
end


end
#===============================================================================
# Stamina and Movement
#===============================================================================
class OverworldCombat 
  
def inputDetection(attacker,target)
    loops = 0
	dir = 0
	pbExclaim(target,46)
	sprite = nil
	amt = 5-@hard_hitting
	loop do
    dir = Input.dir4
	Input.update
    Graphics.update
	#pbExclaim($game_player,47)
	dir_override = false
	dir_override = true if dir == @baddir && target.type.playerstamina>19 && target.type.stamina>19
	if sprite.nil? 
    spriteset = $scene.spriteset(target.map_id)
    sprite = spriteset&.addUserAnimation(47, target.x, target.y, false, 2)
	end
    case dir 
	 when 8
	  if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	  else
	pbExclaim(target,42)
	  end
	
	
	 
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 when 2
	  if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	  else
	pbExclaim(target,44)
	  end
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 when 4 
	  if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	  else
	pbExclaim(target,43)
	  end
	
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 
	 when 6
	 if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	else
	pbExclaim(target,45)
	end
	sprite.dispose
     break
	 else
	loops += 1
	
	
	
	
	
	
	
	end
	
	
	
	
	
	sprite.dispose if loops >= amt
	break if loops >= amt
	if sprite.nil? 
    spriteset = $scene.spriteset(target.map_id)
    sprite = spriteset&.addUserAnimation(47, target.x, target.y, false, 2)
	end
	end

  return dir
end



def staminaManagement(attacker,target)
	  dir = 0
    if advanced_shoes(target)
	  the_effect_of_stamina(attacker,target)
	 elsif default_sta(target)
	  the_effect_of_stamina(attacker,target)
	 else
      dir = inputDetection(attacker,target)
	 end
  return dir
end

  def damageTarget(target,amt)
     if target==$game_player
       damagePlayer(target.pokemon.totalhp/4)
	 else
      damagePokemon(target,target.pokemon.totalhp/4)
	 end
  
  end
  
  
 def damagePokemon(target,amt)
 
    defense, defStage = getDefenseStatsforplayer(target.pokemon)
	 decrease = (defense+defStage)/4
	 theamt = (amt-decrease)
	 theamt = 1 if theamt<1
    target.pokemon.hp -= theamt
	  if target.pokemon.status==:SLEEP
	    target.pokemon.status=:NONE
	  end
  if target.pokemon.hp<0
    target.pokemon.hp=0
  end
  
	puts "#{target.type.name}: #{target.type.hp}/#{target.type.totalhp}"
 end

  def the_effect_of_stamina(attacker,target)
    return if $game_temp.bossfight==true
	 pbExclaim(target,21)
	 pbMessage("\\ts[]" + (_INTL"#{target.type.name} doesn't have enough Stamina to avoid #{attacker.pokemon.name}!\\wtnp[30]"))
	 pbSEPlay("phenomenon_grass")
      damageTarget(target,target.type.totalhp/4)
	  if rand(100)+1 < 16 && $PokemonGlobal.in_dungeon==false && target == $game_player
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} knocked #{target.type.name} down!\\wtnp[10]"))
	  if true
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
        attacker.removeThisEventfromMap
	  end
     end
	  return
  
  end
 
 
 def getdirissues(o=@opponent.direction,c=@controlled.direction)
   
	backattack = o == c
	sideattack = (c == 4 || c == 6)  && (o == 2 || o == 8)
	baddir = if o == 8
            2
          elsif o == 4
            6
          elsif o == 2
            8
          elsif o == 6
            4
          else
            0
          end
	
  return backattack,sideattack,baddir

end

 



 
 
 
 def default_sta(target)
  return $player.playerstamina<10 || target!=$game_player
 end
 
 def default_sta2(target)
  return $player.playerstamina>9 || target!=$game_player
 end
 
  def advanced_shoes(target)
   return $player.playershoes == :DASHBOOTS && $player.playerstamina<20  || target!=$game_player
  end

  def advanced_shoes2(target)
   return $player.playershoes == :DASHBOOTS && $player.playerstamina>19  || target!=$game_player
  end

end
#===============================================================================
# Hit Calculations and Damage
#===============================================================================
class OverworldCombat 


def pbShouldAttack?(attacker,target)
  return false if attacker.pokemon.fainted?
  return false if attacker.pokemon.status == :SLEEP
  return false if attacker.pokemon.status == :PARALYSIS
  return false if attacker.pokemon.status == :FROZEN
  return rand(100)<getRate(attacker,target)

end

def changeTarget(attacker,target)
thetargets = []
distances = []
distances << 0


@player_stuff.each do |event|
 next if event==target
 thetargets << event
 distances << pbDetectTargetPokemon(attacker,event)
end

minimum = distances.min
max_index = distances.index(minimum)


target = @player_stuff[max_index]
distance = distances[max_index]
	 
	



 return target,distance
end



def can_move_there?(event,dir)
dir_override = false
	if dir == @baddir && $player.playerstamina>19
	dir_override = true
	end
return dir != 0 && (dir != @baddir || dir_override == true) && dir != @opponent.direction && (event.can_move_in_direction?(dir) || dir_override == true)
end
  def getAttackStats(user,target, move)
  user.stages = {} if user.stages.nil?
    if move.category == 1 
      return user.spatk, user.stages[:SPECIAL_ATTACK].to_i + 6
    end
    return user.attack, user.stages[:ATTACK].to_i + 6

  end


def is_assassin?
  return $player.playerclass == "Assassin"
end

def outSpeeds?
  speed = @playerspeed
  speed = (@playerspeed*1.8).to_i if is_assassin? && @controlled == $game_player
  return true if speed>=@pokemonspeed
  return false
end


def getDefenseStats(user,target, move)
   if target.is_a?(Pokemon)
  target.stages = {} if target.stages.nil?
    if move.category == 1 
      return target.spdef, target.stages[:SPECIAL_DEFENSE].to_i + 6
    end
    return target.defense, target.stages[:DEFENSE].to_i + 6
	else
	 return $player.equipmentdefbuff, 0
	end
end

def getDefenseStatsforplayer(target)
   if target.is_a?(Pokemon)
  target.stages = {} if target.stages.nil?
    return target.defense, target.stages[:DEFENSE].to_i + 6
	end
end


def get_the_multipliers(mult,pkmn,move)

		 mult[:final_damage_multiplier] *= 1
        mult[:final_damage_multiplier] *= 2 if @backattack
		 mult[:final_damage_multiplier] *= 1.5 if @sideattack
		 mult[:final_damage_multiplier] *= 1.5 if pbThisHasType?(pkmn,move.type)
		 return mult
end


def applyStatus(move,user,target)
	   if move.function_code.include?("SleepTarget")
 ability1=GameData::Ability.try_get(:INSOMNIA)
 ability2=GameData::Ability.try_get(:VITALSPIRIT)
  if target.status != :NONE && (target.ability==ability1 ||target.ability==ability2)
  else
     target.status=:SLEEP
	   if target.status_turns.nil?
	     target.status_turns=0
	   end
	     target.status_turns=(rand(4)+1)
  end
	   end

	   if move.function_code.include?("ParalyzeTarget" )  || move.function_code == "BindTarget"
  if target.status != :NONE && target.pbHasType?(:GROUND)
  else
     target.status=:PARALYSIS
	 #makeParalyzed(target)
  end
	   end
	   
	   
	   if move.function_code.include?("PoisonTarget")

   if target && (target.status != :NONE || !target.pbHasType?(:STEEL) || !target.hasAbility?(:CORROSION))
     target.status=:POISON
	   if target.status_turns.nil?
	     target.status_turns=0
	   end
	     target.status_turns=(rand(4)+1)
		pbSEPlay("FollowEmote_Poison")
   end


	   end


	   
	   if move.function_code.include?("BurnTarget")
  if target.status != :NONE && target.pbHasType?(:FIRE)
  else
     target.status=:BURN
  end
	   end


	   
	   if move.function_code.include?("FreezeTarget")
  if target.status != :NONE  && target.pbHasType?(:ICE)
  else
     target.status=:FROZEN
  end
	   end


	   if move.function_code == "GiveUserStatusToTarget"
         if user.status != :NONE
		   target.status = user.status
		   user.status = :NONE
		 end
	   end



end



def getDamager(event,target,move,multiplier=1)
  #pbCalcDamage
	  baseDmg = move.base_damage
     atk, atkStage = getAttackStats(event.pokemon, target.pokemon, move)
    defense, defStage = getDefenseStats(event.pokemon, target.pokemon, move)
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
	multipliers = get_the_multipliers(multipliers,event.pokemon,move)
    # pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Main damage calculation
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((event.pokemon.level / 6) + 1).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
	damage *= multiplier
	puts damage.floor
	divideby = 4
	puts (damage.floor/divideby).floor
	result = (damage.floor/divideby).floor
	 if result > 100
	  result/=2
	 end
     return result
end



def getRate(event,target)
         rate=35
	  event.pokemon.types.each do |i|
		 value = Effectiveness.calculate(i, *target.pokemon.types)
         rate*=2 if Effectiveness.super_effective?(value)
         rate*=2 if Effectiveness.not_very_effective?(value)
	     rate=0 if Effectiveness.ineffective?(value)
	   end
	  rate*=4 if event.pokemon.is_aggressive?
		 
		 
		 
		 
	   if target == $game_player
      rate*=1.5 if $player.playerstamina <= 75 && $player.playerstamina > 50 &&
      rate*=3 if $player.playerstamina <= 50 && $player.playerstamina > 25
      rate*=4 if $player.playerstamina <= 25
      rate*=4 if $player.playerhealth <= 25
      rate*=3 if $player.playerhealth <= 50 && $player.playerhealth > 25
      rate*=1.5 if $player.playerhealth <= 75 && $player.playerhealth > 50
       end




	  return rate
end



end

#===============================================================================
# Move Calculations
#===============================================================================
class OverworldCombat #Move Calculations

def can_choose_move?(pkmn,move,showMessages=false)
  if move.pp == 0 && move.total_pp > 0
	pbMessage("\\ts[]" + (_INTL"There's no PP left for this move!\\wtnp[30]")) if showMessages
    return false
  end
  if @opponent.battle_variables.key?("Encore")
    return false
  end
  if @opponent.battle_variables.key?("Disabled")
    return false
  end
  if @opponent.battle_variables.key?("Taunt")
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




def chooseMove(attacker,target,distance)
   $PokemonSystem.difficulty =  4 if $PokemonSystem.difficulty.nil?
   $PokemonSystem.difficultymodifier =  80 if $PokemonSystem.difficultymodifier.nil?
   skill=(($PokemonSystem.difficulty+1)*$PokemonSystem.difficultymodifier)+(rand(80)+1)	
   potato = []
   potato2 = []
   attacker.pokemon.moves.each do |m|
      duris = get_ov_move_score(m,attacker.pokemon,target,skill,distance)
      if can_choose_move?(attacker.pokemon,m)
      potato << duris
	  else
      potato << 0
	  end
   end

   attacker.pokemon.moves2.each do |m|
      duris = get_ov_move_score(m,attacker.pokemon,target,skill,distance)
      if can_choose_move?(attacker.pokemon,m)
      potato2 << duris
	  else
      potato2 << 0
	  end
   end
   if potato.empty?
      potato << 0
   end
   if potato2.empty?
      potato2 << 0
   end
   largest = potato.max
   largest2 = potato2.max
   largeroftwo = [largest,largest2].max
   if largeroftwo==0
    return false
   else
   max_index1 = [largest,largest2].index(largeroftwo)
    if max_index1==0
   max_index = potato.index(largest)
   return attacker.pokemon.moves[max_index]
    else
   max_index = potato2.index(largest2)
   return attacker.pokemon.moves2[max_index]
    end
   end

end

















def get_ov_move_score(move,user,target,skill,distance)
   # 1*40 = 40
   # 2*40 = 80
   # 3*40 = 120
   # 4*40 = 160
    score = 100
     if skill > 120
      # If user is asleep, prefer moves that are usable while asleep
      if user.status == :SLEEP && (move!=:SNORE||move!=:SLEEPTALK)
        user.moves.each do |m|
          next unless (m==:SNORE||m==:SLEEPTALK)
          score -= 60
          break
        end
      end
      # If user is frozen, prefer a move that can thaw the user
      if user.status == :FROZEN
        if move.flags.any? { |f| f[/^ThawsUser$/i] }
          score += 40
        else
          user.moves.each do |m|
            next unless m.flags.any? { |f| f[/^ThawsUser$/i] }
            score -= 60
            break
          end
        end
      end
      # If target is frozen, don't prefer moves that could thaw them
	  if target.is_a?(Pokemon)
      if target.status == :FROZEN
        user.moves.each do |m|
          next if m.flags.any? { |f| f[/^ThawsUser$/i] }
          score -= 60
          break
        end
      end
	  elsif target==$game_player
      if $player.playerstateffect == :FROZEN
        user.moves.each do |m|
          next if m.flags.any? { |f| f[/^ThawsUser$/i] }
          score -= 60
          break
        end
       end
     end	  
	   
	   if move.function_code.include?("SleepTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end

	   if move.function_code.include?("ParalyzeTarget" )
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end
	   
	   
	   if move.function_code.include?("PoisonTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   
	   if move.function_code.include?("BurnTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   
	   if move.function_code.include?("FreezeTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   if move.function_code == "GiveUserStatusToTarget"
      if user.status == :NONE
        score -= 90
      else
        score += 40
	   end
	   end
	  end
     if skill > 160
	   	if move.function_code.include?("SwitchOut") 
	   score -= 100
	   end

	   if move.function_code == "TrapTargetInBattle"
	   score += 30
	   end
	   
	   if move.function_code == "PursueSwitchingFoe"
	   score += 80
	   end
	   

	  end
     if skill > 200
	 	if move.function_code == "RemoveTargetItem"
        score += 20 if target.item
	   end
	   if move.function_code == "DestroyTargetBerryOrGem"
	   score += 30
	   end
	   if move.function_code == "HealUserHalfOfTotalHP"
	    score+30
	   end

	   if move.function_code == "FixedDamage20"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamage40"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamageHalfTargetHP"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamageUserLevel"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   


	  end

	   if move.function_code == "UserFaintsExplosive"
	    score -= user.hp * 100 / user.totalhp
	   end



        score -= 40 if move.category == 2
        score += 80 if move.category == 1 && distance>1 #SPECIAL - HITTING WITH THE WAPOW
        score += 80 if move.category == 0 && distance==1 #PHYSICAL _ IN YA FACE
        score += 40 if move.category == 0 && distance>1 #PHYSICAL - RAMMING
		get_ov_damage_score(score,move,user,target,skill)
		   if target.is_a?(Pokemon)
		   value = Effectiveness.calculate(move.type, *target.types)
		   else
		   value = Effectiveness.calculate(move.type, :NORMAL)
		   end
          score+=60 if Effectiveness.super_effective?(value)
          score=0 if Effectiveness.ineffective?(value)
          score-=60 if Effectiveness.not_very_effective?(value)
          score-=60 if Effectiveness.resistant?(value)

	   if move.function_code == "FleeFromBattle" 
	   score = 0
	   end

    score = score.to_i
	 if rand(2)==0
	score+= rand(30)
	 else
	score-= rand(30)
	 end
    score = 0 if score < 0
    return score

end

def get_ov_damage_score(score,move,user,target,skill)
	 atk = pbGetAttackStat2(user,move)
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

def doesStatus?(move)
   return true if move.function_code.include?("SleepTarget") || move.function_code.include?("ParalyzeTarget") || move.function_code.include?("PoisonTarget") ||
   move.function_code.include?("BurnTarget") || move.function_code.include?("FreezeTarget") || move.function_code == "GiveUserStatusToTarget" || 
   move.function_code == "BindTarget"
   return false
end
def pbGetAttackStat2(user,move)
    if move.category == 1 
      return user.spatk
    end
    return user.attack
  end



end
#===============================================================================
# User Pokemon
#===============================================================================
class OverworldCombat

 def is_hitting(attacker,target,move)
	  multiplier = 1
	  multiplier = 2 if @backattack
	  multiplier = 1.5 if @sideattack
	  
 	if move.id == :EARTHQUAKE || move.id == :MAGNITUDE
     counter_match = attacker.name.match(/counter\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match
	 currentDistance = number if number
	 results = get_events_in(currentDistance,attacker.x,attacker.y)
	 results.each do |target|
     thedamage = getDamager(attacker,target,move,multiplier)


	 if target == $game_player
		pbSEPlay("Battle damage super") if @backattack
		pbSEPlay("Battle damage normal") if @sideattack
		pbSEPlay("Battle damage weak") if !@sideattack && !@backattack
		pbWait(6)
		pbExclaim($game_player,17) if $player.playerhealth >= 80
		pbExclaim($game_player,16) if $player.playerhealth >= 50 && $player.playerhealth < 80
		pbExclaim($game_player,15) if $player.playerhealth >= 25 && $player.playerhealth < 50
        pbExclaim($game_player,14) if $player.playerhealth <= 24
	    if rand(255)+1 < 16 && $PokemonGlobal.in_dungeon==false && $game_temp.bossfight==false && target == $game_player && $player.playerhealth-thedamage<=0
          damagePlayer($player.playerhealth-1)
	      pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	      if true
	      $game_temp.encounter_type = $game_temp.encounter_type
	      pbStoreTempForBattle()
	      $PokemonGlobal.battlingSpawnedPokemon = true
	      $game_temp.in_safari = true
	      pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	      $game_temp.in_safari = false
	      $PokemonGlobal.battlingSpawnedPokemon = false
	      pbResetTempAfterBattle()
          attacker.removeThisEventfromMap
	      end
       else
        damagePlayer(thedamage)
       end









     else 
	 
	  applyStatus(move,attacker.pokemon,target.pokemon)
	  target.pokemon.hp-=thedamage
	  target.pokemon.hp = 0 if target.pokemon.hp < 0

	  if target==@opponent
	    puts "#{target.type.name}: #{target.type.hp}/#{target.type.totalhp}"
		target.status_turns=0 if target.status_turns.nil?
		target.status_turns-=1 if target.status_turns>0
		target.pokemon.status=:NONE if target.status_turns==0
        pokemonEXP(@participants,target.pokemon,attacker.pokemon)
        pbHeldItemDropOW(target.pokemon,true)
      end


	 end

 
 
	 
	 end
  

  else
     thedamage = getDamager(attacker,target,move,multiplier)

	 if target == $game_player
		pbSEPlay("Battle damage super") if @backattack
		pbSEPlay("Battle damage normal") if @sideattack
		pbSEPlay("Battle damage weak") if !@sideattack && !@backattack
		pbWait(6)
		pbExclaim($game_player,17) if $player.playerhealth >= 80
		pbExclaim($game_player,16) if $player.playerhealth >= 50 && $player.playerhealth < 80
		pbExclaim($game_player,15) if $player.playerhealth >= 25 && $player.playerhealth < 50
        pbExclaim($game_player,14) if $player.playerhealth <= 24
	    if rand(255)+1 < 16 && $PokemonGlobal.in_dungeon==false && $game_temp.bossfight==false && target == $game_player && $player.playerhealth-thedamage<=0
          damagePlayer($player.playerhealth-1)
	      pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	      if true
	      $game_temp.encounter_type = $game_temp.encounter_type
	      pbStoreTempForBattle()
	      $PokemonGlobal.battlingSpawnedPokemon = true
	      $game_temp.in_safari = true
	      pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	      $game_temp.in_safari = false
	      $PokemonGlobal.battlingSpawnedPokemon = false
	      pbResetTempAfterBattle()
          attacker.removeThisEventfromMap
	      end
       else
        damagePlayer(thedamage)
       end









     else 
	 
	  applyStatus(move,attacker.pokemon,target.pokemon)
	  target.pokemon.hp-=thedamage
	  target.pokemon.hp = 0 if target.pokemon.hp < 0

	  if target==@opponent
	    puts "#{target.type.name}: #{target.type.hp}/#{target.type.totalhp}"
		target.status_turns=0 if target.status_turns.nil?
		target.status_turns-=1 if target.status_turns>0
		target.pokemon.status=:NONE if target.status_turns==0
        pokemonEXP(@participants,target.pokemon,attacker.pokemon)
        pbHeldItemDropOW(target.pokemon,true)
      end


	 end

 
  end


	  
	  
	  

 
 

	 
 
 
 
 
 
 
 
 
 end


def player_pokemonattack(user,target,move,distance)
   if addParticipant(user)
   pokemon = user.pokemon
   target = target.pokemon
   accuracy   = move.accuracy
   accbonus = 0
   will_hit = rand(100) < (accuracy+accbonus)
   @backattack,@sideattack,@baddir = getdirissues(target,user)
   
   
   
   
   
     if move.category == 0 && distance==1
	 
	 
	 
	 
	 
	    pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	 
	 
	 
	 
	 
    if will_hit==true
       is_hitting(user,target,move)
    else
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end


	 
	 
	 
	 
	 
	 
     
	 elsif move.category == 0 && distance>1
	 
	 
	 
	    pbMessage("\\ts[]" + (_INTL"#{pokemon.name} is too far away to use #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	    
	 elsif move.category == 1
	 
	 
	 
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} is gathering energy!\\wtnp[10]"))
	  timepass = 0
	  loop do 
        timepass+=1

	    break if timepass > 29
	  end
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	 
    if will_hit==true
       is_hitting(user,target,move)
    else
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end


	 
	 
	 elsif move.category == 2
    if will_hit==true
	  if doesStatus?(move)
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	  if will_hit==true
	  if target.status_turns.nil?
		 target.status_turns=0
		end
		target.status_turns-=1 if  target.status_turns>0
		if target.status_turns==0
		 target.status=:NONE
		end
	 applyStatus(move,pokemon,target)
	  end
	  else
	  pbMessage("\\ts[]" + (_INTL"#{move.name} has not been implemented!\\wtnp[10]"))
	  return
	  end
	 end
	 end



   elsif @participants.include?(user)
   
   
   pokemon = user.pokemon
   target = target.pokemon
   accuracy   = move.accuracy
   accbonus = 0
   will_hit = rand(100) < (accuracy+accbonus)
   @backattack,@sideattack,@baddir = getdirissues(target,user)
   
   
   
   
   
     if move.category == 0 && distance==1
	 
	 
	 
	 
	 
	    pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	 
	 
	 
	 
	 
    if will_hit==true
       is_hitting(user,target,move)
	    
		event.angry_at=user
    else
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end


	 
	 
	 
	 
	 
	 
     
	 elsif move.category == 0 && distance>1
	 
	 
	 
	    pbMessage("\\ts[]" + (_INTL"#{pokemon.name} is too far away to use #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	    
	 elsif move.category == 1
	 
	 
	 
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} is gathering energy!\\wtnp[10]"))
	  timepass = 0
	  loop do 
        timepass+=1

	    break if timepass > 29
	  end
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	 
    if will_hit==true
       is_hitting(user,target,move)
		event.angry_at=user
    else
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end


	 
	 
	 elsif move.category == 2
    if will_hit==true
	  if doesStatus?(move)
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	  if will_hit==true
	  if target.status_turns.nil?
		 target.status_turns=0
		end
		target.status_turns-=1 if  target.status_turns>0
		if target.status_turns==0
		 target.status=:NONE
		end
	 applyStatus(move,pokemon,target)
	  end
	  else
	  pbMessage("\\ts[]" + (_INTL"#{move.name} has not been implemented!\\wtnp[10]"))
	  return
	  end
	 end
	 end



   else
   
   
   
   
   
     raise _INTL("Could not add \"{1}\".", pokemon)
	 
	 
	 
   end
 
	 target.remaining_steps+=1 if target.remaining_steps
end




end
#===============================================================================
# Bosses
#===============================================================================
class OverworldCombat #Bosses

 def get_current_action(boss)
   case boss
    when "Jorm"
      choice = rand(300)
      if choice < 50
	    return :MOVESET
	  elsif choice > 100 && choice < 151
	    return :MAGNITUDE
	  elsif choice > 150 && choice < 201
	    return :EARTHQUAKE
	  else
	    return :RUSH
	  end
   end
 
 end


def bossfight(event,boss)
	 event.remaining_steps=9999
update
add_rule("No Player Damage")
add_rule("Catchless")
add_rule("Only-One-Mon")
 case boss
   when "Jorm" || 'Jorm'
    boss_jorm(event,boss)
 end

pkmn = event.pokemon
@turn+=1
status_checks(event)
end

def boss_jorm(event,boss)
  @track = getTracks
  if @turn==0
   choice = :RUSH
  else
   choice = get_current_action(boss)
  end
   if event.pokemon.hp<=event.pokemon.totalhp/2
   
	  $game_temp.encounter_type = $game_temp.encounter_type
	  $PokemonGlobal.nextBattleBGM = "002-Battle02x"
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  setBattleRule("cannotRun")
	  setBattleRule("weather", :Sandstorm)
	  setBattleRule("setStyle")
	  setBattleRule("disablepokeballs")
	  setBattleRule("canLose")
	  setBattleRule("outcome", 90)
	  pbSingleOrDoubleWildBattle($game_map.map_id, event.x, event.y, event.pokemon)
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
	  
	  event.opacity = 0
      pbMessage(_INTL("You feel a faint energy fill your body, before it subsides, but you feel lighter than before."))
	  $player.playerstaminamod += 15.0
      $player.playermaxstamina = $player.playermaxstamina.to_f
      $player.playermaxstamina += $player.playerstaminamod
	  $game_variables[234]+=1 if $game_switches[1176]==false #Beaten Bosses
	  $game_switches[1176]=true #STONE TEMPLE BOSS.
	  $game_switches[301]=true #Dog Trio
	  $game_switches[302]=true #Latis + Lugia
	  $game_variables[255]+=1  #Abilities
	  $game_switches[76]=true #EARTHQUAKES
	  @bossesArrayTimer = {} if @bossesArrayTimer.nil?
	  @bossesArrayTimer["Temperate Shore"] = 12400
      event.removeThisEventfromMap
   else
   case choice
    when :RUSH
	  boss_rush(event)
    when :MOVESET
	  ov_combat_loop
    when :MAGNITUDE

	  use_defined_move(event,:MAGNITUDE)
    when :EARTHQUAKE
	 distances = []
	  use_defined_move(event,:EARTHQUAKE)
   
   
   end
  
   end
end


def use_defined_move(event,move)

	 @player_stuff.each do |event|
	 distances << pbDetectTargetPokemon(@opponent,event)
	 end
     minimum = distances.min
     max_index = distances.index(minimum)
     target = @player_stuff[max_index]
     distance = distances[max_index]
   move2 = 0
   for i in 0...4
    move2 = event.pokemon.moves[i] if event.pokemon.moves[i].id==move
  end
  for i in 0...4
    move2 = event.pokemon.moves2[i] if event.pokemon.moves2[i].id==move
  end
	  move_physical_close(event,target,move2)
  
end


def getEventLeftRight(event, otherEvent)
  sx = 0
  sy = 0
  if $map_factory
    relativePos = $map_factory.getThisAndOtherEventRelativePos(otherEvent, event)
    sx = relativePos[0]
    sy = relativePos[1]
  else
    sx = event.x - otherEvent.x
    sy = event.y - otherEvent.y
  end
  sx += (event.width - otherEvent.width) / 2.0
  sy -= (event.height - otherEvent.height) / 2.0
  return if sx == 0 && sy == 0
  if sx==-1
     return true
  elsif sx==1
     return true
  elsif sy==-1
     return true
  elsif sy==1
     return true
  end
   return false
end

def boss_attack_mid_rush(attacker,targets)
  loop do
   move = chooseMove(1)
    break if move.category == 0
  end
  
  
   targets.each do |target|
    if target.y != attacker.y+1
	  name = target.type.name
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} whipped at #{name}!\\wtnp[10]"))
	  dir = staminaManagement(attacker,target) if target == $game_player
	  dir = inputDetection(attacker,target) if target != $game_player
		if can_move_there?(attacker,dir)
	     pbMoveRoute(target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) #PBMoveRoute::Wait, 2
		 if target == $game_player
	     if advanced_shoes2(target)
	         decreaseStamina(20)
		  elsif default_sta2(target)
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			  pbExclaim(target,48)
	         offensive_turn_finishing(attacker,target,move)
		  end
         else
	         offensive_turn_finishing(attacker,target,move,50)
		 end
        else
	     offensive_turn_finishing(attacker,target,move)
        end

    else
	  name = target.type.name
	  pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} barreled through #{name}!\\wtnp[10]"))
    end
   end
	
	
	
	
	
	
	
end









def move_to_coordinates_attack(event,nux,nuy)
  maxsize = [$game_map.width, $game_map.height].max
  return if !pbEventCanReachCoordinates?(event, nux, nuy, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_the_coordinate(nux,nuy)
    break if event.x == x && event.y == y
	 pkmnbeside = getEventLeftRight(event, @pokemona) if !@pokemona.nil?
	 playbeside = getEventLeftRight(event, $game_player)
	 targets << $game_player if playbeside
	 targets << @pokemona if pkmnbeside && !@pokemona.nil?
	 boss_attack_mid_rush(targets)
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
end










def boss_rush(event)
@backattack,@sideattack,@baddir = getdirissues
curTrack = 0
@track.each_with_index do |track,index|
 if track == [@opponent.x,@opponent.y]
   curTrack = index
   break
 end
end

if @change_move_direction==false
  
  
  
   if curTrack+1 > @track.length
    nuindex = curTrack-1
	@change_move_direction=true
   else
    nuindex= curTrack+1
   end
   
   
   
   
  else
  

   if curTrack-1 < 0
    nuindex = curTrack+1
	@change_move_direction=false
   else
    nuindex= curTrack-1
   end
  
  
  end
  
 targetspaces = @track[nuindex]
  loop do
  if [@opponent.x,@opponent.y]!= @track[nuindex]
    move_to_coordinates_attack(event,@track[nuindex][0],@track[nuindex][1])
  else
    
	break
    end
  end 

 end



 
  

end
#===============================================================================
# User
#===============================================================================
class OverworldCombat
def autobattle(attacker) 
   
   if addParticipant(attacker)
   target = @opponent
   distance = pbDetectTargetPokemon(attacker,target)
   opponentChoice(attacker,target,distance)
   elsif @participants.include?(attacker)
   target = @opponent
   distance = pbDetectTargetPokemon(attacker,target)
   opponentChoice(attacker,target,distance)
   end
    pkmn = @opponent.pokemon
    @turn+=1
    status_checks(@opponent)
end

def doesithitfam(event,item,dir)
         pkmn = event.pokemon
        hit_rate=hitcalc(item,pkmn)
        hit_rate+=2 if event.direction == $game_player.direction
        hit_rate+=1 if event.direction == 4 || 6 && $game_player.direction == 8 || 2
		randhit = rand(8)
        return randhit<=hit_rate

 end

   
 #
#when 2 then event.move_down
#when 4 then event.move_left
#when 6 then event.move_right
#when 8 then event.move_up
  def fainted_check(event)
    pkmn = event.pokemon
    if pkmn.fainted?
     event.removeThisEventfromMap
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
	 return true
	else
	 return false
	end
  
  end

  def hitcalc(ball,pkmn)
    x = pkmn.speed
    pkmn.bait_eaten=0 if pkmn.bait_eaten.nil?
	x -= pkmn.bait_eaten
    x = x.floor
    x = 1 if x < 1
    return 99 if pkmn.status == :SLEEP || pkmn.status == :FROZEN
	return 99 if $DEBUG && Input.press?(Input::CTRL)
    y = x-($player.shoespeed/2)
    numShakes = 0
    4.times do |i|
      numShakes += 1 if rand(75) > y
    end
    return numShakes
  end
  

  def capturecalc(event,ball,dir)
    pkmn = event.pokemon
    catch_rate = pkmn.species_data.catch_rate if !catch_rate
      if !pkmn.species_data.has_flag?("UltraBeast") || ball == :BEASTBALL
      catch_rate = OverworldPBEffects.modifyCatchRate(ball, catch_rate, pkmn)
    else
      catch_rate /= 10
    end
	a = pkmn.totalhp
    b = pkmn.hp
    x = (((3 * pkmn.totalhp) - (2 * pkmn.hp)) * catch_rate.to_f) / (3 * pkmn.totalhp)
    # Calculation modifiers
    if pkmn.status == :SLEEP || pkmn.status == :FROZEN
      x *= 2.5
    elsif pkmn.status != :NONE
      x *= 1.5
    end
    if Input.repeat?(Input::ACTION)
      x *= 1.2
    end 
	   if pkmn.bait_eaten.nil?
	     pkmn.bait_eaten=0
	   end
	x += pkmn.bait_eaten
    x = x.floor
    x = 1 if x < 1
    return 99 if x >= 255 || OverworldPBEffects.isUnconditional?(ball, pkmn)
    y = (65_536 / ((255.0 / x)**0.1875)).floor
    if Settings::ENABLE_CRITICAL_CAPTURES
      dex_modifier = 0
      numOwned = $player.pokedex.owned_count
      if numOwned > 600
        dex_modifier = 5
      elsif numOwned > 450
        dex_modifier = 4
      elsif numOwned > 300
        dex_modifier = 3
      elsif numOwned > 150
        dex_modifier = 2
      elsif numOwned > 30
        dex_modifier = 1
      end
      dex_modifier *= 2 if $bag.has?(:CATCHINGCHARM)
      c = x * dex_modifier / 12
      # Calculate the number of shakes
      if c > 0 && pbRandom(256) < c
        criticalCapture = true
        return 4 if pbRandom(65_536) < y
        return 0
      end
    end
    numShakes = 0
    4.times do |i|
      break if numShakes < i
      numShakes += 1 if rand(65_536) < y
    end
	numShakes+=1 if event.direction == [2,4,6,8][dir]
	return 0 if @battle_rules.include?("Catchless")
    return numShakes
  end
  
  def status_checks(event)
    pkmn = event.pokemon
  	if pkmn.status_turns.nil?
		 pkmn.status_turns=0
	end
	pkmn.status_turns-=1 if  pkmn.status_turns>0
	if pkmn.status_turns==0 && pkmn.status!=:NONE
	 pkmn.status=:NONE
	 if event.movement_type==:IMMOBILE
	   makeAggressive(event)
	 end
	end
	  return fainted_check(event)
  end  

  def player_action(event,item,dir)
  
   pbSEPlay("smeck")
   if item.is_a? Symbol
   if !item.is_a? String
    item_data=GameData::Item.get(item)
	end
   end
	hit = doesithitfam(event,item,dir)
	event.times_not_attacking+=1 if hit
	punch(event) if item=="Punch" && hit && !@battle_rules.include?("No Player Damage")
	if !item_data.nil?
    dartly_actions(event,item,dir) if item_data.is_dart? && hit
    weaponly_actions(event,item) if item_data.is_weapon? && hit
    snatcher(event) if item==:SNATCHER && hit
	end
    if !hit
	  pbMessage("\\ts[]" + (_INTL"#{$player.name} missed!\\wtnp[10]"))
      pbSEPlay("Miss")
	   $player.punch_cooldown=5
	else
	   $player.punch_cooldown=60
	end
    @turn+=1
    status_checks(event)
	return
  end
  
  def capture_calcs(target,ball,dir)
     pkmn = target.pokemon
     catch_rate=capturecalc(target,ball,dir)
	 randcatch = rand(9)+2
	  return randcatch<=catch_rate
  end
  
  def dartly_actions(event,item)
   pkmn = event.pokemon
       case item
    when :POISONDART
   if pkmn && (pkmn.status != :NONE || !pkmn.pbHasType?(:STEEL) || !pkmn.hasAbility?(:CORROSION))
     pkmn.status=:POISON
	   if pkmn.status_turns.nil?
	     pkmn.status_turns=0
	   end
	     pkmn.status_turns=(rand(4)+1)
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} has been poisoned!\\wtnp[10]"))
		pbSEPlay("FollowEmote_Poison")
   end
    when :SLEEPDART
 ability1=GameData::Ability.try_get(:INSOMNIA)
 ability2=GameData::Ability.try_get(:VITALSPIRIT)
  if pkmn.status != :NONE && (pkmn.ability==ability1 || pkmn.ability==ability2)
  else
     pkmn.status=:SLEEP
	   if pkmn.status_turns.nil?
	     pkmn.status_turns=0
	   end
	     pkmn.status_turns=(rand(4)+1)
	     makeSleep(event)
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} has been put to sleep!\\wtnp[10]"))
  end
    when :PARALYZDART
 itemname = GameData::Item.get(item).name
  if pkmn.status != :NONE && pkmn.pbHasType?(:GROUND)
  else
     pkmn.status=:PARALYSIS
	 makeParalyzed(event)
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} has been paralyzed!\\wtnp[10]"))
  end
    when :ICEDART
  if pkmn.status != :NONE  && pkmn.pbHasType?(:ICE)
  else
     pkmn.status=:FROZEN
	 makeFrozen(event)
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} has been frozen!\\wtnp[10]"))
  end
    when :FIREDART
 itemname = GameData::Item.get(item).name
  if pkmn.status != :NONE && pkmn.pbHasType?(:FIRE)
  else
     pkmn.status=:BURN
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} has been set ablaze!\\wtnp[10]"))
  end

 end

		event.angry_at=$game_player
  end
  def weaponly_actions(event,item)
     pkmn = event.pokemon
	 if !@battle_rules.include?("No Player Damage")
     case item
	 
	 when :MACHETE
	   machete(event,($player.playerstamina/2).to_i,($player.playermaxstamina/2).to_i)
     when :STONE
	  makeAggressive(event)
      damagePokemon(event,((rand(2)+4)))
	  if pkmn.status==:SLEEP
	    pkmn.status=:NONE
	  end
	  pbSEPlay("Battle damage normal")
	  
	  
	 when :BAIT
        event.remaining_steps -= 1
	    pkmn.bait_eaten=0 if pkmn.bait_eaten.nil?
	    pkmn.bait_eaten+=1
	    pkmn.bait_eaten=4 if pkmn.bait_eaten>4
	    pkmn.hp=pkmn.hp+(rand(20)+1)
		pbSEPlay("eat")
	 
	 
     when :STONEPICKAXE
	   machete(event,($player.playerstamina/3).to_i,($player.playerstamina/6).to_i)
     when :IRONPICKAXE
	   machete(event,($player.playerstamina/3).to_i,($player.playerstamina/5).to_i)
     when :STONEAXE
	   machete(event,($player.playerstamina/3).to_i,($player.playerstamina/6).to_i)
     when :IRONAXE
	   machete(event,($player.playerstamina/3).to_i,($player.playerstamina/5).to_i)
     when :STONEHAMMER
	   machete(event,($player.playerstamina/3).to_i,($player.playerstamina/6).to_i)
     when :IRONHAMMER
	   machete(event,($player.playerstamina/3).to_i,($player.playerstamina/5).to_i)
     when :POLE
	   machete(event,($player.playerstamina/4).to_i,($player.playerstamina/8).to_i)
	 
	 
	 
	 end
     else
	  pbMessage("\\ts[]" + (_INTL"#{$player.name}'s blows seem to be doing nothing!\\wtnp[10]"))
	 
	 end
    
		event.angry_at=$game_player
  end
  def machete(event,randmt,flat)
   pkmn = event.pokemon
     injury = ((rand(randmt)+flat)+$player.equipmentatkbuff)
	  if rand(100)<20
	   injury*=2
		pbSEPlay("Battle damage super")
	  else
		pbSEPlay("Battle damage normal")
	  end

      damagePokemon(event,injury.to_i)
	  if pkmn.status==:SLEEP
	    pkmn.status=:NONE
	  end
      event.remaining_steps += 1
	  makeAggressive(event)
  
  
  end

  def snatcher(event)
	return false if @battle_rules.include?("Theftless")
   pkmn = event.pokemon
     decreaseStamina(4)
     if pbItemThieving(pkmn)
		pbSEPlay("Mining found all")
	     makeAggressive(event)
		event.angry_at=$game_player
	 end
  end
  def punch(event)
   pkmn = event.pokemon
     injurya=rand(2)+4
	  injuryb= ((pkmn.level/4).ceil).to_i
	  if injuryb<1
	   injuryb = 1
	  end
	  injuryc= $player.equipmentatkbuff.to_i
     injury = (injurya+injuryb)+injuryc
	  if rand(100)<20
	   injury*=2
		pbSEPlay("Battle damage super")
	  else
		pbSEPlay("Battle damage normal")
	  end
       puts injury
      damagePokemon(event,injury)
	    puts "#{event.type.name}: #{event.type.hp}/#{event.type.totalhp}"
	  if pkmn.status==:SLEEP
	    pkmn.status=:NONE
	  end
       event.remaining_steps += 1
	  makeAggressive(event)
		event.angry_at=$game_player
  
  
  end


def add_rule(rule)
 if @battle_rules.include?(rule)
 else
 @battle_rules << rule
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




def makeAggressive(event)
makeAggressiveAtPokemon(event,$game_player)
end

def makeExtraAggressive(event)
 makeAggressive(event)
end

def makeAggressiveAtPokemon(event,target)
return if $game_temp.bossfight==true
return if event.pokemon.aggressive==true && event.pokemon.chasing == true 
return if (event.pokemon.status == :SLEEP || event.pokemon.status == :FROZEN)
event.pokemon.aggressive=true
event.pokemon.chasing = true 
event.movement_type = :CHASE 
event.angry_at = target
#event.event.move_frequency += 1

$scene.spriteset.addUserAnimation(VisibleEncounterSettings::AGG_ANIMATIONS[0],event.x,event.y,true,1)




end


EventHandlers.add(:on_step_taken, :respawn_bosses,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
	next if event!=$game_player
	$PokemonGlobal.bossesArrayTimer = {} if $PokemonGlobal.bossesArrayTimer.nil?
   $PokemonGlobal.bossesArrayTimer.keys.each do |key|
    $PokemonGlobal.bossesArrayTimer[key]-=1
    if $PokemonGlobal.bossesArrayTimer[key]==0
	    $PokemonGlobal.bossesRefightAmt == {} if $PokemonGlobal.bossesRefightAmt.nil?
	    $PokemonGlobal.bossesRefightAmt[key]=0 if $PokemonGlobal.bossesRefightAmt[key].nil?
	    $PokemonGlobal.bossesRefightAmt[key]+=1
	    announce_boss(key)
	end
   end
  }
)
  
  def boss_timers
  
  maps = {}
  maps["Temperate Shore"] = [5,4,243,300,7,349,350,8,9,13,45,54,47,282,44,68]
  maps["Temperate Highlands"] = [16,24,31,19,30,29,28,17]
  maps["Temperate Marsh"] = [33,34,35,109,26,218,233]
  maps["Frigid Highlands"] = [36,84,86,110,140,44,68]
  maps["S.S Glittering"] = [101,102,103,116,117,118,119,120,121,122,123,125,126,127,128,129,124]
  maps["Deep Caves"] = [197,163,211]
  maps["Tropical Coast"] = [111,130,131,158,138,132,159,142,133,160,161,134]
  maps["Temperate Ocean"] = [48,62,38,39,58,59,57,60,61,53,234,235,236,42,144,137,43,385,387,392,396,397]
  maps["Deep Forest"] = [200,201,204,202,203,244,205]
  maps["Northern Highlands"] = [207,208,157,237,238,313,315,311,312,209]
  maps["Western Shore"] = [205,295,296,308,302,310,307,309]
  maps["Western Temperate"] = [318,319,320,323,325,326,330,331,327,328,329]
  maps["Western Caves"] = [332,217,22,2]
  maps["Western Jungle"] = [338,354,355,356,357]
  maps["Oil Tanker"] = [141,143]
  maps["Ravine"] = [81]
  maps["Temperate Shore"] = {}
  maps["Temperate Shore"] = {}
  maps["Temperate Shore"] = {}
	$PokemonGlobal.bossesArrayTimer = {} if $PokemonGlobal.bossesArrayTimer.nil?
   $PokemonGlobal.bossesArrayTimer.keys.each do |key|
      next if maps[key].include?($game_map.map_id)
    $PokemonGlobal.bossesArrayTimer[key]-=1
    if $PokemonGlobal.bossesArrayTimer[key]==0
	    $PokemonGlobal.bossesRefightAmt == {} if $PokemonGlobal.bossesRefightAmt.nil?
	    $PokemonGlobal.bossesRefightAmt[key]=0 if $PokemonGlobal.bossesRefightAmt[key].nil?
	    $PokemonGlobal.bossesRefightAmt[key]+=1 
	    announce_boss(key)
	end
  
  end
  end
 def announce_boss(key)
   case key
    when "Temperate Shore"
      pbMessage(_INTL("A New Lord of the Temperate Shores has risen!"))
	  $game_switches[76]=false
    when "Temperate Highlands"
      pbMessage(_INTL("A New Lord of the Temperate Highlands has risen!"))
	  $game_switches[83]=false
    when "Temperate Marsh"
      pbMessage(_INTL("A New Lord of the Temperate Marsh has risen!"))
	  $game_switches[77]=false
    when "Frigid Highlands"
      pbMessage(_INTL("A New Lord of the Frigid Highlands has risen!"))
	  $game_switches[79]=false
    when "Temperate Ocean"
      pbMessage(_INTL("A New Lord of the Temperate Ocean has risen!"))
	  #$game_switches[81]=false
    when "S.S Glittering"
      pbMessage(_INTL("A New Lord of the Wreckage has risen!"))
	  $game_switches[81]=false
     
   
   
   end
 
 end

 def check_boss(key)
 $PokemonGlobal.bossesArrayTimer = {}  if $PokemonGlobal.bossesArrayTimer.nil?
  $PokemonGlobal.bossesArrayTimer[key] = 0 if $PokemonGlobal.bossesArrayTimer[key].nil?
   return $PokemonGlobal.bossesArrayTimer[key]<1
 
 end
 
  def spawn_boss(key)
    case key
    when "Temperate Shore"
    when "Temperate Highlands"
    when "Temperate Swamp"
    when "Frigid Highlands"
    when "Temperate Ocean"
    end
  end
 
  
EventHandlers.add(:on_step_taken, :overworldpkmnpoison,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
	next if !event.is_a?(Game_PokeEvent) && !event.is_a?(Game_ObjectEvent)
	next if !event.pokemon.is_a?(Pokemon)
	pkmn=event.pokemon
	   if pkmn.status==:SLEEP && $game_temp.bossfight!=true
        event.movement_type = :IMMOBILE if event.movement_type != :IMMOBILE
	   end
	   if pkmn.status==:FROZEN && $game_temp.bossfight!=true
        event.movement_type = :IMMOBILE if event.movement_type != :IMMOBILE
	   end
		if pkmn.status==:BURN
		  dmg = (Settings::MECHANICS_GENERATION >= 7) ? pkmn.totalhp / 16 : pkmn.totalhp / 8
          dmg = (dmg / 2.0).round if pkmn.hasAbility?(:HEATPROOF)
		  pkmn.hp-=dmg
		  if pkmn.fainted?
		  
        event.removeThisEventfromMap
        pbPlayerEXP(pkmn)
        pbHeldItemDropOW(@pkmn,true)
		  
		  end
		end
		if pkmn.status==:POISON
		dmg = pkmn.totalhp / 8
		 if pkmn.hp-dmg>1
		  pkmn.hp-=dmg
		 end
		end

  }
)