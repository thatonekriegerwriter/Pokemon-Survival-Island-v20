class Adventure_Scene
	def setup_menu_object(name,x=nil,y=nil)
	 picture = "None"
		@sprites[name] = IconSprite.new(0,0,@viewport)
		@sprites[name].setBitmap("Graphics/Pictures/Pokeventures/#{name}.png") if name != "location"
		@sprites[name].setBitmap("Graphics/Pictures/Pokeventures/explorersbg/None.png") if name == "location"
		@sprites[name].ox = @sprites[name].bitmap.width/2 if name == "base"
		@sprites[name].oy = @sprites[name].bitmap.height/2 if name == "base"
		@sprites[name].x = Graphics.width/2 if x.nil?
		@sprites[name].y = Graphics.height/2 if y.nil?
		@sprites[name].x = x if !x.nil?
		@sprites[name].y = y if !y.nil?
		@sprites[name].z = 3 if name != "location"
		@sprites[name].z = @sprites["visible square"].z-1 if name == "location"
	
	end
	def get_pokemon_icon_old(pkmn,i)
	  case i
	   when 0
	    return GameData::Species.ow_sprite_filename(pkmn.species, pkmn.form,pkmn.gender, pkmn.shiny?, pkmn.shadow)
	   when 3
	    return nil
	   else
	    return nil
	  end
	end
	def get_pokemon_icon(pkmn,i)
	  case i
	   when 0
	    return pkmn
	   when 3
	    return pkmn.who_fighting if !pkmn.who_fighting.nil?
	   else
	    return pkmn.travelingpartners[i-1]
	  end
	end
	def setAreaBG(pokemon=nil)
	 map_id = pokemon.location if !pokemon.nil?
	 picture = "None"
	 picture = getbg(map_id) if !map_id.nil?
	 @sprites["location"].zoom_x=0.32 if picture!="None"
	 @sprites["location"].zoom_y=0.32 if picture!="None"
	 @sprites["location"].zoom_x=1 if picture=="None"
	 @sprites["location"].zoom_y=1 if picture=="None"
	 @sprites["location"].setBitmap("Graphics/Pictures/Pokeventures/explorersbg/#{picture}.png")
	 theexsandeys = [[386,126],[368,126],[350,126],[448,126]]
	 if picture!="None"
	 4.times do |i|
		@sprites["viewer_icon_#{i}"].pokemon = get_pokemon_icon(pokemon,i)
		@sprites["viewer_icon_#{i}"].visible = true if !get_pokemon_icon(pokemon,i).nil?
		@sprites["viewer_icon_#{i}"].visible = false if get_pokemon_icon(pokemon,i).nil?
		@sprites["viewer_icon_#{i}"].mirror=true if i!=3
		@sprites["viewer_icon_#{i}"].mirror=false if i==3
	 end
	 else
	 4.times do |i|
		@sprites["viewer_icon_#{i}"].pokemon = nil
		@sprites["viewer_icon_#{i}"].visible = false
		@sprites["viewer_icon_#{i}"].mirror=false
	 end
	 end
	end
	
	def getbg(map_id)
       time = pbGetTimeNow
	   if $map_factory.getMap(map_id).metadata.battle_background != "" || $map_factory.getMap(map_id).metadata.battle_background.nil?
	   base = $map_factory.getMap(map_id).metadata.battle_background.downcase
	   if $map_factory.getMap(map_id).metadata.battle_background!="LavaCave"
	   if PBDayNight.isMorning?(time)
	   stabbies = "_morn"
	   
	   elsif PBDayNight.isEvening?(time)
	   stabbies = "_eve"
	   elsif PBDayNight.isNight?(time)
	   stabbies = "_night"
	   else
	   stabbies = ""
	
	   end
       else
	   stabbies = ""
	   
	   end
      else
	   base = "indoor1_bg"
	   stabbies = ""
	  end 
	 return "#{base}#{stabbies}_bg"	  
	end
  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  def get_pos_x_y(party,index)
   if party == @party
    case index
	 when 0
	   return 20,114
	 when 1
	   return 93,130
	 when 2
	   return 20,178
	 when 3
	   return 93,194
	 when 4
	   return 20,242
	 when 5
	   return 93,258
	
	
	
	
	end
  
   else
    case index
	 when 0
	   return 190,114
	 when 1
	   return 255,130
	 when 2
	   return 190,178
	 when 3
	   return 255,194
	 when 4
	   return 190,242
	 when 5
	   return 255,258
	
	
	
	
	end
  
   
   end
  end

	def pbStartScene(party)
		@viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
		@viewport.z = 99999
		@sprites = {}
		@party = party
		@adventure = $Adventure
		@adventureparty = @adventure.party
		@cursorpos = 14
		@cursorpos = 0 if @party[0]
		@off = false
		@fastcollect = true

		if defined?(ScrollingSprite)
			@sprites["background"] = IconSprite.new(0,0,@viewport)
			@sprites["background"] = ScrollingSprite.new(@viewport)
			@sprites["background"].speed = 1
			@sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokeventures/bg"))
		else
			addBackgroundPlane(@sprites,"bg","Pokeventures/bg",@viewport)
		end
       setup_menu_object("pokemonmenu",6,110)
       setup_menu_object("jiggly",184,110)
       setup_menu_object("visible square",336,110)
       setup_menu_object("location",336,110)
       setup_menu_object("normal box",336,228)
       setup_menu_object("normal box2",336,308)
       setup_menu_object("back",474,314)
       setup_menu_object("header",8,12)
       setup_menu_object("fw-fwa",6,331)
       setup_menu_object("base")
		pbSetSystemFont(@sprites["base"].bitmap)
		textpos = [
			[_INTL("Pokémon Adventures"), 158, 25, 0, Color.new(88,88,80), Color.new(168,184,184)],
			#[_INTL("Collect Items"),344, 164, 0, Color.new(239, 239, 239), Color.new(140, 140, 140)],
			[_INTL("Call Back Mons"),344, 248, 0, Color.new(239, 239, 239), Color.new(140, 140, 140)],
			[_INTL("Exit"),344, 328, 0, Color.new(239, 239, 239), Color.new(140, 140, 140)]
		]
		overlay = @sprites["base"].bitmap
		pbDrawTextPositions(overlay, textpos)

		@sprites["locationtext"]=Window_UnformattedTextPokemon.new("In Party")
		pbPrepareWindow(@sprites["locationtext"])
		@sprites["locationtext"].viewport=@viewport
		@sprites["locationtext"].windowskin=nil
		@sprites["locationtext"].baseColor = Color.new(239, 239, 239)
		@sprites["locationtext"].shadowColor = Color.new(140, 140, 140)
		@sprites["locationtext"].x = 374
		@sprites["locationtext"].y = 124
		@sprites["locationtext"].width=Graphics.width-48
		@sprites["locationtext"].height=Graphics.height
		@sprites["locationtext"].z = 9999
       @sprites["locationtext"].resizeToFit("In Party")
	    theexsandeys = [[376,120],[346,114],[333,126],[434,120]]
		4.times do |i|
		@sprites["viewer_icon_#{i}"] = PokemonIconSprite.new(nil,@viewport)
		@sprites["viewer_icon_#{i}"].x = theexsandeys[i][0]
		@sprites["viewer_icon_#{i}"].y = theexsandeys[i][1]
		@sprites["viewer_icon_#{i}"].z = 9
		@sprites["viewer_icon_#{i}"].z = 8 if i==1
		@sprites["viewer_icon_#{i}"].visible = true
		end
		12.times do |i|
		 
		 if i>5
		  x,y = get_pos_x_y(@adventureparty,i-6)
		  if @adventureparty[i-6]
			@sprites["icon_#{i}"] = PokemonIconSprite.new(@adventureparty[i-6],@viewport)
			@sprites["icon_#{i}"].x = x
			@sprites["icon_#{i}"].y = y
			@sprites["icon_#{i}"].z = 7
			@sprites["icon_#{i}"].visible = true
		    @sprites["apple_#{i}"] = IconSprite.new(0,0,@viewport)
		    @sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
		   @sprites["apple_#{i}"].x = x+40
		   @sprites["apple_#{i}"].y = y+17
		   @sprites["apple_#{i}"].z = 7
			@sprites["apple_#{i}"].visible = true
		  else
			@sprites["icon_#{i}"] = PokemonIconSprite.new(nil,@viewport)
			@sprites["icon_#{i}"].x = x
			@sprites["icon_#{i}"].y = y
			@sprites["icon_#{i}"].z = 7
			@sprites["icon_#{i}"].visible = true
	    	@sprites["apple_#{i}"] = IconSprite.new(0,0,@viewport)
		    @sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
		    @sprites["apple_#{i}"].x = x+40
		    @sprites["apple_#{i}"].y = y+17
		   @sprites["apple_#{i}"].z = 7
			@sprites["apple_#{i}"].visible = true
		  end
		 
		 else
		  x,y = get_pos_x_y(@party,i)
		  if @party[i]
			@sprites["icon_#{i}"] = PokemonIconSprite.new(@party[i],@viewport)
			@sprites["icon_#{i}"].x = x
			@sprites["icon_#{i}"].y = y
			@sprites["icon_#{i}"].z = 7
			@sprites["icon_#{i}"].visible = true
		    @sprites["apple_#{i}"] = IconSprite.new(0,0,@viewport)
		    @sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
		   @sprites["apple_#{i}"].x = x+40
		   @sprites["apple_#{i}"].y = y+17
		   @sprites["apple_#{i}"].z = 7
			@sprites["apple_#{i}"].visible = true
		  else
			@sprites["icon_#{i}"] = PokemonIconSprite.new(nil,@viewport)
			@sprites["icon_#{i}"].x = x
			@sprites["icon_#{i}"].y = y
			@sprites["icon_#{i}"].z = 7
			@sprites["icon_#{i}"].visible = true
	    	@sprites["apple_#{i}"] = IconSprite.new(0,0,@viewport)
		    @sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
		    @sprites["apple_#{i}"].x = x+40
		    @sprites["apple_#{i}"].y = y+17
		   @sprites["apple_#{i}"].z = 7
			@sprites["apple_#{i}"].visible = true
		  end
		 
		 end
		
		end

		pbUpdateChangingGraphics
		potato = ""
		potato = "In the Party!"  if @party[0]
		@sprites["logtext"]=Window_UnformattedTextPokemon.new(potato)
		pbPrepareWindow(@sprites["logtext"])
		@sprites["logtext"].viewport=@viewport
		@sprites["logtext"].windowskin=nil
		@sprites["logtext"].baseColor = Color.new(239, 239, 239)
		@sprites["logtext"].shadowColor = Color.new(140, 140, 140)
		@sprites["logtext"].x = 10
		@sprites["logtext"].y = 318
		@sprites["logtext"].z = 9999
		@sprites["logtext"].width=Graphics.width-48
		@sprites["logtext"].height=Graphics.height
       @sprites["logtext"].resizeToFit(potato)
		@sprites["pointer"] = IconSprite.new(0,0,@viewport)
		@sprites["pointer"].setBitmap("Graphics/Pictures/Pokeventures/cursor.PNG")
		@sprites["pointer"].x = 30
		@sprites["pointer"].y = 75
		@sprites["pointer"].z = 9999
		pbBGMPlay(PokeventureConfig::CustomMusic)
		pbFadeInAndShow(@sprites) { pbUpdate }
	end
  

	def pbUpdateChangingGraphics
        $PokemonGlobal.addNewFrameCount 
		12.times do |i|
		 
		 if i>5
		  if @adventureparty[i-6]
			@sprites["icon_#{i}"].pokemon=(@adventureparty[i-6])
			@sprites["icon_#{i}"].visible = true
			if @adventureparty[i-6].inventory.length==7
				@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/gold_apple.png")
			@sprites["apple_#{i}"].visible = true
			elsif @adventureparty[i-6].inventory.length>0 && !@adventureparty[i-6].inventory[0][0].nil?
				@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
			@sprites["apple_#{i}"].visible = true
			else
			@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
			@sprites["apple_#{i}"].visible = false
			end

		  else
			@sprites["icon_#{i}"].pokemon=(nil)
			@sprites["icon_#{i}"].visible = false
			@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
			@sprites["apple_#{i}"].visible = false
		  end
		 
		 else
		  if @party[i]
			@sprites["icon_#{i}"].pokemon=(@party[i])
			@sprites["icon_#{i}"].visible = true
			if @party[i].inventory.length==7
				@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/gold_apple.png")
			@sprites["apple_#{i}"].visible = true
			elsif @party[i].inventory.length>0 && !@party[i].inventory[0][0].nil?
				@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
			@sprites["apple_#{i}"].visible = true
			else
			@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
			@sprites["apple_#{i}"].visible = false
			end

		  else
			@sprites["icon_#{i}"].pokemon=(nil)
			@sprites["icon_#{i}"].visible = false
			@sprites["apple_#{i}"].setBitmap("Graphics/Pictures/Pokeventures/apple.png")
			@sprites["apple_#{i}"].visible = false
		  end
		 
		 end
		
		end
  end


	def adventurechoices
	
	
		if !pbCursorValid?
			pbMessage(_INTL("There is nothing here!"))
		else
			pos = getIndexFromCursor
			loop do
		    pbUpdateChangingGraphics
			Graphics.update
			pkmn = @adventureparty[pos]
			text == "Call Back" if pkmn.location != $game_map.map_id
			text == "Add to Party" if pkmn.location != $game_map.map_id
			answer=pbMessage("What do you want to do?", [text,"Summary","Adventuring Type", "Cancel"],-1,nil,0)
			if answer == 0
			  if text == "Call Back"
			     pkmn.called_back_map=$game_map.map_id
			  else
			    
				pbMoveToParty(pos)
			  end
				break
			elsif answer == 2
				pbSummary(@adventureparty,pos)
			elsif answer == 3
			answer2 = []
			if @adventureparty.length > 0
			pkmn = @adventureparty[pos]
			if !pkmn.adventuringTypes.nil?
			pkmn.adventuringTypes.each do |i|
			answer2[answer2.length] = i.to_s
			end
			end
			answer2[answer2.length] = "Cancel"
			if pkmn.chosenAdvType.nil? || pkmn.chosenAdvType == "None"
			commands=pbMessage(_INTL("Choose how this Pokemon goes on adventures."), answer2,-1,nil,0)
			else
			commands=pbMessage(_INTL("This Pokemon is a {1} type Adventurer.",pkmn.chosenAdvType), answer2,-1,nil,0)
			end
			if commands != -1
			pkmn.chosenAdvType = pkmn.adventuringTypes[commands]
			if pkmn.chosenAdvType == "None"
			pkmn.chosenAdvType = nil
			end
			elsif commands == answer2.length || commands == -1
			end
           end
          else 
			 break
		   end
           end
		end



	end
	
	
	
	def partychoices
	
	
		if !pbCursorValid?
			pbMessage(_INTL("There is nothing here!"))
		else
			pos = getIndexFromCursor
			loop do
		    pbUpdateChangingGraphics
			Graphics.update
			answer=pbMessage("What do you want to do?", ["Send on Adventure","Summary","Item","Adventuring Type","Cancel"],-1,nil,0)
			if answer == 0
				pbMoveToAdventure(pos)
				break
			elsif answer == 1
				pbSummary(@party,pos)
			elsif answer == 2 #Item
			if @party.length > 0
			pkmn = @party[pos]
			items = []
			items[items.length] = "Give"
			items[items.length] = "Take"
			items[items.length] = "Cancel"
			if pkmn.item.nil?
			commands=pbMessage(_INTL("They are not holding anything!"), items,-1,nil,0)
			else
			commands=pbMessage(_INTL("They are already holding a {1}!",pkmn.item.name), items,-1,nil,0)
			end
			if commands == 0
			if pkmn.item.nil?
      item = nil
      pbFadeOutIn {
        scene = PokemonBag_Scene.new
        screen = PokemonBagScreen.new(scene, $bag)
        item = screen.pbChooseItemScreen(proc { |itm| GameData::Item.get(itm).can_hold? })
      }
      if item
        dorefresh = pbGiveItemToPokemon2(item, pkmn, self)
      end
        else
		
			pbMessage(_INTL("They are already holding a {1}!",pkmn.item.name))
		end
			elsif commands == 1
			if !pkmn.item.nil?
			  pbTakeItemFromPokemon2(pkmn, self)
			else
			pbMessage(_INTL("They are not holding an item!"))
			end
			else
			end


            end
			elsif answer == 3
			answer2 = []
			pkmn = @party[pos]
			if !pkmn.adventuringTypes.nil?
			pkmn.adventuringTypes.each do |i|
			answer2[answer2.length] = i.to_s
			end
			answer2[answer2.length] = "Cancel"
			if pkmn.chosenAdvType.nil? || pkmn.chosenAdvType == "None"
			commands=pbMessage(_INTL("Choose how this Pokemon goes on adventures."), answer2,-1,nil,0)
			else
			commands=pbMessage(_INTL("This Pokemon is a {1} type Adventurer.",pkmn.chosenAdvType), answer2,-1,nil,0)
			end
			if commands != -1
			pkmn.chosenAdvType = pkmn.adventuringTypes[commands]
			elsif commands == answer2.length || commands == -1
			end
            end
            else 
			 break
			end

            end
		end



	end




	def pbPerformCursorAction
		case @cursorpos
		when 14
			@off=true
		when 4
		
		
		
		
		
		    if false
			if @adventure.items.empty?
				pbMessage(_INTL("There are no items to be collected!"))
			elsif @fastcollect
				@adventure.harvestItemsSilent
				pbMessage(_INTL("All Items Collected!"))
			else
				@adventure.harvestItems
			end
			end
		when 9
			   @adventureparty.each do |pkmn|
			     pkmn.called_back_map=$game_map.map_id
			   end
		when 0,1,5,6,10,11
			partychoices
		else
			adventurechoices
		end
		pbUpdateChangingGraphics
		Graphics.update
	end



	def pbUpdateCursorPos
		positions = [[30,75],[103,89],[200,89],[265,89],[430,79],[30,137],[103,153],[200,153],[265,153],[430,180],[30,201],[103,217],[200,217],[265,217],[430,259]]
		pos = positions[@cursorpos]
		@sprites["pointer"].x = pos[0]
		@sprites["pointer"].y = pos[1]
	end

	def pbCursorValid?
	    puts "cursorpos: #{@cursorpos}"
		return true if [9,14].include? @cursorpos
		if @cursorpos == 0
			return @party[0]
		elsif @cursorpos == 1
			return @party[1]
		elsif @cursorpos == 2
			return @adventureparty[0]
		elsif @cursorpos == 3
			return @adventureparty[1]
		elsif @cursorpos == 5
			return @party[2]
		elsif @cursorpos == 6
			return @party[3]
		elsif @cursorpos == 7
			return @adventureparty[2]
		elsif @cursorpos == 8
			return @adventureparty[3]
		elsif @cursorpos == 10
			return @party[4]
		elsif @cursorpos == 11
			return @party[5]
		elsif @cursorpos == 12
			return @adventureparty[4]
		elsif @cursorpos == 13
			return @adventureparty[5]
		elsif @cursorpos == 4 #Viewer
			return false
		end
		return true
	end
	def pbCursorView
	   athome = [0,1,5,6,10,11]
	   abroad = [2,3,7,8,12,13]
		if athome.include? @cursorpos
			if @party[athome.index(@cursorpos)]
           @sprites["locationtext"].text="In Party"
           @sprites["locationtext"].resizeToFit("In Party")
		    if !@party[athome.index(@cursorpos)].encounterLog.nil? && @party[athome.index(@cursorpos)].encounterLog.length>0
		    text = @party[athome.index(@cursorpos)].encounterLog.to_s
			else
		    text = "In the Party!"
			end
           @sprites["logtext"].text=text
           @sprites["logtext"].resizeToFit(text)
		    else
           @sprites["logtext"].text="None"
           @sprites["logtext"].resizeToFit("None")
           @sprites["locationtext"].text="None"
           @sprites["locationtext"].resizeToFit("None")
			end
		   setAreaBG()
		elsif abroad.include? @cursorpos
			if @adventureparty[abroad.index(@cursorpos)]
           @sprites["locationtext"].text=""
           @sprites["locationtext"].resizeToFit("")
		    if !@adventureparty[abroad.index(@cursorpos)].encounterLog.nil? && @adventureparty[abroad.index(@cursorpos)].encounterLog.length>0
		    text = @adventureparty[abroad.index(@cursorpos)].encounterLog.to_s
			else
		    text = "They are in a #{$map_factory.getMap(@adventureparty[abroad.index(@cursorpos)].location).name}."
			end
           @sprites["logtext"].text=text
           @sprites["logtext"].resizeToFit(text)
		   setAreaBG(@adventureparty[abroad.index(@cursorpos)])
			end
		elsif @cursorpos == 4 #Viewer
           @sprites["locationtext"].text=""
           @sprites["locationtext"].resizeToFit("")
           @sprites["logtext"].text=""
           @sprites["logtext"].resizeToFit("")
		   setAreaBG()
		elsif @cursorpos == 9 #Call Back
           @sprites["locationtext"].text=""
           @sprites["locationtext"].resizeToFit("")
           @sprites["logtext"].text=""
           @sprites["logtext"].resizeToFit("")
		   setAreaBG()
		elsif @cursorpos == 14 #Exit
           @sprites["locationtext"].text=""
           @sprites["locationtext"].resizeToFit("")
           @sprites["logtext"].text=""
           @sprites["logtext"].resizeToFit("")
		   setAreaBG()
		end
	
	end

 
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  # Main function that controls the UI
  def pbEncounter
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK) || @off
        pbPlayCloseMenuSE
		map_id = $game_map.map_id
		map = load_data(sprintf("Data/Map%03d.rxdata",map_id))
		pbBGMPlay(map.bgm)
        break
	  elsif Input.trigger?(Input::USE)
		pbPerformCursorAction
	  elsif Input.trigger?(Input::RIGHT)
		oldpos = @cursorpos.dup
		pbPointerRight
		while (!pbCursorValid?) && !(oldpos == @cursorpos)
			pbPointerRight
		end
		if oldpos == @cursorpos
			pbPlayBuzzerSE
			pbCursorView
		else
			pbPlayCursorSE
			pbCursorView
		end
		pbUpdateCursorPos
	  elsif Input.trigger?(Input::LEFT)
		oldpos = @cursorpos.dup
		pbPointerLeft
		while (!pbCursorValid?) && !(oldpos == @cursorpos)
			pbPointerLeft
		end
		if oldpos == @cursorpos
			pbPlayBuzzerSE
			pbCursorView
		else
			pbPlayCursorSE
			pbCursorView
		end
		pbUpdateCursorPos
	  elsif Input.trigger?(Input::DOWN)
		oldpos = @cursorpos.dup
		pbPointerDown
		while (!pbCursorValid?) && !(oldpos == @cursorpos)
			pbPointerDown
		end
		if oldpos == @cursorpos
			pbPlayBuzzerSE
			pbCursorView
		else
			pbPlayCursorSE
			pbCursorView
		end
		pbUpdateCursorPos
	  elsif Input.trigger?(Input::UP)
		oldpos = @cursorpos.dup
		pbPointerUp
		while (!pbCursorValid?) && !(oldpos == @cursorpos)
			pbPointerUp
		end
		if oldpos == @cursorpos
			pbPlayBuzzerSE
			pbCursorView
		else
			pbPlayCursorSE
			pbCursorView
		end
		pbUpdateCursorPos
	  elsif Input.trigger?(Input::ACTION)
		@fastcollect = !@fastcollect
		pbUpdateChangingGraphics
      end
    end
  end
  
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
    
