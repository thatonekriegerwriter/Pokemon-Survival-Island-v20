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
	if pkmn.level == 20 && pkmn.shadowPokemon?
      pbMessage(_INTL("{1} cannot go beyond this level because it is a Shadow Pokemon.", pkmn.name, curLevel)) if messages
	   return
	end
	  potato1 = pkmn.exp.dup
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
	if curLevel>=level_cap
     pkmn.stored_exp = 0
	  if curLevel>level_cap
     levelMinExp = growth_rate.minimum_exp_for_level(level_cap)
	  pkmn.exp = levelMinExp
	  end
    return
	end
	newLevel = level_cap  if newLevel > level_cap
   if newLevel <= curLevel
	
      pbMessage(_INTL("{1} has not gained enough experience to level up.", pkmn.name, curLevel)) if messages
	  return false
	else
	
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp < expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
	   pkmn.stored_exp -= tempExp2
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
      if curLevel+1 > level_cap
        pkmn.calc_stats
        # Gained all the Exp now, end the animation
        break
      end
   end
      pbMessage(_INTL("{1} grew to Lv. {2}!", pkmn.name, pkmn.level))
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

    pkmn.stored_exp+=potato1 if pkmn.level!=pkmn.level_cap
    pkmn.stored_exp=0 if pkmn.stored_exp<0 || pkmn.level==pkmn.level_cap
    return true
     end




end
def pbCanLevelUp?
    results = [] 
      $player.able_party.each do |pkmn|
           results << (pkmn.stored_exp > 0)
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
    attr_accessor :time_recharging2
    attr_accessor :evo_stones
    attr_accessor :broken
    attr_accessor :version
    attr_accessor :solved

	
  def initialize(event = nil)
    @event = event if !event.nil?
    @star_pieces = [0,0]
    @health = 20
    @power = 100
    @charging = false
    @evo_stones = []
    @power_at_charge_start = @power
    @time_last_updated = pbGetTimeNow.to_i
    @time_recharging = 0
    @time_recharging2 = 0
    @broken = false
	@version = 1
	if !event.nil? && event.name[/^AncientStone\((\d+)\)/i]
      @version = $~[1].to_i
	end
	@solved = false
  end
  def power_at_charge_start 
	@power_at_charge_start = @power if @power_at_charge_start.nil?
    return @power_at_charge_start
  end
  def solved 
	@solved = false if @solved.nil?
    return @solved
  end
  def version 
     if !@event.nil?
	  if @event.name[/^AncientStone\((\d+)\)/i]
      @version = $~[1].to_i
	  end
	 end  
	@version = 1 if @version.nil?
    return @version
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
    @broken = false
  end

  def update
   $ExtraEvents.berry_plants[[@event.map_id,@event.id]] = StoredEvent.new(@event.map_id,@event,:STATUE) if $ExtraEvents.berry_plants[[@event.map_id,@event.id]].nil?
    return if @health==0
	 return if @broken == true && @power>=100
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated.to_i
	 tps = 0.5 if @charging==true
	 tps = 1 if @charging==false
	 tps = 2 if @broken == true
    return if time_delta < (tps * 3600)
	   @time_last_updated = time_now
	  time = time_delta/3600
	  time = [time,1].max
    if @charging==true
	  if @power+(10*time)>175
	   @power=175
      return 
	  end
	   @power +=(10*time)
	 else
    puts @power
	  @power +=(5*time) if @power<100
    puts @power
	 
	 end
	 if @power>=100 && @broken == true
	    @power=100
	 end
     if @power>175
	   @power=175
	 end
  end

  def puzzle
    case @version
        when 1
		  @solved = true
        when 2
	    pbMessage(_INTL("The Statue seems to want you have at least one POKeMON before it will activate."))
		  if $player.able_party.length>=1
	        pbMessage(_INTL("The Statue glows brighter, before a compulsion to touch the Statue begins."))
		    @solved = true
		  else
		     pbMessage(_INTL("Return with one POKeMON."))
		  end
        when 3
	    pbMessage(_INTL("The Statue seems to want you have at tools for mining before it will activate."))
		  if $bag.has?(:IRONPICKAXE) && $bag.has?(:IRONHAMMER)
	        pbMessage(_INTL("The Statue glows brighter, before a compulsion to touch the Statue begins."))
		    @solved = true
		  else
		     pbMessage(_INTL("Return with Mining Tools."))
		  end
        when 4
        when 5
        when 6
        when 7
		  @solved = true
        when 8
        when 9
        when 10
        when 11
        when 12
  
  
  
  
  
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
 class EnergyWindow
    attr_accessor :variable
    attr_accessor :displayextra
    attr_accessor :visible
   def initialize(msgwindow,variable,text)
     @variable = variable
     @visible = true
     @displayextra = false
	  @primefocus = text
     @energywindow = Window_AdvancedTextPokemon.new(_INTL(""))  
     @energywindow.resizeToFit(@energywindow.text,Graphics.width)
     @energywindow.width=160 if @energywindow.width<=160 
     if msgwindow.y==0
       @energywindow.y=Graphics.height-@energywindow.height
     else
       @energywindow.y=0
     end
     @energywindow.viewport=msgwindow.viewport
     @energywindow.z=msgwindow.z   
   end
   def visible=(uwu)
    @visible=uwu
   end
   def update
    if @visible==true
    healthString=_INTL("{1}/20",@variable.health.to_s_formatted) if (Input.press?(Input::CTRL) && $DEBUG || @displayextra == true) && @variable.respond_to?("health")
    moneyString=_INTL("{1}/100",@variable.power.to_s_formatted)
	 text = _INTL("#{@primefocus}: <ar>{1}</ar>",moneyString)
	 text = _INTL("Health: <ar>{2}</ar>#{@primefocus}: <ar>{1}</ar>",moneyString,healthString) if (Input.press?(Input::CTRL) && $DEBUG || @displayextra == true) && @variable.respond_to?("health")
	 @energywindow.setTextToFit(text, Graphics.width)
	 else
	 @energywindow.setTextToFit("")
	 
	 end
   end
   
   def dispose
     @energywindow.dispose
   end
 end
