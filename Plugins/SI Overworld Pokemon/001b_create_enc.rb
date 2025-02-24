
class Game_Player < Game_Character
  def pbCheckEventTriggerFromDistance(triggers)
    ret = pbTriggeredTrainerEvents(triggers)
    ret.concat(pbTriggeredCounterEvents(triggers))
    ret.concat(pbTriggeredSurroundingEvents(triggers))
    return false if ret.length == 0
    ret.each do |event|
      event.start
    end
    return true
  end
  def force_start_event(event)
      event.start
  end
  def pbCheckEventTriggerFromDistanceMoving(triggers)
    ret = pbTriggeredSurroundingEvents(triggers)
    return if ret.length == 0
    ret.each do |event| 
	   next if !event.is_a?(Game_PokeEvent)
	    if rand(10)<4
      event.battle_timer-=1 if event.battle_timer>0
	#puts "Battle Timer (skip_move): #{event.battle_timer}"
	  end
    end
  end

  def update_event_triggering
    pbCheckEventTriggerFromDistanceMoving([2])
    return if moving?
    # Try triggering events upon walking into them/in front of them
    if @moved_this_frame
      $game_temp.followers.turn_followers
      result = pbCheckEventTriggerFromDistance([2])
      # Event determinant is via touch of same position event
      result |= check_event_trigger_here([1, 2])
      # No events triggered, try other event triggers upon finishing a step
      pbOnStepTaken(result)
    end
    # Try to manually interact with events
    if (Input.trigger?(Input::USE)|| Input.trigger?(Input::MOUSELEFT) ) && !$game_temp.in_mini_update && $game_temp.in_throwing==false
      # Same position and front event determinant
      check_event_trigger_here([0])
      check_event_trigger_there([0, 2])
    end
  end

  def check_event_trigger_touch(dir)
    result = false
    return result if $game_system.map_interpreter.running?
    # All event loops
    x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
    y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
    $game_map.events.each_value do |event|
      next if ![1, 2].include?(event.trigger)   # Player touch, event touch
      # If event coordinates and triggers are consistent
      next if !event.at_coordinate?(@x + x_offset, @y + y_offset)
      if event.name[/(?:sight|trainer)\((\d+)\)/i]
        distance = $~[1].to_i
        next if !pbEventCanReachPlayer?(event, self, distance)
      elsif event.name[/counter\((\d+)\)/i]
        distance = $~[1].to_i
        next if !pbEventFacesPlayer?(event, self, distance)
      elsif event.name[/surrounding\((\d+)\)/i]
        distance = $~[1].to_i
        next if !pbPlayerOnOrAroundEvent?(event, self, distance)
      end
      # If starting determinant is front event (other than jumping)
      next if event.jumping? || event.over_trigger?
      event.start
      result = true
    end
    return result
  end

  def pbTriggeredSurroundingEvents(triggers, checkIfRunning = true)
    result = []
    # If event is running
    return result if checkIfRunning && $game_system.map_interpreter.running?
    # All event loops
    $game_map.events.each_value do |event|
      next if !triggers.include?(event.trigger)
      next if !event.name[/surrounding\((\d+)\)/i]
      distance = $~[1].to_i
	   potato = []
	  if !pbPlayerOnOrAroundEvent?(event, self, distance)
	    event.angry_at.each do |target|
		  if pbPlayerOnOrAroundEvent?(event, target, distance)
		   potato << target
		   force_start_event(event) if rand(10)<3
		  end
		end
      next if potato.empty?
	  end
      next if event.jumping? || event.over_trigger?
      result.push(event)
    end
    return result
  end
end



def inputDetection2(enemy,baddir)
    loops = 0
	dir = 0
	pbExclaim($game_player,46)
	sprite = nil
	loop do
    dir = Input.dir4
	Input.update
    Graphics.update
	#pbExclaim($game_player,47)
	if sprite.nil? 
    spriteset = $scene.spriteset($game_map.map_id)
    sprite = spriteset&.addUserAnimation(47, $game_player.x, $game_player.y, false, 2)
	end
    case dir 
	 when 8
	  if  dir == baddir || dir == enemy.direction
	pbExclaim($game_player,48)
	  else
	pbExclaim($game_player,42)
	decreaseStamina(10)
	 pbMoveRoute($game_player, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, true)"]) #PBMoveRoute::Wait, 2
	  end
	
	
	 
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 when 2
	  if dir == baddir || dir == enemy.direction
	pbExclaim($game_player,48)
	  else
	pbExclaim($game_player,44)
	decreaseStamina(10)
	 pbMoveRoute($game_player, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, true)"]) #PBMoveRoute::Wait, 2
	  end
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 when 4 
	  if dir == baddir || dir == enemy.direction
	pbExclaim($game_player,48)
	  else
	pbExclaim($game_player,43)
	decreaseStamina(10)
	 pbMoveRoute($game_player, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, true)"]) #PBMoveRoute::Wait, 2
	  end
	
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 
	 when 6
	 if dir == baddir || dir == enemy.direction
	pbExclaim($game_player,48)
	else
	pbExclaim($game_player,45)
	decreaseStamina(10)
	 pbMoveRoute($game_player, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, true)"]) #PBMoveRoute::Wait, 2
	end
	sprite.dispose
     break
	 else
	loops += 1
	
	
	
	
	
	
	
	end
	
	
	
	
	
	sprite.dispose if loops > 10
	break if loops > 10
	end

  return dir
