#Main script
def pbToggleCharm(charm)
  $player.initializeCharms if !$player.charmsActive

  if $player.elementCharmlist
    if $player.elementCharmlist.include?(charm)
      if $player.charmsActive[charm]
        $player.charmsActive[charm] = false
      else
        $player.elementCharmlist.each do |element_charm|
          $player.charmsActive[element_charm] = false
        end
        $player.charmsActive[charm] = true

        # Check if BALANCECHARM is active and turn it off
        if $player.activeCharm?(:BALANCECHARM)
          $player.charmsActive[:BALANCECHARM] = false
        end

        # Disable Easy Charm if Hard Charm is active, or vice versa
        if $player.activeCharm?(:EASYCHARM) && charm == :HARDCHARM
          $player.charmsActive[:EASYCHARM] = false
        elsif $player.activeCharm?(:HARDCHARM) && charm == :EASYCHARM
          $player.charmsActive[:HARDCHARM] = false
        end
      end
    else
      $player.charmsActive[charm] = !$player.charmsActive[charm]

      # Check if BALANCECHARM is active and turn off all elemental charms
      if $player.activeCharm?(:BALANCECHARM)
        $player.elementCharmlist.each do |element_charm|
          $player.charmsActive[element_charm] = false
        end
      end

      # Disable Easy Charm if Hard Charm is active, or vice versa
      if $player.activeCharm?(:EASYCHARM) && charm == :HARDCHARM
        $player.charmsActive[:EASYCHARM] = false
      elsif $player.activeCharm?(:HARDCHARM) && charm == :EASYCHARM
        $player.charmsActive[:HARDCHARM] = false
      end
    end
  else
    $player.charmsActive[charm] = !$player.charmsActive[charm]
  end
end
	

def pbGainCharm(charm)
  if !$bag.has?(:CHARMCASE)
    pbMessage("It looks like you haven't received a Charm Case yet!")
    pbMessage("It's a perfect place to store all your charms!")
    pbMessage("By default, all Charms you receive are set to on.")
    pbMessage("If you don't want the effects of a certain Charm, go into the case and turn it off.")
    pbReceiveItem(:CHARMCASE)
  end
 

  item_data = GameData::Item.try_get(charm)
  if item_data.nil?
    pbMessage("Received an unknown Charm. It has been discarded.")
    return false
  end
 $player.charmlist ||= []
  found = false
  for i in 0...$player.charmlist.length
    if $player.charmlist[i] == charm
      found = true
      break
    end
  end

  if !found
    $player.charmlist.push(charm)
    pbToggleCharm(charm)
    Kernel.pbMessage(_INTL("{1} is now available in the Charm Case!", GameData::Item.get(charm).name))
    return true
  end
  return false
end

def pbGainElementCharm(charm)
  if !$bag.has?(:CHARMCASE)
    pbMessage("It looks like you haven't received a Charm Case yet!")
    pbMessage("It's a perfect place to store all your charms!")
    pbMessage("By default, all Charms you receive are set to on.")
    pbMessage("If you don't want the effects of a certain Charm, go into the case and turn it off.")
    pbReceiveItem(:CHARMCASE)
  end
  $player.elementCharmlist ||= []
  found = false
  for i in 0...$player.elementCharmlist.length
    if $player.elementCharmlist[i] == charm
      found = true
      break
    end
  end
  
  if !found
    $player.elementCharmlist.push(charm)
     Kernel.pbMessage(_INTL("{1} is now available in the Elemental Charm Case!", GameData::Item.get(charm).name))
    return true
  end
  return false
end

def activeCharm?(charm)
	$player.initializeCharms if !$player.charmsActive
	return $player.charmsActive[charm]
end

class CharmCaseAdapter
  def getName(item)
    return GameData::Item.get(item).name
  end
  
  def getDisplayName(item)
    item_name = getName(item)
    return item_name
  end

  def getDescription(item)
    return GameData::Item.get(item).description
  end

  def getItemIcon(item)
    return (item) ? GameData::Item.icon_filename(item) : nil
  end
end