def pbDisplayStatueWindow(msgwindow,statue)
  powerwindow = EnergyWindow.new(msgwindow,statue,"Energy")
  return powerwindow
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
    if !statue || statue.is_a?(Array)
       statue = StatueData.new(this_event)
       interp.setVariable(statue)
	   statue.reset
    end

   $ExtraEvents.berry_plants[[this_event.map_id,this_event.id]] = StoredEvent.new(this_event.map_id,this_event,:STATUE) if $ExtraEvents.berry_plants[[this_event.map_id,this_event.id]].nil?	
	
    if statue
    statue.solved = true if statue.version == 1 || statue.version == 7
    
	if statue.solved == true
	
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
	   pbMessage(_INTL("It doesn't seem to react at first, before..."))
	   if statue.power_at_charge_start >= statue.power+25
	   pbMEPlay("Pokemon Healing")
       $player.heal_party
       $player.heal_self
	   end
	   statue.charging = false
	   $PokemonGlobal.active_statues << $game_map.map_id
	   this_event.turn_left
	   pbWait(2)
	   pbTeleportStatues2
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

    else
     pbMessage(_INTL("This is a Spirit Statue. Once activated, the spirit inside will aid you with some of its power."))
	  pbMessage(_INTL("The Statue glows dimly, seeming to want something of you."))
	  statue.puzzle
	  if statue.solved == true
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
   $ExtraEvents.berry_plants[[this_event.map_id,this_event.id]] = StoredEvent.new(this_event.map_id,this_event,:STATUE) if $ExtraEvents.berry_plants[[this_event.map_id,this_event.id]].nil?	
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
  
	$PokemonGlobal.addNewFrameCount
  
  
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
	statuewindow = pbDisplayStatueWindow(msgwindow,statue)
	#statuewindow.update
	 
    command = pbShowCommandsssss(statuewindow,statue,msgwindow,
                    [_INTL("Use Statue"),
                    _INTL("Save Game"),
                    _INTL("Place Star Pieces"),
                    _INTL("Return its Power"),
                    _INTL("Exit")],-1)
	#statuewindow.update
	
	
	
    case command
    when 0   # Use Statue
     if true



    pbDisposeMessageWindow(msgwindow)
	   statuewindow.dispose if statuewindow
	  statuewindow = pbDisplayStatueWindow(msgwindow,statue)
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
    commands2 = pbShowCommandsssss(statuewindow,statue,msgwindow,commands,-1)
	pbDisposeMessageWindow(msgwindow)
	if cmd_level_up >= 0 && commands2 == cmd_level_up
	   statuewindow.dispose if statuewindow
	
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
	   statuewindow.dispose if statuewindow
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
	   statuewindow.dispose if statuewindow
	
	  if true
	
	
	pbDisposeMessageWindow(msgwindow)
	 if statue.power-50>=0
	   statue.power-=50

	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
	  elsif statue.power<=0
	  this_event.turn_down
     end  
       pkmn = pbReturnTradablePokemon(proc { |pkmn|
    next !MoveRelearnerScreen.pbGetRelearnableMoves(pkmn).empty?
       })


        if pkmn
	   form = pkmn.form
        if MoveRelearnerScreen.pbGetRelearnableMoves(pkmn).empty?
          pbMessage(_INTL("The Statue seems to not be reacting to #{pkmn.name} right now."))
        else
		   pbMessage(_INTL("As you lift #{pkmn.name} to the Statue, you can feel memories and possiblities flow from within #{pkmn.name}."))
         
          pbMessage(_INTL("The Statue can definitely teach #{pkmn.name} a move."))
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
	   statuewindow.dispose if statuewindow
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
	   statuewindow.dispose if statuewindow
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
	   statuewindow.dispose if statuewindow   
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
	   statuewindow.dispose if statuewindow
	   break
	elsif Input.trigger?(Input::BACK)
	   statuewindow.dispose if statuewindow
	   break
	end
	end
	when 1  # Save Game
	if true
    pbDisposeMessageWindow(msgwindow)
	   statuewindow.dispose if statuewindow
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
	statuewindow.dispose if statuewindow
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
	   statuewindow.dispose if statuewindow
     pbMessage(_INTL("You feel some energy leave your body."))
	 statue.power_at_charge_start = statue.power
      statue.charging = true
	  
	 $PokemonGlobal.active_statues.delete($game_map.map_id)
      pbSetSelfSwitch(this_event.id, "A", false)  
      break



    end
    else
	  pbDisposeMessageWindow(msgwindow)
	   statuewindow.dispose if statuewindow
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
    pbMessageDisplay(msgwindow,_INTL("It seems with the statue in it's current state, you can only save.\\wtnp[1]"))
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

