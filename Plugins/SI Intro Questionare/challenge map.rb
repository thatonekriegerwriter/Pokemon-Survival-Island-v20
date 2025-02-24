class GameStats
  attr_accessor :challenges_ran
  attr_accessor :challenges_lost
  attr_accessor :challenges_won
  attr_accessor :challenges_continued
  attr_accessor :challenges_restarted

  alias _challenge_GameStats_Init initialize
  def initialize
    _challenge_GameStats_Init
	
    @challenges_ran               = 0
    @challenges_lost               = 0
    @challenges_won               = 0
    @challenges_continued          = 0
    @challenges_restarted                   = 0
  end
  
	def challenges_ran
	 @challenges_ran = 0 if @challenges_ran.nil?
	 return @challenges_ran
	end
	def challenges_lost
	 @challenges_lost = 0 if @challenges_lost.nil?
	 return @challenges_lost
	end
	def challenges_won
	 @challenges_won = 0 if @challenges_won.nil?
	 return @challenges_won
	end
	def challenges_continued
	 @challenges_continued = 0 if @challenges_continued.nil?
	 return @challenges_continued
	end
	def challenges_restarted
	 @challenges_restarted = 0 if @challenges_restarted.nil?
	 return @challenges_restarted
	end
end

class PokemonGlobalMetadata
    attr_accessor :in_challenge
    attr_accessor :challenge_active
    attr_accessor :challenge_maps
    attr_accessor :challenge_type
    attr_accessor :cur_challenge
	
	
	def in_challenge
	 @in_challenge = false if @in_challenge.nil?
	 return @in_challenge
	end
	
	
	def challenge_type
	 @challenge_type = "Wave Defense" if @challenge_type.nil?
	 return @challenge_type
	end
	
	
	def challenge_active
	 @challenge_active = false if @challenge_active.nil?
	 return @challenge_active
	end
	
	
	def challenge_maps
	 return @challenge_maps = [11]
	end
	
	
	def cur_challenge
	 @cur_challenge = false if @cur_challenge.nil?
	 @cur_challenge = false if @cur_challenge.is_a?(TrueClass)
	 return @cur_challenge
	end
end
#$PokemonGlobal.challenge_active

