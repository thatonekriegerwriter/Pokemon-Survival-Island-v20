

#===============================================================================
#
#===============================================================================
class PokemonItemSummary_Scene
  def pbStartScreen(item)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
	@item = item
	item_name = GameData::Item.try_get(item).name
	item_name = item_name.slice(0, 10) if item_name.length > 11
	item_desc = GameData::Item.try_get(item).description
    @rightmost = Graphics.width
    @bottommost = Graphics.height
    @sprites = {}
    @sprites["nubg"] = IconSprite.new(0,0,@viewport)
    @sprites["nubg"].setBitmap("Graphics/Pictures/notebookbg2")
    @sprites["box"]=IconSprite.new(60,80,@viewport)
    @sprites["box"].setBitmap("Graphics/Pictures/craftingMenu/bgBox")
    @sprites["box"]=IconSprite.new(60,80,@viewport)
    @sprites["box"].setBitmap(GameData::Item.icon_filename(@item))


    @sprites["ItemText"]=Window_UnformattedTextPokemon.new(item_name)
    pbPrepareWindow(@sprites["ItemText"])
    @sprites["ItemText"].viewport=@viewport
    @sprites["ItemText"].windowskin=nil
    @sprites["ItemText"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["ItemText"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["ItemText"].resizeToFit(item_name)
    @sprites["ItemText"].x = 40
    @sprites["ItemText"].y = 33
	
    @sprites["ItemTextDesc"]=Window_UnformattedTextPokemon.new(item_desc)
    pbPrepareWindow(@sprites["ItemTextDesc"])
    @sprites["ItemTextDesc"].viewport=@viewport
    @sprites["ItemTextDesc"].windowskin=nil
    @sprites["ItemTextDesc"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["ItemTextDesc"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["ItemTextDesc"].width=180
    @sprites["ItemTextDesc"].height=500
    @sprites["ItemTextDesc"].x = 0
    @sprites["ItemTextDesc"].y = 140
    @sprites["ItemTextDesc"].resizeToFit(item_desc,@sprites["ItemTextDesc"].width)
    @sprites["ItemTextDesc"].x = 0
    @sprites["ItemTextDesc"].y = 140
	
	
	
	if true
    width = 150
	height = 15
    fillWidth = width-2
    fillHeight = height-2
    @sprites["durabilitybarborder"] = BitmapSprite.new(width,height,@viewport)
	@sprites["durabilitybarborder"].visible = false
	if !@item.durability.nil? && !(GameData::Item.get(@item).is_foodwater?  || GameData::Item.get(@item).is_berry?)
	x=440
	y=80
    @sprites["durabilitybarborder"].x = x-width/2
    @sprites["durabilitybarborder"].y = y-height/2
    @sprites["durabilitybarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )


    hpColors = Color.new(255,182,66)
    shadowHeight = 1
    @sprites["durabilitybarborder"].zoom_x = 0.80
    @sprites["durabilitybarborder"].zoom_y = 0.80
    @sprites["durabilitybarborder"].visible = true
    @sprites["durabilitybarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["durabilitybarfill"].zoom_x = 0.80
    @sprites["durabilitybarfill"].zoom_y = 0.80
	 durability = 100 if @item.durability.nil?
	 durability = @item.durability if @item.durability
    fillAmount = durability==0  ? 0 : (
      durability*@sprites["durabilitybarfill"].bitmap.width/100
    )
    @sprites["durabilitybarfill"].x = x-fillWidth/2
    @sprites["durabilitybarfill"].y = y-fillHeight/2
    @sprites["durabilitybarfill"].bitmap.fill_rect(
      Rect.new(0,shadowHeight,fillAmount,@sprites["durabilitybarfill"].bitmap.height-shadowHeight), hpColors)

    @sprites["Durability"]=Window_UnformattedTextPokemon.new("Durability:")
    pbPrepareWindow(@sprites["Durability"])
    @sprites["Durability"].viewport=@viewport
    @sprites["Durability"].windowskin=nil
    @sprites["Durability"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Durability"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Durability"].width=180
    @sprites["Durability"].height=100
    @sprites["Durability"].zoom_x = 0.80
    @sprites["Durability"].zoom_y = 0.80
    @sprites["Durability"].x = x
    @sprites["Durability"].y = y-28
    @sprites["Durability"].resizeToFit("Durability:")
	text = "∞" if @item.durability.nil?
	text = "#{@item.durability}/100" if @item.durability
	
    @sprites["Durability1"]=Window_UnformattedTextPokemon.new(text)
    pbPrepareWindow(@sprites["Durability1"])
    @sprites["Durability1"].viewport=@viewport
    @sprites["Durability1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Durability1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Durability1"].windowskin=nil
    @sprites["Durability1"].width=180
    @sprites["Durability1"].height=100
    @sprites["Durability1"].zoom_x = 0.80
    @sprites["Durability1"].zoom_y = 0.80
    @sprites["Durability1"].x = x+86
    @sprites["Durability1"].y = y-28
    @sprites["Durability1"].resizeToFit(text)
    end

	
	
	
    @sprites["waterbarborder"] = BitmapSprite.new(width,height,@viewport)
	@sprites["waterbarborder"].visible = false
	if GameData::BerryPlant::WATERING_CANS.include?(@item.id) && @item.water != false
	x=440
	y=80
    @sprites["waterbarborder"] = BitmapSprite.new(width,height,@viewport)
    @sprites["waterbarborder"].x = x-width/2
    @sprites["waterbarborder"].y = (y-height/2)+40
    @sprites["waterbarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )

	@sprites["waterbarborder"].visible = true

    hpColors = Color.new(0, 84, 119)
    shadowHeight = 1
    @sprites["waterbarborder"].zoom_x = 0.80
    @sprites["waterbarborder"].zoom_y = 0.80
    @sprites["waterbarborder"].visible = true
    @sprites["waterbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["waterbarfill"].zoom_x = 0.80
    @sprites["waterbarfill"].zoom_y = 0.80
	 durability = 100 if @item.water==false
	 durability = @item.water if @item.water!=false
    fillAmount = durability==0  ? 0 : (
      durability*@sprites["waterbarfill"].bitmap.width/100
    )
    @sprites["waterbarfill"].x = x-fillWidth/2
    @sprites["waterbarfill"].y = (y-fillHeight/2)+40
    @sprites["waterbarfill"].bitmap.fill_rect(
      Rect.new(0,shadowHeight,fillAmount,@sprites["waterbarfill"].bitmap.height-shadowHeight), hpColors)

    @sprites["Water"]=Window_UnformattedTextPokemon.new("Water:")
    pbPrepareWindow(@sprites["Water"])
    @sprites["Water"].viewport=@viewport
    @sprites["Water"].windowskin=nil
    @sprites["Water"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Water"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Water"].width=180
    @sprites["Water"].height=100
    @sprites["Water"].zoom_x = 0.80
    @sprites["Water"].zoom_y = 0.80
    @sprites["Water"].x = x+14
    @sprites["Water"].y = y-28+50
    @sprites["Water"].resizeToFit("Water:")
	text = ""
	text = "∞" if @item.water==false
	text = "#{@item.water}/100" if @item.water!=false
	
    @sprites["Water1"]=Window_UnformattedTextPokemon.new(text)
    pbPrepareWindow(@sprites["Water1"])
    @sprites["Water1"].viewport=@viewport
    @sprites["Water1"].windowskin=nil
    @sprites["Water1"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Water1"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Water1"].width=180
    @sprites["Water1"].height=100
    @sprites["Water1"].zoom_x = 0.80
    @sprites["Water1"].zoom_y = 0.80
    @sprites["Water1"].x = x+100
    @sprites["Water1"].y = y-28+50
    @sprites["Water1"].resizeToFit(text)
	end
	end

    @sprites["Flags"]=Window_UnformattedTextPokemon.new("Flags:")
    pbPrepareWindow(@sprites["Flags"])
    @sprites["Flags"].viewport=@viewport
    @sprites["Flags"].windowskin=nil
    @sprites["Flags"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Flags"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Flags"].width=180
    @sprites["Flags"].height=100
    @sprites["Flags"].x = 200
    @sprites["Flags"].y = 38
    @sprites["Flags"].resizeToFit("Flags:")
	theflags = @item.view_flags.join("\n")
	theflags = "None" if theflags== ""
    @sprites["Flags2"]=Window_UnformattedTextPokemon.new(theflags)
    pbPrepareWindow(@sprites["Flags"])
    @sprites["Flags2"].viewport=@viewport
    @sprites["Flags2"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Flags2"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Flags2"].windowskin=nil
    @sprites["Flags2"].width=180
    @sprites["Flags2"].height=300
    @sprites["Flags2"].x = 200
    @sprites["Flags2"].y = 68
    @sprites["Flags2"].resizeToFit(theflags,@sprites["Flags2"].width)



    @sprites["Modifiers"]=Window_UnformattedTextPokemon.new("Modifiers (#{@item.modifiers.length}/#{@item.modifiers.max_length}): ")
    pbPrepareWindow(@sprites["Modifiers"])
    @sprites["Modifiers"].viewport=@viewport
    @sprites["Modifiers"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Modifiers"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Modifiers"].windowskin=nil
    @sprites["Modifiers"].width=180
    @sprites["Modifiers"].height=100
    @sprites["Modifiers"].x = 360
    @sprites["Modifiers"].y = 138
    @sprites["Modifiers"].y -= 100 if !@sprites["durabilitybarborder"].visible && !@sprites["waterbarborder"].visible
    @sprites["Modifiers"].resizeToFit("Modifiers (#{@item.modifiers.length}/#{@item.modifiers.max_length}): ")
	
	
	theflags = @item.modifiers.get_modifiers.join("\n")
	theflags = "None" if theflags== ""
    @sprites["Modifiers2"]=Window_UnformattedTextPokemon.new(theflags)
    pbPrepareWindow(@sprites["Modifiers2"])
    @sprites["Modifiers2"].viewport=@viewport
    @sprites["Modifiers2"].windowskin=nil
    @sprites["Modifiers2"].width=180
    @sprites["Modifiers2"].height=300
    @sprites["Modifiers2"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    @sprites["Modifiers2"].shadowColor=MessageConfig::DARK_TEXT_SHADOW_COLOR
    @sprites["Modifiers2"].x = 360
    @sprites["Modifiers2"].y = 168
    @sprites["Modifiers2"].y -= 100 if !@sprites["durabilitybarborder"].visible && !@sprites["waterbarborder"].visible
    @sprites["Modifiers2"].resizeToFit(theflags,@sprites["Modifiers2"].width)

  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end

  def pbEndScreen
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

end

#===============================================================================
#
#===============================================================================

def pbItemSummaryScreen(item)
  potato = nil
  item = ItemStorageHelper.get_item_data(item) if item.is_a?(Symbol)
  potato = item if item.is_a?(Symbol)
  scene = PokemonItemSummary_Scene.new
  screen = PokemonItemSummaryScreen.new(scene,item)
  screen.pbOperations
  return potato
end


class PokemonItemSummaryScreen
  def initialize(scene,item)
    @scene = scene
	@item = item
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


  def pbOperations
    pbSEPlay("page")
    @scene.pbStartScreen(@item)

      loop do
      Graphics.update
      Input.update
      #pbUpdate
       if Input.trigger?(Input::BACK)
	     pbPlayCloseMenuSE
	     break
	   end
      end
    @scene.pbEndScreen
  end




end

