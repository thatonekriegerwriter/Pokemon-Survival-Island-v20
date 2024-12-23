class PlayerClass
  attr_accessor :id
  attr_accessor :name
  attr_accessor :acted_class
  attr_accessor :actorcooldown


  def initialize(id)
     @id           = id
     @name           = getName
     @acted_class   = :NONE
     @actorcooldown = false
  end
  
  def getName
      case @id
	    when :TRIATHLETE 
		  return "Tri-Athlete"
	    when :ACTOR
		  return "Actor"
	    when :EXPERT#$game_variables
		  return "Expert"
	    when :RANGER
		  return "Ranger"
	    when :BLACKBELT
		  return "Blackbelt"
	    when :COORDINATOR
		  return "Coordinator"
	    when :ENGINEER
		  return "Engineer"
	    when :NURSE
		  return "Nurse"
	    when :BREEDER
		  return "Breeder"
	    when :COLLECTOR
		  return "Collector"
	    when :GARDENER
		  return "Gardener"
	    when :FISHER
		  return "Fisher"
	    when :HIKER
		  return "Hiker"
	 end
  end
 

end



class Window_TextEntry_Intro < SpriteWindow_Base
  def initialize(text, x, y, width, height, heading = nil, usedarkercolor = false)
    super(x, y, width, height)
    colors = getDefaultTextColors(self.windowskin)
    @baseColor = colors[0]
    @shadowColor = colors[1]
    if usedarkercolor
      @baseColor = Color.new(16, 24, 32)
      @shadowColor = Color.new(168, 184, 184)
    end
    @helper = CharacterEntryHelper.new(text)
    @heading = heading
    self.active = true
    @frame = 0
    refresh
  end

  def text
    @helper.text
  end

  def maxlength
    @helper.maxlength
  end

  def passwordChar
    @helper.passwordChar
  end

  def text=(value)
    @helper.text = value
    self.refresh
  end

  def passwordChar=(value)
    @helper.passwordChar = value
    refresh
  end

  def maxlength=(value)
    @helper.maxlength = value
    self.refresh
  end

  def insert(ch)
    if @helper.insert(ch)
      @frame = 0
      self.refresh
      return true
    end
    return false
  end

  def delete
    if @helper.delete
      @frame = 0
      self.refresh
      return true
    end
    return false
  end

  def update
    @frame += 1
    @frame %= 20
    self.refresh if (@frame % 10) == 0
    return if !self.active
    # Moving cursor
    if Input.repeat?(Input::LEFT) && Input.press?(Input::ACTION)
      if @helper.cursor > 0
        @helper.cursor -= 1
        @frame = 0
        self.refresh
      end
    elsif Input.repeat?(Input::RIGHT) && Input.press?(Input::ACTION)
      if @helper.cursor < self.text.scan(/./m).length
        @helper.cursor += 1
        @frame = 0
        self.refresh
      end
    elsif Input.repeat?(Input::BACK)   # Backspace
      self.delete if @helper.cursor > 0
    end
  end

  def refresh
    self.contents = pbDoEnsureBitmap(self.contents, self.width - self.borderX,
                                     self.height - self.borderY)
    bitmap = self.contents
    bitmap.clear
    x = 0
    y = 0
    if @heading
      textwidth = bitmap.text_size(@heading).width
      pbDrawShadowText(bitmap, x, y, textwidth + 4, 32, @heading, @baseColor, @shadowColor)
    end
    x += 10
    x += textwidth
	
    width = self.width - self.borderX
    cursorcolor = Color.new(16, 24, 32)
    textscan = self.text.scan(/./m)
    scanlength = textscan.length
    @helper.cursor = scanlength if @helper.cursor > scanlength
    @helper.cursor = 0 if @helper.cursor < 0
    startpos = @helper.cursor
    fromcursor = 0
    while startpos > 0
      c = (@helper.passwordChar != "") ? @helper.passwordChar : textscan[startpos - 1]
      fromcursor += bitmap.text_size(c).width
      break if fromcursor > width - 4
      startpos -= 1
    end
    (startpos...scanlength).each do |i|
      c = (@helper.passwordChar != "") ? @helper.passwordChar : textscan[i]
      textwidth = bitmap.text_size(c).width
      next if c == "\n"
      # Draw text
      pbDrawShadowText(bitmap, x, y, textwidth + 4, 32, c, @baseColor, @shadowColor)
      # Draw cursor if necessary
      if ((@frame / 10) & 1) == 0 && i == @helper.cursor
        bitmap.fill_rect(x, y + 4, 2, 24, cursorcolor)
      end
      # Add x to drawn text width
      x += textwidth
    end
    if ((@frame / 10) & 1) == 0 && textscan.length == @helper.cursor && self.active == true
      bitmap.fill_rect(x, y + 4, 2, 24, cursorcolor)
    end
  end
end



#===============================================================================
#
#===============================================================================
class Window_TextEntry_Keyboard_Intro < Window_TextEntry_Intro
  def update
    @frame += 1
    @frame %= 20
    self.refresh if (@frame % 10) == 0
    return if !self.active
    # Moving cursor
    if Input.triggerex?(:LEFT) || Input.repeatex?(:LEFT)
      if @helper.cursor > 0
        @helper.cursor -= 1
        @frame = 0
        self.refresh
      end
      return
    elsif Input.triggerex?(:RIGHT) || Input.repeatex?(:RIGHT)
      if @helper.cursor < self.text.scan(/./m).length
        @helper.cursor += 1
        @frame = 0
        self.refresh
      end
      return
    elsif Input.triggerex?(:BACKSPACE) || Input.repeatex?(:BACKSPACE)
      self.delete if @helper.cursor > 0
      return
    elsif Input.triggerex?(:RETURN) || Input.triggerex?(:ESCAPE)
      return
    end
    Input.gets.each_char { |c| insert(c) }
  end
end

