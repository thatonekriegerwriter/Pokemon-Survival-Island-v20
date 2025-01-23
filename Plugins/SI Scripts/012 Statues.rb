class PokemonGlobalMetadata
    attr_accessor :active_statues
    attr_accessor :unlocked_classes
    attr_accessor :all_classes
	
	
	def active_statues
	 @active_statues = [] if @active_statues.nil?
	 return @active_statues
	end

	def unlocked_classes
	 @unlocked_classes = [$player.playerclass.id] if @unlocked_classes.nil?
	 return @unlocked_classes
	end

	def all_classes
	  if @all_classes.nil?
	  @all_classes = [:TRIATHLETE,:ACTOR,:EXPERT,:RANGER,:COOK,:BLACKBELT,:COORDINATOR,:ENGINEER,:NURSE,:BREEDER,:COLLECTOR,:GARDENER,:FISHER,:HIKER]
	  end
	 return @all_classes
	end
	
	
end



   def pbUnlockPlayerClass(aclass=nil)
      if aclass.nil?
        options = $PokemonGlobal.all_classes - $PokemonGlobal.unlocked_classes
        $PokemonGlobal.unlocked_classes << options[0] 
	  else
        $PokemonGlobal.unlocked_classes << aclass
	  end
   end

def pbDoLevelUps(pkmn, messages=false)
    expFinal = pkmn.stored_exp + pkmn.exp
    growth_rate = pkmn.growth_rate
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
	learnedmoves = []
	level_cap = pkmn.level_cap
	if level_cap.nil?
    level_cap = $PokemonSystem.level_caps == 0 ? Level_Cap::LEVEL_CAP[$game_system.level_cap] : Settings::MAXIMUM_LEVEL 
	end
	level_cap = Settings::MAXIMUM_LEVEL if $player.is_it_this_class?(:EXPERT,false)
	if pkmn.level == 20 && pkmn.shadowPokemon?
      pbMessage(_INTL("{1} cannot go beyond this level because it is a Shadow Pokemon.", pkmn.name, curLevel)) if messages
    elsif newLevel > level_cap
    elsif newLevel <= curLevel
	
      pbMessage(_INTL("{1} has not gained enough experience to level up.", pkmn.name, curLevel)) if messages
	  return false
	else
	
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp < expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
      tempExp1 = tempExp2
      curLevel += 1
      if curLevel > newLevel
        # Gained all the Exp now, end the animation
        pkmn.calc_stats
        break
      end
      # Levelled up
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
      pkmn.changeHappiness("levelup",pkmn)
      pkmn.changeLoyalty("levelup",pkmn)
      if pkmn.shadowPokemon?
         potato = pkmn.level
         if potato == 12
          if rand(100) <= 5
          pkmn.nature=:HATEFUL
          end
         elsif potato == 13
          if rand(100) <= 10
          pkmn.nature=:HATEFUL
          end
         elsif potato == 14
          if rand(100) <= 15
          pkmn.nature=:HATEFUL
          end
         elsif potato == 15
          if rand(100) <= 20
          pkmn.nature=:HATEFUL
          end
         elsif potato == 16
          if rand(100) <= 25
          pkmn.nature=:HATEFUL
          end
         elsif potato == 17
          if rand(100) <= 30
          pkmn.nature=:HATEFUL
          end
         elsif potato == 18
          if rand(100) <= 35
          pkmn.nature=:HATEFUL
          end
         elsif potato == 19
          if rand(100) <= 40
          pkmn.nature=:HATEFUL
          end
         elsif potato >= 20
          if rand(100) <= 50
          pkmn.nature=:HATEFUL
          end
         else
       end
      end
      pkmn.calc_stats
	  
      moveList = pkmn.getMoveList
      moveList.each { |m| learnedmoves << m[1] if m[0] == curLevel }
   end
      pbMessage(_INTL("{1} grew to Lv. {2}!", pkmn.name, curLevel))
      # Learn all moves learned at this level
	  learnedmoves.each do |move|
	    pbLearnMove(pkmn, move)
	  end
      newspecies=pkmn.check_evolution_on_level_up
          old_item=pkmn.item
          if newspecies
            pbFadeOutInWithMusic(99999){
            evo=PokemonEvolutionScene.new
            evo.pbStartScreen(pkmn,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
          }
          end

  pkmn.stored_exp = 0
    return true
     end




end
def pbCanLevelUp?
    results = [] 
      $player.able_party.each do |pkmn|
           results << pkmn.stored_exp>0
      end
	 
	  if results.all? { |result| result == false }
        pbMessage(_INTL("Your Pokemon have not experienced enough to grow like this."))
		 return false
	  end
		 return true
end

def howmanystatues()
 return $PokemonGlobal.active_statues.length
end



class StatueData
    attr_accessor :event
    attr_accessor :star_pieces
    attr_accessor :health
    attr_accessor :power
    attr_accessor :charging
    attr_accessor :time_last_updated
    attr_accessor :time_recharging
    attr_accessor :evo_stones
    attr_accessor :broken

	
  def initialize(event = nil)
    @event = event if !event.nil?
    @star_pieces = [0,0]
    @health = 20
    @power = 100
    @charging = false
    @evo_stones = []
    @time_last_updated = pbGetTimeNow
    @time_recharging = 0
    @broken = false
  end
  def evo_stones
    @evo_stones = [] if @evo_stones.nil?
    return @evo_stones
  end
  
  def reset 
    @star_pieces = [0,0]
    @health = 20
    @power = 100
    @charging = false
    @time_last_updated = pbGetTimeNow
    @time_recharging = 0
  end

  def update
    return if @health==0
    return if @charging==false
	 return if @broken == true && @power>=100
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated
    return if time_delta <= 0
    @time_recharging += time_delta
	 tps = 1
	 tps = 2 if @broken == true
	time_per_stage = tps * 3600
	return if @time_recharging < time_per_stage
	amt = 1 + (@time_recharging / time_per_stage)
    @time_last_updated = time_now
	@time_recharging-=time_per_stage
	@return if @power+5>175
	 @power +=5
	 if @power>=100 && @broken == true
	    @power=100
	 end
     if @power>175
	   @power=175
	 end
  end
end

def pbTeleportToLocation(loc1=nil,loc2=nil,loc3=nil)
  return false if $game_temp.fly_destination.nil?
  pbFadeOutIn {
    pbSEPlay("OWThunder1")
    $game_temp.player_new_map_id    = $game_temp.fly_destination[0] if loc1.nil?
    $game_temp.player_new_x         = $game_temp.fly_destination[1] if loc2.nil?
    $game_temp.player_new_y         = $game_temp.fly_destination[2] if loc3.nil?
    $game_temp.player_new_map_id    = loc1 if !loc1.nil?
    $game_temp.player_new_x         = loc2 if !loc2.nil?
    $game_temp.player_new_y         = loc3 if !loc3.nil?
    $game_temp.player_new_direction = 2
    $game_temp.fly_destination = nil
    pbDismountBike
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
    yield if block_given?
    pbWait(Graphics.frame_rate / 4)
  }
  pbEraseEscapePoint
  return true
end


def pbReturnTradablePokemon(ableProc = nil, allowIneligible = false)
  chosen = 0
  pbFadeOutIn {
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene, $player.party)
    if ableProc
      chosen = screen.pbChooseTradablePokemon(ableProc, allowIneligible)
    else
      screen.pbStartScene(_INTL("Choose a Pokémon."), false)
      chosen = screen.pbChoosePokemon
      screen.pbEndScene
    end
  }
  if chosen >= 0
    return $player.party[chosen]
  end
