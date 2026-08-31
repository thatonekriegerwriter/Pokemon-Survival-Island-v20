module NoteOpen  
  def self.openWindow
  $game_temp.in_menu=true
  noteScene=PlayerJournal.new
  noteScene.pbStartScene
  craft=noteScene.pbSelectMenu
  noteScene.pbEndScene
  $game_temp.in_menu=false
 end
end



class PlayerJournal
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
:OverworldLand => "Overworld",
:OverworldLandNight => "Overworld",
:Adventure => "Adventures",
:Bait => "Bait",
:CaveDeep => "Cave",
:BerryTree => "Berry Tree"
}
CRAFTING_TYPES = {
:POKEMON => "Pokemon Support",
:FOODWATER => "Food & Water",
:TOOL => "Tools",
:MEDICINE => "Medicine",
:MATERIAL => "Materials",
:PLACEABLE => "Placeables"



}
 def pbStartScene
  @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  @viewport.z=99999
  @sprites={}
  @note_text = {}
  @sidebar_text={}
  @player_icons = {}
  @pkmn_icons = {}
  @encounter_icons = {}
  @pkmn_icons2={}
  @pkmn_icons3={}
  @recipe_icons={}
  @startend = [0,13]
  @end = false 
  setup_data
  setup_sprites
 end
 
 def setup_data
  @player_length = 0
  @cur_page = 0
  @depth = -1
  @selections = [-1, -1, -1, -1]
  @notes = $PokemonGlobal.notebook + $PokemonGlobal.notestorage + getAllTips
  available_recipes = GameData::Recipe.select do |recipe|
  !recipe.locked? || $recipe_book.has?(recipe.id)
  end
  @recipes = available_recipes.group_by(&:type)
  @recipe_types = @recipes.keys
  @zones = GameData::Zone.all
  @encounter_data = nil
  @max_enc, @eLength = [1, 1]
 end
 
 def setup_sprites
  @bar_image = RPG::Cache.picture("Hud/overlay_hp")
  @bar_image2 = RPG::Cache.picture("Hud/overlay_hp2")
  @rightmost = Graphics.width
  @bottommost = Graphics.height
  @sprites["background"]=IconSprite.new(0,0,@viewport)
  @sprites["background"].setBitmap("Graphics/Pictures/notebookbg")
  @sprites["background"].z = 0 
  4.times do |i|
   @sprites["notebooktab#{i}"]=IconSprite.new(0,0,@viewport)
   @sprites["notebooktab#{i}"].setBitmap("Graphics/Pictures/notebooktabu")
   @sprites["notebooktab#{i}"].x = 211 if i == 0
   @sprites["notebooktab#{i}"].x = 211+((@sprites["notebooktab0"].width-9)*i) if i != 0
   @sprites["notebooktab#{i}"].y = 17
   @sprites["notebooktab#{i}"].z = i+3
   @sprites["notebooktab#{i}"].z = 2 if i == 0
   @sprites["header#{i}"]=Window_UnformattedTextPokemon.new("")
   @sprites["header#{i}"].contents.font.size = 14 
   @sprites["header#{i}"].refresh
   pbPrepareWindow(@sprites["header#{i}"])
   @sprites["header#{i}"].resizeToFit("")
   @sprites["header#{i}"].viewport=@viewport
   @sprites["header#{i}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
   @sprites["header#{i}"].shadowColor=nil
   @sprites["header#{i}"].windowskin=nil
   @sprites["header#{i}"].setTextToFit(["Player", "Notes", "Recipes", "Research"][i])
   tab_x = @sprites["notebooktab#{i}"].x
   tab_width = @sprites["notebooktab#{i}"].width
   bonus = 6
   @sprites["header#{i}"].x = bonus + tab_x + (tab_width - @sprites["header#{i}"].width) / 2
   @sprites["header#{i}"].y += 6 
   @sprites["header#{i}"].z =@sprites["notebooktab#{i}"].z
  end
  @sprites["selarrowr"]=IconSprite.new(0,0,@viewport)
  @sprites["selarrowr"].setBitmap("Graphics/Pictures/selarrow")
  @sprites["selarrowr"].x = @rightmost-17
  @sprites["selarrowr"].y = 10
  @sprites["selarrowr"].z = 99
  @sprites["selarrowl"]=IconSprite.new(0,0,@viewport)
  @sprites["selarrowl"].setBitmap("Graphics/Pictures/selarrowl")
  @sprites["selarrowl"].x = 196
  @sprites["selarrowl"].y = 10
  @sprites["selarrowl"].z = 99

 
  @sprites["selarrow"]=IconSprite.new(0,0,@viewport)
  @sprites["selarrow"].setBitmap("Graphics/Pictures/selarrow")
  @sprites["selarrow"].z = 99
  @sprites["selarrow"].visible = false
  @sprites["selector"]=IconSprite.new(0,0,@viewport)
  @sprites["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
  @sprites["selector"].visible = false
 
 
 end 
 
 def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
 end
 
 def pbSelectMenu
    pbSEPlay("page",50)
    loop do
     $PokemonGlobal.addNewFrameCount 
     update
     Graphics.update
     Input.update
	 handle_input
	 break if @end==true
	 draw_page
	end
 end
 
def draw_page
  case @cur_page
  when 0
    draw_player_page
  when 1
    draw_notes_page
  when 2
    draw_recipes_page
  when 3
    draw_research_page
  end
end


 def update
    pbUpdateSpriteHash(@sprites)
    4.times do |i|
	  if @cur_page == i
       @sprites["notebooktab#{i}"].setBitmap("Graphics/Pictures/notebooktab")
       @sprites["notebooktab#{i}"].z=98
	 else
       @sprites["notebooktab#{i}"].setBitmap("Graphics/Pictures/notebooktabu")
       @sprites["notebooktab#{i}"].z = i+3
       @sprites["notebooktab#{i}"].z = 2 if i == 0
     end
      @sprites["header#{i}"].z = @sprites["notebooktab#{i}"].z
      if @cur_page>0
       @sprites["background"].setBitmap("Graphics/Pictures/notebookbg2")
	  else
       @sprites["background"].setBitmap("Graphics/Pictures/notebookbg")
	  end
   end
    case @cur_page
    when 0
    # update_player_page
    when 1
    #  update_notes_page
    when 2
    #  update_recipe_page
    when 3
    #  update_research_page
    end
 end 
 
 def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
	$game_temp.notebook_calling=false
    @viewport.dispose

 end 


end 

class PlayerJournal

def draw_player_page
  create_player
  refresh_player if !@player_icons.empty?


end 

  def refresh_player
  
    
    @player_icons["starbarborder"].visible = $player.playerstamina!=nil
    @player_icons["bar"].visible = @player_icons["starbarborder"].visible
    @player_icons["starbarfill"].visible = @player_icons["starbarborder"].visible
    @player_icons["starbarfill"].bitmap.clear
    fillAmount = ($player.playerstamina==0 || $player.playermaxstamina==0) ? 0 : (
      $player.playerstamina*@player_icons["hpbarfill"].bitmap.width/$player.playermaxstamina
    )
	
    return if fillAmount <= 0
    hpColors = Color.new(255,182,66)
    shadowHeight = 2
    @player_icons["starbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @player_icons["starbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @player_icons["starbarfill"].bitmap.height-shadowHeight
      ), hpColors
    )



    @player_icons["hpbarborder"].visible = $player.playerhealth!=nil
    @player_icons["bar2"].visible = @player_icons["hpbarborder"].visible
    @player_icons["hpbarfill"].visible = @player_icons["hpbarborder"].visible
    @player_icons["hpbarfill"].bitmap.clear
    fillAmount = ($player.playerhealth==0 || $player.playermaxhealth2==0) ? 0 : (
      $player.playerhealth*@player_icons["hpbarfill"].bitmap.width/$player.playermaxhealth2
    )
    return if fillAmount <= 0
    hpColors = hpBarCurrentColors($player.playerhealth, $player.playermaxhealth2)
    shadowHeight = 2
    @player_icons["hpbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @player_icons["hpbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @player_icons["hpbarfill"].bitmap.height-shadowHeight
      ), hpColors[0]
    )
  
  end
  def create_player
     if @player_icons["trainer"].nil?
    @player_icons["trainer"] = IconSprite.new(200,70,@viewport)
    @player_icons["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @player_icons["trainer"].x = 360
    @player_icons["trainer"].y = 40
    @player_icons["trainer"].z = 98
    @player_icons["trainer"].visible=true
     end
	if $player.playerclass.is_a?(PlayerClass)
	theclass = $player.playerclass.name
	else
	theclass = $player.playerclass
	end



     if @player_icons["playerclassname"].nil?
    @player_icons["playerclassname"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@player_icons["playerclassname"])
    @player_icons["playerclassname"].viewport=@viewport
    @player_icons["playerclassname"].windowskin=nil
    @player_icons["playerclassname"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @player_icons["playerclassname"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @player_icons["playerclassname"].width=240
    @player_icons["playerclassname"].height=90
    @player_icons["playerclassname"].x = 390
    @player_icons["playerclassname"].y = 178
    @player_icons["playerclassname"].z=98
    @player_icons["playerclassname"].text="#{theclass} Lv#{$player.playerclasslevel.to_i}"
    @player_icons["playerclassname"].resizeToFit("#{theclass} Lv#{$player.playerclasslevel.to_i}")
    @player_icons["playerclassname"].visible=true
     end
	
	
     if @player_icons["playername1"].nil?
    @player_icons["playername1"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@player_icons["playername1"])
    @player_icons["playername1"].viewport=@viewport
    @player_icons["playername1"].windowskin=nil
    @player_icons["playername1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @player_icons["playername1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @player_icons["playername1"].width=240
    @player_icons["playername1"].height=90
    @player_icons["playername1"].x = 20
    @player_icons["playername1"].y = 80
    @player_icons["playername1"].z=98
    @player_icons["playername1"].text="Property of:"
    @player_icons["playername1"].resizeToFit("Property of:")
    @player_icons["playername1"].visible=true
     end
	
	
     if @player_icons["playername"].nil?
    @player_icons["playername"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@player_icons["playername"])
    @player_icons["playername"].viewport=@viewport
    @player_icons["playername"].windowskin=nil
    @player_icons["playername"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @player_icons["playername"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @player_icons["playername"].width=240
    @player_icons["playername"].height=90
    @player_icons["playername"].x = 35
    @player_icons["playername"].y = 110
    @player_icons["playername"].z=98
    @player_icons["playername"].text=$player.name
    @player_icons["playername"].resizeToFit($player.name)
    @player_icons["playername"].visible=true
     end
#"Graphics/Pictures/Hud/Heart"
    if true

	sta = $player.playerstamina
	totalsta = $player.playermaxstamina

    width = 90
    height = 8
    fillWidth = width-4
    fillHeight = height-4
	
	







	 
     if @player_icons["starbarborder"].nil?
    @player_icons["starbarborder"] = BitmapSprite.new(width,height,@viewport)
    @player_icons["starbarborder"].x = 210
    @player_icons["starbarborder"].y = 80
    @player_icons["starbarborder"].z=98
    @player_icons["starbarborder"].bitmap.fill_rect(Rect.new(0,0,width,height), Color.new(32,32,32))
    @player_icons["starbarborder"].bitmap.fill_rect((width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96))
    @player_icons["starbarborder"].visible = false
	
	
    @player_icons["starbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @player_icons["starbarfill"].x = @player_icons["starbarborder"].x+2
    @player_icons["starbarfill"].y = @player_icons["starbarborder"].y+2
    @player_icons["starbarfill"].z=98
    @player_icons["starbarfill"].visible = false
     end
	
     if @player_icons["bar"].nil?
    @player_icons["bar"]=IconSprite.new((@player_icons["starbarborder"].x-7),(@player_icons["starbarborder"].y-6),@viewport)
    @player_icons["bar"].setBitmap("Graphics/Pictures/Hud/Bolt")
    @player_icons["bar"].visible = false
    @player_icons["bar"].z = 99
     end
	


	
	
	
	
	
	
	
     if @player_icons["hpbarborder"].nil?
    @player_icons["hpbarborder"] = BitmapSprite.new(width,height,@viewport)
    @player_icons["hpbarborder"].x = 210
    @player_icons["hpbarborder"].y = 60
    @player_icons["hpbarborder"].z=98
    @player_icons["hpbarborder"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @player_icons["hpbarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @player_icons["hpbarborder"].visible = false
     end
	
     if @player_icons["bar2"].nil?
    @player_icons["bar2"]=IconSprite.new((@player_icons["hpbarborder"].x-5),(@player_icons["hpbarborder"].y-7),@viewport)
    @player_icons["bar2"].setBitmap("Graphics/Pictures/Hud/Heart")
    @player_icons["bar2"].visible = false
    @player_icons["bar2"].z = 98
     end
	

	
     if @player_icons["hpbarfill"].nil?
    @player_icons["hpbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @player_icons["hpbarfill"].x = @player_icons["hpbarborder"].x+2
    @player_icons["hpbarfill"].y = @player_icons["hpbarborder"].y+2
    @player_icons["hpbarfill"].z=98
    @player_icons["hpbarfill"].visible = false
     end
    end


  end


def destroy_current_page
  destroy_sidebar_text
  destroy_pkmn_icons
  destroy_player
  destroy_note_content
  destroy_recipe_icons 
  destroy_research_icons
end

def draw_notes_page

  display_notes if @depth == -1 || @depth == 0
  display_note_content if @depth == 0
end

def draw_recipes_page
    draw_recipe_types
end



def draw_research_page
	@zones_temp=[] if (@depth==-1 || @depth==0)
    display_maps if (@depth==-1 || @depth==0)
	@submap_types = [] if (@depth==-1 || @depth==0)
	if !@zones_temp.empty?
    if  @selections[0]!=-1 && (@depth==1 || @depth==2)
	display_sub_maps(@zones_temp[@selections[0]])
	@selections[1]=0 if @selections[1]==-1
	@mapid = @submap_types[@selections[1]]
	return if @mapid.nil?
	load_new_encounter_data(@mapid)
	@selections[2]=0 if @selections[2]==-1
	if @depth==2 && @pkmn_icons.key?("icon_#{@selections[2]}")
       @sprites["selector"].x = @pkmn_icons["icon_#{@selections[2]}"].x+(@sprites["selector"].width/4)-3
       @sprites["selector"].y = @pkmn_icons["icon_#{@selections[2]}"].y+@sprites["selector"].width/4 
       @sprites["selector"].z = 99
       @sprites["selector"].visible=true if @sprites["selector"].visible==false
	end





	elsif @depth==0
	destroy_pkmn_icons if !@pkmn_icons.empty?
    


	elsif @depth==3 && @selections[1]!=-1
	destroy_pkmn_icons if !@pkmn_icons.empty?
	destroy_sidebar_text
    @sprites["selarrow"].visible = false if @sprites["selarrow"].visible==true
	@sprites["selector"].visible=false if @sprites["selector"].visible==true
	display_species if @pkmn_icons2.empty?
    enc_array, currKey = getEncData if !@pkmn_icons2.empty?
	 if !@pkmn_icons2.empty?
    thespecies = enc_array[@selections[2]]
	species_data = GameData::Species.get(thespecies)
	if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
	make_move_text if @pkmn_icons3.empty? && @selections[3]==3 && @depth==3
	end 
	end 
	if !@pkmn_icons2.empty?
	 @pkmn_icons2["thedexentry"].text = pbPokedexEntry(thespecies)
    end
    end
	
	
	
	
	
    @sprites["selector"].visible = false if @depth<2
    @sprites["selarrow"].visible = false if @selection==-1
    @sprites["selarrow"].visible = false if @depth==-1
	end

end

  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return [Color.new(240,80,32),Color.new(168,48,56)]
    elsif hp<=(totalhp/2.0)
      return [Color.new(250,250,51),Color.new(184,112,0)]
    end
    return [Color.new(24,192,32),Color.new(0,144,0)]
  end

def display_notes
# destroy_sidebar_text
 create_notes_text
 count = 0
 @sidebar_text["cook-1"].visible=true

 @notes.each_with_index do |mail, i|
 @sidebar_text["cook#{count}"].visible=true
 if current_selection==count+1
  @sprites["selarrow"].x = @sidebar_text["cook#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["cook#{count}"].y+6
  @sprites["selarrow"].visible = true
 end
 count+=1
 end
 
 
 if current_selection==0
  @sprites["selarrow"].x = @sidebar_text["cook-1"].x
  @sprites["selarrow"].y = @sidebar_text["cook-1"].y+6
  @sprites["selarrow"].visible = true
 
 end
 
 if current_selection==-1
  @sprites["selarrow"].visible = false
 
 end
 @selection_length = count-1
end 

def create_notes_text
 return if !@sidebar_text.empty?
 @sidebar_text["cook-1"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["cook-1"])
 @sidebar_text["cook-1"].viewport=@viewport
 @sidebar_text["cook-1"].windowskin=nil
 @sidebar_text["cook-1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["cook-1"].shadowColor=nil
 @sidebar_text["cook-1"].contents.font.size = 14 
 @sidebar_text["cook-1"].width=240
 @sidebar_text["cook-1"].height=90
 @sidebar_text["cook-1"].x = 10
 @sidebar_text["cook-1"].y = 40
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["cook-1"].z=98
 @sidebar_text["cook-1"].text="[NEW NOTE]"
 @sidebar_text["cook-1"].visible=false
 
 count = 0
 @notes.each_with_index do |note, i|
 @sidebar_text["cook#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["cook#{count}"])
 @sidebar_text["cook#{count}"].viewport=@viewport
 @sidebar_text["cook#{count}"].windowskin=nil
 @sidebar_text["cook#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["cook#{count}"].shadowColor=nil
 @sidebar_text["cook#{count}"].contents.font.size = 14
 @sidebar_text["cook#{count}"].refresh
 @sidebar_text["cook#{count}"].width=240
 @sidebar_text["cook#{count}"].height=90
 @sidebar_text["cook#{count}"].x = 10
 @sidebar_text["cook#{count}"].y = 65 if count == 0
 @sidebar_text["cook#{count}"].y = 65+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["cook#{count}"].z=98
  if note.is_a?(Symbol)
   if isthisAGroup(note)
     thegroup = Settings::TIP_CARDS_GROUPS[note]
     @sidebar_text["cook#{count}"].setTextToFit(thegroup[:Title])
   else
     thetip = $PokemonGlobal.tipcards[note]
     @sidebar_text["cook#{count}"].setTextToFit(thetip[:Title])
   end
  elsif note.is_a?(Mail)
 @sidebar_text["cook#{count}"].setTextToFit(note.matter)
  else
 @sidebar_text["cook#{count}"].setTextToFit("ERROR")
  end
 @sidebar_text["cook#{count}"].visible=false

 
 count+=1
 end




end

def display_note_content
 #destroy_note_content
 create_note_content if current_selection>0
 @note_text["cook-1"].visible = true if current_selection>0
 @note_text["cook-2"].visible = true if current_selection>0
end
def create_note_content
 return if !@note_text.empty?
 return if @notes[current_selection-1].nil?
 note = @notes[current_selection-1]
 @note_text["cook-1"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@note_text["cook-1"])
 @note_text["cook-1"].viewport=@viewport
 @note_text["cook-1"].windowskin=nil
 @note_text["cook-1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @note_text["cook-1"].shadowColor=nil
 @note_text["cook-1"].width=240
 @note_text["cook-1"].height=90
 @note_text["cook-1"].x = 200
 @note_text["cook-1"].y = 28
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @note_text["cook-1"].z=98
  if note.is_a?(Symbol)
   if isthisAGroup(note)
     thegroup = Settings::TIP_CARDS_GROUPS[note]
     topic = thegroup[:Title]
   else
     thetip = $PokemonGlobal.tipcards[note]
     topic = thetip[:Title]
   end
  elsif note.is_a?(Mail)
    if note.date_created!=""
     topic = "#{note.matter}"
	else
     topic = "#{note.matter} - #{note.date_created}"
	end 
  else
     topic = "ERROR"
  end
 @note_text["cook-1"].text="#{topic}"
 @note_text["cook-1"].resizeToFit("#{topic}")
 @note_text["cook-1"].visible=false
 
 
 
 
 
 @note_text["cook-2"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@note_text["cook-2"])
 @note_text["cook-2"].viewport=@viewport
 @note_text["cook-2"].windowskin=nil
 @note_text["cook-2"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @note_text["cook-2"].shadowColor=nil
 @note_text["cook-2"].contents.font.size = 14 
 @note_text["cook-2"].refresh
 @note_text["cook-2"].width=240
 @note_text["cook-2"].height=90
 @note_text["cook-2"].x = 200
 @note_text["cook-2"].y = 62
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @note_text["cook-2"].z=98
  if note.is_a?(Symbol)
   if isthisAGroup(note)
     thegroup = Settings::TIP_CARDS_GROUPS[note]
	 tips = thegroup[:Tips]
	 contents = ""
	 tips.each do |tip|
       thetip = $PokemonGlobal.tipcards[tip]
       contents += thetip[:Text]
	   contents += "\n"
	 
	 end 
    if contents.length > 760
	  contents = contents.slice(0, 760) 
	  contents += "...\nIn order to continue reading, press USE."
	else
	  
	  contents += "\nYou can also press USE to view the Tip itself."
	end 
    # contents = "This is a Tutorial Group, so it cannot be \ndisplayed, press USE to view."
    # contents = "This is a Tutorial Group, so it cannot be \ndisplayed, press USE to view."
   else
     thetip = $PokemonGlobal.tipcards[note]
     contents = thetip[:Text]
    #if contents.length > 71
    # contents = contents.slice(0, 71) 
	 # contents += "...\n\nIn order to continue reading, press USE."
	#  else
	  contents += "\nYou can also press USE to view the Tip itself."
	# end
   end
  elsif note.is_a?(Mail)
     contents = note.message
    #if contents.length > 71
     #contents = contents.slice(0, 71) 
	 # contents += "...\nIn order to continue reading, press USE."
	 #end
  else
     topic = "ERROR"
     contents = "This should not occur."
  end
 contents = wrap_text(contents, 60)
 @note_text["cook-2"].text="#{contents}"
 @note_text["cook-2"].resizeToFit("#{contents}")
 @note_text["cook-2"].visible=false
end
def destroy_research_icons
  destroy_pkmn_icons2
  destroy_pkmn_icons3
end


def wrap_text(text, max_chars)
  result = []

  text.split("\n", -1).each do |line|
    words = line.split(" ")
    current = ""

    words.each do |word|
      if (current.empty? ? word : "#{current} #{word}").length > max_chars
        result << current unless current.empty?
        current = word
      else
        current += " " unless current.empty?
        current += word
      end
    end

    result << current
  end

  result.join("\n")
end
end 
class PlayerJournal
 SPECIES_PAGES_LENGTH = 4
def create_species
    if true
       enc_array, currKey = getEncData
   thespecies = enc_array[@selections[2]]
   @pkmn_icons2["dex_icon"]  = PokemonSprite.new(@viewport)
   @pkmn_icons2["dex_icon"].setOffset(PictureOrigin::CENTER)
   @pkmn_icons2["dex_icon"].x = 80
   @pkmn_icons2["dex_icon"].y = 100
   @pkmn_icons2["dex_icon"].z = 50
   @pkmn_icons2["pkmn_name"]=Window_UnformattedTextPokemon.new("") 
    @pkmn_icons2["pkmn_name"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @pkmn_icons2["pkmn_name"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 pbPrepareWindow(@pkmn_icons2["pkmn_name"])
 @pkmn_icons2["pkmn_name"].viewport=@viewport
 @pkmn_icons2["pkmn_name"].windowskin=nil
 @pkmn_icons2["pkmn_name"].x = @pkmn_icons2["dex_icon"].x-45
 @pkmn_icons2["pkmn_name"].y = @pkmn_icons2["dex_icon"].y+40
 @pkmn_icons2["pkmn_name"].z = 51
 
 
      species_data = GameData::Species.get(thespecies)
      if !$player.pokedex.owned?(thespecies) && !seen_form_any_gender?(thespecies,species_data.form) && !$player.is_it_this_class?(:EXPERT)
        @pkmn_icons2["dex_icon"].setSpeciesBitmap(nil)
        @pkmn_icons2["dex_icon"].zoom_x=0.5
        @pkmn_icons2["dex_icon"].zoom_y=0.5
 @pkmn_icons2["pkmn_name"].x = @pkmn_icons2["pkmn_name"].x+15
        @pkmn_icons2["pkmn_name"].text="???"
        @pkmn_icons2["pkmn_name"].setTextToFit("???")
      elsif !$player.pokedex.owned?(thespecies)
        @pkmn_icons2["dex_icon"].setSpeciesBitmap(thespecies)
        @pkmn_icons2["dex_icon"].tone = Tone.new(0,0,0,255)
        @pkmn_icons2["pkmn_name"].text=GameData::Species.get(thespecies).name
        @pkmn_icons2["pkmn_name"].setTextToFit(GameData::Species.get(thespecies).name)
      else
        @pkmn_icons2["dex_icon"].setSpeciesBitmap(thespecies)
        @pkmn_icons2["dex_icon"].tone = Tone.new(0,0,0,0)
        @pkmn_icons2["pkmn_name"].text=GameData::Species.get(thespecies).name
        @pkmn_icons2["pkmn_name"].setTextToFit(GameData::Species.get(thespecies).name)
      end
   end
 @pkmn_icons2["background"]=IconSprite.new(0,0,@viewport)
 @pkmn_icons2["background"].setBitmap("Graphics/Pictures/notebooksquare")
 @pkmn_icons2["background"].z = 1 
 if @pkmn_icons2["dexcursor"].nil? && false
 @pkmn_icons2["dexcursor"]=IconSprite.new(0,0,@viewport)
 @pkmn_icons2["dexcursor"].setBitmap("Graphics/Pictures/selarrowd")
 @pkmn_icons2["dexcursor"].x = @pkmn_icons2["dex_icon"].x-20
 @pkmn_icons2["dexcursor"].y = 195
 @pkmn_icons2["dexcursor"].z = 51
 @selection4=0 if @selection4==-1
 end
 if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
species_data.types.each_with_index do |type, i|
 @pkmn_icons2["type#{i}"] = IconSprite.new(0,0,@viewport)
 @pkmn_icons2["type#{i}"].setBitmap("Graphics/Pictures/ftypes/#{GameData::Type.get(type).name}")
if species_data.types.length != 1
 @pkmn_icons2["type#{i}"].x = (@pkmn_icons2["pkmn_name"].x-20)+(i*@pkmn_icons2["type#{i}"].width)
 @pkmn_icons2["type#{i}"].y = (@pkmn_icons2["pkmn_name"].y+40)
else
 @pkmn_icons2["type#{i}"].x = (@pkmn_icons2["pkmn_name"].x+20)+(i*@pkmn_icons2["type#{i}"].width)
 @pkmn_icons2["type#{i}"].y = (@pkmn_icons2["pkmn_name"].y+40)

end
 end
 end
 @pkmn_icons2["thedexentry"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmn_icons2["thedexentry"])
 @pkmn_icons2["thedexentry"].viewport=@viewport
 @pkmn_icons2["thedexentry"].windowskin=nil
 @pkmn_icons2["thedexentry"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @pkmn_icons2["thedexentry"].contents.font.size = 14
 @pkmn_icons2["thedexentry"].shadowColor=nil
 @pkmn_icons2["thedexentry"].x = @pkmn_icons2["dex_icon"].x-82

 @pkmn_icons2["thedexentry"].y = 195
 @pkmn_icons2["thedexentry"].z = 99
 @pkmn_icons2["thedexentry"].width=180
 @pkmn_icons2["thedexentry"].height=270
 @pkmn_icons2["thedexentry"].text = pbPokedexEntry(thespecies)


end

def display_species
enc_array, currKey = getEncData
thespecies = enc_array[@selections[2]]
species_data = GameData::Species.get(thespecies)
destroy_pkmn_icons2
create_species
 if !species_data.nil? 
 
 if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
 if @selections[3]==0
    @visibletasks ||= [0,3]
    tasks = []
	$player.pokedex.give_tasks(thespecies)
 $player.pokedex.tasks[species_data.species.name].each_with_index do |pokemon_task, i| # Tasks by pokemon
      next unless i >= @visibletasks[0] && i <= @visibletasks[1]
      tasks << pokemon_task
 end

 @pkmn_icons2["taskheader"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmn_icons2["taskheader"])
 @pkmn_icons2["taskheader"].viewport=@viewport
 @pkmn_icons2["taskheader"].windowskin=nil
    @pkmn_icons2["taskheader"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @pkmn_icons2["taskheader"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmn_icons2["taskheader"].x = @pkmn_icons2["dex_icon"].x+100
 @pkmn_icons2["taskheader"].y = 40
 @pkmn_icons2["taskheader"].width=120
 @pkmn_icons2["taskheader"].height=90
   numtasks1 = num_tasks_completed(thespecies)
   @pkmn_icons2["taskheader"].text = "TASKS (#{numtasks1}/10):"
 @pkmn_icons2["taskheader"].resizeToFit("TASKS (#{numtasks1}/10):")

 tasks.each_with_index do |pokemon_task, i|
	display_task(pokemon_task,i,thespecies)
 end  
 elsif @selections[3]==1
   height = species_data.height
   weight = species_data.weight
         if System.user_language[3..4] == "US"   # If the user is in the United States
          inches = (height / 0.254).round
          pounds = (weight / 0.45359).round
          aheight = "Height: #{(inches / 12)}'#{(inches % 12)}"
          aweight = "Weight: #{(pounds / 10.0)} lbs."
        else
          aheight = "Height: #{(height / 10.0)} m"
          aweight = "Weight: #{(weight / 10.0)} kg"
        end
   growthrate = "Growth Rate: #{species_data.growth_rate}"
   catch_rate = "Catch Rate: #{species_data.catch_rate}"
   habitat = "Habitat: #{species_data.habitat}"
   gender_ratio = "Ratio: #{species_data.gender_ratio}"
   catch_rate = "Catch Rate: #{species_data.catch_rate}"
  items = "Items: "
   if !species_data.wild_item_common[0].nil?
   items << "#{GameData::Item.try_get(species_data.wild_item_common[0]).name}"
   end
   if !species_data.wild_item_uncommon[0].nil?
   if items!="Items: "
   items << ", "
   end
   items << "#{GameData::Item.try_get(species_data.wild_item_uncommon[0]).name}"
   end
   if !species_data.wild_item_rare[0].nil?
   if items!="Items: "
   items << ", "
   end
   items << "#{GameData::Item.try_get(species_data.wild_item_rare[0]).name}"
   end
   evolutions = "Evolutions:\n"
   species_data.evolutions.each do |evo|
   evolutions << "#{GameData::Species.get(evo[0]).name} - #{evo[1]} #{evo[2]}\n"
   
   end

   abilities = []
   abiltext = "Abilities:\n"
   getAbilityList(species_data).each do |ability|
     abiltext << "#{GameData::Ability.try_get(ability[0]).name}\n"
   end




   create_text(@pkmn_icons2,"height",@pkmn_icons2["dex_icon"].x+110,30,aheight)
   create_text(@pkmn_icons2,"weight",@pkmn_icons2["dex_icon"].x+110,55,aweight)
   create_text(@pkmn_icons2,"growth",@pkmn_icons2["dex_icon"].x+235,30,growthrate)
   create_text(@pkmn_icons2,"catch",@pkmn_icons2["dex_icon"].x+235,55,catch_rate)
   create_text(@pkmn_icons2,"habitat",@pkmn_icons2["dex_icon"].x+170,80,habitat)
   create_text(@pkmn_icons2,"items",@pkmn_icons2["dex_icon"].x+110,110,items)
   create_text(@pkmn_icons2,"evolutions",@pkmn_icons2["dex_icon"].x+110,140,evolutions)
   create_text(@pkmn_icons2,"ability",@pkmn_icons2["dex_icon"].x+255,140,abiltext)


 elsif @selections[3]==2
    base_stats = "Base Stats:\n"
   data = species_data.base_stats.sort
   data.each do |key, val|
    base_stats << "#{GameData::Stat.get(key).name}: #{val}\n"
   end
   evs = "EV Yield:\n"
   data2 = species_data.evs.sort
   data2.each do |key, val|
    evs << "#{GameData::Stat.get(key).name}: #{val}\n"
   end
 
   create_text(@pkmn_icons2,"base_stats",@pkmn_icons2["dex_icon"].x+110,30,base_stats)
   create_text(@pkmn_icons2,"evs",@pkmn_icons2["dex_icon"].x+260,30,evs)
 elsif @selections[3]==3
    base_stats1 = "Moves:"
   create_text(@pkmn_icons2,"moves",@pkmn_icons2["dex_icon"].x+110,30,base_stats1)
 end
 #set_dex_entry(value)
end 
end
end
  def make_move_text
    enc_array, currKey = getEncData
    thespecies = enc_array[@selections[2]]
    base_stats = ""
species_data = GameData::Species.get(thespecies)
   data = species_data.moves
   data.each_with_index do |move,index|
    next if index > @startend[1]
    next if index < @startend[0]
    base_stats << "#{GameData::Move.get(move[1]).name} - Level #{move[0]} \n"
   end
   create_text(@pkmn_icons3,"moves",@pkmn_icons2["dex_icon"].x+120,50,base_stats)
 
  
  
  end
  def num_tasks_completed(species)
    num_completed = 0
      species_id = GameData::Species.try_get(species)&.species
	$player.pokedex.give_tasks(species_id)
    $player.pokedex.tasks[species.name].each do |pokemon_task|
      progress = pokemon_task[:progress]
      task = GameData::Tasks.try_get(pokemon_task[:task])
      task.thresholds.each { |i| num_completed += 1 if progress >= i }
    end

    return num_completed
  end
  def getAbilityList(sp_data)
    ret = []
    sp_data.abilities.each_with_index { |a, i| ret.push([a, i]) if a }
    sp_data.hidden_abilities.each_with_index { |a, i| ret.push([a, i + 2]) if a }
    return ret
  end
def create_text(spritetype,name,x,y,text)
 spritetype[name]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(spritetype[name])
 spritetype[name].viewport=@viewport
 spritetype[name].windowskin=nil
 spritetype[name].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 spritetype[name].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 spritetype[name].x = x
 spritetype[name].y = y
 spritetype[name].width=120
 spritetype[name].height=90
 spritetype[name].text = text
 spritetype[name].resizeToFit(text)




end

def display_task(pokemon_task,i,thespecies)
      task = GameData::Tasks.try_get(pokemon_task[:task])
      # Uses try_get so tasks that do not require a move or item can return nil safely
      move_name = GameData::Move.try_get(pokemon_task[:move_item])&.name
      # move_name ||= pokemon_task[:move_item] unless pokemon_task[:move_item] == "NONE"
      item_name ||= GameData::Item.try_get(pokemon_task[:move_item])&.name
      
 @pkmn_icons2["task#{i}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmn_icons2["task#{i}"])
 @pkmn_icons2["task#{i}"].viewport=@viewport
 @pkmn_icons2["task#{i}"].windowskin=nil
 @pkmn_icons2["task#{i}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @pkmn_icons2["task#{i}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmn_icons2["task#{i}"].x = @pkmn_icons2["dex_icon"].x+110
 @pkmn_icons2["task#{i}"].y = 75+(i*70)
 @pkmn_icons2["task#{i}"].width=120
 @pkmn_icons2["task#{i}"].height=90
 cur_thres=0
 progress = pokemon_task[:progress]
   task.thresholds.each_with_index do |threshold, j|
   next if threshold < progress
   cur_thres = threshold
   break
  end
   finaltext = task.description.gsub("REPLACE", cur_thres.to_s)
   finaltext = finaltext.gsub("PKMN", GameData::Species.get(thespecies).name)
   finaltext = finaltext.gsub("MOVE", move_name) if !move_name.nil?
   finaltext = finaltext.gsub("ITEM", item_name) if !item_name.nil?
   numtasks = progress
   #numtasks = "0#{numtasks}" if numtasks < 10
   @pkmn_icons2["task#{i}"].text = "#{task.name} (#{numtasks}/10):\n #{finaltext}"
 @pkmn_icons2["task#{i}"].resizeToFit("#{task.name} (#{numtasks}/10):\n #{finaltext}")
 


end


def display_maps
 destroy_sidebar_text
 create_map_text
 count = 0
 if @sidebar_text["selection_map-1"].nil?
 @zones_temp.each_with_index do |object, i|
  next if $PokemonGlobal.visitedMaps[object[0]].nil?
 @sidebar_text["selection_map#{count}"].visible=true
 if current_selection==count
  @sprites["selarrow"].x = @sidebar_text["selection_map#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["selection_map#{count}"].y+6
  @sprites["selarrow"].visible = true
 end
 if current_selection==-1
  @sprites["selarrow"].visible = false
 
 end
 count+=1
 end
 @selection_length = count-1
 else
 @sidebar_text["selection_map-1"].visible=true
 
 end
end 
def create_map_text
 return if !@sidebar_text.empty?
 count = 0
 @zones.each_with_index do |zone, i|
  object = zone.maps
  next if $PokemonGlobal.visitedMaps[object[0]].nil?
 @sidebar_text["selection_map#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["selection_map#{count}"])
 @sidebar_text["selection_map#{count}"].viewport=@viewport
 @sidebar_text["selection_map#{count}"].windowskin=nil
 @sidebar_text["selection_map#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["selection_map#{count}"].shadowColor=nil
 @sidebar_text["selection_map#{count}"].contents.font.size = 14
 @sidebar_text["selection_map#{count}"].width=240
 @sidebar_text["selection_map#{count}"].height=90
 @sidebar_text["selection_map#{count}"].x = 10
 @sidebar_text["selection_map#{count}"].y = 40 if count == 0
 @sidebar_text["selection_map#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5

 @sidebar_text["selection_map#{count}"].z=98
 @sidebar_text["selection_map#{count}"].text=pbLoadMapInfos[object[0]].name
 @sidebar_text["selection_map#{count}"].visible=false
 @zones_temp << object
 count+=1
 end
 if count==0

 @sidebar_text["selection_map-1"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["selection_map-1"])
 @sidebar_text["selection_map-1"].viewport=@viewport
 @sidebar_text["selection_map-1"].windowskin=nil
 @sidebar_text["selection_map-1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["selection_map-1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["selection_map-1"].width=240
 @sidebar_text["selection_map-1"].height=90
 @sidebar_text["selection_map-1"].x = 0
 @sidebar_text["selection_map-1"].y = 40 if count == 0
 @sidebar_text["selection_map-1"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5

 @sidebar_text["selection_map-1"].z=98
 @sidebar_text["selection_map-1"].text="[NO MAPS]"
 @sidebar_text["selection_map-1"].visible=false

 end
end

def create_submap_text(map_set)
 return if !@sidebar_text.empty?
 count = 0
 #@submap_types = []
 map_set.each_with_index do |object, i|
  next if $PokemonGlobal.visitedMaps[object].nil?
 @sidebar_text["selection_map#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["selection_map#{count}"])
 @sidebar_text["selection_map#{count}"].viewport=@viewport
 @sidebar_text["selection_map#{count}"].windowskin=nil
 @sidebar_text["selection_map#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["selection_map#{count}"].shadowColor=nil
 @sidebar_text["selection_map#{count}"].width=240
 @sidebar_text["selection_map#{count}"].height=90
 @sidebar_text["selection_map#{count}"].contents.font.size = 14
 @sidebar_text["selection_map#{count}"].x = 10
 @sidebar_text["selection_map#{count}"].y = 40 if count == 0
 @sidebar_text["selection_map#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["selection_map#{count}"].z=98
 @sidebar_text["selection_map#{count}"].text="#{count+1} - #{pbLoadMapInfos[object].name}"
 @sidebar_text["selection_map#{count}"].visible=false
 @submap_types << object
 count+=1
 end




end
def display_sub_maps(map_set)
 destroy_sidebar_text
 create_submap_text(map_set)
 count=0
 map_set.each_with_index do |object, i|
  next if $PokemonGlobal.visitedMaps[object].nil?
 @sidebar_text["selection_map#{count}"].visible=true
 if @selections[1]==count
  
  @sprites["selarrow"].x = @sidebar_text["selection_map#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["selection_map#{count}"].y+6
  @sprites["selarrow"].visible = true
 end
 
 count+=1
 end
 @selection_length = count-1
end 



def destroy_pkmn_icons2
 @pkmn_icons2.keys.each do |key|
  @pkmn_icons2[key].visible=false
  @pkmn_icons2.delete(key)
 end
 @pkmn_icons2={}

end
def destroy_pkmn_icons3
 @pkmn_icons3.keys.each do |key|
  @pkmn_icons3[key].visible=false
  @pkmn_icons3.delete(key)
 end
 @pkmn_icons3={}

end





def load_new_encounter_data(mapid,force=false)
	 newEncData = GameData::Encounter.get(mapid, $PokemonGlobal.encounter_version)
	 return if newEncData== @encounter_data && force==false
	 
    destroy_pkmn_icons
	@pkmn_icons = {}
    @encounter_data = newEncData
 if @encounter_data
      @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
      @max_enc, @eLength = getMaxEncounters(@encounter_tables)
 else
      @max_enc, @eLength = [0, 0]
 end
 @max_enc.times do |i|
   @pkmn_icons["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
   
   @pkmn_icons["icon_#{i}"].x = 190 + 64*(i%5)
   @pkmn_icons["icon_#{i}"].y = 190 + (i/5)*64
   @pkmn_icons["icon_#{i}"].visible = false
   @pkmn_icons["icon_#{i}"].z = 2
 end
 @pkmn_icons["EncounterType"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmn_icons["EncounterType"])
 @pkmn_icons["EncounterType"].viewport=@viewport
 @pkmn_icons["EncounterType"].windowskin=nil
 @pkmn_icons["EncounterType"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @pkmn_icons["EncounterType"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmn_icons["EncounterType"].width=240
 @pkmn_icons["EncounterType"].height=90
 @pkmn_icons["EncounterType"].x = @rightmost-200
 @pkmn_icons["EncounterType"].y = 23

 @pkmn_icons["map"] = Sprite.new(@viewport)
 @pkmn_icons["map"].bitmap = createMinimap(mapid)
 @pkmn_icons["map"].visible = true
 @pkmn_icons["map"].x = @rightmost-240
 @pkmn_icons["map"].y = 50
 @pkmn_icons["map"].zoom_x = 0.75
 @pkmn_icons["map"].zoom_y = 0.75
 @pkmn_icons["map"].z=0
	drawMons
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


  def getEncData
    currKey = @encounter_tables.keys[@index]
    arr = []
    enc_array = []
	loop do
	if currKey.nil?
	 @index-=1
    currKey = @encounter_tables.keys[@index]
	 break if !currKey.nil?
	else
	break
	end
	end
    @encounter_tables[currKey].each { |s| arr.push( s[1] ) }
    GameData::Species.each { |s| enc_array.push(s.id) if arr.include?(s.id) } # From Maruno
    enc_array.uniq!
    return enc_array, currKey
  end
  
  
  
  
   def drawMons
       enc_array, currKey = getEncData
    i = 0
    name = USER_DEFINED_NAMES ? USER_DEFINED_NAMES[currKey] : GameData::EncounterType.get(currKey).real_name
    @pkmn_icons["EncounterType"].text = name
    enc_array.each do |s|
     next if @pkmn_icons["icon_#{i}"].nil?
      species_data = GameData::Species.get(s)
      if (!$player.pokedex.owned?(s) && !seen_form_any_gender?(s,species_data.form) && !$player.is_it_this_class?(:EXPERT))
        @pkmn_icons["icon_#{i}"].pbSetParams(0,0,0,false)
        @pkmn_icons["icon_#{i}"].tone = Tone.new(0,0,0,255)
        @pkmn_icons["icon_#{i}"].visible = true
      elsif !$player.pokedex.owned?(s)
        @pkmn_icons["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @pkmn_icons["icon_#{i}"].tone = Tone.new(0,0,0,255)
        @pkmn_icons["icon_#{i}"].visible = true
      else
        @pkmn_icons["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @pkmn_icons["icon_#{i}"].tone = Tone.new(0,0,0,0)
        @pkmn_icons["icon_#{i}"].visible = true
      end
      i += 1
    end
   @display_length = i
   
    
   end





  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end



end

class PlayerJournal
def draw_recipe_types
    display_crafting if (@depth==-1 || @depth==0)
	@the_recipes = [] if (@depth==-1 || @depth==0)
    if  @selection!=-1 && (@depth==1)
	craft_type = @recipe_types[@selections[0]]
	display_craft_type(@recipes[craft_type])
	recipe_index = current_selection + @startend[0]
	@recipe = @the_recipes[recipe_index]
	return if @recipe.nil?
	load_new_recipe_data(@recipe)
   end
end
def display_crafting
 destroy_sidebar_text
 create_crafting_text
 count = 0
 @recipe_types.each_with_index do |object, i|
 @sidebar_text["craft#{count}"].visible=true
 if current_selection==i
  @sprites["selarrow"].x = @sidebar_text["craft#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["craft#{count}"].y+6
  @sprites["selarrow"].visible = true
 end
 if current_selection==-1
  @sprites["selarrow"].visible = false
 
 end
 count+=1
 end
 @selection_length = count-1
end 



def create_crafting_text
 return if !@sidebar_text.empty?
 count = 0
 @recipe_types.each_with_index do |object, i|
 @sidebar_text["craft#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["craft#{count}"])
 @sidebar_text["craft#{count}"].viewport=@viewport
 @sidebar_text["craft#{count}"].windowskin=nil
 @sidebar_text["craft#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["craft#{count}"].shadowColor=nil
 @sidebar_text["craft#{count}"].contents.font.size = 14 
 @sidebar_text["craft#{count}"].width=240
 @sidebar_text["craft#{count}"].height=90
 @sidebar_text["craft#{count}"].x = 10
 @sidebar_text["craft#{count}"].y = 40 if count == 0
 @sidebar_text["craft#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["craft#{count}"].z=98
 header = CRAFTING_TYPES[object]
 header = "Item" if header.nil?
 @sidebar_text["craft#{count}"].text=header
 @sidebar_text["craft#{count}"].visible=false
 
 count+=1
 end




end


def create_craft_type_text(text_set)
 #puts "Return? #{!@sidebar_text.empty?}"
 return if !@sidebar_text.empty?
 count = 0
 #@submap_types = []
 text_set.each_with_index do |object, i|
 @the_recipes << object
    next if i > @startend[1]
    next if i < @startend[0]
 @sidebar_text["selection_craft#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["selection_craft#{count}"])
 @sidebar_text["selection_craft#{count}"].viewport=@viewport
 @sidebar_text["selection_craft#{count}"].windowskin=nil
 @sidebar_text["selection_craft#{count}"].contents.font.size = 14
 @sidebar_text["selection_craft#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["selection_craft#{count}"].shadowColor=nil
 @sidebar_text["selection_craft#{count}"].width=240
 @sidebar_text["selection_craft#{count}"].height=90
 @sidebar_text["selection_craft#{count}"].x = 10
 @sidebar_text["selection_craft#{count}"].y = 40 if count == 0
 @sidebar_text["selection_craft#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["selection_craft#{count}"].z=98
 @sidebar_text["selection_craft#{count}"].text="#{i+1} - #{GameData::Item.get(object.results).name}"
 @sidebar_text["selection_craft#{count}"].visible=false
 count+=1
 end




end
def display_craft_type(crafts)
 #destroy_sidebar_text
 #puts "CRAFT TYPE DEPTH #{@depth}"
 create_craft_type_text(crafts)
 count=0
 crafts.each_with_index do |object, i|
    next if i > @startend[1]
    next if i < @startend[0]
 @sidebar_text["selection_craft#{count}"].visible=true
 if current_selection==count
  @sprites["selarrow"].x = @sidebar_text["selection_craft#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["selection_craft#{count}"].y+6
  @sprites["selarrow"].visible = true
 end
 
 count+=1
 end
 @selection_length = count-1
end 
 


 
def load_new_recipe_data(recipe,force=false)
   return if !@recipe_icons["EncounterType"].nil?
	 
   # destroy_recipe_icons
	#@recipe_icons = {}
    recipe
    result = GameData::Item.get(recipe.results)
	item_recipe = recipe.recipe
	
	
	
	
	
	 case item_recipe.length
	  when 1
	   fx = 267
	  when 2
	   fx = 187
	  when 3
	   fx = 175
	  when 4
	   fx = 165
	  when 5
	   fx = 135
	  else
	   fx = 64
	 end

	 case item_recipe.length
	  when 1
	   rate = 64
	  when 2
	   rate = 88
	  when 3
	   rate = 80
	  when 4
	   rate = 88
	  when 5
	   rate = 64
	   else
	   rate = 64
	 end
	
 item_recipe.each_with_index do |array,i|
	if array.is_a? Array
	 amount = array[1]
	 item = array[0]
	else
	 amount = 1
	end
   @recipe_icons["icon_#{i}"] = IconSprite.new(0,0,@viewport)
   @recipe_icons["icon_#{i}"].setBitmap(GameData::Item.icon_filename(item))
   @recipe_icons["icon_#{i}"].x = fx + (rate*(i+1))
   @recipe_icons["icon_#{i}"].y = 170 + (i/6)*rate
   @recipe_icons["icon_#{i}"].z = 2
   @recipe_icons["box#{i}"]=IconSprite.new(@recipe_icons["icon_#{i}"].x,170 + (i/6)*rate,@viewport)
   @recipe_icons["box#{i}"].setBitmap("Graphics/Pictures/craftingMenu/bgBox")
   @recipe_icons["box#{i}"].z= 1
 @recipe_icons["item#{i}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@recipe_icons["item#{i}"])
 @recipe_icons["item#{i}"].viewport=@viewport
 @recipe_icons["item#{i}"].windowskin=nil
 @recipe_icons["item#{i}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @recipe_icons["item#{i}"].contents.font.size = 14
 @recipe_icons["item#{i}"].shadowColor=nil
 @recipe_icons["item#{i}"].width=240
 @recipe_icons["item#{i}"].height=90
 name = GameData::Item.get(item).name_short
 name = "Iron Bar" if name == "Fine Iron Bar" && item_recipe.length==5
 name = "Plank" if name == "Wooden Plank" && item_recipe.length==5
 text_width = @recipe_icons["item#{i}"].contents.text_size("#{name} x#{amount}").width
 @recipe_icons["item#{i}"].x = fx + 8 + (rate*(i+1)) - (text_width / 2)
 @recipe_icons["item#{i}"].y = 200 + (i/6)*rate
 @recipe_icons["item#{i}"].text = "#{name} x#{amount}"
 @recipe_icons["item#{i}"].resizeToFit("#{name} x#{amount}")
 end
 @recipe_icons["EncounterType"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@recipe_icons["EncounterType"])
 @recipe_icons["EncounterType"].viewport=@viewport
 @recipe_icons["EncounterType"].windowskin=nil
 @recipe_icons["EncounterType"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @recipe_icons["EncounterType"].shadowColor=nil
 @recipe_icons["EncounterType"].width=240
 @recipe_icons["EncounterType"].height=90
 text_width = @recipe_icons["EncounterType"].contents.text_size(result.name).width
 @recipe_icons["EncounterType"].x = @rightmost-176-(text_width/2)
 @recipe_icons["EncounterType"].y = 23
 @recipe_icons["EncounterType"].text=result.name
 @recipe_icons["CraftingStation"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@recipe_icons["CraftingStation"])
 @recipe_icons["CraftingStation"].viewport=@viewport
 @recipe_icons["CraftingStation"].windowskin=nil
 @recipe_icons["CraftingStation"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @recipe_icons["CraftingStation"].contents.font.size = 14
 @recipe_icons["CraftingStation"].shadowColor=nil
 @recipe_icons["CraftingStation"].width=240
 @recipe_icons["CraftingStation"].height=90
 station_text = get_stations(recipe)
 text_width = @recipe_icons["CraftingStation"].contents.text_size(station_text).width
 @recipe_icons["CraftingStation"].x = @rightmost-176-(text_width/2)
 @recipe_icons["CraftingStation"].y = @bottommost - 50
 #puts station_text
 @recipe_icons["CraftingStation"].setTextToFit(station_text)




end

def get_stations(recipe)
  text = ""
 recipe.station.each_with_index do |station, index|
   text += ", " if index!=0
   if station == :POCKET
   text += "Inventory"
   else
   text += GameData::Item.get(station).name
   end 
 end 
  return text 
end 

end 

class PlayerJournal
def destroy_sidebar_text
 @sidebar_text&.keys.each do |key|
  @sidebar_text[key].visible=false
  @sidebar_text.delete(key)
 end
  @sprites["selarrow"].visible = false
 @sidebar_text={}


end
def destroy_pkmn_icons
 @pkmn_icons&.keys.each do |key|
  @pkmn_icons[key].visible=false
  @pkmn_icons.delete(key)
 end
 @pkmn_icons={}

end
def destroy_note_content
 @note_text&.keys.each do |key|
  @note_text[key].visible=false
  @note_text.delete(key)
 end
 @note_text={}


end
def destroy_recipe_icons
 @recipe_icons.keys.each do |key|
  @recipe_icons[key].visible=false
  @recipe_icons.delete(key)
 end
 @recipe_icons={}

end


def destroy_player

 @player_icons&.keys.each do |key|
  @player_icons[key].visible=false
  @player_icons.delete(key)
 end
 @player_icons={}


end



 def reset_variables(reset_depth = true)
  @selections = [-1, -1, -1, -1]

  if reset_depth
    @depth = -1
  else
    @selections[2] = 0
  end

  @index = 0
  @mapid = 0
  @encounter_data = nil

  @sprites["selector"].visible = false
  @sprites["selarrow"].visible = false
 end

def current_selection
  @selections[@depth]
end
def move_selection(amount, max)
  return if @depth < 0 || max < 0
  @selections[@depth] += amount
  @selections[@depth] = max if @selections[@depth] < 0
  @selections[@depth] = 0 if @selections[@depth] > max
end
def notes_up
  move_selection(-1, @notes.length)
  destroy_note_content
end

def notes_down
  move_selection(1, @notes.length)
  destroy_note_content
end
def research_down
  
  case @depth
  when 0
    destroy_current_page
    move_zone_selection(1)
  when 1
    destroy_current_page
    move_encounter_selection(1)
  when 2
    destroy_research_icons
    move_species_selection(:down)
  when 3
 #   move_species_detail(1)
  end
end
def research_up
  
  case @depth
  when 0
    destroy_current_page
    move_zone_selection(-1)
  when 1
    destroy_current_page
    move_encounter_selection(-1)
  when 2
    destroy_research_icons
    move_species_selection(:up)
  when 3
  #  move_species_detail(-1)
  end
end
def research_left
  case @depth
  when 1
    change_encounter_type(-1)
  when 2
    move_species_selection(:left)
  when 3
    destroy_research_icons
    move_selection(-1, SPECIES_PAGES_LENGTH)
  end
end

def research_right
  case @depth
  when 1
    change_encounter_type(1)
  when 2
    move_species_selection(:right)
  when 3
    destroy_research_icons
    move_selection(1, SPECIES_PAGES_LENGTH)
  end
end

def move_research_page(amt)


end 

def recipes_left
  return
end

def recipes_right
  return
end
 def change_page(amount)
  destroy_current_page
  @cur_page += amount
  @cur_page = 3 if @cur_page < 0
  @cur_page = 0 if @cur_page > 3

  reset_variables
  pbSEPlay("page2", 50)
 end
 
 def handle_delete
  pbSEPlay("page", 50)
  case @cur_page
  when 1
    notes_delete
  when 2
  when 3
  end
 
 
 end
 
 def notes_delete
  if current_selection > 0
    note = @notes[current_selection - 1]
      if note.is_a?(Mail)
	   if pbConfirmMessage(_INTL("Are you sure you want to delete '#{note.matter}'?"))
	    deleted = current_selection
	    $PokemonGlobal.notebook.delete(note)
        @notes = $PokemonGlobal.notebook + $PokemonGlobal.notestorage + getAllTips
		if deleted > @notes.length - 1
          @selections[@depth] = @notes.length - 1
		end
		destroy_sidebar_text
	   end 
      end
  end

 end
 def handle_left
  if @depth == -1
    change_page(-1)
  else
    current_page_left
  end
 end
 def handle_right
  if @depth == -1
    change_page(1)
  else
    current_page_right
  end
 end
 def handle_up
  pbSEPlay("page2", 50) if @depth>=0
  case @cur_page
  when 0
    player_up
  when 1
    notes_up
  when 2
    recipes_up
  when 3
    research_up
  end
 end
 def handle_down
  pbSEPlay("page2", 50) if @depth>=0
  case @cur_page
  when 0
    player_down
  when 1
    notes_down
  when 2
    recipes_down
  when 3
    research_down
  end
 end
def current_page_left
  case @cur_page
  when 2
    recipes_left
    pbSEPlay("page2", 50)
  when 3
    research_left
    pbSEPlay("page2", 50)
  end
end
def player_up
  move_selection(-1, @player_length - 1)
end
def player_down
  move_selection(1, @player_length- 1)
end
def current_page_right
  case @cur_page
  when 2
    recipes_right
    pbSEPlay("page2", 50)
  when 3
    research_right
    pbSEPlay("page2", 50)
  end
end



def handle_back
  pbSEPlay("page", 50)

  if @depth >= 0
    destroy_current_page
    @selections[@depth] = -1 if @depth >= 0
    @depth -= 1
   @startend = [0,13]
  else
    destroy_current_page
	@end = true 
  end
end
def handle_use
  return if @cur_page==0

  case @cur_page
  when 1
    notes_enter
  pbSEPlay("page2", 50) if @depth < 2
	@depth += 1 if @depth < 2
  when 2
    recipes_enter
  pbSEPlay("page2", 50) if @depth < 1
    @depth += 1 if @depth < 1
  when 3
    research_enter
    pbSEPlay("page2", 50) if @depth < 3
    @depth += 1 if @depth < 3
  end
  @selections[@depth] = 0 if @selections[@depth] == -1
end



def change_encounter_type(amount)
  return unless @cur_page == 3
  return unless @depth == 1

  @index += amount

  @index = @eLength if @index < 0
  @index = 0 if @index >= @eLength

  load_new_encounter_data(@mapid, true) if @mapid != 0
end
def recipes_up
  destroy_current_page
  case @depth
  when 0
    move_selection(-1, @recipe_types.length - 1)
    when 1, 2
    type = @recipe_types[@selections[0]]
    list = @recipes[type]
    if current_selection - 1 < 0 && @startend[0] - 1 < 0
	 # puts @selection_length
      @selections[@depth] = 8
      @startend[0] = list.length - 10
      @startend[1] = list.length - 2
    else
      if current_selection + @startend[0] == @startend[0]
        @startend[0] -= 1 if @startend[0] - 1 >= 0
        @selections[@depth] = 0
      else
        @selections[@depth] -= 1
      end

      @startend[1] -= 1 if @startend[1] - 1 > 7 &&
        current_selection + @startend[0] == @startend[0] &&
        @startend[1] - 1 > @startend[0] + 13
    end


  end
end

def recipes_down
  destroy_current_page
  case @depth
  when 0
    move_selection(1, @recipe_types.length - 1)
  when 1, 2 
  
    type = @recipe_types[@selections[0]]
    list = @recipes[type]
    if current_selection + 1 > @selection_length
      @selections[@depth] = 0
      @startend = [0, 13]
    else
      @startend[0] += 1 if @startend[0] + 1 < list.length - 9

      if !(@startend[0] + 1 < list.length - 9)
        @selections[@depth] += 1
      else
        @selections[@depth] = 0
      end

      @startend[1] += 1 if @startend[1] + 1 < list.length - 1
    end
  end
  
end

def current_encounter
  map = @zones[@selections[0]].maps[@selections[1]]
  encounters, = getEncData
  encounters
end

def move_zone_selection(amount)
  move_selection(amount, @zones[@selections[0]].maps.length - 1)
end

def move_encounter_selection(amount)
  map = @zones[@selections[0]].maps[@selections[1]]
  encounters, = getEncData

  move_selection(amount, encounters.length - 1)
end

def move_species_selection(direction)
  encounter = current_encounter
  current = @selections[2]
  columns = 5
  row = current / columns
  col = current % columns

  case direction
  when :left
    col -= 1
  when :right
    col += 1
  when :up
    row -= 1
  when :down
    row += 1
  end

  return if row < 0 || col < 0

  target = row * columns + col

  return if target >= encounter.length

  @selections[2] = target
end

def move_species_detail(amount)
  return 
  # Whatever detail list you are displaying:
  # moves, abilities, forms, etc.
  move_selection(amount, @detail_length - 1)
end
def recipes_enter
  destroy_current_page
  case @depth
  when 0
    @selections[1] = -1
  when 1
    @selections[2] = -1
  end
end

def research_enter
 # destroy_current_page
  case @depth
  when 0
 #   @selections[1] = -1
  when 1
 #   @selections[2] = -1
   # @depth -= 1
  when 2
  #  @selections[3] = -1
  when 3
  end
end

def notes_enter
  if current_selection == 0
    writeNote
    @notes = $PokemonGlobal.notebook + $PokemonGlobal.notestorage + getAllTips
	destroy_sidebar_text
   @depth -= 1
  elsif current_selection > 0
    note = @notes[current_selection - 1]

    pbFadeOutIn do
      if note.is_a?(Mail)
        pbDisplayNote(note)
      elsif note.is_a?(Symbol)
        isthisAGroup(note) ? pbShowTipCardsGrouped(note) : pbShowTipCard(note)
      end
    end
  @depth -= 1
  end
end

def handle_q
  
    destroy_current_page
  if @cur_page == 3 && @depth == 2 && current_selection != -1
    handle_previous_subtype
  else
    change_page(-1)
  end 

end 

def handle_e
   
    destroy_current_page
  if @cur_page == 3 && @depth == 2 && current_selection != -1
    handle_next_subtype
  else
    change_page(1)
  end 
end 
 def handle_input
  return handle_back if Input.trigger?(Input::BACK)
  return handle_use if Input.trigger?(Input::USE)
  return handle_delete if Input.triggerex?(:DELETE)

  if Input.triggerex?(:Q)
    handle_q
  elsif Input.triggerex?(:E)
    handle_e
  elsif Input.trigger?(Input::LEFT)
    handle_left
  elsif Input.trigger?(Input::RIGHT)
    handle_right
  elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
    handle_up
  elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
    handle_down
  end
 end

def handle_previous_subtype
  return unless @cur_page == 3
  return unless @depth == 2
  return unless current_selection != -1

  pbSEPlay("page2", 50)

  @index -= 1
  @index = @eLength if @index <= -1

  @selections[2] = 0

  load_new_encounter_data(@mapid, true) if @mapid != 0
end

def handle_next_subtype
  return unless @cur_page == 3
  return unless @depth == 2
  return unless current_selection != -1

  pbSEPlay("page2", 50)

  @index += 1
  @index = 0 if @index >= @eLength

  @selections[2] = 0

  load_new_encounter_data(@mapid, true) if @mapid != 0
end

def change_species_form(amount)
  return unless @cur_page == 3
  return unless @depth == 2
  enc_array, currKey = getEncData
  encounter_pokemon = enc_array[@selections[2]]
  species = GameData::Species.get(encounter_pokemon)
  if $player.pokedex.owned?(encounter_pokemon) && seen_form_any_gender?(encounter_pokemon, species.form)
   @selections[3] += amount
   @selections[3] = 3 if @selections[3]-1 < 0
   @selections[3] = 0 if @selections[3]+1 >= 4
  end
end
end 