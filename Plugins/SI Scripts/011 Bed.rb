
class Window_InputNumberPokemon < SpriteWindow_Base
  attr_reader :sign

  def initialize(digits_max)
    @digits_max = digits_max
    @number = 0
    @frame = 0
    @sign = false
    @negative = false
    super(0, 0, 32, 32)
    self.width = (digits_max * 24) + 8 + self.borderX
    self.height = 32 + self.borderY
    colors = getDefaultTextColors(self.windowskin)
    @baseColor = colors[0]
    @shadowColor = colors[1]
    @index = digits_max - 1
    self.active = true
    refresh
  end

  def active=(value)
    super
    refresh
  end

  def number
    @number * (@sign && @negative ? -1 : 1)
  end

  def number=(value)
    value = 0 if !value.is_a?(Numeric)
    if @sign
      @negative = (value < 0)
      @number = [value.abs, (10**@digits_max) - 1].min
    else
      @number = [[value, 0].max, (10**@digits_max) - 1].min
    end
    refresh
  end

  def sign=(value)
    @sign = value
    self.width = (@digits_max * 24) + 8 + self.borderX + (@sign ? 24 : 0)
    @index = (@digits_max - 1) + (@sign ? 1 : 0)
    refresh
  end

  def refresh
    self.contents = pbDoEnsureBitmap(self.contents,
                                     self.width - self.borderX, self.height - self.borderY)
    pbSetSystemFont(self.contents)
    self.contents.clear
    s = sprintf("%0*d", @digits_max, @number.abs)
    if @sign
      textHelper(0, 0, @negative ? "-" : "+", 0)
    end
    @digits_max.times do |i|
      index = i + (@sign ? 1 : 0)
      textHelper(index * 24, 0, s[i, 1], index)
    end
  end

  def update
    super
    digits = @digits_max + (@sign ? 1 : 0)
    refresh if @frame % 15 == 0
    if self.active
      if Input.repeat?(Input::UP) || Input.repeat?(Input::DOWN) || Input.scroll_v==1 || Input.scroll_v==-1
        pbPlayCursorSE
        if @index == 0 && @sign
          @negative = !@negative
        else
          place = 10**(digits - 1 - @index)
          n = @number / place % 10
          @number -= n * place
          if Input.repeat?(Input::UP) || Input.scroll_v==1
            n = (n + 1) % 10
          elsif Input.repeat?(Input::DOWN) || Input.scroll_v==-1
            n = (n + 9) % 10
          end
          @number += n * place
        end
        refresh
      elsif Input.repeat?(Input::RIGHT)
        if digits >= 2
          pbPlayCursorSE
          @index = (@index + 1) % digits
          @frame = 0
          refresh
        end
      elsif Input.repeat?(Input::LEFT)
        if digits >= 2
          pbPlayCursorSE
          @index = (@index + digits - 1) % digits
          @frame = 0
          refresh
        end
      end
    end
    @frame = (@frame + 1) % 30
  end

  private

  def textHelper(x, y, text, i)
    textwidth = self.contents.text_size(text).width
    pbDrawShadowText(self.contents,
                     x + (12 - (textwidth / 2)),
                     y - 2 + (self.contents.text_offset_y || 0),   # TEXT OFFSET (the - 2)
                     textwidth + 4, 32, text, @baseColor, @shadowColor)
    if @index == i && @active && @frame / 15 == 0
      self.contents.fill_rect(x + (12 - (textwidth / 2)), y + 30, textwidth, 2, @baseColor)
    end
  end
end
class Pokemon

  def heal_PP_by_amt(amt = 1,move_index = -1)
    return if egg?
    if move_index >= 0
      @moves[move_index].pp += amt
    else
      @moves.each { |m| m.pp += amt }
    end
  end

end

def is_current_pos_center?
 
 center = [$PokemonGlobal.pokecenterMapId,$PokemonGlobal.pokecenterX,$PokemonGlobal.pokecenterY]
 center2 = [$game_map.map_id,$game_player.x,$game_player.y] 


  return false unless center[0] == center2[0]


  if (center[1] - center2[1]).abs <= 1 && (center[2] - center2[2]).abs <= 1
    return true
  else
    return false
  end
