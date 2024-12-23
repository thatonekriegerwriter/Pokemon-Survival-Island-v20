#===============================================================================
# Main body to handle the the construction and animation of title screen
#===============================================================================
# Main title screen script
# handles the logic of constructing and animating the title screen visuals
class ModularTitleScreen
  attr_reader :sprites2


  TEXTCOLOR             = Color.new(232, 232, 232)
  TEXTSHADOWCOLOR       = Color.new(136, 136, 136)
  MALETEXTCOLOR         = Color.new(56, 160, 248)
  MALETEXTSHADOWCOLOR   = Color.new(56, 104, 168)
  FEMALETEXTCOLOR       = Color.new(240, 72, 88)
  FEMALETEXTSHADOWCOLOR = Color.new(160, 64, 64)
  # class constructor
  # additively adds new visual elements based on the presence of valid symbol
  # entries in the ModularTitle::MODIFIERS array
  def initialize
    # defines viewport
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    # defines sprite hash
    @sprites = {}
    @sprites2 = {}
    @intro = nil
    @currentFrame = 0
    @depth = 0
    @updatechecker = 500
    @mods = ModularTitle::MODIFIERS
    bg = "BG0"
    backdrop = "nil"
    bg_selected = false
    i = 0; o = 0; m = 0
    for mod in @mods
      arg = mod.to_s.upcase
      x = "nil"; y = "nil"; z = "nil"; zoom = "nil"; file = "nil"; speed="nil"
      #-------------------------------------------------------------------------
      # setting up background
      # uses first available background element
      # if no background modifier has been defined, defaults to stock Essentials
      if arg.include?("BACKGROUND:") # loads specific BG graphic
        next if bg_selected
        cmd = arg.split("_").compact
        backdrop = "\"" + cmd[0].gsub("BACKGROUND:","") + "\""
        bg_selected = true
      elsif arg.include?("BACKGROUND") # loads modifier as object
        next if bg_selected
        cmd = arg.split("_").compact
        s = "BG" + cmd[0].gsub("BACKGROUND","")
        if eval("defined?(MTS_Element_#{s})")
          bg = s
          bg_selected = true
        end
      #-------------------------------------------------------------------------
      # setting up intro animation
      # uses first available element
      elsif arg.include?("INTRO:")
        next if !@intro.nil?
        cmd = arg.split("_").compact
        @intro = cmd[0].gsub("INTRO:","")
      #-------------------------------------------------------------------------
      # setting up background overlay
      # multiple overlays can be added
      # order in which they are defined matters for their Z index
      elsif arg.include?("OVERLAY:") # loads specific overlay graphic
        cmd = arg.split("_").compact
        file = cmd[0].gsub("OVERLAY:","")
        # applies positioning modifiers
        for j in 1...cmd.length
          next if cmd.length < 2
          if cmd[j].include?("Z")
            z = cmd[j].gsub("Z","").to_i
          end
        end
        z = nil if z == "nil"
        @sprites["ol#{o}"] = MTS_Element_OLX.new(@viewport,file,z)
        o += 1
      elsif arg.include?("OVERLAY")
        cmd1 = mod.split("_").compact
        cmd2 = cmd1[0].split(":").compact
        s = "OL" + cmd2[0].upcase.gsub("OVERLAY","")
        f = cmd2.length > 1 ? ("\"" + cmd2[1] + "\"") : "nil"
        # applies positioning modifiers
        for j in 1...cmd1.length
          next if cmd1.length < 2
          if cmd1[j].upcase.include?("Z")
            z = cmd1[j].upcase.gsub("Z","").to_i
          elsif cmd1[j].upcase.include?("S")
            speed = cmd1[j].upcase.gsub("S","").to_i
          end
        end
        if eval("defined?(MTS_Element_#{s})") # loads modifier as object
          @sprites["ol#{o}"] = eval("MTS_Element_#{s}.new(@viewport,#{f},#{z},#{speed})")
          o += 1
        end
      #---------------------------------------------------------------------------
      # setting up additional particle effects
      # multiple overlays can be added
      # order in which they are defined matters for their Z index
      elsif arg.include?("EFFECT")
        cmd = arg.split("_").compact
        s = "FX" + cmd[0].gsub("EFFECT","")
        # applies positioning modifiers
        for j in 1...cmd.length
          next if cmd.length < 2
          if cmd[j].include?("X")
            x = cmd[j].gsub("X","")
          elsif cmd[j].include?("Y")
            y = cmd[j].gsub("Y","")
          elsif cmd[j].include?("Z")
            z = cmd[j].gsub("Z","")
          end
        end
        # loads the sprite class
        if eval("defined?(MTS_Element_#{s})") # loads modifier as object
          @sprites["fx#{i}"] = eval("MTS_Element_#{s}.new(@viewport,#{x},#{y},#{z})")
          i += 1
        end
      #---------------------------------------------------------------------------
      # setting up additional particle effects
      # multiple overlays can be added
      # order in which they are defined matters for their Z index
      elsif arg.include?("MISC")
        cmd = mod.split("_").compact
        mfx = cmd[0].split(":").compact
        s = "MX" + mfx[0].upcase.gsub("MISC","")
        file = "\"" + mfx[1] + "\"" if mfx.length > 1
        # applies positioning modifiers
        for j in 1...cmd.length
          next if cmd.length < 2
          if cmd[j].upcase.include?("X")
            x = cmd[j].upcase.gsub("X","")
          elsif cmd[j].upcase.include?("Y")
            y = cmd[j].upcase.gsub("Y","")
          elsif cmd[j].upcase.include?("Z")
            z = cmd[j].upcase.gsub("Z","")
          elsif cmd[j].upcase.include?("S")
            zoom = cmd[j].upcase.gsub("S","")
          end
        end
        # loads the sprite class
        if eval("defined?(MTS_Element_#{s})") # loads modifier as object
          @sprites["mx#{m}"] = eval("MTS_Element_#{s}.new(@viewport,#{x},#{y},#{z},#{zoom},#{file})")
          m += 1
        end
      end
    end
    @sprites["bg"] = eval("MTS_Element_#{bg}.new(@viewport,#{backdrop})")
    #---------------------------------------------------------------------------
    # setting up game logo
    @sprites["logo"] = MTS_Element_Logo.new(@viewport)
    @sprites["logo"].position
    #---------------------------------------------------------------------------
    # setting up gstart splash text
	
    pbFillUpdaterConfig if (GameVersion::POKE_UPDATER_CONFIG).empty?
	text = GameVersion::POKE_UPDATER_CONFIG['CURRENT_GAME_VERSION']
	text = "LATEST" if text == "999999999.9999.9999.9999.999.9999.999" && !text.nil?
	text = Settings::GAME_VERSION if text.nil?
	
	createtextboxesplease("update_ver_text",3,340,"SI-#{text.slice(0, 10)}")
    @sprites["start"] = Sprite.new(@viewport)
    @sprites["start"].bitmap = pbBitmap("Graphics/MODTS/start")
    @sprites["start"].center!
    @sprites["start"].x = @viewport.rect.width/2
    @sprites["start"].x = ModularTitle::START_POS[0] if ModularTitle::START_POS[0].is_a?(Numeric)
    @sprites["start"].y = @viewport.rect.height*0.85
    @sprites["start"].y = ModularTitle::START_POS[1] if ModularTitle::START_POS[1].is_a?(Numeric)
    @sprites["start"].z = 999
    @sprites["start"].visible = false
    @fade = 8
    create_control_elements
    create_save_data_boxes
	create_info_elements
	
	
	
	
	
	
	
	
  end
  def create_info_elements
    @sprites2["download"] = Sprite.new(@viewport)
    @sprites2["download"].bitmap = pbBitmap("Graphics/MODTS/download")
    @sprites2["download"].center!
    @sprites2["download"].x = 35
    @sprites2["download"].y = 35
    @sprites2["download"].z = 1002
    @sprites2["download"].visible = false
    @sprites2["mysterygift"] = Sprite.new(@viewport)
    @sprites2["mysterygift"].bitmap = pbBitmap("Graphics/MODTS/mysterygift")
    @sprites2["mysterygift"].center!
	amt = getUpdate ? @sprites2["download"].width : 0
	@sprites2["download"].width
    @sprites2["mysterygift"].x = 35 + amt
    @sprites2["mysterygift"].y = 22
    @sprites2["mysterygift"].z = 1002
    @sprites2["mysterygift"].visible = false
  
  end
  def create_control_elements
    @sprites2["selectionbox"] = Sprite.new(@viewport)
    @sprites2["selectionbox"].bitmap = pbBitmap("Graphics/MODTS/the box")
    @sprites2["selectionbox"].center!
    @sprites2["selectionbox"].x = @viewport.rect.width/2
    @sprites2["selectionbox"].x = ModularTitle::START_POS[0] if ModularTitle::START_POS[0].is_a?(Numeric)
    @sprites2["selectionbox"].y = @viewport.rect.height*0.85
    @sprites2["selectionbox"].y = ModularTitle::START_POS[1] if ModularTitle::START_POS[1].is_a?(Numeric)
    @sprites2["selectionbox"].z = 1000
    @sprites2["selectionbox"].visible = false
	
    @sprites2["craftResult"]=Window_UnformattedTextPokemon.new("Continue Game")
    pbPrepareWindow(@sprites2["craftResult"])
    @sprites2["craftResult"].z=1001
    @sprites2["craftResult"].windowskin=nil
    @sprites2["craftResult"].width=Graphics.width-48
    @sprites2["craftResult"].height=Graphics.height
	@sprites2["craftResult"].resizeToFit("")
   # @sprites2["craftResult"].ox = @sprites2["craftResult"].width/2
    @sprites2["craftResult"].x = (@viewport.rect.width/2)-70
    @sprites2["craftResult"].y = (@viewport.rect.height*0.85)-25
    @sprites2["craftResult"].baseColor=Color.new(232, 232, 232)
    @sprites2["craftResult"].shadowColor=Color.new(136, 136, 136)
    @sprites2["craftResult"].viewport=@viewport
    @sprites2["craftResult"].visible=false
	
    @sprites2["arrowl"] = Sprite.new(@viewport)
    @sprites2["arrowl"].bitmap = pbBitmap("Graphics/Pictures/selarrowl")
    @sprites2["arrowl"].center!
    @sprites2["arrowl"].x = @sprites2["selectionbox"].x-@sprites2["selectionbox"].bitmap.width/2 - 10
    @sprites2["arrowl"].y = @sprites2["selectionbox"].y
    @sprites2["arrowl"].z = 1002
    @sprites2["arrowl"].visible = false
	
	
    @sprites2["arrowr"] = Sprite.new(@viewport)
    @sprites2["arrowr"].bitmap = pbBitmap("Graphics/Pictures/selarrow")
    @sprites2["arrowr"].center!
    @sprites2["arrowr"].x = @sprites2["selectionbox"].x + @sprites2["selectionbox"].bitmap.width/2 + 10
    @sprites2["arrowr"].y = @sprites2["selectionbox"].y
    @sprites2["arrowr"].z = 1002
    @sprites2["arrowr"].visible = false
	
  
  end




  def pbSetParty(trainer=nil)
    if trainer.nil?
	  return if @sprites2["player"].nil?
	  @sprites2["player"].visible = false
	  6.times do |i|
	   next if @sprites2["party#{i}"].nil?
      @sprites2["party#{i}"].visible = false
	  @sprites2["party#{i}"] = nil
	  
	  end
	  @sprites2["player"] = nil
	  return
	end
    return if !trainer || !trainer.party
    meta = GameData::PlayerMetadata.get(trainer.character_ID)
    if meta
      filename = pbGetPlayerCharset(meta.walk_charset, trainer, true)
      @sprites2["player"] = TrainerWalkingCharSprite.new(filename, @viewport)
      charwidth  = @sprites2["player"].bitmap.width
      charheight = @sprites2["player"].bitmap.height
      @sprites2["player"].x        = 112 - (charwidth / 8)
      @sprites2["player"].y        = 142 - (charheight / 8)
      @sprites2["player"].z        = 1005
      @sprites2["player"].src_rect = Rect.new(0, 0, charwidth / 4, charheight / 4)
    end
    trainer.party.each_with_index do |pkmn, i|
      @sprites2["party#{i}"] = PokemonIconSprite.new(pkmn, @viewport)
      @sprites2["party#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites2["party#{i}"].x = 334 + (66 * (i % 2))
      @sprites2["party#{i}"].y = 142 + (50 * (i / 2))
      @sprites2["party#{i}"].z = 1005
    end
  end


  def set_text_box_text_color(name,basecolor,shadowcolor)
    @sprites2[name].baseColor=basecolor
    @sprites2[name].shadowColor=shadowcolor
  end
  def createtextboxesplease(name,x,y,text=nil)
    @sprites2[name]=Window_UnformattedTextPokemon.new("")
    @sprites2[name].text=text if !text.nil?
    pbPrepareWindow(@sprites2[name])
    @sprites2[name].z=1005
    @sprites2[name].windowskin=nil
    @sprites2[name].width=Graphics.width-48
    @sprites2[name].height=Graphics.height
	@sprites2[name].resizeToFit("")
    @sprites2[name].resizeToFit(text) if !text.nil?
   # @sprites2["craftResult"].ox = @sprites2["craftResult"].width/2
    @sprites2[name].x = x
    @sprites2[name].y = y
    @sprites2[name].baseColor=Color.new(232, 232, 232)
    @sprites2[name].shadowColor=Color.new(136, 136, 136)
    @sprites2[name].viewport=@viewport
    @sprites2[name].visible=false
  
  
  
  end
  
  # trigger for playing the intro animation
  def pbPrepareWindow(window)
    window.letterbyletter=false
  end
  
  
   def set_text(box,text)
    @sprites2[box].text = text
	@sprites2[box].resizeToFit(text)
    @sprites2[box].visible = true if @sprites2[box].visible==false
   # @sprites2["craftResult"].ox = @sprites2["craftResult"].width/2
   end

  
  def create_save_data_boxes
    @sprites2["selectionbox2"] = Sprite.new(@viewport)
    @sprites2["selectionbox2"].bitmap = pbBitmap("Graphics/MODTS/continuebox")
    @sprites2["selectionbox2"].center!
    @sprites2["selectionbox2"].x = @viewport.rect.width/2
    @sprites2["selectionbox2"].y = (@viewport.rect.height/2)-10
    @sprites2["selectionbox2"].z = 1000
    @sprites2["selectionbox2"].visible = false

	createtextboxesplease("savename",60,66)
	createtextboxesplease("savelocation",292,66)
	createtextboxesplease("playername",125,117)
	createtextboxesplease("playerclass",60,162)
	createtextboxesplease("playerhealth",60,192)
	
	@sprites2["star1"] = IconSprite.new(89,  244, @viewport)
	@sprites2["star2"] = IconSprite.new(109, 244, @viewport)
	@sprites2["star3"] = IconSprite.new(129, 244, @viewport)
	@sprites2["star4"] = IconSprite.new(149, 244, @viewport)
	@sprites2["star5"] = IconSprite.new(169, 244, @viewport)
	@sprites2["star1"].setBitmap("Graphics/Pictures/stars1.png")
	@sprites2["star2"].setBitmap("Graphics/Pictures/stars1.png")
	@sprites2["star3"].setBitmap("Graphics/Pictures/stars1.png")
	@sprites2["star4"].setBitmap("Graphics/Pictures/stars1.png")
	@sprites2["star5"].setBitmap("Graphics/Pictures/stars1.png")
	@sprites2["star1"].z = 1009
	@sprites2["star2"].z = 1009
	@sprites2["star3"].z = 1009
	@sprites2["star4"].z = 1009
	@sprites2["star5"].z = 1009
	@sprites2["star1"].visible = false
	@sprites2["star2"].visible = false
	@sprites2["star3"].visible = false
	@sprites2["star4"].visible = false
	@sprites2["star5"].visible = false
	
    @sprites2["choicebox"] = Sprite.new(@viewport)
    @sprites2["choicebox"].bitmap = pbBitmap("Graphics/MODTS/choice box")
    @sprites2["choicebox"].center!
    @sprites2["choicebox"].x = @sprites2["selectionbox2"].bitmap.width-10
    @sprites2["choicebox"].y = @sprites2["selectionbox2"].y+30
    @sprites2["choicebox"].z = 1007
    @sprites2["choicebox"].visible = false
	createtextboxesplease("info",@sprites2["choicebox"].x-54,128)
	createtextboxesplease("veryeasy",@sprites2["choicebox"].x-54,159)
	createtextboxesplease("easy",@sprites2["choicebox"].x-54,189)
	createtextboxesplease("normal",@sprites2["choicebox"].x-54,219)
	createtextboxesplease("hard",@sprites2["choicebox"].x-54,249)
	createtextboxesplease("veryhard",@sprites2["choicebox"].x-54,279)
	createtextboxesplease("return",@sprites2["choicebox"].x-54,309)
   @sprites2["info"].z=1008
   @sprites2["veryeasy"].z=1008
   @sprites2["easy"].z=1008
   @sprites2["normal"].z=1008
   @sprites2["hard"].z=1008 
   @sprites2["veryhard"].z=1008 
   @sprites2["return"].z=1008 
	

	
	
    @sprites2["arrowl2"] = Sprite.new(@viewport)
    @sprites2["arrowl2"].bitmap = pbBitmap("Graphics/Pictures/selarrowl")
    @sprites2["arrowl2"].center!
    @sprites2["arrowl2"].x = @sprites2["selectionbox2"].x-@sprites2["selectionbox2"].bitmap.width/2 - 10
    @sprites2["arrowl2"].y = @sprites2["selectionbox2"].y
    @sprites2["arrowl2"].z = 1005
    @sprites2["arrowl2"].visible = false
	
	
    @sprites2["arrowr2"] = Sprite.new(@viewport)
    @sprites2["arrowr2"].bitmap = pbBitmap("Graphics/Pictures/selarrow")
    @sprites2["arrowr2"].center!
    @sprites2["arrowr2"].x = @sprites2["selectionbox2"].x + @sprites2["selectionbox2"].bitmap.width/2 + 10
    @sprites2["arrowr2"].y = @sprites2["selectionbox2"].y
    @sprites2["arrowr2"].z = 1005
    @sprites2["arrowr2"].visible = false
	
	
	
	
    @sprites2["arrowr3"] = Sprite.new(@viewport)
    @sprites2["arrowr3"].bitmap = pbBitmap("Graphics/Pictures/selarrow")
    @sprites2["arrowr3"].center!
    @sprites2["arrowr3"].x = @sprites2["choicebox"].x - 46
    @sprites2["arrowr3"].y = @sprites2["veryeasy"].y+26
    @sprites2["arrowr3"].z = 1009
    @sprites2["arrowr3"].visible = false
  end

  def pbChoiceBox(commands=nil)
   if commands.nil?
   @sprites2["choicebox"].visible=false
   @sprites2["veryeasy"].visible=false
   @sprites2["easy"].visible=false
   @sprites2["normal"].visible=false
   @sprites2["hard"].visible=false 
   @sprites2["veryhard"].visible=false 
   @sprites2["return"].visible=false 
   @sprites2["arrowr3"].visible = false
   @sprites2["info"].visible = false
   
   else
   if commands.length > 3
    @sprites2["choicebox"].bitmap = pbBitmap("Graphics/MODTS/choice box2")
   else
    @sprites2["choicebox"].bitmap = pbBitmap("Graphics/MODTS/choice box")
   end
   @sprites2["choicebox"].visible=true
    @sprites2["arrowr3"].visible = true
   @sprites2["veryeasy"].visible=true
   @sprites2["easy"].visible=true
   @sprites2["normal"].visible=true if commands.length > 2
   set_text("veryeasy",commands[0])
   puts commands[0]
   puts commands[1]
   puts commands[2]
   set_text("info","Difficulty:") if commands[0] == 'Very Easy'
   set_text("info","Options:") if commands[0] == 'Play'
   set_text("easy",commands[1])
   set_text("normal",commands[2]) if commands.length > 2
   if commands.length > 3
   @sprites2["hard"].visible=true 
   @sprites2["veryhard"].visible=true 
   @sprites2["return"].visible=true 
   set_text("hard",commands[3])
   set_text("veryhard",commands[4])
   set_text("return",commands[5])
   end
   end
  
  
  end
  
  def move_selector_arrow(selection)
    selection = 0 if selection.nil?
    theoptions = [@sprites2["veryeasy"],@sprites2["easy"],@sprites2["normal"],@sprites2["hard"],@sprites2["veryhard"],@sprites2["return"]]
    @sprites2["arrowr3"].y = theoptions[selection].y+26
  end

  def displayboxdisplaymeasavefile(file=nil,header=nil,selected_file=nil)
   if file.nil?
    @sprites2["selectionbox2"].visible=false
	pbSetParty()
    @sprites2["savename"].visible = false
    @sprites2["savelocation"].visible = false
    @sprites2["playername"].visible = false
    @sprites2["playerclass"].visible = false
    @sprites2["playerhealth"].visible = false
    @sprites2["playerclass"].visible = false
    @sprites2["playerhealth"].visible = false
    @sprites2["arrowl2"].visible = false
    @sprites2["arrowr2"].visible = false
	@sprites2["star1"].visible = false
	@sprites2["star2"].visible = false
	@sprites2["star3"].visible = false
	@sprites2["star4"].visible = false
	@sprites2["star5"].visible = false
   elsif file==1
	pbSetParty()
    @sprites2["savename"].visible = false
    @sprites2["savelocation"].visible = false
    @sprites2["playername"].visible = false
    @sprites2["playerclass"].visible = false
    @sprites2["playerhealth"].visible = false
    @sprites2["playerclass"].visible = false
    @sprites2["playerhealth"].visible = false
	@sprites2["star1"].visible = false
	@sprites2["star2"].visible = false
	@sprites2["star3"].visible = false
	@sprites2["star4"].visible = false
	@sprites2["star5"].visible = false
   
   else
    if header=='Load Game'
    @sprites2["arrowl2"].visible = true
    @sprites2["arrowr2"].visible = true
	end
	@sprites2["star1"].visible = true if getSIDataStatus("stars") >=1
	@sprites2["star2"].visible = true if getSIDataStatus("stars") >=2
	@sprites2["star3"].visible = true if getSIDataStatus("stars") >=3
	@sprites2["star4"].visible = true if getSIDataStatus("stars") >=4
	@sprites2["star5"].visible = true if getSIDataStatus("stars") >=5
	date = file[:player].last_time_saved
	 minute = date.min.to_s
	 minute = "0#{date.min}" if minute.length==1
	thetime = "#{date.year}-#{date.month}-#{date.day} #{date.hour}:#{minute}"
    savename = "#{selected_file}"
    savename += " - #{thetime}"
	
	
	
#[:player].last_time_saved
    mapid = file[:map_factory].map.map_id
    @sprites2["selectionbox2"].visible=true
	pbSetParty(file[:player])
	set_text("savename",savename)
	set_text("savelocation",pbGetMapNameFromId(mapid))
    if file[:player].male?
	  basecolor = MALETEXTCOLOR
	  shadowcolor = MALETEXTSHADOWCOLOR
    elsif file[:player].female?
	  basecolor = FEMALETEXTCOLOR
	  shadowcolor = FEMALETEXTSHADOWCOLOR
    else
	  basecolor = TEXTCOLOR
	  shadowcolor = TEXTSHADOWCOLOR
    end
	set_text_box_text_color("playername",basecolor,shadowcolor)
	set_text("playername",file[:player].name)
	classy = file[:player].playerclass.name.to_s if file[:player].playerclass.respond_to?("name")
	classy = file[:player].playerclass.to_s if !file[:player].playerclass.respond_to?("name")
	set_text("playerclass","Class:    #{classy}")
	set_text("playerhealth","Health:    #{file[:player].playerhealth.to_i.to_s}/#{file[:player].playermaxhealth.to_i.to_s}")
  
   
   
   end
  
  end
  def generic_update(box,text)
	  set_text(box,text)
	  update
      Graphics.update
  
  end
  def move_arrowr(box,text)
  
      Graphics.update
    2.times do 
	update
      Graphics.update
	  @sprites2["arrowr"].x += 5
	  update
      Graphics.update
	end
	  set_text(box,text)
	  update
      Graphics.update
    2.times do 
	  update
      Graphics.update
	  @sprites2["arrowr"].x -= 5
	   update
      Graphics.update
	end
	  update
      Graphics.update
  end
  def move_arrowl(box,text)
	  update
      Graphics.update
    2.times do 
	  update
      Graphics.update
	  @sprites2["arrowl"].x -= 5
	  update
      Graphics.update
	end
	  set_text(box,text)
	  update
      Graphics.update
    2.times do 
	  update
      Graphics.update
	  @sprites2["arrowl"].x += 5
	  update
      Graphics.update
	end
	  update
      Graphics.update
  end

  def move_arrowr2(file=nil,header=nil,selected_file=nil)
  
	  update
      Graphics.update
    2.times do 
	update
	  update
      Graphics.update
	  @sprites2["arrowr2"].x += 5
	  update
      Graphics.update
	end
      displayboxdisplaymeasavefile(file,header,selected_file)
	  
	  update
      Graphics.update
    2.times do 
	  update
      Graphics.update
	  @sprites2["arrowr2"].x -= 5
	   update
      Graphics.update
	end
	  
	  update
      Graphics.update
  end
  def move_arrowl2(file=nil,header=nil,selected_file=nil)
	  update
      Graphics.update
    2.times do 
	  update
      Graphics.update
	  @sprites2["arrowl2"].x -= 5
	  update
      Graphics.update
	end
     displayboxdisplaymeasavefile(file,header,selected_file)
	  update
      Graphics.update
    2.times do 
	  update
      Graphics.update
	  @sprites2["arrowl2"].x += 5
	  update
      Graphics.update
	end

	  update
      Graphics.update
  end

  
  def intro
    @sprites2["selectionbox"].visible = true if @depth>0
    @sprites2["selectionbox"].visible = false if @depth==0
    if eval("defined?(MTS_INTRO_ANIM#{@intro})")
      intro = eval("MTS_INTRO_ANIM#{@intro}.new(@viewport,@sprites)")
    else
      intro = MTS_INTRO_ANIM.new(@viewport,@sprites)
    end
    @currentFrame = intro.currentFrame
    @sprites["start"].visible = true if @depth==0
    @sprites["start"].visible = false if @depth>0
  end
  def hide
   @viewport.visible=false
  end
  def show
   @viewport.visible=true
  end
  
  # main update for all the visual elements
  
  
  def updateElements
    for key in @sprites.keys
      @sprites[key].update if @sprites[key].respond_to?(:update)
    end
	if @depth==0
    for key in @sprites2.keys
	  @sprites2[key].visible = false 
	end
	@sprites["start"].visible = true if @sprites["start"].visible == false
    @sprites["start"].opacity -= @fade
    @fade *= -1 if @sprites["start"].opacity <= 0 || @sprites["start"].opacity >= 255
	else 
	return if @sprites.empty?
	@sprites["start"].visible = false if @sprites["start"].visible == true
	return if @sprites2.empty?
	
    @sprites2["update_ver_text"].visible = true
	@sprites2["selectionbox"].visible = true if @sprites2["selectionbox"].visible == false
    @sprites2["craftResult"].visible = true if @sprites2["craftResult"].visible == false
	@sprites2["arrowl"].visible = true if @sprites2["arrowl"].visible == false
    @sprites2["arrowr"].visible = true if @sprites2["arrowr"].visible == false
	if @updatechecker==0 || $DEBUG && Input.press?(Input::CTRL)
    @sprites2["download"].visible = getUpdate
    @sprites2["mysterygift"].visible = isthereagift
	@updatechecker=2000
	puts "The Update Checker Ran"
	else
	@updatechecker-=1
	end
	end
  end
  
   def depth(amt)
    @depth=amt
   end
  # update for title screen functionality
  def update
    @currentFrame += 1
    self.updateElements
    if !@totalFrames.nil? && @totalFrames >= 0 && @currentFrame >= @totalFrames
    end
  end
  # disposes of all visual elements
  def dispose
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@sprites2)
    @viewport.dispose
  end
  # plays appropriate BGM
  def playBGM
    #---------------------------------------------------------------------------
    # setting up BGM
    # uses first available BGM modifier
    # if no BGM modifier has been defined, defaults to stock system
    bgm = nil
    for mod in @mods
      arg = mod.to_s.upcase
      if arg.include?("BGM:") # loads specific BG graphic
        bgm = arg.gsub("BGM:","")
        break
      end
    end
    # loads data
    bgm = $data_system.title_bgm.name if bgm.nil?
    @totalFrames = (getPlayTime("Audio/BGM/"+bgm).floor - 1) * Graphics.frame_rate
  end
  # function to restart the game when BGM times out
  def restart

  end
end
#===============================================================================