class Window_CommandPokemonEx2 < Window_DrawableCommand
  attr_reader :truecommands
  attr_reader :trueindex
  attr_reader :commands
  attr_reader :length
  attr_reader :downarrow2
  attr_reader :indexandcolor
  #attr_accessor :length

  def initialize(commands, length=4, width = nil)
    @starting = true
	@length = length
    @truecommands = []
    @commands = []
    @indexandcolor = []
	 @truecommands = commands
	 @commands = commands.dup.take(@length)
    dims = []
    super(0, 0, 32, 32)
	 
    getAutoDims(@commands, dims, width)
    self.width = dims[0]
    self.height = dims[1]
    @commands = commands
    self.active = true
    @trueindex = @truecommands.index(@commands[self.index])
    colors = getDefaultTextColors(self.windowskin)
    self.baseColor = colors[0]
    self.shadowColor = colors[1]
    @downarrow2 = AnimatedSprite.create("Graphics/Pictures/downarrow2222", 8, 2, self.viewport)
    RPG::Cache.retain("Graphics/Pictures/downarrow2222")
    @downarrow2.visible = false
    refresh
    @starting = false
  end
  
  def scroll_down
     @trueindex = @truecommands.index(@commands[self.index])
     return if @trueindex==@truecommands.length-1
	 
    @downarrow2.visible = false if @trueindex+1==@truecommands.length-1
	 nucommands = @commands.dup
	 nucommands.delete_at(0)
	 nucommands << @truecommands[@trueindex+1]
	 @commands = nucommands
    refresh
  end
  
  
  def scroll_up
     @trueindex = @truecommands.index(@commands[self.index])
     return if @trueindex==0
    @downarrow2.visible = false if @trueindex+1!=@truecommands.length-1
	 nucommands = @commands.dup
	 nucommands.delete_at(@length)
	 nucommands.insert(0,@truecommands[@trueindex-1])
	 @commands = nucommands
    refresh
  end
  
  
  def self.newWithSize(commands, x, y, width, height, viewport = nil)
    ret = self.new(commands, width)
    ret.x = x
    ret.y = y
    ret.width = width
    ret.height = height
    ret.viewport = viewport
    return ret
  end

  def self.newEmpty(x, y, width, height, viewport = nil)
    ret = self.new([], width)
    ret.x = x
    ret.y = y
    ret.width = width
    ret.height = height
    ret.viewport = viewport
    return ret
  end

  def index=(value)
    super
    @trueindex = @truecommands.index(@commands[self.index])
    refresh if !@starting
  end

  def commands=(value)
    @commands = value
    @item_max = @length
    self.update_cursor_rect
    self.refresh
  end

  def width=(value)
    super
    if !@starting
      self.index = self.index
      @trueindex = @truecommands.index(@commands[self.index])
      self.update_cursor_rect
    end
  end

  def height=(value)
    super
    if !@starting
      self.index = self.index
      self.update_cursor_rect
    end
  end

  def resizeToFit(commands, width = nil)
    dims = []
    getAutoDims(commands, dims, width)
    self.width = dims[0]
    self.height = dims[1]
  end

  def itemCount
    return @length
  end

  def adjustForZoom(sprite)
    sprite.zoom_x = self.zoom_x
    sprite.zoom_y = self.zoom_y
    sprite.x = (sprite.x * self.zoom_x) + (self.offset_x / self.zoom_x)
    sprite.y = (sprite.y * self.zoom_y) + (self.offset_y / self.zoom_y)
  end

  def clear_color
	 @indexandcolor=[]
	refresh
  end
  def set_color(string,thiscolor,color=nil)
    if !color.nil? 
	 @indexandcolor<<[string,thiscolor,color]
    else
	 @indexandcolor<<[string,thiscolor]
	end
	refresh
  end
  
  def what_color_should_this_be(string)
    
	@indexandcolor.each do |potato|
	  if potato[0]==string && potato[1]==true
	    if potato[2].nil?
         return Color.green
		else
         return potato[2]
		end
	  elsif potato[0]!=string &&  potato[1]==false
	    if potato[2].nil?
         return Color.red
		else
         return potato[2]
		end
	  end
	end
    return self.baseColor
  end
  def drawItem(index, _count, rect)
    pbSetSystemFont(self.contents) if @starting
    rect = drawCursor(index, rect)
    pbDrawShadowText(self.contents, rect.x, rect.y + (self.contents.text_offset_y || 0),
                     rect.width, rect.height, @commands[index], what_color_should_this_be(@commands[index]), self.shadowColor)
  end

  def refresh
    super
  end
  
  def dispose
    @downarrow2.dispose
  end
  
  def update
    super
    @downarrow2.x = self.x + (self.width / 2) - (@downarrow2.framewidth / 2)
    @downarrow2.y = self.y + self.height - @downarrow2.frameheight
    adjustForZoom(@downarrow2)
    @downarrow2.visible = self.visible && self.index != -1 && @trueindex!=@truecommands.length-1 #&& self.active
    @downarrow2.z = self.z + 1
    @downarrow2.viewport = self.viewport
    @downarrow2.play if @downarrow2.visible==true
    @downarrow2.stop if @downarrow2.visible==false
    @downarrow2.update
  end
end



def intro_character_select
NeoCI.ChoosePlayerCharacter
 if $game_variables[27]==11 || $game_variables[27]==12
   pbFullCustomization
 end
$game_variables[27]=0
end

def pbStartGameIntro
 $mouse.hide
  pbFadeOutIn(99999) {

      sscene = PokemonIntroScene.new
      sscreen = PokemonIntro.new(sscene)
      ret = sscreen.pbStartScreen
	   pbFullCustomization if $player&.character_ID == 11 || $player&.character_ID == 12
  }
  return
end



#===============================================================================
# Text entry screen - free typing.
#===============================================================================
class PokemonIntroScene
  def initialize_game_start_actions
   if $PokemonSystem.nuzlockemode == 0
    if Nuzlocke.definedrules? == true
      if Nuzlocke.on? == false
      Nuzlocke.toggle(true)
      end
    else 
      Nuzlocke.start
    end

