class SuperFishingScene
  # Size of the valid bar points between the left and the center
  BAR_LEFT_SIZE = 128 
  ARROW_SPEED = 8
  
  def pbStartScene(rodType,speedup,bait=nil)
	@rodType = rodType
	@speedup = speedup
	@bait = bait
    @sprites={} 
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["bar"]=IconSprite.new(0,0,@viewport)
    @sprites["bar"].setBitmap("Graphics/Pictures/superRodBar")
    @sprites["bar"].x=(Graphics.width-@sprites["bar"].bitmap.width)/2
    @sprites["bar"].y=40#Graphics.height-50
    arrow=AnimatedBitmap.new("Graphics/Pictures/Arrow")
    @sprites["arrow"]=BitmapSprite.new(arrow.bitmap.width/2,arrow.bitmap.height/2,@viewport)
    @sprites["arrow"].bitmap.blt(0,0,arrow.bitmap,Rect.new(
        0,@sprites["arrow"].bitmap.height,@sprites["arrow"].bitmap.width, @sprites["arrow"].bitmap.height
    ))
    @arrowXMiddle = @sprites["bar"].x-@sprites["arrow"].bitmap.width/2+4+BAR_LEFT_SIZE
    @sprites["arrow"].x = @arrowXMiddle-BAR_LEFT_SIZE
    @sprites["arrow"].y = @sprites["bar"].y-28
    #@sprites["messagebox"]=Window_AdvancedTextPokemon.new("")
    #@sprites["messagebox"].viewport=@viewport
    #pbBottomLeftLines(@sprites["messagebox"],2)
    #@sprites["messagebox"].z = @sprites["bar"].z-1
    @moving=true
    @right=false
    @result=nil
    @pressedTimes=0
	@totalScore = 0
	@pulls = 4
	@pulls += rand(4)
	@zerochain = 0
	@badchaub = 0
	@oldscore = nil
	@arrowspeed = 4 if @rodType==1
	@arrowspeed = 8 if @rodType==2
	@arrowspeed = 16 if @rodType==3
	@arrowspeed = 16 if @arrowspeed.nil?
	@arrowspeed += 2 if @speedup
	@targetarrowspeed = 4 if @rodType==1
	@targetarrowspeed = 8 if @rodType==2
	@targetarrowspeed = 16 if @rodType==3
	@targetarrowspeed = 16 if @arrowspeed.nil?
	@targetarrowspeed += 2 if @speedup
  end

  def pbMain(rodType,speedup,bait=nil)
    @frameCount=-1
	  playingthebgs = false
    loop do
      Graphics.update
      Input.update
      self.update
      pbUpdateSceneMap
      @frameCount+=1
	  playingBGS = $game_system.getPlayingBGS
	  if !playingBGS
	    playingthebgs = true
       pbBGSPlay("pulling fish")
	  end
      if @result!=nil
         break if @waitFrame<@frameCount
         next
      end
      onPress if Input.trigger?(Input::USE) && @moving
      @moving = true if !@moving && @waitFrame<=@frameCount
      if @moving
        @right = !@right if @sprites["arrow"].x<=@arrowXMiddle-BAR_LEFT_SIZE ||  @sprites["arrow"].x>=@arrowXMiddle+BAR_LEFT_SIZE
        @sprites["arrow"].x+= @right ? @arrowspeed : -@arrowspeed


    end
	end
	if playingthebgs==true
	 pbBGSStop 
    case $game_screen.weather_type
      when :Rain        then pbBGSPlay("Rain")
      when :Storm 		then pbBGSPlay("Storm")
      when :Snow        then pbBGSPlay("Snow")
      when :Blizzard    then pbBGSPlay("Blizzard")
      when :Sandstorm   then pbBGSPlay("Sandstorm")
      when :HeavyRain   then pbBGSPlay("HeavyStorm")
      when :Sun         then pbBGSPlay("Sunny")
      when :Fog         then pbBGSPlay("Fog")
	  else
       if is_near_water($game_player.x, $game_player.y)
	     pbBGSPlay("babbling_brook")
	   
	   end
	end
	end
    return @result,@totalScore
  end
  
  def onPress
	@pressedTimes+=1
    arrowX = @sprites["arrow"].x
	if @arrowspeed<2
     @arrowspeed = 2
    end	
    @score= -(arrowX>@arrowXMiddle ? arrowX-@arrowXMiddle : @arrowXMiddle-arrowX)/@arrowspeed
	if @arrowspeed<2
     @arrowspeed = 2
    end	
	puts "Arrow Speed: #{@arrowspeed}"
    case(@score)
	 when 0
      @totalScore+=2
	  @zerochain+=1 if @oldscore==@score && !@score.nil?
      @totalScore+=@zerochain
	  pbExclaim($game_player,31) if @oldscore==@score && !@score.nil?
    when -1, -2
      @totalScore+=1
    when -8, -9, -10, -11, -6, -7,-5,-4,-3
      @totalScore-=2
    else
      @totalScore-=3
    end
	@oldscore=@score
    @moving = false
    @waitFrame=@frameCount+10
			 
		if @pressedTimes > 0
    case(@oldscore)
	 when 0
      @arrowspeed+=4
    when -1, -2
      @arrowspeed+=2
    when -4, -5, -3
    when -8, -9, -10, -11, -6, -7
      @arrowspeed-=1
    else
      @arrowspeed-=2
    end

	if @arrowspeed<2
     @arrowspeed = 2
    end	
      end
    if @arrowspeed>25
	  @arrowspeed=25
	end
    if @arrowspeed>@targetarrowspeed && rand(100) < 6
	    @arrowspeed-=1 if @arrowspeed-1>=@targetarrowspeed
	end  
	if @pressedTimes>@pulls
	puts "Total Score: #{@totalScore}"
    if @totalScore > 2
      @result = true
	  pbExclaim($game_player,32)
	  pbSEPlay("watersplash")
    elsif @totalScore >= 0 && @totalScore < 3
	  therand = rand(100) < 25
      @result = true if therand
	  pbExclaim($game_player,32) if therand
	  pbSEPlay("watersplash") if therand
	  @pulls+=3 if !therand
    elsif @totalScore<=-1
      @result = false
	  pbExclaim($game_player,36) 
    end
	end
  end  

  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class SuperFishingScreen
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(rodType,speedup,bait=nil)
    @scene.pbStartScene(rodType,speedup,bait)
    ret=@scene.pbMain(rodType,speedup,bait)
    @scene.pbEndScene
    return ret
  end
