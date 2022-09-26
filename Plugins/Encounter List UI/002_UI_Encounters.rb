#########################################################
###                 Encounter list UI                 ###
### Based on the original resource by raZ and friends ###
#########################################################


# This is the name of a graphic in your Graphics/Pictures folder that changes the look of the UI
# If the graphic does not exist, you will get an error
WINDOWSKIN = "base.png"
WINDOWSKIN2= "textbookbg.png"	 

# This hash allows you to define the names of your encounter types if you want them to be more logical
# E.g. "Surfing" instead of "Water"
# If missing, the script will use the encounter type names in GameData::EncounterTypes
USER_DEFINED_NAMES = {
:Land => "Grass",
:LandDay => "Grass (day)",
:LandNight => "Grass (night)",
:LandMorning => "Grass (morning)",
:LandAfternoon => "Grass (afternoon)", 
:LandEvening => "Grass (evening)",
:Cave => "Cave",
:CaveDay => "Cave (day)",
:CaveNight => "Cave (night)",
:CaveMorning => "Cave (morning)",
:CaveAfternoon => "Cave (afternoon)",
:CaveEvening => "Cave (evening)",
:Water => "Surfing",
:WaterDay => "Surfing (day)",
:WaterNight => "Surfing (night)",
:WaterMorning => "Surfing (morning)",
:WaterAfternoon => "Surfing (afternoon)",
:WaterEvening => "Surfing (evening)",
:OldRod => "Fishing (Old Rod)",
:GoodRod => "Fishing (Good Rod)",
:SuperRod => "Fishing (Super Rod)",
:RockSmash => "Rock Smash",
:HeadbuttLow => "Headbutt (rare)",
:HeadbuttHigh => "Headbutt (common)",
:BugContest => "Bug Contest",
:OverworldWater => "Overworld",
:OverworldLandMorning => "Overworld",
:OverworldLandDay => "Overworld",
:OverworldLandNight => "Overworld",
:Adventure => "Adventures",
:Bait => "Bait",
:CaveDeep => "Cave"
}

# Remove the '#' from this line to use default encounter type names
#USER_DEFINED_NAMES = nil


def pbArceusTasksIntro
  pbMessage(_INTL("You look over your notes, and look over it proudly."))
	      cmd = pbMessage(_INTL("Which Area do you want to check?"),[
                            _INTL("Temperate Beach"),
                            _INTL("Temperate Base Zone"),
                            _INTL("Temperate Berry Fields"),
                            _INTL("Temperate Tent Zone"),
                            _INTL("Stone Temple Temperate"),
                            _INTL("Temperate Island"),
                            _INTL("Temperate Snowy")])
		  if cmd==0
		   $game_variables[4977]=5  
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  elsif cmd==1
		   $game_variables[4977]=4
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  elsif cmd==2
		   $game_variables[4977]=7
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  elsif cmd==3
		   $game_variables[4977]=8
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  elsif cmd==4
		   $game_variables[4977]=9
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  elsif cmd==5
		   $game_variables[4977]=13
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  elsif cmd==6
		   $game_variables[4977]=44
		   pbFadeOutIn {
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
  }
		  end 
end
# Method that returns whether a specific form has been seen (any gender)
def seen_form_any_gender?(species, form)
  ret = false
  if $player.pokedex.seen_form?(species, 0, form) ||
    $player.pokedex.seen_form?(species, 1, form)
    ret = true
  end
  return ret
end