end
   if $PokemonSystem.difficulty < 2
      $bag.add(:POTION,3)
   end
  
  
  end
  
  def update_player_sprites
      if @index+1<9
      meta = GameData::PlayerMetadata.get(@index+1)
	   if meta
	  charset = meta.walk_charset 
      filename = pbGetPlayerCharset(charset, nil, true)
	  end
	  else
      meta = GameData::PlayerMetadata.get(13)
	  charset = meta.walk_charset 
      filename = pbGetPlayerCharset(charset, nil, true)
	  end
      @sprites["subject"].charset=filename
      @sprites["character"].setBitmap(sprintf("Graphics/Pictures/charskin#{@index}"))
  
  end

  def pbPrepareWindow(window)
    window.letterbyletter=false
  end

  def pbBodyTypeMessage(message,&block)
     return (pbMessage(message,[_INTL("Feminine"),_INTL("Masculine")],1,&block)==0)
  end

  def pbStartScene
    initialize_game_start_actions
	@commands = [_INTL("Actor"),#0
       _INTL("Tri-Athlete"),#1
       _INTL("Expert"),#2
       _INTL("Ranger"),#3
       _INTL("Cook"),#4
       _INTL("Black Belt"),#5
       _INTL("Coordinator"),#6
       _INTL("Engineer"),#7
       _INTL("Collector"),#8
       _INTL("Breeder"),#9
       _INTL("Nurse"),#10
       _INTL("Gardener"),#11
       _INTL("Fisher"),#12
       _INTL("Hiker")]#13
	 @descriptions = [_INTL("At any statue, you can take on the role of another Class, gaining their passive effects for the day. When not doing so, your POKeMON have a chance to not use PP."),#1
		  _INTL("You excel at movement, and have trained your body to use less Stamina, and move quicker by default. You'll never need Running Shoes."),#1
         _INTL("All your POKeMON partake in your skills, letting them ignore Level Caps. Your Journal is filled with pages of POKeMON you have surely seen."),#3
         _INTL("You can always flee from a fight with (non-special) Wild POKeMON, and owing to your profession you can obtain temporarily POKeMON without using POKeBALLs. ...Not that you are allowed to."),#4
         _INTL("You can always use food to pacify the POKeMON you are fighting, and the food you make is of higher Quality."),#5 #Loyalty decays slower
         _INTL("All your POKeMONs multihit moves will hit twice as much, and you can use various forms of punches."),#6
         _INTL("You perform moves with style that can awe your foes, and your teamwork with your POKeMON on the Overworld is supreme. Your POKeMON's Happiness decays slower."),#7
         _INTL("You can craft most machines without Machine Boxes, use electric POKeMON as Generators, and all your POKeMON are immune to Electric Type moves."),#8
         _INTL("You have a chance not to use an item, and will find twice as many items when scavenging."),#9
         _INTL("You excel at working with Eggs, and have a higher chance to have them spawn. Eggs can appear when you sleep."),#10
         _INTL("Sleeping and health items recover more health for both you and your POKeMON, and you passively heal while on the Overworld."),#11
         _INTL("Plants you care for will always give a berry back if they die, or you dig them up. All Berries you have planted will grow slightly faster."),#12
         _INTL("When fishing, you will encounter fish more frequently, which will be of higher level, and give more meat. You can even get meat off of a Magikarp."),#13
         _INTL("You move around the Mountains with a Pole a little faster. When mining, you have more hits before the mine collapses, and have more items in your mines. Overworld Ore will occasionally give double.")#14
          ]
    helptext = "Name:"
    minlength = 1
    maxlength = Settings::MAX_PLAYER_NAME_SIZE
    initialText = ""
    @sprites = {}
    @index = 0
	@dir = 0
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["entry"] = Window_TextEntry_Keyboard_Intro.new(initialText, 0, 0, 400 - 112, 96, helptext, true)
    @sprites["entry"].x = 11
    @sprites["entry"].y -= 6
    @sprites["entry"].viewport = @viewport
	@sprites["entry"].active = false
    @sprites["entry"].visible = true
    @minlength = minlength
    @maxlength = maxlength
    @symtype = 0
    @sprites["entry"].maxlength = maxlength
    addBackgroundPlane(@sprites, "background", "Naming/introbg", @viewport)
    @sprites["background"].z = -1
    #addBackgroundPlane(@sprites, "background", "Naming/bg_2", @viewport)
    @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
    @sprites["shadow"].setBitmap("Graphics/Characters/Shadows/defaultShadow")
    @sprites["shadow"].x = 53
	 @sprites["shadow"].visible = false 
      meta = GameData::PlayerMetadata.get(@index+1)
	   if meta
	  charset = meta.walk_charset 
      filename = pbGetPlayerCharset(charset, nil, true)
	  end
      @sprites["subject"] = TrainerWalkingCharSprite.new(filename, @viewport)
      charwidth = @sprites["subject"].bitmap.width
      charheight = @sprites["subject"].bitmap.height
      @y=[charheight/4*2,0,charheight/4,charheight/4*3]
      @sprites["subject"].x = 50
      @sprites["subject"].y = 115
      @sprites["shadow"].y = @sprites["subject"].y+35
      @sprites["subject"].visible = true
      @sprites["character"]=IconSprite.new(113,108,@viewport)
      @sprites["character"].setBitmap(sprintf("Graphics/Pictures/charskin#{@index}"))
      @sprites["headingchara"]=Window_CommandPokemonEx.new(["SPRITES"])
      @sprites["headingchara"].viewport=@viewport
      @sprites["headingchara"].index=1
      @sprites["headingchara"].x=@sprites["subject"].x+25
      @sprites["headingchara"].y=@sprites["subject"].y-65
      @sprites["heading"]=Window_CommandPokemonEx.new(["CLASS"])
      @sprites["heading"].viewport=@viewport
      @sprites["heading"].index=1
      @sprites["heading"].y=@sprites["subject"].y-65
	  
      @sprites["cmdwindow"]=Window_CommandPokemonEx2.new(@commands)
      @sprites["cmdwindow"].viewport=@viewport
      @sprites["cmdwindow"].x=Graphics.width-@sprites["cmdwindow"].width
      @sprites["cmdwindow"].y=@sprites["subject"].y-20
      @sprites["cmdwindow"].index=-1
	  @sprites["cmdwindow"].active = false
      @sprites["heading"].x=Graphics.width-@sprites["cmdwindow"].width+22
      @sprites["heading"].z=@sprites["cmdwindow"].z+1
	  @sprites["textbox"]=pbCreateMessageWindow
	   @sprites["textbox"].height = (@sprites["textbox"].height*2)-43
	   @sprites["textbox"].y -= 52
      @sprites["textbox"].letterbyletter=false
      @sprites["textbox"].visible=false
	  