end

def pbTeleportStatues1

	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if statue
	if statue.broken==true
	 if statue.power>=100 && statue.charging==false
	    statue.power=0
	    statue.charging=true
	    statue.time_last_updated=pbGetTimeNow
        pbMessage(_INTL("The Spirit Statue has been rebuilt. It will take some time for it to rebuild its power."))
	elsif statue.power==0 && statue.charging==true
     pbMessage(_INTL("The Spirit Statue has been rebuilt. It will take some time for it to rebuild its power."))
	elsif statue.power>=100 && statue.charging==true
     pbMessage(_INTL("The Spirit Statue has finished rebuilding its spiritual energy. It can return to normal use."))
	   $PokemonGlobal.active_statues << $game_map.map_id
	   statue.charging = false
	   statue.broken = false
     pbSetSelfSwitch(this_event.id, "A", true)  
	end  
    elsif statue.charging==true
	 pbMessage(_INTL("The Spirit Statue has been building its spiritual energy. It has charged to #{statue.power}%."))
	 if pbConfirmMessage(_INTL("Touch Statue?"))
	   pbMEPlay("Pokemon Healing")
       $player.heal_party
       $player.heal_self
	   statue.charging = false
	   $PokemonGlobal.active_statues << $game_map.map_id
     pbSetSelfSwitch(this_event.id, "A", true)  
	 
	 end

	else
      pbSetSelfSwitch(this_event.id, "A", true)  
	end
	else
     pbMessage(_INTL("This is a Spirit Statue. Once activated, the spirit inside will aid you with some of its power."))
	 if pbConfirmMessage(_INTL("Touch Statue?"))
	   $PokemonGlobal.active_statues << $game_map.map_id
	   pbMessage(_INTL("It doesn't seem to react at first, before..."))
	   pbMEPlay("Pokemon Healing")
       $player.heal_party
       $player.heal_self
	   this_event.turn_left
	   pbWait(2)
	   pbTeleportStatues2
	   pbUnlockPlayerClass if $player.playerclass.id==:ACTOR
       pbSetSelfSwitch(this_event.id, "A", true)  
	 end
    end
