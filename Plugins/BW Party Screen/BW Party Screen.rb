#===============================================================================
# Pokémon party buttons and menu
#===============================================================================
class PokemonPartyConfirmCancelSprite < Sprite
  attr_reader :selected

  def initialize(text, x, y, narrowbox = false, viewport = nil)
    super(viewport)
    @refreshBitmap = true
    @bgsprite = ChangelingSprite.new(0, 0, viewport)
    if narrowbox
      @bgsprite.addBitmap("desel", "Graphics/Pictures/Party/icon_cancel_narrow")
      @bgsprite.addBitmap("sel", "Graphics/Pictures/Party/icon_cancel_narrow_sel")
    else
      @bgsprite.addBitmap("desel", "Graphics/Pictures/Party/icon_cancel")
      @bgsprite.addBitmap("sel", "Graphics/Pictures/Party/icon_cancel_sel")
    end
    @bgsprite.changeBitmap("desel")
    @overlaysprite = BitmapSprite.new(@bgsprite.bitmap.width, @bgsprite.bitmap.height, viewport)
    @overlaysprite.z = self.z + 1
    pbSetSystemFont(@overlaysprite.bitmap)
    @yoffset = 8
# Changed color of text
    textpos = [[text, 56, (narrowbox) ? 0 : 2, 2, Color.new(255,255,255), Color.new(132,132,132)]]
    pbDrawTextPositions(@overlaysprite.bitmap, textpos)
    self.x = x
    self.y = y
  end
  def dispose
    @bgsprite.dispose
    @overlaysprite.bitmap.dispose
    @overlaysprite.dispose
    super
  end
  def viewport=(value)
    super
    refresh
  end
  def x=(value)
    super
    refresh
  end
  def y=(value)
    super
    refresh
  end
  def color=(value)
    super
    refresh
  end
  def selected=(value)
    if @selected != value
      @selected = value
      refresh
    end
  end
  def refresh
    if @bgsprite && !@bgsprite.disposed?
      @bgsprite.changeBitmap((@selected) ? "sel" : "desel")
      @bgsprite.x     = self.x
      @bgsprite.y     = self.y
      @bgsprite.color = self.color
    end
    if @overlaysprite && !@overlaysprite.disposed?
      @overlaysprite.x     = self.x
      @overlaysprite.y     = self.y
      @overlaysprite.color = self.color
    end
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartyCancelSprite < PokemonPartyConfirmCancelSprite
  def initialize(viewport = nil)
# Changed Cancel button position
    super(_INTL("CANCEL"), 378, 328, false, viewport)
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartyConfirmSprite < PokemonPartyConfirmCancelSprite
  def initialize(viewport = nil)
    # Changed Confirm  button position
    super(_INTL("CONFIRM"), 378, 310, true, viewport)
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartyCancelSprite2 < PokemonPartyConfirmCancelSprite
  def initialize(viewport = nil)
    # Changed Cancel button position
    super(_INTL("CANCEL"), 378, 348, true, viewport)
   end
 end

#===============================================================================
#
#===============================================================================
class Window_CommandPokemonColor < Window_CommandPokemon
  def initialize(commands, width = nil)
    @colorKey = []
    commands.length.times do |i|
      if commands[i].is_a?(Array)
        @colorKey[i] = commands[i][1]
        commands[i] = commands[i][0]
      end
    end
    super(commands, width)
  end
  def drawItem(index, _count, rect)
    pbSetSystemFont(self.contents) if @starting
    rect = drawCursor(index, rect)
    base   = self.baseColor
    shadow = self.shadowColor
    if @colorKey[index] && @colorKey[index] == 1
      base   = Color.new(0, 80, 160)
      shadow = Color.new(128, 192, 240)
    end
    pbDrawShadowText(self.contents, rect.x, rect.y + (self.contents.text_offset_y || 0),
                     rect.width, rect.height, @commands[index], base, shadow)
  end
end

#===============================================================================
# Blank party panel
#===============================================================================
class PokemonPartyBlankPanel < Sprite
  attr_accessor :text

  def initialize(_pokemon, index, viewport = nil)
    super(viewport)
    self.x = (index % 2) * Graphics.width / 2
    self.y = (16 * (index % 2)) + (96 * (index / 2))
    if PARTY_B2W2_STYLE
      @panelbgsprite = AnimatedBitmap.new("Graphics/Pictures/Party/panel_blank_B2W2")
    else
      @panelbgsprite = AnimatedBitmap.new("Graphics/Pictures/Party/panel_blank")
    end
    self.bitmap = @panelbgsprite.bitmap
    @text = nil
  end

  def dispose
    @panelbgsprite.dispose
    super
  end
  def selected; return false; end
  def selected=(value); end
  def preselected; return false; end
  def preselected=(value); end
  def switching; return false; end
  def switching=(value); end
  def refresh; end
end

#===============================================================================
# Pokémon party panel
#===============================================================================
class PokemonPartyPanel < Sprite
  attr_reader :pokemon
  attr_reader :active
  attr_reader :selected
  attr_reader :preselected
  attr_reader :switching
  attr_reader :text