end

def pbSuperFishing(rodType,speedup,bait=nil)
  scene=SuperFishingScene.new
  screen=SuperFishingScreen.new(scene)
  return screen.pbStartScreen(rodType,speedup,bait)
end




ItemHandlers::UseInField.add(:OLDROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  
  if !$game_player.pbFacingTerrainTag.can_fish || (!$PokemonGlobal.surfing && !notCliff)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  theRods(item,1,:OldRod)
  next true
})

ItemHandlers::UseInField.add(:GOODROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  if !$game_player.pbFacingTerrainTag.can_fish || (!$PokemonGlobal.surfing && !notCliff)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  theRods(item,2,:GoodRod)
  next true
})

ItemHandlers::UseInField.add(:SUPERROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  if !$game_player.pbFacingTerrainTag.can_fish || (!$PokemonGlobal.surfing && !notCliff)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  theRods(item,3,:SuperRod)
  next true
})



def theRods(item,level,encounter_type)
  #if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
   # $game_system.bgm_pause
   # $game_temp.memorized_bgm = $game_system.getPlayingBGM
   # $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
  #end
  # testbgm = "Fishing Vibes" 
  # bgm = pbStringToAudioFile(testbgm) if testbgm
  # pbBGMFade(0.8)
  ## pbBGMPlay(bgm) if testbgm
  encounter_type = $PokemonEncounters.find_valid_encounter_type_for_weather(encounter_type, encounter_type)
  encounter = $PokemonEncounters.has_encounter_type?(encounter_type)
  encounter_type = [encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,"item"][rand([encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,encounter_type,"item"].length)]
  bait = nil
  if pbConfirmMessage(_INTL("Do you want to use any bait?"))
    pbFadeOutIn(99999){
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      bait = screen.pbChooseItemScreen(proc { |item| (GameData::Item.get(item).is_foodwater? || GameData::Item.get(item).is_berry?) && !GameData::Item.get(item).is_apricorn? && item!=:ACORN })
    }

	if !bait.nil?
    if $bag.remove(bait,1)
  bait_name = GameData::Item.get(bait).name
    else
	 bait = nil
     bait_name = nil
	 end
   end
  end

  loop do
  pbSEPlay("Battle throw")
  result,score = pbFishing(encounter, level, bait, encounter_type)
  case result
    when 1
	if encounter_type !="item"
    $stats.fishing_battles += 1
	$game_temp.in_safari=true
    pbEncounter(encounter_type)
	$game_temp.in_safari==false
	end
    when 2
	if encounter_type !="item"
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
    pokemon = pbGenerateWildPokemon(encounter[0],encounter[1])
    $player.pokedex.set_seen(pokemon.species)
	if !bait_name.nil?
	if bait_name == "Poisonous Meat"
	pokemon.status=:POISON 
	pokemon.hp-=rand(10)+1
	end
	end
    $player.pokedex.set_seen(pokemon.species)
	if !pokemon.fainted?
	loop do
	commands=[]