end


def pbPlayerOnOrAroundEvent?(event, player, distance)
  return false if !event || !player
  left_min_x = right_max_x = top_min_y = bottom_max_y = -1
  # Calculate the area in each of the four cardinal directions
  left_min_x  = event.x - distance
  right_max_x = event.x + distance
  top_min_y   = event.y - distance
  bottom_max_y= event.y + distance
  
  # Check if the player is in line with the event in the left direction
  if player.y == event.y && player.x.between?(left_min_x, event.x - 1)
    return true
  end
  
  # Check if the player is in line with the event in the right direction
  if player.y == event.y && player.x.between?(event.x + 1, right_max_x)
    return true
  end
  
  # Check if the player is in line with the event in the upward direction
  if player.x == event.x && player.y.between?(top_min_y, event.y - 1)
    return true
  end
  
  # Check if the player is in line with the event in the downward direction
  if player.x == event.x && player.y.between?(event.y + 1, bottom_max_y)
    return true
  end
  
  return false
end




def tutorial_fight(key_id)
    event = $game_map.events[key_id]
	 o = event.direction
	 c = $game_player.direction
		backattack = o == c
	sideattack1 = c == 6  && (o == 2 || o == 8)
	sideattack2 = c == 4  && (o == 2 || o == 8)
	 
	       if o == 8
          baddir = 2
          elsif o == 4
           baddir =6
          elsif o == 2
          baddir =8
          elsif o == 6
          baddir =4
          end
	
     pbTurnTowardEvent($game_player,event)
	 pbMessage("\\ts[]" + (_INTL"That #{event.pokemon.name} looks pretty riled up."))
     pbTurnTowardEvent(event,$game_player)
     pbTurnTowardEvent($game_player,event)
	 pbMoveTowardEvent9(event,$game_player)
	 3.times do 
	 
	 pbMoveRoute(event, [PBMoveRoute::ScriptAsync, "move_generic(2, true)"]) #PBMoveRoute::Wait, 2
	 
	 end
	 oldpx = $game_player.x
	 oldpy = $game_player.y
	 oldpkx = event.x
	 oldpky = event.y+1
	 pbMessage("\\ts[]" + (_INTL"It rears back to attack!"))
     pbShowTipCardsGrouped(:BASICCOMBAT)
	 theloop = 0
	 loop do
	 pbWait(10)
	 dir = inputDetection2(event,baddir)
    if dir != 0 && dir != baddir && dir != event.direction && $game_player.can_move_in_direction?(dir)
	     pbMoveRoute(event, [PBMoveRoute::ScriptAsync, "move_generic(2, true)"]) #PBMoveRoute::Wait, 2
	     pbMessage("\\ts[]" + (_INTL"You dodged it!"))
         break
    else
	     pbMessage("\\ts[]" + (_INTL"It seems to have hit you."))
	     pbMessage("\\ts[]" + (_INTL"We can ignore that occurred."))
	     pbMessage("\\ts[]" + (_INTL"Just try again."))
		 $game_player.moveto(oldpx,oldpy)
		 event.moveto(oldpkx,oldpky)
	     theloop += 1
    end
  
    end
	 pbMessage("\\ts[]" + (_INTL"If a POKeMON hits you, you'll take damage!"))
	 pbMessage("\\ts[]" + (_INTL"You will have to use a Potion, or Berries to repair damage, and it repairs slowly over time when you sleep."))
	 pbMessage("\\ts[5]" + (_INTL". . ."))
     pbTurnTowardEvent(event,$game_player)
	 pbMessage("\\ts[]" + (_INTL"The #{event.pokemon.name} rears back again, and fast enough you can't avoid!"))
	  pbMessage("\\ts[]" + (_INTL"#{event.pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, event.x, event.y, event.pokemon)
	  $game_temp.in_safari = false
	  $game_switches[556]=false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
      event.removeThisEventfromMap
	$game_switches[556]=false
  
  
  
end


def createBoss(boss)

case boss

when "Jorm"
pkmn = Pokemon.new(:STEELIX, (20+rand(4)))
pkmn.form = 2
pkmn.learn_move(:STEALTHROCK)
pkmn.learn_move(:BIND)
pkmn.learn_move(:DRACOMETEOR)
pkmn.learn_move(:HYPERBEAM)
pkmn.learn_move2(:EARTHQUAKE)
pkmn.learn_move2(:MAGNITUDE)
pkmn.learn_move2(:AUTOTOMIZE)
pkmn.learn_move2(:IRONTAIL)
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 31
pkmn.iv[:SPECIAL_DEFENSE] = 31
pkmn.iv[:DEFENSE] = 31
pkmn.iv[:SPEED] = 31
pkmn.record_first_moves
pkmn.calc_stats
else
return false
end

$game_temp.bossfight=true

if !$map_factory
 $game_map.spawnPokeBoss(10,11,pkmn,boss,8,2)
else
 mapId = $game_map.map_id
 spawnMap = $map_factory.getMap(mapId)
 spawnMap.spawnPokeBoss(10,11,pkmn,boss,8,2)
end
end

def get_the_nil_class(key_id,map=$game_map.map_id)
  return false if !$game_map.events[key_id].nil?
  return true if $game_map.events[key_id].ov_battle.nil?
  return false
end

def get_the_unnil_class(key_id,map=$game_map.map_id)
  return false if key_id.nil?
  return false if $map_factory.getMap(map).events[key_id].nil?
  return true if !$map_factory.getMap(map).events[key_id].ov_battle.nil?
  return false
end

def manuallyGenerate(x,y,dir,pkmn=nil)
  encounter_type = $PokemonEncounters.find_valid_encounter_type_for_time(:Land, pbGetTimeNow)
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  repel_active = ($PokemonGlobal.repel > 0)
  $PokemonGlobal.creatingSpawningPokemon = true
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  if $PokemonEncounters.allow_encounter?(encounter, repel_active)
    pokemon = pbGenerateWildPokemon(encounter[0],encounter[1]) if pkmn.nil?
    pokemon = pbGenerateWildPokemon(pkmn,encounter[1]) if !pkmn.nil?
    # trigger event on spawning of pokemon
    EventHandlers.trigger(:on_wild_pokemon_created_for_spawning, pokemon)
    pbPlaceEncounter(x,y,pokemon,dir)
    $PokemonEncounters.reset_step_count # added such that your encounter rate resets after spawning of an overworld pokemon 
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
  end
  $PokemonGlobal.creatingSpawningPokemon = false



end
def testPokeSpawn(x,y,dir)
    species = pbChooseSpeciesList
    if species
      params = ChooseNumberParams.new
      params.setRange(1, GameData::GrowthRate.max_level)
      params.setInitialValue(5)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("Set the wild {1}'s level.",
                                          GameData::Species.get(species).name), params)
      if level > 0
	pokemon = Pokemon.new(species, level)
    # trigger event on spawning of pokemon
    EventHandlers.trigger(:on_wild_pokemon_created_for_spawning, pokemon)
    pbPlaceEncounter(x,y,pokemon,dir)
    $PokemonEncounters.reset_step_count # added such that your encounter rate resets after spawning of an overworld pokemon 
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
      end
    end

end
def reset_event_functionality_timer
     event = pbMapInterpreter.get_self
 if Input.press?(Input::CTRL) && $DEBUG
    pbSetSelfSwitch(event.id,"A",false)
 end
end
  def spawnPot
     event = pbMapInterpreter.get_self
     x = event.x
	  y = event.y
     if pbPlaceObject(x,y,"OvPot")
	    return true
	  end
    return false
  end
  def place_patroller(dungeon,room,patroller)
   $game_temp.cur_spawning==true
   return false if $game_temp.preventspawns==true
     puts "Fuck me"
     return false if dungeon != $game_temp.cur_dungeon
     return false if room != $game_temp.cur_room
     event = pbMapInterpreter.get_self
      case dungeon
	    when :STONE
	      case room
		    when 0
		     case patroller
			   when 0
			     patrolroute = [[72,21],[65,21],[58,21],[58,14],[65,14],[72,14]] 
			     blockedtiles = [[62,28],[63,28],[64,28],[65,28],[66,28],[67,28],[68,28],[69,28],[65,13]] 
				  species = :GEODUDE
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,0)
			   when 1
			     patrolroute = [[event.x,event.y],[62,18],[61,15],[69,15]] 
			     blockedtiles = [[62,28],[63,28],[64,28],[65,28],[66,28],[67,28],[68,28],[69,28],[65,13]] 
				  species = :GEODUDE_1
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,0,:STILLP)
			   when 2
			     patrolroute = [[72,21],[65,21],[58,21],[58,14],[65,14],[72,14]] 
			     blockedtiles = [[62,28],[63,28],[64,28],[65,28],[66,28],[67,28],[68,28],[69,28],[65,13]] 
				  species = :GEODUDE
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,0,:STILLP,4)
			  end
			 when 1
			 when 2
		     case patroller
			   when 0
			     patrolroute = [[event.x,event.y],[3,11],[3,6],[11,6],[12,11]] 
			     blockedtiles = [[7,15],[7,9],[10,14],[4,14],[7,19],[7,21],[7,4]] 
			     height = 0
			     curPath = 0
			     movementtype = :PATROLLING
				  species = :GEODUDE
				  combatTrial = false
				  alertable = true
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,height,movementtype,curPath,combatTrial,alertable)
			  end
			 when 3
		     case patroller
			   when 0
			     patrolroute = [] 
			     blockedtiles = [[92,54],[99,54],[100,54],[101,54],[102,54],[103,54],[99,50],[100,50],[101,50],[102,50],[103,50],[109,54],[109,47]] 
			     height = 0
			     curPath = 0
			     movementtype = :WANDERP
				  species = :GEODUDE
				  combatTrial = true
				  alertable = true
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,height,movementtype,curPath,combatTrial,alertable)
			   when 1
			     patrolroute = [] 
			     blockedtiles = [[92,54],[99,54],[100,54],[101,54],[102,54],[103,54],[99,50],[100,50],[101,50],[102,50],[103,50],[99,45],[103,45]] 
			     height = 0
			     curPath = 0
			     movementtype = :WANDERP
				  species = :GEODUDE_1
				  combatTrial = true
				  alertable = true
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,height,movementtype,curPath,combatTrial,alertable)
			  end
		    when 4
			 when 5
		     case patroller
			   when 0
			     patrolroute = [] 
			     blockedtiles = [[32,41]] 
			     height = 0
			     curPath = 0
			     movementtype = :WANDERP 
				  species = :GRAVELER
				  combatTrial = false
				  alertable = true
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,height,movementtype,curPath,combatTrial,alertable)
			   when 1
			     patrolroute = [] 
			     blockedtiles = [[32,41]] 
			     height = 0
			     curPath = 0
			     movementtype = :WANDERP 
				  species = :GRAVELER_1
				  combatTrial = false
				  alertable = true
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,height,movementtype,curPath,combatTrial,alertable)
			  end
          when 6
		     case patroller
			   when 0
			     patrolroute = [] 
			     blockedtiles = [] 
			     height = 0
			     curPath = 0
			     movementtype = :PATROLLING 
				  species = :ONIX
				  combatTrial = false
				  alertable = true
			     spawnPatroller(dungeon,patroller,room,event.x,event.y,species,20,patrolroute,blockedtiles,height,movementtype,curPath,combatTrial,alertable,true)
			  end
		  
		   end
	    when :MAGMA
	  
	  
	  end
  
  
  
   $game_temp.cur_spawning==false
  end
  def should_spawn?(room,dungeon)
     return true if dungeon == $game_temp.cur_dungeon && room == $game_temp.cur_room && $game_temp.cur_spawning==false && $game_temp.preventspawns==false
     return false
  
  end
  def spawnPatroller(dungeon,patroller,room,x,y,species=:GEODUDE,level=20,patrolroute=[],blockedtiles=[],height=0,movementtype=:PATROLLING,curPath=0,combatTrial=false,alertable=false,miniboss=false,dir=false)
	pokemon = Pokemon.new(species, level)
   event_id = pbPlaceEncounter(x,y,pokemon,dir)
   puts [x,y].to_s
   puts dungeon
   puts patroller
   puts room
   puts event_id
   if !event_id.nil? && $game_map.events[event_id].is_a?(Game_PokeEvent)
      event = $game_map.events[event_id]
	   pkmn = event.pokemon
     event.pathing = patrolroute
     event.blockedtiles = blockedtiles
     event.cur_path = curPath
     event.movement_type = movementtype
     event.still_timer = rand(5)+5 if movementtype==:STILLP
     event.disable_despawn = true
     event.counter = 7
     event.intelligent = true
     event.height_level = height
	  if combatTrial==true
	   $game_temp.add_to_combat_hash($game_map.map_id,room,event)
	  end 
	  if alertable==true
	   $game_temp.add_to_alert_alert($game_map.map_id,room,patroller,event)
	  end 
	  if miniboss==true
	    $game_temp.miniboss << event
		 event.movement_type_locked=true
		 event.miniboss=true
       event.move_frequency=get_cur_player.move_frequency
       event.barreling=true
       event.move_speed=get_cur_player.move_speed+0.25 
		 modify_miniboss_stats(dungeon,patroller,room,pkmn)
	  end
   end
   
   return true if !event_id.nil?
   return false if event_id.nil?
  end
  def get_miniboss_level(pkmn,level)
   return [2+pbBalancedLevel($player.party),level,pkmn.level].max
  end
  
  def modify_miniboss_stats(dungeon,patroller,room,pkmn)
   
      case dungeon
	    when :STONE
	      case room
		    when 6
		     case patroller
			   when 0 #Stone Temple - Onix Miniboss
			     pkmn.level=get_miniboss_level(pkmn,25)
			     pkmn.item=:FOCUSSASH
              pkmn.nature=:IMPISH
			     pkmn.raw_stat_bonus[:HP]*=1.5
			     pkmn.raw_stat_bonus[:DEFENSE]+=20
			     pkmn.raw_stat_bonus[:SPECIAL_DEFENSE]+=20
			     pkmn.raw_stat_bonus[:SPEED]-=20
			     pkmn.raw_stat_bonus[:SPECIAL_ATTACK]-=10
			     pkmn.calc_stats
			  end
         end
     end
  end