# New Colors (change)
    TEXT_BASE_COLOR    = Color.new(255, 255, 255)
    TEXT_SHADOW_COLOR  = Color.new(132, 132, 132)
    HP_BAR_WIDTH       = 96
    STATUS_ICON_WIDTH  = 44
    STATUS_ICON_HEIGHT = 16

  def initialize(pokemon, index, viewport = nil, evoreqs = nil)
    super(viewport)
    @pokemon = pokemon
    @evoreqs = evoreqs
    refresh_evoreqs
    @active = (index == 0)   # true = rounded panel, false = rectangular panel
    @refreshing = true
    self.x = (index % 2) * Graphics.width / 2
    self.y = (16 * (index % 2)) + (96 * (index / 2))
    @panelbgsprite = ChangelingSprite.new(0, 0, viewport)
    @panelbgsprite.z = self.z
    if PARTY_B2W2_STYLE
      if @active   # Rounded panel
        @panelbgsprite.addBitmap("able", "Graphics/Pictures/Party/panel_round_B2W2")
        @panelbgsprite.addBitmap("ablesel", "Graphics/Pictures/Party/panel_round_sel_B2W2")
        @panelbgsprite.addBitmap("fainted", "Graphics/Pictures/Party/panel_round_faint_B2W2")
        @panelbgsprite.addBitmap("faintedsel", "Graphics/Pictures/Party/panel_round_faint_sel_B2W2")
        @panelbgsprite.addBitmap("swap", "Graphics/Pictures/Party/panel_round_swap_B2W2")
        @panelbgsprite.addBitmap("swapsel", "Graphics/Pictures/Party/panel_round_swap_sel_B2W2")
        @panelbgsprite.addBitmap("swapsel2", "Graphics/Pictures/Party/panel_round_swap_sel2_B2W2")
      else   # Rectangular panel
        @panelbgsprite.addBitmap("able", "Graphics/Pictures/Party/panel_rect_B2W2")
        @panelbgsprite.addBitmap("ablesel", "Graphics/Pictures/Party/panel_rect_sel_B2W2")
        @panelbgsprite.addBitmap("fainted", "Graphics/Pictures/Party/panel_rect_faint_B2W2")
        @panelbgsprite.addBitmap("faintedsel", "Graphics/Pictures/Party/panel_rect_faint_sel_B2W2")
        @panelbgsprite.addBitmap("swap", "Graphics/Pictures/Party/panel_rect_swap_B2W2")
        @panelbgsprite.addBitmap("swapsel", "Graphics/Pictures/Party/panel_rect_swap_sel_B2W2")
        @panelbgsprite.addBitmap("swapsel2", "Graphics/Pictures/Party/panel_rect_swap_sel2_B2W2")
      end
    else
      if @active   # Rounded panel
        @panelbgsprite.addBitmap("able", "Graphics/Pictures/Party/panel_round")
        @panelbgsprite.addBitmap("ablesel", "Graphics/Pictures/Party/panel_round_sel")
        @panelbgsprite.addBitmap("fainted", "Graphics/Pictures/Party/panel_round_faint")
        @panelbgsprite.addBitmap("faintedsel", "Graphics/Pictures/Party/panel_round_faint_sel")
        @panelbgsprite.addBitmap("swap", "Graphics/Pictures/Party/panel_round_swap")
        @panelbgsprite.addBitmap("swapsel", "Graphics/Pictures/Party/panel_round_swap_sel")
        @panelbgsprite.addBitmap("swapsel2", "Graphics/Pictures/Party/panel_round_swap_sel2")
      else   # Rectangular panel
        @panelbgsprite.addBitmap("able", "Graphics/Pictures/Party/panel_rect")
        @panelbgsprite.addBitmap("ablesel", "Graphics/Pictures/Party/panel_rect_sel")
        @panelbgsprite.addBitmap("fainted", "Graphics/Pictures/Party/panel_rect_faint")
        @panelbgsprite.addBitmap("faintedsel", "Graphics/Pictures/Party/panel_rect_faint_sel")
        @panelbgsprite.addBitmap("swap", "Graphics/Pictures/Party/panel_rect_swap")
        @panelbgsprite.addBitmap("swapsel", "Graphics/Pictures/Party/panel_rect_swap_sel")
        @panelbgsprite.addBitmap("swapsel2", "Graphics/Pictures/Party/panel_rect_swap_sel2")
      end
    end
    @hpbgsprite = ChangelingSprite.new(0, 0, viewport)
    @hpbgsprite.z = self.z + 1
	@ballsprite = ChangelingSprite.new(0, 0, viewport)
    @ballsprite.z = self.z + 5
	
    if PARTY_B2W2_STYLE
      @hpbgsprite.addBitmap("able", "Graphics/Pictures/Party/overlay_hp_back_B2W2")
      @hpbgsprite.addBitmap("fainted", "Graphics/Pictures/Party/overlay_hp_back_faint_B2W2")
      @hpbgsprite.addBitmap("swap", "Graphics/Pictures/Party/overlay_hp_back_swap_B2W2")
    else
	@ballsprite = ChangelingSprite.new(0, 0, viewport)
      @ballsprite.z = self.z + 5
      @hpbgsprite.addBitmap("able", "Graphics/Pictures/Party/overlay_hp_back")
      @hpbgsprite.addBitmap("fainted", "Graphics/Pictures/Party/overlay_hp_back_faint")
      @hpbgsprite.addBitmap("swap", "Graphics/Pictures/Party/overlay_hp_back_swap")

	end
    # Removed the balls from summary
    @pkmnsprite = PokemonIconSprite.new(pokemon, viewport)
    @pkmnsprite.setOffset(PictureOrigin::CENTER)
    @pkmnsprite.active = @active
    @pkmnsprite.z      = self.z + 2
    @helditemsprite = HeldItemIconSprite.new(0, 0, @pokemon, viewport)
    @helditemsprite.z = self.z + 3
    @overlaysprite = BitmapSprite.new(Graphics.width, Graphics.height, viewport)
    @overlaysprite.z = self.z + 4
    pbSetSystemFont(@overlaysprite.bitmap)
    @hpbar    = AnimatedBitmap.new("Graphics/Pictures/Party/overlay_hp")
    @statuses = AnimatedBitmap.new(_INTL("Graphics/Pictures/statuses"))
    @selected      = false
    @preselected   = false
    @switching     = false
    @text          = nil
    @refreshBitmap = true
    @refreshing    = false
    refresh
  end

  def dispose
    @panelbgsprite.dispose
    @hpbgsprite.dispose
    @ballsprite.dispose
    @pkmnsprite.dispose
    @helditemsprite.dispose
    @overlaysprite.bitmap.dispose
    @overlaysprite.dispose
    @hpbar.dispose
    @statuses.dispose
    super
  end

  def x=(value)
    super
    refresh
  end

  def y=(value)
    super
    refresh
  end

  def color=(value)
    super
    refresh
  end

  def text=(value)
    return if @text == value
    @text = value
    @refreshBitmap = true
    refresh
  end

  def pokemon=(value)
    @pokemon = value
    refresh_evoreqs
    @pkmnsprite.pokemon = value if @pkmnsprite && !@pkmnsprite.disposed?
    @helditemsprite.pokemon = value if @helditemsprite && !@helditemsprite.disposed?
    @refreshBitmap = true
    refresh
  end

  def selected=(value)
    return if @selected == value
    @selected = value
    refresh
  end

  def preselected=(value)
    return if @preselected == value
    @preselected = value
    refresh
  end

  def switching=(value)
    return if @switching == value
    @switching = value
    refresh
  end

  def hp; return @pokemon.hp; end

  def refresh_evoreqs
    return if @pokemon.egg? || @evoreqs.nil?
    # [new_species, item[optional]
    @evoreqs.clear
    # [new_species, method, parameter, boolean]
    GameData::Species.get(@pokemon.species).get_evolutions(true).each do |evo|
      case evo[1].to_s
      when "TradeSpecies"
        # menu handler shouldnt care what species it requires since its checked here
        # its not like you lose the mon or anything
        @evoreqs.push([evo[0], nil]) if $player.has_species?(evo[2])
      when /\AItem/
        @evoreqs.push([evo[0], evo[2]]) if $bag.has?(evo[2]) && @pokemon.check_evolution_on_use_item(evo[2])
      when /\ATrade/
        # technically should pass a Pokemon object but if that ever becomes relevant something must have gone wrong
        @evoreqs.push([evo[0], evo[2]]) if @pokemon.check_evolution_on_trade(nil)
      else
        @evoreqs.push([evo[0], nil]) if @pokemon.check_evolution_on_level_up
      end
    end
  end


  def refresh_panel_graphic
    return if !@panelbgsprite || @panelbgsprite.disposed?
    if self.selected
      if self.preselected
        @panelbgsprite.changeBitmap("swapsel2")
      elsif @switching
        @panelbgsprite.changeBitmap("swapsel")
      elsif @pokemon.fainted?
        @panelbgsprite.changeBitmap("faintedsel")
      else
        @panelbgsprite.changeBitmap("ablesel")
      end
    else
      if self.preselected
        @panelbgsprite.changeBitmap("swap")
      elsif @pokemon.fainted?
        @panelbgsprite.changeBitmap("fainted")
      else
        @panelbgsprite.changeBitmap("able")
      end
    end
    @panelbgsprite.x     = self.x
    @panelbgsprite.y     = self.y
    @panelbgsprite.color = self.color
  end

  def refresh_hp_bar_graphic
    return if !@hpbgsprite || @hpbgsprite.disposed?
    @hpbgsprite.visible = (!@pokemon.egg? && !(@text && @text.length > 0))
    return if !@hpbgsprite.visible
    if self.preselected || (self.selected && @switching)
      @hpbgsprite.changeBitmap("swap")
    elsif @pokemon.fainted?
      @hpbgsprite.changeBitmap("fainted")
    else
      @hpbgsprite.changeBitmap("able")
    end
    @hpbgsprite.x     = self.x + 96
    @hpbgsprite.y     = self.y + 50
    @hpbgsprite.color = self.color
  end

  def refresh_ball_graphic
    return if !@ballsprite || @ballsprite.disposed?
    bitmapname = (self.selected) ? "sel" : "desel"
    bitmapname << "_canevo" unless @evoreqs.nil? || @evoreqs.empty?
    @ballsprite.changeBitmap(bitmapname)
    @ballsprite.x     = self.x + 10
    @ballsprite.y     = self.y
    @ballsprite.color = self.color
  end

  def refresh_pokemon_icon
    return if !@pkmnsprite || @pkmnsprite.disposed?
    @pkmnsprite.x        = self.x + 60
    @pkmnsprite.y        = self.y + 40
    @pkmnsprite.color    = self.color
    @pkmnsprite.selected = self.selected
  end

  def refresh_held_item_icon
    return if !@helditemsprite || @helditemsprite.disposed? || !@helditemsprite.visible
    @helditemsprite.x     = self.x + 62
    @helditemsprite.y     = self.y + 48
    @helditemsprite.color = self.color
  end

  def refresh_overlay_information
    return if !@refreshBitmap
    @overlaysprite.bitmap&.clear
    draw_name
    draw_level
    draw_gender
    draw_hp
    draw_status
    draw_shiny_icon
    draw_annotation
  end

  def draw_name
    # Draw Pokémon name
    pbDrawTextPositions(@overlaysprite.bitmap,
                        [[@pokemon.name, 96, 19, 0, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR]])
  end

  def draw_level
    return if @pokemon.egg?
    # Draw "Lv" graphic
      if PARTY_B2W2_STYLE
    pbDrawImagePositions(@overlaysprite.bitmap,
                         [["Graphics/Pictures/Party/overlay_lv", 20, 72, 0, 0, 22, 14]])
                       else
    pbDrawImagePositions(@overlaysprite.bitmap,
                         [["Graphics/Pictures/Party/overlay_lv", 20, 62, 0, 0, 22, 14]])
          end
    # Draw Level number
    pbSetSmallFont(@overlaysprite.bitmap)
      if PARTY_B2W2_STYLE
    pbDrawTextPositions(@overlaysprite.bitmap,
                        [[@pokemon.level.to_s, 42, 67, 0, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR]])
                      else
    pbDrawTextPositions(@overlaysprite.bitmap,
                        [[@pokemon.level.to_s, 42, 52, 0, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR]])
        end
    pbSetSystemFont(@overlaysprite.bitmap)
  end

  # Draw Gender Icon
  def draw_gender
    return if @pokemon.egg? || @pokemon.genderless?
    gender_text  = (@pokemon.male?) ? _INTL("♂") : _INTL("♀")
    base_color   = (@pokemon.male?) ? Color.new(0, 239, 255) : Color.new(231, 57, 57)
    shadow_color = (@pokemon.male?) ? Color.new(0, 107, 99) : Color.new(115, 33, 49)
    pbDrawTextPositions(@overlaysprite.bitmap,
                        [[gender_text, 228, 18, 0, base_color, shadow_color]])
  end

  def draw_hp
    return if @pokemon.egg? || (@text && @text.length > 0)
    # Draw HP numbers
    hp_text = sprintf("% 3d /% 3d", @pokemon.hp, @pokemon.totalhp)
    pbDrawTextPositions(@overlaysprite.bitmap,
                        [[hp_text, 226, 56, 1, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR]])
    # Draw HP bar
    if @pokemon.able?
      w = @pokemon.hp * HP_BAR_WIDTH / @pokemon.totalhp.to_f
      w = 1 if w < 1
      w = ((w / 2).round) * 2   # Round to the nearest 2 pixels
      hpzone = 0
      hpzone = 1 if @pokemon.hp <= (@pokemon.totalhp / 2).floor
      hpzone = 2 if @pokemon.hp <= (@pokemon.totalhp / 4).floor
      hprect = Rect.new(0, hpzone * 8, w, 8)
      if PARTY_B2W2_STYLE
          @overlaysprite.bitmap.blt(128, 54, @hpbar.bitmap, hprect)
            else
          @overlaysprite.bitmap.blt(128, 52, @hpbar.bitmap, hprect)
        end
    end
  end

  def draw_status
    return if @pokemon.egg? || (@text && @text.length > 0)
    status = -1
    if @pokemon.fainted?
      status = GameData::Status.count - 1
    elsif @pokemon.status != :NONE
      status = GameData::Status.get(@pokemon.status).icon_position
    elsif @pokemon.pokerusStage == 1
      status = GameData::Status.count
    end
    return if status < 0
    statusrect = Rect.new(0, STATUS_ICON_HEIGHT * status, STATUS_ICON_WIDTH, STATUS_ICON_HEIGHT)
    @overlaysprite.bitmap.blt(78, 68, @statuses.bitmap, statusrect)
  end

  # Draw Shiny Icon
  def draw_shiny_icon
    return if @pokemon.egg? || !@pokemon.shiny?
    pbDrawImagePositions(@overlaysprite.bitmap,
                         [["Graphics/Pictures/shiny", 80, 48, 0, 0, 16, 16]])
  end

  # Draw annotation text
  def draw_annotation
    return if !@text || @text.length == 0
    pbDrawTextPositions(@overlaysprite.bitmap,
                        [[@text, 96, 49, 0, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR]])
  end

  def refresh
    return if disposed?
    return if @refreshing
    @refreshing = true
    refresh_panel_graphic
    refresh_hp_bar_graphic
    refresh_ball_graphic
    refresh_pokemon_icon
    refresh_held_item_icon
    if @overlaysprite && !@overlaysprite.disposed?
      @overlaysprite.x     = self.x
      @overlaysprite.y     = self.y
      @overlaysprite.color = self.color
    end
    refresh_overlay_information
    @refreshBitmap = false
    @refreshing = false
  end

  def update
    super
    @panelbgsprite.update if @panelbgsprite && !@panelbgsprite.disposed?
    @hpbgsprite.update if @hpbgsprite && !@hpbgsprite.disposed?
    @ballsprite.update if @ballsprite && !@ballsprite.disposed?
    @pkmnsprite.update if @pkmnsprite && !@pkmnsprite.disposed?
    @helditemsprite.update if @helditemsprite && !@helditemsprite.disposed?
  end
