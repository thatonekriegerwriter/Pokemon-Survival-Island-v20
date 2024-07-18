#===============================================================================
# * Slot Charm
#===============================================================================

class SlotMachineReel < BitmapSprite
  def stopSpinning(noslipping = false)
    @stopping = true
    @slipping = SLIPPING[rand(SLIPPING.length)]
    @slipping = 0 if noslipping || $player.activeCharm?(:SPINNINGCHARM)
  end

  def update
    self.bitmap.clear
    if @toppos == 0 && @stopping && @slipping == 0
      @spinning = @stopping = false
    end
    if @spinning
      speed += SCROLLSPEED
      speed *= 3/4 if $player.activeCharm?(:SPINNINGCHARM)
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