

module NoteOpen  
  def self.openWindow
#  $DiscordRPC.details = "Cooking a Tasty Meal!"
#  $DiscordRPC.update
  $game_temp.in_menu=true
  craftScene=PlayerNotebook.new
  craftScene.pbStartScene
  craft=craftScene.pbSelectMenu
  craftScene.pbEndScene
  $game_temp.in_menu=false
 end
end


class PlayerNotebook
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



def resetvariables(depth=true)
 @selection = -1 if @depth==true
 @selection = -1 if @depth==false
 @selection2 = -1 
 @selection3 = -1 if @depth==true
 @selection3 = 0 if @depth==false
 @depth = -1 if @depth==true
 @index = 0
 @mapid = 0
 @encounter_data = nil
 @sprites["selector"].visible=  false
 @sprites["selarrow"].visible=  false
end


def pbStartScene
 @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
 @viewport.z=99999
 @sprites={}
 @icons={}
 @sidebar_text={}
 @recipeicons={}
 if true
 @pkmnicons={}
 @pkmnicons2={}
 @pkmnicons3={}
 @notetext={}
 @playericons={}
 end
$coal=:COAL
@notessection = $PokemonGlobal.notebook + getAllTips
 if true
 
 end
 if true
 
   
@cooking = CraftsList.getcrafts(:CAULDRON)[1..-1]
@press = CraftsList.getcrafts(:ELECTRICPRESS)[1..-1]
@sewing = CraftsList.getcrafts(:SEWINGMACHINE)[1..-1]
@pocket= CraftsList.getcrafts(:POCKETCRAFTING)[1..-1]
@medicine = CraftsList.getcrafts(:MEDICINEPOT)[1..-1]
@crafting =CraftsList.getcrafts(:CRAFTINGBENCH)[1..-1]
@ucrafting = CraftsList.getcrafts(:UPGRADEDCRAFTINGBENCH)[1..-1]

@pokeball= CraftsList.getcrafts(:APRICORNCRAFTING)[1..-1]

@furnace = CraftsList.getcrafts(:FURNACE)[1..-1]

@grinder = CraftsList.getcrafts(:GRINDER)[1..-1]





 
  @crafting_types = ["Pocket","Crafting","Upgraded","Pokeball","Cauldron","Medicine","Furnace","Grinder","Sewing","Press"]
  @crafting_data = [@pocket, @crafting,@ucrafting,@pokeball,@cooking,@medicine,@furnace,@grinder,@press,@sewing]
 
 
 
 
 
 
 
 end
 @imagepos=[]
 @cur_page = 0
 @selection = -1
 @selection2 = -1
 @selection3 = -1
 @selection4 = -1
 @depth = -1
 @index = 0
 @mapid = 0
 @startend = [0,8]
 @rightmost = Graphics.width
 @bottommost = Graphics.height
 @selection_length = 0
 @selection2_length = 0
	@bar_image = RPG::Cache.picture("Hud/overlay_hp")
	@bar_image2 = RPG::Cache.picture("Hud/overlay_hp2")
 if true
 @temperate_forest = [5,4,243,300,7,349,350,8,9,13,45,54,47,282,44,68,64]
 @temperate_highlands=[16,24,31,19,30,29,28,17]
 @temperate_marsh=[33,34,35,109,26,218,233]
 @deep_marsh=[36,84,86,110,140,44,68]
 @frigid_highlands=[71,72,77,73,78,80,74,85,82]
 @deep_caves=[197,163,211]
 @tropical_coast=[111,130,131,158,138,132,159,142,133,160,161,134]
 @ssglittering=[101,102,103,116,117,118,119,120,121,122,123,125,126,127,128,129,124]
 @temperate_ocean=[48,62,38,39,58,59,57,60,61,53,234,235,236,42,144,137,43,385,387,392,396,397]
 @deep_forest=[200,201,204,202,203,244,205]
 @northern_highlands=[207,208,157,237,238,313,315,311,312,209]
 @western_shores=[205,295,296,308,302,310,307,309]
 @western_temperate=[318,319,320,323,325,326,330,331,327,328,329]
 @western_caves=[332,217,22,2]
 @western_jungle=[338,354,355,356,357]
 @oil_tanker=[141,143]
 @ravine=[81]
 @map_types = [@temperate_forest,@temperate_highlands,@temperate_marsh,@deep_marsh,@frigid_highlands,@deep_caves,@tropical_coast,@ssglittering,@temperate_ocean,@deep_forest,@northern_highlands,@western_shores,@western_temperate,
 @western_caves,@western_jungle,@oil_tanker,@ravine] 
 @map_types_temp=[]
 @submap_types=[]
end