end

#===============================================================================
# Pokémon party visuals
#===============================================================================
class PokemonParty_Scene
  attr_reader :all_evoreqs

  def pbStartScene(party, starthelptext, annotations = nil, multiselect = false, can_access_storage = false)
    @sprites = {}
    @party = party
    @all_evoreqs = []
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @multiselect = multiselect
    @can_access_storage = can_access_storage
    if PARTY_B2W2_STYLE
      addBackgroundPlane(@sprites, "partybg", "Party/bg_B2W2", @viewport)
    else
      addBackgroundPlane(@sprites, "partybg", "Party/bg", @viewport)
    end
    @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].z              = 50
    @sprites["messagebox"].viewport       = @viewport
    @sprites["messagebox"].visible        = false
    # Changed the Windows Box Skin
    @sprites["messagebox"].setSkin("Graphics/Windowskins/bw choice")
    @sprites["messagebox"].letterbyletter = true
    pbBottomLeftLines(@sprites["messagebox"], 2)
    @sprites["storagetext"] = Window_UnformattedTextPokemon.new(
      @can_access_storage ? _INTL("[Special]: To Boxes") : ""
    )
    @sprites["storagetext"].x           = 32
    @sprites["storagetext"].y           = Graphics.height - @sprites["messagebox"].height - 16
    @sprites["storagetext"].z           = 10
    @sprites["storagetext"].viewport    = @viewport
    @sprites["storagetext"].baseColor   = Color.new(255, 255, 255)
    @sprites["storagetext"].shadowColor = Color.new(132, 132, 132)
    @sprites["storagetext"].windowskin  = nil
    @sprites["helpwindow"] = Window_UnformattedTextPokemon.new(starthelptext)
    @sprites["helpwindow"].viewport = @viewport
    @sprites["helpwindow"].visible  = true
    pbBottomLeftLines(@sprites["helpwindow"], 1)
    # Changed the Windows Box Skin
    @sprites["helpwindow"].setSkin("Graphics/Windowskins/bw choice")
    pbBottomLeftLines(@sprites["helpwindow"],1)
    pbSetHelpText(starthelptext)
    # Add party Pokémon sprites
    Settings::MAX_PARTY_SIZE.times do |i|
      if @party[i]
        @sprites["pokemon#{i}"] = PokemonPartyPanel.new(@party[i], i, @viewport, (@all_evoreqs[i] = []))
      else
        @sprites["pokemon#{i}"] = PokemonPartyBlankPanel.new(@party[i], i, @viewport)
      end
      @sprites["pokemon#{i}"].text = annotations[i] if annotations
    end
    if @multiselect
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyConfirmSprite.new(@viewport)
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE + 1}"] = PokemonPartyCancelSprite2.new(@viewport)
    else
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyCancelSprite.new(@viewport)
    end
    # Select first Pokémon
    @activecmd = 0
    @sprites["pokemon0"].selected = true
    pbFadeInAndShow(@sprites) { update }
  end

  def pbEndScene
      pbFadeOutAndHide(@sprites) { update }
      pbDisposeSpriteHash(@sprites)
      @viewport.dispose
  end
    def pbDisplay(text)
      @sprites["messagebox"].text    = text
      @sprites["messagebox"].visible = true
      @sprites["helpwindow"].visible = false
      pbPlayDecisionSE				   
      loop do
        Graphics.update
        Input.update		
        self.update
        if @sprites["messagebox"].busy?
          if Input.trigger?(Input::USE)
            pbPlayDecisionSE if @sprites["messagebox"].pausing?
            @sprites["messagebox"].resume
          end
        elsif Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
          break
        end
      end
      @sprites["messagebox"].visible = false
      @sprites["helpwindow"].visible = true
    end
	
    def pbDisplayConfirm(text)
      ret = -1
      @sprites["messagebox"].text    = text
      @sprites["messagebox"].visible = true
      @sprites["helpwindow"].visible = false
      using(cmdwindow = Window_CommandPokemon.new([_INTL("Yes"), _INTL("No")])) {
        cmdwindow.visible = false
        pbBottomRight(cmdwindow)
        cmdwindow.y -= @sprites["messagebox"].height
        cmdwindow.z = @viewport.z + 1
        loop do
          Graphics.update
          Input.update
          cmdwindow.visible = true if !@sprites["messagebox"].busy?
          cmdwindow.update
          self.update
          if !@sprites["messagebox"].busy?
            if Input.trigger?(Input::BACK)
              ret = false
              break
            elsif Input.trigger?(Input::USE) && @sprites["messagebox"].resume
              ret = (cmdwindow.index == 0)
              break
            end
          end
        end
      }
      @sprites["messagebox"].visible = false
      @sprites["helpwindow"].visible = true
      return ret
    end
    def pbShowCommands(helptext, commands, index = 0)
      ret = -1
      helpwindow = @sprites["helpwindow"]
      helpwindow.visible = true
      using(cmdwindow = Window_CommandPokemonColor.new(commands)) {
        cmdwindow.z     = @viewport.z + 1
        cmdwindow.index = index
        pbBottomRight(cmdwindow)
        helpwindow.resizeHeightToFit(helptext, Graphics.width - cmdwindow.width)
        helpwindow.text = helptext
        pbBottomLeft(helpwindow)
        loop do
          Graphics.update
          Input.update
          cmdwindow.update
          self.update
          if Input.trigger?(Input::BACK)
            pbPlayCancelSE
            ret = -1
            break
          elsif Input.trigger?(Input::USE)
            pbPlayDecisionSE
            ret = cmdwindow.index
            break
          end
        end 
      }								 
      return ret
    end
    def pbChooseNumber(helptext, maximum, initnum = 1)
      return UIHelper.pbChooseNumber(@sprites["helpwindow"], helptext, maximum, initnum) { update }
    end

  def pbSetHelpText(helptext)
    helpwindow = @sprites["helpwindow"]
    pbBottomLeftLines(helpwindow, 1)
    helpwindow.text = helptext
    # Changed help window width
    helpwindow.width = 378
    helpwindow.visible = true
  end

  def pbHasAnnotations?
    return !@sprites["pokemon0"].text.nil?
  end

  def pbAnnotate(annot)
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].text = (annot) ? annot[i] : nil
    end
  end

  def pbSelect(item)
    @activecmd = item
    numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
    numsprites.times do |i|
      @sprites["pokemon#{i}"].selected = (i == @activecmd)
    end
  end

  def pbPreSelect(item)
    @activecmd = item
  end

  def pbSwitchBegin(oldid, newid)
    pbSEPlay("GUI party switch")
    oldsprite = @sprites["pokemon#{oldid}"]
    newsprite = @sprites["pokemon#{newid}"]
    timeTaken = Graphics.frame_rate * 4 / 10
    distancePerFrame = (Graphics.width / (2.0 * timeTaken)).ceil
    timeTaken.times do
      oldsprite.x += (oldid & 1) == 0 ? -distancePerFrame : distancePerFrame
      newsprite.x += (newid & 1) == 0 ? -distancePerFrame : distancePerFrame
      Graphics.update
      Input.update
      self.update
    end
  end

  def pbSwitchEnd(oldid, newid)
    pbSEPlay("GUI party switch")
    oldsprite = @sprites["pokemon#{oldid}"]
    newsprite = @sprites["pokemon#{newid}"]
    oldsprite.pokemon = @party[oldid]
    newsprite.pokemon = @party[newid]
    timeTaken = Graphics.frame_rate * 4 / 10
    distancePerFrame = (Graphics.width / (2.0 * timeTaken)).ceil
    timeTaken.times do
      oldsprite.x -= (oldid & 1) == 0 ? -distancePerFrame : distancePerFrame
      newsprite.x -= (newid & 1) == 0 ? -distancePerFrame : distancePerFrame
      Graphics.update
      Input.update
      self.update
    end
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].preselected = false
      @sprites["pokemon#{i}"].switching   = false
    end
    pbRefresh
  end

  def pbClearSwitching
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].preselected = false
      @sprites["pokemon#{i}"].switching   = false
    end
  end

  def pbSummary(pkmnid, inbattle = false)
    oldsprites = pbFadeOutAndHide(@sprites)
    scene = PokemonSummary_Scene.new
    screen = PokemonSummaryScreen.new(scene, inbattle)
    screen.pbStartScreen(@party, pkmnid)
    yield if block_given?
    pbFadeInAndShow(@sprites, oldsprites)
  end

  def pbChooseItem(bag)
    ret = nil
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, bag)
      ret = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).can_hold? })
      yield if block_given?
    }
    return ret
  end

  def pbUseItem(bag, pokemon)
    ret = nil
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, bag)
      ret = screen.pbChooseItemScreen(proc { |item|
        itm = GameData::Item.get(item)
        next false if !pbCanUseOnPokemon?(itm)
        next false if pokemon.hyper_mode && !GameData::Item.get(item)&.is_scent?
        if itm.is_machine?
          move = itm.move
          next false if pokemon.hasMove?(move) || !pokemon.compatible_with_move?(move)
        end
        next true
      })
      yield if block_given?
    }
    return ret
  end

  def pbChoosePokemon(switching = false, initialsel = -1, canswitch = 0)
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].preselected = (switching && i == @activecmd)
      @sprites["pokemon#{i}"].switching   = switching
    end
    @activecmd = initialsel if initialsel >= 0
    pbRefresh
    loop do
      Graphics.update
      Input.update
      self.update
      oldsel = @activecmd
      key = -1
      key = Input::DOWN if Input.repeat?(Input::DOWN)
      key = Input::RIGHT if Input.repeat?(Input::RIGHT)
      key = Input::LEFT if Input.repeat?(Input::LEFT)
      key = Input::UP if Input.repeat?(Input::UP)
      if key >= 0
        @activecmd = pbChangeSelection(key, @activecmd)
      end
      if @activecmd != oldsel   # Changing selection
        pbPlayCursorSE
        numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
        numsprites.times do |i|
          @sprites["pokemon#{i}"].selected = (i == @activecmd)
        end
      end
      cancelsprite = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 1 : 0)
      if Input.trigger?(Input::SPECIAL) && @can_access_storage && canswitch != 2
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonStorageScene.new
          screen = PokemonStorageScreen.new(scene, $PokemonStorage)
          screen.pbStartScreen(0)
          pbHardRefresh
        }
      elsif Input.trigger?(Input::ACTION) && canswitch == 1 && @activecmd != cancelsprite
        pbPlayDecisionSE
        return [1, @activecmd]
      elsif Input.trigger?(Input::ACTION) && canswitch == 2
        return -1
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE if !switching
        return -1
      elsif Input.trigger?(Input::USE)
        if @activecmd == cancelsprite
          (switching) ? pbPlayDecisionSE : pbPlayCloseMenuSE
          return -1
        else
          pbPlayDecisionSE
          return @activecmd
        end
      end
    end
  end

  def pbChangeSelection(key, currentsel)
    numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
    case key
    when Input::LEFT
      loop do
        currentsel -= 1
        break unless currentsel > 0 && currentsel < @party.length && !@party[currentsel]
      end
      if currentsel >= @party.length && currentsel < Settings::MAX_PARTY_SIZE
        currentsel = @party.length - 1
      end
      currentsel = numsprites - 1 if currentsel < 0
    when Input::RIGHT
      loop do
        currentsel += 1
        break unless currentsel < @party.length && !@party[currentsel]
      end
      if currentsel == @party.length
        currentsel = Settings::MAX_PARTY_SIZE
      elsif currentsel == numsprites
        currentsel = 0
      end
    when Input::UP
      if currentsel >= Settings::MAX_PARTY_SIZE
        currentsel -= 1
        while currentsel > 0 && currentsel < Settings::MAX_PARTY_SIZE && !@party[currentsel]
          currentsel -= 1
        end
      else
        loop do
          currentsel -= 2
          break unless currentsel > 0 && !@party[currentsel]
        end
      end
      if currentsel >= @party.length && currentsel < Settings::MAX_PARTY_SIZE
        currentsel = @party.length - 1
      end
      currentsel = numsprites - 1 if currentsel < 0
    when Input::DOWN
      if currentsel >= Settings::MAX_PARTY_SIZE - 1
        currentsel += 1
      else
        currentsel += 2
        currentsel = Settings::MAX_PARTY_SIZE if currentsel < Settings::MAX_PARTY_SIZE && !@party[currentsel]
      end
      if currentsel >= @party.length && currentsel < Settings::MAX_PARTY_SIZE
        currentsel = Settings::MAX_PARTY_SIZE
      elsif currentsel >= numsprites
        currentsel = 0
      end
    end
    return currentsel
  end

  def pbHardRefresh
    oldtext = []
    lastselected = -1
    Settings::MAX_PARTY_SIZE.times do |i|
      oldtext.push(@sprites["pokemon#{i}"].text)
      lastselected = i if @sprites["pokemon#{i}"].selected
      @sprites["pokemon#{i}"].dispose
    end
    lastselected = @party.length - 1 if lastselected >= @party.length
    lastselected = 0 if lastselected < 0
    Settings::MAX_PARTY_SIZE.times do |i|
      if @party[i]
        @sprites["pokemon#{i}"] = PokemonPartyPanel.new(@party[i], i, @viewport, (@all_evoreqs[i] = []))
      else
        @sprites["pokemon#{i}"] = PokemonPartyBlankPanel.new(@party[i], i, @viewport)
      end
      @sprites["pokemon#{i}"].text = oldtext[i]
    end
    pbSelect(lastselected)
  end

  def pbRefresh
    Settings::MAX_PARTY_SIZE.times do |i|
      sprite = @sprites["pokemon#{i}"]
      if sprite
        if sprite.is_a?(PokemonPartyPanel)
          sprite.pokemon = sprite.pokemon
        else
          sprite.refresh
        end
      end
    end
  end

  def pbRefreshSingle(i)
    sprite = @sprites["pokemon#{i}"]
    if sprite
      if sprite.is_a?(PokemonPartyPanel)
        sprite.pokemon = sprite.pokemon
      else
        sprite.refresh
      end
    end
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end
end