end
class Adventure_Scene

	def getIndexFromCursor
		case @cursorpos
		when 0,2
			return 0
		when 1,3
			return 1
		when 5,7
			return 2
		when 6,8
			return 3
		when 10,12
			return 4
		when 11,13
			return 5
		else
			return -1
		end
	end

	def pbSummary(list,id)
		oldsprites = pbFadeOutAndHide(@sprites)
		scene = PokemonSummary_Scene.new
		screen = PokemonSummaryScreen.new(scene)
		screen.pbStartScreen(list,id)
		pbFadeInAndShow(@sprites,oldsprites)
	end

	def pbMoveToAdventure(pos)
			if !@adventure.party_full?
				@party[pos].play_cry
			    @party[pos].location = $game_map.map_id
				@party[pos].onAdventure = true
				@adventure.add_pokemon(@party[pos].dup)
				$player.remove_pokemon_at_index2(pos)
			else
				pbMessage(_INTL("The adventuring Party is already full!"))
			end
	end

	def pbMoveToParty(pos) 
		if !$player.party_full?
			@adventureparty[pos].location = nil
			@adventureparty[pos].onAdventure = false
			partymember = @adventureparty[pos].dup
			partymember.travelingpartners = []
			@party.append(partymember)
			@adventureparty[pos].travelingpartners.each do |pk|
			   if !$player.party_full?
			     @party.append(pk)
			     pbMessage(_INTL("#{pk.name} was also added."))
			   else
			pbMessage(_INTL("#{@adventureparty[pos].name} was traveling with #{pk.name}."))
			pbMessage(_INTL("#{pk.name} was added to the most recently used Crate."))
			    @adventure.pbAddtoPCAlly(pk)
			   end
			end
			@adventure.remove_pokemon_at_index(pos)
		else
			pbMessage(_INTL("You have no space in your party for this Pokémon!"))
		end
	end

	def pbPointerRight
		@cursorpos = @cursorpos+1
		@cursorpos = 5 if @cursorpos == 10
		@cursorpos = 9 if @cursorpos == 4
		@cursorpos = 5 if @cursorpos == 10
		@cursorpos = 10 if @cursorpos == 15
	end
	def pbPointerLeft
		@cursorpos = @cursorpos-1
		@cursorpos = 3 if @cursorpos == 8
		@cursorpos = 14 if @cursorpos == 9
		@cursorpos = 8 if @cursorpos == 14
		@cursorpos = 9 if @cursorpos == 4
		@cursorpos = 4 if @cursorpos == -1
	end
	def pbPointerDown
		@cursorpos = @cursorpos+5
		@cursorpos = @cursorpos-15 if @cursorpos > 14
	end
	def pbPointerUp
		@cursorpos = @cursorpos-5
		@cursorpos = @cursorpos+15 if @cursorpos < 0
	end