def pbMoveTowardCoordinates(event,nux,nuy)
  maxsize = [$game_map.width, $game_map.height].max
  return if !pbEventCanReachCoordinates?(event, nux, nuy, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_the_coordinate(nux,nuy)
    break if event.x == x && event.y == y
	 while event.moving?

    Graphics.update
    Input.update
    $scene.update
	 
	 
	 end
  end
   return true
end

def pbAlertPatrollers(room,patrollers,map_id=$game_map.map_id)
 return if $game_temp.alert_alert_empty?(map_id,room,patrollers)
  altered = $game_temp.get_alerted(map_id,room,patrollers)
   return if altered.nil?
   altered.each do |event|
    event.angy_at_cur_tar = get_cur_player
	 event.movement_type = :CHASEP
   end
end
###
def hol_up
 while $game_temp.currently_iterating==true
    
  break if $game_temp.currently_iterating==false
 end
end

def disable_a_switch_for_patrollers(dungeon)
   $game_temp.currently_iterating=true
   if false
   case dungeon
     when :STONE
       pbSetSelfSwitch(28,"A",false,12)
	    pbSetSelfSwitch(29,"A",false,12)
	    pbSetSelfSwitch(42,"A",false,12)
	    pbSetSelfSwitch(40,"A",false,12)
	    pbSetSelfSwitch(68,"A",false,12)
	    pbSetSelfSwitch(37,"A",false,12)
	    pbSetSelfSwitch(91,"A",false,12)
	    pbSetSelfSwitch(92,"A",false,12)
		
       pbSetSelfSwitch(53,"A",false,12)
	    pbSetSelfSwitch(25,"A",false,12)
	    pbSetSelfSwitch(87,"A",false,12)
	    pbSetSelfSwitch(81,"A",false,12)
	    pbSetSelfSwitch(88,"A",false,12)
	    pbSetSelfSwitch(12,"A",false,12)
	    pbSetSelfSwitch(78,"A",false,12)
	    pbSetSelfSwitch(79,"A",false,12)
	    pbSetSelfSwitch(89,"A",false,12)
	    pbSetSelfSwitch(61,"A",false,12)
	    pbSetSelfSwitch(60,"A",false,12)
	    pbSetSelfSwitch(62,"A",false,12)
	    pbSetSelfSwitch(63,"A",false,12)
   
   
	    pbSetSelfSwitch(35,"A",false,12)
	    pbSetSelfSwitch(34,"A",false,12)
	    pbSetSelfSwitch(33,"A",false,12)
	    pbSetSelfSwitch(31,"A",false,12)
	    pbSetSelfSwitch(113,"A",false,12)
	    pbSetSelfSwitch(110,"A",false,12)
	    pbSetSelfSwitch(108,"A",false,12)
	    pbSetSelfSwitch(106,"A",false,12)
	    pbSetSelfSwitch(109,"A",false,12)
	    pbSetSelfSwitch(107,"A",false,12)
	    
	    pbSetSelfSwitch(114,"A",false,12)
	    pbSetSelfSwitch(14,"A",false,12)
	    pbSetSelfSwitch(4,"A",false,12)
   
   
	    pbSetSelfSwitch(70,"A",false,12)
	    pbSetSelfSwitch(71,"A",false,12)
	    pbSetSelfSwitch(41,"A",false,12)
	    pbSetSelfSwitch(24,"A",false,12)
   end
   end

   if true
   case dungeon
     when :STONE
       spawnMap = $map_factory.getMap(12)
	    spawnMap.events.each_key do |key|
		   event = spawnMap.events[key]
		   if event.name.include?("ItemPotSpawner") || event.name.include?("temp_patroller") || event.name.include?("doorcloser") || event.name.include?("doorcloser") || event.name.include?("caldoor") || event.name.include?("Trainer")
		    puts event.name
		    puts key
           pbSetSelfSwitch(key,"A",false,12)
		   end
		  end
     	$ExtraEvents.pokemon.each_key do |i|
	     if $ExtraEvents.pokemon[i].map_id==12
	       $ExtraEvents.pokemon.delete(i)
	     end
      end
   end
   end
   pbWait(5)
   $game_temp.currently_iterating=false
end

def get_miniboss_patroller
 return nil if $game_temp.miniboss.empty?
 return $game_temp.miniboss
end

def set_miniboss_route(route,index=nil)
 bosses = get_miniboss_patroller
 return if bosses.nil?
   if index.nil?
  bosses.each do |miniboss|
    miniboss.pathing = route
  end
   else
   bosses[index].pathing = route
  end
end
def pbEventCanReachCoordinates?(event, x, y, distance)
  delta_x = (event.direction == 6) ? 1 : (event.direction == 4) ? -1 : 0
  delta_y = (event.direction == 2) ? 1 : (event.direction == 8) ? -1 : 0
  case event.direction
  when 2   # Down
    real_distance = y - event.y - 1
  when 4   # Left
    real_distance = event.x - x - 1
  when 6   # Right
    real_distance = x - event.x - event.width
  when 8   # Up
    real_distance = event.y - event.height - y
  end
    real_distance.to_i.times do |i|
      return false if !event.can_move_from_coordinate?(event.x + (i * delta_x), event.y + (i * delta_y), event.direction)
    end

  return true
end
class Game_Temp
  attr_accessor :in_temple
  attr_accessor :combat_hash
  attr_accessor :alert_alert
  attr_accessor :miniboss
  attr_accessor :cur_dungeon
  attr_accessor :cur_room
  attr_accessor :currently_iterating
  attr_accessor :cur_spawning

  def cur_spawning
   @cur_spawning = false if @cur_spawning.nil?
   return @cur_spawning
  end

  def currently_iterating
   @currently_iterating = false if @currently_iterating.nil?
   return @currently_iterating
  end
  def in_temple
   @in_temple = false if @in_temple.nil?
   return @in_temple
  end
  def cur_dungeon
   @cur_dungeon = :NONE if @cur_dungeon.nil?
   return @cur_dungeon
  end
  def cur_room
   @cur_room = -1 if @cur_room.nil?
   return @cur_room
  end
  def combat_hash
   @combat_hash = {} if @combat_hash.nil?
   return @combat_hash
  end
  def miniboss
   @miniboss = [] if @miniboss.nil?
   return @miniboss
  end
  def alert_alert
   @alert_alert = {} if @alert_alert.nil?
   return @alert_alert
  end

  def combat_hash_empty?(map_id,room)
   @combat_hash = {} if @combat_hash.nil?
     return if @combat_hash.nil?
     return if @combat_hash[[map_id, room]].nil?
     @combat_hash[[map_id, room]].each_with_index do |event, index|
	    if !defined?(event.pokemon)
          @combat_hash[[map_id, room]][index] = nil
		    next
	    end
		  if event.pokemon.fainted?
       @combat_hash[[map_id, room]][index] = nil
		    next
	     end
     end
     @combat_hash[[map_id,room]].uniq!
     @combat_hash[[map_id,room]].compact!
	  
     return @combat_hash[[map_id,room]].empty?
  end

  def alert_alert_empty?(map_id,room,patroller)
   @alert_alert = {} if @alert_alert.nil?
   return true if @alert_alert[[map_id, room, patroller]].nil?
     @alert_alert[[map_id, room, patroller]].each_with_index do |event, index|
	    if !defined?(event.pokemon)
          @alert_alert[[map_id, room, patroller]][index] = nil
		    next
	    end
		  if event.pokemon.fainted?
       @alert_alert[[map_id, room, patroller]][index] = nil
		    next
	     end
     end
     @alert_alert[[map_id,room, patroller]].uniq!
     @alert_alert[[map_id,room, patroller]].compact!
	  
     return @alert_alert[[map_id,room, patroller]].empty?
  end
  
  def add_to_combat_hash(map_id,room,value)
   @combat_hash[[map_id,room]]=[] if @combat_hash[[map_id,room]].nil?
   @combat_hash[[map_id,room]] << value
  end
  def add_to_alert_alert(map_id,room,patrollers,value)
   @alert_alert = {} if @alert_alert.nil?
   @alert_alert[[map_id,room,patrollers]]=[] if @alert_alert[[map_id,room,patrollers]].nil?
   @alert_alert[[map_id,room,patrollers]] << value
  end
  
  def get_alerted(map_id,room,patrollers)
   @alert_alert = {} if @alert_alert.nil?
     return @alert_alert[[map_id,room,patrollers]]
  end
end
 def pbCheckCombatHash(room)
   return $game_temp.combat_hash_empty?($game_map.map_id,room)
 
 end

class Game_Character
  def move_toward_the_coordinate(x,y)
    sx = @x + (@width / 2.0) - (x)
    sy = @y - (@height / 2.0) - (y)
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
  end


def move_to_another_event(target)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
end


  def move_type_toward_event(target)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    if sx.abs + sy.abs >= 20
      move_random
      return
    end
    case rand(6)
    when 0..3 then move_to_another_event(target)
    when 4    then move_random
    when 5    then move_forward
    end
  end
  
  

  def turn_toward_event(target)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    if sx.abs > sy.abs
      (sx > 0) ? turn_left : turn_right
    else
      (sy > 0) ? turn_up : turn_down
    end
  end
  
end
class Sprite_Character < RPG::Sprite
  attr_accessor :nux
  attr_accessor :nuy

  def nux
    return self.x
  end

  def nuy
    return self.y
  end
  def nux=(value)
    self.x = value
  end

  def nuy=(value)
    self.y = value
  end

end


class Game_Map
  def spawnPokeEvent(x,y,pokemon,dir=false)
	if $game_switches[556]==true
		 @events.each do |event|
	      if event.is_a?(Array)
	       return if event[1].name == "tutorialvanishingEncounter" 
	      else
	       return if event.name == "tutorialvanishingEncounter" 
	      end
	 end
	end
    puts "A"
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    mapId = $game_map.map_id
	 amt = rand(3)+3
    event.name = "vanishingEncounter.surrounding(#{amt})" 
    event.name = "tutorialvanishingEncounter" if $game_switches[556]==true 

    #--- nessassary properties ----------------------------------------
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
	chance = rand(100)
	is_hidden_voltorb = (chance<26 || $PokemonGlobal.in_dungeon==true) && pokemon.species == :VOLTORB
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
	
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
	 fname = "Object Ball" if is_hidden_voltorb
    fname.gsub!("Graphics/Characters/","")
    event.pages[0].graphic.character_name = fname
	
	
    #--- movement of the event --------------------------------
	
	 puts "B"
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].through = false
    event.pages[0].through = true if pokemon.types.include?(:FLYING)
    event.pages[0].always_on_top = true if pokemon.types.include?(:FLYING)
	
	
    event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[0].move_frequency = 4
    event.pages[0].trigger = 2
    event.pages[0].move_type = 3
	
	
	
	if $game_switches[556]==true || is_hidden_voltorb
    event.pages[0].move_type = 0
    event.pages[0].trigger = 0 if is_hidden_voltorb
	else
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement2"]
	
	
    for move in VisibleEncounterSettings::Enc_Movements do
      if pokemon.method(move[0]).call == move[1]
        event.pages[0].move_speed = move[2] if move[2]
        event.pages[0].move_frequency = move[3] if move[3]
      end
    end
    end
	
	
	if $game_switches[556]==true
     Compiler::push_script(event.pages[0].list,sprintf("tutorial_fight(#{key_id})"))
	elsif is_hidden_voltorb
	  create_battle(event,key_id,mapId)
	else
    Compiler::push_script(event.pages[0].list,sprintf("pokeevent_functionality"))
	end
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
	
	
	
	
	
	  puts "C"
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(@map_id, event, pokemon, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.direction = dir if dir!=false
	
	
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end
	
	
	
	  puts "D"
    $ExtraEvents.pokemon[[mapId,key_id]] = StoredEvent.new(mapId,event,pokemon)
	 $ExtraEvents.pokemon[[mapId,key_id]].eventdata = gameEvent
	
	
	if $game_temp.preventspawns==true #|| $game_system.map_interpreter.running?
	 $game_temp.spawnqueue << [gameEvent,event]
	 return nil
	end

	  puts "E"
    @events[key_id] = gameEvent
	
	
	
	
	
	  puts "F"
	
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
	  puts "F"
	$player.pokedex.register(pokemon.species)
    $player.pokedex.set_seen(pokemon.species)
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
	
	
	
	
	
	
	
	
	  puts "G"
	
	
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	 return key_id
  end

 def create_battle(event,key_id,mapId)

	if true
	if true
	 Compiler::push_script(event.pages[0].list,sprintf(" pbStoreTempForBattle()"))
    if $PokemonGlobal.roamEncounter!=nil # i.e. $PokemonGlobal.roamEncounter = [i,species,poke[1],poke[4]]
      parameter1 = $PokemonGlobal.roamEncounter[0].to_s
      parameter2 = $PokemonGlobal.roamEncounter[1].to_s
      parameter3 = $PokemonGlobal.roamEncounter[2].to_s
      $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
      parameter = " $PokemonGlobal.roamEncounter = ["+parameter1+",:"+parameter2+","+parameter3+","+parameter4+"] "
    else
      parameter = " $PokemonGlobal.roamEncounter = nil "
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.roamer_index_for_encounter!=nil) ? " $game_temp.roamer_index_for_encounter = "+$game_temp.roamer_index_for_encounter.to_s : " $game_temp.roamer_index_for_encounter = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonGlobal.nextBattleBGM!=nil) ? " $PokemonGlobal.nextBattleBGM = '"+$PokemonGlobal.nextBattleBGM.to_s+"'" : " $PokemonGlobal.nextBattleBGM = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.force_single_battle!=nil) ? " $game_temp.force_single_battle = "+$game_temp.force_single_battle.to_s : " $game_temp.force_single_battle = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.encounter_type!=nil) ? " $game_temp.encounter_type = :"+$game_temp.encounter_type.to_s : " $game_temp.encounter_type = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    #  - add a branch to check if player can battle water pokemon from ground
    Compiler::push_branch(event.pages[0].list,sprintf(" pbCheckBattleAllowed()"))
    #  - set $PokemonGlobal.battlingSpawnedPokemon = true
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = true"),1)    
    #  - add method pbSingleOrDoubleWildBattle for the battle
	end
    parameter = " pbMessage('\\ts[]' + (_INTL'It was a Voltorb!\\wtnp[15]')) "
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    parameter = "$game_temp.in_safari = true "
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    if !$map_factory
      parameter = " pbSingleOrDoubleWildBattle( $game_map.events[#{key_id}].map.map_id, $game_map.events[#{key_id}].x, $game_map.events[#{key_id}].y, $game_map.events[#{key_id}].pokemon )"
    else
      parameter = " pbSingleOrDoubleWildBattle( $map_factory.getMap("+mapId.to_s+").events[#{key_id}].map.map_id, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].x, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].y, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].pokemon )"
    end
	if true
    parameter = "$game_temp.in_safari = false "
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #   - set $PokemonGlobal.battlingSpawnedPokemon = false
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = false"),1) 
    #  - add a method to reset temporary data to previous state, must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type
    Compiler::push_script(event.pages[0].list,sprintf(" pbResetTempAfterBattle()"),1)
    #  - add method to remove this PokeEvent from map
    if !$map_factory
      parameter = "$game_map.removeThisEventfromMap(#{key_id})"
    else
      mapId = $game_map.map_id
      parameter = "$map_factory.getMap("+mapId.to_s+").removeThisEventfromMap(#{key_id})"
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
	end
   end




 end
 
 
  def spawnPokeBoss(x,y,pokemon,boss,view,dir=false)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    event.name = "vanishingEncounter.surrounding(#{view})" 
    #--- nessassary properties ----------------------------------------
    mapId = $game_map.map_id
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
	 chance = rand(100)
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")
	
	
    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].through = false
    event.pages[0].move_speed = 5
    event.pages[0].move_frequency = 4
    event.pages[0].move_type = 0
    event.pages[0].trigger = 0
	
	
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
      mapId = $game_map.map_id
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type

    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.bossfight($map_factory.getMap("+mapId.to_s+").events[#{key_id}],'#{boss}')"))
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.add_rule('No Player Damage')"))
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.add_rule('Catchless')"))
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.add_rule('Theftless')"))



    Compiler::push_script(event.pages[0].list,sprintf(" pbSetSelfSwitch($map_factory.getMap("+mapId.to_s+").events[#{key_id}], 'A', true)"))
    #  - add the end of branch
	
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
	 event.pages << RPG::Event::Page.new
   
     condition2 = RPG::Event::Page::Condition.new
	 condition2.self_switch_valid  = true
	 condition2.self_switch_ch = "A"
	 event.pages[1].condition = condition2
	 
    event.pages[1].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[1].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[1].through = false
    event.pages[1].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[1].move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
    event.pages[1].move_type = 0
    event.pages[1].trigger = 2
	
	
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type

    Compiler::push_script(event.pages[1].list,sprintf(" $PokemonGlobal.ov_combat.bossfight($map_factory.getMap("+mapId.to_s+").events[#{key_id}],'#{boss}')"))
    #  - add the end of branch
    #  - finally push end command
    Compiler::push_end(event.pages[1].list)
	
	




	
	

	
	
	
	
	
	
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(@map_id, event, pokemon, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.direction = dir if dir!=false
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end
	if $game_temp.preventspawns.nil?
	 $game_temp.preventspawns=false
	end
    if $game_temp.preventspawns==false #&& !$game_system.map_interpreter.running?
    $ExtraEvents.pokemon[[mapId,key_id]] = StoredEvent.new(mapId,event,pokemon)
	 $ExtraEvents.pokemon[[mapId,key_id]].eventdata = gameEvent
	$player.pokedex.register(pokemon)
    $player.pokedex.set_seen(pokemon.species)
    @events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	$player.pokedex.register(pokemon.species)
    $player.pokedex.set_seen(pokemon.species)
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
    else
	 $game_temp.spawnqueue << [gameEvent,event]
	end
  end
 
  def spawnPokeEventForChallenge(x,y,pokemon,spawn_now=false)
    
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
	amt = rand(3)+3
    event.name = "vanishingEncounter.surrounding(#{amt})" 
    #--- nessassary properties ----------------------------------------
	amtofkeysinroom = 0
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id if spawn_now
    event.x = x if spawn_now
    event.y = y if spawn_now
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")

    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].through = false
    event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[0].move_frequency = 4
    event.pages[0].trigger = 2
    event.pages[0].move_type = 3
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement2"]
	
	
	
	
	
	
    for move in VisibleEncounterSettings::Enc_Movements do
      if pokemon.method(move[0]).call == move[1]
        event.pages[0].move_speed = move[2] if move[2]
        event.pages[0].move_frequency = move[3] if move[3]
      end
    end

	
	
	
	
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
      mapId = $game_map.map_id
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type

    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.ov_combat.ov_combat_loop($map_factory.getMap("+mapId.to_s+").events[#{key_id}]) if !$map_factory.getMap("+mapId.to_s+").events[#{key_id}].nil?"))

    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(@map_id, event, pokemon, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end
	
	 return if $PokemonGlobal.cur_challenge.nil?
	 return if $PokemonGlobal.cur_challenge==false
	 if spawn_now==true #&& !$game_system.map_interpreter.running?
	     $game_map.events[key_id] = gameEvent
	     sprite = Sprite_Character.new(Spriteset_Map.viewport,$game_map.events[key_id])
	     $scene.spritesets[$game_map.map_id]=Spriteset_Map.new($game_map) if $scene.spritesets[$game_map.map_id]==nil
	     $scene.spritesets[$game_map.map_id].character_sprites.push(sprite)
	     $PokemonGlobal.cur_challenge.opponent_events<<key_id
		  makeAggressive($game_map.events[key_id]) #if !pkmn.is_aggressive?
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
		  else
	 $PokemonGlobal.cur_challenge.spawn_queue << [pokemon,event]
	   end
	
   # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets



  end


end



class Interpreter
  def command_201
    return true if $game_temp.in_battle
    return false if $game_temp.player_transferring ||
                    $game_temp.message_window_showing ||
                    $game_temp.transition_processing
    # Set up the transfer and the player's new coordinates
    $game_temp.player_transferring = true
    if @parameters[0] == 0   # Direct appointment
      $game_temp.player_new_map_id    = @parameters[1]
      $game_temp.player_new_x         = @parameters[2]
      $game_temp.player_new_y         = @parameters[3]
    else   # Appoint with variables
      $game_temp.player_new_map_id    = $game_variables[@parameters[1]]
      $game_temp.player_new_x         = $game_variables[@parameters[2]]
      $game_temp.player_new_y         = $game_variables[@parameters[3]]
    end
    $game_temp.player_new_direction = @parameters[4]
    @index += 1
    # If transition happens with a fade, do the fade
    if @parameters[5] == 0
      Graphics.freeze
      $game_temp.transition_processing = true
      $game_temp.transition_name       = ""
    end
    $game_temp.preventspawns=false
    return false
  end


end



