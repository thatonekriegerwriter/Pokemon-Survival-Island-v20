module PkmnAR
	class Show

		# Check pokemon bitmap
		#--------#
		# Height #
		#--------#
		def height_top_bot(bitmap, bottom=false)
			return 0 if !bitmap
			if bottom
				(1..bitmap.height).each { |i|
					(0..bitmap.width-1).each { |j|
						return bitmap.height - i + 1 if bitmap.get_pixel(j, bitmap.height - i).alpha > 0
					} 
				}
			else
				h   = []
				(1..bitmap.height).each { |i| 
					(0..bitmap.width-1).each { |j|
						h << bitmap.height - i if bitmap.get_pixel(j, bitmap.height - i).alpha > 0
					} 
				}
				return h.min
			end
			return 0
		end

		def height_bitmap(bitmap) = self.height_top_bot(bitmap,true) - self.height_top_bot(bitmap)

		#-------#
		# Width #
		#-------#
		def width_left_right(bitmap, right=false)
			return 0 if !bitmap
			if right
				(1..bitmap.width).each { |i|
					(0..bitmap.height-1).each { |j|
						return bitmap.width - i + 1 if bitmap.get_pixel(bitmap.width - i, j).alpha > 0
					} 
				}
			else
				w = []
				(1..bitmap.width).each { |i| 
					(0..bitmap.height-1).each { |j|
						w << bitmap.width - i if bitmap.get_pixel(bitmap.width - i, j).alpha > 0
					} 
				}
				return w.min
			end
			return 0
		end

		def width_bitmap(bitmap) = self.width_left_right(bitmap,true) - self.width_left_right(bitmap)

		#--------#
		# Metrix #
		#--------#
		# metrix = [
		# 	[w1, w2, w3, w4, ... , wn] # h1
		# 	[w1, w2, w3, w4, ... , wn] # h2
		# ]
		# If alpha <= 0, w is nil
		def pixel_bitmap_can_see_ww_h(bitmap)
			return unless bitmap.is_a?(Bitmap)
			arr = []
			(0...bitmap.height).each { |i|
				arr[i] = []
				(0...bitmap.width).each { |j| arr[i] << (bitmap.get_pixel(i, j).alpha > 0 ? j : nil) }
			}
			return arr
		end

		def over_pixel_bitmap(bitmap)
			w = bitmap.width
			h = bitmap.height
			xmin = width_left_right(bitmap)
			xmax = width_left_right(bitmap, true)
			ymin = height_top_bot(bitmap)
			ymax = height_top_bot(bitmap, true)
			return @oldm[0] > x + w || @oldm[1] > y + h
		end

	end
end