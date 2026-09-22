#===============================================================================
# Single source of truth for every player class: its display name and
# description. This used to be duplicated independently across
# PlayerClass#getName, the free function getPlayerClassName, and
# PokemonIntroScene#pbStartScene's own @commands/@descriptions arrays — and
# they had drifted out of sync (getName was missing :COOK, getPlayerClassName
# was missing :HIKER, and "Blackbelt" vs "Black Belt" disagreed between
# sources). Everything now reads from here instead.
#
# ORDER matters: it's the same order the class-picker menu displays classes
# in, since PokemonIntroScene#pbEntry picks a class by looking up the chosen
# menu index directly against this order.
#===============================================================================
module PlayerClassData
  CLASSES = {
    ACTOR:       { name: "Actor",       description: "At any statue, you can take on the role of another Class, gaining their passive effects for the day. When not doing so, your POKeMON have a chance to not use PP." },
    TRIATHLETE:  { name: "Tri-Athlete", description: "You excel at movement, and have trained your body to use less Stamina, and move quicker by default. You'll never need Running Shoes." },
    EXPERT:      { name: "Expert",      description: "All your POKeMON partake in your skills, letting them ignore Level Caps. Your Journal is filled with pages of POKeMON you have surely seen." },
    RANGER:      { name: "Ranger",      description: "You can always flee from a fight with (non-special) Wild POKeMON, and owing to your profession you can obtain temporarily POKeMON without using POKeBALLs. ...Not that you are allowed to use POKeBALLs." },
    COOK:        { name: "Cook",        description: "You can always use food to pacify the POKeMON you are fighting, and the food you make is of higher Quality." },
    BLACKBELT:   { name: "Black Belt",  description: "All your POKeMONs multihit moves will hit twice as much, and you can use various forms of punches." },
    COORDINATOR: { name: "Coordinator", description: "You perform moves with style that can awe your foes, and your teamwork with your POKeMON on the Overworld is supreme. Your POKeMON's Happiness decays slower." },
    ENGINEER:    { name: "Engineer",    description: "You can craft most machines without Machine Boxes." },
    COLLECTOR:   { name: "Collector",   description: "You have a chance not to use an item, and will find twice as many items when scavenging." },
    BREEDER:     { name: "Breeder",     description: "You excel at working with Eggs, and have a higher chance to have them spawn. Eggs can appear when you sleep." },
    NURSE:       { name: "Nurse",       description: "Sleeping and health items recover more health for both you and your POKeMON, and you passively heal while on the Overworld." },
    GARDENER:    { name: "Gardener",    description: "Plants you care for will always give a berry back if they die, or you dig them up. All Berries you have planted will grow slightly faster." },
    FISHER:      { name: "Fisher",      description: "When fishing, you will encounter fish more frequently, which will be of higher level, and give more meat. You can even get meat off of a Magikarp." },
    HIKER:       { name: "Hiker",       description: "When holding a Pole, you move faster in mountainous areas. When mining, you have more hits before the mine collapses, and have more items in your mines. Overworld Ore will occasionally give double." },
  }.freeze

  # index -> class id, in class-picker menu order
  ORDER = CLASSES.keys.freeze

  def self.name_for(id)
    CLASSES[id] ? CLASSES[id][:name] : nil
  end

  def self.description_for(id)
    CLASSES[id] ? CLASSES[id][:description] : nil
  end
end