class ChallengeData
    attr_accessor :event
    attr_accessor :boss
    attr_accessor :current_round
    attr_accessor :next_bgm
    attr_accessor :challenge_level
    attr_accessor :challenge_running
    attr_accessor :opponents_bosses
    attr_accessor :opponents_minibosses
    attr_accessor :opponents
    attr_accessor :opponent_events
    attr_accessor :next_opponent
    attr_accessor :current_opponent
    attr_accessor :shop_items
    attr_accessor :points
    attr_accessor :levels
    attr_accessor :spawn_queue
    attr_accessor :placed
    attr_accessor :loop_amt2
    attr_accessor :beaten
	
	
  def initialize(event = nil)
    @event = event if !event.nil?
    @current_round = 0
    @challenge_level = nil
    @next_bgm = nil
    @boss = false
    @placed = false
    @levels = 0
    @loop_amt = 0
    @loop_amt2 = 0
    @handled = []
    @beaten = 0
    @challenge_running = false
	@default_song = "a Battle 02"
    @opponents_bosses = [
	  [[:GIRATINA],"Giratina"],
	 [[:ZEKROM,:KYUREM,:RESHIRAM],"noodle"],
	  [[:XATU,:XATU,:XATU,:XATU,:XATU],"UN Owen was Xatu"],
	  [[:MEWTWO],"Pokémon The Origins Recreation - Mewtwo Battle (HQ)"]
	  ]
    @opponents = get_opponents
    @opponents_minibosses = [
	  [:DRAGONITE,:TYRANITAR,:SALAMENCE],
	  [:METAGROSS,:GARCHOMP,:HYDREIGON],
	  [:GOODRA,:KOMMOO,:DRAGAPULT],
	  [:ARCANINE,:NINETALES],
	  [:VENUSAUR,:CHARIZARD, :BLASTOISE],
	  [:ALAKAZAM,:MACHAMP, :GENGAR] #,"The Power to Control"]
	]
    @shop_items = [
	  [:ACORN,1],
	  [:ORANBERRY,1],
	  [:STONE,2],
	  [:GLASS,3],
	  [:COAL,4],
	  [:IRONORE,5],
	  [:SITRUSBERRY,5],
	  [:POKEBALLC,10],
	  [:MASTERBALL,40]
	]
    @current_opponent = []
    @next_opponent = []
    @points = 0
    @opponent_events = []
    @spawn_queue = []
  end
  def get_opponents
       available = []
          GameData::Species.each_species do |species|
		     species1 = GameData::Species.try_get(species).id
		      next if available.include?(species1)
			  next if pbLegendaryStarter?(species1.to_s)
			  next if GameData::Species.try_get(species1).has_flag?("UltraBeast")
			  next if GameData::Species.try_get(species1).has_flag?("Unreleased")
			  next if GameData::Species.try_get(species1).has_flag?("Mythical")
			  next if GameData::Species.try_get(species1).has_flag?("Legendary")
              evo = GameData::Species.get(species1).get_family_species
			    if !evo[0].nil?
			   available << evo[0] if !GameData::Species.try_get(evo[0]).has_flag?("Unreleased")
			    end
			    if !evo[3].nil?
              available << evo[3] if !GameData::Species.try_get(evo[3]).has_flag?("Unreleased")
			    end
          end
       return available
  
  end
  def get_rounds_length
     case @challenge_level
        when :VERY_EASY
		  return 2
        when :EASY
		  return 5
        when :NORMAL
		  return 8
        when :HARD
		  return 11
        when :VERY_HARD
		  return 14
		 else
		  return 0
	 end
  end
  def get_next_opponent
     
    @next_bgm = nil
     thresholds = (@current_round/3).to_i
	 thresholds = 1 if thresholds<1
	 if (@current_round == get_rounds_length+1 && @current_round!=0) || (@current_round % 6 == 0 && @current_round!=0)
	    opponent = @opponents_bosses[rand(@opponents_bosses.length)]
	   @next_opponent = opponent[0]
	    @next_bgm = opponent[1]
    @boss = true
	 elsif @current_round % 3 == 0 && @current_round!=0 && @current_round!=get_rounds_length+1
	    opponent = @opponents_minibosses[rand(@opponents_minibosses.length)]
	    @next_bgm = "The Power to Control"
	   @next_opponent = opponent
	   
    @boss = true
	 else
	 
	 opponent_amt = thresholds+1
	 opponent_amt = 6 if opponent_amt>6
	 puts opponent_amt
	 opponent_amt.times do |i|
	   ownop = :LUVDISC
	     loop do
       ownop = @opponents[rand(@opponents.length)]
		  break if !ownop.nil?
		 end
	    @next_opponent << ownop
     end
	 
    @next_bgm = @default_song
	  @boss=false
	 end
  end
  
  def start_round
    pbBGMPlay(@next_bgm,75)
    @current_opponent = @next_opponent.dup if @current_opponent.empty?
    @next_opponent = []
	get_cur_level
    @current_opponent.each_with_index do |opponent, index|
		pokemon = Pokemon.new(opponent, @levels)
		 if index==0
	    $game_map.spawnPokeEventForChallenge(30,27,pokemon,true)
		 else
	    $game_map.spawnPokeEventForChallenge(30,27,pokemon)
		 end
	
	end
    @challenge_running=true
	 $PokemonGlobal.cur_challenge = self
	 
     pbMapInterpreter.pbSetSelfSwitch(@event.id, "A", true)  
  end
  def get_level
  
  
     case @challenge_level
        when :VERY_EASY
		  return 5
        when :EASY
		  return 10
        when :NORMAL
		  return 20
        when :HARD
		  return 40
        when :VERY_HARD
		  return 60
		 else
		  return 5
	 end
   
  end
  def get_cur_level
	 if @levels == 0
	   @levels = get_level
	 end
   if @current_round>get_rounds_length
      amt = @current_round-get_rounds_length
	  if amt % 5 == 0
	    @levels+=5
		@levels=100 if @levels>100
	  end
	  end
   end
    
  
  

  def update
    return if @challenge_running==false
	  
	
	if @loop_amt==Graphics.frame_rate*2
	  nils = [] 
	  @opponent_events.each do |event|
	    nils << event if event.nil? && !nils.include?(event)
	  end
	   if nils.length== @opponent_events.length
	     @beaten = nils.length
	   end
     if @beaten == @opponent_events.length
	      @points+=@beaten
	   pbBGMFade(2.0)
	   pbBGMPlay($game_map.bgm.name,75)
	   @opponent_events=[]
	   @current_opponent = []
	   @handled = []
       @beaten = 0
	   @current_round+=1
	   @boss = false
	   @placed==false
	   pbMapInterpreter.pbSetSelfSwitch(@event.id, "A", false)  
	   @challenge_running=false
	 end
     @loop_amt=0 
    else
    @loop_amt+=1
   
   end

  end