end
 BED_LOOKUP_FOR_HOURS = {
                "1" => 0,
                "2" => 1,
                "3" => 1,
                "4" => 2,
                "5" => 2,
                "6" => 3,
                "7" => 3,
                "8" => 5,
                "9" => 5,
                "10" => 5,
                "11" => 5,
                "12" => 10,
                "13" => 10,
                "14" => 10,
                "15" => 10,
                "16" => 20,
                "17" => 20,
                "18" => 20,
                "19" => 20,
                "20" => 30,
                "21" => 30,
                "22" => 30,
                "23" => 30,
                "24" => :FULL
            }
 
 


def heal_BED(wari,pkmn)
  case $PokemonSystem.difficulty
    when 0
	 chance = rand(5)+1
    when 1
	 chance = rand(9)+1
    when 2
	 chance = rand(17)+1
    when 3
	 chance = rand(19)+1
	 else
	 chance = rand(19)+4
  end
  pkmn.lifespan=100 if pkmn.lifespan.nil?
  if pkmn.permaFaint==true && wari>7
    pkmn.lifespan=-25
  return if pkmn.lifespan<=0
    pkmn.permaFaint=false
    pkmn.lifespan=50
  end
  return if pkmn.egg?
    newHP = pkmn.hp + (wari*4.25)
    newHP = pkmn.totalhp if newHP > pkmn.totalhp
    newHP = pkmn.totalhp if $player.is_it_this_class?(:NURSE,false)
    pkmn.hp = newHP
    pkmn.heal_status if (chance <= wari || $player.is_it_this_class?(:NURSE,false) )
	 if (chance <= wari || $player.is_it_this_class?(:NURSE,false) )
	 amt = BED_LOOKUP_FOR_HOURS[wari.to_s]
	 amt = 0 if amt.nil?
	 amt = :FULL if $player.is_it_this_class?(:NURSE,false)
	 if amt == :FULL
	 pkmn.heal_PP
	 else
    pkmn.heal_PP_by_amt(amt)
	 end
	end
  #pkmn.ready_to_evolve = false
end

def breederEgg
  return if $player.is_it_this_class?(:BREEDER,false)
  ran = false
  $player.able_party.each do |pkmn1|
     next if ran==true
    $player.able_party.each do |pkmn2|
   compat = $PokemonGlobal.day_care.get_compatibility2(pkmn1,pkmn2)
   egg_chance = [0, 20, 50, 70][compat]
   egg_chance += 10 if $bag.has?(:OVALCHARM) && compat>0 && !$player.is_it_this_class?(:BREEDER)
   egg_chance += 10 if $player.is_it_this_class?(:BREEDER) && compat>0 && !$bag.has?(:OVALCHARM)
   egg_chance += 10 if $player.is_it_this_class?(:BREEDER) && $bag.has?(:OVALCHARM) && compat>0
   egg_chance += 1 if $player.is_it_this_class?(:BREEDER) && $bag.has?(:OVALCHARM) && compat==0
   daycare.egg_generated = true if rand(100) < egg_chance
   if daycare.egg_generated == true
        egg = EggGenerator.generate(pkmn1,pkmn2)
        raise _INTL("Couldn't generate the egg.") if egg.nil
        if !$map_factory
           event = $game_map.generateEvent($game_player.x,$game_player.y,egg,false,false,2)
       else
          mapId = $game_map.map_id
          spawnMap = $map_factory.getMap(mapId)
          event = spawnMap.generateEvent($game_player.x+1,$game_player.y,egg,false,false,2)
       end
        $game_player.move_backward
      ran = true
   end 
  end
 end

end

def pbErasePokemonCenter(map)
  if $PokemonGlobal.pokecenterMapId == map
    $PokemonGlobal.pokecenterMapId      = -1
    $PokemonGlobal.pokecenterX          = -1
    $PokemonGlobal.pokecenterY          = -1
    $PokemonGlobal.pokecenterDirection  = -1
	return true
  end
  return false
end


