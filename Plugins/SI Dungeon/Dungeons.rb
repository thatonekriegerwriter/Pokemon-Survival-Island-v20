EventHandlers.add(:on_wild_battle_end, :dungeonbattle,
  proc { |species, level, decision|
  if $PokemonGlobal.in_dungeon==true
    pkmn = species 
	joinrnd = rand(100)
	firstPkmn = $player.first_pokemon
    if decision == 1
    	if level > firstPkmn.level+5
	  chances = 10
    elsif level > firstPkmn.level+10
	  chances = 5
    elsif level > firstPkmn.level+20
	  chances = 1
	else 
	  chances = 15
    end 	
       if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = chances+10
    when :SUPERLUCK
      chances = chances+25
    end
	if firstPkmn.item == :WONDERORB
      chances = chances+15
	end
	if firstPkmn.hasMove?(:FALSESWIPE)
      chances = chances+15
	end
  end
    	if joinrnd<chances 
	if pbConfirmMessage(_INTL("Oh! {1} want's to join your Party! Do you want {1} to join your Party?",pkmn))
	  pbMessage(_INTL("{1} is overjoyed!",pkmn))
	  pbAddPokemonSilent(species,level)
	else
	  pbMessage(_INTL("{1} leaves crying.",pkmn))
	end

	end
  	elsif decision == 2
      leavingDungeon
  end
  
  end
  }
)

#===============================================================================
# Code that generates a random dungeon layout, and implements it in a given map.
#===============================================================================
EventHandlers.add(:on_game_map_setup, :random_dungeon,
  proc { |map_id, map, _tileset_data|
    next if !GameData::MapMetadata.try_get(map_id)&.random_dungeon
    # Generate a random dungeon
    tileset_data = GameData::DungeonTileset.try_get(map.tileset_id)
    params = GameData::DungeonParameters.try_get($PokemonGlobal.dungeon_area,
                                                 $PokemonGlobal.dungeon_version)
    dungeon = RandomDungeon::Dungeon.new(params.cell_count_x, params.cell_count_y,
                                         tileset_data, params)
    dungeon.generate
    map.width = dungeon.width
    map.height = dungeon.height
    map.data.resize(map.width, map.height, 3)
    dungeon.generateMapInPlace(map)
    occupied_tiles = []
    # Reposition the player
    tile = dungeon.get_random_room_tile(occupied_tiles)
	if $PokemonGlobal.in_dungeon==true && tile
      $PokemonGlobal.dungeon_x = tile[0]
      $PokemonGlobal.dungeon_y = tile[1]
	else
    if tile
      $game_temp.player_new_x = tile[0]
      $game_temp.player_new_y = tile[1]
    end
	end
    # Reposition events
	amt = [rand(60),30].max
	ore_type = [:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:STONE,:TUMBLESTONE,:TUMBLESTONE,:TUMBLESTONE,:TUMBLESTONE,:TUMBLESTONE,:TUMBLESTONE,:IRON2,:IRON2,:IRON2,:IRON2,:IRON2,:GOLD2,:GOLD2,:SILVER2,:SILVER2,:COPPER2,:COPPER2,:COPPER2,:COPPER2,
	:COPPER2,:COAL,:COAL,:COAL,:COAL,:COAL,:FIRESTONE,:WATERSTONE,:THUNDERSTONE,:LEAFSTONE,:MOONSTONE,:DAWNSTONE,:ICESTONE,:SUNSTONE,:OVALSTONE,:EVERSTONE,:LIGHTCLAY,:LIGHTCLAY,:THUNDERSTONE,:HARDSTONE,:EVIOLITE,:EVERSTONE,:STONE,:STONE,:STONE]
	amt.times do |x|
	 ore = ore_type[ore_type.length]
	 pbPlaceOre(x+rand(10),x+rand(10),ore)
	
	
	end

	amt2 = [rand(10),5].max
	amt.times do |x|
	 pbPlaceOre(x+rand(20)+10,x+rand(20)+10,"MININGMINIGAME")
	
	end
    map.events.each_value do |event|
	 if event.name[/doorexit/i]
      tile = dungeon.get_random_wall_tile(occupied_tiles)
      if tile
        event.x = tile[0]
        event.y = tile[1]
      end
	 else
      tile = dungeon.get_random_room_tile(occupied_tiles)
      if tile
        event.x = tile[0]
        event.y = tile[1]
      end
	 end
    end
  }
)