end



def pbTeleportStatues2(home=false)
command = 0
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue || statue.is_a?(Array)
       statue = StatueData.new(this_event)
       interp.setVariable(statue)
	   statue.reset
    end
	if $game_temp.carried_evo_stones.length>0
	  $game_temp.carried_evo_stones.each do |stone|
	    statue.evo_stones << stone
	    pbMessage(_INTL("You store the special #{GameData::Item.get(stone).name} in the Statue."))
	  end 
	  $game_temp.carried_evo_stones = []
	end
	if statue.health>0
	if statue.power>0
	
	
	
	if statue.power>175
	  statue.health=-1
     pbMessage(_INTL("The Statue is crackling with untethered energy."))
	end
    if statue.star_pieces==[0,0]
	  if statue.power>0 && statue.power<75
	   if statue.event.direction!=2&&statue.event.direction!=6
	   if rand(2)==0
         this_event.turn_down
	   else
	     this_event.turn_right
	   end
	   end
     elsif statue.power>=75
	  this_event.turn_left 
	 else 
	  #this_event.turn_up
     end 
   end



  loop do
  
  
  
  
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Use Statue"),
                    _INTL("Save Game"),
                    _INTL("Place Star Pieces"),
                    _INTL("Return its Power"),
                    _INTL("Exit")],-1)
	pbDisposeMessageWindow(msgwindow)
	
	
	
	
    case command
    when 0   # Use Statue
     if true



    pbDisposeMessageWindow(msgwindow)
	   commands = []
      cmd_level_up     = -1
      cmd_move_statues     = -1
      cmd_present_pokemon     = -1
      cmd_change_class     = -1
      cmd_evolve     = -1
      cmd_rest     = -1
      cmd_quit     = -1
      commands[cmd_level_up = commands.length] = _INTL('Level Up') if $player.party.length>0
      commands[cmd_move_statues = commands.length] = _INTL('Move Between Statues') if $PokemonGlobal.active_statues.length>1
      commands[cmd_present_pokemon = commands.length] = _INTL('Learn Move') if $player.party.length>0
      commands[cmd_change_class = commands.length]  = _INTL('Change Class') if $PokemonGlobal.unlocked_classes.length > 1 && $player.playerclass.id==:ACTOR
      commands[cmd_evolve = commands.length]  = _INTL('Use Evo Stone') if statue.evo_stones.length > 0
      commands[cmd_new_game = commands.length]  = _INTL('Try to Rest') if PBDayNight.isNight?(pbGetTimeNow)
      commands[cmd_quit = commands.length]      = _INTL('Cancel')
	  
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
    commands2 = pbShowCommands(msgwindow,commands,-1)
	pbDisposeMessageWindow(msgwindow)
	if cmd_level_up >= 0 && commands2 == cmd_level_up
	
	  if true
	
	
	pbDisposeMessageWindow(msgwindow)
	  if pbCanLevelUp?
	 if statue.power-10>=0
	   statue.power-=10

	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
	  elsif statue.power<=0
	  this_event.turn_down
     end  

      $player.able_party.each do |pkmn|
        pbDoLevelUps(pkmn)
      end
    else
     pbMessage(_INTL("The Statue doesn't have the energy to make your pokemon recall moves!"))
	  this_event.turn_down

	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
     end
    end
     end
      end


	
	
	elsif cmd_move_statues >= 0 && commands2 == cmd_move_statues
	if true
	pbDisposeMessageWindow(msgwindow)
	 if statue.star_pieces == [1,1] && statue.power>100
   	  pbShowTeleportMap if $game_temp.fly_destination.nil?
	  statue.power-=100 if statue.power-100>=0
	   pbMessage(_INTL("Nothing is different about it physically, but something feels different."))
	  if statue.power<=0 && statue.star_pieces==[1,1] || [1,0] || [0,1]
	  this_event.turn_down
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
	  end
	  if statue.power<=0
	  this_event.turn_down
     end	
      pbTeleportToLocation
	else
     pbMessage(_INTL("The Statue doesn't have the energy to move you somewhere."))
	  this_event.turn_down
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
    end
   end
	elsif cmd_present_pokemon >= 0 && commands2 == cmd_present_pokemon
	
	  if true
	
	
	pbDisposeMessageWindow(msgwindow)
	 if statue.power-10>=0
	   statue.power-=10

	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
	  elsif statue.power<=0
	  this_event.turn_down
     end  
       pkmn = pbReturnTradablePokemon(proc { |pkmn|
    next pkmn.egg?
	next pkmn.shadowPokemon?
       })


        if pkmn
	   form = pkmn.form
        if MoveRelearnerScreen.pbGetRelearnableMoves(pkmn).empty?
          pbMessage(_INTL("The Statue seems to not be reacting to #{pkmn.name} right now."))
        else
		   pbMessage(_INTL("As you lift #{pkmn.name} to the Statue, you can feel memories and possible memories flow from #{pkmn.name}."))
          pbMessage(_INTL("its likely this can teach it something."))
          pbRelearnMoveScreen(pkmn) 
	     pbMessage(_INTL("Nothing is different about it physically, but something feels different."))
        end
        end
    else
     pbMessage(_INTL("The Statue doesn't have the energy to make your pokemon recall moves!"))
	  this_event.turn_down

	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
     end
    end

      end


	elsif cmd_change_class >= 0 && commands2 == cmd_change_class
      if true
   	  cmd12 = []
	 pbMessageDisplay(msgwindow,_INTL("What do you want to change your acted class to?\\wtnp[1]"))
	  cmd12 << "Remove" if $player.playerclass.acted_class!=:NONE
	 $PokemonGlobal.unlocked_classes.each do |tclass|
	  cmd12 << getPlayerClassName(tclass)
	 end
	 cmd12 << _INTL("Cancel")
    commands3 = pbShowCommands(msgwindow,cmd12,-1)
	pbDisposeMessageWindow(msgwindow)
	  case commands3 
	   when commands3.length
	     break
	   when $PokemonGlobal.unlocked_classes[commands3]==$player.playerclass.id
	    pbMessage(_INTL("You do not change your acted class."))
	   when $player.playerclass.acted_class!=:NONE && commands3==0
	      pbMessage(_INTL("You do not change your acted class."))
	      $player.playerclass.acted_class=:NONE
	   
	   when $player.playerclass.acted_class!=:NONE && commands3>0
	     if pbConfirmMessage(_INTL("Are you sure you want to change your acted class to #{getPlayerClassName($PokemonGlobal.unlocked_classes[commands3-1].getName)}?"))
		 pbMessage(_INTL("You change your acted class to #{getPlayerClassName($PokemonGlobal.unlocked_classes[commands3-1].getName)}."))
		  $player.playerclass.acted_class = $PokemonGlobal.unlocked_classes[commands3-1]
		 else 
	    pbMessage(_INTL("You do not change your acted class."))
	     break
		 end

	   
	   else
	   
	     if pbConfirmMessage(_INTL("Are you sure you want to change your acted class to #{getPlayerClassName($PokemonGlobal.unlocked_classes[commands3].getName)}?"))
		 pbMessage(_INTL("You change your acted class to #{getPlayerClassName($PokemonGlobal.unlocked_classes[commands3].getName)}."))
		  $player.playerclass.acted_class = $PokemonGlobal.unlocked_classes[commands3]
		 else 
	    pbMessage(_INTL("You do not change your acted class."))
	     break
		 end

	   end
	  end
	elsif cmd_evolve >= 0 && commands2 == cmd_evolve	
	  if statue.evo_stones.length<1
	   pbMessage(_INTL("You don't have any specialized stones."))
	  else 
   	  cmd12 = []
	 pbMessageDisplay(msgwindow,_INTL("What stone do you use?\\wtnp[1]"))
	 statue.evo_stones.each do |stone|
	  cmd12 << GameData::Item.get(stone).name
	 end
	
	 cmd12 << _INTL("Cancel")
    commands3 = pbShowCommands(msgwindow,cmd12,-1)
	pbDisposeMessageWindow(msgwindow)
	  case commands3 
	   when commands3.length
	     break
	   else
	     if pbConfirmMessage(_INTL("Are you sure you want to use #{GameData::Item.get(statue.evo_stones[commands3]).name}?"))
		    case statue.evo_stones[commands3]
			  when :LEAFSTONE
			    pbGrassEvolutionStone
			end
		 else 
	    pbMessage(_INTL("You choose not to."))
	     break
		 end
	   end
	
	  end
	elsif cmd_rest >= 0 && commands2 == cmd_rest     
    if PBDayNight.isNight?(pbGetTimeNow)
	    pbMessage(_INTL("You get the best rest you can in the Wilderness."))
				pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
		       pbSleepRestore(4)
              $ExtraEvents.clearOverworldPokemonMemory
				$game_variables[29] += (3600*8)
				pbToneChangeAll(Tone.new(0,0,0,0),20)
	
	else
	 break
	end
	elsif cmd_quit >= 0 && commands2 == cmd_quit
	   break
	elsif Input.trigger?(Input::BACK)
	   break
	end
	end
	when 1  # Save Game
	if true
    pbDisposeMessageWindow(msgwindow)
	if statue.power-5<1
     pbMessage(_INTL("The Statue doesn't have enough energy to store your memories!"))
	  this_event.turn_down
	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
	  elsif statue.power<=0
	  this_event.turn_down
     end	
	else
	statue.power-=5
	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
	  elsif statue.power<=0
	  this_event.turn_down
     end	
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
	end






  
    end
	when 2 #Place Star Pieces
	 if true
    pbDisposeMessageWindow(msgwindow)
	if $bag.has?(:STARPIECE, 2) && (statue.star_pieces != [0,1] || statue.star_pieces != [1,0]  || statue.star_pieces != [1,1]) 
     pbMessage(_INTL("The Star Pieces in your bag seem like they would fit in its eyes."))
	 if pbConfirmMessage(_INTL("Do you wish to place Star Pieces in its eyes?"))
	    $bag.remove(:STARPIECE,2)
	    this_event.turn_left
        statue.power+=20
	   pbMessage(_INTL("The Statue feels complete, but physically and spiritually."))
		 statue.star_pieces = [1,1]
	 end
	elsif $bag.has?(:STARPIECE, 1)
     pbMessage(_INTL("The Star Pieces in your bag seem like they would fit in its eyes."))
	 if pbConfirmMessage(_INTL("Do you wish to place Star Pieces in its eyes?"))
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("Which eye do you wish to place your Star Piece in?\\wtnp[1]"))
    command = pbShowCommands(msgwindow,
                                   [_INTL("Left"),
                                    _INTL("Right"),
                                    _INTL("Cancel")])
	     
          case command
          when 0
             pbMessage(_INTL("You place a Star Piece in its left eye."))
			 
			 
			 if statue.star_pieces == [0,1]
	        $bag.remove(:STARPIECE,1)
             this_event.turn_down
             statue.power+=10
	   pbMessage(_INTL("The Statue feels complete, but physically and spiritually."))
		      statue.star_pieces = [1,1]
			 elsif statue.star_pieces == [1,1]
	        $bag.remove(:STARPIECE,1)
             statue.power+=10
			  if statue.power>175
	           pbMessage(_INTL("The Statue is taking the energy, but it looks a little unstable."))
			  else 
			  pbMessage(_INTL("The Statue is teeming with energy."))
			  end
			 else
             this_event.turn_right
	        $bag.remove(:STARPIECE,1)
             statue.power+=10
	        pbMessage(_INTL("The Statue feels more full."))
		     statue.star_pieces = [1,0]
			 end
			 
			 
          when 1
             pbMessage(_INTL("You place a Star Piece in its right eye."))
			 
			 
			 if statue.star_pieces == [1,0]
	        $bag.remove(:STARPIECE,1)
             this_event.turn_down
             statue.power+=10
	         pbMessage(_INTL("The Statue feels complete, but physically and spiritually."))
		     statue.star_pieces = [1,1]
			 elsif statue.star_pieces == [1,1]
             statue.power+=10
			  if statue.power>175
	           pbMessage(_INTL("The Statue is taking the energy, but it looks a little unstable."))
			  else 
			  pbMessage(_INTL("The Statue is teeming with energy."))
			  end
	        $bag.remove(:STARPIECE,1)
             statue.power+=10
			 else
             this_event.turn_up
	        $bag.remove(:STARPIECE,1)
             statue.power+=10
	         pbMessage(_INTL("The Statue feels more full."))
		     statue.star_pieces = [0,1]
			 end
			 
			 
			 
          end
	 end
	else 
     pbMessage(_INTL("It looks like something would fit in its eyes."))
	end
     end
	when 3  # Return its Power
	 if true
     pbDisposeMessageWindow(msgwindow)
     pbMessage(_INTL("You feel some energy leave your body."))
      statue.charging = true
	  
	 $PokemonGlobal.active_statues.delete($game_map.map_id)
      pbSetSelfSwitch(this_event.id, "A", false)  



    end
    else
	  pbDisposeMessageWindow(msgwindow)
      break
    end