def pbBedCore(item)
command = 0
	$PokemonGlobal.bars_visible=false
  loop do
      cmdSleep  = -1
      cmdNap   = -1
      cmdSave   = -1
      cmdDreamConnect = -1
      cmdPickUp = -1
      commands = []
      commands[cmdSleep  = commands.length] = _INTL("Sleep")
      commands[cmdNap  = commands.length] = _INTL("Nap")
      commands[cmdSave   = commands.length] = _INTL("Save")
      commands[cmdDreamConnect = commands.length] = _INTL("Dream Connect")
      commands[cmdPickUp  = commands.length] = _INTL("Pick Up")
      commands[commands.length]              = _INTL("Cancel")
      msgwindow = pbCreateMessageWindow(nil,nil)
      pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
      command = pbShowCommands(msgwindow, commands, -1)
      pbDisposeMessageWindow(msgwindow)
      if cmdSleep >= 0 && command == cmdSleep      # Send to Boxes
          if pbConfirmMessage(_INTL("Do you want to head to bed?\\wtnp[1]"))
		   if !nuzlocke_has?(:AFULLEIGHTHOURS)
             params = ChooseNumberParams.new
             params.setMaxDigits(2)
             params.setRange(0,24)
             msgwindow = pbCreateMessageWindow(nil,nil)
             pbMessageDisplay(msgwindow,_INTL("How many hours do you want to sleep?\\wtnp[1]"))
		     hours = pbChooseNumber(msgwindow,params)
             pbDisposeMessageWindow(msgwindow)
			else
			 hours = 8
			end

			  if hours == 0
			    pbMessage(_INTL("You decide not to sleep.",hours))
				 break
			  else
			    pbMessage(_INTL("You lay down to rest with your Pokemon for {1} hours.\\wtnp[6]",hours)) if hours>1
			    pbMessage(_INTL("You lay down to rest with your Pokemon for an hour.\\wtnp[6]")) if hours==1
				 
				 
			  end
				pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
            if !is_current_pos_center?
			  sideDisplay("Respawn Point set to #{$game_map.name}!")
             pbSetPokemonCenter
			 end
			  pbShowTipCardsGrouped(:BEDTIMETIPS) if !pbSeenTipCard?(:SLEEPING1)
				 curTime = pbGetTimeNow
				 nuTime = Time.new($PokemonGlobal.newFrameCount+(((3600*hours))/UnrealTime::PROPORTION.to_f))
				  if curTime.day!=nuTime.day
				    midnight_activations_please
				  end
				party = $player.party
                 for i in 0...party.length
                 pkmn = party[i]
				 heal_BED(hours,pkmn)
				 end
				pbWait(80)
				pbRandomEvent
				
			    pbMessage(_INTL("Your Pokemon seems a little off tonight.")) if pbPokerus?
				$game_variables[29] += (3600*hours)
				pbSleepRestore(hours)
			   increaseHealthAndTotalHP(hours)
	            pbMEPlay("Pokemon Healing")
              $ExtraEvents.clearOverworldPokemonMemory
				pbToneChangeAll(Tone.new(0,0,0,0),20)
				if $player.playersleep >= 100.0
			        pbMessage(_INTL("You feel well rested!"))
				elsif $player.playersleep >= 75.0
			        pbMessage(_INTL("You feel a little groggy, but are raring to go!"))
				elsif $player.playersleep >= 50.0
			        pbMessage(_INTL("Your brain feels fuzzy."))
				elsif $player.playersleep >= 25.0
			        pbMessage(_INTL("You want to go back to bed."))
				else
			        pbMessage(_INTL("You really need to sleep."))
				end  
        	    break
		  end
      elsif cmdNap >= 0 && command == cmdNap   # Summary
          if pbConfirmMessage(_INTL("Do you want to take a nap?"))
			    pbMessage(_INTL("You lay down to take a nap."))
				pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
			    hours = 1

				 curTime = pbGetTimeNow
				 nuTime = Time.new($PokemonGlobal.newFrameCount+(((3600*hours))/UnrealTime::PROPORTION.to_f))
				  if curTime.day!=nuTime.day
				    midnight_activations_please
				  end
				$game_variables[29] += ((3600*hours)/2).round
            if !is_current_pos_center?
			  sideDisplay("Respawn Point set to #{$game_map.name}!")
             pbSetPokemonCenter
			 end
				pbWait(40)
				pbRandomEvent
				chance = rand(3)
				if chance == 0
				$player.pokemon_party.each do |pkmn|
                 pkmn.heal_HP
                 pkmn.heal_status
                 pkmn.heal_PP
				 end
				 pbSleepRestore(hours)
              $ExtraEvents.clearOverworldPokemonMemory
			   increaseHealthAndTotalHP(hours)
	            pbMEPlay("Pokemon Healing")
			 	pbToneChangeAll(Tone.new(0,0,0,0),20)
			     pbMessage(_INTL("You wake up feeling great!"))
				 elsif chance == 1
			 	pbToneChangeAll(Tone.new(0,0,0,0),20)
			     pbMessage(_INTL("You wake up not feeling any different."))
				 else
				   $player.playersleep -= 24
				 pbToneChangeAll(Tone.new(0,0,0,0),20)
			     pbMessage(_INTL("You wake up feeling worse than before."))
				 end

              break
				end
      elsif cmdSave >= 0 && command == cmdSave   # Summary
       scene = PokemonSave_Scene.new
       screen = PokemonSaveScreen.new(scene)
       screen.pbSaveScreen
	   break
      elsif cmdDreamConnect >= 0 && command == cmdDreamConnect   # Summary
	    pbCableClub
		break
      elsif cmdPickUp >= 0 && command == cmdPickUp   # Summary
          if pbConfirmMessage(_INTL("Do you want to pick up the Bed?"))
		    pbErasePokemonCenter($game_map.map_id)
			  sideDisplay("Respawn Point removed!")
		    pbReceiveItem(item)
		    this_event = pbMapInterpreter.get_self
	  if !$map_factory
           $game_map.removeThisEventfromMap(this_event.id)
         else
           mapId = $game_map.map_id
           $map_factory.getMap(mapId).removeThisEventfromMap(this_event.id)
         end
          deletefromSIData(this_event.id,mapId)

		  end
		  break
	  elsif Input.trigger?(Input::BACK)
	    break
	  else
	    break
      end