#@sprites["player"]=TrainerWalkingCharSprite.new(charset,@viewport)

    @sprites["window"]=SpriteWindow_Base.new(@sprites["character"].x+20,@sprites["subject"].y-35,128,192)
    @sprites["window2"]=SpriteWindow_Base.new(@sprites["subject"].x-45,@sprites["subject"].y-35,127,128)
    @sprites["window"].viewport=@viewport
    @sprites["window2"].viewport=@viewport
    @sprites["window"].z=@sprites["character"].z-1
    @sprites["window2"].z=@sprites["subject"].z-1
    @sprites["window"].visible=true
    @sprites["window2"].visible=true
	
	
    @sprites["window3"]=SpriteWindow_Base.new(@sprites["subject"].x-45,@sprites["subject"].y+93,64,64)
    @sprites["window4"]=SpriteWindow_Base.new(@sprites["subject"].x+@sprites["window3"].width-46,@sprites["window3"].y,64,64)
    @sprites["window3"].viewport=@viewport
    @sprites["window4"].viewport=@viewport
    @sprites["window3"].z=@sprites["character"].z-1
    @sprites["window4"].z=@sprites["subject"].z-1
    @sprites["window3"].visible=true
    @sprites["window4"].visible=true
    @sprites["charaleft"]=IconSprite.new(@sprites["window3"].x+8,@sprites["window3"].y+8,@viewport)
    @sprites["charaleft"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/a"))
    @sprites["chararight"]=IconSprite.new(@sprites["window4"].x+8,@sprites["window4"].y+8,@viewport)
    @sprites["chararight"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/c"))
    @sprites["finishbutton"] = IconSprite.new(0,0,@viewport)
    @sprites["finishbutton"].setBitmap("Graphics/Pictures/IntroAssets/introbase")
	@sprites["finishbutton"].x = Graphics.width-@sprites["finishbutton"].width-20
	@sprites["finishbutton"].y = Graphics.height-@sprites["finishbutton"].height-20
	@sprites["header"]=Window_UnformattedTextPokemon.new("FINISH")
	pbPrepareWindow(@sprites["header"])
	@sprites["header"].viewport=@viewport
	@sprites["header"].windowskin=nil
	@sprites["header"].x = @sprites["finishbutton"].x+20
	@sprites["header"].y = @sprites["finishbutton"].y-7
	@sprites["header"].width=Graphics.width-48
	@sprites["header"].height=Graphics.height
    pbFadeInAndShow(@sprites)
  end

  def pbEntry
    ret = ""
    frame=0
    loop do
      frame+=1
      Graphics.update
      Input.update
	  if $mouse.hidden?# && frame==Graphics.frame_rate*10
	   $mouse.show 
	  end

      if @sprites["cmdwindow"].active == false && @sprites["entry"].text!="" && !$player.playerclass.nil? && @sprites["cmdwindow"].active == false && Input.triggerex?(:RETURN) && @sprites["entry"].text.length >= @minlength && @sprites["entry"].active == true

		  pbPlayDecisionSE
		  $player.name = @sprites["entry"].text
		 if @index==9
		    if pbBodyTypeMessage(_INTL("Would you like a feminine looking body, or a masculine looking body?"))
				index2=11
			else
				index2=12
			end
		 else
				index2=@index+1
		 end
		 pbChangePlayer(index2)
		 break
      elsif @sprites["cmdwindow"].active == false && @sprites["entry"].text!="" && !$player.playerclass.nil? && @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && (Input.mouse_x.between?(@sprites["finishbutton"].x-5,@sprites["finishbutton"].x+@sprites["finishbutton"].width+5) && Input.mouse_y.between?(@sprites["finishbutton"].y,@sprites["finishbutton"].y+@sprites["finishbutton"].height))
		  pbPlayDecisionSE
         $player.name = @sprites["entry"].text
		 if @index==9
		    if pbBodyTypeMessage(_INTL("Would you like a feminine looking body, or a masculine looking body?"))
				index2=11
			else
				index2=12
			end
		 else
				index2=@index+1
		 end
		 pbChangePlayer(index2)
		 break
      elsif Input.trigger?(Input::USE) && (Input.mouse_x.between?(@sprites["finishbutton"].x-5,@sprites["finishbutton"].x+@sprites["finishbutton"].width+5) && Input.mouse_y.between?(@sprites["finishbutton"].y,@sprites["finishbutton"].y+@sprites["finishbutton"].height))
       pbPlayBuzzerSE
      elsif @sprites["cmdwindow"].active == false && @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && (Input.mouse_x.between?(@sprites["charaleft"].x-5,@sprites["charaleft"].x+@sprites["charaleft"].width+5) && Input.mouse_y.between?(@sprites["charaleft"].y,@sprites["charaleft"].y+@sprites["charaleft"].height))

        @sprites["charaleft"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/b"))
		 if @index-1>=0
            pbPlayCursorSE
		@index-=1
		 update_player_sprites
		  pbWait(5)
		  end
        @sprites["charaleft"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/a"))
      elsif @sprites["cmdwindow"].active == false && @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && (Input.mouse_x.between?(@sprites["chararight"].x-5,@sprites["chararight"].x+@sprites["chararight"].width+5) && Input.mouse_y.between?(@sprites["chararight"].y,@sprites["chararight"].y+@sprites["chararight"].height))

        @sprites["chararight"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/d"))
		if @index+1<=8
            pbPlayCursorSE
		@index+=1
		 update_player_sprites
		  pbWait(5)
		 end
        @sprites["chararight"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/c"))
      elsif @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && (Input.mouse_x.between?(@sprites["entry"].x-5,@sprites["entry"].x+@sprites["entry"].width+5) && Input.mouse_y.between?(@sprites["entry"].y-38,@sprites["entry"].y+@sprites["entry"].height-38))
      Input.text_input = true
      @sprites["entry"].active = true
      elsif @sprites["entry"].active == true && Input.text_input == true && Input.trigger?(Input::MOUSERIGHT)
	   Input.text_input = false 
      @sprites["entry"].active = false
      elsif @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && (Input.mouse_x.between?(Graphics.width-@sprites["cmdwindow"].width,Graphics.width) && Input.mouse_y.between?(@sprites["subject"].y-20,@sprites["subject"].y-20+@sprites["cmdwindow"].height))
      @sprites["cmdwindow"].index = 0
      @sprites["cmdwindow"].active = true
      @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex]
      @sprites["textbox"].visible = true
      @sprites["cmdwindow"]&.update
      elsif @sprites["cmdwindow"].active == true && @sprites["cmdwindow"].index != -1
	   loop do
      frame+=1
      Graphics.update
      Input.update
      @sprites["entry"].update
      @sprites["subject"]&.update
	  if frame%120==0 && @index!=8
      @dir+=1
      @sprites["subject"].src_rect.y=@y[@dir%4]
     end
	    if Input.trigger?(Input::USE)
		  pbPlayDecisionSE
         command = @sprites["cmdwindow"].truecommands.index(@sprites["cmdwindow"].commands[@sprites["cmdwindow"].index])
           case command
            when 0
	          $player.set_player_class(:ACTOR)
            when 1
	          $player.set_player_class(:TRIATHLETE)
            when 2
	          $player.set_player_class(:EXPERT)
            when 3
	          $player.set_player_class(:RANGER)
            when 4
	          $player.set_player_class(:COOK)
            when 5
	          $player.set_player_class(:BLACKBELT)
            when 6
	          $player.set_player_class(:COORDINATOR)
            when 7
	          $player.set_player_class(:ENGINEER)
            when 8
	          $player.set_player_class(:COLLECTOR)
            when 9
	          $player.set_player_class(:BREEDER)
            when 10
	          $player.set_player_class(:NURSE)
            when 11
	          $player.set_player_class(:GARDENER)
            when 12
	          $player.set_player_class(:FISHER) 
            when 13
	          $player.set_player_class(:HIKER)
           end
		   @sprites["cmdwindow"].clear_color
		   @sprites["cmdwindow"].set_color(getPlayerClassName($player.playerclass.id),true)
        @sprites["cmdwindow"].refresh
		  @sprites["cmdwindow"].index = -1
         @sprites["cmdwindow"].active = false
         @sprites["textbox"].visible = false
         @sprites["cmdwindow"]&.update
		  break
		elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN) || Input.scroll_v==-1
            pbPlayCursorSE
			if @sprites["cmdwindow"].index+1<@sprites["cmdwindow"].length
			 @sprites["cmdwindow"].index += 1 
           @sprites["cmdwindow"].downarrow2.visible = true if @sprites["cmdwindow"].trueindex+1!=@sprites["cmdwindow"].truecommands.length-1
          @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex]

			else#if @sprites["cmdwindow"].truecommands[@sprites["cmdwindow"].index+1] && @sprites["cmdwindow"].index+1>@sprites["cmdwindow"].length
			 @sprites["cmdwindow"].scroll_down
          @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex+1] if @descriptions[@sprites["cmdwindow"].trueindex+1]
          @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex] if !@descriptions[@sprites["cmdwindow"].trueindex+1]
			 end
			 
		elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP) || Input.scroll_v==1
            pbPlayCursorSE
			 if @sprites["cmdwindow"].index-1>=0
			 @sprites["cmdwindow"].index -= 1
           @sprites["cmdwindow"].downarrow2.visible = true if @sprites["cmdwindow"].trueindex!=@sprites["cmdwindow"].truecommands.length-1
          @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex]

			 else#if @sprites["cmdwindow"].truecommands[@sprites["cmdwindow"].index-1] && @sprites["cmdwindow"].index-1>0
			 @sprites["cmdwindow"].scroll_up
          @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex-1] if @sprites["cmdwindow"].trueindex!=0
          @sprites["textbox"].text=@descriptions[@sprites["cmdwindow"].trueindex] if @sprites["cmdwindow"].trueindex==0
			 end
			 
		elsif Input.trigger?(Input::BACK)
		  pbPlayCloseMenuSE
		  @sprites["cmdwindow"].index = -1
         @sprites["cmdwindow"].active = false
         @sprites["textbox"].visible = false
         @sprites["cmdwindow"]&.update
		 
		  break
		end
		end
	  else 
	
      end
	  
	  
	  
	  if Input.trigger?(Input::MOUSELEFT) && !(Input.mouse_x.between?(@sprites["entry"].x-5,@sprites["entry"].x+@sprites["entry"].width+5) && Input.mouse_y.between?(@sprites["entry"].y-38,@sprites["entry"].y+@sprites["entry"].height-38)) 
      Input.text_input = false 
      @sprites["entry"].active = false
	  end
	  if Input.trigger?(Input::MOUSELEFT) && !(Input.mouse_x.between?(Graphics.width-@sprites["cmdwindow"].width,Graphics.width) && Input.mouse_y.between?(@sprites["subject"].y-20,@sprites["subject"].y-20+@sprites["cmdwindow"].height))
      @sprites["cmdwindow"].index = -1
      @sprites["cmdwindow"].active = false
      @sprites["textbox"].visible = false
      @sprites["cmdwindow"]&.update
	  end
      @sprites["entry"].update
      @sprites["subject"]&.update
	  if frame%120==0 && @index!=8
      @dir+=1
      @sprites["subject"].src_rect.y=@y[@dir%4]
     end



    end
	 $mouse.disable
	 if pbGenerateEgg(:SHAYMIN)
	 	 egg = $player.last_party
	 	 egg.learn_move(:SYNTHESIS)
	 	 egg.learn_move(:AROMATHERAPY)
	 	 egg.record_first_moves
	 	 egg.happiness=200
	 	 egg.loyalty=200
	 	 egg.shiny = true
	 	 egg.obtain_text=_I("???")
	 	 egg.calc_stats 
	 
	 
	 end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeMessageWindow(@sprites["textbox"])
    pbDisposeSpriteHash(@sprites)
    @viewport.visible=false
    @viewport.dispose
	Graphics.update
  end