if true
 @sprites["background"]=IconSprite.new(0,0,@viewport)
 @sprites["background"].setBitmap("Graphics/Pictures/notebookbg")
 @sprites["background"].z = 0 
 @encounter_data = nil
    if @encounter_data
      @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
      @max_enc, @eLength = getMaxEncounters(@encounter_tables)
    else
      @max_enc, @eLength = [1, 1]
    end
 4.times do |i|
 @sprites["notebooktab#{i}"]=IconSprite.new(0,0,@viewport)
 @sprites["notebooktab#{i}"].setBitmap("Graphics/Pictures/notebooktabu")
 @sprites["notebooktab#{i}"].x = 211 if i == 0
 @sprites["notebooktab#{i}"].x = 211+((@sprites["notebooktab0"].width-9)*i) if i != 0
 @sprites["notebooktab#{i}"].y = 17
 @sprites["notebooktab#{i}"].z = i+3
 @sprites["notebooktab#{i}"].z = 2 if i == 0
 @sprites["header#{i}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sprites["header#{i}"])
 @sprites["header#{i}"].viewport=@viewport
 @sprites["header#{i}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sprites["header#{i}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sprites["header#{i}"].windowskin=nil
 @sprites["header#{i}"].x = 211 if i == 0
 @sprites["header#{i}"].x = 211+((@sprites["notebooktab0"].width-9)*i) if i != 0
 @sprites["header#{i}"].width=Graphics.width-48
 @sprites["header#{i}"].height=Graphics.height
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
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
 
 @sprites["header0"].text="Player" #stats
 @sprites["header1"].text="Notes"
 @sprites["header1"].x +=7
 @sprites["header2"].text="Recipes"
 #@sprites["header2"].x -=7
 @sprites["header3"].text="Research"
 @sprites["header3"].x -=7
 @max_enc.times do |i|
   @sprites["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
   @sprites["icon_#{i}"].x = 340 + 28 + 64*(i%7)
   @sprites["icon_#{i}"].y = 20 + 100 + (i/7)*64
   @sprites["icon_#{i}"].visible = false
 end
end
 
 @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
 @sprites["overlay"].z = 100
 
 @sprites["selarrow"]=IconSprite.new(0,0,@viewport)
 @sprites["selarrow"].setBitmap("Graphics/Pictures/selarrow")
 @sprites["selarrow"].z = 99
 @sprites["selarrow"].visible = false
 @sprites["selector"]=IconSprite.new(0,0,@viewport)
 @sprites["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
 @sprites["selector"].visible = false
end
def pagechange(dir)
  case dir
   when "left"
      if @depth==-1
          pbSEPlay("page2",50)
 @selection = -1
		  resetvariables
	     if @cur_page>0
           @cur_page-=1
		 elsif @cur_page==0
		   @cur_page=3
		 end
      end
   when "right"
      if @depth==-1
          pbSEPlay("page2",50)
 @selection = -1
		  resetvariables
	     if @cur_page<3
           @cur_page+=1
		 elsif @cur_page==3
		   @cur_page=0
		 end
      end
   when "up"
       if @depth==0 || @depth==1
           pbSEPlay("page2",50)
	    if @selection-1<0
	    @selection=@selection_length
		else
	    @selection-=1
	   
	   end
       end
	    
   when "down"
       if @depth==0 || @depth==1
           pbSEPlay("page2",50)
	    if @selection+1>@selection_length
	    @selection=0
		
		else
	    @selection+=1
	   
	   end

	   end

	    
   when "use"
		 if Input.press?(Input::CTRL) && $DEBUG && Input.pressex?(0x12)
		 openCalendar
		 
		 
		 
		 else
           pbSEPlay("page2",50)
	    @depth+=1 if @depth+1 <4
		 @selection=0 if @selection==-1 && @depth==0
		 
		 
		 
		 end
   when "back"
          pbSEPlay("page",50)
  	    @depth-=1
		 @selection=-1 if @depth==-1
		

  
  end
end

def page4
	   
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
	   if @selection!=-1 && @depth==1
	   elsif @selection!=-1 && @depth==2
          pbSEPlay("page3",50)
       enc_array, currKey = getEncData
		  if @selection2-1>=0
		  @selection2-=1
		  else
		  @selection2=enc_array.length-1
		  end
	   elsif @selection!=-1 && @depth>=3
        enc_array, currKey = getEncData
        thespecies = enc_array[@selection2]
        species_data = GameData::Species.get(thespecies)
	   if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
          pbSEPlay("page3",50)
		  if @selection4-1>=0
		  @selection4-=1
		  else
		  @selection4=3
		  end
destroy_pkmn_icons2
destroy_pkmn_icons3 if !@pkmnicons3.empty?
	    end
	   
	   else
	   pagechange("left")
		end
		
		
      elsif Input.trigger?(Input::RIGHT)
	   if @selection!=-1 && @depth==1
	   elsif @selection!=-1 && @depth==2
          pbSEPlay("page3",50)
       enc_array, currKey = getEncData
		  if @selection2+1 < enc_array.length
		  @selection2+=1 
         else
		  @selection2=0
		  end
	   elsif @selection!=-1 && @depth>=3
	   
        enc_array, currKey = getEncData
        thespecies = enc_array[@selection2]
        species_data = GameData::Species.get(thespecies)
	   if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
          pbSEPlay("page3",50)
		  if @selection4+1 < 4
		  @selection4+=1 
         else
		  @selection4=0
		  end
destroy_pkmn_icons2
destroy_pkmn_icons3 if !@pkmnicons3.empty?
      end


	   else
	   pagechange("right")
        
		end
	  end
	  if Input.triggerex?(:Q)
	   if @selection!=-1 && @depth==2
          pbSEPlay("page2",50)
        @index -= 1 if @index-1>-1
		 @index = @eLength if @index==0
		 @selection2=0
		load_new_encounter_data(@mapid,true) if @mapid!=0 && @selection!=-1 && @depth>=1
	  
	  	 
	  end    
      elsif Input.triggerex?(:E)
	   if @selection!=-1 && @depth==2
	  
          pbSEPlay("page2",50)
        @index += 1 if @index+1<=@eLength
		 @index = 0 if @index==@eLength
		 @selection2=0
		load_new_encounter_data(@mapid,true) if @mapid!=0 && @selection!=-1 && @depth>=1

	  end
		
		
		end
		
		
		
      if Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
	   if @selection!=-1 && @depth>2 && @depth<2
	   elsif @selection!=-1 && @depth>=3 && @selection4==3	
          pbSEPlay("page2",50) if @startend[0]-1>-1
		  destroy_pkmn_icons3 if @startend[0]-1>-1
         @startend[0]-=1 if @startend[0]-1>-1
         @startend[1]-=1 if @startend[1]-1>7

	   elsif @selection!=-1 && @depth==2






		  if @selection2-5>=0
          pbSEPlay("page3",50)
		  @selection2-=5
         elsif @selection2-5 < 0
		 
		 
		 
			if @selection2-10 < 0
			 bonusducks= @display_length-15
			 bonusducks=5+bonusducks
			 bonusducks=5 if @display_length==10 || @display_length==5
			 @selection2 = @selection2+@display_length-bonusducks
			
			else
           @selection2= @selection2-10
			
			end
			
			
			
          if @selection2>@display_length
		   @selection2=@display_length
		   else
          pbSEPlay("page3",50)
		  end 
		  
		  
		  
		  else
		  @selection2=@display_length
		  end
	   


	   elsif @selection!=-1 && @depth==1
          pbSEPlay("page2",50)
	   	    if @selection3-1<0
	    @selection3=@selection_length
		
		
		else
          pbSEPlay("page2",50)
	    @selection3-=1
	   
	   end

	   else
	   pagechange("up")
 end


       elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
	   if @selection!=-1 && @depth>2 && @depth<2
	   
	   elsif @selection!=-1 && @depth>=3 && @selection4==3	
        enc_array, currKey = getEncData
        thespecies = enc_array[@selection2]
        species_data = GameData::Species.get(thespecies)
          pbSEPlay("page2",50) if @startend[0]+1<species_data.moves.length-9
		  destroy_pkmn_icons3 if @startend[0]+1<species_data.moves.length-9
         @startend[0]+=1 if @startend[0]+1<species_data.moves.length-9
         @startend[1]+=1 if @startend[1]+1<species_data.moves.length-1
		 

	   elsif @selection!=-1 && @depth==2



	   length = @display_length-1
		  if @selection2+5 <= length
		  @selection2+=5 
          pbSEPlay("page3",50)
         elsif @selection2+5 > length
			if @selection2-10<0
			 @selection2 = @selection2-10+5
			else
           @selection2= @selection2-10
		   end
          if @selection2<0
		   @selection2=0
		   else
          pbSEPlay("page3",50)
		  end 
		  else
		  @selection2=0
		  end
        


	   elsif @selection!=-1 && @depth==1
          pbSEPlay("page2",50)
	   
	   	if @selection3+1>@selection_length
	    @selection3=0
		
		else
	    @selection3+=1
	   
	   end

	   else
	   pagechange("down")
 
 end
       end







	  if Input.trigger?(Input::USE)
	   if !@map_types_temp.empty?
		if @depth+1==0
		 @selection=0 if @selection==-1
		 
		end
		if (@depth+1==0 || @depth+1==1) && @cur_page==4
		 @selection3=0
		end
       
        pagechange("use")

		if @selection!=-1 && @depth>=3 && @selection4==-1
		  @selection4=0
		end
		if @depth==2 && @cur_page==4
	    @selection2 = 0 if @selection2==-1 
		end

       end
      elsif Input.trigger?(Input::BACK)
		if @depth==3 && @selection2!=-1 && @cur_page==4
		 destroy_pkmn_icons
	    load_new_encounter_data(@mapid,true)
		end
		if @depth==3
		  destroy_pkmn_icons2
		  destroy_pkmn_icons3
		end

		pagechange("back")
		if @depth==0
		 resetvariables(false)
		end
       
		if @selection!=-1 && @depth<=3 && @selection4!=-1
		  @selection4=0
         @startend = [0,8]
		end
   
      end
	  
	  	
		
		
		
		
		
		
	  if Input.trigger?(Input::ACTION)
	  
		if @selection4!=-1 && @cur_page==4 && @depth==3
       enc_array, currKey = getEncData if !@pkmnicons2.empty?
       thespecies = enc_array[@selection2]
	    entry = pbFreeTextNoWindow(pbPokedexEntry(thespecies),false,256,Graphics.width,false)
		pbSetPokedexEntry(thespecies,entry)
		end 
	  
	  
	  
	  
	  end

	  
end



def page2
	   
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
	   if false

	   else
	   pagechange("left")
		end
		
		
      elsif Input.trigger?(Input::RIGHT)
	   if false

	   else
	   pagechange("right")
        
		end
	  end
	  
	  
	  if Input.triggerex?(:Q)

     elsif Input.triggerex?(:E)

	  end

      if Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
	   if (@depth == 1 || @depth == 2) && @selection!=-1
	     
	   
          pbSEPlay("page2",50)
	   	    if @selection3-1<0 && @startend[0]-1<0
	        @selection3=@selection_length
           @startend[0]=@crafting_data[@selection].length-10
           @startend[1]=@crafting_data[@selection].length-2 
		
		
		  else
          pbSEPlay("page2",50)
       @startend[0]-=1 if @startend[0]-1>-1  && @selection!=-1 && (@depth==1 || @depth==2) && @selection3+@startend[0]==@startend[0]

	   @selection3=0 if @selection3+@startend[0]==@startend[0]

	   @selection3-=1 if @selection3+@startend[0]!=@startend[0]
       @startend[1]-=1 if @startend[1]-1>7 && @selection!=-1 && (@depth==1 || @depth==2) && @selection3+@startend[0]==@startend[0] && @startend[1]-1>@startend[0]+8


	   
	   end





	   else
	   pagechange("up")
       end


       elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
	   if @depth == 1 || @depth == 2  && @selection!=-1
	   
          pbSEPlay("page2",50)
	   
	   	if @selection3+1>@selection_length
	    @selection3=0
        @startend = [0,8]
		
		else
       @startend[0]+=1 if @startend[0]+1<@crafting_data[@selection].length-9 && @selection!=-1 && (@depth==1 || @depth==2)
	    @selection3+=1 if !(@startend[0]+1<@crafting_data[@selection].length-9)
	    @selection3=0 if (@startend[0]+1<@crafting_data[@selection].length-9)
       @startend[1]+=1 if @startend[1]+1<@crafting_data[@selection].length-1 && @selection!=-1 && (@depth==1 || @depth==2)

	   end

	   else
	   pagechange("down")
       end
       end

	  if Input.trigger?(Input::USE)
        pagechange("use")
		 @selection3=0 if @selection3==-1
      elsif Input.trigger?(Input::BACK)
	    destroy_recipe_icons
         @startend = [0,8]
		pagechange("back")
      end
	  
	  	
		
		
		
		
		
		
	  if Input.trigger?(Input::ACTION)

	  end

	  


end
def page1

	   
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
	   if false

	   else
	   pagechange("left")
		end
		
		
      elsif Input.trigger?(Input::RIGHT)
	   if false

	   else
	   pagechange("right")
        
		end
	  end
	  
	  
	  if Input.triggerex?(:Q)

     elsif Input.triggerex?(:E)

	  end

      if Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
	   if false
	   else
	   pagechange("up")
       end


       elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
	   if false
	   else
	   pagechange("down")
       end
       end

	  if Input.trigger?(Input::USE)
	    if @selection==0 
		 writeNote
        @notessection = $PokemonGlobal.notebook + getAllTips
		elsif @selection>0
		  note = @notessection[@selection-1]
        pbFadeOutIn {
		   if note.is_a?(Mail)
         pbDisplayMail(note)
		  elsif note.is_a?(Symbol)
           if isthisAGroup(note)
		       pbShowTipCardsGrouped(note)
           else
              pbShowTipCard(note)
           end
		  
		  else
		  end
        
        }
		else
        pagechange("use")
		end
      elsif Input.trigger?(Input::BACK)
		pagechange("back")
      end
	  
	  	
		
		
		
		
		
		
	  if Input.trigger?(Input::ACTION)
	    if @selection>0
		     note = @notessection[@selection-1]
		     if note.is_a?(Mail)
            if pbConfirmMessage(_INTL("The note #{note.matter} will be lost. Is that OK?"))
              pbMessage(_INTL("The note was deleted."))
			    $PokemonGlobal.notebook.delete(note)
              @notessection = $PokemonGlobal.notebook + getAllTips
			   @selection=0
            end
			  end
        end
	  end

	  


end



def page0

	   
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
	   if false

	   else
	   pagechange("left")
		end
		
		
      elsif Input.trigger?(Input::RIGHT)
	   if false

	   else
	   pagechange("right")
        
		end
	  end
	  
	  
	  if Input.triggerex?(:Q)

     elsif Input.triggerex?(:E)

	  end

      if Input.trigger?(Input::UP) || Input.repeat?(Input::DOWN)
	   if false
	   else
	   pagechange("up")
       end


       elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
	   if false
	   else
	   pagechange("down")
       end
       end

	  if Input.trigger?(Input::USE)
        pagechange("use")
      elsif Input.trigger?(Input::BACK)
		pagechange("back")
      end
	  
	  	
		
		
		
		
		
		
	  if Input.trigger?(Input::ACTION)

	  end

	  


end


def pageblank

	   
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
	   if false

	   else
	   pagechange("left")
		end
		
		
      elsif Input.trigger?(Input::RIGHT)
	   if false

	   else
	   pagechange("right")
        
		end
	  end
	  
	  
	  if Input.triggerex?(:Q)

     elsif Input.triggerex?(:E)

	  end

      if Input.trigger?(Input::UP) 
	   if false
	   else
	   pagechange("up")
       end


       elsif Input.trigger?(Input::DOWN)
	   if false
	   else
	   pagechange("down")
       end
       end

	  if Input.trigger?(Input::USE)
        pagechange("use")
      elsif Input.trigger?(Input::BACK)
		pagechange("back")
      end
	  
	  	
		
		
		
		
		
		
	  if Input.trigger?(Input::ACTION)

	  end

	  





end



def pbSelectMenu
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    pbSEPlay("page",50)
 
    while true
    $PokemonGlobal.addNewFrameCount 
     update
    Graphics.update
    Input.update
     if Input.trigger?(Input::BACK)
	  	if @depth==-1
	    destroy_sidebar_text
		 destroy_player
		 destroy_pkmn_icons
		 destroy_note_content
	    break
	   end
	 end

	  case @cur_page
	   when 0
          page0
	   when 1
          page1
	   when 2
          page2
	   when 3
          page4
		  
	  
	  
	 end

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


    playermenu if @cur_page == 0
    statsmenu if @cur_page == 1
    craftingmenu if @cur_page == 2
    researchmenu if @cur_page == 3

  end





   def playermenu
     destroy_sidebar_text
     destroy_pkmn_icons
	 destroy_note_content
	 display_player
   end
   def statsmenu
     destroy_sidebar_text
     destroy_pkmn_icons
	 destroy_player
	 display_notes  if (@depth==-1 || @depth==0)
	 display_note_content if @depth==0
	 if @notetext["cook-1"]
	 @notetext["cook-1"].visible = false if @selection==0
	 end
	 if @notetext["cook-2"]
	 @notetext["cook-2"].visible = false if @selection==0
	 end
   end
   
   
   def craftingmenu
     destroy_sidebar_text
     destroy_pkmn_icons
	 destroy_note_content
	 destroy_player
    display_crafting if (@depth==-1 || @depth==0)
	@the_recipe = [] if (@depth==-1 || @depth==0)
    if  @selection!=-1 && (@depth==1 || @depth==2)
	display_craft_type(@crafting_data[@selection])
	@recipe = @the_recipe[@selection3+@startend[0]]
	return if @recipe.nil?
	load_new_recipe_data(@recipe)
   end
  end
  
  
   def researchmenu
    destroy_sidebar_text
	destroy_note_content
	destroy_player
	@map_types_temp=[] if (@depth==-1 || @depth==0)
    display_maps if (@depth==-1 || @depth==0)
	@submap_types = [] if (@depth==-1 || @depth==0)
	if !@map_types_temp.empty?
    if  @selection!=-1 && (@depth==1 || @depth==2)
	display_sub_maps(@map_types_temp[@selection])
	@selection3=0 if @selection3==-1
	@mapid = @submap_types[@selection3]
	return if @mapid.nil?
	load_new_encounter_data(@mapid)
	@selection2=0 if @selection2==-1
	if @depth==2 && @pkmnicons.key?("icon_#{@selection2}")
       @sprites["selector"].x = @pkmnicons["icon_#{@selection2}"].x+(@sprites["selector"].width/4)-3 if @selection2!=-1 
       @sprites["selector"].y = @pkmnicons["icon_#{@selection2}"].y+@sprites["selector"].width/4 if @selection2!=-1
       @sprites["selector"].z = 99
       @sprites["selector"].visible=true if @sprites["selector"].visible==false
	end





	elsif @depth==0
	destroy_pkmn_icons if !@pkmnicons.empty?
    


	elsif @depth==3 && @selection2!=-1
	destroy_pkmn_icons if !@pkmnicons.empty?
    @sprites["selarrow"].visible = false if @sprites["selarrow"].visible==true
	@sprites["selector"].visible=false if @sprites["selector"].visible==true
	display_species if @pkmnicons2.empty?
	make_move_text if @pkmnicons3.empty? && !@pkmnicons2.empty? && @selection4==3 && @depth==3
    enc_array, currKey = getEncData if !@pkmnicons2.empty?
    thespecies = enc_array[@selection2] if !@pkmnicons2.empty?
	if !@pkmnicons2.empty?
	@pkmnicons2["thedexentry"].text = pbPokedexEntry(thespecies)
   @pkmnicons2["thedexentry"].resizeToFit(pbPokedexEntry(thespecies))
   end
    end
	
	
	
	
	
    @sprites["selector"].visible = false if @depth<2
    @sprites["selarrow"].visible = false if @selection==-1
    @sprites["selarrow"].visible = false if @depth==-1
	end
   end




  def pbEndScene

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
	
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)
	
	$game_temp.notebook_calling=false
    @viewport.dispose
  end









end


class PlayerNotebook
  def display_player
    destroy_player
	create_player
    refresh_player if !@playericons.empty?
	
  end
  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return [Color.new(240,80,32),Color.new(168,48,56)]
    elsif hp<=(totalhp/2.0)
      return [Color.new(250,250,51),Color.new(184,112,0)]
    end
    return [Color.new(24,192,32),Color.new(0,144,0)]
  end
  def refresh_player
  
    
    @playericons["starbarborder"].visible = $player.playerstamina!=nil
    @playericons["bar"].visible = @playericons["starbarborder"].visible
    @playericons["starbarfill"].visible = @playericons["starbarborder"].visible
    @playericons["starbar_bar"].visible = @playericons["starbarborder"].visible
    @playericons["starbar_num"].visible = @playericons["starbarborder"].visible
    @playericons["starbarfill"].bitmap.clear
    fillAmount = ($player.playerstamina==0 || $player.playermaxstamina==0) ? 0 : (
      $player.playerstamina*@playericons["hpbarfill"].bitmap.width/$player.playermaxstamina
    )
	
    return if fillAmount <= 0
    hpColors = Color.new(255,182,66)
    shadowHeight = 2
    @playericons["starbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @playericons["starbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @playericons["starbarfill"].bitmap.height-shadowHeight
      ), hpColors
    )



    @playericons["hpbarborder"].visible = $player.playerhealth!=nil
    @playericons["bar2"].visible = @playericons["hpbarborder"].visible
    @playericons["hpbarfill"].visible = @playericons["hpbarborder"].visible
    @playericons["health_bar"].visible = @playericons["hpbarborder"].visible
    @playericons["health_num"].visible = @playericons["hpbarborder"].visible
    @playericons["hpbarfill"].bitmap.clear
    fillAmount = ($player.playerhealth==0 || $player.playermaxhealth2==0) ? 0 : (
      $player.playerhealth*@playericons["hpbarfill"].bitmap.width/$player.playermaxhealth2
    )
    return if fillAmount <= 0
    hpColors = hpBarCurrentColors($player.playerhealth, $player.playermaxhealth2)
    shadowHeight = 2
    @playericons["hpbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @playericons["hpbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @playericons["hpbarfill"].bitmap.height-shadowHeight
      ), hpColors[0]
    )
  
  end
  def create_player
     if @playericons["trainer"].nil?
    @playericons["trainer"] = IconSprite.new(200,70,@viewport)
    @playericons["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @playericons["trainer"].x = 360
    @playericons["trainer"].y = 40
    @playericons["trainer"].z = 98
    @playericons["trainer"].visible=true
     end
	if $player.playerclass.is_a?(PlayerClass)
	theclass = $player.playerclass.name
	else
	theclass = $player.playerclass
	end



     if @playericons["playerclassname"].nil?
    @playericons["playerclassname"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["playerclassname"])
    @playericons["playerclassname"].viewport=@viewport
    @playericons["playerclassname"].windowskin=nil
    @playericons["playerclassname"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["playerclassname"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["playerclassname"].width=240
    @playericons["playerclassname"].height=90
    @playericons["playerclassname"].x = 390
    @playericons["playerclassname"].y = 178
    @playericons["playerclassname"].z=98
    @playericons["playerclassname"].text="#{theclass} Lv#{$player.playerclasslevel.to_i}"
    @playericons["playerclassname"].resizeToFit("#{theclass} Lv#{$player.playerclasslevel.to_i}")
    @playericons["playerclassname"].visible=true
     end
	
	
     if @playericons["playername1"].nil?
    @playericons["playername1"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["playername1"])
    @playericons["playername1"].viewport=@viewport
    @playericons["playername1"].windowskin=nil
    @playericons["playername1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["playername1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["playername1"].width=240
    @playericons["playername1"].height=90
    @playericons["playername1"].x = 20
    @playericons["playername1"].y = 80
    @playericons["playername1"].z=98
    @playericons["playername1"].text="Property of:"
    @playericons["playername1"].resizeToFit("Property of:")
    @playericons["playername1"].visible=true
     end
	
	
     if @playericons["playername"].nil?
    @playericons["playername"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["playername"])
    @playericons["playername"].viewport=@viewport
    @playericons["playername"].windowskin=nil
    @playericons["playername"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["playername"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["playername"].width=240
    @playericons["playername"].height=90
    @playericons["playername"].x = 35
    @playericons["playername"].y = 110
    @playericons["playername"].z=98
    @playericons["playername"].text=$player.name
    @playericons["playername"].resizeToFit($player.name)
    @playericons["playername"].visible=true
     end
#"Graphics/Pictures/Hud/Heart"
    if true

	sta = $player.playerstamina
	totalsta = $player.playermaxstamina

    width = 90
    height = 8
    fillWidth = width-4
    fillHeight = height-4
	
	







	 
     if @playericons["starbarborder"].nil?
    @playericons["starbarborder"] = BitmapSprite.new(width,height,@viewport)
    @playericons["starbarborder"].x = 310
    @playericons["starbarborder"].y = 90
    @playericons["starbarborder"].z=98
    @playericons["starbarborder"].bitmap.fill_rect(Rect.new(0,0,width,height), Color.new(32,32,32))
    @playericons["starbarborder"].bitmap.fill_rect((width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96))
    @playericons["starbarborder"].visible = false
	
	
    @playericons["starbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @playericons["starbarfill"].x = @playericons["starbarborder"].x+2
    @playericons["starbarfill"].y = @playericons["starbarborder"].y+2
    @playericons["starbarfill"].z=98
    @playericons["starbarfill"].visible = false
     end
	
     if @playericons["bar"].nil?
    @playericons["bar"]=IconSprite.new((@playericons["starbarborder"].x-7),(@playericons["starbarborder"].y-6),@viewport)
    @playericons["bar"].setBitmap("Graphics/Pictures/Hud/Bolt")
    @playericons["bar"].visible = false
    @playericons["bar"].z = 99
     end
	


     if @playericons["starbar_bar"].nil?
    @playericons["starbar_bar"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["starbar_bar"])
    @playericons["starbar_bar"].viewport=@viewport
    @playericons["starbar_bar"].windowskin=nil
    @playericons["starbar_bar"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["starbar_bar"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["starbar_bar"].width=240
    @playericons["starbar_bar"].height=90
    @playericons["starbar_bar"].z=98
    @playericons["starbar_bar"].text="Stamina:"
    @playericons["starbar_bar"].resizeToFit("Stamina:")
    @playericons["starbar_bar"].x = @playericons["starbarborder"].x-100
    @playericons["starbar_bar"].y = @playericons["starbarborder"].y-30
    @playericons["starbar_bar"].visible=false
     end

     if @playericons["starbar_num"].nil?
    @playericons["starbar_num"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["starbar_num"])
    @playericons["starbar_num"].viewport=@viewport
    @playericons["starbar_num"].windowskin=nil
    @playericons["starbar_num"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["starbar_num"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["starbar_num"].width=240
    @playericons["starbar_num"].height=90
    @playericons["starbar_num"].z=98
    @playericons["starbar_num"].text="#{sta.to_i}/#{totalsta.to_i}"
    @playericons["starbar_num"].resizeToFit("#{sta.to_i}/#{totalsta.to_i}")
    @playericons["starbar_num"].zoom_x = 0.8
    @playericons["starbar_num"].zoom_y = 0.8
	# @playericons["starbar_num"].ox = @playericons["starbarborder"].width
    @playericons["starbar_num"].x = @playericons["starbarborder"].x + 65
    @playericons["starbar_num"].y = @playericons["starbarborder"].y + 15
    @playericons["starbar_num"].visible=false
     end
	
	
	
	
	
	
	
	
	
	
	
	
     if @playericons["hpbarborder"].nil?
    @playericons["hpbarborder"] = BitmapSprite.new(width,height,@viewport)
    @playericons["hpbarborder"].x = 310
    @playericons["hpbarborder"].y = 60
    @playericons["hpbarborder"].z=98
    @playericons["hpbarborder"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @playericons["hpbarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @playericons["hpbarborder"].visible = false
     end
	
     if @playericons["bar2"].nil?
    @playericons["bar2"]=IconSprite.new((@playericons["hpbarborder"].x-5),(@playericons["hpbarborder"].y-7),@viewport)
    @playericons["bar2"].setBitmap("Graphics/Pictures/Hud/Heart")
    @playericons["bar2"].visible = false
    @playericons["bar2"].z = 98
     end
	

	
     if @playericons["hpbarfill"].nil?
    @playericons["hpbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @playericons["hpbarfill"].x = @playericons["hpbarborder"].x+2
    @playericons["hpbarfill"].y = @playericons["hpbarborder"].y+2
    @playericons["hpbarfill"].z=98
    @playericons["hpbarfill"].visible = false
     end


	hp = $player.playerhealth
	totalhp = $player.playermaxhealth2

     if @playericons["health_bar"].nil?
    @playericons["health_bar"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["health_bar"])
    @playericons["health_bar"].viewport=@viewport
    @playericons["health_bar"].windowskin=nil
    @playericons["health_bar"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["health_bar"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["health_bar"].width=240
    @playericons["health_bar"].height=90
    @playericons["health_bar"].z=98
    @playericons["health_bar"].text="Health:"
    @playericons["health_bar"].resizeToFit("Health:")
    @playericons["health_bar"].visible=false
    @playericons["health_bar"].x = @playericons["hpbarborder"].x-100
    @playericons["health_bar"].y = @playericons["hpbarborder"].y-30
     end

     if @playericons["health_num"].nil?
    @playericons["health_num"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@playericons["health_num"])
    @playericons["health_num"].viewport=@viewport
    @playericons["health_num"].windowskin=nil
    @playericons["health_num"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @playericons["health_num"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @playericons["health_num"].width=240
    @playericons["health_num"].height=90
    @playericons["health_num"].z=98
    @playericons["health_num"].text="#{hp.to_i}/#{totalhp.to_i}"
    @playericons["health_num"].resizeToFit("#{hp.to_i}/#{totalhp.to_i}")
    @playericons["health_num"].visible=false
    @playericons["health_num"].zoom_x = 0.8
    @playericons["health_num"].zoom_y = 0.8
	# @playericons["health_num"].ox = @playericons["hpbarborder"].width
    @playericons["health_num"].x = @playericons["hpbarborder"].x + 65
    @playericons["health_num"].y = @playericons["hpbarborder"].y + 8
     end



    end


  end
def destroy_player

 @playericons.each_key do |key|
  @playericons[key].visible=false
  @playericons.delete(key)
 end
 @playericons={}


end
end


class PlayerNotebook

def create_species
    if true
       enc_array, currKey = getEncData
   thespecies = enc_array[@selection2]
   @pkmnicons2["dex_icon"]  = PokemonSprite.new(@viewport)
   @pkmnicons2["dex_icon"].setOffset(PictureOrigin::CENTER)
   @pkmnicons2["dex_icon"].x = 80
   @pkmnicons2["dex_icon"].y = 100
   @pkmnicons2["dex_icon"].z = 50
   @pkmnicons2["pkmn_name"]=Window_UnformattedTextPokemon.new("") 
    @pkmnicons2["pkmn_name"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @pkmnicons2["pkmn_name"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 pbPrepareWindow(@pkmnicons2["pkmn_name"])
 @pkmnicons2["pkmn_name"].viewport=@viewport
 @pkmnicons2["pkmn_name"].windowskin=nil
 @pkmnicons2["pkmn_name"].x = @pkmnicons2["dex_icon"].x-45
 @pkmnicons2["pkmn_name"].y = @pkmnicons2["dex_icon"].y+40
 @pkmnicons2["pkmn_name"].z = 51
 
 
      species_data = GameData::Species.get(thespecies)
      if !$player.pokedex.owned?(thespecies) && !seen_form_any_gender?(thespecies,species_data.form) && !$player.is_it_this_class?(:EXPERT)
        @pkmnicons2["dex_icon"].setSpeciesBitmap(nil)
        @pkmnicons2["dex_icon"].zoom_x=0.5
        @pkmnicons2["dex_icon"].zoom_y=0.5
 @pkmnicons2["pkmn_name"].x = @pkmnicons2["pkmn_name"].x+15
        @pkmnicons2["pkmn_name"].text="???"
        @pkmnicons2["pkmn_name"].setTextToFit("???")
      elsif !$player.pokedex.owned?(thespecies)
        @pkmnicons2["dex_icon"].setSpeciesBitmap(thespecies)
        @pkmnicons2["dex_icon"].tone = Tone.new(0,0,0,255)
        @pkmnicons2["pkmn_name"].text=GameData::Species.get(thespecies).name
        @pkmnicons2["pkmn_name"].setTextToFit(GameData::Species.get(thespecies).name)
      else
        @pkmnicons2["dex_icon"].setSpeciesBitmap(thespecies)
        @pkmnicons2["dex_icon"].tone = Tone.new(0,0,0,0)
        @pkmnicons2["pkmn_name"].text=GameData::Species.get(thespecies).name
        @pkmnicons2["pkmn_name"].setTextToFit(GameData::Species.get(thespecies).name)
      end
   end
 @pkmnicons2["background"]=IconSprite.new(0,0,@viewport)
 @pkmnicons2["background"].setBitmap("Graphics/Pictures/notebooksquare")
 @pkmnicons2["background"].z = 1 
 if @pkmnicons2["dexcursor"].nil? && false
 @pkmnicons2["dexcursor"]=IconSprite.new(0,0,@viewport)
 @pkmnicons2["dexcursor"].setBitmap("Graphics/Pictures/selarrowd")
 @pkmnicons2["dexcursor"].x = @pkmnicons2["dex_icon"].x-20
 @pkmnicons2["dexcursor"].y = 195
 @pkmnicons2["dexcursor"].z = 51
 @selection4=0 if @selection4==-1
 end
 if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
species_data.types.each_with_index do |type, i|
 @pkmnicons2["type#{i}"] = IconSprite.new(0,0,@viewport)
 @pkmnicons2["type#{i}"].setBitmap("Graphics/Pictures/ftypes/#{GameData::Type.get(type).name}")
if species_data.types.length != 1
 @pkmnicons2["type#{i}"].x = (@pkmnicons2["pkmn_name"].x-20)+(i*@pkmnicons2["type#{i}"].width)
 @pkmnicons2["type#{i}"].y = (@pkmnicons2["pkmn_name"].y+40)
else
 @pkmnicons2["type#{i}"].x = (@pkmnicons2["pkmn_name"].x+20)+(i*@pkmnicons2["type#{i}"].width)
 @pkmnicons2["type#{i}"].y = (@pkmnicons2["pkmn_name"].y+40)

end
 end
 end
 @pkmnicons2["thedexentry"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmnicons2["thedexentry"])
 @pkmnicons2["thedexentry"].viewport=@viewport
 @pkmnicons2["thedexentry"].windowskin=nil
    @pkmnicons2["thedexentry"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @pkmnicons2["thedexentry"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmnicons2["thedexentry"].x = @pkmnicons2["dex_icon"].x-82

 @pkmnicons2["thedexentry"].y = 195
 @pkmnicons2["thedexentry"].z = 99
 @pkmnicons2["thedexentry"].width=60
 @pkmnicons2["thedexentry"].height=90
 @pkmnicons2["thedexentry"].text = pbPokedexEntry(thespecies)
 @pkmnicons2["thedexentry"].resizeToFit(pbPokedexEntry(thespecies))


end

def display_species
enc_array, currKey = getEncData
thespecies = enc_array[@selection2]
species_data = GameData::Species.get(thespecies)
destroy_pkmn_icons2
create_species
 if !species_data.nil? 
 
 if $player.pokedex.owned?(thespecies) && seen_form_any_gender?(thespecies,species_data.form)
 if @selection4==0
    @visibletasks ||= [0,3]
    tasks = []
	$player.pokedex.give_tasks(thespecies)
 $player.pokedex.tasks[species_data.species.name].each_with_index do |pokemon_task, i| # Tasks by pokemon
      next unless i >= @visibletasks[0] && i <= @visibletasks[1]
      tasks << pokemon_task
 end

 @pkmnicons2["taskheader"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmnicons2["taskheader"])
 @pkmnicons2["taskheader"].viewport=@viewport
 @pkmnicons2["taskheader"].windowskin=nil
    @pkmnicons2["taskheader"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @pkmnicons2["taskheader"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmnicons2["taskheader"].x = @pkmnicons2["dex_icon"].x+100
 @pkmnicons2["taskheader"].y = 40
 @pkmnicons2["taskheader"].width=120
 @pkmnicons2["taskheader"].height=90
   numtasks1 = num_tasks_completed(thespecies)
   @pkmnicons2["taskheader"].text = "TASKS (#{numtasks1}/10):"
 @pkmnicons2["taskheader"].resizeToFit("TASKS (#{numtasks1}/10):")

 tasks.each_with_index do |pokemon_task, i|
	display_task(pokemon_task,i,thespecies)
 end  
 elsif @selection4==1
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




   create_text(@pkmnicons2,"height",@pkmnicons2["dex_icon"].x+110,30,aheight)
   create_text(@pkmnicons2,"weight",@pkmnicons2["dex_icon"].x+110,55,aweight)
   create_text(@pkmnicons2,"growth",@pkmnicons2["dex_icon"].x+235,30,growthrate)
   create_text(@pkmnicons2,"catch",@pkmnicons2["dex_icon"].x+235,55,catch_rate)
   create_text(@pkmnicons2,"habitat",@pkmnicons2["dex_icon"].x+170,80,habitat)
   create_text(@pkmnicons2,"items",@pkmnicons2["dex_icon"].x+110,110,items)
   create_text(@pkmnicons2,"evolutions",@pkmnicons2["dex_icon"].x+110,140,evolutions)
   create_text(@pkmnicons2,"ability",@pkmnicons2["dex_icon"].x+255,140,abiltext)


 elsif @selection4==2
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
 
   create_text(@pkmnicons2,"base_stats",@pkmnicons2["dex_icon"].x+110,30,base_stats)
   create_text(@pkmnicons2,"evs",@pkmnicons2["dex_icon"].x+260,30,evs)
 elsif @selection4==3
    base_stats1 = "Moves:"
   create_text(@pkmnicons2,"moves",@pkmnicons2["dex_icon"].x+110,30,base_stats1)
 end
 #set_dex_entry(value)
end 
end
end
  def make_move_text
    enc_array, currKey = getEncData
    thespecies = enc_array[@selection2]
    base_stats = ""
species_data = GameData::Species.get(thespecies)
   data = species_data.moves
   data.each_with_index do |move,index|
    next if index > @startend[1]
    next if index < @startend[0]
    base_stats << "#{GameData::Move.get(move[1]).name} - Level #{move[0]} \n"
   end
   create_text(@pkmnicons3,"moves",@pkmnicons2["dex_icon"].x+120,50,base_stats)
 
  
  
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
      
 @pkmnicons2["task#{i}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmnicons2["task#{i}"])
 @pkmnicons2["task#{i}"].viewport=@viewport
 @pkmnicons2["task#{i}"].windowskin=nil
 @pkmnicons2["task#{i}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @pkmnicons2["task#{i}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmnicons2["task#{i}"].x = @pkmnicons2["dex_icon"].x+110
 @pkmnicons2["task#{i}"].y = 75+(i*70)
 @pkmnicons2["task#{i}"].width=120
 @pkmnicons2["task#{i}"].height=90
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
   @pkmnicons2["task#{i}"].text = "#{task.name} (#{numtasks}/10):\n #{finaltext}"
 @pkmnicons2["task#{i}"].resizeToFit("#{task.name} (#{numtasks}/10):\n #{finaltext}")
 


end


def display_maps
 destroy_sidebar_text
 create_map_text
 count = 0
 if @sidebar_text["selection_map-1"].nil?
 @map_types_temp.each_with_index do |object, i|
  next if $PokemonGlobal.visitedMaps[object[0]].nil?
 @sidebar_text["selection_map#{count}"].visible=true
 if @selection==count
  @sprites["selarrow"].x = @sidebar_text["selection_map#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["selection_map#{count}"].y+10
  @sprites["selarrow"].visible = true
 end
 if @selection==-1
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
 @map_types.each_with_index do |object, i|
  next if $PokemonGlobal.visitedMaps[object[0]].nil?
 @sidebar_text["selection_map#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["selection_map#{count}"])
 @sidebar_text["selection_map#{count}"].viewport=@viewport
 @sidebar_text["selection_map#{count}"].windowskin=nil
 @sidebar_text["selection_map#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["selection_map#{count}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["selection_map#{count}"].width=240
 @sidebar_text["selection_map#{count}"].height=90
 @sidebar_text["selection_map#{count}"].x = 0
 @sidebar_text["selection_map#{count}"].y = 40 if count == 0
 @sidebar_text["selection_map#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5

 @sidebar_text["selection_map#{count}"].z=98
 @sidebar_text["selection_map#{count}"].text=pbLoadMapInfos[object[0]].name
 @sidebar_text["selection_map#{count}"].visible=false
 @map_types_temp << object
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
 @sidebar_text["selection_map#{count}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["selection_map#{count}"].width=240
 @sidebar_text["selection_map#{count}"].height=90
 @sidebar_text["selection_map#{count}"].x = 0
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
 if @selection3==count
  
  @sprites["selarrow"].x = @sidebar_text["selection_map#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["selection_map#{count}"].y+10
  @sprites["selarrow"].visible = true
 end
 
 count+=1
 end
 @selection_length = count-1
end 



def destroy_sidebar_text
 @sidebar_text.each_key do |key|
  @sidebar_text[key].visible=false
  @sidebar_text.delete(key)
 end
  @sprites["selarrow"].visible = false
 @sidebar_text={}


end
def destroy_pkmn_icons
 @pkmnicons.each_key do |key|
  @pkmnicons[key].visible=false
  @pkmnicons.delete(key)
 end
 @pkmnicons={}

end
def destroy_pkmn_icons2
 @pkmnicons2.each_key do |key|
  @pkmnicons2[key].visible=false
  @pkmnicons2.delete(key)
 end
 @pkmnicons2={}

end
def destroy_pkmn_icons3
 @pkmnicons3.each_key do |key|
  @pkmnicons3[key].visible=false
  @pkmnicons3.delete(key)
 end
 @pkmnicons3={}

end





def load_new_encounter_data(mapid,force=false)
	 newEncData = GameData::Encounter.get(mapid, $PokemonGlobal.encounter_version)
	 return if newEncData== @encounter_data && force==false
	 
    destroy_pkmn_icons
	@pkmnicons = {}
    @encounter_data = newEncData
 if @encounter_data
      @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
      @max_enc, @eLength = getMaxEncounters(@encounter_tables)
 else
      @max_enc, @eLength = [0, 0]
 end
 @max_enc.times do |i|
   @pkmnicons["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
   
   @pkmnicons["icon_#{i}"].x = 190 + 64*(i%5)
   @pkmnicons["icon_#{i}"].y = 190 + (i/5)*64
   @pkmnicons["icon_#{i}"].visible = false
   @pkmnicons["icon_#{i}"].z = 2
 end
 @pkmnicons["EncounterType"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@pkmnicons["EncounterType"])
 @pkmnicons["EncounterType"].viewport=@viewport
 @pkmnicons["EncounterType"].windowskin=nil
 @pkmnicons["EncounterType"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @pkmnicons["EncounterType"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @pkmnicons["EncounterType"].width=240
 @pkmnicons["EncounterType"].height=90
 @pkmnicons["EncounterType"].x = @rightmost-200
 @pkmnicons["EncounterType"].y = 23

 @pkmnicons["map"] = Sprite.new(@viewport)
 @pkmnicons["map"].bitmap = createMinimap(mapid)
 @pkmnicons["map"].visible = true
 @pkmnicons["map"].x = @rightmost-240
 @pkmnicons["map"].y = 50
 @pkmnicons["map"].zoom_x = 0.75
 @pkmnicons["map"].zoom_y = 0.75
 @pkmnicons["map"].z=0
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
    @pkmnicons["EncounterType"].text = name
    enc_array.each do |s|
     next if @pkmnicons["icon_#{i}"].nil?
      species_data = GameData::Species.get(s)
      if (!$player.pokedex.owned?(s) && !seen_form_any_gender?(s,species_data.form) && !$player.is_it_this_class?(:EXPERT))
        @pkmnicons["icon_#{i}"].pbSetParams(0,0,0,false)
        @pkmnicons["icon_#{i}"].tone = Tone.new(0,0,0,255)
        @pkmnicons["icon_#{i}"].visible = true
      elsif !$player.pokedex.owned?(s)
        @pkmnicons["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @pkmnicons["icon_#{i}"].tone = Tone.new(0,0,0,255)
        @pkmnicons["icon_#{i}"].visible = true
      else
        @pkmnicons["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @pkmnicons["icon_#{i}"].tone = Tone.new(0,0,0,0)
        @pkmnicons["icon_#{i}"].visible = true
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

class PlayerNotebook
def display_notes
 destroy_sidebar_text
 create_notes_text
 count = 0
 @sidebar_text["cook-1"].visible=true

 @notessection.each_with_index do |mail, i|
 @sidebar_text["cook#{count}"].visible=true
 if @selection==count+1
  @sprites["selarrow"].x = @sidebar_text["cook#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["cook#{count}"].y+10
  @sprites["selarrow"].visible = true
 end
 count+=1
 end
 
 
 
 
 
 
 if @selection==0
  @sprites["selarrow"].x = @sidebar_text["cook-1"].x
  @sprites["selarrow"].y = @sidebar_text["cook-1"].y+10
  @sprites["selarrow"].visible = true
 
 end
 
 if @selection==-1
  @sprites["selarrow"].visible = false
 
 end
 @selection_length = count
end 

def create_notes_text
 return if !@sidebar_text.empty?
 @sidebar_text["cook-1"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["cook-1"])
 @sidebar_text["cook-1"].viewport=@viewport
 @sidebar_text["cook-1"].windowskin=nil
 @sidebar_text["cook-1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["cook-1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["cook-1"].width=240
 @sidebar_text["cook-1"].height=90
 @sidebar_text["cook-1"].x = 0
 @sidebar_text["cook-1"].y = 40
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["cook-1"].z=98
 @sidebar_text["cook-1"].text="[NEW NOTE]"
 @sidebar_text["cook-1"].visible=false
 
 count = 0
 @notessection.each_with_index do |note, i|
 @sidebar_text["cook#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["cook#{count}"])
 @sidebar_text["cook#{count}"].viewport=@viewport
 @sidebar_text["cook#{count}"].windowskin=nil
 @sidebar_text["cook#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["cook#{count}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["cook#{count}"].width=240
 @sidebar_text["cook#{count}"].height=90
 @sidebar_text["cook#{count}"].x = 0
 @sidebar_text["cook#{count}"].y = 65 if count == 0
 @sidebar_text["cook#{count}"].y = 65+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["cook#{count}"].z=98
  if note.is_a?(Symbol)
   if isthisAGroup(note)
     thegroup = Settings::TIP_CARDS_GROUPS[note]
     @sidebar_text["cook#{count}"].text = thegroup[:Title]
   else
     thetip = $PokemonGlobal.tipcards[note]
     @sidebar_text["cook#{count}"].text = thetip[:Title]
   end
  elsif note.is_a?(Mail)
 @sidebar_text["cook#{count}"].text=note.matter
  else
 @sidebar_text["cook#{count}"].text="ERROR"
  end
 @sidebar_text["cook#{count}"].visible=false

 
 count+=1
 end




end

def display_note_content
 destroy_note_content
 create_note_content if @selection>0
 @notetext["cook-1"].visible = true if @selection>0
 @notetext["cook-2"].visible = true if @selection>0
end
def create_note_content
 return if !@notetext.empty?
 return if @notessection[@selection-1].nil?
 note = @notessection[@selection-1]
 @notetext["cook-1"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@notetext["cook-1"])
 @notetext["cook-1"].viewport=@viewport
 @notetext["cook-1"].windowskin=nil
 @notetext["cook-1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @notetext["cook-1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @notetext["cook-1"].width=240
 @notetext["cook-1"].height=90
 @notetext["cook-1"].x = 190
 @notetext["cook-1"].y = 40
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @notetext["cook-1"].z=98
  if note.is_a?(Symbol)
   if isthisAGroup(note)
     thegroup = Settings::TIP_CARDS_GROUPS[note]
     topic = thegroup[:Title]
   else
     thetip = $PokemonGlobal.tipcards[note]
     topic = thetip[:Title]
   end
  elsif note.is_a?(Mail)
     topic = "#{note.matter} - #{note.date_created}"
  else
     topic = "ERROR"
  end
 @notetext["cook-1"].text="Topic: #{topic}"
 @notetext["cook-1"].resizeToFit("Topic: #{topic}")
 @notetext["cook-1"].visible=false
 
 
 
 
 
 @notetext["cook-2"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@notetext["cook-2"])
 @notetext["cook-2"].viewport=@viewport
 @notetext["cook-2"].windowskin=nil
 @notetext["cook-2"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @notetext["cook-2"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @notetext["cook-2"].width=240
 @notetext["cook-2"].height=90
 @notetext["cook-2"].x = 190
 @notetext["cook-2"].y = 70
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @notetext["cook-2"].z=98
  if note.is_a?(Symbol)
   if isthisAGroup(note)
     thegroup = Settings::TIP_CARDS_GROUPS[note]
     contents = "This is a Tutorial Group, so it cannot be \ndisplayed, press USE to view."
   else
     thetip = $PokemonGlobal.tipcards[note]
     contents = thetip[:Text]
    if contents.length > 71
     contents = contents.slice(0, 71) 
	  contents += "...\n\nIn order to continue reading, press USE."
	  else
	  contents += "\n\nYou can also press USE to view the Tip itself."
	 end
   end
  elsif note.is_a?(Mail)
     contents = note.message
    if contents.length > 71
     contents = contents.slice(0, 71) 
	  contents += "...\nIn order to continue reading, press USE."
	 end
  else
     topic = "ERROR"
     contents = "This should not occur."
  end
 @notetext["cook-2"].text="Contents:\n#{contents}"
 @notetext["cook-2"].resizeToFit("Contents:\n#{contents}")
 @notetext["cook-2"].visible=false
end
def destroy_note_content
 @notetext.each_key do |key|
  @notetext[key].visible=false
  @notetext.delete(key)
 end
 @notetext={}


end








def display_crafting
 destroy_sidebar_text
 create_crafting_text
 count = 0
 @crafting_types.each_with_index do |object, i|
 @sidebar_text["craft#{count}"].visible=true
 if @selection==i
  @sprites["selarrow"].x = @sidebar_text["craft#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["craft#{count}"].y+10
  @sprites["selarrow"].visible = true
 end
 if @selection==-1
  @sprites["selarrow"].visible = false
 
 end
 count+=1
 end
 @selection_length = count-1
end 

def create_crafting_text
 return if !@sidebar_text.empty?
 count = 0
 @crafting_types.each_with_index do |object, i|
 @sidebar_text["craft#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["craft#{count}"])
 @sidebar_text["craft#{count}"].viewport=@viewport
 @sidebar_text["craft#{count}"].windowskin=nil
 @sidebar_text["craft#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["craft#{count}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["craft#{count}"].width=240
 @sidebar_text["craft#{count}"].height=90
 @sidebar_text["craft#{count}"].x = 0
 @sidebar_text["craft#{count}"].y = 40 if count == 0
 @sidebar_text["craft#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["craft#{count}"].z=98
 @sidebar_text["craft#{count}"].text=object
 @sidebar_text["craft#{count}"].visible=false
 
 count+=1
 end




end


def create_craft_type_text(text_set)
 return if !@sidebar_text.empty?
 count = 0
 #@submap_types = []
 text_set.each_with_index do |object, i|
 @the_recipe << object
    next if i > @startend[1]
    next if i < @startend[0]
 @sidebar_text["selection_craft#{count}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@sidebar_text["selection_craft#{count}"])
 @sidebar_text["selection_craft#{count}"].viewport=@viewport
 @sidebar_text["selection_craft#{count}"].windowskin=nil
 @sidebar_text["selection_craft#{count}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @sidebar_text["selection_craft#{count}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @sidebar_text["selection_craft#{count}"].width=240
 @sidebar_text["selection_craft#{count}"].height=90
 @sidebar_text["selection_craft#{count}"].x = 0
 @sidebar_text["selection_craft#{count}"].y = 40 if count == 0
 @sidebar_text["selection_craft#{count}"].y = 40+(25*count) if count != 0
 #@sprites["header#{i}"].zoom_x=0.5
 #@sprites["header#{i}"].zoom_y=0.5
 @sidebar_text["selection_craft#{count}"].z=98
 if object[0].is_a? Array
 if !$recipe_book.has?(object[0][0]) && object[0][object.length-1].is_a?(FalseClass)
 @sidebar_text["selection_craft#{count}"].text="#{i+1} - ???"
 else
 @sidebar_text["selection_craft#{count}"].text="#{i+1} - #{GameData::Item.get(object[0][0]).name.slice(0, 12)}"
 end
 else
 if !$recipe_book.has?(object[0]) && object[object.length-1].is_a?(FalseClass)
 @sidebar_text["selection_craft#{count}"].text="#{i+1} - ???"
 else
 @sidebar_text["selection_craft#{count}"].text="#{i+1} - #{GameData::Item.get(object[0]).name.slice(0, 12)}"
 end
 end
 @sidebar_text["selection_craft#{count}"].visible=false
 count+=1
 end




end
def display_craft_type(map_set)
 destroy_sidebar_text
 create_craft_type_text(map_set)
 count=0
 map_set.each_with_index do |object, i|
    next if i > @startend[1]
    next if i < @startend[0]
 @sidebar_text["selection_craft#{count}"].visible=true
 if @selection3==count
  @sprites["selarrow"].x = @sidebar_text["selection_craft#{count}"].x
  @sprites["selarrow"].y = @sidebar_text["selection_craft#{count}"].y+10
  @sprites["selarrow"].visible = true
 end
 
 count+=1
 end
 @selection_length = count-1
end 
 
def destroy_recipe_icons
 @recipeicons.each_key do |key|
  @recipeicons[key].visible=false
  @recipeicons.delete(key)
 end
 @recipeicons={}

end

 
def load_new_recipe_data(recipe,force=false)

	 
    destroy_recipe_icons
	@recipeicons = {}
if !$recipe_book.has?(recipe[0]) && recipe[recipe.length-1].is_a?(FalseClass)

 @recipeicons["EncounterType"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@recipeicons["EncounterType"])
 @recipeicons["EncounterType"].viewport=@viewport
 @recipeicons["EncounterType"].windowskin=nil
 @recipeicons["EncounterType"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @recipeicons["EncounterType"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @recipeicons["EncounterType"].width=240
 @recipeicons["EncounterType"].height=90
 @recipeicons["EncounterType"].x = @rightmost-200
 @recipeicons["EncounterType"].y = 23
 @recipeicons["EncounterType"].text = "???"
else
    s = 1
	s += 1 if recipe[recipe.length-1].is_a?(FalseClass)
	 case recipe.length-s
	  when 1
	   fx = 127
	  when 2
	   fx = 97
	  when 3
	   fx = 142
	  when 4
	   fx = 100
	  when 5
	   fx = 75
	  else
	   fx = 64
	 end

	 case recipe.length
	  when 1
	   rate = 30
	  when 2
	   rate = 97
	  when 3
	   rate = 97
	  when 4
	   rate = 64
	  when 5
	   rate = 64
	   else
	   rate = 64
	 end
	
 recipe.each_with_index do |item,i|
    next if item.is_a? FalseClass
    next if i == 0
	if item.is_a? Array
	 amount = item[1]
	 item = item[0]
	else
	 amount = 1
	end
   @recipeicons["icon_#{i}"] = IconSprite.new(0,0,@viewport)
   @recipeicons["icon_#{i}"].setBitmap(GameData::Item.icon_filename(item))
   @recipeicons["icon_#{i}"].x = fx + (rate*(i+1))
   @recipeicons["icon_#{i}"].y = 170 + (i/6)*rate
   @recipeicons["icon_#{i}"].z = 2
   @recipeicons["box#{i}"]=IconSprite.new(@recipeicons["icon_#{i}"].x,170 + (i/6)*rate,@viewport)
   @recipeicons["box#{i}"].setBitmap("Graphics/Pictures/craftingMenu/bgBox")
   @recipeicons["box#{i}"].z= 1
 @recipeicons["item#{i}"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@recipeicons["item#{i}"])
 @recipeicons["item#{i}"].viewport=@viewport
 @recipeicons["item#{i}"].windowskin=nil
 @recipeicons["item#{i}"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @recipeicons["item#{i}"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @recipeicons["item#{i}"].width=240
 @recipeicons["item#{i}"].height=90
 @recipeicons["item#{i}"].x = fx-16 + (rate*(i+1))
 @recipeicons["item#{i}"].y = 190 + (i/6)*rate
 @recipeicons["item#{i}"].text = "#{GameData::Item.get(item).name.slice(0, 4)} x#{amount}"
 @recipeicons["item#{i}"].resizeToFit("#{GameData::Item.get(item).name.slice(0, 4)} x#{amount}")
 end
 @recipeicons["EncounterType"]=Window_UnformattedTextPokemon.new("")
 pbPrepareWindow(@recipeicons["EncounterType"])
 @recipeicons["EncounterType"].viewport=@viewport
 @recipeicons["EncounterType"].windowskin=nil
 @recipeicons["EncounterType"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
 @recipeicons["EncounterType"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
 @recipeicons["EncounterType"].width=240
 @recipeicons["EncounterType"].height=90
 @recipeicons["EncounterType"].x = @rightmost-220
 @recipeicons["EncounterType"].y = 23
 
 if recipe[0].is_a? Array
 @recipeicons["EncounterType"].text = GameData::Item.get(recipe[0][0]).name
 @recipeicons["EncounterType"].resizeToFit(GameData::Item.get(recipe[0][0]).name)
 else
 @recipeicons["EncounterType"].text = GameData::Item.get(recipe[0]).name
 @recipeicons["EncounterType"].resizeToFit(GameData::Item.get(recipe[0]).name)
 end
end
end

end


def prepareforsendingfile
    # list of all possible rules
    modifiers = [:ROAMING_SPECIES, :FAMILY, :MOVES, :TYPES]
    # list of rule descriptions
    desc = [
      _INTL("Adds Roaming Species to the Pokemon Pool"),
      _INTL("Adds Evolutions and Preevolutions to the Pokemon Pool"),
      _INTL("Enables Moves in the Output"),
      _INTL("Enables Types in the Output")
    ]
    # default
    added = []; cmd = 0
    ## creates help text message window
    msgwindow = pbCreateMessageWindow(nil, "choice 1")
    msgwindow.text = _INTL("Select what you wish to apply.")
    # main loop
    loop do
    #  # generates all commands
      commands = []
      for i in 0...modifiers.length
        commands.push(_INTL("{1} {2}",(added.include?(modifiers[i])) ? "[X]" : "[  ]",desc[i]))
      end
      commands.push(_INTL("Done"))
    #  # goes to command window
      cmd = pbShowCommands(msgwindow,commands,cmd)
    #  # processes return
      if cmd < 0
        clear = pbConfirmMessage("Do you wish to cancel?")
        added.clear if clear
        next unless clear
      end
      break if cmd < 0 || cmd >= (commands.length - 1)
      if cmd >= 0 && cmd < (commands.length - 1)
        if added.include?(modifiers[cmd])
          added.delete(modifiers[cmd])
        else
          added.push(modifiers[cmd])
        end
      end
    end
    # disposes of message window
    pbDisposeMessageWindow(msgwindow)
    Input.update
	 if cmd < 0
	  return false
	 end
	 send_pokemon_list(added)
    return true
end


def send_pokemon_list(options)
    
	
	have_roamers = options.include?(:ROAMING_SPECIES)
	have_family = options.include?(:FAMILY)
	have_moves = options.include?(:MOVES)
	have_types = options.include?(:TYPES)
    arr = []
    enc_array = []
    move_array = []
    type_array = []
	map_info = pbLoadMapInfos
	puts "BEGINNING PRINTING..."
	puts "BEGINNING ENCOUNTER TABLES..."
	 encversion = 0 if $PokemonGlobal.nil?
	 encversion = $PokemonGlobal.encounter_version if !$PokemonGlobal.nil?
   map_info.each do |map|
   newEncData = GameData::Encounter.get(map[0], encversion)
   next if newEncData.nil?
   encounter_tables = Marshal.load(Marshal.dump(newEncData.types))
   encounter_tables.keys.each do |key|
    encounter_tables[key].each { |s| arr.push( s[1] ) }
    GameData::Species.each { |s| enc_array.push(s.id) if arr.include?(s.id) } # From Maruno
    enc_array.uniq!
   end
   end


    if have_roamers==true
	puts "BEGINNING ROAMING SPECIES..."

   Settings::ROAMING_SPECIES.each do |pkmn|
      name = GameData::Species.get(pkmn[0]).id
    enc_array<<name
    enc_array.uniq!
  end
    end 
  
    if have_family==true
	puts "BEGINNING FAMILY SPECIES..."
   enc_array.each do |pkmn|
   
    other_family = GameData::Species.get(pkmn).get_family_species
	other_family.each do |i|
      name = GameData::Species.get(i).id
    enc_array<<name
    enc_array.uniq!
    end
   end
    end



    pokemonlength = enc_array.length
	
	
	
    if have_moves==true
	puts "BEGINNING MOVE INDEXING..."
    moves = []
   enc_array.each_with_index do |pkmn1, index|
     pkmn = GameData::Species.get(pkmn1)
      pkmn.moves.each do |move|
	    themove = move
	    themove = move[1] if move.is_a? Array
	    moves << GameData::Move.get(themove).name
	  end
      pkmn.tutor_moves.each do |move|
	   next if moves.include?(GameData::Move.get(move).name)
	    themove = move
	    themove = move[1] if move.is_a? Array
	    moves << GameData::Move.get(move).name
	  end
      pkmn.egg_moves.each do |move|
	   next if moves.include?(GameData::Move.get(move).name)
	    themove = move
	    themove = move[1] if move.is_a? Array
	    moves << GameData::Move.get(move).name
	  end
   end
	move_hash = {}
   move_hash = moves.tally
   
	puts "BEGINNING FULL MOVE LIST INDEXING..."
	 GameData::Move.each do |move|
	    themove = move
	    themove = move[1] if move.is_a? Array
		
	   next if GameData::Move.get(themove).flags.include?("MaxMove")
	   next if GameData::Move.get(themove).flags.include?("ZMove")
	   next if move_hash.keys.include?(GameData::Move.get(themove).name)
	   if GameData::Move.get(themove).type!=:SHADOW
	    move_hash[GameData::Move.get(themove).name] = 0 
	   else
	    move_hash[GameData::Move.get(themove).name] = :SHADOW
	   end
	 end
	 
   end



    if have_types==true
	puts "BEGINNING TYPE INDEXING..."
    types = []
   enc_array.each_with_index do |pkmn1, index|
     pkmn = GameData::Species.get(pkmn1)
      pkmn.types.each do |type|
	    types << GameData::Type.get(type).real_name
	  end
   end
    end
	 

	puts "BEGINNING RENAMING..."
   enc_array.each_with_index do |pkmn, index|
    name = GameData::Species.get(pkmn).name
    formName = GameData::Species.get(pkmn).form_name
	 formName = "Normal Form" if nil_or_empty?(formName)
     enc_array[index] = "#{name} - #{formName}"
   end
   enc_array = enc_array.sort
	puts "BEGINNING SHIFTING..."
   enc_array = enc_array.unshift("  ")
   enc_array = enc_array.unshift("List of Available Species:")
   enc_array = enc_array.unshift("  ")
   
    if have_types==true
   counts = types.tally
	 GameData::Type.each do |type|
	    thetype = type
	    thetype = type[1] if type.is_a? Array
		
	   next if GameData::Type.get(thetype).real_name == "???"
	   next if GameData::Type.get(thetype).real_name == "Shadow"
	   next if counts.keys.include?(GameData::Type.get(thetype).real_name)
	    counts[GameData::Type.get(type).real_name] = 0 
	 end
   
   counts.each do |key, value|
   type_array << "#{value} Pokemon which Types include: #{key}"
   end
   type_array = type_array.sort_by do |string|
       string.match(/^\d+/)[0].to_i  # Extracts the leading number and converts to integer
   end
   type_array = type_array.unshift("  ")
   type_array = type_array.unshift("Type Data:")
   end
  
    if have_moves==true
	puts "BEGINNING MOVE APPENDING..."
   enc_array << "  "
   enc_array << "Move Data:"
   enc_array << "  "
   move_hash.each do |key, value|
    if value != :SHADOW
   move_array  << "#{value} Pokemon which have Move: #{key}"
    else
   move_array  << "9999 No Pokemon have #{key} has it is a Shadow Move."
   end
   end
 move_array = move_array.sort_by do |string|
  string.match(/^\d+/)[0].to_i  # Extracts the leading number and converts to integer
end
 move_array.reverse!
   end
   
   
   enc_array = type_array + enc_array + move_array 
   
   enc_array = enc_array.unshift("  ")
     
     settings_message = "Approximately #{pokemonlength} Pokemon Available under: "
     settings_message += "'Default'"
     settings_message += ", " if  have_roamers
     settings_message += "'have_roamers'" if have_roamers
     settings_message += ", " if have_family && have_roamers
     settings_message += "'have_family'" if have_family
   enc_array = enc_array.unshift(settings_message)
   
   
   results = enc_array.join("\n")
   File.open("IG Pokemon Data.txt", "wb") do |file|
     file.write(results)
   end
	puts "FINISHED."
end
  
  MenuHandlers.add(:debug_menu, :print_living_dex, {
  "name"        => _INTL("Print Real Dex"),
  "parent"      => :main,
  "description" => _INTL("Prints all Pokemon currently available in game to a file."),
   "effect"      => proc {
    prepareforsendingfile
  },
  #"always_show" => false
})
  
  
def seen_form_any_gender?(species, form)
  ret = false
  if $player.pokedex.seen_form?(species, 0, form) ||
    $player.pokedex.seen_form?(species, 1, form)
    ret = true
  end
  return ret
end