end
class Adventure_Screen
  def initialize(scene,party)
    @scene = scene
	@party = party
  end

  def pbStartScreen
    @scene.pbStartScene(@party)
    @scene.pbEncounter
    @scene.pbEndScene
  end
end

class PokemonStorage
	attr_accessor	:party
	
	def party
		return @party if !@party.nil?
		return $player.party
	
	end
	def party=(value)
		@party = value
	end

	def party_full?
		return @party.length >= Settings::MAX_PARTY_SIZE if !@party.nil?
		return $player.party_full?
	end
end

def pbStartAdventureMenu
	pbFadeOutIn(99999) {
		scene = Adventure_Scene.new
		screen = Adventure_Screen.new(scene,$player.party)
		screen.pbStartScreen
     }
end



def pbGiveItemToPokemon2(item, pkmn, scene, pkmnid = 0)
  newitemname = GameData::Item.get(item).portion_name
  if pkmn.egg?
    scene.pbMessage(_INTL("Eggs can't hold items."))
    return false
  elsif pkmn.mail
    scene.pbMessage(_INTL("{1}'s mail must be removed before giving it an item.", pkmn.name))
    return false if !pbTakeItemFromPokemon(pkmn, scene)
  end
  if pkmn.hasItem?
    olditemname = pkmn.item.portion_name
    if newitemname.starts_with_vowel?
      scene.pbMessage(_INTL("{1} is already holding an {2}.\1", pkmn.name, olditemname))
    else
      scene.pbMessage(_INTL("{1} is already holding a {2}.\1", pkmn.name, olditemname))
    end
    if scene.pbConfirm(_INTL("Would you like to switch the two items?"))
      $bag.remove(item)
      if !$bag.add(pkmn.item)
        raise _INTL("Couldn't re-store deleted item in Bag somehow") if !$bag.add(item)
        scene.pbMessage(_INTL("The Bag is full. The Pokémon's item could not be removed."))
      elsif GameData::Item.get(item).is_mail?
        if pbWriteMail(item, pkmn, pkmnid, scene)
          pkmn.item = item
          scene.pbMessage(_INTL("Took the {1} from {2} and gave it the {3}.", olditemname, pkmn.name, newitemname))
          return true
        elsif !$bag.add(item)
          raise _INTL("Couldn't re-store deleted item in Bag somehow")
        end
      else
        pkmn.item = item
        scene.pbMessage(_INTL("Took the {1} from {2} and gave it the {3}.", olditemname, pkmn.name, newitemname))
        return true
      end
    end
  elsif !GameData::Item.get(item).is_mail? || pbWriteMail(item, pkmn, pkmnid, scene)
    $bag.remove(item)
    pkmn.item = item
    scene.pbMessage(_INTL("{1} is now holding the {2}.", pkmn.name, newitemname))
    return true
  end
  return false