end


class PokemonIntro
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbEntry
    @scene.pbEndScene
  end
end



  
  def getPlayerClassName(id)
      case id
	    when :TRIATHLETE 
		  return "Tri-Athlete"
	    when :ACTOR
		  return "Actor"
	    when :EXPERT#$game_variables
		  return "Expert"
	    when :RANGER
		  return "Ranger"
	    when :BLACKBELT
		  return "Black Belt"
	    when :COORDINATOR
		  return "Coordinator"
	    when :ENGINEER
		  return "Engineer"
	    when :NURSE
		  return "Nurse"
	    when :BREEDER
		  return "Breeder"
	    when :COLLECTOR
		  return "Collector"
	    when :GARDENER
		  return "Gardener"
	    when :FISHER
		  return "Fisher"
	    when :COOK
		  return "Cook"
	 end
  end
 




class Player < Trainer
 def is_it_this_class?(id,acting=true)
   return $player.playerclass == id if id.is_a? String
   return if $player.playerclass.is_a? String
  if acting==true
   return ($player.playerclass.id == id || ($player.playerclass.id == :ACTOR && $player.playerclass.acted_class == id ))
  else
   return $player.playerclass.id == id
  end
 end
 def set_player_class(class_id)
   @playerclass = PlayerClass.new(class_id) if @playerclass.nil?
   @playerclass.id = class_id
   @playerclass.name = @playerclass.getName
 end


end



def get_class_text


	 if $player.playerclass.id == :TRIATHLETE #DONE
      pbMessage(_INTL("You are a Tri-Athlete."))
      pbMessage(_INTL("You excel at movement, and have trained your body to use less Stamina, and move quicker by default. You'll never need Running Shoes."))
	 elsif $player.playerclass.id == :ACTOR#DONE
      pbMessage(_INTL("You are a Actor."))
      pbMessage(_INTL("At any statue, you can unlock the role of another Class, and use it, gaining their passive effects for the day. When not doing so, your POKeMON have a chance to not use PP."))
	 elsif $player.playerclass.id == :EXPERT#DONE
      pbMessage(_INTL("You are a Expert."))
      pbMessage(_INTL("All your POKeMON partake in your skills, letting them ignore Level Caps. Your Journal is filled with pages of POKeMON you have surely seen."))
	 elsif $player.playerclass.id == :RANGER #DONE
      pbMessage(_INTL("You are a Ranger."))
      pbMessage(_INTL("You can always flee from a fight with (non-special) Wild POKeMON, and owing to your profession you can obtain temporarily POKeMON without using POKeBALLs. ...Not that you are allowed to.")) 
	 elsif $player.playerclass.id == :COOK #Need to do item work
      pbMessage(_INTL("You are an Cook."))
      pbMessage(_INTL("You can always use food permanently buff your POKeMON, and the food you make is of higher Quality."))
	 elsif $player.playerclass.id == :BLACKBELT #DONE
      pbMessage(_INTL("You are a Black Belt."))
      pbMessage(_INTL("All your POKeMONs multihit moves will hit twice as much, and you can use various forms of punches."))
	 elsif $player.playerclass.id == :COORDINATOR #It's done for now.
      pbMessage(_INTL("You are a Coordinator."))
      pbMessage(_INTL("Your POKeMON will always listen to you. Your POKeMON's Happiness decays slower."))
	 elsif $player.playerclass.id == :ENGINEER #DONE
      pbMessage(_INTL("You are a Engineer."))
      pbMessage(_INTL("You can craft most machines without Machine Boxes, use electric POKeMON as Generators, and all your POKeMON are immune to Electric Type moves."))#8
	 elsif $player.playerclass.id == :NURSE #DONE
      pbMessage(_INTL("You are a Nurse."))
      pbMessage(_INTL("Health items recover more health for both you and your POKeMON, Beds will always fully heal, and you passively heal while on the Overworld."))
	 elsif $player.playerclass.id == :BREEDER #DONE
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You excel at working with Eggs, and have a higher chance to have them spawn. Eggs can appear when you sleep."))
	 elsif $player.playerclass.id == :COLLECTOR #DONE
      pbMessage(_INTL("You are a Collector."))
      pbMessage(_INTL("You have a chance not to use an item, and will find twice as many items when scavenging."))
	 elsif $player.playerclass.id == :GARDENER #DONE
      pbMessage(_INTL("You are a Gardener."))
      pbMessage(_INTL("Plants you care for will always give a berry back if they die, or you dig them up. All Berries you have planted will grow slightly faster."))
	 elsif $player.playerclass.id == :FISHER #DONE
      pbMessage(_INTL("You are a Fisher."))
      pbMessage(_INTL("When fishing, you will encounter fish more frequently, which will be of higher level, and give more meat. You can even get meat off of a Magikarp."))
	 elsif $player.playerclass.id == :HIKER#DONE
      pbMessage(_INTL("You are a Hiker."))
      pbMessage(_INTL("You move around the Mountains with a Pole a little faster. When mining, you have more hits before the mine collapses, and have more items in your mines. Overworld Ore will occasionally give double."))
	 end




end

def display_commands(text,text2)
    command = 0
  loop do
