module ContestHall
	class AnimationPlayerX

		attr_accessor :looping
		MAX_SPRITES = 60
	
		def initialize(animation,usersprite,targetsprite,vp,scene=nil,oppMove=false,inEditor=false)
			@animation     = animation

			# New
			@user          = nil
			@usersprite    = usersprite
			@targetsprite  = targetsprite

			@userbitmap    = (@usersprite && @usersprite.bitmap) ? @usersprite.bitmap : nil # not to be disposed
			@targetbitmap  = (@targetsprite && @targetsprite.bitmap) ? @targetsprite.bitmap : nil # not to be disposed
			@scene         = scene
			@viewport      = vp
			@viewport.z    = vp.z
			@inEditor      = inEditor
			@looping       = false
			@animbitmap    = nil   # Animation sheet graphic
			@frame         = -1
			@framesPerTick = [Graphics.frame_rate/20,1].max   # 20 ticks per second
			@srcLine       = nil
			@dstLine       = nil
			@userOrig      = getSpriteCenter(@usersprite)
			@targetOrig    = getSpriteCenter(@targetsprite)
			@oldbg         = []
			@oldfo         = []
			initializeSprites
		end
	
		def initializeSprites
			# Create animation sprites (0=user's sprite, 1=target's sprite)
			@animsprites  = []
			@animsprites[0] = @usersprite
			@animsprites[1] = @targetsprite
			for i in 2...MAX_SPRITES
				@animsprites[i] = Sprite.new(@viewport)
				@animsprites[i].bitmap  = nil
				@animsprites[i].visible = false
			end
			# Create background colour sprite
			@bgColor = ColoredPlane.new(Color.new(0,0,0),@viewport)
			@bgColor.borderX = 64 if @inEditor
			@bgColor.borderY = 64 if @inEditor
			@bgColor.z       = 5
			@bgColor.opacity = 0
			@bgColor.refresh
			# Create background graphic sprite
			@bgGraphic = AnimatedPlane.new(@viewport)
			@bgGraphic.setBitmap(nil)
			@bgGraphic.borderX = 64 if @inEditor
			@bgGraphic.borderY = 64 if @inEditor
			@bgGraphic.z       = 5
			@bgGraphic.opacity = 0
			@bgGraphic.refresh
			# Create foreground colour sprite
			@foColor = ColoredPlane.new(Color.new(0,0,0),@viewport)
			@foColor.borderX = 64 if @inEditor
			@foColor.borderY = 64 if @inEditor
			@foColor.z       = 85
			@foColor.opacity = 0
			@foColor.refresh
			# Create foreground graphic sprite
			@foGraphic = AnimatedPlane.new(@viewport)
			@foGraphic.setBitmap(nil)
			@foGraphic.borderX = 64 if @inEditor
			@foGraphic.borderY = 64 if @inEditor
			@foGraphic.z       = 85
			@foGraphic.opacity = 0
			@foGraphic.refresh
		end
	
		def dispose
			@animbitmap.dispose if @animbitmap
			for i in 2...MAX_SPRITES
				@animsprites[i].dispose if @animsprites[i]
			end
			@bgGraphic.dispose
			@bgColor.dispose
			@foGraphic.dispose
			@foColor.dispose
		end
	
		def start
			@frame = 0
		end
	
		def animDone?
			return @frame<0
		end
	
		def setLineTransform(x1,y1,x2,y2,x3,y3,x4,y4)
			@srcLine = [x1,y1,x2,y2]
			@dstLine = [x3,y3,x4,y4]
		end
	
		def update
			return if @frame<0
			animFrame = @frame/@framesPerTick
			# Loop or end the animation if the animation has reached the end
			if animFrame >= @animation.length
				@frame = (@looping) ? 0 : -1
				if @frame<0
					@animbitmap.dispose if @animbitmap
					@animbitmap = nil
					return
				end
			end
			# Load the animation's spritesheet and assign it to all the sprites.
			if !@animbitmap || @animbitmap.disposed?
				@animbitmap = AnimatedBitmap.new("Graphics/Animations/"+@animation.graphic,
					 @animation.hue).deanimate
				for i in 0...MAX_SPRITES
					@animsprites[i].bitmap = @animbitmap if @animsprites[i]
				end
			end
			# Update background and foreground graphics
			@bgGraphic.update
			@bgColor.update
			@foGraphic.update
			@foColor.update
			# Update all the sprites to depict the animation's next frame
			if @framesPerTick==1 || (@frame % @framesPerTick) == 0
				thisframe = @animation[animFrame]
				# Make all cel sprites invisible
				for i in 0...MAX_SPRITES
					@animsprites[i].visible = false if @animsprites[i]
				end
				# Set each cel sprite acoordingly
				for i in 0...thisframe.length
					cel = thisframe[i]
					next if !cel
					sprite = @animsprites[i]
					next if !sprite
					# Set cel sprite's graphic
					case cel[AnimFrame::PATTERN]
					when -1
						sprite.bitmap = @userbitmap
					when -2
						sprite.bitmap = @targetbitmap
					else
						sprite.bitmap = @animbitmap
					end

					# New
					cel[AnimFrame::MIRROR] = 1
					# Apply settings to the cel sprite
					pbSpriteSetAnimFrame(sprite, cel, @usersprite, @targetsprite)
					case cel[AnimFrame::FOCUS]
					when 1   # Focused on target
						sprite.x = cel[AnimFrame::X] - 304
						sprite.y = cel[AnimFrame::Y] - 16
					when 2   # Focused on user
						sprite.x = cel[AnimFrame::X] + 139
						sprite.y = cel[AnimFrame::Y] - 48

					when 3   # Focused on user and target
						next if !@srcLine || !@dstLine
						point = transformPoint(
							 @srcLine[0],@srcLine[1],@srcLine[2],@srcLine[3],
							 @dstLine[0],@dstLine[1],@dstLine[2],@dstLine[3],
							 sprite.x,sprite.y)
						sprite.x = point[0]
						sprite.y = point[1]
						if isReversed(@srcLine[0],@srcLine[2],@dstLine[0],@dstLine[2]) &&
							 cel[AnimFrame::PATTERN]>=0
							# Reverse direction
							sprite.mirror = !sprite.mirror
						end
					end
					sprite.x += 64 if @inEditor
					sprite.y += 64 if @inEditor
				end
				# Play timings
				@animation.playTiming(animFrame,@bgGraphic,@bgColor,@foGraphic,@foColor,@oldbg,@oldfo,@user)
			end
			@frame += 1
		end

	end
end