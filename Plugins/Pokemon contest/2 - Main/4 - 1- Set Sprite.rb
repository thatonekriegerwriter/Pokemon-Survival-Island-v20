module ContestHall
	class Show

		#------------#
		# Set bitmap #
		#------------#
		# Image
		def create_sprite(spritename, filename, vp, dir="Contest")
			@sprites["#{spritename}"] = Sprite.new(vp)
			file = dir ? "Graphics/Pictures/#{dir}/#{filename}" : "Graphics/Pictures/#{filename}"
			@sprites["#{spritename}"].bitmap = Bitmap.new(file)
		end
		def set_sprite(spritename, filename, dir="Contest")
			file = dir ? "Graphics/Pictures/#{dir}/#{filename}" : "Graphics/Pictures/#{filename}"
			@sprites["#{spritename}"].bitmap = Bitmap.new(file)
		end
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
		#------------------------------------------------------------------------------#
    # Dispose
    def dispose(sprite=@sprites, id=nil)
      (id.nil?)? pbDisposeSpriteHash(sprite) : pbDisposeSprite(sprite, id)
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
      # Dipose sprites
			arr = [@pkmn1sprite, @pkmn2sprite, @pkmn3sprite, @pkmn4sprite]
			arr.each { |sprite|
				sprite.dispose
				sprite = nil
			}
			dispose(@heartsprites) if @heartsprites
      dispose
			# Dispose viewport
      @viewport.dispose
			@vp1.dispose
			@vp2.dispose
			if @quantity_winner == 1
				position = 
					case @order_winner[0] 
					when @pkmn1 then "No.4"
					when @pkmn2 then "No.1"
					when @pkmn3 then "No.2"
					when @pkmn4 then "No.3"
					end
				pbMessage(_INTL("MC: Congratulation! The winner is {1}, {2}", position, @order_winner[0].name))
				pbMessage(_INTL("MC: Your ribbon will get after this show. Thank you!"))
			else
				pbMessage(_INTL("MC: OMG! I can't believe. We are the winners. Sorry! We must restart."))
				pbMessage(_INTL("MC: Please register again."))
			end
			map = MAP_ID[DIFFICULT.index(@difficulty)]
			$game_self_switches[[map, EVENT_ID_CONTEST, 'A']] = false
			self.transfer(*COORIDINATE_WHEN_FINISH_CONTEST)
    end

	end
end