commands.push(_INTL"Yes")
commands.push(_INTL("No"))
commands.push(_INTL("Throw it back")) 
commands.push(_INTL("Check Stats")) 
commandMail = pbMessage(_INTL("Do you want to use #{pokemon.name} for food?"),commands, -1)
 if commandMail == 0
	pbCookMeat(false,pokemon,true,true)
	break
 elsif commandMail == 1
 
	pokemon.poke_ball=:POKEBALLC
	pokemon.calc_stats
    pbAddPokemonSilent(pokemon)
    pkmnAnim(pokemon)
	break
 elsif commandMail == 2
   pbMessage(_INTL("You throw it back."))
   break
 else
 
          pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene)
            summary_screen.pbStartScreen([pokemon], 0)
          }
 end
  end

    else
pbCollectionMain

    end
    else
	if encounter_type !="item"
	 if !bait_name.nil?
	if bait_name == "Poisonous Meat" || pokemon.status==:POISON
    pbMessage(_INTL("It seems to have died of the poison."))
	else
    pbMessage(_INTL("It seems to have died.")) 
	pbCookMeat(false,pokemon,true,true)
	end
	end
    else
	pbCollectionMain
	
	end
	end
  end

	commands=[]
commands.push(_INTL"With same bait")
commands.push(_INTL("With different bait"))
commands.push(_INTL("No")) 
commandMail = pbMessage(_INTL("Do you want to fish again?"),commands, -1)
 if commandMail == 0
   if !bait.nil?
   if $bag.remove(bait,1)
   else
    pbMessage(_INTL("You don't have anymore of that bait!.")) 
	  bait = nil
  bait_name = nil
   end
   end
  elsif commandMail == 1
    if pbConfirmMessage(_INTL("Do you want to use any bait?"))
    pbFadeOutIn(99999){
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      bait = screen.pbChooseItemScreen(proc { |item| (GameData::Item.get(item).is_foodwater? || GameData::Item.get(item).is_berry?) && !GameData::Item.get(item).is_apricorn? && item!=:ACORN })
    }
	if !bait.nil?
    if $bag.remove(bait,1)
  bait_name = GameData::Item.get(bait).name
    else
	 bait = nil
     bait_name = nil
	 end
   end
  end
  else
    pbFishingEnd
		#  if $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
       #        pbBGMFade(0.8)
       #        $game_system.bgm_pause
         #      $game_system.bgm_position = $game_temp.memorized_bgm_position
       #        $game_system.bgm_resume($game_temp.memorized_bgm)
			#    $game_temp.memorized_bgm = nil
		#	    $game_temp.memorized_bgm_position = nil
		  #end
    break
  end
  end