class FollowerData

  def move_followers
    
    leader = $PokemonGlobal.dungeon_leader if $PokemonGlobal.in_dungeon!=false
    leader = $game_player if $PokemonGlobal.in_dungeon!=false
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.follow_leader(leader, false, (i == 0))
      follower.x              = event.x
      follower.y              = event.y
      follower.current_map_id = event.map.map_id
      follower.direction      = event.direction
      leader = event
    end
  end




end


  def pbStorePokemonPC(pkmn)
    oldCurBox = pbCurrentBox
    storedBox = $PokemonStorage.pbStoreCaught(pkmn)
    if storedBox < 0
      # NOTE: Poké Balls can't be used if storage is full, so you shouldn't ever
      #       see this message.
      pbDisplayPaused(_INTL("Can't catch any more..."))
      return oldCurBox
    end
    return storedBox
  end
  
  def xatu_mart_setup
    item1=0
	item2=0
	item3=0
    itemscommon=[:ORANMASH,:ARGOSTBERRY,:LEPPABERRY,"RANDOMGEM",:ORANBERRY]
    itemsuncommon=[:KINGSROCK,:RAZORFANG,:ROCKYHELMET,:LIFEORB,:FOCUSBAND]
    itemsrare=[:PURESEED,:METRONOME,:WONDERORB,:QUICKCLAW,:RAZORCLAW]
	itemsgem=[:FIREGEM,:WATERGEM,:ELECTRICGEM,:GRASSGEM,:ICEGEM,:FIGHTINGGEM,:POISONGEM,
	:GROUNDGEM,:FLYINGGEM,:PSYCHICGEM,:BUGGEM,:ROCKGEM,:GHOSTGEM,:DRAGONGEM,:DARKGEM,:STEELGEM,
	:FAIRYGEM,:NORMALGEM,:LIGHTBALL]
	rnditems=[itemscommon,itemsuncommon,itemsrare]
	itemchoice1 = rnditems[rand(3)]
	itemchoice2 = rnditems[rand(3)]
	itemchoice3 = rnditems[rand(3)]
	if itemchoice1 == itemscommon
	 cost1 = 1
	end
	if itemchoice2 == itemscommon
	 cost2 = 1
	end
	if itemchoice3 == itemscommon
	 cost3 = 1
	end
	if itemchoice1 == itemsuncommon
	 cost1 = 2
	end
	if itemchoice2 == itemsuncommon
	 cost2 = 2
	end
	if itemchoice3 == itemsuncommon
	 cost3 = 2
	end
	if itemchoice1 == itemsrare
	 cost1 = 3
	end
	if itemchoice2 == itemsrare
	 cost2 = 3
	end
	if itemchoice3 == itemsrare
	 cost3 = 3
	end
    item1 = itemchoice1[rand(5)]
    item2 = itemchoice2[rand(5)]
    item3 = itemchoice3[rand(5)]
	if item1 == "RANDOMGEM"
    item1 = itemsgem[rand(19)]
    elsif item2 == "RANDOMGEM"
    item2 = itemsgem[rand(19)]
    elsif item3 == "RANDOMGEM"
    item3 = itemsgem[rand(19)]
	end
	
	
	$game_temp.dungeon_xatu_mart = [[item1,cost1],[item2,cost2],[item3,cost3]]
  end
  
  
  def dungeon_transfer(mapid,x,y,enter=true)
    pbFadeOutIn {
      $game_temp.player_new_map_id    = mapid
      $game_temp.player_new_x         = 0
      $game_temp.player_new_y         = 0
      $game_temp.player_new_direction = $game_player.direction
      $PokemonGlobal.surfing = false
      $PokemonGlobal.diving  = false
      pbUpdateVehicle
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
    }
    pbTransform($game_player,"empty",false,false) if enter==true
  
  end
  
  
  def enterDungeon(dungeon)
    pbMessage(_INTL("There seems to be a hole in the ground here, while its wide, it narrows to the point only a POKeMON can fit through.")) if dungeon == :TEMPERATECAVES
    if pbConfirmMessage(_INTL("Do you want to go into the Dungeon?")) 
      $PokemonGlobal.in_dungeon=true
      FollowingPkmn.toggle_off
	  mapid = 145 if dungeon == :TEMPERATECAVES
     parameters = PokemonSelection::Parameters.new.setMinPokemon(1).setMaxPokemon(2).setCanCancel(true)
  	  PokemonSelection.choose(parameters) if enter==true
     if PokemonSelection.canCancel==false
     dungeon_transfer(mapid,0,0)
      $player.party.each_with_index do |pkmn,index|
	    pbPlacePokemonDungeon(index)
	   end
      $player.party.each_with_index do |pkmn,index|
	   event = getOverworldPokemonfromPokemon(index)
	   $PokemonGlobal.dungeon_leader=event if index == 0
	   Followers.add(event.id, pkmn.name, 6) if index > 0
	   end
	  end

    end
  end
  
  def leavingDungeon
      $player.party.each_with_index do |pkmn,index|
	   event = getOverworldPokemonfromPokemon(index)
	   event.removeThisEventfromMap
	   $PokemonGlobal.dungeon_leader=0 if index == 0
	   Followers.remove(pkmn.name) if index > 0
	   if index > 1
	    pbStorePokemonPC(pkmn)
	   end
	   end
	   
	   mapid,x,y = 204,29,18 if dungeon == :TEMPERATECAVES
      dungeon_transfer(mapid,x,y,false)
	   pbDetransform
	   PokemonSelection.restore
      $PokemonGlobal.in_dungeon=false
      $PokemonGlobal.dungeon_floor=0
  end

  def getFloorMessage(floor)
     message = _INTL("There's the roar of something monsterous below, do you enter?") if floor == :FINAL
     message = _INTL("There's the sound of birds and the rustle of grass, would you like to exit?") if floor == :EXIT
     message = _INTL("There's the echos of a lonely cave, would you like to enter?") if floor == :CAVE
     message = _INTL("There's the echos of rushing water, would you like to enter?") if floor == :CAVE_WATER
    return message
  end
  def getDungeonMapID(floor,dungeon)
     case dungeon 
	   when :TEMPERATECAVES
	     case floor
		   when :CAVE
		     return 114
		   when :CAVE_WATER
		     return 156
		   when :FINAL
		     return 336
		 
		 
		 end
	   when :DEEPCAVES
	   when :DEEPSWAMP
	 
	 
	 
	 
	 end
  
  
  end
  def dungeondoor(floor,dungeon)
    if pbConfirmMessage(getFloorMessage(floor))
		followerids = []
	    $PokemonGlobal.followers.each_with_index do |follower, i|
		   thefollower  = @events[i]
          followerids << thefollower.id
		 end
	  $game_map.events.each_with_index do |event,index|
	    next if $PokemonGlobal.dungeon_leader.id == index
		next  if followerids.include?(index)
	    pbSetSelfSwitch(index, "A", false)
	 end
       $PokemonGlobal.dungeon_floor+=1
	   $game_temp.dungeon_xatu_mart=[]
	   if floor == :EXIT
	    leavingDungeon
	   else
	    dungeon_transfer(getDungeonMapID(floor,dungeon),x,y,enter=true)
	   end
    end
  end

