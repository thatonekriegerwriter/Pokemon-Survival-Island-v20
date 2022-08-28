module PokegearHGSS
	class Show

		#------------#
		# Set bitmap #
		#------------#
		# Image
		def create_sprite(spritename,filename,vp,dir="Pokegear HGSS")
			@sprites["#{spritename}"] = Sprite.new(vp)
			@sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/Pictures/#{dir}/#{filename}")
		end
		["scene","bar","detail","mini"].each { |i|
			# Create
			define_method("create_sprite_#{i}".to_sym) { |spritename, filename, vp, subdir=nil|
				return create_sprite(spritename, filename, vp, "Pokegear HGSS/#{i.capitalize}") if subdir.nil?
				return create_sprite(spritename, filename, vp, "Pokegear HGSS/#{i.capitalize}/#{subdir}")
			}
			# Set sprite
			define_method("set_sprite_#{i}".to_sym) { |spritename, filename, subdir=nil|
				file = "Graphics/Pictures/Pokegear HGSS/#{i.capitalize}" + (subdir.nil? ? "" : "/#{subdir}") + "/#{filename}" 
				@sprites["#{spritename}"].bitmap = Bitmap.new(file)
			}
		}
		# Set ox, oy
		def set_oxoy_sprite(spritename,ox,oy)
			@sprites["#{spritename}"].ox = ox
			@sprites["#{spritename}"].oy = oy
		end
		# Set x, y
		def set_xy_sprite(spritename,x,y)
			@sprites["#{spritename}"].x = x
			@sprites["#{spritename}"].y = y
		end
		# Set zoom
		def set_zoom_sprite(spritename,zoom_x,zoom_y)
			@sprites["#{spritename}"].zoom_x = zoom_x
			@sprites["#{spritename}"].zoom_y = zoom_y
		end
		# Set visible
		def set_visible_sprite(spritename,vsb=false)
			@sprites["#{spritename}"].visible = vsb
		end
		# Set angle
		def set_angle_sprite(spritename,angle)
			@sprites["#{spritename}"].angle = angle
		end
		# Set src
		# width, height
		def set_src_wh_sprite(spritename,w,h)
			@sprites["#{spritename}"].src_rect.width = w
			@sprites["#{spritename}"].src_rect.height = h
		end
		# x, y
		def set_src_xy_sprite(spritename,x,y)
			@sprites["#{spritename}"].src_rect.x = x
			@sprites["#{spritename}"].src_rect.y = y
		end
		#------#
		# Text #
		#------#
		# Draw
		def create_sprite_2(spritename,vp)
			@sprites["#{spritename}"] = Sprite.new(vp)
			@sprites["#{spritename}"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
		end
		# Write
		def drawTxt(bitmap,textpos,font=nil,fontsize=nil,width=0,pw=false,height=0,ph=false,clearbm=true)
			# Sprite
			bitmap = @sprites["#{bitmap}"].bitmap
			bitmap.clear if clearbm
			# Set font, size
			(font!=nil)? (bitmap.font.name=font) : pbSetSystemFont(bitmap)
			bitmap.font.size = fontsize if !fontsize.nil?
			textpos.each { |i|
				if pw
					i[1] += width==0 ? 0 : width==1 ? bitmap.text_size(i[0]).width/2 : bitmap.text_size(i[0]).width
				else
					i[1] -= width==0 ? 0 : width==1 ? bitmap.text_size(i[0]).width/2 : bitmap.text_size(i[0]).width
				end
				if ph
					i[2] += height==0 ? 0 : height==1 ? bitmap.text_size(i[0]).height/2 : bitmap.text_size(i[0]).height
				else
					i[2] -= height==0 ? 0 : height==1 ? bitmap.text_size(i[0]).height/2 : bitmap.text_size(i[0]).height
				end
			}
			pbDrawTextPositions(bitmap,textpos)
		end
		# Clear
		def clearTxt(bitmap)
			@sprites["#{bitmap}"].bitmap.clear
		end
		#------------------------------------------------------------------------------#
		# Set SE for input
		#------------------------------------------------------------------------------#
		def checkInput(name,exact=false)
			if exact
				if Input.triggerex?(name)
					(name==:X)? pbPlayCloseMenuSE : pbPlayDecisionSE
					return true
				end
			else
				if Input.trigger?(name)
					(name==Input::BACK)? pbPlayCloseMenuSE : pbPlayDecisionSE
					return true
				end
			end
			return false
		end
		#-------#
		# Mouse #
		#-------#
		# Position
		def posMouse
			mouse = Mouse::getMousePos
			mouse = [0,0] if !mouse
			return mouse # Return value x, y of mouse
		end
		# Check delay (use in loop)
		def delayMouse(num=DelayMouse)
			m = self.posMouse
			@delay += 1
			@delay  = 0 if @oldm!=m && @delay>num
			return true if @delay<num
			@oldm = m
			return false
		end
		# Click
		def clickedMouse?
			if Input.trigger?(Input::MOUSERIGHT) || Input.trigger?(Input::MOUSELEFT)
				pbPlayDecisionSE
				return true
			end
			return false
		end
		# Check area
		def areaMouse?(arr)
			if !arr.is_a?(Array) || arr.size!=4
				p "Check area mouse"
				Kernel.exit!
			end
			x, y, w, h = arr
			rect = [x,w+x,y,h+y]
			m = @oldm
			return true if m[0].between?(rect[0], rect[1]) && m[1].between?(rect[2], rect[3])
			return false
		end
		# Check range
		def range_mouse?(*arg)
			return if arg.size < 4
			x1, x2, y1, y2 = arg
			m = @oldm
			return true if m[0].between?(x1, x2) && m[1].between?(y1, y2)
			return false
		end
		#------------------------------------------------------------------------------#
    # Dispose
    def dispose(id=nil)
      (id.nil?)? pbDisposeSpriteHash(@sprites) : pbDisposeSprite(@sprites,id)
    end
    # Update (just script)
    def update
      pbUpdateSpriteHash(@sprites)
    end
    # Update
    def update_ingame
      Graphics.update
      Input.update
      pbUpdateSpriteHash(@sprites)
    end
    # End
    def endScene
			# Fade
			pbFadeOutAndHide(@sprites)
      # Dipose sprites
      self.dispose
      # Dispose viewport
      @viewport.dispose
    end

	end
end