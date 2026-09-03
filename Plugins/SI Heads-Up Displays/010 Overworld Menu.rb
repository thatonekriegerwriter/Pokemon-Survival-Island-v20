class OverworldMenu
   attr_accessor :should_refresh
  def initialize(viewport)
    @viewport = viewport 
    @y_position = Graphics.height-64 + $PokemonSystem.screenposy + 45
    @x_position = 440 + $PokemonSystem.screenposx
	@sprites = {}
	@slots = {}
	@previous_name = nil
	@should_refresh = true 
	@last_extended_state  = nil
	@previous_amount = nil
	$OverworldMenu = self 
  end 
  def should_display?
    return false unless $hud
	return false if $game_system.menu_disabled
	return true if $game_temp.just_update_anyways
    return $PokemonGlobal.ball_hud_enabled && !$game_temp.in_menu && !$game_temp.message_window_showing && $hud.show && !$game_temp.signposting
  end 

  def refresh
    return unless hasSprites?
    return unless should_display?
	refreshBox 
	@state_check_count ||= 0
    return unless should_refresh?
	refreshSubboxes 
	@should_refresh = false 
  end 
  
  def should_refresh?
    return true if @should_refresh
	return true if state_changed?
    return false 
  
  end 
  def extended_ball_order
   $PokemonGlobal.ball_order.map do |item|
    item.is_a?(ItemData) ? [item.id, item.durability, item.water] : item
   end
  end


  def state_changed?
      state = [
      extended_ball_order,
      $PokemonGlobal.ball_hud_index,
      $PokemonGlobal.cur_stored_pokemon,
      $PokemonGlobal.cur_stored_fishing_rod,
      $PokemonGlobal.alt_control_move
    ]
   if state != @last_extended_state
     @state_check_count += 1
     @last_extended_state = state
	 return true 
    end
    return false 
  end 
  
  def create
    createSprites
    refresh
  end 
  
  def item_box
    return if @sprites["hud_bg"].nil?
	return @sprites["hud_bg"]
  end 
  

  def createSprites
    createBox(@x_position , @y_position, 70, 11)
  end 
  def createBox(x, y, width, height)
     return if !@sprites["hud_bg"].nil?
     getCurrentItemOrder
     current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	 
	 
     @sprites["hud_bg"]=IconSprite.new(x-22,280,@viewport)
     @sprites["hud_bg"].setBitmap("Graphics/Pictures/OW_Catch_UI")
     @sprites["hud_bg"].z=9
     @sprites["ball_icon"]=ItemIconSprite.new(x+24,288+34,nil,@viewport)
     @sprites["ball_icon"].blankzero = true
     @sprites["ball_icon"].z=9
	 @sprites["pkmn_icon"]=PokemonIconSprite.new(nil, @viewport)
     @sprites["pkmn_icon"].x=x-7
     @sprites["pkmn_icon"].y=288-4
     @sprites["pkmn_icon"].z=9
     @sprites["other_icon"]=IconSprite.new(x,228+70,nil,@viewport)
     @sprites["other_icon"].z=9
	 
     @sprites["overlay"]=BitmapSprite.new(48,48,@viewport)
     @sprites["overlay"].x=x
     @sprites["overlay"].y=288
     @sprites["overlay"].z=9
     pbSetSystemFont(@sprites["overlay"].bitmap)
	 
     if current_selection.is_a?(Pokemon)
       @sprites["pkmn_icon"].pokemon=current_selection
     elsif current_selection.is_a?(ItemData)
       @sprites["ball_icon"].item=current_selection
     elsif current_selection == :MULTISELECT
       @sprites["ball_icon"].item=:NO
     end

     @sprites["namewindow"] = Window_AdvancedTextPokemon.newWithSize("", x-24, 250, 270, 64)
     @sprites["namewindow"].visible = true
     @sprites["namewindow"].windowskin  = nil
     @sprites["amt"] = Window_AdvancedTextPokemon.newWithSize("", x-24+46, 256+56, 270+1, 200)
     @sprites["amt"].visible = true
     @sprites["amt"].windowskin  = nil
     @sprites["durawindow"] = Window_AdvancedTextPokemon.new("")
     @sprites["durawindow"].visible = true
     @sprites["durawindow"].windowskin  = nil
     @sprites["durawindow"].zoom_x  = 0.75
     @sprites["durawindow"].zoom_y  = 0.75
     @sprites["durawindow"].x  = x-24+144-15
     @sprites["durawindow"].y  = 240+190-2
     @sprites["durawindow"].baseColor  = Color.new(255,192,66)
     @sprites["durawindow"].shadowColor=get_shadow_color(:FIRE)
     @sprites["waterwindow"] = Window_AdvancedTextPokemon.new("")
     @sprites["waterwindow"].visible = true
     @sprites["waterwindow"].windowskin  = nil
     @sprites["waterwindow"].zoom_x  = 0.75
     @sprites["waterwindow"].zoom_y  = 0.75
     @sprites["waterwindow"].x  = x-24+209-6
     @sprites["waterwindow"].y  = 240+190-54
     @sprites["waterwindow"].baseColor  = get_type_color
     @sprites["waterwindow"].shadowColor=get_shadow_color(:FIRE)
     @sprites["status_effect"]=IconSprite.new(x+1,289,@viewport)
     @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
     @sprites["status_effect"].z=10
     createSubboxes(x, y, width, height)
     overlay=@sprites["overlay"].bitmap
     overlay.clear
		 
     hideBallHUD if $PokemonGlobal.ball_hud_enabled==false
  end
 
  def dispose
    pbDisposeSpriteHash(@sprites)
  end
  def hasSprites?
    return !@sprites.empty?
  end 


  def update
    pbUpdateSpriteHash(@sprites)
    pbUpdateSpriteHash(@slots)
  end 

  def createSubboxes(x, y, width, height)
     @sprites["extendedBG"]=IconSprite.new(x-70 - (46*5),Graphics.height-80,@viewport)
     @sprites["extendedBG"].setBitmap("")
     @sprites["extendedBG"].visible=false
     @sprites["title_window"] = Window_AdvancedTextPokemon.new("")
     @sprites["title_window"].windowskin  = nil
     @sprites["title_window"].x  = x-76 - (46*5)
     @sprites["title_window"].y  = Graphics.height-120
     @sprites["title_window"].z=9
   6.times do |i|
		bonus = get_subbox_bonus(i)
     @sprites["secondary_boxes#{i}"]=IconSprite.new(0,0,@viewport)
     @sprites["secondary_boxes#{i}"].visible=false
     @sprites["secondary_boxes#{i}"].setBitmap("Graphics/Pictures/Hud/catchuiblank")
     @sprites["secondary_boxes#{i}"].zoom_x=0.50
     @sprites["secondary_boxes#{i}"].zoom_y=0.50
	   boxes_xvalue = x-56- (46*i)
	 
     @sprites["secondary_boxes#{i}"].x=boxes_xvalue
     @sprites["secondary_boxes#{i}"].y=Graphics.height-66
     @sprites["secondary_boxes#{i}"].z=8
     #@sprites["secondary_boxes#{i}"].opacity = (300/(i+1)).to_i
     @sprites["durawindow_small#{i}"] = Window_AdvancedTextPokemon.new("")
     @sprites["durawindow_small#{i}"].visible = false
     @sprites["durawindow_small#{i}"].windowskin  = nil
     @sprites["durawindow_small#{i}"].zoom_x  = 0.50
     @sprites["durawindow_small#{i}"].zoom_y  = 0.50
     @sprites["aquawindow_small#{i}"] = Window_AdvancedTextPokemon.new("")
     @sprites["aquawindow_small#{i}"].visible = false
     @sprites["aquawindow_small#{i}"].windowskin  = nil
     @sprites["aquawindow_small#{i}"].zoom_x  = 0.50
     @sprites["aquawindow_small#{i}"].zoom_y  = 0.50
	   if i == 0
	    duris1 = x + bonus + 320 - (95*i) - (@sprites["durawindow_small#{i}"].width / 4)
	   else 
	   
	    duris1 = x + bonus + 320 - (90*i) - (@sprites["durawindow_small#{i}"].width / 4)
	   end
     @sprites["durawindow_small#{i}"].x  = duris1
     @sprites["durawindow_small#{i}"].y  = Graphics.height + 276
     @sprites["aquawindow_small#{i}"].x  = duris1+46
     @sprites["aquawindow_small#{i}"].y  = Graphics.height + 246
     #@sprites["durawindow_small#{i}"].opacity = (300/(i+1)).to_i

     @sprites["namewindow_small#{i}"] = Window_AdvancedTextPokemon.newWithSize("", x-24, 250, 270, 64)
     @sprites["namewindow_small#{i}"].visible = false
     @sprites["namewindow_small#{i}"].windowskin  = nil
     @sprites["namewindow_small#{i}"].zoom_x  = 0.50
     @sprites["namewindow_small#{i}"].zoom_y  = 0.50
	   if i == 0
	    duris = x + bonus + 373 - (95*i) - (@sprites["namewindow_small#{i}"].width / 4)
	   else 
	   
	    duris = x + bonus + 373 - (90*i) - (@sprites["namewindow_small#{i}"].width / 4)
	   end
     @sprites["namewindow_small#{i}"].x  = duris
     @sprites["namewindow_small#{i}"].y  = Graphics.height + 210
     #@sprites["namewindow_small#{i}"].opacity = (300/(i+1)).to_i

	  @sprites["pkmn_icon_small#{i}"]=PokemonIconSprite.new(nil, @viewport)
     @sprites["pkmn_icon_small#{i}"].zoom_x  = 0.50
     @sprites["pkmn_icon_small#{i}"].zoom_y  = 0.50
     @sprites["pkmn_icon_small#{i}"].x=boxes_xvalue + (@sprites["pkmn_icon_small#{i}"].width/2)
     @sprites["pkmn_icon_small#{i}"].y=Graphics.height-66
     @sprites["pkmn_icon_small#{i}"].z=9
     #@sprites["pkmn_icon_small#{i}"].opacity = (300/(i+1)).to_i
     @sprites["pkmn_icon_small#{i}"].visible = false
	 
     @sprites["ball_icon_small#{i}"]=ItemIconSprite.new(x+24,288+34,nil,@viewport)
     @sprites["ball_icon_small#{i}"].blankzero = true
     @sprites["ball_icon_small#{i}"].zoom_x  = 0.50
     @sprites["ball_icon_small#{i}"].zoom_y  = 0.50
     @sprites["ball_icon_small#{i}"].x=boxes_xvalue + @sprites["ball_icon_small#{i}"].width + 17
     @sprites["ball_icon_small#{i}"].y=Graphics.height-49
     @sprites["ball_icon_small#{i}"].z=9
     #@sprites["ball_icon_small#{i}"].opacity = (300/(i+1)).to_i
     @sprites["ball_icon_small#{i}"].visible = false
	 
     @sprites["other_icon_small#{i}"]=IconSprite.new(x+24,288+34,nil,@viewport)
     @sprites["other_icon_small#{i}"].zoom_x  = 0.50
     @sprites["other_icon_small#{i}"].zoom_y  = 0.50
     @sprites["other_icon_small#{i}"].x=boxes_xvalue + @sprites["other_icon_small#{i}"].width + 5
     @sprites["other_icon_small#{i}"].y=Graphics.height-61
     @sprites["other_icon_small#{i}"].z=9
     #@sprites["ball_icon_small#{i}"].opacity = (300/(i+1)).to_i
     @sprites["other_icon_small#{i}"].visible = false
	end
	 
  
  
  
  
  end


  def get_subbox_bonus(i)
    [-0, -1, -2, -3, -4, -4, -4][i] || 0
  end
  def hideSmallBallHUD
  @sprites.each_key do |key|
    next unless key.include?("_small") || key.include?("secondary_boxes") || key.include?("extendedBG")
    @sprites[key].visible = false
  end
  end
  def hideBallHUD
  @sprites.each_key do |key|
    @sprites[key].visible=false
  end
  end
  def revealBallHUD
  changed = false 
  @sprites.each_key do |key|
     next if key.include?("secondary_boxes")
     next if key.include?("pkmn_icon_small")
     next if key.include?("other_icon_small")
     next if key.include?("ball_icon_small")
     next if key.include?("namewindow_small")
     next if key.include?("durawindow_small")
     next if key.include?("aquawindow_small")
	 sprite = @sprites[key]
     next if sprite.visible
     sprite.visible=true
     changed = true 
  end
    @should_refresh = true if changed 
  end


  def get_type_color(type=nil)
       case type
         when :NORMAL
           return Color.new(168, 167, 122)
         when :FIRE
           return Color.new(238, 129, 48)
         when :WATER
           return Color.new(99, 144, 240)
         when :ELECTRIC
           return Color.new(247, 208, 44)
         when :GRASS
           return Color.new(122, 199, 76)
         when :ICE
           return Color.new(150, 217, 214)
         when :FIGHTING
           return Color.new(194, 46, 40)
         when :POISON
           return Color.new(163, 62, 161)
         when :GROUND
           return Color.new(226, 191, 101)
         when :FLYING
           return Color.new(169, 143, 243)
         when :PSYCHIC
           return Color.new(249, 85, 135)
         when :BUG
           return Color.new(166, 185, 26)
         when :ROCK
           return Color.new(182, 161, 54)
         when :GHOST
           return Color.new(115, 87, 151)
         when :DRAGON
           return Color.new(111, 53, 252)
         when :DARK
           return Color.new(112, 87, 70)
         when :STEEL
           return Color.new(183, 183, 206)
         when :FAIRY
           return Color.new(214, 133, 173)
         else
           return Color.new(80, 80, 88)
       end
  end
 
  def get_shadow_color(type)
       case type
         when :NORMAL
           return Color.new(80, 80, 88)
         when :FIRE
           return Color.new(80, 80, 88)
         when :WATER
           return Color.new(80, 80, 88)
         when :ELECTRIC
           return Color.new(80, 80, 88)
         when :GRASS
           return Color.new(80, 80, 88)
         when :ICE
           return Color.new(80, 80, 88)
         when :FIGHTING
           return Color.new(80, 80, 88)
         when :POISON
           return Color.new(80, 80, 88)
         when :GROUND
           return Color.new(80, 80, 88)
         when :FLYING
           return Color.new(80, 80, 88)
         when :PSYCHIC
           return Color.new(80, 80, 88)
         when :BUG
           return Color.new(80, 80, 88)
         when :ROCK
           return Color.new(80, 80, 88)
         when :GHOST
           return Color.new(80, 80, 88)
         when :DRAGON
           return Color.new(80, 80, 88)
         when :DARK
           return Color.new(80, 80, 88)
         when :STEEL
           return Color.new(80, 80, 88)
         when :FAIRY
           return Color.new(80, 80, 88)
         else
           return Color.new(160, 160, 168)
       end
  end 
  
  def durable?(current_selection)
    return current_selection.is_a?(ItemData) && current_selection.durable?
  
  end
  def spoiling?(current_selection)
    return current_selection.is_a?(ItemData) && current_selection.is_spoiling?
  end 
  def pokeball?(current_selection)
    return current_selection.is_a?(ItemData) && GameData::Item.get(current_selection).is_poke_ball?
  end 
  def getCurrentSelection
    getCurrentItemOrder
    return $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
  end 


