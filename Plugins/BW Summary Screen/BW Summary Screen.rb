  #===============================================================================
  #
  #===============================================================================
  class MoveSelectionSprite < Sprite
    attr_reader :preselected
    attr_reader :index
    def initialize(viewport = nil, fifthmove = false)
      super(viewport)
      # Sets the Move Selection Cursor
      if SUMMARY_B2W2_STYLE
        @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_move_B2W2")
      else
        @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_move")
      end
      @frame = 0
      @index = 0
      @fifthmove = fifthmove
      @preselected = false
      @updating = false
      refresh
    end

    def dispose
        @movesel.dispose
        super
      end
      def index=(value)
        @index = value
        refresh
      end
      def preselected=(value)
        @preselected = value
        refresh
      end

    def refresh
      w = @movesel.width
      h = @movesel.height / 2
      self.x = 240
      # Changed the position of the Move Select cursor
      self.y = 91 + (self.index * 64)
      self.y -= 76 if @fifthmove
      self.y += 20 if @fifthmove && self.index == Pokemon::MAX_MOVES   # Add a gap
      self.bitmap = @movesel.bitmap
      if self.preselected
        self.src_rect.set(0, h, w, h)
      else
        self.src_rect.set(0 ,0, w, h)
      end
    end

    def update
      @updating = true
      super
      @movesel.update
      @updating = false
      refresh
    end
  end

  #===============================================================================
  #
  #===============================================================================
  class RibbonSelectionSprite < MoveSelectionSprite
    def initialize(viewport = nil)
      super(viewport)
      # Sets the Ribbon Selection Cursor
      if SUMMARY_B2W2_STYLE
        @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_ribbon_B2W2")
      else
        @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_ribbon")
      end

      @frame = 0
      @index = 0
      @preselected = false
      @updating = false
      @spriteVisible = true
      refresh
    end

    def visible=(value)
        super
        @spriteVisible = value if !@updating
      end

    def refresh
      w = @movesel.width
      h = @movesel.height / 2
   # Changed the position of the Ribbon Select cursor
      self.x = 0 + (self.index % 4) * 68
      self.y = 72 + ((self.index / 4).floor * 68)
      self.bitmap = @movesel.bitmap
      if self.preselected
        self.src_rect.set(0, h, w, h)
      else
        self.src_rect.set(0, 0, w, h)
      end
    end

    def update
      @updating = true
      super
      self.visible = @spriteVisible && @index >= 0 && @index < 12
      @movesel.update
      @updating = false
      refresh
    end
  end

  #===============================================================================
  #
  #===============================================================================
  class PokemonSummary_Scene
    SHOW_FAMILY_EGG = true 
    MARK_WIDTH  = 16
    MARK_HEIGHT = 16

    def pbUpdate
      pbUpdateSpriteHash(@sprites)
      # Sets the Moving Background
      if @sprites["background"]
        @sprites["background"].ox-= -1
        @sprites["background"].oy-= -1
      end
    if SHOW_FAMILY_EGG && @pokemon.egg?
      if Input.trigger?(Input::LEFT) && @page==7
        @page=1
        pbPlayCursorSE()
        dorefresh=true
      end
      if Input.trigger?(Input::RIGHT) && @page==1
        @page=7
        pbPlayCursorSE()
        dorefresh=true
      end
    end
    if dorefresh
      case @page
        when 1; drawPageOneEgg
        when 7; drawPageSeven
      end
    end
    end
    def pbStartScene(party, partyindex, inbattle = false)
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99999
      @party      = party
      @partyindex = partyindex
      @pokemon    = @party[@partyindex]
      @inbattle   = inbattle
      @page = 1
      @typebitmap    = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      @markingbitmap = AnimatedBitmap.new("Graphics/Pictures/Summary/markings")
      @sprites = {}
      # Sets the Summary Background
      # Background glitch fixed by Shashu-Greninja
      @sprites["bg_overlay"] = IconSprite.new(0, 0, @viewport)
      if SUMMARY_B2W2_STYLE
        addBackgroundPlane(@sprites, "background", "Summary/background_B2W2", @viewport)
      else
        addBackgroundPlane(@sprites, "background", "Summary/background", @viewport)
      end
      # Sets the Moving Background Loop
      @sprites["background"].ox+= 6
      @sprites["background"].oy-= 36
      # Sets the Summary Overlays
      @sprites["menuoverlay"] = IconSprite.new(0, 0, @viewport)
      @sprites["pokemon"] = PokemonSprite.new(@viewport)
      @sprites["pokemon"].setOffset(PictureOrigin::CENTER)
      # Changed the position of Pokémon Battler
      @sprites["pokemon"].x = 414
      @sprites["pokemon"].y = 208
      @sprites["pokemon"].setPokemonBitmap(@pokemon)
      @sprites["pokemon"].tone = Tone.new(0,0,0,255) if @pokemon.dead?
      @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon, @viewport)
      @sprites["pokeicon"].setOffset(PictureOrigin::CENTER)
      # Changed the position of Pokémon Icon
      @sprites["pokeicon"].x       = 46
      @sprites["pokeicon"].y       = 92
      @sprites["pokeicon"].visible = false
      # Changed the position of the held Item icon
      @sprites["itemicon"] = ItemIconSprite.new(485, 358, @pokemon.item_id, @viewport)
      @sprites["itemicon"].blankzero = true
      @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["overlay"].bitmap)
      @sprites["movepresel"] = MoveSelectionSprite.new(@viewport)
      @sprites["movepresel"].visible     = false
      @sprites["movepresel"].preselected = true
      @sprites["movesel"] = MoveSelectionSprite.new(@viewport)
      @sprites["movesel"].visible = false
      # Draws the Ribbon Selection Cursor
      @sprites["ribbonpresel"] = RibbonSelectionSprite.new(@viewport)
      @sprites["ribbonpresel"].visible     = false
      @sprites["ribbonpresel"].preselected = true
      @sprites["ribbonsel"] = RibbonSelectionSprite.new(@viewport)
      @sprites["ribbonsel"].visible = false
      # Sets the Up Arrow in Ribbons Page
      @sprites["uparrow"] = AnimatedSprite.new("Graphics/Pictures/uparrow",8, 28, 40, 2, @viewport)
      # Draws the Up Arrow in Ribbons Page
      @sprites["uparrow"].x = 262
      @sprites["uparrow"].y = 56
      @sprites["uparrow"].play
      @sprites["uparrow"].visible = false
      # Sets the Down Arrow in Ribbons Page
      @sprites["downarrow"] = AnimatedSprite.new("Graphics/Pictures/downarrow",8, 28, 40, 2, @viewport)
      # Draws the Up Arrow in Ribbons Page
      @sprites["downarrow"].x = 262
      @sprites["downarrow"].y = 260
      @sprites["downarrow"].play
      @sprites["downarrow"].visible = false
      # Sets the Marking Overlay
      @sprites["markingbg"] = IconSprite.new(260, 88, @viewport)
      @sprites["markingbg"].setBitmap("Graphics/Pictures/Summary/overlay_marking")
      @sprites["markingbg"].visible = false
      @sprites["markingoverlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      @sprites["markingoverlay"].visible = false
      pbSetSystemFont(@sprites["markingoverlay"].bitmap)
      # Sets the Marking Selector
      @sprites["markingsel"] = IconSprite.new(0, 0, @viewport)
      if SUMMARY_B2W2_STYLE
        @sprites["markingsel"].setBitmap("Graphics/Pictures/Summary/cursor_marking_B2W2")
      else
        @sprites["markingsel"].setBitmap("Graphics/Pictures/Summary/cursor_marking")
      end
      @sprites["markingsel"].src_rect.height = @sprites["markingsel"].bitmap.height / 2
      @sprites["markingsel"].visible = false
      @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
      @sprites["messagebox"].viewport       = @viewport
      @sprites["messagebox"].visible        = false
      @sprites["messagebox"].letterbyletter = true
      pbBottomLeftLines(@sprites["messagebox"], 2)
      @nationalDexList = [:NONE]
      GameData::Species.each_species { |s| @nationalDexList.push(s.species) }
      drawPage(@page)
      pbFadeInAndShow(@sprites) { pbUpdate }
    end

    def pbStartForgetScene(party, partyindex, move_to_learn)
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99999
      @party      = party
      @partyindex = partyindex
      @pokemon    = @party[@partyindex]
      @page = 4
      @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      @sprites = {}
      # Sets the Summary Background
      # Background glitch fixed by Shashu-Greninja
      @sprites["bg_overlay"] = IconSprite.new(0, 0, @viewport)
      if SUMMARY_B2W2_STYLE
        addBackgroundPlane(@sprites, "background","Summary/background_B2W2", @viewport)
      else
        addBackgroundPlane(@sprites, "background","Summary/background", @viewport)
      end
      # Sets the Moving Background Loop
      @sprites["background"].ox+= 6
      @sprites["background"].oy-= 36
      # Sets the Summary Overlays
      @sprites["menuoverlay"] = IconSprite.new(0, 0, @viewport)
      @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["overlay"].bitmap)
      @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon, @viewport)
      @sprites["pokeicon"].setOffset(PictureOrigin:: CENTER)
      # Sets the Pokémon Icon on the scene
      @sprites["pokeicon"].x       = 46
      @sprites["pokeicon"].y       = 92
      @sprites["movesel"] = MoveSelectionSprite.new(@viewport, !move_to_learn.nil?)
      @sprites["movesel"].visible = false
      @sprites["movesel"].visible = true
      @sprites["movesel"].index   = 0
      new_move = (move_to_learn) ? Pokemon::Move.new(move_to_learn) : nil
      drawSelectedMove(new_move, @pokemon.moves[0])
      pbFadeInAndShow(@sprites)
    end

    def pbEndScene
        pbFadeOutAndHide(@sprites) { pbUpdate }
        pbDisposeSpriteHash(@sprites)
        @typebitmap.dispose
        @markingbitmap&.dispose
        @viewport.dispose
      end
      def pbDisplay(text)
        @sprites["messagebox"].text = text
        @sprites["messagebox"].visible = true
        pbPlayDecisionSE
        loop do
          Graphics.update
          Input.update
          pbUpdate
          if @sprites["messagebox"].busy?
            if Input.trigger?(Input::USE)
              pbPlayDecisionSE if @sprites["messagebox"].pausing?
              @sprites["messagebox"].resume
            end
          elsif Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
            break
          end
        end
        @sprites["messagebox"].visible = false
      end
      def pbConfirm(text)
        ret = -1
        @sprites["messagebox"].text    = text
        @sprites["messagebox"].visible = true
        using(cmdwindow = Window_CommandPokemon.new([_INTL("Yes"), _INTL("No")])) {
          cmdwindow.z       = @viewport.z + 1
          cmdwindow.visible = false
          pbBottomRight(cmdwindow)
          cmdwindow.y -= @sprites["messagebox"].height
          loop do
            Graphics.update
            Input.update
            cmdwindow.visible = true if !@sprites["messagebox"].busy?
            cmdwindow.update
            pbUpdate
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
        return ret
      end
      def pbShowCommands(commands, index = 0)
        ret = -1
        using(cmdwindow = Window_CommandPokemon.new(commands)) {
          cmdwindow.z = @viewport.z + 1
          cmdwindow.index = index
          pbBottomRight(cmdwindow)
          loop do
            Graphics.update
            Input.update
            cmdwindow.update
            pbUpdate
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
      def drawMarkings(bitmap, x, y)
        mark_variants = @markingbitmap.bitmap.height / MARK_HEIGHT
        markings = @pokemon.markings
        markrect = Rect.new(0, 0, MARK_WIDTH, MARK_HEIGHT)
        (@markingbitmap.bitmap.width / MARK_WIDTH).times do |i|
          markrect.x = i * MARK_WIDTH
          markrect.y = [(markings[i] || 0), mark_variants - 1].min * MARK_HEIGHT
          bitmap.blt(x + (i * MARK_WIDTH), y, @markingbitmap.bitmap, markrect)
        end
      end
def get_parent_icon(parent)
    return parent ? parent.icon_filename : GameData::Species.icon_filename(nil)
end


  #===============================================================================
  # IV Ratings - Shows IV ratings on Page 3 (Stats)
  #   Adaptaded from Lucidious89's IV star script by Tommaniacal
  #
  # Converted to BW Summary Pack by DeepBlue PacificWaves
  #	Updated to v19 by Shashu-Greninja
  #===============================================================================
    def pbDisplayIVRating
      ratingf  = sprintf("Graphics/Pictures/Summary/RatingF")
      ratingd  = sprintf("Graphics/Pictures/Summary/RatingD")
      ratingc  = sprintf("Graphics/Pictures/Summary/RatingC")
      ratingb  = sprintf("Graphics/Pictures/Summary/RatingB")
      ratinga  = sprintf("Graphics/Pictures/Summary/RatingA")
      ratings  = sprintf("Graphics/Pictures/Summary/RatingS")
      overlay  = @sprites["overlay"].bitmap
      imagepos = []
      # HP
      if @pokemon.iv[:HP] > 30 || @pokemon.ivMaxed[:HP]
        imagepos.push([ratings, 110, 82, 0, 0, -1, -1])
      elsif @pokemon.iv[:HP] > 22 && @pokemon.iv[:HP] < 31
        imagepos.push([ratinga, 110, 82, 0, 0, -1, -1])
      elsif @pokemon.iv[:HP] > 15 && @pokemon.iv[:HP] < 23
        imagepos.push([ratingb, 110, 82, 0, 0, -1, -1])
      elsif @pokemon.iv[:HP] > 7 && @pokemon.iv[:HP] < 16
        imagepos.push([ratingc, 110, 82, 0, 0, -1, -1])
      elsif @pokemon.iv[:HP] > 0 && @pokemon.iv[:HP] < 8
        imagepos.push([ratingd, 110, 82, 0, 0, -1, -1])
      else
        imagepos.push([ratingf, 110, 82, 0, 0, -1, -1])
      end
      # ATK
      if @pokemon.iv[:ATTACK] > 30 || @pokemon.ivMaxed[:ATTACK]
        imagepos.push([ratings, 110, 132, 0, 0, -1, -1])
      elsif @pokemon.iv[:ATTACK] > 22 && @pokemon.iv[:ATTACK] < 31
        imagepos.push([ratinga, 110, 132, 0, 0, -1, -1])
      elsif @pokemon.iv[:ATTACK] > 15 && @pokemon.iv[:ATTACK] < 23
        imagepos.push([ratingb, 110, 132, 0, 0, -1, -1])
      elsif @pokemon.iv[:ATTACK] > 7 && @pokemon.iv[:ATTACK] < 16
        imagepos.push([ratingc,110, 132, 0, 0, -1, -1])
      elsif @pokemon.iv[:ATTACK] > 0 && @pokemon.iv[:ATTACK] < 8
        imagepos.push([ratingd, 110, 132, 0, 0, -1, -1])
      else
        imagepos.push([ratingf, 110, 132, 0, 0, -1, -1])
      end
      # DEF
      if @pokemon.iv[:DEFENSE] > 30 || @pokemon.ivMaxed[:DEFENSE]
        imagepos.push([ratings, 110, 164, 0, 0, -1, -1])
      elsif @pokemon.iv[:DEFENSE] > 22 && @pokemon.iv[:DEFENSE] < 31
        imagepos.push([ratinga, 110, 164, 0, 0, -1, -1])
      elsif @pokemon.iv[:DEFENSE] > 15 && @pokemon.iv[:DEFENSE] < 23
        imagepos.push([ratingb, 110, 164, 0, 0, -1, -1])
      elsif @pokemon.iv[:DEFENSE] > 7 && @pokemon.iv[:DEFENSE] < 16
        imagepos.push([ratingc, 110, 164, 0, 0, -1, -1])
      elsif @pokemon.iv[:DEFENSE] > 0 && @pokemon.iv[:DEFENSE] < 8
        imagepos.push([ratingd, 110, 164, 0, 0, -1, -1])
      else
        imagepos.push([ratingf, 110, 164, 0, 0, -1, -1])
      end
      # SPATK
      if @pokemon.iv[:SPECIAL_ATTACK] > 30 || @pokemon.ivMaxed[:SPECIAL_ATTACK]
        imagepos.push([ratings,110, 196, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_ATTACK] > 22 && @pokemon.iv[:SPECIAL_ATTACK] < 31
        imagepos.push([ratinga, 110, 196, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_ATTACK] > 15 && @pokemon.iv[:SPECIAL_ATTACK] < 23
        imagepos.push([ratingb, 110, 196, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_ATTACK] > 7 && @pokemon.iv[:SPECIAL_ATTACK] < 16
        imagepos.push([ratingc, 110, 196, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_ATTACK] > 0 && @pokemon.iv[:SPECIAL_ATTACK] < 8
        imagepos.push([ratingd, 110, 196, 0, 0, -1, -1])
      else
        imagepos.push([ratingf, 110, 196, 0, 0, -1, -1])
      end
      # SPDEF
      if @pokemon.iv[:SPECIAL_DEFENSE] > 30 || @pokemon.ivMaxed[:SPECIAL_DEFENSE]
        imagepos.push([ratings, 110, 228, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_DEFENSE] > 22 && @pokemon.iv[:SPECIAL_DEFENSE] < 31
        imagepos.push([ratinga, 110, 228, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_DEFENSE] > 15 && @pokemon.iv[:SPECIAL_DEFENSE] < 23
        imagepos.push([ratingb, 110, 228, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_DEFENSE] > 7 && @pokemon.iv[:SPECIAL_DEFENSE] < 16
        imagepos.push([ratingc, 110, 228, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPECIAL_DEFENSE] > 0 && @pokemon.iv[:SPECIAL_DEFENSE] < 8
        imagepos.push([ratingd, 110, 228, 0, 0, -1, -1])
      else
        imagepos.push([ratingf, 110, 228, 0, 0, -1, -1])
      end
      # SPEED
      if @pokemon.iv[:SPEED] > 30 || @pokemon.ivMaxed[:SPEED]
        imagepos.push([ratings, 110, 260, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPEED] > 22 && @pokemon.iv[:SPEED] < 31
        imagepos.push([ratinga, 110, 260, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPEED] > 15 && @pokemon.iv[:SPEED] < 23
        imagepos.push([ratingb, 110, 260, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPEED] > 7 && @pokemon.iv[:SPEED] < 16
        imagepos.push([ratingc, 110, 260, 0, 0, -1, -1])
      elsif @pokemon.iv[:SPEED] > 0 && @pokemon.iv[:SPEED] < 8
        imagepos.push([ratingd, 110, 260, 0, 0, -1, -1])
      else
       imagepos.push([ratingf, 110, 260, 0, 0, -1, -1])
      end
      pbDrawImagePositions(overlay,imagepos)
    end

  #=============================================================================

    def drawPage(page)
      if @pokemon.egg?
        drawPageOneEgg
        return
      end
      @sprites["itemicon"].item = @pokemon.item_id
      overlay = @sprites["overlay"].bitmap
      overlay.clear
      # Changes the color of the text, to the one used in BW
      base   = Color.new(90, 82, 82)
      shadow = Color.new(165, 165, 173)
      # Set background image
        @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_#{page}")
      imagepos = []
      # Show the Poké Ball containing the Pokémon
      ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%s", @pokemon.poke_ball)
      imagepos.push([ballimage, 320, 44])
      # Show status/fainted/Pokérus infected icon
      status = -1
      if @pokemon.status != :NONE
        status = GameData::Status.get(@pokemon.status).icon_position
      elsif @pokemon.pokerusStage == 1
        status = GameData::Status.count
      end
      status -= 1
      if @pokemon.fainted?
        status = GameData::Status.count - 1
	  end
      if @pokemon.permaFaint
        status = GameData::Status.count + 1
	  end
      if status >= 0
        imagepos.push(["Graphics/Pictures/statuses", 410, 88, 0, 16 * status, 44, 16])
      end
      # Show Pokérus cured icon
      if @pokemon.pokerusStage == 2
        if SUMMARY_B2W2_STYLE
          imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"), 376, 303])
        else
          imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"), 376, 305])
        end
      end
      # Show shininess star
      if @pokemon.shiny?
        if SUMMARY_B2W2_STYLE
          imagepos.push([sprintf("Graphics/Pictures/shiny"), 350, 303])
        else
          imagepos.push([sprintf("Graphics/Pictures/shiny"), 350, 306])
        end
      end
      # Draw all images
      pbDrawImagePositions(overlay,imagepos)
      # Write various bits of text
      pagename = [_INTL("POKéMON INFO"),
                  _INTL("TRAINER MEMO"),
                  _INTL("SKILLS"),
                  _INTL("MOVES"),
                  _INTL("HAPPINESS"),
                  _INTL("RIBBON"),
                  _INTL("FAMILY TREE")][page - 1]

      #============================================================================
      # Changed various positions of the text
      #============================================================================

      if SUMMARY_B2W2_STYLE
        textpos = [
          [@pokemon.name, 354, 52, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          ["#{@pokemon.level.to_s}/#{@pokemon.level_cap.to_s}", 346, 86, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          [_INTL("Item"), 298, 326, 0, base, shadow]
        ]
      else
        textpos = [
          [pagename, 26, 6, 0, Color.new(255, 255, 255), Color.new(132, 132, 132)],
          [@pokemon.name, 354, 39, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          ["#{@pokemon.level.to_s}/#{@pokemon.level_cap.to_s}", 344, 76, 0, Color.new(90,82,82),Color.new(165,165,173)],
          [_INTL("Item"), 298, 320, 0, base, shadow]
        ]
      end
      # Write the held item's name
      if @pokemon.hasItem?
        textpos.push([@pokemon.item.name, 290, 343, 0, base, shadow])
      else
        textpos.push([_INTL("None"), 290, 343, 0, base, shadow])
      end
      # Write the gender symbol
      if @pokemon.male?
        textpos.push([_INTL("♂"), 486, 39, 0, Color.new(0, 0, 214), Color.new(15, 148, 255)])
      elsif @pokemon.female?
        textpos.push([_INTL("♀"), 486, 39, 0, Color.new(198, 0, 0), Color.new(255, 155, 155)])
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw the Pokémon's markings
      if SUMMARY_B2W2_STYLE
        drawMarkings(overlay, 370, 302)
      else
        drawMarkings(overlay, 416, 306)
      end

      # Draw page-specific information
      case page
      when 1 then drawPageOne
      when 2 then drawPageTwo
      when 3 then drawPageThree
      when 4 then drawPageFour
      when 5 then drawPageFive
      when 6 then drawPageSix
      when 7 then drawPageSeven
      end
    end

    def drawPageOne
      overlay = @sprites["overlay"].bitmap
      # Changes the color of the text, to the one used in BW
      base   = Color.new(255, 255, 255)
      shadow = Color.new(165, 165, 173)
      dexNumBase   = (@pokemon.shiny?) ? Color.new(198, 0, 0) : Color.new(90, 82, 82)
      dexNumShadow = (@pokemon.shiny?) ? Color.new(255, 155, 155) : Color.new(165, 165, 173)
      # If a Shadow Pokémon, draw the heart gauge area and bar
      if @pokemon.shadowPokemon?
        shadowfract = @pokemon.heart_gauge.to_f / @pokemon.max_gauge_size
        if SUMMARY_B2W2_STYLE
          imagepos = [
            ["Graphics/Pictures/Summary/overlay_shadow_B2W2",0, 228],
            ["Graphics/Pictures/Summary/overlay_shadowbar", 90, 266, 0, 0,(shadowfract * 248).floor, -1]
          ]
        else
          imagepos = [
            ["Graphics/Pictures/Summary/overlay_shadow", 0, 228],
            ["Graphics/Pictures/Summary/overlay_shadowbar", 90, 268, 0, 0,(shadowfract * 248).floor, -1]
          ]
        end

        pbDrawImagePositions(overlay, imagepos)

      end
      # Write various bits of text. Changed various positions of the text
      if SUMMARY_B2W2_STYLE
        textpos = [
          [_INTL("Dex No."), 34, 72, 0, base, shadow],
          [_INTL("Species"), 34, 104, 0, base, shadow],
          [@pokemon.speciesName, 162, 106, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          [_INTL("Type"), 34, 136, 0, base, shadow],
          [_INTL("OT"), 34, 168, 0, base, shadow],
          [_INTL("ID No."), 34, 200, 0, base, shadow],
        ]
      else
        textpos = [
          [_INTL("Dex No."), 34, 64, 0, base, shadow],
          [_INTL("Species"), 34, 96, 0, base, shadow],
          [@pokemon.speciesName, 164, 96, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          [_INTL("Type"), 34, 129, 0, base, shadow],
          [_INTL("OT"), 34, 160, 0, base, shadow],
          [_INTL("ID No."), 34, 192, 0, base, shadow],
        ]
      end

      # Write the Regional/National Dex number
      dexnumshift = false
      if $player.pokedex.unlocked?(-1)   # National Dex is unlocked
        dexnum = @nationalDexList.index(@pokemon.species_data.species) || 0
        dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(-1)
      else
        dexnum = 0
        ($player.pokedex.dexes_count - 1).times do |i|
          next if !$player.pokedex.unlocked?(i)
          num = pbGetRegionalNumber(i, @pokemon.species)
          next if num <= 0
          dexnum = num
          dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(i)
          break
        end
      end
      if dexnum <= 0
        if SUMMARY_B2W2_STYLE
          # Write ??? if Pokémon is not found in the Dex
          textpos.push(["???", 164, 72, 0, dexNumBase, dexNumShadow])
        else
          textpos.push(["???", 164, 64, 0, dexNumBase, dexNumShadow])
        end
      else
        dexnum -= 1 if dexnumshift
        # Write the Dex Number
        if SUMMARY_B2W2_STYLE
          textpos.push([sprintf("%03d", dexnum), 164, 72, 0, dexNumBase, dexNumShadow])
        else
          textpos.push([sprintf("%03d", dexnum), 164, 64, 0, dexNumBase, dexNumShadow])
        end
      end
      # Write Original Trainer's name and ID number
      if @pokemon.owner.name.empty?
        if SUMMARY_B2W2_STYLE
          textpos.push([_INTL("RENTAL"), 164, 156, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push(["?????", 164, 176, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        else
          textpos.push([_INTL("RENTAL"), 164, 158, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push(["?????", 164, 178, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        end
      else
        # Changes the color of the text, to the one used in BW
        ownerbase   = Color.new(90, 82, 82)
        ownershadow = Color.new(165, 165, 173)
        case @pokemon.owner.gender
        when 0
          ownerbase = Color.new(0, 0, 214)
          ownershadow = Color.new(15, 148, 255)
        when 1
          ownerbase = Color.new(198, 0, 0)
          ownershadow = Color.new(255, 155, 155)
        end
        if SUMMARY_B2W2_STYLE
          # Write Trainer's name
          textpos.push([@pokemon.owner.name, 164, 158, 0, ownerbase, ownershadow])
          # Write Pokémon's ID
          textpos.push([sprintf("%05d", @pokemon.owner.public_id), 164, 190, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        else
          # Write Trainer's name
          textpos.push([@pokemon.owner.name, 164, 160, 0, ownerbase, ownershadow])
          # Write Pokémon's ID
          textpos.push([sprintf("%05d", @pokemon.owner.public_id), 164, 192, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        end
      end
      # Write Exp text OR heart gauge message (if a Shadow Pokémon)
      if @pokemon.shadowPokemon?
        textpos.push([_INTL("Heart Gauge"), 33, 231, 0, base, shadow])
        heartmessage = [_INTL("The door to its heart is open! Undo the final lock!"),
                        _INTL("The door to its heart is almost fully open."),
                        _INTL("The door to its heart is nearly open."),
                        _INTL("The door to its heart is opening wider."),
                        _INTL("The door to its heart is opening up."),
                        _INTL("The door to its heart is tightly shut.")][@pokemon.heartStage]
         # Changed the text color, to the one used in BW
         memo = sprintf("<c3=404040,B0B0B0>%s\n", heartmessage)
         y_coord = SUMMARY_B2W2_STYLE ? 294 : 296
         drawFormattedTextEx(overlay, 16, y_coord-9, 264, memo)
      else
        endexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level + 1)
        if SUMMARY_B2W2_STYLE
          textpos.push([_INTL("Exp. Points"), 34, 229, 0, base, shadow])
          # Changed the Positon of No. of Exp
          textpos.push(["#{(@pokemon.exp).to_s_formatted} + #{(@pokemon.stored_exp).to_s_formatted}", 200, 261, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push([_INTL("To Next Lv."), 34, 293, 0, base, shadow])
          # Changed the Positon of No. of Exp to Next Level
          textpos.push([(endexp-@pokemon.exp).to_s_formatted, 177, 325, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        else
          textpos.push([_INTL("Exp. Points (Stored)"), 34, 226, 0, base, shadow])
          # Changed the Positon of No. of Exp
          textpos.push(["#{(@pokemon.exp).to_s_formatted} (#{(@pokemon.stored_exp).to_s_formatted})", 200, 257, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          # Changed the Positon of No. of Exp to Next Level
          textpos.push([_INTL("To Next Lv."), 34, 288, 0, base, shadow])
          textpos.push(["#{(endexp-@pokemon.exp-@pokemon.stored_exp).to_s_formatted}", 177, 322, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        end
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw Pokémon type(s)
      @pokemon.types.each_with_index do |type, i|
        type_number = GameData::Type.get(type).icon_position
        type_rect = Rect.new(0, type_number * 28, 64, 28)
        type_x = (@pokemon.types.length == 1) ? 162 : 162 + (66 * i)
        if SUMMARY_B2W2_STYLE
                overlay.blt(type_x, 132, @typebitmap.bitmap, type_rect)
              else
                overlay.blt(type_x, 134, @typebitmap.bitmap, type_rect)
        end
      end
      # Draw Exp bar
      if @pokemon.level < GameData::GrowthRate.max_level
        w = @pokemon.exp_fraction * 128
        w = ((w/2).round) * 2
        if SUMMARY_B2W2_STYLE
          pbDrawImagePositions(overlay, [["Graphics/Pictures/Summary/overlay_exp", 140, 358 ,0, 0, w, 6]])
        else
          pbDrawImagePositions(overlay, [["Graphics/Pictures/Summary/overlay_exp", 140, 360, 0, 0, w, 6]])
        end
      end
    if Settings::SUMMARY_TERA_TYPES
      overlay = @sprites["overlay"].bitmap
      coords = (PluginManager.installed?("BW Summary Screen")) ? [122, 129] : [330, 143]
      pbDisplayTeraType(@pokemon, overlay, coords[0], coords[1])
    end
    end

    def drawPageOneEgg
      @sprites["itemicon"].item = @pokemon.item_id
      overlay = @sprites["overlay"].bitmap
      overlay.clear
      # Changes the color of the text, to the one used in BW
      base   = Color.new(90, 82, 82)
      shadow = Color.new(165, 165, 173)
      # Set background image
      if SUMMARY_B2W2_STYLE
        @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_egg_B2W2")
      else
        @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_egg")
      end
      imagepos = []
      # Show the Poké Ball containing the Pokémon
      ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%s", @pokemon.poke_ball)
      imagepos.push([ballimage, 320, 50])
      # Draw all images
      pbDrawImagePositions(overlay, imagepos)
      # Write various bits of text
      if SUMMARY_B2W2_STYLE
        textpos = [
          [@pokemon.name, 354, 52, 0, base, shadow],
          [_INTL("Item"), 298, 326, 0, base, shadow]
        ]
      else
        textpos = [
          [_INTL("TRAINER MEMO"), 26, 14, 0, Color.new(255, 255, 255), Color.new(132, 132, 132)],
          [@pokemon.name, 354, 52, 0, base, shadow],
          [_INTL("Item"), 298, 328, 0, base, shadow]
        ]
      end
      # Write the held item's name
      if @pokemon.hasItem?
        textpos.push([@pokemon.item.name, 290, 356, 0, base, shadow])
      else
        textpos.push([_INTL("None"), 290, 356, 0, base, shadow])
      end
      # Draw all text
      pbDrawTextPositions(overlay,textpos)
      memo = ""
      # Write date received
      if @pokemon.timeReceived
        date  = @pokemon.timeReceived.day
        month = pbGetMonthName(@pokemon.timeReceived.mon)
        year  = @pokemon.timeReceived.year
        # Changed the color of the text, to the one used in BW
        memo += _INTL("<c3=404040,B0B0B0>{1} {2}, {3}\n", date, month, year)
      end
      # Write map name egg was received on
      mapname = pbGetMapNameFromId(@pokemon.obtain_map)
      mapname = @pokemon.obtain_text if @pokemon.obtain_text && !@pokemon.obtain_text.empty?
      if mapname && mapname != ""
        # Changed the color of the text, to the one used in BW
        memo += _INTL("<c3=404040,B0B0B0>A mysterious Pokémon Egg received from <c3=0000D6,7394FF>{1}<c3=404040,B0B0B0>.\n", mapname)
      else
        # Changed the color of the text, to the one used in BW
        memo += _INTL("<c3=404040,B0B0B0>A mysterious Pokémon Egg.\n", mapname)
      end
      memo += "\n" # Empty line
      # Write Egg Watch blurb
      memo += _INTL("<c3=404040,B0B0B0>\"The Egg Watch\"\n")
      eggstate = _INTL("It looks like this Egg will take a long time to hatch.")
      eggstate = _INTL("What will hatch from this? It doesn't seem close to hatching.") if @pokemon.steps_to_hatch < 10_200
      eggstate = _INTL("It appears to move occasionally. It may be close to hatching.") if @pokemon.steps_to_hatch < 2550
      eggstate = _INTL("Sounds can be heard coming from inside! It will hatch soon!") if @pokemon.steps_to_hatch < 1275
      memo += sprintf("<c3=404040,B0B0B0>%s\n", eggstate)
      # Draw all text
      drawFormattedTextEx(overlay, 10, 90, 268, memo)
      # Draw the Pokémon's markings
      if SUMMARY_B2W2_STYLE
        drawMarkings(overlay, 370, 302)
      else
        drawMarkings(overlay, 416, 306)
      end
    end

    def drawPageTwo
      overlay = @sprites["overlay"].bitmap
      memo = ""
      # Write nature
      showNature = !@pokemon.shadowPokemon? || @pokemon.heartStage <= 3
      if showNature
        natureName = @pokemon.nature.name
        # Changed the color of the text, to the one used in BW
        memo += _INTL("<c3=0000d6,7394ff>{1}<c3=404040,B0B0B0> nature.\n", natureName)
      end
      # Write date received
      if @pokemon.timeReceived
        date  = @pokemon.timeReceived.day
        month = pbGetMonthName(@pokemon.timeReceived.mon)
        year  = @pokemon.timeReceived.year
        # Changed the color of the text, to the one used in BW
		
	  if pbGetMapNameFromId(@pokemon.obtain_map) == "INTRO"
	    @pokemon.obtain_text = "Hoenn"
	  end
      mapname = _INTL("met at {1}",pbGetMapNameFromId(@pokemon.obtain_map))
      mapname = _INTL("from {1}",@pokemon.obtain_text)  if @pokemon.obtain_text && !@pokemon.obtain_text.empty?
      mapname = _INTL("met at Faraway place") if !mapname || mapname==""
        memo += _INTL("<c3=404040,B0B0B0>{1} {2}, {3} {4}.\n", date, month, year, mapname)
      end
      # Write map name Pokémon was received on
	  if @pokemon.onAdventure == true && !@pokemon.location.nil?
      memo += _INTL("Currently in <c3=0000d6,7394ff>{1}\n", pbGetMapNameFromId(@pokemon.location))
	  end
      # Changed the color of the text, to the one used in BW
      # Write how Pokémon was obtained
	  if @pokemon.starter == true
      mettext = _INTL("Friends since Lv. 1")
	  else
      mettext = [_INTL("Caught at Lv. {1}", @pokemon.obtain_level),
                 _INTL("Egg hatched"),
                 _INTL("Traded at Lv. {1}", @pokemon.obtain_level),
                 "",
                 _INTL("Had a fateful encounter at Lv. {1}", @pokemon.obtain_level)
                ][@pokemon.obtain_method]
                # Changed the color of the text, to the one used in BW
	 end
      if @pokemon.obtain_method == 1
        if @pokemon.timeEggHatched
          date  = @pokemon.timeEggHatched.day
          month = pbGetMonthName(@pokemon.timeEggHatched.mon)
          year  = @pokemon.timeEggHatched.year
          # Changed the color of the text, to the one used in BW
        mapname = pbGetMapNameFromId(@pokemon.hatched_map)
        mapname = _INTL("a Faraway place") if nil_or_empty?(mapname)
		  if mettext && mettext!=""
          memo += _INTL("<c3=404040,B0B0B0>{1} {2} {3}, {4} in {5}.\n",mettext, date, month, year,mapname)
		  else
          memo += _INTL("<c3=404040,B0B0B0>{1} {2}, {3} in {4}.\n", date, month, year,mapname)
		  end
        end
      else
	  if @pokemon.starter == true
      memo += sprintf("<c3=404040,B0B0B0>%s!\n", mettext) if mettext && mettext!=""
	  else
      memo += sprintf("<c3=404040,B0B0B0>%s.\n", mettext) if mettext && mettext!=""
	  end
      end
      # If Pokémon was hatched, write when and where it hatched
      # Write characteristic
      if showNature
        best_stat = nil
        best_iv = 0
        stats_order = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
        start_point = @pokemon.personalID % stats_order.length   # Tiebreaker
        stats_order.length.times do |i|
          stat = stats_order[(i + start_point) % stats_order.length]
          if !best_stat || @pokemon.iv[stat] > @pokemon.iv[best_stat]
            best_stat = stat
            best_iv = @pokemon.iv[best_stat]
          end
        end
        characteristics = {
          :HP              => [_INTL("Loves to eat."),
                               _INTL("Takes plenty of siestas."),
                               _INTL("Nods off a lot."),
                               _INTL("Scatters things often."),
                               _INTL("Likes to relax.")],
          :ATTACK          => [_INTL("Proud of its power."),
                               _INTL("Likes to thrash about."),
                               _INTL("A little quick tempered."),
                               _INTL("Likes to fight."),
                               _INTL("Quick tempered.")],
          :DEFENSE         => [_INTL("Sturdy body."),
                               _INTL("Capable of taking hits."),
                               _INTL("Highly persistent."),
                               _INTL("Good endurance."),
                               _INTL("Good perseverance.")],
          :SPECIAL_ATTACK  => [_INTL("Highly curious."),
                               _INTL("Mischievous."),
                               _INTL("Thoroughly cunning."),
                               _INTL("Often lost in thought."),
                               _INTL("Very finicky.")],
          :SPECIAL_DEFENSE => [_INTL("Strong willed."),
                               _INTL("Somewhat vain."),
                               _INTL("Strongly defiant."),
                               _INTL("Hates to lose."),
                               _INTL("Somewhat stubborn.")],
          :SPEED           => [_INTL("Likes to run."),
                               _INTL("Alert to sounds."),
                               _INTL("Impetuous and silly."),
                               _INTL("Somewhat of a clown."),
                               _INTL("Quick to flee.")]
        }
        memo += sprintf("<c3=404040,B0B0B0>%s\n", characteristics[best_stat][best_iv % 5])
      end
      # Write all text
      drawFormattedTextEx(overlay, 12, 62, 300, memo)
    end

    def drawPageThree
      overlay = @sprites["overlay"].bitmap
      # Changes the color of the text, to the one used in BW
      base   = Color.new(90, 82, 82)
      shadow = Color.new(165, 165, 173)
      if SHOW_EV_IV
        # Set background image when showing EV/IV Stats
        @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_hidden")
      end

      if SHOW_EV_IV && SUMMARY_B2W2_STYLE
        # Set background image when showing EV/IV Stats
        @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background_B2W2")
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_hidden_B2W2")
      end

      # Show IV Letters Grades
      pbDisplayIVRating if SHOW_IV_RATINGS
      # Determine which stats are boosted and lowered by the Pokémon's nature
      # Stats Shadow Bug fixed by Shashu-Greninja
      statshadows = {}
      GameData::Stat.each_main { |s| statshadows[s.id] = shadow }
      if !@pokemon.shadowPokemon? || @pokemon.heartStage <= 3
        @pokemon.nature_for_stats.stat_changes.each do |change|
          if INVERTED_SHADOW_STATS
            statshadows[change[0]] = Color.new(148, 148, 214) if change[1] > 0
            statshadows[change[0]] = Color.new(206, 148, 156) if change[1] < 0
          else
            statshadows[change[0]] = Color.new(206, 148, 156) if change[1] > 0
            statshadows[change[0]] = Color.new(148, 148, 214) if change[1] < 0
          end
        end
      end
  #===============================================================================
  # Stat Screen Upgrade (EVs and IVs in Summary)
  #   By Weibrot, Kobi2604 and dirkriptide
  #
  #     Converted to BW Summary Pack by DeepBlue PacificWaves
  #    Updated to v19 by Shashu-Greninja
  #===============================================================================
  # Write various bits of text
        textpos = [
          [_INTL("HP"), 64, 72, 0, Color.new(255, 255, 255), statshadows[:HP]],
          [sprintf("%d/%d", @pokemon.hp, @pokemon.totalhp), 182, 72, 2, base, shadow],
          [sprintf("%d", @pokemon.ev[:HP]), 252, 72, 2, base, shadow],
          [sprintf("%d" ,@pokemon.iv[:HP]), 296, 72, 2, base, shadow],
          [_INTL("Attack"), 16, 122, 0, Color.new(255, 255, 255), statshadows[:ATTACK]],
          [sprintf("%d", @pokemon.attack), 182, 122, 2, base, shadow],
          [sprintf("%d", @pokemon.ev[:ATTACK]), 252, 122, 2, base, shadow],
          [sprintf("%d", @pokemon.iv[:ATTACK]), 296, 122, 2, base, shadow],
          [_INTL("Defense"), 16, 154, 0, Color.new(255, 255, 255), statshadows[:DEFENSE]],
          [sprintf("%d", @pokemon.defense), 182, 154, 2, base, shadow],
          [sprintf("%d", @pokemon.ev[:DEFENSE]), 252, 154, 2, base, shadow],
          [sprintf("%d", @pokemon.iv[:DEFENSE]), 296, 154, 2, base, shadow],
          [_INTL("Sp. Atk"), 16, 186, 0, Color.new(255, 255, 255), statshadows[:SPECIAL_ATTACK]],
          [sprintf("%d", @pokemon.spatk), 182, 186, 2, base, shadow],
          [sprintf("%d", @pokemon.ev[:SPECIAL_ATTACK]), 252, 186, 2, base, shadow],
          [sprintf("%d", @pokemon.iv[:SPECIAL_ATTACK]), 296, 186, 2, base, shadow],
          [_INTL("Sp. Def"), 16, 218, 0, Color.new(255, 255, 255), statshadows[:SPECIAL_DEFENSE]],
          [sprintf("%d", @pokemon.spdef), 182, 218, 2, base, shadow],
          [sprintf("%d", @pokemon.ev[:SPECIAL_DEFENSE]), 252, 218, 2, base, shadow],
          [sprintf("%d", @pokemon.iv[:SPECIAL_DEFENSE]), 296, 218, 2, base, shadow],
          [_INTL("Speed"), 16, 250, 0, Color.new(255, 255, 255), statshadows[:SPEED]],
          [sprintf("%d", @pokemon.speed), 182, 250, 2, base, shadow],
          [sprintf("%d", @pokemon.ev[:SPEED]), 252, 250, 2, base, shadow],
          [sprintf("%d", @pokemon.iv[:SPEED]), 296, 250, 2, base, shadow],
          [_INTL("Ability"), 38, 284, 0, Color.new(255, 255, 255), Color.new(165, 165, 173)],
        ]
      # Draw ability name and description
      ability = @pokemon.ability
      if ability
        textpos.push([ability.name, 240, 284, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        drawTextEx(overlay, 12, 318, 277, 2, ability.description, base, shadow)
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw HP bar
      if @pokemon.hp > 0
        w = @pokemon.hp * 96 / @pokemon.totalhp.to_f
        w = 1 if w < 1
        w = ((w / 2).round) * 2
        hpzone = 0
        hpzone = 1 if @pokemon.hp <= (@pokemon.totalhp / 2).floor
        hpzone = 2 if @pokemon.hp <= (@pokemon.totalhp / 4).floor
        if SHOW_EV_IV
          imagepos = [["Graphics/Pictures/Summary/overlay_hp", 190, 112, 0, hpzone * 6, w, 6]]
        else
          imagepos = [["Graphics/Pictures/Summary/overlay_hp", 168, 112, 0, hpzone * 6, w, 6]]
        end
        pbDrawImagePositions(overlay, imagepos)
      end
    end

    def drawPageFour
      overlay = @sprites["overlay"].bitmap
      # Changes the color of the text, to the one used in BW
      moveBase   = Color.new(255, 255, 255)
      moveShadow = Color.new(123, 123, 123)
      ppBase   = [moveBase,                # More than 1/2 of total PP
                  Color.new(255, 214, 0),    # 1/2 of total PP or less
                  Color.new(255, 115, 0),   # 1/4 of total PP or less
                  Color.new(255, 8, 72)]    # Zero PP
      ppShadow = [moveShadow,             # More than 1/2 of total PP
                  Color.new(123, 99, 0),   # 1/2 of total PP or less
                  Color.new(115, 57, 0),   # 1/4 of total PP or less
                  Color.new(123, 8, 49)]   # Zero PP
      @sprites["pokemon"].visible  = true
      @sprites["pokeicon"].visible = false
      @sprites["itemicon"].visible = true
      textpos  = []
      imagepos = []
      # Write move names, types and PP amounts for each known move
      yPos = 76
      Pokemon::MAX_MOVES.times do |i|
        move = @pokemon.moves[i]
        if move
          type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
          imagepos.push(["Graphics/Pictures/types", 32, yPos + 8, 0, type_number * 28, 64, 28])
          textpos.push([move.name, 100, yPos + 2, 0, moveBase, moveShadow])
          if move.total_pp > 0
            textpos.push([_INTL("PP"), 126, yPos + 34, 0, moveBase, moveShadow])
            ppfraction = 0
            if move.pp == 0
            ppfraction = 3
            elsif move.pp * 4 <= move.total_pp
            ppfraction = 2
            elsif move.pp * 2 <= move.total_pp
            ppfraction = 1
          end
            textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 244, yPos + 34, 1, ppBase[ppfraction], ppShadow[ppfraction]])
          end
        else
          textpos.push(["-", 100, yPos - 0, 0, moveBase, moveShadow])
          textpos.push(["--", 226, yPos + 44, 1, moveBase, moveShadow])
        end
        yPos += 64
      end
      # Draw all text and images
      pbDrawTextPositions(overlay, textpos)
      pbDrawImagePositions(overlay, imagepos)
    end

    def drawPageFourSelecting(move_to_learn)
      # Learn a New Move Scene
      overlay = @sprites["overlay"].bitmap
      overlay.clear
      # Changes the color of the text, to the one used in BW
      base   = Color.new(255, 255, 255)
      shadow = Color.new(123, 123, 123)
      moveBase   = Color.new(255, 255, 255)
      moveShadow = Color.new(123, 123, 123)
      ppBase   = [moveBase,                # More than 1/2 of total PP
                  Color.new(255, 214, 0),    # 1/2 of total PP or less
                  Color.new(255, 115, 0),   # 1/4 of total PP or less
                  Color.new(255, 8, 74)]    # Zero PP
      ppShadow = [moveShadow,             # More than 1/2 of total PP
                  Color.new(123, 99, 0),   # 1/2 of total PP or less
                  Color.new(115, 57, 0),   # 1/4 of total PP or less
                  Color.new(123, 8, 49)]   # Zero PP
      # Set background image
      if move_to_learn
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_learnmove")
      else
        if SUMMARY_B2W2_STYLE
          @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_movedetail_B2W2")
        else
          @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
        end
      end
      # Write various bits of text
      if move_to_learn || SUMMARY_B2W2_STYLE
        textpos = [
          [_INTL("CATEGORY"), 20, 128, 0, base, shadow],
          [_INTL("POWER"), 20, 160, 0, base, shadow],
          [_INTL("ACCURACY"), 20, 192, 0, base, shadow]
        ]
      else
        textpos = [
          [_INTL("MOVES"), 26, 14, 0, base, shadow],
          [_INTL("CATEGORY"), 20, 128, 0, base, shadow],
          [_INTL("POWER"), 20, 160, 0, base, shadow],
          [_INTL("ACCURACY"), 20, 192, 0, base, shadow]
        ]
      end
      imagepos = []
      # Write move names, types and PP amounts for each known move
      yPos = 92
      yPos -= 76 if move_to_learn
      limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
      limit.times do |i|
        move = @pokemon.moves[i]
        if i == Pokemon::MAX_MOVES
          move = move_to_learn
          yPos += 20
        end
        if move
          type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
          imagepos.push(["Graphics/Pictures/types", 260, yPos + 8, 0, type_number * 28, 64, 28])
          textpos.push([move.name, 328, yPos + 12, 0, moveBase, moveShadow])
          if move.total_pp > 0
            textpos.push([_INTL("PP"), 354, yPos + 34, 0, moveBase, moveShadow])
            ppfraction = 0
            if move.pp == 0
              ppfraction = 3
            elsif move.pp * 4 <= move.total_pp
              ppfraction = 2
            elsif move.pp * 2 <= move.total_pp
              ppfraction = 1
            end
            textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 472, yPos + 44, 1, ppBase[ppfraction], ppShadow[ppfraction]])
          end
        else
          textpos.push(["-", 328, yPos + 12, 0, moveBase, moveShadow])
          textpos.push(["--", 454, yPos + 44, 1, moveBase, moveShadow])
        end
        yPos += 64
      end
      # Draw all text and images
      pbDrawTextPositions(overlay, textpos)
      pbDrawImagePositions(overlay, imagepos)
      # Draw Pokémon's type icon(s)
      @pokemon.types.each_with_index do |type, i|
        type_number = GameData::Type.get(type).icon_position
        type_rect = Rect.new(0, type_number * 28, 64, 28)
        type_x = (@pokemon.types.length == 1) ? 130 : 96 + (70 * i)
        overlay.blt(type_x, 78, @typebitmap.bitmap, type_rect)
      end
    end

    def drawSelectedMove(move_to_learn, selected_move)
      # Draw all of page four, except selected move's details
      drawPageFourSelecting(move_to_learn)
      # Set various values
      overlay = @sprites["overlay"].bitmap
      base   = Color.new(90, 82, 82)
      shadow = Color.new(165, 165, 173)
      @sprites["pokemon"].visible = false if @sprites["pokemon"]
      @sprites["pokeicon"].pokemon = @pokemon
      @sprites["pokeicon"].visible = true
      @sprites["itemicon"].visible = false if @sprites["itemicon"]
      textpos = []
      # Write power and accuracy values for selected move
      case selected_move.display_damage(@pokemon)
      when 0 then textpos.push(["---", 216, 162, 1, base, shadow])   # Status move
      when 1 then textpos.push(["???", 216, 160, 1, base, shadow])   # Variable power move
      else        textpos.push([selected_move.display_damage(@pokemon).to_s, 216, 160, 1, base, shadow])
      end
      if selected_move.display_accuracy(@pokemon) == 0
        textpos.push(["---", 216, 194, 1, base, shadow])
      else
        textpos.push(["#{selected_move.display_accuracy(@pokemon)}%", 216 + overlay.text_size("%").width, 192, 1, base, shadow])
      end

      #---------------------------------------------------------------------------
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw selected move's damage category icon
      imagepos = [["Graphics/Pictures/category", 166, 122, 0, selected_move.display_category(@pokemon) * 28, 64, 28]]
      pbDrawImagePositions(overlay, imagepos)
      # Draw selected move's description
      drawTextEx(overlay, 4, 224, 230, 5, selected_move.description, base, shadow)
    end

    def drawPageFive
    overlay = @sprites["overlay"].bitmap
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    textColumn=300
    evColumn=390
    ivColumn=455
	if @pokemon.loyalty.nil?
	 @pokemon.loyalty = 75
	endn.water = 100
	end
    # Write various bits of text
	verdict = ""
	@pokemon.inventory.each_with_index do |item,index|
	 next if item[0].nil?
	 if index==0
	   verdict+="#{GameData::Item.get(item[0]).name}"
	  elsif index == @pokemon.inventory.length
	   else
	   verdict+=", #{GameData::Item.get(item[0]).name}"
	  end
	
	end
    textpos = []
    textpos << [_INTL("Happiness:"),10,62,0,base,shadow]
    textpos << [_INTL("{1}/255",@pokemon.happiness{1}),126,62,0,base,shadow]
    textpos << [_INTL("Loyalty:"),10,92,0,base,shadow]
    textpos << [_INTL("{1}/255",@pokemon.loyalty{1}),126,92,0,base,shadow]
    textpos << [_INTL("Age:"),10,122,0,base,shadow]
    textpos << [_INTL("{1}",@pokemon.age{1}),126,122,0,base,shadow]
    textpos << [_INTL("Inventory"),10,222,0,base,shadow] if verdict!=""
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    # Show all ri
	drawTextEx(overlay,126,222,0,3,verdict,Color.new(64,64,64),Color.new(176,176,176))
    imagepos = []
    coord = 0
    pbDrawImagePositions(overlay,imagepos)
	
  end

  def drawPageSeven
    overlay=@sprites["overlay"].bitmap
    base=Color.new(248,248,248)
    shadow=Color.new(104,104,104)
    textpos=[]
    if @pokemon.egg?
      overlay.clear
      pbSetSystemFont(overlay)
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_7")
      ballimage = sprintf(
        "Graphics/Pictures/Summary/icon_ball_%s", @pokemon.poke_ball
      )
      if !pbResolveBitmap(ballimage)
        ballimage = sprintf(
          "Graphics/Pictures/Summary/icon_ball_%02d", 
          pbGetBallType(@pokemon.poke_ball)
        )
      end
      pbDrawImagePositions(overlay,[[ballimage,150,60,0,0,-1,-1]])
      textpos=[
         [_INTL("TRAINER MEMO"),26,10,0,base,shadow],
         [@pokemon.name,46,56,0,base,shadow],
         [_INTL("Item"),66,312,0,base,shadow]
      ]
      textpos.push([
        _INTL("None"),16,346,0,Color.new(192,200,208),Color.new(208,216,224)
      ])
      drawMarkings(overlay,84,292)
    end  
    # Draw parents
    parents_y = [78,239]
    for i in 0...2
      parent_text_line_1_y = parents_y[i]-6
      parent_text_line_2_y = parent_text_line_1_y + 24
      parent = @pokemon&.family&.[](i)
      overlay.blt(
        20,parents_y[i],
        AnimatedBitmap.new(get_parent_icon(parent)).bitmap,Rect.new(0,0,64,64)
      )
      textpos.push([
        parent ? parent.name : _INTL("???"),
        150,parent_text_line_1_y,0,base,shadow
      ])
      parent_species_name = "/" 
      if parent
        parent_species_name += GameData::Species.get(parent.species).name
      else
        parent_species_name += _INTL("???")
      end
      if ["♂","♀"].include?(parent_species_name.split('').last)
        parent_species_name=parent_species_name[0..-2]
      end
      textpos.push([parent_species_name,160,parent_text_line_2_y,0,base,shadow])
      if parent
        if parent.gender==0
          textpos.push([
            _INTL("♂"),200,parent_text_line_2_y,1,
            Color.new(24,112,216),Color.new(136,168,208)
          ])
        elsif parent.gender==1
          textpos.push([
            _INTL("♀"),200,parent_text_line_2_y,1,
            Color.new(248,56,32),Color.new(224,152,144)
          ])
        end
      end
      for j in 0...2
        overlay.blt(
          [154,207][j],68+parents_y[i],
          AnimatedBitmap.new(get_parent_icon(parent&.[](j))).bitmap,
          Rect.new(0,0,64,64)
        )
      end
    end
    pbDrawTextPositions(overlay,textpos)
  end



    def drawSelectedRibbon(ribbonid)
      # Draw all of page five
      drawPage(6)
      # Set various values
      overlay = @sprites["overlay"].bitmap
      # Changes the color of the text, to the one used in BW
      base   = Color.new(90, 82, 82)
      shadow = Color.new(165, 165, 173)
      nameBase   = Color.new(248, 248, 248)
      nameShadow = Color.new(104, 104, 104)
      # Get data for selected ribbon
      name = ribbonid ? GameData::Ribbon.get(ribbonid).name : ""
      desc = ribbonid ? GameData::Ribbon.get(ribbonid).description : ""
      # Draw the description box
      if SUMMARY_B2W2_STYLE
        imagepos = [["Graphics/Pictures/Summary/overlay_ribbon_B2W2", 0, 280]]
      else
        imagepos = [["Graphics/Pictures/Summary/overlay_ribbon", 0, 280]]
      end
      pbDrawImagePositions(overlay, imagepos)

      # Draw name of selected ribbon
      textpos = [
         [name,30, 292, 0, nameBase, nameShadow]
      ]
      pbDrawTextPositions(overlay, textpos)
      # Draw selected ribbon's description
      drawTextEx(overlay, 30, 324, 480, 0, desc, base, shadow)
    end

    def pbGoToPrevious
      newindex = @partyindex
      while newindex > 0
        newindex -= 1
        if @party[newindex] && (@page == 1 || !@party[newindex].egg? || (
        @page==6 && SHOW_FAMILY_EGG
      )) 
          @partyindex = newindex
          break
        end
      end
    end

    def pbGoToNext
      newindex = @partyindex
      while newindex < @party.length - 1
        newindex += 1
        if @party[newindex] && (@page == 1 || !@party[newindex].egg? || (
        @page==7 && SHOW_FAMILY_EGG
      ))
          @partyindex = newindex
          break
        end
      end
    end

    def pbChangePokemon
      @pokemon = @party[@partyindex]
      @sprites["pokemon"].setPokemonBitmap(@pokemon)
      @sprites["itemicon"].item = @pokemon.item_id
      pbSEStop
      @pokemon.play_cry
    if SHOW_FAMILY_EGG && @pokemon.egg? && @page==7
      @ignore_refresh=true
      drawPageSeven
    end
    end

    def pbMoveSelection
      @sprites["movesel"].visible = true
      @sprites["movesel"].index   = 0
      selmove    = 0
      oldselmove = 0
      switching = false
      drawSelectedMove(nil, @pokemon.moves[selmove])
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["movepresel"].index == @sprites["movesel"].index
          @sprites["movepresel"].z = @sprites["movesel"].z + 1
        else
          @sprites["movepresel"].z = @sprites["movesel"].z
        end
        if Input.trigger?(Input::BACK)
          (switching) ? pbPlayCancelSE : pbPlayCloseMenuSE
          break if !switching
          @sprites["movepresel"].visible = false
          switching = false
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          if selmove == Pokemon::MAX_MOVES
            break if !switching
            @sprites["movepresel"].visible = false
            switching = false
          elsif !@pokemon.shadowPokemon?
            if switching
              tmpmove                    = @pokemon.moves[oldselmove]
              @pokemon.moves[oldselmove] = @pokemon.moves[selmove]
              @pokemon.moves[selmove]    = tmpmove
              @sprites["movepresel"].visible = false
              switching = false
              drawSelectedMove(nil, @pokemon.moves[selmove])
            else
              @sprites["movepresel"].index   = selmove
              @sprites["movepresel"].visible = true
              oldselmove = selmove
              switching = true
            end
          end
        elsif Input.trigger?(Input::UP)
          selmove -= 1
          if selmove < Pokemon::MAX_MOVES && selmove >= @pokemon.numMoves
            selmove = @pokemon.numMoves - 1
          end
          selmove = 0 if selmove >= Pokemon::MAX_MOVES
          selmove = @pokemon.numMoves - 1 if selmove < 0
          @sprites["movesel"].index = selmove
          pbPlayCursorSE
          drawSelectedMove(nil, @pokemon.moves[selmove])
        elsif Input.trigger?(Input::DOWN)
          selmove += 1
          selmove = 0 if selmove < Pokemon::MAX_MOVES && selmove >= @pokemon.numMoves
          selmove = 0 if selmove >= Pokemon::MAX_MOVES
          selmove = Pokemon::MAX_MOVES if selmove < 0
          @sprites["movesel"].index = selmove
          pbPlayCursorSE
          drawSelectedMove(nil, @pokemon.moves[selmove])
        end
      end
      @sprites["movesel"].visible = false
    end

    def pbRibbonSelection
      @sprites["ribbonsel"].visible = true
      @sprites["ribbonsel"].index   = 0
      selribbon    = @ribbonOffset * 4
      oldselribbon = selribbon
      switching = false
      numRibbons = @pokemon.ribbons.length
      numRows    = [((numRibbons + 3) / 4).floor, 3].max
      drawSelectedRibbon(@pokemon.ribbons[selribbon])
      loop do
        @sprites["uparrow"].visible   = (@ribbonOffset > 0)
        @sprites["downarrow"].visible = (@ribbonOffset < numRows - 3)
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["ribbonpresel"].index == @sprites["ribbonsel"].index
          @sprites["ribbonpresel"].z = @sprites["ribbonsel"].z + 1
        else
          @sprites["ribbonpresel"].z = @sprites["ribbonsel"].z
        end
        hasMovedCursor = false
        if Input.trigger?(Input::BACK)
          (switching) ? pbPlayCancelSE : pbPlayCloseMenuSE
          break if !switching
          @sprites["ribbonpresel"].visible = false
          switching = false
        elsif Input.trigger?(Input::USE)
          if switching
            pbPlayDecisionSE
            tmpribbon                      = @pokemon.ribbons[oldselribbon]
            @pokemon.ribbons[oldselribbon] = @pokemon.ribbons[selribbon]
            @pokemon.ribbons[selribbon]    = tmpribbon
            if @pokemon.ribbons[oldselribbon] || @pokemon.ribbons[selribbon]
              @pokemon.ribbons.compact!
              if selribbon >= numRibbons
                selribbon = numRibbons - 1
                hasMovedCursor = true
              end
            end
            @sprites["ribbonpresel"].visible = false
            switching = false
            drawSelectedRibbon(@pokemon.ribbons[selribbon])
          else
            if @pokemon.ribbons[selribbon]
              pbPlayDecisionSE
              @sprites["ribbonpresel"].index = selribbon - (@ribbonOffset * 4)
              oldselribbon = selribbon
              @sprites["ribbonpresel"].visible = true
              switching = true
            end
          end
        elsif Input.trigger?(Input::UP)
          selribbon -= 4
          selribbon += numRows * 4 if selribbon < 0
          hasMovedCursor = true
          pbPlayCursorSE
        elsif Input.trigger?(Input::DOWN)
          selribbon += 4
          selribbon -= numRows * 4 if selribbon >= numRows * 4
          hasMovedCursor = true
          pbPlayCursorSE
        elsif Input.trigger?(Input::LEFT)
          selribbon -= 1
          selribbon += 4 if selribbon % 4 == 3
          hasMovedCursor = true
          pbPlayCursorSE
        end
      next if !hasMovedCursor
          @ribbonOffset = (selribbon / 4).floor if selribbon < @ribbonOffset * 4
          @ribbonOffset = (selribbon / 4).floor - 2 if selribbon >= (@ribbonOffset + 3) * 4
          @ribbonOffset = 0 if @ribbonOffset < 0
          @ribbonOffset = numRows - 3 if @ribbonOffset > numRows - 3
          @sprites["ribbonsel"].index    = selribbon - (@ribbonOffset * 4)
          @sprites["ribbonpresel"].index = oldselribbon - (@ribbonOffset * 4)
        drawSelectedRibbon(@pokemon.ribbons[selribbon])
      end
          @sprites["ribbonsel"].visible = false
    end

    def pbMarking(pokemon)
      @sprites["markingbg"].visible      = true
      @sprites["markingoverlay"].visible = true
      @sprites["markingsel"].visible     = true
      # Changed the color of the text, to the one used in BW
      base   = Color.new(248, 248, 248)
      shadow = Color.new(104, 104, 104)
      ret = pokemon.markings.clone
      markings = pokemon.markings.clone
      mark_variants = @markingbitmap.bitmap.height / MARK_HEIGHT
      index = 0
      redraw = true
      markrect = Rect.new(0, 0, MARK_WIDTH, MARK_HEIGHT)
      loop do
        # Redraw the markings and text
        if redraw
          @sprites["markingoverlay"].bitmap.clear
          (@markingbitmap.bitmap.width / MARK_WIDTH).times do |i|
            markrect.x = i * MARK_WIDTH
            markrect.y = [(markings[i] || 0), mark_variants - 1].min * MARK_HEIGHT
            @sprites["markingoverlay"].bitmap.blt(300 + (58 * (i % 3)), 154 + (50 * (i / 3)),
                                                  @markingbitmap.bitmap, markrect)
          end
          textpos = [
             [_INTL("Mark {1}", pokemon.name), 366, 102, 2, base, shadow],
             [_INTL("OK"), 366, 254, 2, base, shadow],
             [_INTL("Cancel"), 366, 302, 2, base, shadow]
          ]
          pbDrawTextPositions(@sprites["markingoverlay"].bitmap, textpos)
          redraw = false
        end
        # Reposition the marking cursor
        @sprites["markingsel"].x = 284 + (58 * (index % 3))
        @sprites["markingsel"].y = 144 + (50 * (index / 3))
        case index
        when 6    # OK
          @sprites["markingsel"].x = 284
          @sprites["markingsel"].y = 244
          @sprites["markingsel"].src_rect.y = @sprites["markingsel"].bitmap.height / 2
        when 7    # Cancel
          @sprites["markingsel"].x = 284
          @sprites["markingsel"].y = 294
          @sprites["markingsel"].src_rect.y = @sprites["markingsel"].bitmap.height / 2
        else
          @sprites["markingsel"].src_rect.y = 0
        end
        Graphics.update
        Input.update
        pbUpdate
        if Input.trigger?(Input::BACK)
          pbPlayCloseMenuSE
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          case index
          when 6   # OK
            ret = markings
            break
          when 7   # Cancel
            break
          else
            markings[index] = ((markings[index] || 0) + 1) % mark_variants
            redraw = true
          end
        elsif Input.trigger?(Input::ACTION)
          if index < 6 && markings[index] > 0
            pbPlayDecisionSE
            markings[index] = 0
            redraw = true
          end
        elsif Input.trigger?(Input::UP)
          if index == 7
            index = 6
          elsif index == 6
            index = 4
          elsif index < 3
            index = 7
          else
            index -= 3
          end
          pbPlayCursorSE
        elsif Input.trigger?(Input::DOWN)
          if index == 7
            index = 1
          elsif index == 6
            index = 7
          elsif index >= 3
            index = 6
          else
            index += 3
          end
          pbPlayCursorSE
        elsif Input.trigger?(Input::LEFT)
          if index < 6
            index -= 1
            index += 3 if index % 3 == 2
            pbPlayCursorSE
          end
        elsif Input.trigger?(Input::RIGHT)
          if index < 6
            index += 1
            index -= 3 if index % 3 == 0
            pbPlayCursorSE
          end
        end
      end
      @sprites["markingbg"].visible      = false
      @sprites["markingoverlay"].visible = false
      @sprites["markingsel"].visible     = false
      if pokemon.markings != ret
        pokemon.markings = ret
        return true
      end
      return false
    end

    def pbOptions
      dorefresh = false
      commands = []
      cmdGiveItem = -1
      cmdTakeItem = -1
      cmdPokedex  = -1
      cmdMark     = -1
      if !@pokemon.egg?
        commands[cmdGiveItem = commands.length] = _INTL("Give item")
        commands[cmdTakeItem = commands.length] = _INTL("Take item") if @pokemon.hasItem?
        commands[cmdPokedex = commands.length]  = _INTL("View Pokédex") if $player.has_pokedex
      end
      commands[cmdMark = commands.length]       = _INTL("Mark")
      commands[commands.length]                 = _INTL("Cancel")
      command = pbShowCommands(commands)
      if cmdGiveItem >= 0 && command == cmdGiveItem
        item = nil
        pbFadeOutIn {
          scene = PokemonBag_Scene.new
          screen = PokemonBagScreen.new(scene, $bag)
          item = screen.pbChooseItemScreen(proc { |itm| GameData::Item.get(itm).can_hold? })
        }
        if item
          dorefresh = pbGiveItemToPokemon(item, @pokemon, self, @partyindex)
        end
      elsif cmdTakeItem >= 0 && command == cmdTakeItem
        dorefresh = pbTakeItemFromPokemon(@pokemon, self)
      elsif cmdPokedex >= 0 && command == cmdPokedex
        $player.pokedex.register_last_seen(@pokemon)
        pbFadeOutIn {
          scene = PokemonPokedexInfo_Scene.new
          screen = PokemonPokedexInfoScreen.new(scene)
          screen.pbStartSceneSingle(@pokemon.species)
        }
        dorefresh = true
      elsif cmdMark >= 0 && command == cmdMark
        dorefresh = pbMarking(@pokemon)
      end
      return dorefresh
    end

    def pbChooseMoveToForget(move_to_learn)
      new_move = (move_to_learn) ? Pokemon::Move.new(move_to_learn) : nil
      selmove = 0
      maxmove = (new_move) ? Pokemon::MAX_MOVES : Pokemon::MAX_MOVES - 1
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if Input.trigger?(Input::BACK)
          selmove = Pokemon::MAX_MOVES
          pbPlayCloseMenuSE if new_move
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          break
        elsif Input.trigger?(Input::UP)
          selmove -= 1
          selmove = maxmove if selmove < 0
          if selmove < Pokemon::MAX_MOVES && selmove >= @pokemon.numMoves
            selmove = @pokemon.numMoves - 1
          end
          @sprites["movesel"].index = selmove
          selected_move = (selmove == Pokemon::MAX_MOVES) ? new_move : @pokemon.moves[selmove]
          drawSelectedMove(new_move, selected_move)
        elsif Input.trigger?(Input::DOWN)
          selmove += 1
          selmove = 0 if selmove > maxmove
          if selmove < Pokemon::MAX_MOVES && selmove >= @pokemon.numMoves
            selmove = (new_move) ? maxmove : 0
          end
          @sprites["movesel"].index = selmove
          selected_move = (selmove == Pokemon::MAX_MOVES) ? new_move : @pokemon.moves[selmove]
          drawSelectedMove(new_move, selected_move)
        end
      end
      return (selmove == Pokemon::MAX_MOVES) ? -1 : selmove
    end

    def pbScene
      @pokemon.play_cry
      loop do
        Graphics.update
        Input.update
        pbUpdate
        dorefresh = false
        if Input.trigger?(Input::ACTION)
          pbSEStop
          @pokemon.play_cry
        elsif Input.trigger?(Input::BACK)
          pbPlayCloseMenuSE
          break
        elsif Input.trigger?(Input::USE)
          if @page == 4
            pbPlayDecisionSE
            pbMoveSelection
            dorefresh = true
          elsif @page == 6
            pbPlayDecisionSE
            pbRibbonSelection
            dorefresh = true
          elsif !@inbattle
            pbPlayDecisionSE
            dorefresh = pbOptions
          end
        elsif Input.trigger?(Input::UP) && @partyindex > 0
          oldindex = @partyindex
          pbGoToPrevious
          if @partyindex != oldindex
            pbChangePokemon
            @ribbonOffset = 0
            dorefresh = true
          end
        elsif Input.trigger?(Input::DOWN) && @partyindex < @party.length - 1
          oldindex = @partyindex
          pbGoToNext
          if @partyindex != oldindex
            pbChangePokemon
            @ribbonOffset = 0
            dorefresh = true
          end
        elsif Input.trigger?(Input::LEFT) && !@pokemon.egg?
          oldpage = @page
          @page -= 1
          @page = 1 if @page < 1
          @page = 7 if @page > 7
          if @page != oldpage   # Move to next page
            pbSEPlay("GUI summary change page")
            @ribbonOffset = 0
            dorefresh = true
          end
        elsif Input.trigger?(Input::RIGHT) && !@pokemon.egg?
          oldpage = @page
          @page += 1
          @page = 1 if @page < 1
          @page = 7 if @page > 7
          if @page != oldpage   # Move to next page
            pbSEPlay("GUI summary change page")
            @ribbonOffset = 0
            dorefresh = true
          end
        end
        if dorefresh
          drawPage(@page)
        end
      end
      return @partyindex
    end
  end

  #===============================================================================
  #
  #===============================================================================
  class PokemonSummaryScreen
    def initialize(scene, inbattle = false)
      @scene = scene
      @inbattle = inbattle
    end

    def pbStartScreen(party, partyindex)
      @scene.pbStartScene(party, partyindex, @inbattle)
      ret = @scene.pbScene
      @scene.pbEndScene
      return ret
    end

    def pbStartForgetScreen(party, partyindex, move_to_learn)
      ret = -1
      @scene.pbStartForgetScene(party, partyindex, move_to_learn)
      loop do
        ret = @scene.pbChooseMoveToForget(move_to_learn)
        break if ret < 0 || !move_to_learn
        break if $DEBUG || !party[partyindex].moves[ret].hidden_move?
        pbMessage(_INTL("HM moves can't be forgotten now.")) { @scene.pbUpdate }
      end
      @scene.pbEndScene
      return ret
    end

    def pbStartChooseMoveScreen(party, partyindex, message)
      ret = -1
      @scene.pbStartForgetScene(party, partyindex, nil)
      pbMessage(message) { @scene.pbUpdate }
      loop do
        ret = @scene.pbChooseMoveToForget(nil)
        break if ret >= 0
        pbMessage(_INTL("You must choose a move!")) { @scene.pbUpdate }
      end
      @scene.pbEndScene
      return ret
    end
  end

  #===============================================================================
  #
  #===============================================================================
  def pbChooseMove(pokemon, variableNumber, nameVarNumber)
    return if !pokemon
    ret = -1
    pbFadeOutIn {
      scene = PokemonSummary_Scene.new
      screen = PokemonSummaryScreen.new(scene)
      ret = screen.pbStartForgetScreen([pokemon], 0, nil)
    }
    $game_variables[variableNumber] = ret
    if ret >= 0
      $game_variables[nameVarNumber] = pokemon.moves[ret].name
    else
      $game_variables[nameVarNumber] = ""
    end
    $game_map.need_refresh = true if $game_map
  end