#===============================================================================
# Pokémon party mechanics
#===============================================================================
class PokemonPartyScreen
  attr_reader :scene
  attr_reader :party

  def initialize(scene, party)
    @scene = scene
    @party = party
  end

  def pbStartScene(helptext, _numBattlersOut, annotations = nil)
    @scene.pbStartScene(@party, helptext, annotations)
  end

  def pbChoosePokemon(helptext = nil)
    @scene.pbSetHelpText(helptext) if helptext
    return @scene.pbChoosePokemon
  end

  def pbPokemonGiveScreen(item)
    @scene.pbStartScene(@party, _INTL("Give to which Pokémon?"))
    pkmnid = @scene.pbChoosePokemon
    ret = false
    if pkmnid >= 0
      ret = pbGiveItemToPokemon(item, @party[pkmnid], self, pkmnid)
    end
    pbRefreshSingle(pkmnid)
    @scene.pbEndScene
    return ret
  end

  def pbPokemonGiveMailScreen(mailIndex)
    @scene.pbStartScene(@party, _INTL("Give to which Pokémon?"))
    pkmnid = @scene.pbChoosePokemon
    if pkmnid >= 0
      pkmn = @party[pkmnid]
      if pkmn.hasItem? || pkmn.mail
        pbDisplay(_INTL("This Pokémon is holding an item. It can't hold mail."))
      elsif pkmn.egg?
        pbDisplay(_INTL("Eggs can't hold mail."))
      else
        pbDisplay(_INTL("Mail was transferred from the Mailbox."))
        pkmn.mail = $PokemonGlobal.mailbox[mailIndex]
        pkmn.item = pkmn.mail.item
        $PokemonGlobal.mailbox.delete_at(mailIndex)
        pbRefreshSingle(pkmnid)
      end
    end
    @scene.pbEndScene
  end

  def pbEndScene
    @scene.pbEndScene
  end

  def pbUpdate
    @scene.update
  end

  def pbHardRefresh
    @scene.pbHardRefresh
  end

  def pbRefresh
    @scene.pbRefresh
  end

  def pbRefreshSingle(i)
    @scene.pbRefreshSingle(i)
  end

  def pbDisplay(text)
    @scene.pbDisplay(text)
  end

  def pbConfirm(text)
    return @scene.pbDisplayConfirm(text)
  end

  def pbShowCommands(helptext, commands, index = 0)
    return @scene.pbShowCommands(helptext, commands, index)
  end

  # Checks for identical species
  def pbCheckSpecies(array)   # Unused
    array.length.times do |i|
      (i + 1...array.length).each do |j|
        return false if array[i].species == array[j].species
      end
    end
    return true
  end

  # Checks for identical held items
  def pbCheckItems(array)   # Unused
    array.length.times do |i|
      next if !array[i].hasItem?
      (i + 1...array.length).each do |j|
        return false if array[i].item == array[j].item
      end
    end
    return true
  end

  def pbSwitch(oldid, newid)
    if oldid != newid
      @scene.pbSwitchBegin(oldid, newid)
      tmp = @party[oldid]
      @party[oldid] = @party[newid]
      @party[newid] = tmp
      @scene.pbSwitchEnd(oldid, newid)
    end
  end

  def pbChooseMove(pokemon, helptext, index = 0)
    movenames = []
    pokemon.moves.each do |i|
      next if !i || !i.id
      if i.total_pp <= 0
        movenames.push(_INTL("{1} (PP: ---)", i.name))
      else
        movenames.push(_INTL("{1} (PP: {2}/{3})", i.name, i.pp, i.total_pp))
      end
    end
    return @scene.pbShowCommands(helptext, movenames, index)
  end

  def pbRefreshAnnotations(ableProc)   # For after using an evolution stone
    return if !@scene.pbHasAnnotations?
    annot = []
    @party.each do |pkmn|
      elig = ableProc.call(pkmn)
      annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
    end
    @scene.pbAnnotate(annot)
  end

  def pbClearAnnotations
    @scene.pbAnnotate(nil)
  end

  def pbPokemonMultipleEntryScreenEx(ruleset)
    annot = []
    statuses = []
    ordinals = [_INTL("INELIGIBLE"), _INTL("NOT ENTERED"), _INTL("BANNED")]
    positions = [_INTL("FIRST"), _INTL("SECOND"), _INTL("THIRD"), _INTL("FOURTH"),
                 _INTL("FIFTH"), _INTL("SIXTH"), _INTL("SEVENTH"), _INTL("EIGHTH"),
                 _INTL("NINTH"), _INTL("TENTH"), _INTL("ELEVENTH"), _INTL("TWELFTH")]
    Settings::MAX_PARTY_SIZE.times do |i|
      if i < positions.length
        ordinals.push(positions[i])
      else
        ordinals.push("#{i + 1}th")
      end
    end
    return nil if !ruleset.hasValidTeam?(@party)
    ret = nil
    addedEntry = false
    @party.length.times do |i|
      statuses[i] = (ruleset.isPokemonValid?(@party[i])) ? 1 : 2
      annot[i] = ordinals[statuses[i]]
    end
    @scene.pbStartScene(@party, _INTL("Choose Pokémon and confirm."), annot, true)
    loop do
      realorder = []
      @party.length.times do |i|
        @party.length.times do |j|
          if statuses[j] == i + 3
            realorder.push(j)
            break
          end
        end
      end
      realorder.length.times do |i|
        statuses[realorder[i]] = i + 3
      end
      @party.length.times do |i|
        annot[i] = ordinals[statuses[i]]
      end
      @scene.pbAnnotate(annot)
      if realorder.length == ruleset.number && addedEntry
        @scene.pbSelect(Settings::MAX_PARTY_SIZE)
      end
      @scene.pbSetHelpText(_INTL("Choose Pokémon and confirm."))
      pkmnid = @scene.pbChoosePokemon
      addedEntry = false
      if pkmnid == Settings::MAX_PARTY_SIZE   # Confirm was chosen
        ret = []
        realorder.each do |i|
          ret.push(@party[i])
        end
        error = []
        break if ruleset.isValid?(ret, error)
        pbDisplay(error[0])
        ret = nil
      end
      break if pkmnid < 0   # Cancelled
      cmdEntry   = -1
      cmdNoEntry = -1
      cmdSummary = -1
      commands = []
      if (statuses[pkmnid] || 0) == 1
        commands[cmdEntry = commands.length]   = _INTL("Entry")
      elsif (statuses[pkmnid] || 0) > 2
        commands[cmdNoEntry = commands.length] = _INTL("No Entry")
      end
      pkmn = @party[pkmnid]
      commands[cmdSummary = commands.length]   = _INTL("Summary")
      commands[commands.length]                = _INTL("Cancel")
      command = @scene.pbShowCommands(_INTL("Do what with {1}?", pkmn.name), commands) if pkmn
      if cmdEntry >= 0 && command == cmdEntry
        if realorder.length >= ruleset.number && ruleset.number > 0
          pbDisplay(_INTL("No more than {1} Pokémon may enter.", ruleset.number))
        else
          statuses[pkmnid] = realorder.length + 3
          addedEntry = true
          pbRefreshSingle(pkmnid)
        end
      elsif cmdNoEntry >= 0 && command == cmdNoEntry
        statuses[pkmnid] = 1
        pbRefreshSingle(pkmnid)
      elsif cmdSummary >= 0 && command == cmdSummary
        @scene.pbSummary(pkmnid) {
          @scene.pbSetHelpText((@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
        }
      end
    end
    @scene.pbEndScene
    return ret
  end

  def pbChooseAblePokemon(ableProc, allowIneligible = false)
    annot = []
    eligibility = []
    @party.each do |pkmn|
      elig = ableProc.call(pkmn)
      eligibility.push(elig)
      annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
    end
    ret = -1
    @scene.pbStartScene(
      @party,
      (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
      annot
    )
    loop do
      @scene.pbSetHelpText(
        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
      )
      pkmnid = @scene.pbChoosePokemon
      break if pkmnid < 0
      if !eligibility[pkmnid] && !allowIneligible
        pbDisplay(_INTL("This Pokémon can't be chosen."))
      else
        ret = pkmnid
        break
      end
    end
    @scene.pbEndScene
    return ret
  end

  def pbChooseTradablePokemon(ableProc, allowIneligible = false)
    annot = []
    eligibility = []
    @party.each do |pkmn|
      elig = ableProc.call(pkmn)
      elig = false if pkmn.egg? || pkmn.shadowPokemon? || pkmn.cannot_trade
      eligibility.push(elig)
      annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
    end
    ret = -1
    @scene.pbStartScene(
      @party,
      (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
      annot
    )
    loop do
      @scene.pbSetHelpText(
        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
      )
      pkmnid = @scene.pbChoosePokemon
      break if pkmnid < 0
      if !eligibility[pkmnid] && !allowIneligible
        pbDisplay(_INTL("This Pokémon can't be chosen."))
      else
        ret = pkmnid
        break
      end
    end
    @scene.pbEndScene
    return ret
  end

  def pbPokemonScreen
    can_access_storage = false
    if ($player.has_box_link || $bag.has?(:POKEMONBOXLINK)) &&
       !$game_switches[Settings::DISABLE_BOX_LINK_SWITCH] &&
       !$game_map.metadata&.has_flag?("DisableBoxLink")
      can_access_storage = true
    end
    @scene.pbStartScene(@party,
                        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
                        nil, false, can_access_storage)
    # Main loop
    loop do
      # Choose a Pokémon or cancel or press Action to quick switch
      @scene.pbSetHelpText((@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
      party_idx = @scene.pbChoosePokemon(false, -1, 1)
      break if (party_idx.is_a?(Numeric) && party_idx < 0) || (party_idx.is_a?(Array) && party_idx[1] < 0)
      # Quick switch
      if party_idx.is_a?(Array) && party_idx[0] == 1   # Switch
        @scene.pbSetHelpText(_INTL("Move to where?"))
        old_party_idx = party_idx[1]
        party_idx = @scene.pbChoosePokemon(true, -1, 2)
        pbSwitch(old_party_idx, party_idx) if party_idx >= 0 && party_idx != old_party_idx
        next
      end
      # Chose a Pokémon
      pkmn = @party[party_idx]
      # Get all commands
      command_list = []
      commands = []
      MenuHandlers.each_available(:party_menu, self, @party, party_idx) do |option, hash, name|
        command_list.push(name)
        commands.push(hash)
      end
      command_list.push(_INTL("Cancel"))
      # Add field move commands
      if !pkmn.egg?
        insert_index = ($DEBUG) ? 2 : 1
        pkmn.moves.each_with_index do |move, i|
          next if !HiddenMoveHandlers.hasHandler(move.id) &&
                  ![:MILKDRINK, :SOFTBOILED].include?(move.id)
          command_list.insert(insert_index, [move.name, 1])
          commands.insert(insert_index, i)
          insert_index += 1
        end
      end
      # Choose a menu option
      choice = @scene.pbShowCommands(_INTL("Do what with {1}?", pkmn.name), command_list)
      next if choice < 0 || choice >= commands.length
      # Effect of chosen menu option
      case commands[choice]
      when Hash   # Option defined via a MenuHandler below
        commands[choice]["effect"].call(self, @party, party_idx)
      when Integer   # Hidden move's index
        move = pkmn.moves[commands[choice]]
        if [:MILKDRINK, :SOFTBOILED].include?(move.id)
          amt = [(pkmn.totalhp / 5).floor, 1].max
          if pkmn.hp <= amt
            pbDisplay(_INTL("Not enough HP..."))
            next
          end
          @scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
          old_party_idx = party_idx
          loop do
            @scene.pbPreSelect(old_party_idx)
            party_idx = @scene.pbChoosePokemon(true, party_idx)
            break if party_idx < 0
            newpkmn = @party[party_idx]
            movename = move.name
            if party_idx == old_party_idx
              pbDisplay(_INTL("{1} can't use {2} on itself!", pkmn.name, movename))
            elsif newpkmn.egg?
              pbDisplay(_INTL("{1} can't be used on an Egg!", movename))
            elsif newpkmn.fainted? || newpkmn.hp == newpkmn.totalhp
              pbDisplay(_INTL("{1} can't be used on that Pokémon.", movename))
            else
              pkmn.hp -= amt
              hpgain = pbItemRestoreHP(newpkmn, amt)
              @scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", newpkmn.name, hpgain))
              pbRefresh
            end
            break if pkmn.hp <= amt
          end
          @scene.pbSelect(old_party_idx)
          pbRefresh
        elsif pbCanUseHiddenMove?(pkmn, move.id)
          if pbConfirmUseHiddenMove(pkmn, move.id)
            @scene.pbEndScene
            if move.id == :FLY
              scene = PokemonRegionMap_Scene.new(-1, false)
              screen = PokemonRegionMapScreen.new(scene)
              ret = screen.pbStartFlyScreen
              if ret
                $game_temp.fly_destination = ret
                return [pkmn, move.id]
              end
              @scene.pbStartScene(
                @party, (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
              )
              next
            end
            return [pkmn, move.id]
          end
        end
      end
    end
    @scene.pbEndScene
    return nil
  end
end



class MoveRelearnerScreen
  def MoveRelearnerScreen.pbGetRelearnableMoves(pkmn)
    return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?
    moves = []
    pkmn.getMoveList.each do |m|
      next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
      moves.push(m[1]) if !moves.include?(m[1])
    end
    tmoves = []
    if pkmn.first_moves
      for i in pkmn.first_moves
        tmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i)
      end
    end
    species_data = pkmn.species_data
    species_data.tutor_moves.each { |m| moves.push(m) }
    moves = tmoves + moves
    return moves | []   # remove duplicates
  end

  def pbStartScreen(pkmn)
    puts pkmn
    moves = MoveRelearnerScreen.pbGetRelearnableMoves(pkmn)    #by Kota
    @scene.pbStartScene(pkmn, moves)
    loop do
      move = @scene.pbChooseMove
      if move
        if @scene.pbConfirm(_INTL("Teach {1}?", GameData::Move.get(move).name))
          if pbLearnMove(pkmn, move)
            $stats.moves_taught_by_reminder += 1
            @scene.pbEndScene
            return true
          end
        end
      elsif @scene.pbConfirm(_INTL("Give up trying to teach a new move to {1}?", pkmn.name))
        @scene.pbEndScene
        return false
      end
    end
  end
end
#===============================================================================
# Party screen menu commands.
# Note that field moves are inserted into the list of commands after the first
# command, which is usually "Summary". If playing in Debug mode, they are
# inserted after the second command instead, which is usually "Debug". See
# insert_index above if you need to change this.
#===============================================================================
MenuHandlers.add(:party_menu, :summary, {
  "name"      => _INTL("Summary"),
  "order"     => 10,
  "effect"    => proc { |screen, party, party_idx|
    screen.scene.pbSummary(party_idx) {
      screen.scene.pbSetHelpText((party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
    }
  }
})

MenuHandlers.add(:party_menu, :debug, {
  "name"      => _INTL("Debug"),
  "order"     => 20,
  "condition" => proc { |screen, party, party_idx| next $DEBUG },
  "effect"    => proc { |screen, party, party_idx|
    screen.pbPokemonDebug(party[party_idx], party_idx)
  }
})

MenuHandlers.add(:party_menu, :switch, {
  "name"      => _INTL("Switch"),
  "order"     => 30,
  "condition" => proc { |screen, party, party_idx| next party.length > 1 },
  "effect"    => proc { |screen, party, party_idx|
    screen.scene.pbSetHelpText(_INTL("Move to where?"))
    old_party_idx = party_idx
    party_idx = screen.scene.pbChoosePokemon(true)
    screen.pbSwitch(old_party_idx, party_idx) if party_idx >= 0 && party_idx != old_party_idx
  }
})

MenuHandlers.add(:party_menu, :mail, {
  "name"      => _INTL("Mail"),
  "order"     => 40,
  "condition" => proc { |screen, party, party_idx| next !party[party_idx].egg? && party[party_idx].mail },
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    command = screen.scene.pbShowCommands(_INTL("Do what with the mail?"),
                                          [_INTL("Read"), _INTL("Take"), _INTL("Cancel")])
    case command
    when 0   # Read
      pbFadeOutIn {
        pbDisplayMail(pkmn.mail, pkmn)
        screen.scene.pbSetHelpText((party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
      }
    when 1   # Take
      if pbTakeItemFromPokemon(pkmn, screen)
        screen.pbRefreshSingle(party_idx)
      end
    end
  }
})

MenuHandlers.add(:party_menu, :item, {
  "name"      => _INTL("Item"),
  "order"     => 50,
  "condition" => proc { |screen, party, party_idx| next !party[party_idx].egg? && !party[party_idx].mail },
  "effect"    => proc { |screen, party, party_idx|
    # Get all commands
    command_list = []
    commands = []
    MenuHandlers.each_available(:party_menu_item, screen, party, party_idx) do |option, hash, name|
      command_list.push(name)
      commands.push(hash)
    end
    command_list.push(_INTL("Cancel"))
    # Choose a menu option
    choice = screen.scene.pbShowCommands(_INTL("Do what with an item?"), command_list)
    next if choice < 0 || choice >= commands.length
    commands[choice]["effect"].call(screen, party, party_idx)
  }
})

MenuHandlers.add(:party_menu_item, :use, {
  "name"      => _INTL("Use"),
  "order"     => 10,
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    item = screen.scene.pbUseItem($bag, pkmn) {
      screen.scene.pbSetHelpText((party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
    }
    next if !item
    pbUseItemOnPokemon(item, pkmn, screen)
    screen.pbRefreshSingle(party_idx)
  }
})

MenuHandlers.add(:party_menu_item, :give, {
  "name"      => _INTL("Give"),
  "order"     => 20,
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    item = screen.scene.pbChooseItem($bag) {
      screen.scene.pbSetHelpText((party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
    }
    next if !item || !pbGiveItemToPokemon(item, pkmn, screen, party_idx)
    screen.pbRefreshSingle(party_idx)
  }
})

MenuHandlers.add(:party_menu_item, :take, {
  "name"      => _INTL("Take"),
  "order"     => 30,
  "condition" => proc { |screen, party, party_idx| next party[party_idx].hasItem? },
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    next if !pbTakeItemFromPokemon(pkmn, screen)
    screen.pbRefreshSingle(party_idx)
  }
})

MenuHandlers.add(:party_menu_item, :move, {
  "name"      => _INTL("Move"),
  "order"     => 41,
  "condition" => proc { |screen, party, party_idx| next party[party_idx].hasItem? && !party[party_idx].item.is_mail? },
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    item = pkmn.item
    itemname = item.name
    screen.scene.pbSetHelpText(_INTL("Move {1} to where?", itemname))
    old_party_idx = party_idx
    moved = false
    loop do
      screen.scene.pbPreSelect(old_party_idx)
      party_idx = screen.scene.pbChoosePokemon(true, party_idx)
      break if party_idx < 0
      newpkmn = party[party_idx]
      break if party_idx == old_party_idx
      if newpkmn.egg?
        screen.pbDisplay(_INTL("Eggs can't hold items."))
        next
      elsif !newpkmn.hasItem?
        newpkmn.item = item
        pkmn.item = nil
        screen.scene.pbClearSwitching
        screen.pbRefresh
        screen.pbDisplay(_INTL("{1} was given the {2} to hold.", newpkmn.name, itemname))
        moved = true
        break
      elsif newpkmn.item.is_mail?
        screen.pbDisplay(_INTL("{1}'s mail must be removed before giving it an item.", newpkmn.name))
        next
      end
      # New Pokémon is also holding an item; ask what to do with it
      newitem = newpkmn.item
      newitemname = newitem.name
      if newitem == :LEFTOVERS
        screen.pbDisplay(_INTL("{1} is already holding some {2}.\1", newpkmn.name, newitemname))
      elsif newitemname.starts_with_vowel?
        screen.pbDisplay(_INTL("{1} is already holding an {2}.\1", newpkmn.name, newitemname))
      else
        screen.pbDisplay(_INTL("{1} is already holding a {2}.\1", newpkmn.name, newitemname))
      end
      next if !screen.pbConfirm(_INTL("Would you like to switch the two items?"))
      newpkmn.item = item
      pkmn.item = newitem
      screen.scene.pbClearSwitching
      screen.pbRefresh
      screen.pbDisplay(_INTL("{1} was given the {2} to hold.", newpkmn.name, itemname))
      screen.pbDisplay(_INTL("{1} was given the {2} to hold.", pkmn.name, newitemname))
      moved = true
      break
    end
    screen.scene.pbSelect(old_party_idx) if !moved
  }
})

MenuHandlers.add(:party_menu, :tend, {
  "name"      => _INTL("Tend"),
  "order"     => 39,
  "effect"    => proc { |screen, party, party_idx|    # Get all commands
    command_list = []
    commands = []
    MenuHandlers.each_available(:party_menu_tend, screen, party, party_idx) do |option, hash, name|
      command_list.push(name)
      commands.push(hash)
    end
    command_list.push(_INTL("Cancel"))
    # Choose a menu option
    choice = screen.scene.pbShowCommands(_INTL("Do what with {1}?",party[party_idx].name), command_list)
    next if choice < 0 || choice >= commands.length
    commands[choice]["effect"].call(screen, party, party_idx)
  }
})




MenuHandlers.add(:party_menu_tend, :milk, {
  "name"      => _INTL("Milk"),
  "order"     => 9,
  "condition" => proc { |screen, party, party_idx| next party[party_idx].species == :MILTANK && !party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    time_delta = pbGetTimeNow.to_i - pkmn.time_last_milk
	if time_delta < 3600*4
      pbMessage(_INTL("{1} has been milked recently.",pkmn.name))
	next 0 
	end
	 if pkmn.species != :MILTANK
      pbMessage(_INTL("You cannot milk a {1}.",pkmn.species))
    elsif !$bag.has?(:WATERBOTTLE) && !$bag.has?(:GLASSBOTTLE)
      pbMessage(_INTL("You do not have something to put Milk in."))
	 else 
	  item2 = nil
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, $bag)
	  item2 = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).id == :GLASSBOTTLE || GameData::Item.get(item).id == :WATERBOTTLE })
    }
	 return if item2.nil?
	 return if item2==false
	 message = (_INTL("I AM ERROR")) 
     message=(_INTL("Store Milk in your Bottle?")) if item2.id == :GLASSBOTTLE
     message=(_INTL("Store Milk in your Canteen?")) if item2.id == :WATERBOTTLE
	   if pbConfirmMessage(message)
	    item = ItemData.new(:MOOMOOMILK)
        item2.decrease_durability(1)
		 item.set_bottle(item2)
       $bag.add(item,1)
       $bag.remove(item2,1)
      pbMessage(_INTL("You got some milk.",pkmn.species))
	  pkmn.time_last_milk = pbGetTimeNow.to_i
      end
	end
  }
})


MenuHandlers.add(:party_menu_tend, :pet, {
  "name"      => _INTL("Pet"),
  "order"     => 10,
  "condition" => proc { |screen, party, party_idx| next !party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
      pkmn = party[party_idx]
    time_delta = pbGetTimeNow.to_i - pkmn.time_last_pet
	if time_delta < 3600
      pbMessage(_INTL("{1} has been pet recently. You shouldn't spoil them.",pkmn.name))
	next 0 
	end
      pkmn.changeHappiness("groom",pkmn)
      pbMessage(_INTL("You pet {1}!",pkmn.name))
      pkmn.cute += 5
	  pkmn.time_last_pet = pbGetTimeNow.to_i
  }
})

MenuHandlers.add(:party_menu_tend, :groom, {
  "name"      => _INTL("Groom"),
  "order"     => 15,
  "condition" => proc { |screen, party, party_idx| next !party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
      pkmn = party[party_idx]
    time_delta = pbGetTimeNow.to_i - pkmn.time_last_brush
	if time_delta < 3600
      pbMessage(_INTL("{1} has been brushed recently. You shouldn't spoil them.",pkmn.name))
	next 0 
	end
      pkmn.changeLoyalty("groom",pkmn)
      pbMessage(_INTL("You brush {1}!",pkmn.name))
      pkmn.beauty += 5
	  pkmn.time_last_brush = pbGetTimeNow.to_i
  }
})



MenuHandlers.add(:party_menu_tend, :nickname, {
  "name"      => _INTL("Nickname"),
  "order"     => 16,
  "condition" => proc { |screen, party, party_idx| next !party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
      pkmn = party[party_idx]
      species = pkmn.speciesName
      pbSet(4, species)
      pbTextEntry("#{species}'s nickname?",0, Pokemon::MAX_NAME_SIZE, 5)
	  if pbGet(5) == pbGet(3) || (pbGet(5) == "" && pbGet(3) == pbGet(4))
	    pbMessage(_INTL("You do not change its name",pkmn.name))
	  elsif pbGet(5) == "" || pbGet(5) == pbGet(4)
	    pkmn = party[party_idx]
       pkmn.name = nil
       pbSet(3, pkmn.name)
       pbMessage(_INTL("It's name is now: {1}.",pkmn.name))
	  else 
      pkmn = party[party_idx]
      pkmn.name = pbGet(5)
      pbMessage(_INTL("It's name is now: {1}.",pkmn.name))
	  end
  }
})
MenuHandlers.add(:party_menu_tend, :feed, {
  "name"      => _INTL("Feed"),
  "order"     => 20,
  "condition" => proc { |screen, party, party_idx| next !party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    pbEatingPkmn(pkmn)
  }
})

MenuHandlers.add(:party_menu_tend, :nap, {
  "name"      => _INTL("Let Nap"),
  "order"     => 30,
  "condition" => proc { |screen, party, party_idx| next party[party_idx].status == :NONE && !party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
      pkmn = party[party_idx]
      newHP = pkmn.hp + rand(51)
      newHP = pkmn.totalhp if newHP > pkmn.totalhp
      hpGain = newHP - pkmn.hp
      pkmn.hp = newHP
	  pkmn.changeHappiness("machine",pkmn)
	  pkmn.changeLoyalty("machine",pkmn)
	  pkmn.status = :SLEEP
      pbMessage(_INTL("{1} went to sleep for a while.",pkmn.name))
  }
})

MenuHandlers.add(:party_menu_tend, :wake, {
  "name"      => _INTL("Wake Up"),
  "order"     => 35,
  "condition" => proc { |screen, party, party_idx| next party[party_idx].status == :SLEEP && !party[party_idx].dead? },
  "effect"    => proc { |screen, party, party_idx|
      pkmn = party[party_idx]
      chance = rand(100)
	  if chance <= 10
	  pkmn.status = :NONE
	  pkmn.changeHappiness("powder",pkmn)
	  pkmn.changeLoyalty("powder",pkmn)
      pbMessage(_INTL("{1} woke up!!",pkmn.name))
	  else 
      pbMessage(_INTL("{1} remained asleep.",pkmn.name))
	  end
  }
})

MenuHandlers.add(:party_menu_tend, :evolve, {
  "name"      => _INTL("Evolve"),
  "order"     => 39,
  "condition" => proc { |screen, party, party_idx| next !screen.scene.all_evoreqs[party_idx].empty? },
  "effect"    => proc { |screen, party, party_idx|
    evoreqs = screen.scene.all_evoreqs[party_idx]
    case evoreqs.length
    when 0
      pbDisplay(_INTL("This Pokémon can't evolve."))
      next
    when 1
      evoreq = evoreqs[0]
    else
      evoreq = evoreqs[screen.scene.pbShowCommands(
        _INTL("Which species would you like to evolve into?"),
        evoreqs.map { |req| GameData::Species.get(req[0]).real_name }
      )]
    end
    if evoreq[1] # requires an item
      itemname = GameData::Item.get(evoreq[1]).name
      next unless @scene.pbConfirmMessage(_INTL("This will consume a {1}. Do you want to continue?", itemname))
      $bag.remove(evoreq[1])
    end
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(party[party_idx], evoreq[0])
      evo.pbEvolution
      evo.pbEndScreen
      screen.pbRefresh
    }
  }
})




MenuHandlers.add(:party_menu_tend, :slaughter, {
  "name"      => _INTL("Slaughter"),
  "order"     => 35,
  "condition" => proc { |screen, party, party_idx| next !(party[party_idx].egg? || party[party_idx].shadowPokemon?) && party[party_idx].dead?},
  "effect"    => proc { |screen, party, party_idx|
      pkmn = party[party_idx]
    if pbConfirmMessage(_INTL("Are you sure you want to prepare your #{pkmn.name} for food?"))
	 pbCookMeat(pkmn)
	end
  }
})




#===============================================================================
# Open the party screen
#===============================================================================
def pbPokemonScreen
  pbFadeOutIn {
    sscene = PokemonParty_Scene.new
    sscreen = PokemonPartyScreen.new(sscene, $player.party)
    sscreen.pbPokemonScreen
  }
end

#===============================================================================
# Choose a Pokémon in the party
#===============================================================================
# Choose a Pokémon/egg from the party.
# Stores result in variable _variableNumber_ and the chosen Pokémon's name in
# variable _nameVarNumber_; result is -1 if no Pokémon was chosen
def pbChoosePokemon(variableNumber, nameVarNumber, ableProc = nil, allowIneligible = false)
  chosen = 0
  pbFadeOutIn {
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene, $player.party)
    if ableProc
      chosen = screen.pbChooseAblePokemon(ableProc, allowIneligible)
    else
      screen.pbStartScene(_INTL("Choose a Pokémon."), false)
      chosen = screen.pbChoosePokemon
      screen.pbEndScene
    end
  }
  pbSet(variableNumber, chosen)
  if chosen >= 0
    pbSet(nameVarNumber, $player.party[chosen].name)
  else
    pbSet(nameVarNumber, "")
  end
end

def pbChooseNonEggPokemon(variableNumber, nameVarNumber)
  pbChoosePokemon(variableNumber, nameVarNumber, proc { |pkmn| !pkmn.egg? })
end

def pbChooseAblePokemon(variableNumber, nameVarNumber)
  pbChoosePokemon(variableNumber, nameVarNumber, proc { |pkmn| !pkmn.egg? && pkmn.hp > 0 })
end

# Same as pbChoosePokemon, but prevents choosing an egg or a Shadow Pokémon.
def pbChooseTradablePokemon(variableNumber, nameVarNumber, ableProc = nil, allowIneligible = false)
  chosen = 0
  pbFadeOutIn {
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene, $player.party)
    if ableProc
      chosen = screen.pbChooseTradablePokemon(ableProc, allowIneligible)
    else
      screen.pbStartScene(_INTL("Choose a Pokémon."), false)
      chosen = screen.pbChoosePokemon
      screen.pbEndScene
    end
  }
  pbSet(variableNumber, chosen)
  if chosen >= 0
    pbSet(nameVarNumber, $player.party[chosen].name)
  else
    pbSet(nameVarNumber, "")
  end
end

def pbChoosePokemonForTrade(variableNumber, nameVarNumber, wanted)
  wanted = GameData::Species.get(wanted).species
  pbChooseTradablePokemon(variableNumber, nameVarNumber, proc { |pkmn|
    next pkmn.species == wanted
  })
end