end

 EventHandlers.add(:on_frame_update, :update_challenge,
  proc { 
      next if !$scene.is_a?(Scene_Map)
	  next if $PokemonGlobal.cur_challenge.nil?
	  next if $PokemonGlobal.cur_challenge==false
	  next if $PokemonGlobal.cur_challenge.challenge_running==false
	  $PokemonGlobal.cur_challenge.update
   }
  )



  def spawn_event
     $PokemonGlobal.cur_challenge.placed=true
  	  spawn_queue = $PokemonGlobal.cur_challenge.spawn_queue.dup
	  placed_one = false
	  if spawn_queue.length>0
	  spawn_queue.each_with_index do |i,index|
	     next if placed_one == true
	     pokemon = i[0]
	     event = i[1]
	     mapId=$game_map.map_id
	     key_id = ($game_map.events.keys.max || -1) + 1

	     x=30
	     y=27
	     event2 = $game_map.check_event(x, y)
	     next if $game_temp.preventspawns==true
	     next if event2.is_a?(Integer)
	     next if key_id.nil?
		 event.id = key_id
		 event.x = x
		 event.y = y
         gameEvent = Game_PokeEvent.new(mapId, event, $game_map)
         gameEvent.id = key_id
         gameEvent.moveto(x,y)
         gameEvent.pokemon = pokemon
	     next if $game_temp.preventspawns==true
	     $game_map.events[key_id] = gameEvent
		 placed_one=true
	     sprite = Sprite_Character.new(Spriteset_Map.viewport,$game_map.events[key_id])
	     $scene.spritesets[$game_map.map_id]=Spriteset_Map.new($game_map) if $scene.spritesets[$game_map.map_id]==nil
	     $scene.spritesets[$game_map.map_id].character_sprites.push(sprite)
	     $PokemonGlobal.cur_challenge.opponent_events<<key_id
		  
		  $PokemonGlobal.cur_challenge.spawn_queue.delete_at(index)
	  end




 end
 
     $PokemonGlobal.cur_challenge.placed=false
	 
  end

 EventHandlers.add(:on_frame_update, :spawn_queued_challenge_events,
  proc { 
     
      next if !$scene.is_a?(Scene_Map)
	     next if pbMapInterpreterRunning?
	     next if $game_temp.preventspawns==true
	  next if $PokemonGlobal.cur_challenge.nil?
	  next if $PokemonGlobal.cur_challenge==false
	  next if $PokemonGlobal.cur_challenge.challenge_running==false
	  next if $PokemonGlobal.cur_challenge.spawn_queue.length == 0
	  if $PokemonGlobal.cur_challenge.loop_amt2==120
	    spawn_event
	  else
	    $PokemonGlobal.cur_challenge.loop_amt2+=1
	  end

  }
)



 def create_commands_window(commands,text,help=[])
    text += "\\wtnp[1]"
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL(text))
	 if help.length>0
    commands2 = pbShowCommandsWithHelp(msgwindow,commands,help,-1,0)
	 else
    commands2 = pbShowCommands(msgwindow,commands,-1)
	 end
	pbDisposeMessageWindow(msgwindow)
 
    return commands2
 
 end