#===============================================================================
#
#===============================================================================
class BuyAdapter
  def initialize(adapter)
    @adapter = adapter
  end

  def getDisplayName(item)
    @adapter.getDisplayName(item)
  end
end

#===============================================================================
#
#===============================================================================
class Window_CharmCase < Window_DrawableCommand
  def initialize(stock, adapter, x, y, width, height, viewport = nil)
    @stock       = stock
    @adapter     = adapter
    super(x, y, width, height, viewport)
    @selarrow    = AnimatedBitmap.new("Graphics/UI/Charm Case/martSel")
    @baseColor   = Color.new(88, 88, 80)
    @shadowColor = Color.new(168, 184, 184)
    self.windowskin = nil
    @sliderVisible = false
    @sliderY = 0
    @sliderHeight = 0
    @sliderBitmap = AnimatedBitmap.new("Graphics/UI/Charm Case/icon_slider")
  end

	def itemCount
	   return (@stock ? @stock.length : 0) + 2
	  count += 1 if activeCharm?(:WISHINGCHARM) 
	end

	def item
		return @stock && self.index < @stock.length ? @stock[self.index] : nil
	end

def refreshSlider
  @sliderVisible = self.row_max > self.page_row_max
  if @sliderVisible
    @sliderHeight = (self.page_row_max.to_f / self.row_max * self.height).to_i
    @sliderY = (self.top_row.to_f / (self.row_max - self.page_row_max) * (self.height - @sliderHeight)).to_i
  else
    @sliderHeight = 0
    @sliderY = 0
  end
end

  def drawSlider
    return unless @sliderVisible

    sliderRect = Rect.new(0, 0, 16, @sliderHeight)
    sliderDestRect = Rect.new(self.x + self.width - 16, self.y + @sliderY, 16, @sliderHeight)
    self.contents.blt(sliderDestRect.x, sliderDestRect.y, @sliderBitmap.bitmap, sliderRect)
  end
  def update
    super

    refreshSlider
  end

def drawItem(index, count, rect)
  textpos = []
  rect = drawCursor(index, rect)
  ypos = rect.y

  if index == count - 1
    textpos.push([_INTL("Close Case"), rect.x + 22, ypos + 2, false, self.baseColor, self.shadowColor])
  elsif index == count - 2
    textpos.push([_INTL("Elemental Charms"), rect.x + 22, ypos + 2, false, self.baseColor, self.shadowColor])
	elsif index == count - 3 && activeCharm?(:WISHINGCHARM)
	  textpos.push([_INTL("Wishing Charm"), rect.x + 22, ypos + 2, false, self.baseColor, self.shadowColor])
  else
    item = @stock[index]
    itemname = @adapter.getDisplayName(item)

    # Draw the charm name first
    textpos.push([itemname, rect.x + 22, ypos + 2, false, self.baseColor, self.shadowColor])

    if $player.activeCharm?(item)
      pbDrawImagePositions(
        self.contents,
        [["Graphics/UI/Charm Case/icon_active", rect.x + rect.width - 110, rect.y + 8, 0, 0, -1, 24]]
      )
    else
      pbDrawImagePositions(
        self.contents,
        [["Graphics/UI/Charm Case/icon_active", rect.x + rect.width - 110, rect.y + 8, 0, 24, -1, 24]]
      )
    end
  end

  # Draw all text after processing each item
  pbDrawTextPositions(self.contents, textpos)
	end
