module BerryBlender
	class Show

		# Pos = position of player's berry -> 0: Player, 1: AI-1, 2: AI-2, 3: AI-3, 
		def animationBerry(berrynumber, pos=0)
			if !@sprites["berry #{pos}"]
				begin
					filename = GameData::Item.icon_filename(berrynumber)
				rescue 
					p "You have an error when choosing berry"
					Kernel.exit!
				end
				@sprites["berry #{pos}"] = Sprite.new(@viewport)
				@sprites["berry #{pos}"].bitmap = Bitmap.new(filename)
				ox = @sprites["berry #{pos}"].bitmap.width/2
				oy = @sprites["berry #{pos}"].bitmap.height/2
				set_oxoy_sprite("berry #{pos}",ox,oy)
				x = Graphics.width / 2 + (pos==0 || pos==2 ? -Graphics.height/2 : Graphics.height/2)
				y = pos==0 || pos==1 ? 0 : Graphics.height
				set_xy_sprite("berry #{pos}",x,y)
				x0 = x
				y0 = y
			end
			t = 0
			loop do
				Graphics.update
				update
				if pos==0 || pos==1
					break if @sprites["berry #{pos}"].y >= (Graphics.height/2-10)
				else
					break if @sprites["berry #{pos}"].y <= (Graphics.height/2+10)
				end
				r = Graphics.height/4*Math.sqrt(2)
				t += 0.05
				case pos
				when 0
					x =  r*(1-Math.cos(t))
					y =  r*(t-Math.sin(t))
				when 1
					x = -r*(1-Math.cos(t))
					y =  r*(t-Math.sin(t))
				when 2
					x =  r*(t-Math.sin(t))
					y = -r*(1-Math.cos(t))
				when 3
					x = -r*(t-Math.sin(t))
					y = -r*(1-Math.cos(t))
				end
				x += x0
				y += y0
				set_xy_sprite("berry #{pos}", x, y)
			end
			dispose("berry #{pos}")
		end

  end
end