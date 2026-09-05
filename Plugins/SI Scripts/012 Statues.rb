class PokemonGlobalMetadata
    attr_accessor :active_statues
    attr_accessor :unlocked_classes
    attr_accessor :all_classes
	
	
	def active_statues
	 @active_statues = StatueCollection.new if @active_statues.nil? || !@active_statues.is_a?(StatueCollection)
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

class StatueCollection
STATUE_MAP_POSITIONS = {
  :STATUE_01 => [27, 32, "Temporate Coast", ""],
  :STATUE_02 => [34, 26, "Temperate Plains", "Stone Temple"],
  :STATUE_03 => [33, 21, "Temperate Highlands", "Mountain"],
  :STATUE_04 => [36, 33, "Temperate Ocean", ""],
  :STATUE_05 => [41, 23, "Temperate Marsh", "Deep Swamp Dungeon"],
  :STATUE_06 => [50, 30, "Temperate Marsh", "Deep Marsh"],
  :STATUE_07 => [26, 14, "Frigid Highlands", "Xatu Village"],
  :STATUE_08 => [50, 30, "Tropical Coast", "Oil Tanker"],
 # :STATUE_09 => [26, 17],
  :STATUE_10 => [26, 14, "Northern Highlands", ""],#THIS IS IN TEH WRONG POSITION
  :STATUE_11 => [8, 6, "Atmosphere", "Mountain Skies"],
  :STATUE_99 => [9, 19, "Tropical Jungle", "Temple Tech Lab"]
}
  def initialize
    @statues = {}
  end 

  def register(id, data)
    return false if @statues.key?(id)
    @statues[id] = data
	return true 
  end
  
  def length
    @statues.length
  end 
  
  def [](id)
    @statues[id]
  end

  def each(&block)
    @statues.each(&block)
  end
  
  def map_id(id)
    @statues[id][:map_id]
  end 
  
  def x(id)
    @statues[id][:x]
  end 
  
  def y(id)
    @statues[id][:y]
  end 
  
  def map_x(id)
    @statues[id][:map_x]
  end 
  
  def map_y(id)
    @statues[id][:map_y]
  end 
  
  def statue_name(id)
    @statues[id][:statue_name]
  end 
  
  def point_of_interest(id)
    @statues[id][:point_of_interest]
  end 
  
  def delete(id)
    @statues.delete(id)
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




def pbDoLevelUps
  $player.able_party.each do |pkmn|
    next unless pkmn.can_level_up?
    pkmn.apply_levels(true, true)
  end
end


def pbCanLevelUp?
  return true if $player.able_party.any?(&:can_level_up?)

  pbMessage(_INTL("Your Pokemon have not experienced enough to grow like this."))
  false
end




def howmanystatues()
 return $PokemonGlobal.active_statues.length
end