class PlayerClass
  attr_accessor :id
  attr_accessor :name
  attr_accessor :acted_class
  attr_accessor :actorcooldown
  attr_accessor :started_acting_at

  def initialize(id)
    @id            = id
    @name          = getName
    @acted_class   = :NONE
    @actorcooldown = false
  end

  def getName
    PlayerClassData.name_for(@id)
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
      next_index = (@trueindex + 1) % @truecommands.length
	 
	 nucommands = @commands.dup
	 nucommands.delete_at(0)
	 nucommands << @truecommands[next_index]
	 @commands = nucommands
    refresh
  end
  
  
  def scroll_up
     @trueindex = @truecommands.index(@commands[self.index])
     prev_index = (@trueindex - 1) % @truecommands.length
	 nucommands = @commands.dup
	 nucommands.delete_at(@length)
	 nucommands.insert(0,@truecommands[prev_index])
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
	   $mouse.disable
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
        Nuzlocke.toggle(true) if Nuzlocke.on? == false
      else
        Nuzlocke.start
        Nuzlocke.toggle(true)
      end
    end
    if $PokemonSystem.difficulty < 2
      $bag.add(ItemData.new(:POTION), 3)
    end
    $mouse.enable
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
    # Built from PlayerClassData instead of a separately hardcoded copy of the
    # class list/descriptions, so this always matches what set_player_class
    # actually recognizes (see pbEntry's class-picker selection below).
    @commands = PlayerClassData::ORDER.map { |id| _INTL(PlayerClassData::CLASSES[id][:name]) }
    @descriptions = PlayerClassData::ORDER.map { |id| _INTL(PlayerClassData::CLASSES[id][:description]) }
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
	   @sprites["textbox"].contents.font.size = 22
	   @sprites["textbox"].y -= 52
      @sprites["textbox"].letterbyletter=false
      @sprites["textbox"].visible=false
	  

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
	@sprites["header"].x = @sprites["finishbutton"].x+16
	@sprites["header"].y = @sprites["finishbutton"].y-7
	@sprites["header"].width=Graphics.width-48
	@sprites["header"].height=Graphics.height
    pbFadeInAndShow(@sprites)
  end

  # Every mouse-hit-test in pbEntry used to recompute this inline (~150+ chars each,
  # several with a copy-pasted duplicate clause elsewhere in the same condition).
  # x_margin pads the horizontal bounds; y_offset shifts (not pads) the vertical
  # bounds — matches each sprite's original check exactly (entry needed a -38 shift,
  # cmdwindow needed 0 margin, everything else used the 5px margin / 0 offset default).
  def mouse_over?(sprite, x_margin: 5, y_offset: 0)
    Input.mouse_x.between?(sprite.x - x_margin + $PokemonSystem.screenposx,
                            sprite.x + sprite.width + x_margin + $PokemonSystem.screenposx) &&
      Input.mouse_y.between?(sprite.y + y_offset + $PokemonSystem.screenposy,
                              sprite.y + sprite.height + y_offset + $PokemonSystem.screenposy)
  end

  # shared by both ways of confirming the entered name (pressing Enter vs clicking
  # Finish) — these used to be two ~15-line copies of the same logic. Note the two
  # callers still check slightly different conditions (Enter additionally requires
  # the entry field to be focused and meet @minlength) — only the action itself,
  # not the trigger condition, was actually duplicated.
  def can_confirm_name?
    @sprites["cmdwindow"].active == false && @sprites["entry"].text != "" && !$player.playerclass.nil?
  end

  def confirm_name_and_advance
    pbPlayDecisionSE
    $player.name = @sprites["entry"].text
    index2 =
      if @index + 1 == 9
        pbBodyTypeMessage(_INTL("Would you like a feminine looking body, or a masculine looking body?")) ? 12 : 11
      else
        @index + 1
      end
    pbChangePlayer(index2)
  end

  # advances the walking-animation frame; was duplicated inline at the tail of the
  # outer loop and the head of the inner (class-picker) loop in pbEntry
  def update_frame_animation(frame)
    @sprites["entry"].update
    @sprites["subject"]&.update
    if frame % 120 == 0 && @index != 8
      @dir += 1
      @sprites["subject"].src_rect.y = @y[@dir % 4]
    end
  end

  def pbEntry
    frame = 0
    loop do
      frame += 1
      Graphics.update
      Input.update
      $mouse.show if $mouse.hidden?

      if can_confirm_name? && Input.triggerex?(:RETURN) && @sprites["entry"].text.length >= @minlength && @sprites["entry"].active == true
        confirm_name_and_advance
        break
      elsif can_confirm_name? && Input.trigger?(Input::USE) && mouse_over?(@sprites["finishbutton"])
        confirm_name_and_advance
        break
      elsif Input.trigger?(Input::USE) && mouse_over?(@sprites["finishbutton"])
        pbPlayBuzzerSE
      elsif @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && mouse_over?(@sprites["charaleft"])
        @sprites["charaleft"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/b"))
        pbPlayCursorSE
        @index = (@index - 1) % 9
        update_player_sprites
        pbWait(5)
        @sprites["charaleft"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/a"))
      elsif @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && mouse_over?(@sprites["chararight"])
        @sprites["chararight"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/d"))
        pbPlayCursorSE
        @index = (@index + 1) % 9
        update_player_sprites
        pbWait(5)
        @sprites["chararight"].setBitmap(sprintf("Graphics/Pictures/IntroAssets/c"))
      elsif @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && mouse_over?(@sprites["entry"], y_offset: -38)
        Input.text_input = true
        @sprites["entry"].active = true
      elsif @sprites["entry"].active == true && Input.text_input == true && Input.trigger?(Input::MOUSERIGHT)
        Input.text_input = false
        @sprites["entry"].active = false
      elsif @sprites["cmdwindow"].active == false && Input.trigger?(Input::USE) && mouse_over?(@sprites["cmdwindow"], x_margin: 0)
        @sprites["cmdwindow"].index = 0
        @sprites["cmdwindow"].active = true
        @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex]
        @sprites["textbox"].visible = true
        @sprites["cmdwindow"]&.update
      elsif @sprites["cmdwindow"].active == true && @sprites["cmdwindow"].index != -1
        loop do
          frame += 1
          Graphics.update
          Input.update
          update_frame_animation(frame)
          if Input.trigger?(Input::USE)
            pbPlayDecisionSE
            command = @sprites["cmdwindow"].truecommands.index(@sprites["cmdwindow"].commands[@sprites["cmdwindow"].index])
            # picks the class directly from the same registry/order used to build
            # the menu, instead of a separately hand-maintained 14-branch case
            # statement that had to be kept in sync with that order by hand
            class_id = PlayerClassData::ORDER[command]
            $player.set_player_class(class_id) if class_id
            @sprites["cmdwindow"].clear_color
            @sprites["cmdwindow"].set_color(getPlayerClassName($player.playerclass.id), true)
            @sprites["cmdwindow"].refresh
            @sprites["cmdwindow"].index = -1
            @sprites["cmdwindow"].active = false
            @sprites["textbox"].visible = false
            @sprites["cmdwindow"]&.update
            break
          elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN) || Input.scroll_v == -1
            pbPlayCursorSE
            if @sprites["cmdwindow"].index + 1 < @sprites["cmdwindow"].length
              @sprites["cmdwindow"].index += 1
              @sprites["cmdwindow"].downarrow2.visible = true if @sprites["cmdwindow"].trueindex + 1 != @sprites["cmdwindow"].truecommands.length - 1
              @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex]
            else
              @sprites["cmdwindow"].scroll_down
              @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex + 1] if @descriptions[@sprites["cmdwindow"].trueindex + 1]
              @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex] if !@descriptions[@sprites["cmdwindow"].trueindex + 1]
            end
          elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP) || Input.scroll_v == 1
            pbPlayCursorSE
            if @sprites["cmdwindow"].index - 1 >= 0
              @sprites["cmdwindow"].index -= 1
              @sprites["cmdwindow"].downarrow2.visible = true if @sprites["cmdwindow"].trueindex != @sprites["cmdwindow"].truecommands.length - 1
              @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex]
            else
              @sprites["cmdwindow"].scroll_up
              @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex - 1] if @sprites["cmdwindow"].trueindex != 0
              @sprites["textbox"].text = @descriptions[@sprites["cmdwindow"].trueindex] if @sprites["cmdwindow"].trueindex == 0
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
      end

      if Input.trigger?(Input::MOUSELEFT) && !mouse_over?(@sprites["entry"], y_offset: -38)
        Input.text_input = false
        @sprites["entry"].active = false
      end
      if Input.trigger?(Input::MOUSELEFT) && !mouse_over?(@sprites["cmdwindow"], x_margin: 0)
        @sprites["cmdwindow"].index = -1
        @sprites["cmdwindow"].active = false
        @sprites["textbox"].visible = false
        @sprites["cmdwindow"]&.update
      end
      update_frame_animation(frame)
    end

    $mouse.disable
    if pbGenerateEgg(:SHAYMIN)
      egg = $player.last_party
      egg.learn_move(:SYNTHESIS)
      egg.learn_move(:AROMATHERAPY)
      egg.record_first_moves
      egg.happiness = 200
      egg.loyalty = 200
      egg.shiny = true
      egg.obtain_text = _I("???")
      egg.calc_stats
    end

    if $player.real_ranger?
      item = ItemData.new(:CAPTURESTYLUS)
      $bag.add(item, 1)
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
    PlayerClassData.name_for(id)
  end
 