def the_xatu_mart
    xatu_mart_setup if !$game_temp.dungeon_xatu_mart.empty? || !$game_temp.dungeon_xatu_mart.nil?
	if !$game_temp.dungeon_xatu_mart.nil? || !$game_temp.dungeon_xatu_mart.empty?
    pbMessage(_INTL("This Xatu may be willing to sell you things."))
	 loop do
	   item1=$game_temp.dungeon_xatu_mart[0][0]
	   item2=$game_temp.dungeon_xatu_mart[1][0]
	   item3=$game_temp.dungeon_xatu_mart[2][0]
	   cost1=$game_temp.dungeon_xatu_mart[0][1]
	   cost2=$game_temp.dungeon_xatu_mart[1][1]
	   cost3=$game_temp.dungeon_xatu_mart[2][1]
	   message1= _INTL("#{GameData::Item.get(item1).name} - #{cost1} Stardust")
	   message2= _INTL("#{GameData::Item.get(item2).name} - #{cost2} Stardust")
	   message3= _INTL("#{GameData::Item.get(item3).name} - #{cost3} Stardust")
	   message1= _INTL("#{GameData::Item.get(item1).name} - SOLD") if cost1=="SOLD"
	   message2= _INTL("#{GameData::Item.get(item2).name} - SOLD") if cost2=="SOLD"
	   message3= _INTL("#{GameData::Item.get(item3).name} - SOLD") if cost3=="SOLD"
      cmd1  = -1
      cmd2   = -1
      cmd3   = -1
      commands = []
      commands[cmd1  = commands.length] = message1
      commands[cmd2  = commands.length] = message2
      commands[cmd3   = commands.length] = message3
      commands[commands.length]              = _INTL("No Thanks")
      command = pbShowCommands(_INTL("You can buy..."), commands)
      if cmd1 >= 0 && command == cmd1      # Send to Boxes
	     if cost1!="SOLD"
		   if $PokemonGlobal.dungeon_leader.type.inv_remove(:STARDUST,cost1)
		    if $PokemonGlobal.dungeon_leader.type.inv_add(item1)
			    cost1="SOLD"
			 end
          else
		     amt = cost1-$bag.quantity(:STARDUST)
            pbMessage(_INTL("You can't afford #{item1}, you need #{amt} more Stardust."))
			end
        else
    pbMessage(_INTL("#{item1} is sold out."))
		 end
	   elsif cmd2 >= 0 && command == cmd2 
	     if cost2!="SOLD"
		   if $PokemonGlobal.dungeon_leader.type.inv_remove(:STARDUST,cost2)
		    if $PokemonGlobal.dungeon_leader.type.inv_add(item2)
			    cost2="SOLD"
			 end
          else
		     amt = cost2-$bag.quantity(:STARDUST)
            pbMessage(_INTL("You can't afford #{item2}, you need #{amt} more Stardust."))
			end

        else
    pbMessage(_INTL("#{item1} is sold out."))
		  end
	   elsif cmd3 >= 0 && command == cmd3 
	     if cost3!="SOLD"
		   if $PokemonGlobal.dungeon_leader.type.inv_remove(:STARDUST,cost3)
		    if $PokemonGlobal.dungeon_leader.type.inv_add(item3)
			    cost3="SOLD"
			 end
          else
		     amt = cost3-$bag.quantity(:STARDUST)
            pbMessage(_INTL("You can't afford #{item3}, you need #{amt} more Stardust."))
			end

        else
    pbMessage(_INTL("#{item1} is sold out."))
		  end
       elsif Input.trigger?(Input::BACK)
		 break
	   else
		 break
	   
	  end
	 end
    
   end