end


def fishingmodifiers(rodType,speedup,bait=nil)
  
  
  
  biteChance = 20 + (25 * rodType)   
  biteChance *= 1.5 if speedup
  hookChance = 45  
  biteChance *= 1.5 if GameData::Weather.get($game_screen.weather_type).category == :Rain
  biteChance *= 1.75 if GameData::Weather.get($game_screen.weather_type).category == :Storm
  biteChance *= 2 if GameData::Weather.get($game_screen.weather_type).category == :HeavyRain
  hookChance *= 1.5 if GameData::Weather.get($game_screen.weather_type).category == :Rain
  hookChance *= 1.75 if GameData::Weather.get($game_screen.weather_type).category == :Storm
  hookChance *= 2 if GameData::Weather.get($game_screen.weather_type).category == :HeavyRain
  return biteChance,hookChance if bait.nil?
  bait_name = GameData::Item.get(bait).name
  biteChance *= 4 if bait_name.include?("Meat")
  biteChance *= 1.25 if bait_name.include?("Sushi")
  hookChance *= 2 if bait_name.include?("Berry") 
  hookChance *= 1.25 if bait_name.include?("Sushi")

  return biteChance,hookChance
end



def pbFishing(hasEncounter, rodType, bait=nil, item_or_encounter)
  $stats.fishing_count += 1
  speedup = ($player.first_pokemon && [:STICKYHOLD, :SUCTIONCUPS].include?($player.first_pokemon.ability_id)  || $player.activeCharm?(:LURECHARM))
  biteChance, hookChance = fishingmodifiers(rodType,speedup,bait)
  bait_name = GameData::Item.get(bait).name if !bait.nil?
  pbFishingBegin
  msgWindow = pbCreateMessageWindow
  ret = 0
  score = 0
  loop do
    time = rand(5..10)
    time = [time, rand(5..10)].min if speedup
    message = ""
    time.times { message += ".   " }
    if bait_name=="Poisonous Meat" && rand(100) < 76 && !bait.nil?
      pbFishingEnd {
        pbMessageDisplay(msgWindow, _INTL("The fish avoid the poison."))
      }
      break
    end
    if pbWaitMessage(msgWindow, time)
      pbFishingEnd {
        pbMessageDisplay(msgWindow, _INTL("Not even a nibble..."))
      }
      break
    end
    
    
	
	
	
    
    
    if hasEncounter && rand(100) < biteChance
      $scene.spriteset.addUserAnimation(Settings::EXCLAMATION_ANIMATION_ID, $game_player.x, $game_player.y, true, 3)
      frames = Graphics.frame_rate - rand(Graphics.frame_rate / 2)   # 0.5-1 second
	  
	  
	  
	  
      if !pbWaitForInput(msgWindow, message + _INTL("\r\nOh! A bite!"), frames)
        pbFishingEnd {
          pbMessageDisplay(msgWindow, _INTL("You didn't reel in fast enough..."))
        }
        break
      end
	  
	  
	  
	  
	  
      if rand(100) < hookChance
	  
	  
	  
      ret, score = pbSuperFishing(rodType,speedup,bait)
	    if ret==false
        pbFishingEnd {
          pbMessageDisplay(msgWindow, _INTL("The Pokémon doesn't look happy!")) if item_or_encounter != "item"
		   ret=1
        }
		elsif ret==true
        pbFishingEnd {
		   ret=2
        }
		end
        break
		
	  else
      pbFishingEnd {
        pbMessageDisplay(msgWindow, _INTL("The Pokémon fled as you started reeling..."))
      }
      break
      end
	  
	  
	  







    else
      pbFishingEnd {
        pbMessageDisplay(msgWindow, _INTL("Not even a nibble..."))
      }
      break
    end
  end
  pbDisposeMessageWindow(msgWindow)
  return ret, score
end