end

			  $PokemonGlobal.bars_visible=true
end

EventHandlers.add(:on_frame_update, :midnight_activations,
  proc {
    next if !$player
    next if !PBDayNight.isMidnight?
	midnight_activations_please
  }
)
def midnight_activations_please

	$player.playerclass.acted_class=:NONE if $player.is_it_this_class?(:ACTOR)
	$PokemonGlobal.everytwodays+=1
	if $PokemonGlobal.everytwodays==2
	  bed_plant_reset
	  $PokemonGlobal.collection_maps = {}
	  $PokemonGlobal.everytwodays=0
	end


end


def bed_plant_reset
	 $map_factory.maps.each do |map|
      map.events.each_value do |event|
        if event.name[/berryplant/i]
          time = 24*3600
          plant = pbMapInterpreter.getVariableOther(event,map)
		   if plant
		   if plant.timewithoutberry>(time+rand(time/2))
            plant.plant(plant.last_berry) if plant.last_berry
		   end
		   end
        end
      end
      $game_map.need_refresh = true if map==$game_map
    end



end

   def getVariableSup(map,event)
      return nil if !$PokemonGlobal.eventvars
      return $PokemonGlobal.eventvars[[@map_id, @event_id]]
   end


def pbBedMessageLoss
if $player.playermaxhealth2 >=75
    pbMessage(_INTL("#{$player.name} woke up feeling well-rested."),)
elsif $player.playermaxhealth2 >=50
    pbMessage(_INTL("#{$player.name} woke up feeling rested, if a little achey.."))
elsif $player.playermaxhealth2 >=25
    pbMessage(_INTL("#{$player.name} woke up feeling tired, but determined."))
elsif $player.playermaxhealth2 >=10
    pbMessage(_INTL("#{$player.name} woke up in pain, but shrugged it off. It can't be *that* bad..."))
elsif $player.playermaxhealth2 <=9
    pbMessage(_INTL("#{$player.name} really doesn't want to get out of bed."))
end
end


module MessageConfig

def pbPositionNearMsgWindow(cmdwindow, msgwindow, side)
  return if !cmdwindow
  if msgwindow
    height = [cmdwindow.height, Graphics.height - msgwindow.height].min
    if cmdwindow.height != height
      cmdwindow.height = height
    end
    cmdwindow.y = msgwindow.y - cmdwindow.height
    if cmdwindow.y < 0
      cmdwindow.y = msgwindow.y + msgwindow.height
      if cmdwindow.y + cmdwindow.height > Graphics.height
        cmdwindow.y = msgwindow.y - cmdwindow.height
      end
    end
    case side
    when :left
      cmdwindow.x = msgwindow.x
    when :right
      cmdwindow.x = msgwindow.x + msgwindow.width - cmdwindow.width
    else
      cmdwindow.x = msgwindow.x + msgwindow.width - cmdwindow.width
    end
  else
    cmdwindow.height = Graphics.height if cmdwindow.height > Graphics.height
    cmdwindow.x = 0
    cmdwindow.y = 0
  end
end
end


class PokemonGlobalMetadata
    attr_accessor :everytwodays
	
	  def everytwodays
	   @everytwodays = 0 if @everytwodays.nil?
	   return @everytwodays
	  end
	end