end

def pbDungeonMain
  vbItems=[:SOFTSAND,:SOFTSAND,:SOFTSAND,:SOFTSAND,:STONE,
  :STONE,:STONE,:STONE,:HARDSTONE,:HARDSTONE,
  :CHARCOAL,:BIGROOT,:LIGHTCLAY,:BLACKSLUDGE,:DAMPROCK,
  :SHOALSHELL,:SHOALSALT,:ORANMASH,:BIGPEARL,:KINGSROCK,
  :DEEPSEATOOTH,:DEEPSEASCALE,:IRONORE,:STARDUST,:STARDUST,
  :STARPIECE,:REDAPRICORN,:SITRUSBERRY,:ORANBERRY,:WOOL,
  :CHARCOAL,:CHARCOAL,:APPLE,:ACORN,:BAIT,:WONDERORB]
  chanceCollect=rand(100)  #Encounters 2/10 of the time
  if  chanceCollect > 5
    vbItem = vbItems[rand(36)]
    pbItemBallDungeon(vbItem)
 end
end

  def pbSetEventTime2(map,event)
    $PokemonGlobal.eventvars = {} if !$PokemonGlobal.eventvars
    time = pbGetTimeNow
    time = time.to_i
    pbSetSelfSwitch(event, "A", true)
    $PokemonGlobal.eventvars[[map, event]] = time
  end	

	
