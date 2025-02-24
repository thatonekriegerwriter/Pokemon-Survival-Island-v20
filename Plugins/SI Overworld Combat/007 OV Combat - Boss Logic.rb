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
return if status_checks(event)
	 event.remaining_steps=9999
add_rule("Catchless")
 case boss
   when "Jorm" || 'Jorm'
    add_rule("No Player Basics")
    add_rule("Only-One-Mon")
    boss_jorm(event,boss)
 end

pkmn = event.pokemon
@turn+=1
end

def boss_jorm(event,boss)
  @track = getTracks if @track.empty?
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
	  $player.playerstaminamod += 25.0
      $player.playermaxstamina = $player.playermaxstamina.to_f
      $player.playermaxstamina += $player.playerstaminamod
	  $game_variables[234]+=1 if $game_switches[1176]==false #Beaten Bosses
	  $game_switches[1176]=true #STONE TEMPLE BOSS.
	  $game_switches[301]=true #Dog Trio
	  $game_switches[302]=true #Latis + Lugia
	  $game_switches[76]=true #EARTHQUAKES
	  reset_rules
      $player.able_party.each do |pkmn|
        endexp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
		addexp = endexp-pkmn.exp-pkmn.stored_exp
		pkmn.stored_exp+=addexp
        pbDoLevelUps(pkmn)
      end
	  $PokemonGlobal.bossesArrayTimer = {} if @bossesArrayTimer.nil?
	  $PokemonGlobal.bossesArrayTimer["Temperate Shore"] = 12400
      event.removeThisEventfromMap
   else
   case choice
    when :RUSH
	  boss_rush(event)
    when :MOVESET
	  ov_combat_loop(event)
    when :MAGNITUDE

	  use_defined_move(event,:MAGNITUDE)
    when :EARTHQUAKE
	 distances = []
	  use_defined_move(event,:EARTHQUAKE)
   
   
   end
  
   end
end


def use_defined_move(attacker,move)

	 get_player_and_allies.each do |event|
	 distances << pbDetectTargetPokemon(attacker,event)
	 end
     minimum = distances.min
     max_index = distances.index(minimum)
     target = get_player_and_allies[max_index]
     distance = distances[max_index]
   move2 = 0
   for i in 0...4
    move2 = attacker.pokemon.moves[i] if attacker.pokemon.moves[i].id==move
  end
  for i in 0...4
    move2 = attacker.pokemon.moves2[i] if attacker.pokemon.moves2[i].id==move
  end
	  move_physical_close(event,target,move2,nil,nil)
  
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
   move = :TACKLE
   times = 0
  loop do
   update_package
   move3 = chooseMove(attacker,targets[0],1)
   if move3.category == 0
    move = move3
    break 
   end
   if times > 3
    break 
   end
    times+=1
  end
  
  
   targets.each do |target|
    update_package
    if target.y != attacker.y+1
	  name = target.type.name
	  sideDisplay("#{attacker.pokemon.name} whipped at #{name}!")
	  offensive_turn_finishing(attacker,target,move,1)

    else
	  name = target.type.name
	  sideDisplay("#{attacker.pokemon.name} barreled through #{name}!")
	  offensive_turn_finishing(attacker,target,move,1)
    end
   end
	
	
	
	
	
	
	
end









def move_to_coordinates_attack(event,nux,nuy)
  targets = []
  maxsize = [$game_map.width, $game_map.height].max
   potatopotatotomatotomato = calc_path2(event,[nux, nuy])
  return if potatopotatotomatotomato==false
    x = event.x
    y = event.y
    event = get_event_from_id(event) if event.is_a?(Integer)
	
    moveroute = calc_path(event,[nux, nuy])
    return if nux == x && nuy == y
	moveroute.each do |move|
     update_package
	 pbAStarMoveRoute(event, [move])
	 targets = who_am_i_hitting2(event)
	 boss_attack_mid_rush(event,targets)
    break if nux == x && nuy == y
	end

end










def boss_rush(event)
curTrack = 0
@track.each_with_index do |track,index|
 if track == [event.x,event.y]
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
   
     update_package
  if [event.x,event.y]!= @track[nuindex]
    move_to_coordinates_attack(event,@track[nuindex][0],@track[nuindex][1])
  else
    
	break
    end
  end 

 end




def get_events_in(move_distance,cur_x,cur_y)
  results = []
  return results if move_distance.nil?
  return results if cur_x.nil?
  return results if cur_y.nil?
  $game_temp.preventspawns=true
  # Checking horizontal and vertical movements
  (-move_distance..move_distance).each do |i|
    if cur_x != cur_x + i && cur_y != cur_y + i
	
     event = $game_map.check_event(cur_x + i,cur_y + i)
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
     event = $game_map.check_event(cur_x + i,cur_y + i)
	 if event.is_a?(Integer) && event!=0
	 results << event
	 end
    
	end
  end
  end

  $game_temp.preventspawns=false


  return results
end



 
  

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
 