#===============================================================================
# * Simple HUD - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It displays a HUD with the party icons,
# HP bars, tone (for status) and some small text.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main.
#
#===============================================================================

if defined?(PluginManager) && !PluginManager.installed?("Simple HUD")
  PluginManager.register({                                                 
    :name    => "Simple HUD",                                        
    :version => "3.0",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=390640",             
    :credits => "FL"
  })
end

class PokemonGlobalMetadata
  attr_accessor :hud_selector

  def hud_selector
    @hud_selector = 0 if !@hud_selector
    return @hud_selector
  end
end


class PokemonGlobalMetadata
  attr_writer :ball_hud_enabled #$PokemonGlobal.ball_hud_enabled = true
  attr_writer :ball_hud_index
  attr_writer :ball_hud_type
  attr_writer :ball_hud_item_type
  attr_writer :ball_hud_item_type_old
  attr_writer :ball_hud_pkmn_index
  attr_writer :ball_hud_item_index
  attr_writer :ball_hud_place_index
  attr_writer :ball_hud_pkmn_index_old
  attr_writer :ball_hud_item_index_old

  def ball_hud_enabled
    @ball_hud_enabled = false if !@ball_hud_enabled
    return @ball_hud_enabled
  end

  def ball_hud_index
    return @ball_hud_index || 0
  end









  def ball_hud_type
    return @ball_hud_type || :PKMN
  end




  def ball_hud_item_type
    return @ball_hud_item_type || :PLACE
  end
  def ball_hud_item_type_old
    return @ball_hud_item_type_old || :PLACE
  end
  
  def ball_hud_item_type_toggle
    if @ball_hud_item_type==:PLACE
	  @ball_hud_item_type=:TOOL
	 else
	  @ball_hud_item_type=:PLACE
	 end
  end
  
  def ball_hud_type_toggle
    if @ball_hud_type==:PKMN
	  @ball_hud_type=:ITEM
	 else
	  @ball_hud_type=:PKMN
	 end
  end

  def ball_hud_pkmn_index
    return @ball_hud_pkmn_index || 0
  end

  def ball_hud_item_index
    return @ball_hud_item_index || 0
  end
  def ball_hud_place_index
    return @ball_hud_place_index || 0
  end

  def ball_hud_pkmn_index_old
    return @ball_hud_pkmn_index_old || 0
  end

  def ball_hud_item_index_old
    return @ball_hud_item_index_old || 0
  end
end



