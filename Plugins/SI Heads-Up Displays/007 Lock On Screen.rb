class LockOnScreen
  def initialize(viewport)
    @viewport = viewport 
	@sprites = {}
    @y_position = Graphics.height-64 + $PokemonSystem.screenposy
    @x_position = 440 + $PokemonSystem.screenposx
	$LockOnScreen = self 
   
  end 
  def createSprites
   # createSelection(@x_position , @yposition, 70, 11)
   createHPLevel(80, 10)
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
  end
  def hasSprites?
    return !@sprites.empty?
  end

  def create
    createSprites
    refresh
  end 

  def refresh
    return unless hasSprites?
    refreshHPLevel(80, 10)
  end
    def hideHPHUD
  @sprites.each_key do |key|
    @sprites[key].visible=false
  end
   
  end
  
  def revealHPHUD
  @sprites.each_key do |key|
    @sprites[key].visible=true
  end
  end 
  
  def update
    pbUpdateSpriteHash(@sprites)
  end 
  
  def createHPLevel(width, height)
    fillWidth = width-4
    fillHeight = height-4
	x=Graphics.width + $PokemonSystem.screenposx - 110
	y=40
    @sprites["hpbarborderevent"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["hpbarborderevent"].x = x
    @sprites["hpbarborderevent"].y = y

    @sprites["hpbarborderevent"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites["hpbarborderevent"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites["hpbarborderevent"].visible = false
    @sprites["hpbarfillevent"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["hpbarfillevent"].x = x+2
    @sprites["hpbarfillevent"].y = y+2
    @sprites["hpbarfillevent"].z = @sprites["hpbarborderevent"].z+1
    text = ""
    @sprites["hpbarfillevent"].visible = false
	@sprites["namewindowevent"] = Window_AdvancedTextPokemon.newWithSize(text, x-30, -5, 270, 64)
    @sprites["namewindowevent"].visible = false
	@sprites["namewindowevent"].windowskin  = nil
end
   
  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return HUD::HP_BAR_RED
    elsif hp<=(totalhp/2.0)
      return HUD::HP_BAR_YELLOW
    end
    return HUD::HP_BAR_GREEN
  end



  def refreshHPLevel(width, height)
   if $game_temp.lockontarget==false
   @sprites["namewindowevent"].visible = false 
    @sprites["hpbarborderevent"].visible = false
    @sprites["hpbarfillevent"].visible = false
    return 
   end
   event = $game_temp.lockontarget
    totalhp = event.pokemon.totalhp if defined?(event.pokemon) && totalhp.nil?
    hp = event.pokemon.hp if defined?(event.pokemon) && hp.nil?
	totalhp = 100 if totalhp.nil?
	hp = 100 if hp.nil?
	 text = event.name.sub(/\..*/, '')
	  text = event.variable.berry.name  if text.downcase == "berryplant" && event.variable && event.variable.berry
	  text = "Farming Plot"  if text.downcase == "berryplant"
	  text = "Torch"  if text.include?("naturaltorch")
	  text = "Torch"  if text.include?("playertorch")
	  text = "A Rock."  if text.include?("A Rock")
	  text = "Ancient Statue"  if text.downcase.include?("ancientstone")
    text = "#{event.pokemon.name}" if defined?(event.pokemon) && !event.pokemon.is_a?(Pokemon)
    text = "#{event.pokemon.name} (#{event.pokemon.gender_symbol})" if defined?(event.pokemon) && event.pokemon.is_a?(Pokemon)
    text = "#{event.pokemon.name} (#{event.pokemon.gender_symbol}) Lv #{event.pokemon.level}" if defined?(event.pokemon) && $bag.has?(:LVLDETECTOR) && event.pokemon.is_a?(Pokemon)
	@sprites["namewindowevent"].text  = text
	@sprites["namewindowevent"].setTextToFit(text)
   @sprites["namewindowevent"].visible = true 
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborderevent"].visible = hp!=nil
    #@sprites["bar"].visible = @sprites["hpbarborderevent"].visible
	
	
	
    @sprites["hpbarfillevent"].visible = @sprites["hpbarborderevent"].visible
    @sprites["hpbarfillevent"].bitmap.clear
	
	
    fillAmount = (hp==0 || totalhp==0) ? 0 : (hp*@sprites["hpbarfillevent"].bitmap.width/totalhp)
    # Always show a bit of HP when alive
    return if fillAmount <= 0
	
    hpColors = hpBarCurrentColors(hp, totalhp)
    shadowHeight = 2
    @sprites["hpbarfillevent"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @sprites["hpbarfillevent"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfillevent"].bitmap.height-shadowHeight
      ), hpColors[0]
    )
   

   



  end


def self.get_lock_on_text
 return if $game_temp.lockontarget==false
 event = $game_temp.lockontarget
      event_name = event.name.sub(/\..*/, '')
	  text = ""
	  text = "One of many Statues that can be found around the Island. They have various uses from Saving, to Teleporting, to leveling up Pokemon."  if event_name.downcase.include?("ancientstone")
	  text = "Your backpack. You should probably grab it."  if event_name.downcase == "backpack"
	  #text = "It is a rock."  if text.downcase == "a rock"
      text = GameData::Item.get(:ACORN).description if event_name.downcase == "tree"
	  text = event.variable.berry_obj.description  if event_name.downcase == "berryplant" && event.variable && event.variable.berry_obj
	  text = "A plot for farming berries and other plants."  if event_name.downcase == "berryplant"
	   if defined?(event.pokemon) && event.pokemon.is_a?(Pokemon)
	    thespecies = GameData::Species.get_species_form(event.pokemon.species, event.pokemon.form)
		if (!customEntry?(thespecies) && $PokemonSystem.entries==0) || Input.trigger?(Input::SHIFT)
	     commands=[]
        commands.push(_INTL("Yes"))
        commands.push(_INTL("No"))
        commands.push(_INTL("Don't ask me this again.")) if $PokemonSystem.entries==0
        msgwindow = pbCreateMessageWindow(nil,nil)
        pbMessageDisplay(msgwindow,_INTL("Would you like to give this Pokemon a custom dex entry?\\wtnp[1]"))
        commandMail = pbShowCommandsssss(nil,nil,msgwindow,commands, -1)
	     pbDisposeMessageWindow(msgwindow)
        if commands[commandMail]==_INTL("Yes")
		
	   vp = Viewport.new(0-$PokemonSystem.screenposx, 0-$PokemonSystem.screenposy, Settings::SCREEN_WIDTH*4, Settings::SCREEN_HEIGHT*4)
	    vp.z = 9999999
     potato=IconSprite.new(0,0,vp)
     potato.setBitmap("Graphics/Pictures/loadslotsbg")
     potato.z=-100000
     base=SpriteWindow_Base.new((Settings::SCREEN_WIDTH/2)-64,(Settings::SCREEN_HEIGHT/2)-64,128,128)
	  base.viewport = vp
     base.z=10
     species = PokemonSprite.new(vp)
     species.setPokemonBitmapSpecies(event.pokemon,thespecies)
	  species.viewport = vp
     species.x=Settings::SCREEN_WIDTH/2
     species.y=Settings::SCREEN_HEIGHT/2
     species.z=11
		      pbDexEntryMenu(thespecies,vp)
	   potato.dispose
	   base.dispose
	   species.dispose
	   vp.dispose
		  elsif commands[commandMail]==_INTL("Don't ask me this again.")
		    $PokemonSystem.entries=1
		  else
		  end
		end
	   text = pbPokedexEntry(thespecies)
	  end
      text = GameData::Item.get(event.pokemon).description if defined?(event.pokemon) && (event.pokemon.is_a?(Symbol) || event.pokemon.is_a?(ItemData))
      text = GameData::Item.get(:TORCH).description if event_name.include?("naturaltorch") || event_name.include?("playertorch")
      text = GameData::Item.get(:ARGOSTBERRY).description if event_name.include?("Argost Berry")
	  text = "You see: #{event_name}." if text == "" || text.nil?


 pbMessage(text)

end


end 