def pbChallengeOver
  playingBGS = $game_system.getPlayingBGS
  playingBGM = $game_system.getPlayingBGM
  $game_system.bgm_pause(1.0)
  $game_system.bgs_pause(1.0)
  pos = $game_system.bgm_position
  pbFadeOutIn {
	   pbBGMPlay("020-Field03",75)
	   commands = []
      cmd_continue     = -1
      cmd_restart     = -1
      cmd_end     = -1
	   text = "You died! What would you like to do?"
      commands[cmd_continue = commands.length] = _INTL('Continue') if $PokemonGlobal.cur_challenge.points>=10
      commands[cmd_restart = commands.length] = _INTL('Restart Round')
      commands[cmd_end = commands.length]      = _INTL('End Game')
	   help = []
      help[help.length] = _INTL('Spend 10 Points to Continue your game.') if $PokemonGlobal.cur_challenge.points>=10
      help[help.length] = _INTL('Restart the round with your current items and points.')
      help[help.length] = _INTL("Quit playing #{$PokemonGlobal.challenge_type}: Round - #{$PokemonGlobal.cur_challenge.current_round}")
	  the_commands = create_commands_window(commands, text, help)
	  if cmd_continue >= 0 && the_commands == cmd_continue
	     $player.playerhealth = $player.playermaxhealth
		 $PokemonGlobal.cur_challenge.points-=10
        $game_system.bgm_position = pos
        $game_system.bgm_resume(playingBGM)
        $game_system.bgs_resume(playingBGS)
      elsif cmd_restart >= 0 && the_commands == cmd_restart
	    $PokemonGlobal.cur_challenge.opponent_events.each do |id|
		 event = $game_map.events[id]
        event.removeThisEventfromMap
		end
		 $PokemonGlobal.cur_challenge.challenge_running=false
		 pbBGMFade(1.0)
      elsif cmd_end >= 0 && the_commands == cmd_end

    if pbConfirmMessage(_INTL("Are you sure you want to quit the game?"))
      pbSEPlay("GUI save choice")
		 pbBGMFade(1.0)
	  pbWait(1)
	  pbWait(1)
	  $scene.dispose
	$scene = pbCallTitle(false)
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
    end


	  end
    }
end