def get_text_for_title_window
  if !$PokemonGlobal.cur_stored_pokemon.nil?
     return "#{$PokemonGlobal.cur_stored_pokemon.name} - (#{$PokemonGlobal.cur_stored_pokemon.hp}/#{$PokemonGlobal.cur_stored_pokemon.totalhp})"
  elsif !$PokemonGlobal.cur_stored_fishing_rod.nil?
     return "Pick Bait (#{$PokemonGlobal.cur_stored_fishing_rod.durability}/#{$PokemonGlobal.cur_stored_fishing_rod.max_durability} Durability)"
  elsif $game_temp.radial_enabled==true
     return "Home"
  elsif $game_temp.favorites_enabled==true
     return "Favorites"
  elsif $PokemonGlobal.alt_control_move==true
     return "Multi Sel"
  elsif $PokemonGlobal.ball_hud_type==:PKMN
     return "Pokemon"
  elsif $PokemonGlobal.ball_hud_type==:ITEM
      case $PokemonGlobal.ball_hud_item_type
		   when :PLACE
             return "Placeable"
		   when :TOOL
             return "Tools"
		   when :WEAPONS
             return "Weapons"
		   when :BATTLE
             return "Consumable"
		   when :CROPS
             return "Crops"
       end

  end
  return "Error"
