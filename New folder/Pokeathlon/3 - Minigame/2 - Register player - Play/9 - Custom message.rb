module Pokeathlon
	module_function

	class Window_AdvancedTextPokemon_custom < Window_AdvancedTextPokemon
		def setText(value)
			@waitcount     = 0
			@curchar       = 0
			@drawncurchar  = -1
			@lastDrawnChar = -1
			@text          = value
			@textlength    = unformattedTextLength(value)
			@scrollstate   = 0
			@scrollY       = 0
			@linesdrawn    = 0
			@realframes    = 0
			@textchars     = []
			width  = 1
			height = 1
			numlines = 0
			visiblelines = (self.height-self.borderY) / 32
			if value.length==0
				@fmtchars     = []
				@bitmapwidth  = width
				@bitmapheight = height
				@numtextchars = 0
			else
				if @letterbyletter
					@fmtchars = []
					fmt = getFormattedText(self.contents, 0, 0,
						 self.width-self.borderX-SpriteWindow_Base::TEXTPADDING, -1,
						 shadowctag(@baseColor,@shadowColor)+value,32,true)
					@oldfont = self.contents.font.clone
					for ch in fmt
						chx = ch[1]+ch[3]
						chy = ch[2]+ch[4]
						width  = chx if width<chx
						height = chy if height<chy
						ch[2] += 4
						if !ch[5] && ch[0]=="\n"
							numlines += 1
							if numlines>=visiblelines
								fclone = ch.clone
								fclone[0] = "\1"
								@fmtchars.push(fclone)
								@textchars.push("\1")
							end
						end
						# Don't add newline characters, since they
						# can slow down letter-by-letter display
						if ch[5] || (ch[0]!="\r")
							@fmtchars.push(ch)
							@textchars.push(ch[5] ? "" : ch[0])
						end
					end
					fmt.clear
				else
					@fmtchars = getFormattedText(self.contents, 0, 0,
						 self.width-self.borderX-SpriteWindow_Base::TEXTPADDING, -1,
						 shadowctag(@baseColor,@shadowColor)+value,32,true)
					@oldfont = self.contents.font.clone
					for ch in @fmtchars
						chx = ch[1]+ch[3]
						chy = ch[2]+ch[4]
						width  = chx if width<chx
						height = chy if height<chy
						ch[2] += 4
						@textchars.push(ch[5] ? "" : ch[0])
					end
				end
				@bitmapwidth  = width
				@bitmapheight = 64 #height
				@numtextchars = @textchars.length
			end
			stopPause
			@displaying = @letterbyletter
			@needclear  = true
			@nodraw     = @letterbyletter
			refresh
		end
	end

	def custom_create_message_window(viewport=nil, skin=nil, line=false)
		msgwindow = line ? Window_AdvancedTextPokemon_custom.new("") : Window_AdvancedTextPokemon.new("")
		viewport ? (msgwindow.viewport = viewport) : (msgwindow.z = 99999)
		msgwindow.visible = true
		msgwindow.letterbyletter = true
		msgwindow.back_opacity = MessageConfig::WINDOW_OPACITY
		pbBottomLeftLines(msgwindow, 2)
		$game_temp.message_window_showing = true if $game_temp
		skin=MessageConfig.pbGetSpeechFrame() if !skin
		msgwindow.setSkin(skin)
		return msgwindow
	end

	def custom_message(message, newwidth=nil, line=false, commands=nil, cmdIfCancel=0, skin=nil, defaultCmd=0, &block)
		ret = 0

		msgwindow = custom_create_message_window(nil, skin, line)

		msgwindow.width = newwidth if !newwidth.nil?
		if commands
			ret = pbMessageDisplay(msgwindow, message, true,
				 proc { |msgwindow|
					 next Kernel.pbShowCommands(msgwindow,commands,cmdIfCancel,defaultCmd,&block)
				 },&block)
		else
			pbMessageDisplay(msgwindow, message, &block)
		end
		pbDisposeMessageWindow(msgwindow)
		Input.update
		return ret
	end
end