def pbChallengeMap
    if $PokemonGlobal.cur_challenge!=false
	 if $PokemonGlobal.cur_challenge.challenge_running
	  sideDisplay("You can't use the statue while the challenge is running!")
	  return
	 end
	end
    if $PokemonGlobal.challenge_active==true && !$PokemonGlobal.challenge_maps.include?($game_map.map_id)
        pbMessage((_INTL"I'm not quite sure how you reached this state."))
        pbMessage((_INTL"I'm going to move you back to the primary challenge map."))
	    pbTeleportToLocation(11,24,10)
		return
	elsif $PokemonGlobal.challenge_active==false && $PokemonGlobal.challenge_maps.include?($game_map.map_id) && !$DEBUG
        pbMessage((_INTL"I'm not quite sure how you reached this state."))
        pbMessage((_INTL"I'm going to move you back to the main game now."))
	    pbTeleportToLocation(5,16,41)
		return
	end
    interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue
      statue = ChallengeData.new(this_event)
    end
	 statue = $PokemonGlobal.cur_challenge if statue!=$PokemonGlobal.cur_challenge && $PokemonGlobal.cur_challenge!=false && $PokemonGlobal.cur_challenge.is_a?(ChallengeData)
	
	
	$PokemonGlobal.cur_challenge = statue if $PokemonGlobal.cur_challenge==false
    if statue.challenge_running==true
	  sideDisplay("You can't use the statue while the challenge is running!")
	  return
	end
	$game_temp.preventspawns=false
	
	  if statue.current_round ==  0 && statue.challenge_level.nil?
	   commands = []
      cmd_very_easy     = -1
      cmd_easy     = -1
      cmd_normal     = -1
      cmd_hard     = -1
      cmd_very_hard     = -1
      cmd_cancel     = -1
      commands[cmd_very_easy = commands.length] = _INTL('Very Easy')
      commands[cmd_easy = commands.length] = _INTL('Easy')
      commands[cmd_normal = commands.length] = _INTL('Normal')
      commands[cmd_hard = commands.length] = _INTL('Hard')
      commands[cmd_very_hard = commands.length] = _INTL('Very Hard')
      commands[cmd_cancel = commands.length]      = _INTL('Cancel')
	   text = "What difficulty?"
	   the_commands = create_commands_window(commands,text)
	  if cmd_very_easy >= 0 && the_commands == cmd_very_easy
	     statue.challenge_level=:VERY_EASY
	  elsif cmd_easy >= 0 && the_commands == cmd_easy
	     statue.challenge_level=:EASY
	  elsif cmd_normal >= 0 && the_commands == cmd_normal
	     statue.challenge_level=:NORMAL
	  elsif cmd_hard >= 0 && the_commands == cmd_hard
	     statue.challenge_level=:HARD
	  elsif cmd_very_hard >= 0 && the_commands == cmd_very_hard
	     statue.challenge_level=:VERY_HARD
	  elsif cmd_cancel >= 0 && the_commands == cmd_cancel
	    return
	  elsif Input.trigger?(Input::BACK)
	    return
	  end
	end
	  
	   statue.get_next_opponent if statue.next_opponent.empty?
	
    pbFadeOutIn {
    scene = ChallengeMap_Scene.new
    screen = ChallengeMapScreen.new(scene)
    screen.pbMain(statue)
    }
	 
	
	




end