command = pbShowCommandsWithHelp(nil,
       [_INTL(text),#0
       _INTL("Actor!"),#1
       _INTL("Tri-Athlete!"),#2
       _INTL("Expert!"),#3
       _INTL("Ranger!"),#4
       _INTL("Cook!"),#5
       _INTL("Black Belt!"),#6
       _INTL("Coordinator!"),#7
       _INTL("Engineer!"),#8
       _INTL("Collector!"),#9
       _INTL("Breeder!"),#10
       _INTL("Nurse!"),#11
       _INTL("Gardener!"),#12
       _INTL("Fisher!"),#13
       _INTL("Hiker!")],#14
         [_INTL(text2),#0
         _INTL("At any statue, you can take on the role of another Class, gaining their passive effects for the day. When not doing so, your POKeMON have a chance to not use PP."),#1
		  _INTL("You excel at movement, and have trained your body to use less Stamina, and move quicker by default. You'll never need Running Shoes."),#1
         _INTL("All your POKeMON partake in your skills, letting them ignore Level Caps. Your Journal is filled with pages of POKeMON you have surely seen."),#3
         _INTL("You can always flee from a fight with (non-special) Wild POKeMON, and owing to your profession you can obtain temporarily POKeMON without using POKeBALLs. ...Not that you are allowed to."),#4
         _INTL("You can always use food to pacify the POKeMON you are fighting, and the food you make is of higher Quality."),#5 #Loyalty decays slower
         _INTL("All your POKeMONs multihit moves will hit twice as much, and you can use various forms of punches."),#6
         _INTL("You perform moves with style that can awe your foes, and your teamwork with your POKeMON on the Overworld is supreme. Your POKeMON's Happiness decays slower."),#7
         _INTL("You can craft most machines without Machine Boxes, use electric POKeMON as Generators, and all your POKeMON are immune to Electric Type moves."),#8
         _INTL("You have a chance not to use an item, and will find twice as many items when scavenging."),#9
         _INTL("You excel at working with Eggs, and have a higher chance to have them spawn. Eggs can appear when you sleep."),#10
         _INTL("Sleeping and health items recover more health for both you and your POKeMON, and you passively heal while on the Overworld."),#11
         _INTL("Plants you care for will always give a berry back if they die, or you dig them up. All Berries you have planted will grow slightly faster."),#12
         _INTL("When fishing, you will encounter fish more frequently, which will be of higher level, and give more meat. You can even get meat off of a Magikarp."),#13
         _INTL("You move around the Mountains with a Pole a little faster. When mining, you have more hits before the mine collapses, and have more items in your mines. Overworld Ore will occasionally give double.")#14
          ],-1,command
      )
	   if pbConfirmMessage(_INTL("Are you sure you want to pick this?"))
           case command
            when -1  
	          return -1 
            when 0
             return 0
            when 1
	          $player.set_player_class(:ACTOR)
             return 1
            when 2
	          $player.set_player_class(:TRIATHLETE)
             return 2
            when 3
	          $player.set_player_class(:EXPERT)
             return 3
            when 4
	          $player.set_player_class(:RANGER)
             return 4
            when 5
	          $player.set_player_class(:COOK)
             return 5
            when 6
	          $player.set_player_class(:BLACKBELT)
             return 6
            when 7
	          $player.set_player_class(:COORDINATOR)
             return 4
            when 8
	          $player.set_player_class(:ENGINEER)
             return 8
            when 9
	          $player.set_player_class(:COLLECTOR)
             return 9
            when 10
	          $player.set_player_class(:BREEDER)
             return 10
            when 11
	          $player.set_player_class(:NURSE)
             return 11
            when 12
	          $player.set_player_class(:GARDENER)
             return 12
            when 13
	          $player.set_player_class(:FISHER)
             return 13
            when 14
	          $player.set_player_class(:HIKER)
             return 14
           end
       end
  
 end
  
 
end