end

def pbTakeItemFromPokemon2(pkmn, scene)
  ret = false
  if !pkmn.hasItem?
    scene.pbMessage(_INTL("{1} isn't holding anything.", pkmn.name))
  elsif !$bag.can_add?(pkmn.item)
    scene.pbMessage(_INTL("The Bag is full. The Pokémon's item could not be removed."))
  elsif pkmn.mail
    if scene.pbConfirm(_INTL("Save the removed mail in your Crate?"))
      if pbMoveToMailbox(pkmn)
        scene.pbMessage(_INTL("The mail was saved in your Crate."))
        pkmn.item = nil
        ret = true
      else
        scene.pbMessage(_INTL("Your Crate's Mailbox is full."))
      end
    elsif scene.pbConfirm(_INTL("If the mail is removed, its message will be lost. OK?"))
      $bag.add(pkmn.item)
      scene.pbMessage(_INTL("Received the {1} from {2}.", pkmn.item.portion_name, pkmn.name))
      pkmn.item = nil
      pkmn.mail = nil
      ret = true
    end
  else
    $bag.add(pkmn.item)
    scene.pbMessage(_INTL("Received the {1} from {2}.", pkmn.item.portion_name, pkmn.name))
    pkmn.item = nil
    ret = true
  end
  return ret
end
