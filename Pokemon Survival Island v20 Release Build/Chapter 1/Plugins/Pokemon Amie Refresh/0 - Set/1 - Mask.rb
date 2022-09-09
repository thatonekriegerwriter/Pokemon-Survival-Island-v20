class Sprite
	def mask(mask = nil,xpush = 0,ypush = 0)
    # exits out of the function if the sprite currently has no bitmap to mask
    return false if !self.bitmap
    # backs up the Sprites current bitmap
    bitmap = self.bitmap.clone
    # check for mask types
    if mask.is_a?(Bitmap) # accepts Bitmap.new
      mbmp = mask
    elsif mask.is_a?(Sprite) # accepts other Sprite.new
      mbmp = mask.bitmap
    else # exits if non-matching type
      return false
    end
    # creates a new bitmap
    self.bitmap = Bitmap.new(mbmp.width, mbmp.height)
    # creates the main mask
    mask = mbmp.clone
    # calculates the dimension metrics for pixel transfer
    ox = (bitmap.width - mbmp.width) / 2
    oy = (bitmap.height - mbmp.height) / 2
    width  = mbmp.width + ox
    height = mbmp.height + oy
    # draws pixels to mask bitmap
		(oy...height).each { |y|
			(ox...width).each { |x|
				# gets pixel of mask for analysis
				pixel = mask.get_pixel(x - ox, y - oy)
				# gets pixel of current bitmap for analysis
				color = bitmap.get_pixel(x - xpush, y - ypush)
				# sets the new alpha to use the value of the mask alpha
				alpha = pixel.alpha
				alpha = color.alpha if color.alpha < pixel.alpha
				# draws new pixels onto the Sprite's bitmap
				self.bitmap.set_pixel(x - ox, y - oy, Color.new(color.red, color.green,color.blue, alpha))
			}
		}
    # returns finalized bitmap to be used elsewhere
    return self.bitmap
  end

end