class Player < Trainer
 def is_it_this_class?(id, acting=true)
  return $player.playerclass == id if id.is_a? String
  return false if $player.playerclass.is_a? String
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
 
 def not_acting?
    actor? && $player.playerclass.acted_class == :NONE
 end 
 
 def currently_acting?
    actor? && $player.playerclass.acted_class != :NONE
 end 
 
 def clear_acting
    @playerclass.acted_class = :NONE
 end 
 
 def can_act_again?
   return true if @playerclass.started_acting_at.nil?
   cooldown_days = 3
   cooldown_days = 2 if actor?(10)
   cooldown_days = 1 if actor?(15)
   cooldown_days = 0 if actor?(20)

   cooldown_seconds = cooldown_days * 24 * 60 * 60
   return pbGetTimeNow.to_i - @playerclass.started_acting_at >= cooldown_seconds
 end 
 
 def set_acting(id)
    raise unless CLASS_HELPERS.values.include?(id)
    @playerclass.acted_class = id
	@playerclass.started_acting_at = pbGetTimeNow.to_i 
 end 
 
  CLASS_HELPERS = {
    actor:        :ACTOR,
    triathlete:   :TRIATHLETE,
    expert:       :EXPERT,
    ranger:       :RANGER,
    cook:         :COOK,
    coordinator:  :COORDINATOR,
    gardener:     :GARDENER,
    collector:    :COLLECTOR,
    hiker:        :HIKER,
    black_belt:   :BLACKBELT,
    engineer:     :ENGINEER,
    breeder:      :BREEDER,
    nurse:        :NURSE,
    fisher:       :FISHER,
  }.freeze

  CLASS_HELPERS.each do |name, id|
    define_method("#{name}?") do |level = 0|
      is_it_this_class?(id, true) && playerclasslevel >= level
    end

    define_method("real_#{name}?") do |level = 0|
      is_it_this_class?(id, false) && playerclasslevel >= level
    end
  end