class ChallengeMap_Scene
    attr_accessor :challenge_data
    attr_accessor :do_not
  def pbStartScreen(challenge_data)
    @challenge_data = challenge_data
    @do_not = false
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
	
	
    mapname = "Current Round: #{@challenge_data.current_round+1}"
	upcomingenemies = "ERROR"
	upcomingenemies = "???" if false
	upcomingenemies = @challenge_data.next_opponent.dup if !@challenge_data.next_opponent.empty?
	if upcomingenemies.is_a?(Array)
	 checked=[]
	 string = ""
	 upcomingenemies.each_with_index do |pkmn,index|
	   next if pkmn.nil?
	   next if checked.include?(pkmn)
	 count = upcomingenemies.count(pkmn)
	 name = GameData::Species.try_get(pkmn).name
	 string += "#{name} x#{count}"
	 string += ", " if index!=upcomingenemies.length-1 ||  upcomingenemies.length!=count
	 checked << pkmn
	 end
    upcomingenemies = string
	end
	if upcomingenemies == "ERROR"
	  @do_not=true
	end
    textColor = ["0070F8,78B8E8", "E82010,F8A8B8", "0070F8,78B8E8"][$player.gender]
    locationColor = "209808,90F090"   # green
    loctext = _INTL("<ac><c3={1}>{2}</c3></ac>", textColor, mapname)
    loctext += _INTL("Upcoming Enemies: <r>{1}<br>", upcomingenemies)
    loctext += _INTL("Points<r>{1}<br>", @challenge_data.points)
    @sprites["nubg"] = IconSprite.new(0,0,@viewport)
    @sprites["nubg"].setBitmap(_INTL("Graphics/Pictures/loadslotsbg"))
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new(loctext)
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].x = 0-BorderSettings::SCREENPOSX
    @sprites["locwindow"].y = 0-BorderSettings::SCREENPOSY
    @sprites["locwindow"].width = 228 if @sprites["locwindow"].width < 228
    @sprites["locwindow"].visible = true
	
	
	
	
  end
  def refresh
	
	
    mapname = "Current Round: #{@challenge_data.current_round+1}"
	upcomingenemies = "ERROR"
	upcomingenemies = "???" if false
	upcomingenemies = @challenge_data.next_opponent.dup if !@challenge_data.next_opponent.empty?
	if upcomingenemies.is_a?(Array)
	 checked=[]
	 string = ""
	 upcomingenemies.each_with_index do |pkmn,index|
	   next if pkmn.nil?
	   next if checked.include?(pkmn)
	 count = upcomingenemies.count(pkmn)
	 name = GameData::Species.try_get(pkmn).name
	 string += "#{name} x#{count}"
	 string += ", " if index!=upcomingenemies.length-1 ||  upcomingenemies.length!=count
	 checked << pkmn
	 end
    upcomingenemies = string
	end
	if upcomingenemies == "ERROR"
	  @do_not=true
	end
    textColor = ["0070F8,78B8E8", "E82010,F8A8B8", "0070F8,78B8E8"][$player.gender]
    loctext = _INTL("<ac><c3={1}>{2}</c3></ac>", textColor, mapname)
    loctext += _INTL("Upcoming Enemies: <r>{1}<br>", upcomingenemies)
    loctext += _INTL("Points<r>{1}<br>", @challenge_data.points)
    @sprites["locwindow"].text = loctext
  
  end
  def get_upcoming_enemies
    @challenge_data.current_round
  
  
  end

  def pbEndScreen
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class ChallengeMapScreen
  def initialize(scene)
    @scene = scene
  end

  def pbDisplay(text, brief = false)
    @scene.pbDisplay(text, brief)
  end

  def pbDisplayPaused(text)
    @scene.pbDisplayPaused(text)
  end

  def pbConfirm(text)
    return @scene.pbConfirm(text)
  end

  def pbMain(challenge_data)
    ret = false
    @scene.pbStartScreen(challenge_data)
	   commands = []
      cmd_start_game     = -1
      cmd_shop     = -1
      cmd_end_game     = -1
      cmd_cancel     = -1
      commands[cmd_start_game = commands.length] = _INTL('Start Round')
      commands[cmd_shop = commands.length] = _INTL('Shop')
      commands[cmd_end_game = commands.length]      = _INTL('End Game')
      commands[cmd_cancel = commands.length]      = _INTL('Cancel')
	   text = "What would you like to do?"
	   loop do
	   the_commands = create_commands_window(commands,text)
	  if cmd_start_game >= 0 && the_commands == cmd_start_game
	   if @scene.do_not==false
	    challenge_data.start_round
	   else
	    pbMessage(_INTL("Something has gone critically wrong. Thankfully this caught it."))
	   end
	    break
	  elsif cmd_shop >= 0 && the_commands == cmd_shop
	   text2 = "What would you like to buy?"
	   shop_items = challenge_data.shop_items
	     commands2=[]
		shop_items.each do |item|
		  commands2<<"#{GameData::Item&.try_get(item[0]).name} - #{item[1]} Points"
		end
		  commands2<< "Cancel"
		  loop do
	   the_commands = create_commands_window(commands2,text2)
	   if the_commands==-1 || the_commands==commands2.length
	     break
	   elsif (challenge_data.points-shop_items[the_commands][1])<0
	     pbMessage(_INTL("You don't have enough points."))
	   else
	   $bag.add(shop_items[the_commands][0])
	   challenge_data.points = challenge_data.points-shop_items[the_commands][1]
	   @scene.refresh
	    end
		end
	  elsif cmd_end_game >= 0 && the_commands == cmd_end_game

    if pbConfirmMessage(_INTL("Are you sure you want to quit the game?"))
      pbSEPlay("GUI save choice")
		 pbBGMFade(1.0)
	  pbWait(1)
	  pbWait(1)
	  $scene.dispose
	$scene = pbCallTitle(false)
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
	    break
    end


	  elsif cmd_cancel >= 0 && the_commands == cmd_cancel
	    break
	  elsif Input.trigger?(Input::BACK)
	    break
	  end
	  end
     @scene.pbEndScreen
	  end
    
  end