class EncounterList_Scene

  # Constructor method
  # Sets a handful of key variables needed throughout the script
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    mapid = $game_variables[4977]
    @encounter_data = GameData::Encounter.get(mapid, $PokemonGlobal.encounter_version)
    if @encounter_data
      @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
      @max_enc, @eLength = getMaxEncounters(@encounter_tables)
    else
      @max_enc, @eLength = [1, 1]
    end
    @index = 0
  end
 
  # This gets the highest number of unique encounters across all defined encounter types for the map
  # It might sound weird, but this is needed for drawing the icons
  def getMaxEncounters(data)
    keys = data.keys
    a = []
    for key in keys
      b = []
      arr = data[key]
      for i in 0...arr.length
        b.push( arr[i][1] )
      end
      a.push(b.uniq.length)
    end
    return a.max, keys.length
  end
  
  # This method initiates the following:
  # Background graphics, text overlay, Pokémon sprites and navigation arrows
  def pbStartScene
    @selectX=0
    @selectY=0
    @selection=0
	@species=0
    if !File.file?("Graphics/Pictures/EncounterUI/"+WINDOWSKIN)
      raise _INTL("You are missing the graphic for this UI. Make sure the image is in your Graphics/Pictures folder and that it is named appropriately.")
    end
    addBackgroundPlane(@sprites,"bg","EncounterUI/bg",@viewport)
    @sprites["base"] = IconSprite.new(0,0,@viewport)
    @sprites["base"].setBitmap("Graphics/Pictures/EncounterUI/"+WINDOWSKIN)
    @sprites["base"].ox = @sprites["base"].bitmap.width/2
    @sprites["base"].oy = @sprites["base"].bitmap.height/2
    @sprites["base"].x = Graphics.width/2; @sprites["base"].y = Graphics.height/2
    @sprites["base"].opacity = 200
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].width = 512
    @sprites["locwindow"].height = 344
    @sprites["locwindow"].x = (Graphics.width - @sprites["locwindow"].width)/2
    @sprites["locwindow"].y = (Graphics.height - @sprites["locwindow"].height)/2
    @sprites["locwindow"].windowskin = nil
    @h = (Graphics.height - @sprites["base"].bitmap.height)/2
    @w = (Graphics.width - @sprites["base"].bitmap.width)/2
    @max_enc.times do |i|
      @sprites["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
      @sprites["icon_#{i}"].x = @w + 28 + 64*(i%7)
      @sprites["icon_#{i}"].y = @h + 100 + (i/7)*64
      @sprites["icon_#{i}"].visible = false
    end
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow",8,40,28,2,@viewport)
    @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
    @sprites["rightarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["rightarrow"].visible = false
    @sprites["rightarrow"].play
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow",8,40,28,2,@viewport)
    @sprites["leftarrow"].x = 0
    @sprites["leftarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["leftarrow"].visible = false
    @sprites["leftarrow"].play
    @sprites["map"]=IconSprite.new(@selectX,@selectY,@viewport)
    filename=sprintf("map%s",$game_variables[4977].to_s)
    @sprites["map"].setBitmap("Graphics/Pictures/EncounterUI/"+filename)
    @sprites["map"].visible = true
    @sprites["map"].x = 375
    @sprites["map"].y = 225
    @sprites["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @sprites["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
    @sprites["selector"].visible = false
    @sprites["selector"].x += @w + 28 + 8
    @sprites["selector"].y = @h + 100 + 13
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/EncounterUI/"+WINDOWSKIN2)
    @sprites["background"].visible = false
    @encounter_data ? drawPresent : drawAbsent
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  # Main function that controls the UI
  def pbEncounter
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::RIGHT) && @eLength >1 && @index< @eLength-1
        pbPlayCursorSE
        hideSprites
        @index += 1
        drawPresent
      elsif Input.trigger?(Input::LEFT) && @eLength >1 && @index !=0
        pbPlayCursorSE
        hideSprites
        @index -= 1
        drawPresent

	  elsif Input.trigger?(Input::USE)
          @sprites["selector"].visible = true
	      pbEncounterInteract
	  elsif Input.trigger?(Input::ACTION)
	      cmd = pbMessage(_INTL("Which Area do you want to check?"),[
                            _INTL("Temperate Beach"),
                            _INTL("Temperate Base Zone"),
                            _INTL("Temperate Berry Fields"),
                            _INTL("Temperate Tent Zone"),
                            _INTL("Stone Temple Temperate"),
                            _INTL("Temperate Island"),
                            _INTL("Temperate Snowy")])
		  if cmd==0
		   $game_variables[4977]=5
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==1
		   $game_variables[4977]=4
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==2
		   $game_variables[4977]=7
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==3
		   $game_variables[4977]=8
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==4
		   $game_variables[4977]=9
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==5
		   $game_variables[4977]=13
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==6
		   $game_variables[4977]=44
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  end 
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
    end
  end

 

  def pbEncounterInteract
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::RIGHT) 
	    if @selection==11
		@sprites["selector"].x = 40
        @sprites["selector"].y = 130
        @selection=0
		elsif @selection==6
        @sprites["selector"].y = 200
        @sprites["selector"].x -= (64*@selection)
          @selection+=1
		else
          @sprites["selector"].x+=64
          @selection+=1
		end
      elsif Input.trigger?(Input::LEFT) 
	    if @selection==0
		@sprites["selector"].x += (64*4)
        @sprites["selector"].y = 200
        @selection=11
		elsif @selection==7
        @selection-=1
        @sprites["selector"].x = 40+(64*@selection)
        @sprites["selector"].y = 130
		else
          @sprites["selector"].x-=64
          @selection-=1
		end
      elsif Input.trigger?(Input::DOWN)
		@selection+=7
		if @selection>11 
		 @selection=11
		else
        @sprites["selector"].y += 70
		end 
      elsif Input.trigger?(Input::UP) 
		@selection-=7
		if @selection<0 
		 @selection=0
		else
        @sprites["selector"].y -= 70
		end
	  elsif Input.trigger?(Input::USE)
	  pbArceusTasksStart
      elsif Input.trigger?(Input::BACK)
        @currentTexts = textsDefined2
    	drawText
	    @sprites["selector"].visible = false
        @sprites["selector"].x -= (64*@selection)
        @selection=0
     	@sprites["background"].visible = false
        break
      end
    end
  end
 
 
 
  def pbArceusTasksStart
          enc_array, currKey = getEncData
		  
          if @selection==0
		  @species = enc_array[0]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you dont have any research tasks for it."))
               else
				 pbArceusTasksMain
			   end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==1
		  @species = enc_array[1]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
               end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==2
		  @species = enc_array[2]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
			else
 		     pbMessage(_INTL("There is no Encounter Data in this slot.",(@species)))
			end
          elsif @selection==3
		  @species = enc_array[3]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==4
		  @species = enc_array[4]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
              else
				 pbArceusTasksMain
			  end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==5
		  @species = enc_array[5]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==6
		  @species = enc_array[6]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==7
		  @species = enc_array[7]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==8
		  @species = enc_array[8]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
				 
			end
          elsif @selection==9
		  @species = enc_array[9]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==10
		  @species = enc_array[10]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
			end
          elsif @selection==11
		  @species = enc_array[11]
		    if !@species.empty?
          species_data = GameData::Species.get(@species)
              if !$player.pokedex.owned?(@species) && !seen_form_any_gender?(@species,species_data.form)
 		         pbMessage(_INTL("You haven't discovered this species, so you cannot look up data on it."))
               else
				 pbArceusTasksMain
			     end
            else
			pbMessage(_INTL("There is no encounter data in this slot."))
               end
			end


	      end
     



     def drawText
	  powerColor=Color.new(0,0,0)
      shadowColor=Color.new(160,160,160)

      textPositions=[
        [@currentTexts[0],250,0,2,powerColor,shadowColor],
        [@currentTexts[1],84,40,2,powerColor,shadowColor],
        [@currentTexts[2],88,60,2,powerColor,shadowColor],
        [@currentTexts[3],120,80,2,powerColor,shadowColor],
        [@currentTexts[4],120,120,2,powerColor,shadowColor],
        [@currentTexts[5],120,140,2,powerColor,shadowColor],
        [@currentTexts[6],120,180,2,powerColor,shadowColor],
        [@currentTexts[7],90,200,2,powerColor,shadowColor],
		
        [@currentTexts[8],310,40,2,powerColor,shadowColor],
        [@currentTexts[9],310,60,2,powerColor,shadowColor],
        [@currentTexts[10],310,80,2,powerColor,shadowColor],
        [@currentTexts[11],310,120,2,powerColor,shadowColor],
        [@currentTexts[12],310,140,2,powerColor,shadowColor],
        [@currentTexts[13],310,180,2,powerColor,shadowColor],
        [@currentTexts[14],310,200,2,powerColor,shadowColor]
      ]

      pbSetSystemFont(@sprites["background"].bitmap)
      pbDrawTextPositions(@sprites["background"].bitmap,textPositions)
   if Input.trigger?(Input::BACK)
  @sprites["background"].visible=false
  @currentTexts = textsDefined2
  drawPresent
   end
    end
	
	
	

	
	
    # Note that this method is called on each refresh, but the texts
    # only will be redrawed if any character change.
    def textsDefined
	  @moveA = pbDefineMoveA(@species)
	  @moveB = pbDefineMoveB(@species)
      ret=[]
      ret[0] = _INTL("{1}",@species)
	  ret[1] = _INTL("Number Caught",$player.pokedex.caught_count(@species))
      ret[2] = _INTL("Number Defeated",$player.pokedex.battled_count(@species))
	  ret[3] = _INTL("Number defeated (Weakness)",$player.pokedex.number_weakness(@species))
	  ret[4] = _INTL("Times seen it use {2}",$player.pokedex.number_moves(@species,@moveA),@moveA)
	  ret[5] = _INTL("Times seen it use {2}",$player.pokedex.number_moves(@species,@moveB),@moveB)
	  ret[6] = _INTL("Number Forms Registered",$player.pokedex.seen_forms_count(@species))
	  ret[7] = _INTL("Number evolved ",$player.pokedex.number_evolved(@species))
	  ret[8] = _INTL("| {1}",$player.pokedex.caught_count(@species))
	  ret[9] = _INTL("| {1}",$player.pokedex.battled_count(@species))
	  ret[10] = _INTL("| {1}",$player.pokedex.number_weakness(@species))
	  ret[11] = _INTL("| {1}",$player.pokedex.number_moves(@species,@moveA))
	  ret[12] = _INTL("| {1}",$player.pokedex.number_moves(@species,@moveB)) 
	  if $player.pokedex.seen_forms_count(@species)==pbFormCheck(@species)
	  ret[13] = _INTL("- Complete!    | {1}",$player.pokedex.seen_forms_count(@species))
	  else
	  ret[13] = _INTL("| {1}",$player.pokedex.seen_forms_count(@species))
	  end
	  ret[14] = _INTL("| {1}",$player.pokedex.number_evolved(@species))
      return ret
    end    
	def textsDefined2
      ret=[]
      ret[0] = _INTL("",@species)
	  ret[1] = _INTL("",$player.pokedex.number_caught(@species))
      ret[2] = _INTL("",$player.pokedex.number_battled(@species))
	  ret[3] = _INTL("",$player.pokedex.number_weakness(@species))
	  ret[4] = _INTL("",$player.pokedex.number_moves(@species,@moveA),@moveA)
	  ret[5] = _INTL("",$player.pokedex.number_moves(@species,@moveB),@moveB)
	  ret[6] = _INTL("",$player.pokedex.seen_forms_count(@species))
	  ret[6] = _INTL("",$player.pokedex.seen_forms_count(@species)) if (!@species == :VENUSAUR || !@species == :CHARIZARD || !@species == :BLASTOISE || !@species == :BEEDRILL || !@species == :PIDGEOT || !@species == :RATTATA || !@species == :RATICATE || !@species == :PIKACHU || !@species == :RAICHU || !@species == :SANDSHREW || !@species == :SANDSLASH || !@species == :VULPIII || !@species == :VULPIX || !@species == :KITSUVEN || !@species == :NINETALES || !@species == :DIGLETT || !@species == :DUGTRIO || !@species == :MEOWTH || !@species == :PERSIAN || !@species == :ALAKAZAM || !@species == :GEODUDE || !@species == :GRAVELER || !@species == :GOLEM || !@species == :PONYTA || !@species == :RAPIDASH || !@species == :SLOWPOKE || !@species == :SLOWBRO || !@species == :FARFETCHD || !@species == :GRIMER || !@species == :MUK || !@species == :GENGAR || !@species == :EXEGGUTOR || !@species == :CUBONE || !@species == :MAROWAK || !@species == :WEEZING || !@species == :KANGASKHAN || !@species == :MRMIME || !@species == :PINSIR || !@species == :GYARADOS || !@species == :AERODACTYL || !@species == :ARTICUNO || !@species == :ZAPDOS || !@species == :MOLTRES || !@species == :MEWTWO || !@species == :PICHU || !@species == :AMPHAROS || !@species == :SLOWKING || !@species == :UNOWN || !@species == :STEELIX || !@species == :SCIZOR || !@species == :HERACROSS || !@species == :CORSOLA || !@species == :HOUNDOOM || !@species == :TYRANITAR || !@species == :SCEPTILE || !@species == :BLAZIKEN || !@species == :SWAMPERT || !@species == :ZIGZAGOON || !@species == :LINOONE || !@species == :GARDEVOIR || !@species == :SABLEYE || !@species == :MAWILE || !@species == :AGGRON || !@species == :MEDICHAM || !@species == :MANECTRIC || !@species == :SHARPEDO || !@species == :CAMERUPT || !@species == :ALTARIA || !@species == :CASTFORM || !@species == :BANETTE || !@species == :ABSOL || !@species == :GLALIE || !@species == :SALAMENCE || !@species == :METAGROSS || !@species == :LATIAS || !@species == :LATIOS || !@species == :KYOGRE || !@species == :GROUDON || !@species == :RAYQUAZA || !@species == :DEOXYS || !@species == :BURMY || !@species == :WORMADAM || !@species == :CHERRIM || !@species == :SHELLOS || !@species == :GASTRODON || !@species == :LOPUNNY || !@species == :GARCHOMP || !@species == :LUCARIO || !@species == :ABOMASNOW || !@species == :GALLADE || !@species == :ROTOM || !@species == :GIRATINA || !@species == :SHAYMIN || !@species == :ARCEUS || !@species == :AUDINO || !@species == :BASCULIN || !@species == :DARUMAKA || !@species == :DARMANITAN || !@species == :YAMASK || !@species == :DEERLING || !@species == :SAWSBUCK || !@species == :STUNFISK || !@species == :TORNADUS || !@species == :THUNDURUS || !@species == :LANDORUS || !@species == :KYUREM || !@species == :KELDEO || !@species == :MELOETTA || !@species == :GENESECT || !@species == :GRENINJA || !@species == :VIVILLON || !@species == :FLABEBE || !@species == :FLOETTE || !@species == :FLORGES || !@species == :FURFROU || !@species == :MEOWSTIC || !@species == :AEGISLASH || !@species == :PUMPKABOO || !@species == :GOURGEIST || !@species == :XERNEAS || !@species == :ZYGARDE || !@species == :DIANCIE || !@species == :HOOPA || !@species == :ORICORIO || !@species == :LYCANROC || !@species == :WISHIWASHI || !@species == :SILVALLY || !@species == :MINIOR || !@species == :NECROZMA || !@species == :MAGEARNA || !@species == :CRAMORANT || !@species == :TOXTRICITY || !@species == :ALCREMIE || !@species == :SINISTEA || !@species == :POLTEAGEIST || !@species == :EISCUE || !@species == :INDEEDEE || !@species == :MORPEKO || !@species == :ZACIAN || !@species == :ZAMAZENTA || !@species == :URSHIFU || !@species == :CALYREX || !@species == :MAGMORTAR || !@species == :MAGIKARP || !@species == :MILOTIC || !@species == :MAMOSWINE || !@species == :SPIRITOMB || !@species == :ELECTIVIRE || !@species == :ZORUA || !@species == :ZOROARK || !@species == :ZUBAT || !@species == :GOLBAT || !@species == :CROBAT || !@species == :HOPPIP || !@species == :SKIPLOOM || !@species == :JUMPLUFF || !@species == :REMORAID || !@species == :OCTILLERY || !@species == :TYROGUE || !@species == :HITMONTOP || !@species == :KINGDRA || !@species == :LEDIAN || !@species == :GIRAFARIG || !@species == :POLITOED || !@species == :MEW) && $player.pokedex.seen_forms_count(@species)== 1
	  ret[7] = _INTL("",$player.pokedex.number_evolved(@species))
	  ret[8] = _INTL("",$player.pokedex.number_caught(@species))
	  ret[9] = _INTL("",$player.pokedex.number_battled(@species))
	  ret[10] = _INTL("",$player.pokedex.number_weakness(@species))
	  ret[11] = _INTL("",$player.pokedex.number_moves(@species,@moveA))
	  ret[12] = _INTL("",$player.pokedex.number_moves(@species,@moveB))
	  ret[13] = _INTL("",$player.pokedex.seen_forms_count(@species))
	  ret[14] = _INTL("",$player.pokedex.number_evolved(@species))
      return ret
    end

	def pbDefineMoveA(pkmn)
	  return @moveA = :RAPIDSPIN if pkmn== :WARTORTLE 
	  return @moveA = :WRAP if pkmn== :INKAY 
	  return @moveA = :BUBBLEBEAM if pkmn== :SEISMITOAD
	  return @moveA = :SURF if pkmn== :VAPOREON
	  return @moveA = :AQUAJET if pkmn== :POPPLIO
	  return @moveA = :SPLASH if pkmn== :MAGIKARP
	  return @moveA = :SPLASH if pkmn== :FEEBAS
	  return @moveA = :HYPNOSIS if pkmn== :POLIWAG
	  return @moveA = :AQUATAIL if pkmn== :PSYDUCK
	  return @moveA = :MEGADRAIN if pkmn== :HOPPIP
	  return @moveA = :RAZORLEAF if pkmn== :SUNKERN
	  return @moveA = :FLAMEWHEEL if pkmn== :GROWLITHE
	  return @moveA = :GIGADRAIN if pkmn== :ROSELIA
	  return @moveA = :SUCKERPUNCH if pkmn== :SENTRET
	  return @moveA = :STUNSPORE if pkmn== :ODDISH
	  return @moveA = :AERIALACE if pkmn== :TAILLOW
	  return @moveA = :ROLLOUT if pkmn== :PHANPY
	  return @moveA = :CYNDAQUIL if pkmn== :CYNDAQUIL
	  return @moveA = :CUT if pkmn== :FARFETCHD
	  return @moveA = :DOUBLEKICK if pkmn== :NIDORANfE
	  return @moveA = :DOUBLEKICK if pkmn== :NIDORANmA
	  return @moveA = :FOLLOWME if pkmn== :FURRET
	  return @moveA = :FEATHERDANCE if pkmn== :PIDGEY
	  return @moveA = :ROLLOUT if pkmn== :SANDSHREW
	  return @moveA = :FLAMETHROWER if pkmn== :VULPIX
	  return @moveA = :FURYATTACK if pkmn== :BEEDRILL
	  return @moveA = :SANDATTACK if pkmn== :TORCHIC
	  return @moveA = :HELPINGHAND if pkmn== :MINUN
	  return @moveA = :HELPINGHAND if pkmn== :PLUSLE
	  return @moveA = :BITE if pkmn== :EKANS
	  return @moveA = :THUNDERSHOCK if pkmn== :MAREEP
	  return @moveA = :ROAR if pkmn== :POOCHYENA
	  return @moveA = :CONFUSION if pkmn== :DROWZEE
	  return @moveA = :HYPNOSIS if pkmn== :HYPNO
	  return @moveA = :PURSUIT if pkmn== :BLITZLE
	  return @moveA = :SWIFT if pkmn== :EEVEE
	  return @moveA = :SHOCKWAVE if pkmn== :ELECTRIKE
	  return @moveA = :THUNDERBOLT if pkmn== :PIKACHU
	  return @moveA = :PSYCHIC if pkmn== :RALTS
	  return @moveA = :ROCKSMASH if pkmn== :FALINKS
	  return @moveA = :NUZZLE if pkmn== :YAMPER
	  return @moveA = :HEADBUTT if pkmn== :OBSTAGOON
	  return @moveA = :ELECTROBALL if pkmn== :RAICHU
	  return @moveA = :HYPERFANG if pkmn== :RATTATA
	  return @moveA = :EMBER if pkmn== :FLETCHLING
	  return @moveA = :THUNDERSHOCK if pkmn== :TOGEDEMARU
	  return @moveA = :TANGELA if pkmn== :TANGELA
	  return @moveA = :WATERGUN if pkmn== :LOTAD
	  return @moveA = :AQUATAIL if pkmn== :MARILL
	  return @moveA = :BUBBLEBEAM if pkmn== :SQUIRTLE
	  return @moveA = :THUNDERSHOCK if pkmn== :DEDENNE
	  return @moveA = :THUNDERSHOCK if pkmn== :EMOLGA
	  return @moveA = :DOUBLEKICK if pkmn== :WOOLOO
	  return @moveA = :BITE if pkmn== :HOUNDOUR
	  return @moveA = :BITE if pkmn== :ZIGZAGOON
	  return @moveA = :PSYCHIC if pkmn== :NATU
	  return @moveA = :PSYCHIC if pkmn== :ROOKIDEE
	  return @moveA = :CRUNCH if pkmn== :GROWLITHE
	  return @moveA = :CRUNCH if pkmn== :MAWILE
	  return @moveA = :ZENHEADBUTT if pkmn== :MUNNA
	  return @moveA = :AIRCUTTER if pkmn== :WOOBAT
	  return @moveA = :LICKITUNG if pkmn== :LICKITUNG
	  return @moveA = :AQUAJET if pkmn== :KABUTO
	  return @moveA = :PSYCHIC if pkmn== :VENONAT
	  return @moveA = :BITE if pkmn== :BASCULIN
	  return @moveA = :WATERPULSE if pkmn== :FRILLISH
	  return @moveA = :SURF if pkmn== :WISHIWASHI
	  return @moveA = :VENOSHOCK if pkmn== :MAREANIE
	  return @moveA = :WATERGUN if pkmn== :OSHAWOTT
	  return @moveA = :AIRCUTTER if pkmn== :BEAUTIFLY
	  return @moveA = :VENOSHOCK if pkmn== :DUSTOX
	  return @moveA = :MASQUERAIN if pkmn== :MASQUERAIN
	  return @moveA = :MAGICALLEAF if pkmn== :BOUNSWEET
	  return @moveA = :SYNTHESIS if pkmn== :SEEDOT
	  return @moveA = :SUPERFANG if pkmn== :PATRAT
	  return @moveA = :BITE if pkmn== :TOTODILE
	  return @moveA = :DOUBLEKICK if pkmn== :DEERLING
	  return @moveA = :WATERGUN if pkmn== :SIMIPOUR
	  return @moveA = :RAPIDSPIN if pkmn== :KOMALA
	  return @moveA = :DOUBLETEAM if pkmn== :MIMIKYU
	  return @moveA = :BRUTALSWING if pkmn== :BEWEAR
	  return @moveA = :DOUBLESLAP if pkmn== :ORICORIO
	  return @moveA = :DRAGONCLAW if pkmn== :AXEW
	  return @moveA = :NIGHTSHADE if pkmn== :GOLETT
	  return @moveA = :BUBBLEBEAM if pkmn== :PRINPLUP
	  return @moveA = :ICICLESPEAR if pkmn== :VANILLITE
	  return @moveA = :VINEWHIP if pkmn== :GOGOAT
	  return @moveA = :HONECLAWS if pkmn== :ZANGOOSE
	  return @moveA = :ECHOEDVOICE if pkmn== :WHISMUR
	  return @moveA = :MEGADRAIN if pkmn== :LUDICOLO
	  return @moveA = :STOMP if pkmn== :RHYHORN
	  return @moveA = :PSYBEAM if pkmn== :ESPURR
	  return @moveA = :TAKEDOWN if pkmn== :SWAMPERT
	  return @moveA = :MAGICALLEAF if pkmn== :CHERUBI
	  return @moveA = :POISONPOWDER if pkmn== :WHIMSICOTT
	  return @moveA = :FIREFANG if pkmn== :DARUMAKA
	  return @moveA = :AQUAJET if pkmn== :FLOATZEL
	  return @moveA = :ROLLOUT if pkmn== :MILTANK
	  return @moveA = :MUDBOMB if pkmn== :MUK
	  return @moveA = :COUNTER if pkmn== :RIOLU
	  return @moveA = :MAGICALLEAF if pkmn== :ROSERADE
	  return @moveA = :HEADBUTT if pkmn== :LINOONE
	  return @moveA = :TACKLE
	end
	

	def pbDefineMoveB(pkmn)
	  return @moveB = :AQUATAIL if pkmn== :WARTORTLE 
	  return @moveB = :NIGHTSLASH if pkmn== :INKAY 
	  return @moveB = :AQUARING if pkmn== :SEISMITOAD
	  return @moveB = :WATERGUN if pkmn== :VAPOREON
	  return @moveB = :BUBBLEBEAM if pkmn== :POPPLIO
	  return @moveB = :TACKLE if pkmn== :MAGIKARP
	  return @moveB = :TACKLE if pkmn== :FEEBAS
	  return @moveB = :BUBBLEBEAM if pkmn== :POLIWAG
	  return @moveB = :HYPNOSIS if pkmn== :PSYDUCK
	  return @moveB = :ACROBATICS if pkmn== :HOPPIP
	  return @moveB = :RAZORLEAF if pkmn== :SUNKERN
	  return @moveB = :FIREFANG if pkmn== :GROWLITHE
	  return @moveB = :MAGICALLEAF if pkmn== :ROSELIA
	  return @moveB = :QUICKATTACK if pkmn== :SENTRET
	  return @moveB = :MEGADRAIN if pkmn== :ODDISH
	  return @moveB = :WINGATTACK if pkmn== :TAILLOW
	  return @moveB = :BULLDOZE if pkmn== :PHANPY
	  return @moveB = :EMBER if pkmn== :CYNDAQUIL
	  return @moveB = :FURYCUTTER if pkmn== :FARFETCHD
	  return @moveB = :TAILWHIP if pkmn== :NIDORANfE
	  return @moveB = :FOCUSENERGY if pkmn== :NIDORANmA
	  return @moveB = :HELPINGHAND if pkmn== :FURRET
	  return @moveB = :SANDATTACK if pkmn== :PIDGEY
	  return @moveB = :ROLLOUT if pkmn== :SANDSHREW
	  return @moveB = :INCINERATE if pkmn== :VULPIX
	  return @moveB = :TWINNEEDLE if pkmn== :BEEDRILL
	  return @moveB = :BULLDOZE if pkmn== :PHANPY
	  return @moveB = :FLAMECHARGE if pkmn== :TORCHIC
	  return @moveB = :ENCORE if pkmn== :MINUN
	  return @moveB = :COPYCAT if pkmn== :PLUSLE
	  return @moveB = :GLARE if pkmn== :EKANS
	  return @moveB = :THUNDERSHOCK if pkmn== :MAREEP
	  return @moveB = :BITE if pkmn== :POOCHYENA
	  return @moveB = :HEADBUTT if pkmn== :DROWZEE
	  return @moveB = :HYPNOSIS if pkmn== :HYPNO
	  return @moveB = :FLAMECHARGE if pkmn== :BLITZLE
	  return @moveB = :TACKLE if pkmn== :EEVEE
	  return @moveB = :SHOCKWAVE if pkmn== :ELECTRIKE
	  return @moveB = :ELECTROBALL if pkmn== :PIKACHU
	  return @moveB = :DRAININGKISS if pkmn== :RALTS
	  return @moveB = :HEADBUTT if pkmn== :FALINKS
	  return @moveB = :NUZZLE if pkmn== :YAMPER
	  return @moveB = :TAUNT if pkmn== :OBSTAGOON
	  return @moveB = :THUNDERBOLT if pkmn== :RAICHU
	  return @moveB = :BITE if pkmn== :RATTATA
	  return @moveB = :PECK if pkmn== :FLETCHLING
	  return @moveB = :CHARGE if pkmn== :TOGEDEMARU
	  return @moveB = :STUNSPORE if pkmn== :TANGELA
	  return @moveB = :MEGADRAIN if pkmn== :LOTAD
	  return @moveB = :BUBBLEBEAM if pkmn== :MARILL
	  return @moveB = :BUBBLEBEAM if pkmn== :SQUIRTLE
	  return @moveB = :PARABOLICCHARGE if pkmn== :DEDENNE
	  return @moveB = :ACROBATICS if pkmn== :EMOLGA
	  return @moveB = :COPYCAT if pkmn== :WOOLOO
	  return @moveB = :HOWL if pkmn== :HOUNDOUR
	  return @moveB = :COVET if pkmn== :ZIGZAGOON
	  return @moveB = :TELEPORT if pkmn== :NATU
	  return @moveB = :POWERTRIP if pkmn== :ROOKIDEE
	  return @moveB = :SUCKERPUNCH if pkmn== :MAWILE
	  return @moveB = :MOONLIGHT if pkmn== :MUNNA
	  return @moveB = :ENDEAVOR if pkmn== :WOOBAT
	  return @moveB = :LICK if pkmn== :LICKITUNG
	  return @moveB = :AQUAJET if pkmn== :KABUTO
	  return @moveB = :SUPERSONIC if pkmn== :VENONAT
	  return @moveB = :BITE if pkmn== :BASCULIN
	  return @moveB = :BRINE if pkmn== :FRILLISH
	  return @moveB = :TEARFULLOOK if pkmn== :WISHIWASHI
	  return @moveB = :LIQUIDATION if pkmn== :MAREANIE
	  return @moveB = :FOCUSENERGY if pkmn== :OSHAWOTT
	  return @moveB = :MORNINGSUN if pkmn== :BEAUTIFLY
	  return @moveB = :MOONLIGHT if pkmn== :DUSTOX
	  return @moveB = :SWEETSCENT if pkmn== :MASQUERAIN
	  return @moveB = :SPLASH if pkmn== :BOUNSWEET
	  return @moveB = :GROWTH if pkmn== :SEEDOT
	  return @moveB = :HYPNOSIS if pkmn== :PATRAT
	  return @moveB = :SCARYFACE if pkmn== :TOTODILE
	  return @moveB = :JUMPKICK if pkmn== :DEERLING
	  return @moveB = :ACROBATICS if pkmn== :SIMIPOUR
	  return @moveB = :YAWN if pkmn== :KOMALA
	  return @moveB = :COPYCAT if pkmn== :MIMIKYU
	  return @moveB = :STRENGTH if pkmn== :BEWEAR
	  return @moveB = :REVELATIONDANCE if pkmn== :ORICORIO
	  return @moveB = :DUALCHOP if pkmn== :AXEW
	  return @moveB = :HEAVYSLAM if pkmn== :GOLETT
	  return @moveB = :SWAGGER if pkmn== :PRINPLUP
	  return @moveB = :HAIL if pkmn== :VANILLITE
	  return @moveB = :SEEDBOMB if pkmn== :GOGOAT
	  return @moveB = :SLASH if pkmn== :ZANGOOSE
	  return @moveB = :ECHOEDVOICE if pkmn== :WHISMUR
	  return @moveB = :ZENHEADBUTT if pkmn== :LUDICOLO
	  return @moveB = :HORNATTACK if pkmn== :RHYHORN
	  return @moveB = :LEER if pkmn== :ESPURR
	  return @moveB = :MUDDYWATER if pkmn== :SWAMPERT
	  return @moveB = :LEAFAGE if pkmn== :CHERUBI
	  return @moveB = :COTTONGUARD if pkmn== :WHIMSICOTT
	  return @moveB = :UPROAR if pkmn== :DARUMAKA
	  return @moveB = :WATERFALL if pkmn== :FLOATZEL
	  return @moveB = :DEFENSECURL if pkmn== :MILTANK
	  return @moveB = :BELCH if pkmn== :MUK
	  return @moveB = :NASTYPLOT if pkmn== :RIOLU
	  return @moveB = :INGRAIN if pkmn== :ROSERADE
	  return @moveB = :BELLYDRUM if pkmn== :LINOONE
	  return @moveB = :STRUGGLE
	end
 
 def pbArceusTasksMain
    loctext = _INTL("")
    loctext += sprintf("")
    loctext += sprintf("")
    @sprites["locwindow"].setText(loctext)
  @sprites["background"]=IconSprite.new(0,0,@viewport)
  @sprites["background"].setBitmap("Graphics/Pictures/EncounterUI/"+WINDOWSKIN2)
  @currentTexts = textsDefined
  drawText
      if Input.trigger?(Input::BACK)
        return
      end
 end
 
 
 
 def pbArceusTasksClear
  drawText
 end
  # Draw text and icons if map has encounters defined
  def drawPresent
    @sprites["rightarrow"].visible = (@index < @eLength-1) ? true : false
    @sprites["leftarrow"].visible = (@index > 0) ? true : false
    i = 0
    enc_array, currKey = getEncData
    enc_array.each do |s|
      species_data = GameData::Species.get(s)
      if !$player.pokedex.owned?(s) && !seen_form_any_gender?(s,species_data.form)
        @sprites["icon_#{i}"].pbSetParams(0,0,0,false)
        @sprites["icon_#{i}"].visible = true
      elsif !$player.pokedex.owned?(s)
        @sprites["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @sprites["icon_#{i}"].tone = Tone.new(0,0,0,255)
        @sprites["icon_#{i}"].visible = true
      else
        @sprites["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @sprites["icon_#{i}"].tone = Tone.new(0,0,0,0)
        @sprites["icon_#{i}"].visible = true
      end
      i += 1
    end
    # Get user-defined encounter name or default one if not present
    name = USER_DEFINED_NAMES ? USER_DEFINED_NAMES[currKey] : GameData::EncounterType.get(currKey).real_name
	idealmap = pbGetMapNameFromId($game_variables[4977])
    loctext = _INTL("<ac><c2=43F022E8>{1}: {2}</c2></ac>", idealmap,name)
    loctext += sprintf("<al><c2=7FF05EE8>Total encounters for area: %s</c2></al>",enc_array.length)
    loctext += sprintf("<c2=63184210>-----------------------------------------</c2>")
    @sprites["locwindow"].setText(loctext)
  end
  
  # Draw text if map has no encounters defined (e.g. in buildings)
  def drawAbsent
    loctext = _INTL("<ac><c2=43F022E8>{1}</c2></ac>", $game_map.name)
    loctext += sprintf("<al><c2=7FF05EE8>This area has no encounters!</c2></al>")
    loctext += sprintf("<c2=63184210>-----------------------------------------</c2>")
    @sprites["locwindow"].setText(loctext)
  end
 
  # Method that returns an array of symbolic names for chosen encounter type on current map
  # Currently, the resulting array is sorted by national Pokédex number
  def getEncData
    currKey = @encounter_tables.keys[@index]
    arr = []
    enc_array = []
    @encounter_tables[currKey].each { |s| arr.push( s[1] ) }
    GameData::Species.each { |s| enc_array.push(s.id) if arr.include?(s.id) } # From Maruno
    enc_array.uniq!
    return enc_array, currKey
  end
  
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  # Hide sprites
  def hideSprites
    for i in 0...@max_enc
      @sprites["icon_#{i}"].visible = false
    end
  end

  # Dipose stuff at the end
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

end


class EncounterList_Screen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbEncounter
    @scene.pbEndScene
  end
end

  def getEncData
    currKey = @encounter_tables.keys[@index]
    arr = []
    enc_array = []
    @encounter_tables[currKey].each { |s| arr.push( s[1] ) }
    GameData::Species.each { |s| enc_array.push(s.id) if arr.include?(s.id) } # From Maruno
    enc_array.uniq!
    return enc_array, currKey
  end
  
    def getMaxEncounters(data)
    keys = data.keys
    a = []
    for key in keys
      b = []
      arr = data[key]
      for i in 0...arr.length
        b.push( arr[i][1] )
      end
      a.push(b.uniq.length)
    end
    return a.max, keys.length
  end

def pbCompletionCheck(vari)
    amt = 0
    if vari == 1
	maps=[5,4,7,8,9,13,44,16,24,31,19,30,29,28,17]
	end
	maps.each do |map|
	mapid = map
	if mapid == 5 || mapid == 4 || mapid == 7 || mapid == 8 || mapid == 9 || mapid == 13  || mapid == 44
	$game_variables[2] = "Temperate Zone"
	else
	$game_variables[2] = "Mountain Zone"
	end
    @encounter_data = GameData::Encounter.get(mapid, $PokemonGlobal.encounter_version)
    if @encounter_data   #if it finds encounter data for the map
      @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
      @max_enc = getMaxEncounters(@encounter_tables)
    else
      @max_enc, @eLength = [1, 1]
    end
    enc_array, currKey = getEncData
    enc_array.each do |s|
      species_data = GameData::Species.get(s)
      if !$player.pokedex.owned?(s) && !seen_form_any_gender?(s,species_data.form)
      pbMessage(_INTL("Checking your report, you seem to be missing a POKeMON from {1}.",$game_variables[2]))
	  return false
      else
	  amt = amt + 1
    end
	if amt==@max_enc
	 return true
	end
end
end
end

    def pbFormCheck(pkmn)
        formcmds = [[], []]
        GameData::Species.each do |sp|
          next if sp.species != pkmn
          formcmds[0].push(sp.form)
        end
        return formcmds[0].length
        end

# Utility method for calling UI
def pbViewEncounters
	      cmd = pbMessage(_INTL("Which Area do you want to check?"),[
                            _INTL("Temperate Beach"),
                            _INTL("Temperate Base Zone"),
                            _INTL("Temperate Berry Fields"),
                            _INTL("Temperate Tent Zone"),
                            _INTL("Stone Temple Temperate"),
                            _INTL("Temperate Island"),
                            _INTL("Temperate Snowy")])
		  if cmd==0
		   $game_variables[4977]=5
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==1
		   $game_variables[4977]=4
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==2
		   $game_variables[4977]=7
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==3
		   $game_variables[4977]=8
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==4
		   $game_variables[4977]=9
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==5
		   $game_variables[4977]=13
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  elsif cmd==6
		   $game_variables[4977]=44
    scene = EncounterList_Scene.new
    screen = EncounterList_Screen.new(scene)
    screen.pbStartScreen
		  end 
end