end









    else
      pbMessage(_INTL("The Spirit Statue has no more energy."))
      pbMessage(_INTL("You feel some energy leave your body."))
      statue.charging = true
      pbSetSelfSwitch(this_event.id, "A", false)  

    end
    else
	 
	 $PokemonGlobal.active_statues << $game_map.map_id
     pbSetSelfSwitch(this_event.id, "B", true)  
     pbMessage(_INTL("The Statue has been damaged, and will need to be repaired."))
	 if pbConfirmMessage(_INTL("Would you like to attempt a repair?"))
	  if $bag.quantity(:HARDSTONE)>=50 && $bag.quantity(:MINDPLATE)>=5
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $bag.remove(:HARDSTONE,50)
	   $bag.remove(:MINDPLATE,5)
       statue.broken = true
	   statue.reset
     pbSetSelfSwitch(this_event.id, "B", false)  
       pbSetSelfSwitch(this_event.id, "A", false)  
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  else 
	   amount = 5 - $bag.quantity(:MINDPLATE)
	   if amount>0
	   pbMessage(_INTL("You need {1} more Mind Plate to repair the statue.",amount))
	   end
	   amount = 50 - $bag.quantity(:HARDSTONE)
	   if amount>0
	   pbMessage(_INTL("You need {1} more Hard Stone to build the statue.",amount))
	   end
	  end

	
	 end
	end

	
	
	
	end




