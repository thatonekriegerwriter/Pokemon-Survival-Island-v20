class PokemonGlobalMetadata
    attr_accessor :active_statues
    attr_accessor :unlocked_classes
	
	
	def active_statues
	 @active_statues = [] if @active_statues.nil?
	 return @active_statues
	end

	def unlocked_classes
	 @unlocked_classes = [$player.playerclass] if @unlocked_classes.nil?
	 return @unlocked_classes
	end
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
    return evo_stones
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

def pbTeleportToLocation
  return false if $game_temp.fly_destination.nil?
  pbFadeOutIn {
    pbSEPlay("OWThunder1")
    $game_temp.player_new_map_id    = $game_temp.fly_destination[0]
    $game_temp.player_new_x         = $game_temp.fly_destination[1]
    $game_temp.player_new_y         = $game_temp.fly_destination[2]
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
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Use Statue"),
                    _INTL("Recall Adventure"),
                    _INTL("Place Star Pieces"),
                    _INTL("Return its Power"),
                    _INTL("Exit")],-1)
	pbDisposeMessageWindow(msgwindow)
	
	
	
	
    case command
    when 0   # Use Statue




    pbDisposeMessageWindow(msgwindow)
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
	 thecommands = [_INTL("Move Between Statues"),
                    _INTL("Present Pokemon"),
                    _INTL("Change Class"),
                    _INTL("Evolve")]
	
	 thecommands << _INTL("Try to Rest") if PBDayNight.isNight?(pbGetTimeNow)
	 thecommands << _INTL("Cancel")
    commands2 = pbShowCommands(msgwindow,thecommands,-1)
	pbDisposeMessageWindow(msgwindow)
	
	
	
	
	case commands2
    when 0
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
	when 1
	
	
	
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
        end
	     pbMessage(_INTL("Nothing is different about it physically, but something feels different."))
        end
    else
     pbMessage(_INTL("The Statue doesn't have the energy to make your pokemon recall moves!"))
	  this_event.turn_down

	  if (statue.star_pieces==[1,1] || [1,0] || [0,1]) && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces = [0,0]
     end
    end
   when 2
   	  cmd12 = []
	 pbMessageDisplay(msgwindow,_INTL("What do you want to change your class to?"))
	 $PokemonGlobal.unlocked_classes.each do |tclass|
	  cmd12 << tclass
	 end
	
	 cmd12 << _INTL("Cancel")
    commands3 = pbShowCommands(msgwindow,cmd12,-1)
	pbDisposeMessageWindow(msgwindow)
	  case commands3 
	   when commands3.length
	     break
	   when $PokemonGlobal.unlocked_classes[commands3]==$player.playerclass
	    pbMessage(_INTL("You do not change your class."))
	   else
	     if pbConfirmMessage(_INTL("Are you sure you want to change your class to #{$PokemonGlobal.unlocked_classes[commands3]} for the cost of One Level?"))
		 pbMessage(_INTL("You change your class to #{$PokemonGlobal.unlocked_classes[commands3]}."))
		  $player.playerclass = $PokemonGlobal.unlocked_classes[commands3]
		  $player.playerclasslevel -= 1
		 else 
	    pbMessage(_INTL("You do not change your class."))
	     break
		 end
	   end
	
	when 3
	  if statue.evo_stones.length<1
	   pbMessage(_INTL("You don't have any specialized stones."))
	  else 
   	  cmd12 = []
	 pbMessageDisplay(msgwindow,_INTL("What stone do you use?"))
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
   when 4 
    if PBDayNight.isNight?(pbGetTimeNow)
	    pbMessage(_INTL("You get the best rest you can in the Wilderness."))
				pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
		       pbSleepRestore(4)
				$game_variables[29] += (3600*8)
				pbToneChangeAll(Tone.new(0,0,0,0),20)
	
	else
	 break
	end
   else
     break
	end


















	when 1  # Save Game
	




	
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








	when 2
	
	
	
	
	
	
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
    pbMessageDisplay(msgwindow,_INTL("Which eye do you wish to place your Star Piece in?"))
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










	when 3  # Save Game
	
     pbDisposeMessageWindow(msgwindow)
     pbMessage(_INTL("You feel some energy leave your body."))
      statue.charging = true
	  
	 $PokemonGlobal.active_statues.delete($game_map.map_id)
      pbSetSelfSwitch(this_event.id, "A", false)  





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
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
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
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
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