end

  def resetExtendedHUD
 6.times do |i|
     @sprites["pkmn_icon_small#{i}"].visible = false
     @sprites["other_icon_small#{i}"].visible = false
     @sprites["ball_icon_small#{i}"].visible = false
     @sprites["secondary_boxes#{i}"].visible = false
     @sprites["durawindow_small#{i}"].visible = false
     @sprites["namewindow_small#{i}"].visible = false
     @sprites["aquawindow_small#{i}"].visible = false
     @sprites["durawindow_small#{i}"].baseColor = Color.new(255,182,66)  # Default (green)
     @sprites["ball_icon_small#{i}"].item=nil
     @sprites["pkmn_icon_small#{i}"].pokemon=nil
     @sprites["other_icon_small#{i}"].name=nil
     @sprites["durawindow_small#{i}"].text = ""
     @sprites["namewindow_small#{i}"].text = ""
     @sprites["durawindow_small#{i}"].resizeToFit("")
     @sprites["namewindow_small#{i}"].resizeToFit("")
     @sprites["aquawindow_small#{i}"].text = ""
     @sprites["aquawindow_small#{i}"].resizeToFit("")
	 @sprites["title_window"].text= ""
     @sprites["title_window"].resizeToFit("")
 
 
 
 
 end
     @sprites["extendedBG"].setBitmap("")
     @sprites["extendedBG"].visible=false  
  
  
  end 
  
 def refreshSubboxes
  resetExtendedHUD
  refreshExtendedHUD if $PokemonGlobal.set_extended_hud==true && $game_temp.in_inventory==false
 end 
 def refreshExtendedHUD
   refreshExtendedBackground
   refreshExtendedTitle
   each_extended_slot do |i, selection|
     refreshExtendedSlot(i, selection)
   end 
 end 
 
 def refreshExtendedBackground
  if $PokemonGlobal.cur_stored_pokemon.nil? && !$PokemonGlobal.alt_control_move
    @sprites["extendedBG"].setBitmap("Graphics/UI/OV HUD/extendedbg")
  else
    @sprites["extendedBG"].setBitmap("Graphics/UI/OV HUD/extendedbg2")
  end
  @sprites["extendedBG"].visible=true
 end
 
 def refreshExtendedTitle
  text = get_text_for_title_window
  @sprites["title_window"].text = text
  @sprites["title_window"].resizeToFit(text)
 end
 
 def refreshExtendedPokemon(i, currentSelection)
	  text2 = ""
    @sprites["pkmn_icon_small#{i}"].pokemon=currentSelection
	@sprites["ball_icon_small#{i}"].item=nil
    @sprites["other_icon_small#{i}"].name=nil
	name = GameData::Species.try_get(currentSelection.species).real_name
	name = name.slice(0, 10) if name.length > 10
	formname = currentSelection.species_data.form_name
	text1 = "#{name}" if formname.nil? 
	text1 = "#{name} (#{formname.slice(0, 1)})" if !formname.nil? 
	text1 = "???" if currentSelection.egg?
	text2 = "#{currentSelection.hp}/#{currentSelection.totalhp}" if !currentSelection.egg?
    @sprites["durawindow_small#{i}"].baseColor = Color.new(24,198,33)  
    @sprites["durawindow_small#{i}"].baseColor = Color.new(239,173,0) if currentSelection.hp <= (currentSelection.totalhp / 2).floor 
    @sprites["durawindow_small#{i}"].baseColor = Color.new(255,74,57) if currentSelection.hp <= (currentSelection.totalhp / 4).floor
	
	return text1, text2, ""
 end 
 
 def refreshExtendedItem(i, currentSelection)
    @sprites["pkmn_icon_small#{i}"].pokemon=nil
	@sprites["ball_icon_small#{i}"].item=currentSelection.id
    @sprites["other_icon_small#{i}"].name=nil
	name = currentSelection.name
	name = name.slice(0, 10) if name.length > 10
	durability = ""
	durability = "#{currentSelection.durability}/#{currentSelection.max_durability}" if durable?(currentSelection) && !spoiling?(currentSelection) && !pokeball?(currentSelection)
		 
		 
    return name, durability, ""
 end 
 
 def refreshExtendedMove(i, currentSelection)
	  text2 = ""
	  text1 = GameData::Move.get(currentSelection.id).real_name
	  text2 = "#{currentSelection.pp}/#{currentSelection.total_pp}"
	  text3 = ""
	  if !$PokemonGlobal.cur_stored_pokemon.nil?
	     moves =  $PokemonGlobal.cur_stored_pokemon.moves+$PokemonGlobal.cur_stored_pokemon.moves2
		  index = moves.index(currentSelection)
	     text3 = "#{index+1}"
	  end
	  imagepath = "Graphics/UI/OV HUD/#{currentSelection.id}"
	  image = imagepath if pbResolveBitmap(imagepath)
	  if currentSelection.is_a?(Pokemon::Move) && image.nil?
	   imagepath = "Graphics/UI/OV HUD/#{currentSelection.type}"
	   image = imagepath if pbResolveBitmap(imagepath)
	  end
	  @sprites["pkmn_icon_small#{i}"].pokemon=nil
      @sprites["ball_icon_small#{i}"].item=nil
      @sprites["other_icon_small#{i}"].name=image
	  text1 = text1.slice(0, 10) if text1.length > 10
	  return text1, text2, text3
 end 
 
 def refreshExtendedSymbol(i, currentSelection)
	  text2 = ""
	  text1 = "None"
	  text1 = get_current_symbol_name(currentSelection)
	  
	   imagepath = "Graphics/UI/OV HUD/#{text1}"
	   image = imagepath if pbResolveBitmap(imagepath)
       @sprites["pkmn_icon_small#{i}"].pokemon=nil
       @sprites["ball_icon_small#{i}"].item=nil if currentSelection != :BATTLE
	    @sprites["ball_icon_small#{i}"].item=:POTION if currentSelection == :BATTLE
	    @sprites["ball_icon_small#{i}"].item=:ORANBERRY if currentSelection == :CROPS
	   @sprites["ball_icon_small#{i}"].item=:BLUEFLUTE if currentSelection == :TOOL
	   @sprites["ball_icon_small#{i}"].item=:BLACKBELT if currentSelection == :WEAPONS
       @sprites["other_icon_small#{i}"].name=image  if image && currentSelection != :BATTLE && currentSelection != :TOOL && currentSelection != :WEAPONS 
       @sprites["other_icon_small#{i}"].name=nil  if currentSelection == :BATTLE
       @sprites["other_icon_small#{i}"].name=nil  if currentSelection == :TOOL
       @sprites["other_icon_small#{i}"].name=nil  if currentSelection == :WEAPONS
		 
	  text1 = text1.slice(0, 10) if text1.length > 10
	  return text1, text2, ""
 end 
 
 def refreshExtendedString(i, currentSelection)
 
	  text2 = ""
	  text1 = "None"
	  text1 = currentSelection
	  imagepath = "Graphics/UI/OV HUD/#{text1}"
	  image = imagepath if pbResolveBitmap(imagepath)
      @sprites["pkmn_icon_small#{i}"].pokemon=nil
      @sprites["ball_icon_small#{i}"].item=nil
      @sprites["other_icon_small#{i}"].name=image
	  text1 = text1.slice(0, 10) if text1.length > 10
	  return text1, text2, ""
 end 
 
 def showExtendedSlot(i, text1, text2, text3)
       @sprites["aquawindow_small#{i}"].text = text3
       @sprites["durawindow_small#{i}"].text = text2
       @sprites["namewindow_small#{i}"].text = text1
      @sprites["aquawindow_small#{i}"].resizeToFit(text3)
      @sprites["durawindow_small#{i}"].resizeToFit(text2)
      @sprites["namewindow_small#{i}"].resizeToFit(text1)
     @sprites["pkmn_icon_small#{i}"].visible = true
     @sprites["other_icon_small#{i}"].visible = true
     @sprites["ball_icon_small#{i}"].visible = true
     @sprites["secondary_boxes#{i}"].visible = true
     @sprites["durawindow_small#{i}"].visible = true
     @sprites["aquawindow_small#{i}"].visible = true
     @sprites["namewindow_small#{i}"].visible = true
 end 
 
 
 def refreshExtendedSlot(index, selection)
   case selection
  when Pokemon
    text1, text2, text3 = refreshExtendedPokemon(index, selection)
  when ItemData
    text1, text2, text3 = refreshExtendedItem(index, selection)
  when Pokemon::Move
    text1, text2, text3 = refreshExtendedMove(index, selection)
  when Symbol
    text1, text2, text3 = refreshExtendedSymbol(index, selection)
  when String
    text1, text2, text3 = refreshExtendedString(index, selection)
  end

  showExtendedSlot(index, text1, text2, text3)
 end 
 
 def each_extended_slot
   amount = [$PokemonGlobal.ball_order.length - 1, 6].min
   amount.times do |i|
    target = (i + 1 + $PokemonGlobal.ball_hud_index) % $PokemonGlobal.ball_order.length
    selection = $PokemonGlobal.ball_order[target]
	next if selection.nil?
	yield i, selection
   end 
 end 

  def refresh_window
     @sprites["waterwindow"].baseColor  = get_type_color
     @sprites["waterwindow"].shadowColor=get_shadow_color(:FIRE)
  end 
  
  def refreshPokemon(current_selection)
	  @sprites["pkmn_icon"].pokemon=nil if @sprites["pkmn_icon"].pokemon!=current_selection
	  name = GameData::Species.try_get(current_selection.species).real_name
	  name = name.slice(0, 10) if name.length > 10
	  formname = current_selection.species_data.form_name
	  name = "#{name} (#{formname.slice(0, 1)})" if !formname.nil? 
	  @sprites["pkmn_icon"].pokemon=current_selection
	  @sprites["ball_icon"].item=nil
	  @sprites["other_icon"].name=nil
	  durability_text = ""
	  if current_selection.egg?
	    @sprites["durawindow"].baseColor  = Color.new(255,182,66)
	  else
	    durability_text = "#{current_selection.hp}/#{current_selection.totalhp}"
        @sprites["durawindow"].baseColor = Color.new(24,198,33)  # Default (green)
        @sprites["durawindow"].baseColor = Color.new(239,173,0) if current_selection.hp <= (current_selection.totalhp / 2).floor  # Yellow at 50% HP
        @sprites["durawindow"].baseColor = Color.new(255,74,57) if current_selection.hp <= (current_selection.totalhp / 4).floor  # Red at 25% HP
        @sprites["durawindow"].shadowColor=get_shadow_color(:FIRE)
	  end


	  @sprites["durawindow"].text = durability_text
      @sprites["durawindow"].resizeToFit(durability_text)
	  
	  
	  
	  @sprites["waterwindow"].text = ""
      @sprites["waterwindow"].shadowColor=get_shadow_color(:FIRE)
	  
	  
	  name = "???" if current_selection.egg?
	  
	  
      case current_selection.status
        when :SLEEP
         @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/sleep")
        when :POISON
         @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/Poison")
        when :BURN
         @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/Flame")
        when :PARALYSIS
         @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/Paralyzed")
        when :FROZEN
         @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/Frozen")
		 else
         @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
      end
	  
	  
	  if !current_selection.egg? && $PokemonGlobal.selected_pokemon[0]!=current_selection
	    $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}#{$PokemonGlobal.selected_pokemon[0]&.name}") if $PokemonGlobal.selected_pokemon[0] != 0
	    $PokemonGlobal.selected_pokemon[0] = current_selection  if !current_selection&.associatedevent.nil?
	  elsif $PokemonGlobal.selected_pokemon[0] != 0
	    $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}#{$PokemonGlobal.selected_pokemon[0]&.name}")if $PokemonGlobal.selected_pokemon[0]!=0
	    $PokemonGlobal.selected_pokemon[0] = 0 if current_selection.egg?
	  end
     

  
	 return name 
  
  
  end 
  def refreshItem(current_selection)
	   clearPokemonSelection
       @sprites["waterwindow"].baseColor  = Color.new(0, 84, 119)
       @sprites["waterwindow"].shadowColor=get_shadow_color(:FIRE)
	   object = GameData::Item.try_get(current_selection) 
	   @sprites["ball_icon"].item=nil if @sprites["ball_icon"].item!=current_selection
	   name = object.name
	   name = name.slice(0, 10) if name.length > 10
	   name = _INTL("{1}",pbGetTimeNow.strftime("%I:%M %p")) if object.id == :CLOCK
	   @sprites["ball_icon"].item=current_selection
	   @sprites["pkmn_icon"].pokemon=nil
	   @sprites["other_icon"].name=nil
       @sprites["durawindow"].baseColor  = Color.new(255,182,66)
	   text4 = ""    
	   text4 = "#{current_selection.durability}/#{current_selection.max_durability}" if durable?(current_selection) && !spoiling?(current_selection) && !pokeball?(current_selection)
	   @sprites["durawindow"].text = text4
       @sprites["durawindow"].resizeToFit(text4)

	   text5 = ""   
       text5 = "#{current_selection.water}" if current_selection.watering_can?
	   @sprites["waterwindow"].text = text5
       @sprites["waterwindow"].resizeToFit(text5)
	   return name 
  end 
  
  def refreshMove(current_selection)
      clearPokemonSelection
	  name = GameData::Move.get(current_selection.id).real_name
	  imagepath = "Graphics/UI/OV HUD/#{name}" if !current_selection.is_a?(Pokemon::Move)
	  imagepath = "Graphics/UI/OV HUD/#{current_selection.id}" if current_selection.is_a?(Pokemon::Move)
	  image = imagepath if pbResolveBitmap(imagepath)
	  image = "Graphics/UI/OV HUD/#{current_selection.type}" if pbResolveBitmap("Graphics/UI/OV HUD/#{current_selection.type}") if image.nil?
	  name = name.slice(0, 10) if name.length > 10
	  
	  
	  @sprites["ball_icon"].item=nil
      @sprites["other_icon"].name = image
	  @sprites["pkmn_icon"].pokemon=nil
      @sprites["durawindow"].baseColor  = Color.new(255,182,66)
	  text4 = "#{current_selection.pp}/#{current_selection.total_pp}"
	  @sprites["durawindow"].text = text4
      @sprites["durawindow"].resizeToFit(text4)

	  text5 = ""   
	  if !$PokemonGlobal.cur_stored_pokemon.nil?
	    moves =  $PokemonGlobal.cur_stored_pokemon.totalMoves
		index = moves.index(current_selection)
	    text5 = "#{index+1}"
	  end
	  @sprites["waterwindow"].text = text5
      @sprites["waterwindow"].resizeToFit(text5)
	  return name 
  end
 
  def refreshSymbol(current_selection)
      clearPokemonSelection
	  name = get_current_symbol_name(current_selection)
	  imagepath = "Graphics/UI/OV HUD/#{name}"
	  image = imagepath if pbResolveBitmap(imagepath)
	  @sprites["ball_icon"].item=nil if current_selection != :BATTLE && current_selection != :TOOL && current_selection != :WEAPONS 
	  @sprites["ball_icon"].item=:POTION if current_selection == :BATTLE
	  @sprites["ball_icon"].item=:ORANBERRY if current_selection == :CROPS
	  @sprites["ball_icon"].item=:BLUEFLUTE if current_selection == :TOOL
	  @sprites["ball_icon"].item=:BLACKBELT if current_selection == :WEAPONS
      @sprites["other_icon"].name=image  if current_selection != :BATTLE && current_selection != :TOOL && current_selection != :WEAPONS 
	  @sprites["pkmn_icon"].pokemon=nil
      @sprites["durawindow"].baseColor  = Color.new(255,182,66)
	  @sprites["durawindow"].text = ""
      @sprites["durawindow"].resizeToFit("")
	  @sprites["waterwindow"].text = "" 
      @sprites["waterwindow"].resizeToFit("")
	  return name 
  end 
  
  def refreshString(name)
     clearPokemonSelection
	 imagepath = "Graphics/UI/OV HUD/#{name}"
	 image = imagepath if pbResolveBitmap(imagepath)
	 name = name.slice(0, 10) if name.length > 10
	 @sprites["ball_icon"].item=nil
	 @sprites["pkmn_icon"].pokemon=nil
	 @sprites["other_icon"].name=image
     @sprites["durawindow"].baseColor  = Color.new(255,182,66)
	 @sprites["durawindow"].text = ""
     @sprites["durawindow"].resizeToFit("")
	 @sprites["waterwindow"].text = ""
     @sprites["waterwindow"].resizeToFit("")
	 return name 
  end 
  
  def clearPokemonSelection
	 if $PokemonGlobal.selected_pokemon[0] != 0
	  $PokemonGlobal.selected_pokemon[0] = 0 
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}#{$PokemonGlobal.selected_pokemon[0]&.name}") if $PokemonGlobal.selected_pokemon[0]!=0
	 end
     @sprites["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
	 return nil
  end 
  
  def refreshText(current_selection, name)
    if current_selection.is_a?(ItemData)
	  cur_qty=$bag.quantity(current_selection) 
	  if cur_qty > 0
		case cur_qty.to_s.length
		  when 1
		  @sprites["amt"].x = @x_position - 24 + 46
		  when 2
		  @sprites["amt"].x = @x_position - 24 + 40
		  when 3
		  @sprites["amt"].x = @x_position - 24 + 36
		end
	  end
	end 


	@sprites["namewindow"].text=name if name && @sprites["namewindow"].text!=name
	
	if !cur_qty.nil?
	  @sprites["amt"].text = "x#{cur_qty}" if cur_qty>0 && @sprites["namewindow"].text!="x#{cur_qty}"
	  @sprites["amt"].text = "" if cur_qty==0 && @sprites["namewindow"].text!=""
	else
	  @sprites["amt"].text = ""
	end
	return cur_qty
  end 
  
  
  def refreshPunchQuickAccess
     if $player.quick_access.is_a?(Pokemon)
	    refreshPokemon($player.quick_access)
	 elsif $player.quick_access.is_a?(ItemData)
	    refreshItem($player.quick_access)
	 elsif $player.quick_access.is_a?(Pokemon::Move)
	    refreshMove($player.quick_access)
	 elsif $player.quick_access.is_a?(Symbol)
	   refreshSymbol($player.quick_access)
	 end
  end
  
  def refreshInteractQuickAccess
     refreshString("Pick Up")
  end
  
  def refreshBox
	refresh_window
	if !$game_temp.in_inventory && (override? || (Input.press?(Input::PUNCH) && $player.quick_access != $PokemonGlobal.cur_stored_pokemon))
	 if Input.press?(Input::PUNCH) && $player.quick_access != $PokemonGlobal.cur_stored_pokemon
	  name =  refreshPunchQuickAccess
	 else
	  name =  refreshInteractQuickAccess
	 end
	  cur_qty = refreshText($player.quick_access, name)
	else
    current_selection = getCurrentSelection
    case current_selection
       when Pokemon
	     name = refreshPokemon(current_selection)
	   when ItemData
	     name = refreshItem(current_selection)
	   when Pokemon::Move
	     name = refreshMove(current_selection)
	   when Symbol
	     name = refreshSymbol(current_selection)
	   when String
	     name = refreshString(current_selection)
	   else 
	     name = clearPokemonSelection
    end 
	cur_qty = refreshText(current_selection, name)
	
	if name
	 @previous_name = name
	 @previous_amount = cur_qty
	end 
	end
	overlay=@sprites["overlay"].bitmap
	overlay.clear
  end 
  

  

  def get_current_symbol_name(symbol)
    case symbol
    when :MULTISELECT
     name = "Multi Sel"
    when :BATTLE
     name = "Consumable"
    when :TOOL
     name = "Tools"
    when :WEAPONS
     name = "Weapons"
    when :PKMN
     name = "Pokemon"
    when :PLACE
     name = "Placeable"
    when :FAVORITES
     name = "Favorites"
    when :RADIAL
     name = "Home"
    when :CROPS
     name = "Crops"
    when :PUNCH
     name = "Punch"
    else
     name = "None"
    end
	return name
  end 
 
  def override?
   return false if !Input.press?(Input::RUNNING)
   player = get_cur_player
   x = player.x
   y = player.y

   case player.direction
   when 2 then y += 1
   when 4 then x -= 1
   when 6 then x += 1
   when 8 then y -= 1
   end

   event_id = $game_map.check_event(x, y)
   event = $game_map.events[event_id]
   return true if event && event.respond_to?(:type) && event.type.is_a?(ItemData)
   return false
  end 
end 