end
#===============================================================================
#
#===============================================================================
class CharmCase_Scene
  def initialize
    @current_option = 0
  end

  def update
    pbUpdateSpriteHash(@sprites)
    @subscene&.pbUpdate
    update_option_text
  end

  def update_option_text
    itemwindow = @sprites["itemwindow"]
    if itemwindow.index != @current_option
      @current_option = itemwindow.index
      pbRefresh
    end
  end

  def pbRefresh
    if @subscene
      @subscene.pbRefresh
    else
      itemwindow = @sprites["itemwindow"]
      @sprites["icon"].item = itemwindow.item

      if itemwindow.index == itemwindow.itemCount - 1
        @sprites["itemtextwindow"].text = _INTL("Close Case")
      elsif itemwindow.index == itemwindow.itemCount - 2
        @sprites["itemtextwindow"].text = _INTL("Elemental Charms")
	  elsif itemwindow.index == itemwindow.itemCount - 3  && activeCharm?(:WISHINGCHARM)
		@sprites["itemtextwindow"].text = @adapter.getDescription(:WISHINGCHARM)
        @sprites["icon"].item = :WISHINGCHARM
      else
        @sprites["itemtextwindow"].text =
          (itemwindow.item) ? @adapter.getDescription(itemwindow.item) : _INTL("Quit shopping.")
      end
      itemwindow.refresh
    end
  end

  def pbCharmSetupScene(buying, stock, adapter)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @stock = stock || []
    @adapter = adapter
	@stock.sort! do |a, b|
		name_a = GameData::Item.get(a).name
		name_b = GameData::Item.get(b).name
		name_a <=> name_b
	end
    @sprites = {}
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["background"].setBitmap("Graphics/UI/Charm Case/bg")
    @sprites["gradient"] = IconSprite.new(0, 0, @viewport)
    @sprites["gradient"].setBitmap("Graphics/UI/Charm Case/grad")
    @sprites["panorama"] = IconSprite.new(0, 0, @viewport)
    @sprites["panorama"].setBitmap("Graphics/UI/Charm Case/panorama")
    @sprites["ui1"] = IconSprite.new(0, 0, @viewport)
    @sprites["ui1"].setBitmap("Graphics/UI/Charm Case/ui1_charms")
    @sprites["ui2"] = IconSprite.new(0, 0, @viewport)
    @sprites["ui2"].setBitmap("Graphics/UI/Charm Case/ui2_charms")
    @sprites["icon"] = ItemIconSprite.new(46, Graphics.height - 46, nil, @viewport)
    winAdapter = buying ? BuyAdapter.new(adapter) : SellAdapter.new(adapter)
    @sprites["itemwindow"] = Window_CharmCase.new(
      stock, winAdapter, Graphics.width - 316 - 6, -7, 330 + 16, Graphics.height - 124
    )
    @sprites["itemwindow"].viewport = @viewport
    @sprites["itemwindow"].index = 0
    @sprites["itemwindow"].refresh
    @sprites["itemtextwindow"] = Window_UnformattedTextPokemon.newWithSize(
      "", 75, Graphics.height - 92 - 16, Graphics.width - 64, 128, @viewport
    )
    pbPrepareWindow(@sprites["itemtextwindow"])
    @sprites["itemtextwindow"].baseColor = Color.new(248, 248, 248)
    @sprites["itemtextwindow"].shadowColor = Color.new(0, 0, 0)
    @sprites["itemtextwindow"].windowskin = nil
   pbDeactivateWindows(@sprites)
    pbRefresh
  end

  def pbStartCharmScene(stock, adapter)
    pbCharmSetupScene(true, stock, adapter)
  end

  def pbEndCharmScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbPrepareWindow(window)
    window.visible = true
    window.letterbyletter = false
  end

def pbSelectCharm
  itemwindow = @sprites["itemwindow"]
  pbActivateWindow(@sprites, "itemwindow") {
    pbRefresh
    loop do
      Graphics.update
      Input.update
      olditem = itemwindow.item
      self.update
      pbRefresh if itemwindow.item != olditem
      
      if Input.trigger?(Input::BACK)   # Cancel the item screen
        pbPlayCloseMenuSE
        return nil
      elsif Input.trigger?(Input::USE)
	   if itemwindow.index == itemwindow.itemCount - 3 && activeCharm?(:WISHINGCHARM) # Wishing Charm
          pbWishingStar
          return nil  # Return immediately after calling pbWishingStar
        elsif itemwindow.item
          pbToggleCharm(itemwindow.item)  # Toggle the charm
          pbRefresh  # Update the charm's status in the bag scene
          pbMessage(
            _INTL("The {1} was {2}.",
            GameData::Item.get(itemwindow.item).name,
            (activeCharm?(itemwindow.item) ? _INTL("activated") : _INTL("deactivated")))
          )
        elsif itemwindow.index == itemwindow.itemCount - 1  # Close Case
          return nil
        elsif itemwindow.index == itemwindow.itemCount - 2  # Elemental Charms
          pbOpenElementalCharmMenu
        end
      end
    end
  }