end


class Game_Player < Game_Character

  def move_generic(dir, turn_enabled = true)
    turn_generic(dir, true) if turn_enabled
    if !$game_temp.encounter_triggered
      if can_move_in_direction?(dir)
        x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
        y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
        return if pbLedge(x_offset, y_offset)
        return if pbEndSurf(x_offset, y_offset)
        turn_generic(dir, true)
        if !$game_temp.encounter_triggered
          @x += x_offset
          @y += y_offset
          if $PokemonGlobal&.diving || $PokemonGlobal&.surfing
            $stats.distance_surfed += 1
          elsif $PokemonGlobal&.bicycle
            $stats.distance_cycled += 1
          else
            $stats.distance_walked += 1
          end
          $stats.distance_slid_on_ice += 1 if $PokemonGlobal.sliding
          increase_steps
        end
      elsif !check_event_trigger_touch(dir)
        try_pole_vault || bump_into_object
      end
    end
    $game_temp.encounter_triggered = false
  end


def try_pole_vault
  return false unless $player.real_triathlete?(20)
  return false unless $player.running
  return false unless isSelectedThisItem?(:POLE)
  return false if $game_temp.in_menu || $game_temp.in_throwing

  direction = $game_player.direction
  max_range = [$player.playerstamina / 4, 3].min
  return false if max_range < 1

  (2..max_range).each do |amt|
    start_end = getLandingCoords(amt)
    next if start_end.nil?
    x, y = start_end[1]
    next unless $game_map.passableStrict?(x, y, direction, $game_player)
    if pbJumpToward(amt, true, false, direction)
      decreaseStamina(amt * 4)
      return true
    end
  end
  false
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

if $player.real_ranger?
  item = ItemData.new(:CAPTURESTYLUS)
  $bag.add(item, 1)
end
end













class Battle::Battler

  def pbReducePP(move)
    return true if usingMultiTurnAttack?
    return true if move.pp < 0          # Don't reduce PP for special calls of moves
    return true if move.total_pp <= 0   # Infinite PP, can always be used
    return true if $player.not_acting? && @battle.pbOwnedByPlayer?(@index) && rand(5)==1																				   
    return false if move.pp == 0        # Ran out of PP, couldn't reduce
    pbSetPP(move, move.pp - 1) if move.pp > 0
    return true
  end
end

def pbItemRestoreHP(pkmn, restoreHP)
  restoreHP *= 1.5 if $player.nurse?
  pbPlayerEXPPassive(1) if $player.nurse? && rand(100) < 5
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
  hpGain = pbItemRestoreHP(pkmn, restoreHP)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, hpGain))
  return true
end

def pbBattleHPItem(pkmn, battler, restoreHP, scene)
  if battler
    restoreHP *= 1.5 if $player.nurse?
    if battler.pbRecoverHP(restoreHP) > 0
      scene.pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
      pbPlayerEXPPassive(1) if $player.nurse? && rand(100) < 5
    end
  elsif pbItemRestoreHP(pkmn, restoreHP) > 0
    scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  end
  return true
end

