class Game_Map

  def generateMining(x,y,object)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    if $ExtraEvents.objects.nil?
	$ExtraEvents.objects = {}
	end 
    key_id = ((@events.keys.max)|| -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    event.name = "#{object}.noshadow"
    image = getObjectImage2(object)
	fname = "#{image}.png"
    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = 0 #Sets movement speed.
    event.pages[0].move_frequency = 0 #Sets movement frequency.
    event.pages[0].move_type = 0 #Sets movement type.
    event.pages[0].direction_fix = true
    event.pages[0].walk_anime = false #Sets movement type.
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = false #Sets movement type.
    event.pages[0].trigger = 0 #Action Button
    #--- event commands of the event -------------------------------------
    mapId = $game_map.map_id
    Compiler::push_script(event.pages[0].list,sprintf("puts 'hi'"))
	Compiler::push_script(event.pages[0].list,sprintf("ov_mining2(#{object})"))
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
    gameEvent = Game_ObjectEvent.new(object, @map_id, event, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.type = object
	@events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
  end




end


def pbPlaceOre(x,y,object)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if !$map_factory
    event = $game_map.generateMining(x,y,object)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    event = spawnMap.generateMining(x,y,object)
  end
 # Play the pokemon cry of encounter
end

def getObjectImage2(object)
	case object #CAULDRON, CraftingStation, 
	when :TUMBLESTONE
	 image = "Legends_Tumblestone"
	when :STONE
	 image = "Legends_Tumblestone"
	when :IRON2
	 image = "Legends_Tumblestone"
	when :GOLD2
	 image = "Legends_Tumblestone"
	when :SILVER2
	 image = "Legends_Tumblestone"
	when :COPPER2
	 image = "Legends_Tumblestone"
	when :COAL
	 image = "Legends_Tumblestone"
	when "MININGMINIGAME"
	 image = "Object boulder"
	else
	 image = "Object rock"
	end

 return image
end