def pbIntroQuestionare
loop do
  if pbConfirmMessage(_INTL("Can I ask you some questions about what #{$player.name} does? If not, you can just immediately choose what they do outright."))
      
      if $DEBUG && Input.press?(Input::CTRL) || Input.press?(Input::CTRL) && Input.press?(Input::SHIFT)
	  else
	  if true
      pbMessage(_INTL("Answer the following questions however you feel strongest."))
      pbMessage(_INTL("There will be a word, Choose the first thing that comes to mind."))
      cmd = pbMessage(_INTL("Arcanine"),[
                            _INTL("Train"), #Actor,Ranger
                            _INTL("Catch"), #Collector,Black Belt
                            _INTL("Run"), #Tri-Athlete,Scientist,Engineer
                            _INTL("Feed"),  #Breeder,Nurse
                            _INTL("Dinner")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=1 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=1 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==3
	 $player.playerwrath-=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=2 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Forest"),[
                            _INTL("Targets"), #Coordinator,Expert
                            _INTL("Friends"),  #Collector,Nurse
                            _INTL("Danger"), #Tri-Athlete,Breeder,Ranger
                            _INTL("Curiousity"),#Scientist,Engineer
                            _INTL("Campfire")]) #Black Belt,Actor
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=5 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==3
	 $player.playerwrath-=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=5 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Night"),[
                            _INTL("Shelter"), #Black Belt,Actor
                            _INTL("Dream"),  #Scientist,Engineer
                            _INTL("Sleep"), #Tri-Athlete,Ranger
                            _INTL("Comfort"), #Collector,Nurse,Breeder
                            _INTL("Shroud")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=4 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=5 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=5 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("Pokemon Center"),[
                            _INTL("Safety"), #Black Belt,Actor
                            _INTL("Healing"),  #Scientist,Engineer
                            _INTL("Rest"), #Tri-Athlete,Ranger
                            _INTL("Burglarize"), #Collector,Nurse,Breeder
                            _INTL("Renovate")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Grunt"),[
                            _INTL("Bribe"), #Black Belt,Actor
                            _INTL("Fight"),  #Scientist,Engineer
                            _INTL("Fear"), #Tri-Athlete,Ranger
                            _INTL("Police"), #Collector,Nurse,Breeder
                            _INTL("Reasonable")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=5 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=4 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Light"),[
                            _INTL("Dark"), #Black Belt,Actor
                            _INTL("Heavy"),  #Scientist,Engineer
                            _INTL("Flash"), #Tri-Athlete,Ranger
                            _INTL("Torch"), #Collector,Nurse,Breeder
                            _INTL("Sun")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=4 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      pbMessage(_INTL("Here are a few statements, choose if you agree with them or not."))
      cmd = pbMessage(_INTL("I charge in to deal with my problems head on."),[
                            _INTL("Strongly Agree"), #Black Belt,Actor
                            _INTL("Agree"),  #Scientist,Engineer
                            _INTL("No Opinion"), #Tri-Athlete,Ranger
                            _INTL("Disagree"), #Collector,Nurse,Breeder
                            _INTL("Strongly Disagree")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==4
	 $player.playerwrath-=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=4 #Intelligence
	     end
      cmd = pbMessage(_INTL("I don't tend to rely on others for support."),[
                            _INTL("Strongly Agree"), #Black Belt,Actor
                            _INTL("Agree"),  #Scientist,Engineer
                            _INTL("No Opinion"), #Tri-Athlete,Ranger
                            _INTL("Disagree"), #Collector,Nurse,Breeder
                            _INTL("Strongly Disagree")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony-=4 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath-=4 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Conflict isn't in my nature."),[
                            _INTL("Strongly Agree"), #Black Belt,Actor
                            _INTL("Agree"),  #Scientist,Engineer
                            _INTL("No Opinion"), #Tri-Athlete,Ranger
                            _INTL("Disagree"), #Collector,Nurse,Breeder
                            _INTL("Strongly Disagree")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=5 #Physical
	 $player.playerharmony-=2 #Emotional
	 $player.playermoral+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("I am slow to adapt."),[
                            _INTL("Strongly Agree"), #Black Belt,Actor
                            _INTL("Agree"),  #Scientist,Engineer
                            _INTL("No Opinion"), #Tri-Athlete,Ranger
                            _INTL("Disagree"), #Collector,Nurse,Breeder
                            _INTL("Strongly Disagree")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral-=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=5 #Intelligence
	     end
      cmd = pbMessage(_INTL("I want to be the center of attention."),[
                            _INTL("Strongly Agree"), #Black Belt,Actor
                            _INTL("Agree"),  #Scientist,Engineer
                            _INTL("No Opinion"), #Tri-Athlete,Ranger
                            _INTL("Disagree"), #Collector,Nurse,Breeder
                            _INTL("Strongly Disagree")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral-=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      pbMessage(_INTL("The following are 'Yes' 'No' type questions."))
      cmd = pbMessage(_INTL("Do you think it's important to always aim to be the best?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Do you have a cheerful personality?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("Can you focus on something you like?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Good news and bad news... Which one do you want to hear first?"),[
                            _INTL("Good"), #Black Belt,Actor
                            _INTL("Bad")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=3 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=3 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Once you've decided something, do you see it through to the end?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=3 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Do you like to noisily enjoy yourself with others?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath-=0 #Physical
	 $player.playerharmony-=4 #Emotional
	 $player.playermoral-=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Can you strike up conversations with new people easily?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony-=4 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Do you sometimes run out of things to do all of a sudden?"),[
                            _INTL("Yes"), #Black Belt,Actor
                            _INTL("No")]) #Coordinator,Expert
		  if cmd==0
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=6 #Emotional
	 $player.playermoral+=3 #Intelligence
	     end
      pbMessage(_INTL("That's all!"))
      end
    # Emotional   (-13) to 45
    # Intelligence   (-1) to 31
    # Physical   (-5) to 36
	 $player.set_player_class(:COLLECTOR)
	 if $player.playerwrath >= 15 && $player.playerharmony >= 15
	 $player.set_player_class(:TRIATHLETE)
	 end
	 if $player.playerwrath >= 20 && $player.playerharmony >= 20
	 $player.set_player_class(:HIKER)
	 end
	 if $player.playerwrath >= 20 && $player.playermoral >= 10
	 $player.set_player_class(:COORDINATOR)
	 end
	 if $player.playerwrath >= 20 && $player.playermoral >= 20
	 $player.set_player_class(:EXPERT)
	 end
	 if $player.playerwrath >= 15 && $player.playerharmony >= 15  && $player.playerharmony >= 10
	 $player.set_player_class(:RANGER)
	 end
	 if $player.playermoral >= 15 && $player.playerharmony >= 15
	 $player.set_player_class(:BREEDER)
	 end
	 if $player.playerwrath >= 20 && $player.playerharmony >= 20
	 $player.set_player_class(:TRIATHLETE)
	 end
	 if $player.playerwrath >= 25 && $player.playerharmony >= 25
	 $player.set_player_class(:ACTOR)
	 end
	 if $player.playerwrath >= 25 && $player.playermoral >= 15
	 $player.set_player_class(:COORDINATOR)
	 end
	 if $player.playerwrath >= 25 && $player.playermoral >= 25
	 $player.set_player_class(:EXPERT)
	 end
	 if $player.playerwrath >= 20 && $player.playerharmony >= 20  && $player.playerharmony >= 15
	 $player.set_player_class(:RANGER)
	 end
	 if $player.playermoral >= 20 && $player.playerharmony >= 20
	 $player.set_player_class(:BREEDER)
	 end
	 if $player.playermoral >= 25 && $player.playerharmony >= 25
	 $player.set_player_class(:GARDENER)
	 end
	 if $player.playerwrath >= 30
	 $player.set_player_class(:BLACKBELT)
	 end
	 if $player.playerharmony >= 30
	 $player.set_player_class(:NURSE)
	 end
	 if $player.playermoral >= 30
	 $player.set_player_class(:ENGINEER)
     end
	 get_class_text
	 end
      pbMessage(_INTL("If you aren't pleased with this, you are welcome to choose."))
      command = display_commands("I want what I got.","Keep your current class.")
      break
  else
      command = display_commands("I might do the quiz.","Do the Quiz.")
	  
      if command > 0
        return
      end
  end
end

if $player.is_it_this_class?(:RANGER,false)
  $bag.add(:CAPTURESTYLUS)
end
end









module GameData
  class Type
    def effectiveness(other_type)
      return Effectiveness::INEFFECTIVE if other_type==:ELECTRIC && $player.is_it_this_class?(:ENGINEER)
      return Effectiveness::NORMAL_EFFECTIVE_ONE if !other_type
      return Effectiveness::SUPER_EFFECTIVE_ONE if @weaknesses.include?(other_type)
      return Effectiveness::NOT_VERY_EFFECTIVE_ONE if @resistances.include?(other_type)
      return Effectiveness::INEFFECTIVE if @immunities.include?(other_type)
      return Effectiveness::NORMAL_EFFECTIVE_ONE
    end
end
end





class Battle::Battler

  def pbReducePP(move)
    return true if usingMultiTurnAttack?
    return true if move.pp < 0          # Don't reduce PP for special calls of moves
    return true if move.total_pp <= 0   # Infinite PP, can always be used
    return true if ($player.is_it_this_class?(:ACTOR) && $player.playerclass.acted_class==:NONE )&& @battle.pbOwnedByPlayer?(@index) && rand(5)==1																				   
    return false if move.pp == 0        # Ran out of PP, couldn't reduce
    pbSetPP(move, move.pp - 1) if move.pp > 0
    return true
  end
end

def pbItemRestoreHP(pkmn, restoreHP)
  restoreHP *= 1.5 if $player.is_it_this_class?(:NURSE)
  newHP = pkmn.hp + restoreHP
  newHP = pkmn.totalhp if newHP > pkmn.totalhp
  hpGain = newHP - pkmn.hp
  pkmn.hp = newHP
  return hpGain
end

def pbHPItem(pkmn, restoreHP, scene)
  if !pkmn.able? || pkmn.hp == pkmn.totalhp
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  restoreHP *= 1.5 if $player.is_it_this_class?(:NURSE)
  hpGain = pbItemRestoreHP(pkmn, restoreHP)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, hpGain))
  return true
end

def pbBattleHPItem(pkmn, battler, restoreHP, scene)
  restoreHP *= 1.5 if $player.is_it_this_class?(:NURSE)
  if battler
    if battler.pbRecoverHP(restoreHP) > 0
      scene.pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
    end
  elsif pbItemRestoreHP(pkmn, restoreHP) > 0
    scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  end
  return true
end



#===============================================================================
# Hits twice.
#===============================================================================
class Battle::Move::HitTwoTimes < Battle::Move
  def multiHitMove?;            return true; end
  def pbNumHits(user, targets)
    return 4  if $player.is_it_this_class?(:BLACKBELT,false) && user.pokemon.owner.id == $player.id
    return 2
  end
end

#===============================================================================
# Hits twice. May poison the target on each hit. (Twineedle)
#===============================================================================
class Battle::Move::HitTwoTimesPoisonTarget < Battle::Move::PoisonTarget
  def multiHitMove?;            return true; end
  def pbNumHits(user, targets)
  return 4  if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id
  return 2
  end
end

#===============================================================================
# Hits twice. Causes the target to flinch. (Double Iron Bash)
#===============================================================================
class Battle::Move::HitTwoTimesFlinchTarget < Battle::Move::FlinchTarget
  def multiHitMove?;            return true; end
  def pbNumHits(user, targets)
  return 4  if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id
  return 2
  end
end

#===============================================================================
# Hits in 2 volleys. The second volley targets the original target's ally if it
# has one (that can be targeted), or the original target if not. A battler
# cannot be targeted if it is is immune to or protected from this move somehow,
# or if this move will miss it. (Dragon Darts)
# NOTE: This move sometimes shows a different failure message compared to the
#       official games. This is because of the order in which failure checks are
#       done (all checks for each target in turn, versus all targets for each
#       check in turn). This is considered unimportant, and since correcting it
#       would involve extensive code rewrites, it is being ignored.
#===============================================================================
class Battle::Move::HitTwoTimesTargetThenTargetAlly < Battle::Move
  def pbNumHits(user, targets); return 1;    end
  def pbRepeatHit?;             return true; end

  def pbModifyTargets(targets, user)
    return if targets.length != 1
    choices = []
    targets[0].allAllies.each { |b| user.pbAddTarget(choices, user, b, self) }
    return if choices.length == 0
    idxChoice = (choices.length > 1) ? @battle.pbRandom(choices.length) : 0
    user.pbAddTarget(targets, user, choices[idxChoice], self, !pbTarget(user).can_choose_distant_target?)
  end

  def pbShowFailMessages?(targets)
    if targets.length > 1
      valid_targets = targets.select { |b| !b.fainted? && !b.damageState.unaffected }
      return valid_targets.length <= 1
    end
    return super
  end

  def pbDesignateTargetsForHit(targets, hitNum)
    valid_targets = []
    targets.each { |b| valid_targets.push(b) if !b.damageState.unaffected }
    return [valid_targets[1]] if valid_targets[1] && hitNum == 1
    return [valid_targets[0]]
  end
end

#===============================================================================
# Hits 3 times. Power is multiplied by the hit number. (Triple Kick)
# An accuracy check is performed for each hit.
#===============================================================================
class Battle::Move::HitThreeTimesPowersUpWithEachHit < Battle::Move
  def multiHitMove?;            return true; end
  def pbNumHits(user, targets)
  return 6  if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id
  return 3
  end

  def successCheckPerHit?
    return @accCheckPerHit
  end

  def pbOnStartUse(user, targets)
    @calcBaseDmg = 0
    @accCheckPerHit = !user.hasActiveAbility?(:SKILLLINK)
  end

  def pbBaseDamage(baseDmg, user, target)
    @calcBaseDmg += baseDmg
    return @calcBaseDmg
  end
end

#===============================================================================
# Hits 3 times in a row. If each hit could be a critical hit, it will definitely
# be a critical hit. (Surging Strikes)
#===============================================================================
class Battle::Move::HitThreeTimesAlwaysCriticalHit < Battle::Move
  def multiHitMove?;                   return true; end
  def pbNumHits(user, targets);   
  return 6  if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id    
  return 3
  end
  def pbCritialOverride(user, target); return 1;    end
end

#===============================================================================
# Hits 2-5 times.
#===============================================================================
class Battle::Move::HitTwoToFiveTimes < Battle::Move
  def multiHitMove?; return true; end

  def pbNumHits(user, targets)
    hitChances = [
      2, 2, 2, 2, 2, 2, 2,
      3, 3, 3, 3, 3, 3, 3,
      4, 4, 4,
      5, 5, 5
    ]
    r = @battle.pbRandom(hitChances.length)
    r = hitChances.length - 1 if user.hasActiveAbility?(:SKILLLINK)
    r = hitChances.length - 1 if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id
    return hitChances[r]
  end
end

#===============================================================================
# Hits 2-5 times. If the user is Ash Greninja, powers up and hits 3 times.
# (Water Shuriken)
#===============================================================================
class Battle::Move::HitTwoToFiveTimesOrThreeForAshGreninja < Battle::Move::HitTwoToFiveTimes
  def pbNumHits(user, targets)
    return 6  if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id && user.isSpecies?(:GRENINJA) && user.form == 2
    return 3 if user.isSpecies?(:GRENINJA) && user.form == 2
    return super
  end

  def pbBaseDamage(baseDmg, user, target)
    return 20 if user.isSpecies?(:GRENINJA) && user.form == 2
    return super
  end
end

#===============================================================================
# Hits 2-5 times in a row. If the move does not fail, increases the user's Speed
# by 1 stage and decreases the user's Defense by 1 stage. (Scale Shot)
#===============================================================================
class Battle::Move::HitTwoToFiveTimesRaiseUserSpd1LowerUserDef1 < Battle::Move
  def multiHitMove?; return true; end

  def pbNumHits(user, targets)
    hitChances = [
      2, 2, 2, 2, 2, 2, 2,
      3, 3, 3, 3, 3, 3, 3,
      4, 4, 4,
      5, 5, 5
    ]
    r = @battle.pbRandom(hitChances.length)
    r = hitChances.length - 1 if user.hasActiveAbility?(:SKILLLINK)
    r = hitChances.length - 1 if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id
    return hitChances[r]
  end

  def pbEffectAfterAllHits(user, target)
    return if target.damageState.unaffected
    if user.pbCanLowerStatStage?(:DEFENSE, user, self)
      user.pbLowerStatStage(:DEFENSE, 1, user)
    end
    if user.pbCanRaiseStatStage?(:SPEED, user, self)
      user.pbRaiseStatStage(:SPEED, 1, user)
    end
  end
end

#===============================================================================
# Hits X times, where X is the number of non-user unfainted status-free Pokémon
# in the user's party (not including partner trainers). Fails if X is 0.
# Base power of each hit depends on the base Attack stat for the species of that
# hit's participant. (Beat Up)
#===============================================================================
class Battle::Move::HitOncePerUserTeamMember < Battle::Move
  def multiHitMove?; return true; end

  def pbMoveFailed?(user, targets)
    @beatUpList = []
    @beatUpList << $player
    @battle.eachInTeamFromBattlerIndex(user.index) do |pkmn, i|
      next if !pkmn.able? || pkmn.status != :NONE
      @beatUpList.push(i)
    end
    if @beatUpList.length == 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbNumHits(user, targets)
    return 6  if $player.is_it_this_class?(:BLACKBELT) && user.pokemon.owner.id == $player.id    
    return @beatUpList.length
  end

  def pbBaseDamage(baseDmg, user, target)
    i = @beatUpList.shift   # First element in array, and removes it from array
	if i == $player
	  atk = 150
	else
    atk = @battle.pbParty(user.index)[i].baseStats[:ATTACK]
	end
    return 5 + (atk / 10)
  end
end