def item_ball_dungeon(eventid)
 if pbItemBallDungeon(:STARDUST)
   pbSetEventTime2($game_map.map_id,eventid)
 end
end

def stardust_dungeon(eventid)
 if pbDungeonMain
   pbSetEventTime2($game_map.map_id,eventid)
 end
end


def exp_candy_dungeon(eventid)
 item = :EXPCANDYXS
 item = :EXPCANDYS if $PokemonGlobal.dungeon_floor > 2
 item = :EXPCANDYM if $PokemonGlobal.dungeon_floor > 5
 item = :EXPCANDYL if $PokemonGlobal.dungeon_floor > 8
 item = :EXPCANDYXL if $PokemonGlobal.dungeon_floor > 11
 
 if pbItemBallDungeon(item)
   pbSetSelfSwitch(eventid, "A", true)
 end
end

def pbItemBallDungeon(item, quantity = 1)
  item = GameData::Item.get(item)
  return false if !item || quantity < 1
  itemname = (quantity > 1) ? item.name_plural : item.name
  pocket = item.pocket
  move = item.move
  if $PokemonGlobal.dungeon_leader.type.inv_add(item, quantity)   # If item can be picked up
    meName = (item.is_key_item?) ? "Key item get" : "Item get"
    if item == :LEFTOVERS
      pbMessage(_INTL("\\me[{1}]You found some \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    elsif item == :DNASPLICERS
      pbMessage(_INTL("\\me[{1}]You found \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    elsif item.is_machine?   # TM or HM
      pbMessage(_INTL("\\me[{1}]You found \\c[1]{2} {3}\\c[0]!\\wtnp[30]", meName, itemname, GameData::Move.get(move).name))
    elsif quantity > 1
      pbMessage(_INTL("\\me[{1}]You found {2} \\c[1]{3}\\c[0]!\\wtnp[30]", meName, quantity, itemname))
    elsif itemname.starts_with_vowel?
      pbMessage(_INTL("\\me[{1}]You found an \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    else
      pbMessage(_INTL("\\me[{1}]You found a \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    end
    return true
  end
  # Can't add the item
  if item == :LEFTOVERS
    pbMessage(_INTL("You found some \\c[1]{1}\\c[0]!\\wtnp[30]", itemname))
  elsif item.is_machine?   # TM or HM
    pbMessage(_INTL("You found \\c[1]{1} {2}\\c[0]!\\wtnp[30]", itemname, GameData::Move.get(move).name))
  elsif quantity > 1
    pbMessage(_INTL("You found {1} \\c[1]{2}\\c[0]!\\wtnp[30]", quantity, itemname))
  elsif itemname.starts_with_vowel?
    pbMessage(_INTL("You found an \\c[1]{1}\\c[0]!\\wtnp[30]", itemname))
  else
    pbMessage(_INTL("You found a \\c[1]{1}\\c[0]!\\wtnp[30]", itemname))
  end
  pbMessage(_INTL("But you can't carry anymore..."))
  return false
end


def is_cooled
   pbSetSelfSwitch(self, "A", false)
   setTempSwitchOn("A")

end

class PokemonGlobalMetadata
  attr_accessor :in_dungeon
  attr_accessor :dungeon_floor
  attr_accessor :dungeon_leader
  attr_accessor :dungeon_x
  attr_accessor :dungeon_y

  def in_dungeon
    @in_dungeon = false if !@in_dungeon
    return @in_dungeon
  end
  def dungeon_floor
    @dungeon_floor = 0 if !@dungeon_floor
    return @dungeon_floor
  end
  def dungeon_x
    @dungeon_x = 0 if !@dungeon_x
    return @dungeon_x
  end
  def dungeon_y
    @dungeon_y = 0 if !@dungeon_y
    return @dungeon_y
  end
  def dungeon_leader
    @dungeon_leader = 0 if !@dungeon_leader
    return @dungeon_leader
  end
end
  
  EventHandlers.add(:on_player_step_taken_can_transfer, :patch1,
  proc {
  if $PokemonGlobal.in_dungeon==true
  #if $game_switches[485]==true
  setBattleRule("setStyle")
  setBattleRule("canLose")
end

})