end

def pbWishingStar
  wishingStarRefresh = CharmCaseSettings::WISHING_CHARM_REFRESH
  $player.last_wish_time ||= 0
  current_time = Time.now
  time_difference = current_time - $player.last_wish_time
  seconds_passed = time_difference.to_i  # Convert to seconds
  hours_passed = seconds_passed / 3600  # 1 hour = 3600 seconds

  if hours_passed >= CharmCaseSettings::WISHING_CHARM_REFRESH
    pbWishingCharmPoke
    $player.last_wish_time = current_time  # Update the last wish time
  else
    hours_remaining = wishingStarRefresh - hours_passed
    pbMessage("You can make another wish in #{hours_remaining} hours.")
  end
end

	
def pbOpenElementalCharmMenu
  elementalCharmList = $player.elementCharmlist

  if !elementalCharmList
    pbMessage("You don't have any Elemental Charms.")
    return
  end

  commands = []
  elementalCharmList.each do |charm|
    charm_name = GameData::Item.get(charm).name
    charm_status = activeCharm?(charm) ? "Active" : "Inactive"
    commands.push(_INTL("{1} ({2})", charm_name, charm_status))
  end

  cmd = pbMessage("Choose an Elemental Charm.", commands, -1)
  if cmd >= 0
    selected_charm = elementalCharmList[cmd]
    pbToggleCharm(selected_charm)  # Toggle the charm
    pbMessage(
      _INTL("The {1} was {2}.",
      GameData::Item.get(selected_charm).name,
      (activeCharm?(selected_charm) ? _INTL("activated") : _INTL("deactivated")))
    )
  end
end
end
#===============================================================================
#
#===============================================================================
class CharmCaseScreen
  def initialize(scene, stock)
    @scene = scene
    @stock = stock
    @adapter = CharmCaseAdapter.new
  end

  def pbBuyScreen
    @scene.pbStartCharmScene(@stock, @adapter)
    item = nil
    loop do
      item = @scene.pbSelectCharm
      break if !item
      itemname       = @adapter.getDisplayName(item)
      end
    @scene.pbEndCharmScene
  end
end

def pbGiveAllCharms
  charm_list = [
        :BALANCECHARM, :BERRYCHARM, :CATCHINGCHARM, :CLOVERCHARM,  :COINCHARM,   :CORRUPTCHARM, :DISABLECHARM, :EFFORTCHARM, :EASYCHARM,  :EXPALLCHARM, :EXPCHARM,  :FRUGALCHARM, 
		:GENECHARM,    :GOLDCHARM,  :HARDCHARM,     :HEALINGCHARM, :HEARTCHARM,  :IVCHARM,      :KEYCHARM,     :LURECHARM,   :MERCYCHARM, :MININGCHARM, :OVALCHARM, :PROMOCHARM,  
		:PURIFYCHARM,  :SHINYCHARM, :SLOTSCHARM,    :SMARTCHARM,   :SPIRITCHARM, :STABCHARM,    :STEPCHARM,    :TWINCHARM,   :VIRALCHARM, :WISHINGCHARM

  ]

  charm_list.each do |charm|
    pbGainCharm(charm)
	end
end

def pbGiveAllECharms
	elemental_charm_list = [
		:BUGCHARM, :DARKCHARM, :DRAGONCHARM, :ELECTRICCHARM, :FAIRYCHARM, :FIGHTINGCHARM,
		:FIRECHARM, :FLYINGCHARM, :GHOSTCHARM, :GRASSCHARM, :GROUNDCHARM, :ICECHARM,
		:NORMALCHARM, :POISONCHARM, :PSYCHICCHARM, :ROCKCHARM, :STEELCHARM, :WATERCHARM
	  ]
  elemental_charm_list.each do |charm|
	pbGainElementCharm(charm)
	end
end
	