def pbTeleportStatues3(home=false)
command = 0
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Save Game"),
                    _INTL("Exit")],-1)
	pbDisposeMessageWindow(msgwindow)
    case command
	when 0   # Save Game
    pbDisposeMessageWindow(msgwindow)
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
   else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end



def pbTeleportStatues4(home=false)
command = 0
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Use Statue"),
                    _INTL("Save Game"),
                    _INTL("Exit")],-1)
	pbDisposeMessageWindow(msgwindow)
    case command
    when 0   # Use Statue
    pbDisposeMessageWindow(msgwindow)
	  pbMessage(_INTL("The Statue is now sparking. This doesn't feel safe."))
   	  pbShowTeleportMap(-1, false) if $game_temp.fly_destination.nil?
	  if rand(2)==1
	  $game_temp.fly_destination[0]=255
	  $game_temp.fly_destination[1]=26
	  $game_temp.fly_destination[2]=17
      pbTeleportToLocation
	  pbMessage(_INTL("Uhh... where are we?"))
	  else
      pbTeleportToLocation
	  end
      break
    
	when 1   # Save Game
    pbDisposeMessageWindow(msgwindow)
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
    else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end


def getRevealedStatueAmt
  revealamt=0
  revealamt+=1 if $game_self_switches[[5, 6, "A"]] == true
  revealamt+=1 if $game_self_switches[[9, 17, "A"]] == true
  revealamt+=1 if $game_self_switches[[24, 13, "A"]] == true
  revealamt+=1 if $game_self_switches[[34, 1, "A"]] == true
  revealamt+=1 if $game_self_switches[[36, 2, "A"]] == true
  revealamt+=1 if $game_self_switches[[111, 8, "A"]] == true
  revealamt+=1 if $game_self_switches[[207, 2, "A"]] == true
  revealamt+=1 if $game_self_switches[[266, 1, "A"]] == true
  revealamt+=1 if $game_self_switches[[207, 2, "A"]] == true
  revealamt+=1 if $game_self_switches[[355, 1, "A"]] == true
  revealamt+=1 if $game_self_switches[[54, 49, "A"]] == true
  return revealamt

  
  
  end

#    loctext += _INTL("Statues<r><c3={1}>{2}</c3><br>", textColor, getRevealedStatueAmt)