class StatueData
    BASE_POWER_CAP       = 100
    STAR_PIECE_POWER_CAP = 200

    attr_accessor :event
    attr_accessor :star_pieces_placed
    attr_accessor :health
    attr_accessor :power
    attr_accessor :charging
    attr_accessor :time_last_updated
    attr_accessor :power_at_charge_start
    attr_accessor :time_recharging
    attr_accessor :time_recharging2
    attr_accessor :evo_stones
    attr_accessor :broken
    attr_accessor :version
    attr_accessor :solved
  
  def id
   return :STATUE 
  end 
  def event_id=(value)
    @event_id = value 
  end 
  
  def event_id
    @event_id 
  end 
  
  def initialize(event = nil)
    @event = event if !event.nil?
    @star_pieces_placed = false
    @health = 20
    @power = BASE_POWER_CAP
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

  # Reads true whenever the upgrade is active. Also migrates old saves that
  # still carry the retired two-slot @star_pieces array ([0,0]/[1,0]/[0,1]/[1,1]) -
  # any save where both eyes were already filled is treated as upgraded.
  def star_pieces_placed
    if @star_pieces_placed.nil?
      @star_pieces_placed = defined?(@star_pieces) && @star_pieces == [1, 1]
    end
    @star_pieces_placed
  end

  def power_cap
    star_pieces_placed ? STAR_PIECE_POWER_CAP : BASE_POWER_CAP
  end
  
  def reset 
    @health = 20
    @power = BASE_POWER_CAP
    @charging = false
    @time_last_updated = pbGetTimeNow
    @time_recharging = 0
    @broken = false
    # star_pieces_placed is a permanent upgrade and intentionally survives a reset/repair.
  end

  def update
    return if @health==0
	 return if @broken == true && @power>=BASE_POWER_CAP
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
	  if @power+(10*time)>power_cap
	   @power=power_cap
      return 
	  end
	   @power +=(10*time)
	 else
  #  puts @power
	  @power +=(5*time) if @power<BASE_POWER_CAP
  #  puts @power
	 
	 end
	 if @power>=BASE_POWER_CAP && @broken == true
	    @power=BASE_POWER_CAP
	 end
     if @power>power_cap
	   @power=power_cap
	 end
  end

  # --- Eyes-glow mechanic (replaces the old power-window readout) ---

  def glow_tier
    return :none if @power <= 0
    pct = @power.to_f / power_cap
    return :intense if pct >= 0.75
    return :bright  if pct >= 0.4
    :dim
  end

  def glow_message
    case glow_tier
    when :intense
      _INTL("The Statue's eyes blaze with power.")
    when :bright
      _INTL("The Statue's eyes glow brightly.")
    when :dim
      _INTL("The Statue's eyes glow faintly.")
    else
      _INTL("The Statue's eyes are dark.")
    end
  end

  # Character direction constants: 2=down, 4=left, 6=right, 8=up
  def glow_direction
    case glow_tier
    when :intense then 4
    when :bright  then 2
    when :dim     then 6
    else 8
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
  def statue_id
    :"STATUE_#{version.to_s.rjust(2, "0")}"
  end
  def register_self
    raise if statue_id == :STATUE_09
    registry = {:map_id => @event.map_id, :x => @event.x, :y => @event.y}
    $PokemonGlobal.active_statues.register(statue_id, registry)
  end 
  def unregister_self
    $PokemonGlobal.active_statues.delete(statue_id)
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
  return nil unless $DEBUG && Input.press?(Input::CTRL)
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

  # $ExtraEvents.berry_plants[[this_event.map_id,this_event.id]] = StoredEvent.new(this_event.map_id,this_event,:STATUE) if $ExtraEvents.berry_plants[[this_event.map_id,this_event.id]].nil?	
	
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
	   statue.register_self
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
	   statue.register_self
	   this_event.turn_left
	   pbWait(2)
     pbSetSelfSwitch(this_event.id, "A", true)  
	 
	 end

	else
	
     pbMessage(_INTL("This is a Spirit Statue. Once activated, the spirit inside will aid you with some of its power."))
	 if pbConfirmMessage(_INTL("Touch Statue?"))
	   statue.register_self
	   pbMessage(_INTL("It doesn't seem to react at first, before..."))
	   pbMEPlay("Pokemon Healing")
       $player.heal_party
       $player.heal_self
	   this_event.turn_left
	   pbWait(2)
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
	   statue.register_self
	   pbMessage(_INTL("It doesn't seem to react at first, before..."))
	   pbMEPlay("Pokemon Healing")
       $player.heal_party
       $player.heal_self
	   this_event.turn_left
	   pbWait(2)
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
	statue.register_self
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
    case statue.glow_direction
    when 4 then this_event.turn_left
    when 2 then this_event.turn_down
    when 6 then this_event.turn_right
    when 8 then this_event.turn_up
    end



  loop do
  
	$PokemonGlobal.addNewFrameCount
  
  
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
	statuewindow = pbDisplayStatueWindow(msgwindow,statue)
	 
    command = pbShowCommandsssss(statuewindow,statue,msgwindow,
                    [_INTL("Use Statue"),
                    _INTL("Save Game"),
                    _INTL("Place Star Pieces"),
                    _INTL("Return its Power"),
                    _INTL("Exit")],-1)
	
	
	
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
      commands[cmd_move_statues = commands.length] = _INTL('Move Between Statues') #if $PokemonGlobal.active_statues.length>1
      commands[cmd_present_pokemon = commands.length] = _INTL('Learn Move') if $player.party.length>0
      commands[cmd_change_class = commands.length]  = _INTL('Change Class') if $PokemonGlobal.unlocked_classes.length > 1 && $player.playerclass.id==:ACTOR
      commands[cmd_evolve = commands.length]  = _INTL('Use Evo Stone') if statue.evo_stones.length > 0
      commands[cmd_rest = commands.length]  = _INTL('Try to Rest') if PBDayNight.isNight?(pbGetTimeNow)
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

	  if statue.star_pieces_placed && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces_placed = false
	  elsif statue.power<=0
	  this_event.turn_down
     end  
     pbDoLevelUps
    else
     pbMessage(_INTL("The Statue doesn't have the energy to make your pokemon recall moves!"))
	  this_event.turn_down

	  if statue.star_pieces_placed && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces_placed = false
     end
    end
     end
      end


	
	
	elsif cmd_move_statues >= 0 && commands2 == cmd_move_statues
	   statuewindow.dispose if statuewindow
	if true
	pbDisposeMessageWindow(msgwindow)
	 if statue.power>=100
   	  pbShowTeleportMap(statue) if $game_temp.fly_destination.nil?
	  statue.power-=100 if statue.power-100>=0
	  
	  
	  if statue.power<=0 && statue.star_pieces_placed
	   this_event.turn_down
       pbMessage(_INTL("The Star Pieces crumble to dust."))
       statue.star_pieces_placed = false
	  end
	  
	  
	  this_event.turn_down if statue.power<=0
      pbTeleportToLocation
	else
     pbMessage(_INTL("The Statue doesn't have the energy to move you somewhere."))
	  this_event.turn_down
    end
   end
	elsif cmd_present_pokemon >= 0 && commands2 == cmd_present_pokemon
	   statuewindow.dispose if statuewindow
	
	  if true
	
	
	pbDisposeMessageWindow(msgwindow)
	 if statue.power-50>=0
	   statue.power-=50

	  if statue.star_pieces_placed && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces_placed = false
	  elsif statue.power<=0
	  this_event.turn_down
     end  
      pbRelearnMoveScreen
    else
     pbMessage(_INTL("The Statue doesn't have the energy to make your pokemon recall moves!"))
	  this_event.turn_down

	  if statue.star_pieces_placed && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces_placed = false
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
	  cancel_index = cmd12.length - 1
	  has_remove = ($player.playerclass.acted_class!=:NONE)
	  selected_class = nil
	  selected_class = has_remove ? $PokemonGlobal.unlocked_classes[commands3-1] : $PokemonGlobal.unlocked_classes[commands3] if !(has_remove && commands3==0) && commands3 != cancel_index
	  if commands3 == cancel_index
	     break
	   elsif has_remove && commands3==0
	      pbMessage(_INTL("You do not change your acted class."))
	      $player.playerclass.acted_class=:NONE
	   
	   elsif selected_class==$player.playerclass.id
	    pbMessage(_INTL("You do not change your acted class."))
	   else
	   
	     if pbConfirmMessage(_INTL("Are you sure you want to change your acted class to #{getPlayerClassName(selected_class.getName)}?"))
		 pbMessage(_INTL("You change your acted class to #{getPlayerClassName(selected_class.getName)}."))
		  $player.playerclass.acted_class = selected_class
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
	  if commands3 == cmd12.length - 1
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
	  if statue.star_pieces_placed && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces_placed = false
	  elsif statue.power<=0
	  this_event.turn_down
     end	
	else
	this_event.clear_starting
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    statue.power-=5 
	statue.power+=5 unless screen.pbSaveScreen==true
	  if statue.star_pieces_placed && statue.power<=0
      pbMessage(_INTL("The Star Pieces crumble to dust."))
      statue.star_pieces_placed = false
	  elsif statue.power<=0
	  this_event.turn_down
     end	
	end





  
    end
	when 2 #Place Star Pieces
	 if true
    pbDisposeMessageWindow(msgwindow)
	statuewindow.dispose if statuewindow
	if statue.star_pieces_placed
     pbMessage(_INTL("The Statue's eyes already hold their Star Pieces."))
	elsif $bag.has?(:STARPIECE, 2)
     pbMessage(_INTL("The Star Pieces in your bag seem like they would fit in its eyes."))
	 if pbConfirmMessage(_INTL("Do you wish to place two Star Pieces in its eyes?"))
	    $bag.remove(:STARPIECE,2)
	    statue.star_pieces_placed = true
	    this_event.turn_left
	   pbMessage(_INTL("The Statue feels complete. Its power capacity doubles."))
	 end
	else 
     pbMessage(_INTL("It looks like a pair of Star Pieces would fit in its eyes."))
	end
     end
	when 3  # Return its Power
	 if true
     pbDisposeMessageWindow(msgwindow)
	   statuewindow.dispose if statuewindow
     pbMessage(_INTL("You feel some energy leave your body."))
	 statue.power_at_charge_start = statue.power
      statue.charging = true
	  statue.unregister_self
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
	 
	 statue.register_self
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
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue || statue.is_a?(Array)
       statue = StatueData.new(this_event)
       interp.setVariable(statue)
	   statue.reset
    end
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
	this_event.clear_starting
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    statue.power-=5 
	statue.power+=5 unless screen.pbSaveScreen
   else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end



def pbTeleportStatues4(home=false)
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue || statue.is_a?(Array)
       statue = StatueData.new(this_event)
       interp.setVariable(statue)
	   statue.reset
    end
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
   	  pbShowTeleportMap(statue) if $game_temp.fly_destination.nil?
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
	this_event.clear_starting
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    statue.power-=5 
	statue.power+=5 unless screen.pbSaveScreen
    else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end