class HUD
  # If you wish to use a background picture, put the image path below, like
  # BG_PATH="Graphics/Pictures/battleMessage". I recommend a 512x64 picture.
  # If there is no image, a blue background will be draw.
  BG_PATH="Graphics/Pictures/Hud/Bolt"
  BG_PATH2="Graphics/Pictures/Hud/Heart"

  # Make as 'false' to don't show the blue bar
  USE_BAR=false

  # Make as 'true' to draw the HUD at bottom
  DRAW_AT_BOTTOM=true

  # Make as 'true' to only show HUD in the pause menu
  DRAW_ONLY_IN_MENU=false


  # When above 0, only displays HUD when this switch is on.
  SWITCH_NUMBER = -1

  # Lower this number = more lag.
  FRAMES_PER_UPDATE = 1

  # The size of drawable content.
  BAR_HEIGHT = 64
  
    $old_qty=nil
    $old_ball=nil
    $originalx = nil
	$originaly = nil
  HP_BAR_GREEN    = [Color.new(24,192,32),Color.new(0,144,0)]
  HP_BAR_YELLOW   = [Color.new(250,250,51),Color.new(184,112,0)]
  HP_BAR_RED      = [Color.new(240,80,32),Color.new(168,48,56)]
  STA_BAR_GREEN    = [Color.new(255,182,66),Color.new(0,144,0)]
  STA_BAR_YELLOW   = [Color.new(248,184,0),Color.new(184,112,0)]
  STA_BAR_RED      = [Color.new(240,80,32),Color.new(168,48,56)]
  TEXT_COLORS = [Color.new(72,72,72), Color.new(160,160,160)]
  BACKGROUND_COLOR = Color.new(128,128,192)
  
  @@lastGlobalRefreshFrame = -1
  @@instanceArray = []
  @@tonePerStatus = nil

  attr_reader :lastRefreshFrame

  # Note that this method is called on each refresh, but the texts
  # only will be redrawed if any character change.
  def textsDefined
    ret=[]
    ret[0] = _INTL(" ")
    ret[1] = _INTL(" ")
    return ret
  end

  class RunningData
    attr_reader :hp, :totalhp, :sta, :totalsta

    def initialize
      @hp = $player.playerhealth
      @totalhp = 100
      @sta = $player.playerstamina
      @totalsta = $player.playermaxstamina
    end

  end

  def initialize(viewport1)
    @viewport1 = viewport1
    @sprites = {}
    @sprites2={}
    @sprites3={}
	@sprites4={}
	@sprites5={}
    @yposition = DRAW_AT_BOTTOM ? Graphics.height-64 : 0
    @old_index=nil
    @old_map=nil
    @@instanceArray.compact! 
    @@instanceArray.push(self)
  end

  def showHUD?
    return (
      $player && !$game_temp.in_menu && $PokemonSystem.playermode == 1
    )
  end

  def create
    createSprites
    for sprite in @sprites.values
      sprite.z+=600
    end
    refresh
  end

  def createSprites
    createSTABar(1, 120, @yposition+45, 70, 11)
    createHPBar(2, 40, @yposition+45, 70, 11)
    createBox(3, 440, @yposition+45, 70, 11)
	createSelection(4, 440, @yposition+45, 70, 11)
  end

  def refreshSelection
  
  if $game_temp.current_pkmn_controlled!=false
   if $game_temp.menu_calling && $game_temp.current_pkmn_controlled!=false
        @sprites4["pause"].visible = true
         @sprites4["bar"].visible = true
   else
        @sprites4["pause"].visible = false
         @sprites4["bar"].visible = false
   end
 $game_temp.current_pkmn_controlled.type.moves.each_with_index do |move,index|
        @sprites4["selection#{index}"].visible = true
        @sprites4["item_sel#{index}"].text="#{index+1}. #{move.name}"
        @sprites4["item_sel#{index}"].visible = true
		if index == $PokemonGlobal.hud_selector
        #@sprites4["item_sel#{index}"].x = 420-30
        #@sprites4["selection#{index}"].x = 420-30
        #@sprites4["selection#{index}"].setBitmap("Graphics/Pictures/ov_selection_box2")
		else
        #@sprites4["item_sel#{index}"].x = 420
        #@sprites4["selection#{index}"].x = 420
        #@sprites4["selection#{index}"].setBitmap("Graphics/Pictures/ov_selection_box")
	   end
end
        @sprites4["selection4"].visible = true
        @sprites4["item_sel4"].visible = true
 if 4 == $PokemonGlobal.hud_selector
        #@sprites4["selection4"].setBitmap("Graphics/Pictures/ov_selection_box2")
 
        #@sprites4["item_sel4"].x = 420-30
        #@sprites4["selection4"].x = 420-30
 else
        #@sprites4["selection4"].setBitmap("Graphics/Pictures/ov_selection_box")
        #@sprites4["item_sel4"].x = 420
        #@sprites4["selection4"].x = 420
 
 end
  else

  end
  end



def createSelection(i, x, y, width, height)
 5.times do |i| 
        @sprites4["selection#{i}"]=IconSprite.new(x-30,220+(i*32),@viewport)
        @sprites4["selection#{i}"].setBitmap("Graphics/Pictures/ov_selection_box")
        @sprites4["selection#{i}"].z=9
        @sprites4["selection#{i}"].visible=false
		 if i==4
	    @sprites4["item_sel#{i}"] = Window_UnformattedTextPokemon.newWithSize("5. Interact", x-30,200+(i*32), 270, 64)
		 else
	    @sprites4["item_sel#{i}"] = Window_UnformattedTextPokemon.newWithSize("", x-30,200+(i*32), 270, 64)
		end
        @sprites4["item_sel#{i}"].visible = false
        @sprites4["item_sel#{i}"].z=10
	    @sprites4["item_sel#{i}"].windowskin  = nil
