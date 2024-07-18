#===============================================================================
# * Slots Charm / Coin Charm
#===============================================================================

class SlotMachineScene
  #Payout
  def pbPayout
    @replay = false
    payout = 0
    bonus = 0
    wonRow = []
    # Get reel pictures
    reel1 = @sprites["reel1"].showing
    reel2 = @sprites["reel2"].showing
    reel3 = @sprites["reel3"].showing
    combinations = [[reel1[1], reel2[1], reel3[1]], # Centre row
                    [reel1[0], reel2[0], reel3[0]], # Top row
                    [reel1[2], reel2[2], reel3[2]], # Bottom row
                    [reel1[0], reel2[1], reel3[2]], # Diagonal top left -> bottom right
                    [reel1[2], reel2[1], reel3[0]]] # Diagonal bottom left -> top right
    combinations.length.times do |i|
      break if i >= 1 && @wager <= 1 # One coin = centre row only
      break if i >= 3 && @wager <= 2 # Two coins = three rows only
      wonRow[i] = true
      case combinations[i]
      when [1, 1, 1]   # Three Magnemites
        payout += 8
      when [2, 2, 2]   # Three Shellders
        payout += 8
      when [3, 3, 3]   # Three Pikachus
        payout += 15
      when [4, 4, 4]   # Three Psyducks
        payout += 15
      when [5, 5, 6], [5, 6, 5], [6, 5, 5], [6, 6, 5], [6, 5, 6], [5, 6, 6]   # 777 multi-colored
        payout += 90
        bonus = 1 if bonus < 1
      when [5, 5, 5], [6, 6, 6]   # Red 777, blue 777
        payout += 300
        bonus = 2 if bonus < 2
      when [7, 7, 7]   # Three replays
        @replay = true
      else
        if combinations[i][0] == 0   # Left cherry
          if combinations[i][1] == 0   # Centre cherry as well
            payout += 4
          else
            payout += 2
          end
        else
          wonRow[i] = false
        end
      end
    end
   if $player.activeCharm?(:COINCHARM) && $player.activeCharm?(:SLOTSCHARM)
  # If both charms are active, multiply by 5
      payout *= 5
   elsif $player.activeCharm?(:COINCHARM) || $player.activeCharm?(:SLOTSCHARM)
  # If only :COINCHARM or :SLOTSCHARM is active, multiply by 3
      payout *= 3
   end
    @sprites["payout"].score = payout
    frame = 0
    if payout > 0 || @replay
      if bonus > 0
        pbMEPlay("Slots big win")
      else
        pbMEPlay("Slots win")
      end
      # Show winning animation
      timePerFrame = Graphics.frame_rate / 8
      until frame == Graphics.frame_rate * 3
        Graphics.update
        Input.update
        update
        @sprites["window2"].bitmap&.clear
        @sprites["window1"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/win"))
        @sprites["window1"].src_rect.set(152 * ((frame / timePerFrame) % 4), 0, 152, 208)
        if bonus > 0
          @sprites["window2"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/bonus"))
          @sprites["window2"].src_rect.set(152 * (bonus - 1), 0, 152, 208)
        end
        @sprites["light1"].visible = true
        @sprites["light1"].src_rect.set(0, 26 * ((frame / timePerFrame) % 4), 96, 26)
        @sprites["light2"].visible = true
        @sprites["light2"].src_rect.set(0, 26 * ((frame / timePerFrame) % 4), 96, 26)
        (1..5).each do |i|
          if wonRow[i - 1]
            @sprites["row#{i}"].visible = (frame / timePerFrame).even?
          else
            @sprites["row#{i}"].visible = false
          end
        end
        frame += 1
      end
      @sprites["light1"].visible = false
      @sprites["light2"].visible = false
      @sprites["window1"].src_rect.set(0, 0, 152, 208)
      # Pay out
      loop do
        break if @sprites["payout"].score <= 0
        Graphics.update
        Input.update
        update
        @sprites["payout"].score -= 1
        @sprites["credit"].score += 1
        if Input.trigger?(Input::USE) || @sprites["credit"].score == Settings::MAX_COINS
          @sprites["credit"].score += @sprites["payout"].score
          @sprites["payout"].score = 0
        end
      end
      (Graphics.frame_rate / 2).times do
        Graphics.update
        Input.update
        update
      end
    else
      # Show losing animation
      timePerFrame = Graphics.frame_rate / 4
      until frame == Graphics.frame_rate * 2
        Graphics.update
        Input.update
        update
        @sprites["window2"].bitmap&.clear
        @sprites["window1"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/lose"))
        @sprites["window1"].src_rect.set(152 * ((frame / timePerFrame) % 2), 0, 152, 208)
        frame += 1
      end
    end
    @wager = 0
  end
     #Changing the Background image depending on payout
  def pbStartScene(difficulty)
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    if $player.activeCharm?(:COINCHARM) && $player.activeCharm?(:SLOTSCHARM)
      bg_image = "Slot Machine/bg2"  # Use this when both :COINCHARM and :SLOTSCHARM are active
    elsif $player.activeCharm?(:COINCHARM) || $player.activeCharm?(:SLOTSCHARM)
      bg_image = "Slot Machine/bg1"  # Use this when only :COINCHARM is active
    else
      bg_image = "Slot Machine/bg"   # Default option
    end
    bg_sprite = IconSprite.new(0, 0, @viewport)
    bg_sprite.setBitmap(bg_image)
#    addBackgroundPlane(@sprites, "bg", bg_image, @viewport)
    if Essentials::VERSION <= "20.9"
      @sprites["reel1"] = SlotMachineReel.new(64, 112, difficulty)
      @sprites["reel2"] = SlotMachineReel.new(144, 112, difficulty)
      @sprites["reel3"] = SlotMachineReel.new(224, 112, difficulty)
    elsif Essentials::VERSION >= "21"
      @sprites["reel1"] = SlotMachineReel.new(64, 112, 1, difficulty)
      @sprites["reel2"] = SlotMachineReel.new(144, 112, 2, difficulty)
      @sprites["reel3"] = SlotMachineReel.new(224, 112, 3, difficulty)
    else
      pbMessage("Not supported")
    end
    (1..3).each do |i|
      @sprites["button#{i}"] = IconSprite.new(68 + (80 * (i - 1)), 260, @viewport)
      @sprites["button#{i}"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/button"))
      @sprites["button#{i}"].visible = false
    end
    (1..5).each do |i|
      y = [170, 122, 218, 82, 82][i - 1]
      @sprites["row#{i}"] = IconSprite.new(2, y, @viewport)
      @sprites["row#{i}"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/line%1d%s",
                                            1 + (i / 2), (i >= 4) ? ((i == 4) ? "a" : "b") : ""))
    @sprites["row#{i}"].visible = false
    end
    @sprites["light1"] = IconSprite.new(16, 32, @viewport)
    @sprites["light1"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/lights"))
    @sprites["light1"].visible = false
    @sprites["light2"] = IconSprite.new(240, 32, @viewport)
    @sprites["light2"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/lights"))
    @sprites["light2"].mirror = true
    @sprites["light2"].visible = false
    @sprites["window1"] = IconSprite.new(358, 96, @viewport)
    @sprites["window1"].setBitmap(sprintf("Graphics/Pictures/Slot Machine/insert"))
    @sprites["window1"].src_rect.set(0, 0, 152, 208)
    @sprites["window2"] = IconSprite.new(358, 96, @viewport)
    @sprites["credit"] = SlotMachineScore.new(360, 66, $player.coins)
    @sprites["payout"] = SlotMachineScore.new(438, 66, 0)
    @wager = 0
    update
    pbFadeInAndShow(@sprites)
  end
end
class SlotMachineReel < BitmapSprite
  def stopSpinning(noslipping = false)
    @stopping = true
    @slipping = SLIPPING[rand(SLIPPING.length)]
    @slipping = 0 if noslipping || $player.activeCharm?(:SLOTSCHARM)
  end
  def update
    self.bitmap.clear
    if @toppos == 0 && @stopping && @slipping == 0
      @spinning = @stopping = false
    end
    if @spinning
      speed = SCROLLSPEED
      speed =(speed * 3 / 4).to_i if $player.activeCharm?(:SLOTSCHARM)
      @toppos += speed
      if @toppos > 0
        @toppos -= 48
        @index = (@index + 1) % @reel.length
        @slipping -= 1 if @slipping > 0
      end
    end
    4.times do |i|
      num = @index - i
      num += @reel.length if num < 0
      self.bitmap.blt(0, @toppos + (i * 48), @images.bitmap, Rect.new(@reel[num] * 64, 0, 64, 48))
    end
    self.bitmap.blt(0, 0, @shading.bitmap, Rect.new(0, 0, 64, 144))
  end
end