end
	    @sprites4["pause"] = Window_UnformattedTextPokemon.newWithSize("PAUSE", Graphics.width/2-40,Graphics.height/2-70, 270, 64)
        @sprites4["pause"].visible = false
	    @sprites4["pause"].windowskin  = nil
        @sprites4["pause"].z=99
		@sprites4["bar"]=IconSprite.new(0,0,@viewport1)
    @sprites4["bar"].setBitmap("Graphics/Pictures/loadslotsbg")
    @sprites4["bar"].visible = false
        @sprites4["bar"].z=98

end

def createBox(i, x, y, width, height)
   if @sprites2["hud_bg"].nil?
	    getCurrentItemOrder
		if $ball_order[$PokemonGlobal.ball_hud_index].nil?
		 $PokemonGlobal.ball_hud_index = 0
		end
        cur_ball=$PokemonGlobal.ball_hud_index
        @sprites2["hud_bg"]=IconSprite.new(x-22,270,@viewport)
        @sprites2["hud_bg"].setBitmap("Graphics/Pictures/OW_Catch_UI")
        @sprites2["hud_bg"].z=9
        @sprites2["ball_icon"]=ItemIconSprite.new(x+24,288+24,nil,@viewport)
        @sprites2["ball_icon"].blankzero = true
        @sprites2["ball_icon"].z=9
		
        #@sprites5["ball_icon2"]=IconSprite.new(49,-25,nil,@viewport)
       # @sprites5["ball_icon2"].setBitmap("Graphics/Pictures/dropdownstuff")
       # @sprites5["ball_icon2"].z=9
       # @sprites5["ball_icon2"].visible=false
		#keyname = get_keyname("Control Pokemon")
	   # @sprites5["ball_icon2window"] = Window_UnformattedTextPokemon.newWithSize("#{keyname}", 46, 25, 270, 64)
        #@sprites5["ball_icon2window"].visible = false
	   # @sprites5["ball_icon2window"].windowskin  = nil
       # @sprites5["ball_icon2window"].z=9
		
        @sprites2["pkmn_icon"]=PokemonIconSprite.new(nil, @viewport)
        @sprites2["pkmn_icon"].x=x-4
        @sprites2["pkmn_icon"].y=288-14
        @sprites2["pkmn_icon"].z=9
        @sprites2["overlay"]=BitmapSprite.new(48,48,@viewport)
        @sprites2["overlay"].x=x
        @sprites2["overlay"].y=288
        @sprites2["overlay"].z=9
        pbSetSystemFont(@sprites2["overlay"].bitmap)

		if $ball_order[cur_ball].is_a?(Symbol)==false	
        @sprites2["pkmn_icon"].pokemon=$ball_order[cur_ball]
		else
        @sprites2["ball_icon"].item=$ball_order[cur_ball]
		end
		
		
		
	    @sprites2["namewindow"] = Window_UnformattedTextPokemon.newWithSize("", x-24, 240, 270, 64)
        @sprites2["namewindow"].visible = true
	    @sprites2["namewindow"].windowskin  = nil
		
		
		
        overlay=@sprites2["overlay"].bitmap
        overlay.clear
		
		 if $ball_order[cur_ball].is_a?(Symbol)==false	
		    cur_qty = 0
		 else 
           cur_qty=$bag.quantity($ball_order[cur_ball])
		 end
		 
	    @sprites2["amt"] = Window_UnformattedTextPokemon.newWithSize("", x-24+46, 240+66, 270+1, 200)
		$originalx = x
		$originaly = y
        @sprites2["amt"].visible = true
	    @sprites2["amt"].windowskin  = nil
		
		
		
	    if $PokemonGlobal.ball_hud_enabled==false
		 hideBallHUD
		end
end

end
  def createSTABar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["hpbarborder#{i}"].x = x-width/2
    @sprites["hpbarborder#{i}"].y = y-height/2
        @sprites["hpbarborder#{i}"].z=9
	
    @sprites["bar"]=IconSprite.new((@sprites["hpbarborder#{i}"].x-5),(@sprites["hpbarborder#{i}"].y-8),@viewport1)
    @sprites["bar"].setBitmap(BG_PATH)
    @sprites["bar"].visible = false
    @sprites["bar"].z = 9
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites["hpbarborder#{i}"].visible = false
    @sprites["hpbarfill#{i}"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["hpbarfill#{i}"].x = x-fillWidth/2
    @sprites["hpbarfill#{i}"].y = y-fillHeight/2
        @sprites["hpbarfill#{i}"].z=9
  end
  
  def createHPBar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["hpbarborder#{i}"].x = x-width/2
    @sprites["hpbarborder#{i}"].y = y-height/2
        @sprites["hpbarborder#{i}"].z=9
    @sprites["bar2"]=IconSprite.new((@sprites["hpbarborder#{i}"].x-5),(@sprites["hpbarborder#{i}"].y-7),@viewport1)
    @sprites["bar2"].setBitmap(BG_PATH2)
    @sprites["bar2"].visible = false
    @sprites["bar2"].z = 9
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites["hpbarborder#{i}"].visible = false
    @sprites["hpbarfill#{i}"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["hpbarfill#{i}"].x = x-fillWidth/2
    @sprites["hpbarfill#{i}"].y = y-fillHeight/2
        @sprites["hpbarfill#{i}"].z=9
  end

  def createOverlay
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,BAR_HEIGHT,@viewport1)
    @sprites["overlay"].y = @yposition
    pbSetSystemFont(@sprites["overlay"].bitmap)
  end
  
  def refresh
    refreshSTABar(1, 120, @yposition+45, 70, 11)
    refreshHPBar(2, 40, @yposition+45, 70, 11)
	#puts $game_temp.lockontarget!=false && !@sprites3.empty?
	
	createHPLevel(80, 10) if $game_temp.lockontarget!=false && @sprites3.empty?
	refreshHPLevel(80, 10) if $game_temp.lockontarget!=false && !@sprites3.empty?
	
	createSelection(4, 440, @yposition+45, 70, 11) if @sprites4.empty? && $game_temp.current_pkmn_controlled!=false
	refreshSelection if !@sprites4.empty? && $game_temp.current_pkmn_controlled!=false
	destroyHPHUD if $game_temp.lockontarget==false && !@sprites3.empty?
	destroySelectionHUD if $game_temp.current_pkmn_controlled==false && !@sprites4.empty?
	if $PokemonGlobal.ball_hud_enabled==true
      refreshBox(3)
    end
  end

  def refreshBox(i)
      return if $ball_order[$PokemonGlobal.ball_hud_index].nil?
      cur_qty = 0
	  getCurrentItemOrder
	  if @old_map!=$game_map.map_id
	    #old_item = $old_ball
		#@old_map=$game_map.map_id
	  end
      cur_ball=$PokemonGlobal.ball_hud_index
	  
	    if $ball_order[cur_ball].nil?
		  cur_ball=0
		end
	    if $ball_order[cur_ball].nil?
		  $PokemonGlobal.ball_hud_type= :ITEM if $PokemonGlobal.ball_hud_type==:PKMN
		  $PokemonGlobal.ball_hud_type= :PKMN if $PokemonGlobal.ball_hud_type==:ITEM
	      getCurrentItemOrder
		  cur_ball=0
		end
	    if $ball_order[cur_ball].is_a?(Symbol)==false	
		  object = nil
         @sprites2["pkmn_icon"].pokemon=nil
		else
	    object = GameData::Item.try_get($ball_order[cur_ball]) 
        @sprites2["ball_icon"].item=nil
		end
		
		
		if $ball_order[cur_ball].is_a?(Symbol)==false
        name = GameData::Species.try_get($ball_order[cur_ball].species).real_name
        name = name.slice(0, 10) if name.length > 10
		 formname = $ball_order[cur_ball].species_data.form_name
		 if !formname.nil? 
		 name = "#{name} (#{formname.slice(0, 1)})"
		 end
        @sprites2["pkmn_icon"].pokemon=$ball_order[cur_ball]
       @sprites2["ball_icon"].item=nil

		 if $ball_order[cur_ball].egg?
		 name = "???"
         end
		else
		name = object.name
       name = name.slice(0, 10) if name.length > 10
       @sprites2["ball_icon"].item=$ball_order[cur_ball]
       @sprites2["pkmn_icon"].pokemon=nil
		end
		if @sprites2["namewindow"].text!=name
	    @sprites2["namewindow"].text=name
		end
		
		formname = ""
		
		if $ball_order[cur_ball].is_a?(Symbol)==false	
		    cur_qty = 0
          # @sprites5["ball_icon2"].visible=$ball_order[cur_ball].inworld
          # @sprites5["ball_icon2window"].text = get_keyname("Control Pokemon")
         #  @sprites5["ball_icon2window"].visible=$ball_order[cur_ball].inworld
		else 
           cur_qty=$bag.quantity($ball_order[cur_ball])
		end
		
      return if $old_ball==name && $old_qty==cur_qty
      $old_ball = name
      $old_qty = cur_qty
	  
        overlay=@sprites2["overlay"].bitmap
        overlay.clear
		if $old_qty > 0
		case $old_qty.to_s.length
		  when 1
		  @sprites2["amt"].x = $originalx-24+46
		  when 2
		  @sprites2["amt"].x = $originalx-24+40
		  when 3
		  @sprites2["amt"].x = $originalx-24+36
		end
		@sprites2["amt"].text = "x#{$old_qty}"
		else
		@sprites2["amt"].text = ""
       end
  end

  def refreshSTABar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"].visible = $player.playerstamina!=nil
    @sprites["bar"].visible = @sprites["hpbarborder#{i}"].visible
    @sprites["hpbarfill#{i}"].visible = @sprites["hpbarborder#{i}"].visible
    @sprites["hpbarfill#{i}"].bitmap.clear
    fillAmount = ($player.playerstamina==0 || $player.playermaxstamina==0) ? 0 : (
      $player.playerstamina*@sprites["hpbarfill#{i}"].bitmap.width/$player.playermaxstamina
    )
    # Always show a bit of HP when alive
    return if fillAmount <= 0
    hpColors = Color.new(255,182,66)
    shadowHeight = 2
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfill#{i}"].bitmap.height-shadowHeight
      ), hpColors
    )
  end


  def refreshHPBar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"].visible = $player.playerhealth!=nil
    @sprites["bar2"].visible = @sprites["hpbarborder#{i}"].visible
    @sprites["hpbarfill#{i}"].visible = @sprites["hpbarborder#{i}"].visible
    @sprites["hpbarfill#{i}"].bitmap.clear
    fillAmount = ($player.playerhealth==0 || $player.playermaxhealth==0) ? 0 : (
      $player.playerhealth*@sprites["hpbarfill#{i}"].bitmap.width/$player.playermaxhealth
    )
    # Always show a bit of HP when alive
    return if fillAmount <= 0
    hpColors = hpBarCurrentColors($player.playerhealth, $player.playermaxhealth)
    shadowHeight = 2
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfill#{i}"].bitmap.height-shadowHeight
      ), hpColors[0]
    )



  end





def createHPLevel(width, height)
if $game_temp.lockontarget!=false
     event = $game_temp.lockontarget
    fillWidth = width-4
    fillHeight = height-4
    @sprites3["hpbarborder#{event.id}"] = BitmapSprite.new(width,height,@viewport1)
    @sprites3["hpbarborder#{event.id}"].x = 25
    @sprites3["hpbarborder#{event.id}"].y = 40
	x=25
	y=40
   # @sprites3["bar"]=IconSprite.new((@sprites3["hpbarborder#{event.id}"].x-1),(@sprites3["hpbarborder#{event.id}"].y-8),@viewport1)
   # @sprites3["bar"].setBitmap(BG_PATH)
   # @sprites3["bar"].visible = false
   # @sprites3["bar"].z = 9
    @sprites3["hpbarborder#{event.id}"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites3["hpbarborder#{event.id}"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites3["hpbarborder#{event.id}"].visible = false


    @sprites3["hpbarfill#{event.id}"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites3["hpbarfill#{event.id}"].x = x+2
    @sprites3["hpbarfill#{event.id}"].y = y+2
    text = ""
	
	
	@sprites3["namewindow#{event.id}"] = Window_UnformattedTextPokemon.newWithSize(text, 10, 1, 270, 64)
    @sprites3["namewindow#{event.id}"].visible = false
	@sprites3["namewindow#{event.id}"].windowskin  = nil
end


end




def refreshHPLevel(width, height)
if $game_temp.lockontarget!=false
  event = $game_temp.lockontarget
  createHPLevel(80, 10) if @sprites3["namewindow#{event.id}"].nil?

    text = "#{event.pokemon.name}"
   if $bag.has?(:HPDETECTOR)
    fillWidth = width-4
    fillHeight = height-4
    totalhp = event.pokemon.totalhp
    hp = event.pokemon.hp
	puts totalhp
	puts hp
    @sprites3["hpbarborder#{event.id}"].visible = hp!=nil
    #@sprites3["bar"].visible = @sprites3["hpbarborder#{event.id}"].visible
	
	
	
    @sprites3["hpbarfill#{event.id}"].visible = @sprites3["hpbarborder#{event.id}"].visible
    @sprites3["hpbarfill#{event.id}"].bitmap.clear
	
	
    fillAmount = (hp==0 || totalhp==0) ? 0 : (event.pokemon.hp*@sprites3["hpbarfill#{event.id}"].bitmap.width/totalhp)
    # Always show a bit of HP when alive
    return if fillAmount <= 0
	
    hpColors = hpBarCurrentColors(hp, totalhp)
    shadowHeight = 2
    @sprites3["hpbarfill#{event.id}"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @sprites3["hpbarfill#{event.id}"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites3["hpbarfill#{event.id}"].bitmap.height-shadowHeight
      ), hpColors[0]
    )
  end
   if $bag.has?(:LVLDETECTOR)
    text = "#{event.pokemon.name} Lv #{event.pokemon.level}"
end
    @sprites3["namewindow#{event.id}"].visible = true

	@sprites3["namewindow#{event.id}"].text  = text
end


end

  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return HP_BAR_RED
    elsif hp<=(totalhp/2.0)
      return HP_BAR_YELLOW
    end
    return HP_BAR_GREEN
  end




  def refreshOverlay
    newText = textsDefined
    return if newText == @currentTextArray
    @currentTextArray = newText
    @sprites["overlay"].bitmap.clear
    x = Graphics.width-64
    textpos=[
      [@currentTextArray[0],x,6,2,TEXT_COLORS[0],TEXT_COLORS[1]],
      [@currentTextArray[1],x,38,2,TEXT_COLORS[0],TEXT_COLORS[1]]
    ]
    pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)
  end

  def tryUpdate(force=false)
    if showHUD?
      update(force) if @lastRefreshFrame != Graphics.frame_count
    else
      dispose if hasSprites?
    end
  end

  def update(force)
    if hasSprites?
      if (
        force || FRAMES_PER_UPDATE<=1 || 
        Graphics.frame_count%FRAMES_PER_UPDATE==0
      )
        refresh
      end
	if $PokemonGlobal.ball_hud_enabled==false
	hideBallHUD
	getCurrentItemOrder
   # @sprites5["ball_icon2"].visible=false
   # @sprites5["ball_icon2window"].visible=false
	elsif $game_temp.current_pkmn_controlled!=false
	hideBallHUD
	getCurrentItemOrder
	else
	revealBallHUD
	getCurrentItemOrder
	end
    else
      create
    end
    pbUpdateSpriteHash(@sprites)
    @lastRefreshFrame = Graphics.frame_count
    self.class.tryUpdateAll if self.class.shouldUpdateAll?
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@sprites2)
    pbDisposeSpriteHash(@sprites3)
  end
  def destroySelectionHUD
  @sprites4.each_key do |key|
    @sprites4[key].visible=false
    @sprites4.delete(key)
  end
   @sprites4={}
   
  end
  
  def destroyHPHUD
  @sprites3.each_key do |key|
    @sprites3[key].visible=false
    @sprites3.delete(key)
  end
   @sprites3={}
   
  end
  
    def revealBallHUD
  @sprites2.each_key do |key|
    @sprites2[key].visible=true
  end
  end
  def hideBallHUD
  @sprites2.each_key do |key|
    @sprites2[key].visible=false
  end
  end

  def hasSprites?
    return !@sprites.empty?
  end

  def recreate
    dispose
    create
  end
  
  class << self
    def shouldUpdateAll?
      return @@lastGlobalRefreshFrame != Graphics.frame_count
    end

    def tryUpdateAll
      @@lastGlobalRefreshFrame = Graphics.frame_count
      for hud in @@instanceArray
        if (
          hud && hud.hasSprites? && 
          hud.lastRefreshFrame < @@lastGlobalRefreshFrame
        )
          hud.tryUpdate 
        end
      end
    end

    def recreateAll
      for hud in @@instanceArray
        hud.recreate if hud && hud.hasSprites?
      end
    end
  end
end

class Spriteset_Map
  alias :initializeOldFL :initialize
  alias :disposeOldFL :dispose
  alias :updateOldFL :update

  def initialize(map=nil)
    $player = $Trainer if !$player # For compatibility with v20 and older
    initializeOldFL(map)
  end

  def dispose
    @hud.dispose if @hud
    disposeOldFL
  end

  def update
    updateOldFL
    @hud = HUD.new(@viewport1) if !@hud
    @hud.tryUpdate
  end
end

# For compatibility with older versions
module GameData
  class Species
    class << self
      if !method_defined?(:icon_filename_from_pokemon)
        def icon_filename_from_pokemon(pkmn)
          pbPokemonIconFile(pkmn)
        end
      end
    end
  end
end

EventHandlers.add(:on_enter_map, :selection_set, 
proc{

  }
)

EventHandlers.add(:on_leave_map, :selection_save,
  proc {
  
  }
)

def getCurrentItemOrder
	maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $PokemonGlobal.ball_hud_type==:PKMN
	if $player.party.length < 1
	 $PokemonGlobal.ball_hud_type=:ITEM 
	end 
     $ball_order=$player.party
	 if $player.party.length < $PokemonGlobal.ball_hud_pkmn_index
	  $PokemonGlobal.ball_hud_pkmn_index=0
	 end
	end
	
	
	
	if $PokemonGlobal.ball_hud_type==:ITEM 
	if maps.include?($game_map.map_id)
	
	
	
    basicitems=$bag.isPlacableinInventory
	 $PokemonGlobal.ball_hud_item_type=:PLACE
	 if basicitems.length < $PokemonGlobal.ball_hud_place_index
	  $PokemonGlobal.ball_hud_place_index=0
	 end
	 
	 $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_place_index
	 
	 
	 if $PokemonGlobal.ball_hud_item_type_old!=$PokemonGlobal.ball_hud_item_type
	 $PokemonGlobal.ball_hud_item_type_old=$PokemonGlobal.ball_hud_item_type
	 end



	else


    basicitems=$bag.isToolinInventory
	 $PokemonGlobal.ball_hud_item_type=:TOOL
	 if basicitems.length < $PokemonGlobal.ball_hud_item_index
	  $PokemonGlobal.ball_hud_item_index=0
	 end
	 

	 
	 if $PokemonGlobal.ball_hud_item_type_old!=$PokemonGlobal.ball_hud_item_type
	 $PokemonGlobal.ball_hud_item_type_old=$PokemonGlobal.ball_hud_item_type
	 end


	end
     
	 
	 if basicitems.length < 1
	 $PokemonGlobal.ball_hud_type=:PKMN
	 return 
	 end 
     $ball_order=basicitems
	 return
	end
end