module ContestHall
	class Show
		
		#=============================================================================
		# Loads a move/common animation
		#=============================================================================
		# Old: pbFindMoveAnimDetails
		def find_move_aim_details(move2anim, moveID, idxUser, hitNum=0)
			id_number = GameData::Move.get(moveID).id_number
			noFlip = false
			if (idxUser&1)==0   # On player's side
				anim = move2anim[0][id_number]
			else                # On opposing side
				anim = move2anim[1][id_number]
				noFlip = true if anim
				anim = move2anim[0][id_number] if !anim
			end
			return [anim+hitNum,noFlip] if anim
			return nil
		end

		# Old: pbFindMoveAnimation
		def find_animation(moveID, idxUser, hitNum)
			begin
				move2anim = pbLoadMoveToAnim
				# Find actual animation requested (an opponent using the animation first
				# looks for an OppMove version then a Move version)
				anim = find_move_aim_details(move2anim, moveID, idxUser, hitNum)
				return anim if anim
				# Actual animation not found, get the default animation for the move's type
				moveData = GameData::Move.get(moveID)
				target_data = GameData::Target.get(moveData.target)
				moveType = moveData.type
				moveKind = moveData.category
				moveKind += 3 if target_data.num_targets > 1 || target_data.affects_foe_side
				moveKind += 3 if moveKind == 2 && target_data.num_targets > 0
				# [one target physical, one target special, user status,
				#  multiple targets physical, multiple targets special, non-user status]
				typeDefaultAnim = {
					:NORMAL   => [:TACKLE,       :SONICBOOM,    :DEFENSECURL, :EXPLOSION,  :SWIFT,        :TAILWHIP],
					:FIGHTING => [:MACHPUNCH,    :AURASPHERE,   :DETECT,      nil,         nil,           nil],
					:FLYING   => [:WINGATTACK,   :GUST,         :ROOST,       nil,         :AIRCUTTER,    :FEATHERDANCE],
					:POISON   => [:POISONSTING,  :SLUDGE,       :ACIDARMOR,   nil,         :ACID,         :POISONPOWDER],
					:GROUND   => [:SANDTOMB,     :MUDSLAP,      nil,          :EARTHQUAKE, :EARTHPOWER,   :MUDSPORT],
					:ROCK     => [:ROCKTHROW,    :POWERGEM,     :ROCKPOLISH,  :ROCKSLIDE,  nil,           :SANDSTORM],
					:BUG      => [:TWINEEDLE,    :BUGBUZZ,      :QUIVERDANCE, nil,         :STRUGGLEBUG,  :STRINGSHOT],
					:GHOST    => [:LICK,         :SHADOWBALL,   :GRUDGE,      nil,         nil,           :CONFUSERAY],
					:STEEL    => [:IRONHEAD,     :MIRRORSHOT,   :IRONDEFENSE, nil,         nil,           :METALSOUND],
					:FIRE     => [:FIREPUNCH,    :EMBER,        :SUNNYDAY,    nil,         :INCINERATE,   :WILLOWISP],
					:WATER    => [:CRABHAMMER,   :WATERGUN,     :AQUARING,    nil,         :SURF,         :WATERSPORT],
					:GRASS    => [:VINEWHIP,     :MEGADRAIN,    :COTTONGUARD, :RAZORLEAF,  nil,           :SPORE],
					:ELECTRIC => [:THUNDERPUNCH, :THUNDERSHOCK, :CHARGE,      nil,         :DISCHARGE,    :THUNDERWAVE],
					:PSYCHIC  => [:ZENHEADBUTT,  :CONFUSION,    :CALMMIND,    nil,         :SYNCHRONOISE, :MIRACLEEYE],
					:ICE      => [:ICEPUNCH,     :ICEBEAM,      :MIST,        nil,         :POWDERSNOW,   :HAIL],
					:DRAGON   => [:DRAGONCLAW,   :DRAGONRAGE,   :DRAGONDANCE, nil,         :TWISTER,      nil],
					:DARK     => [:PURSUIT,      :DARKPULSE,    :HONECLAWS,   nil,         :SNARL,        :EMBARGO],
					:FAIRY    => [:TACKLE,       :FAIRYWIND,    :MOONLIGHT,   nil,         :SWIFT,        :SWEETKISS]
				}
				if typeDefaultAnim[moveType]
					anims = typeDefaultAnim[moveType]
					if GameData::Move.exists?(anims[moveKind])
						anim = find_move_aim_details(move2anim, anims[moveKind], idxUser)
					end
					if !anim && moveKind >= 3 && GameData::Move.exists?(anims[moveKind - 3])
						anim = find_move_aim_details(move2anim, anims[moveKind - 3], idxUser)
					end
					if !anim && GameData::Move.exists?(anims[2])
						anim = find_move_aim_details(move2anim, anims[2], idxUser)
					end
				end
				return anim if anim
				# Default animation for the move's type not found, use Tackle's animation
				if GameData::Move.exists?(:TACKLE)
					return find_move_aim_details(move2anim, :TACKLE, idxUser)
				end
			rescue
			end
			return nil
		end

		#=============================================================================
		# Plays a move/common animation
		#=============================================================================
		# Old: pbAnimation
		def animation(moveID, hitNum=0)
			animID = find_animation(moveID, 0, hitNum)
			return if !animID
			anim = animID[0]
			animations = pbLoadBattleAnimations
			return if !animations
			animation_core(animations[anim])
		end

		# Old: pbAnimationCore
		def animation_core(animation)
			return if !animation
			@briefMessage = false
			userSprite   = @sprites["pokemon#{@currentpos}"]
			targetSprite = @atself ? userSprite : @sprites["opponent"]
			# Remember the original positions of Pokémon sprites
			oldUserX = userSprite.x
			oldUserY = userSprite.y
			oldTargetX = @atself ? oldUserX : targetSprite.x
			oldTargetY = @atself ? oldUserY : targetSprite.y
			oldUserOx = userSprite.ox
			oldUserOy = userSprite.oy
			oldTargetOx = @atself ? oldUserOx : targetSprite.ox
			oldTargetOy = @atself ? oldUserOy : targetSprite.oy
			# Create the animation player
			animPlayer = AnimationPlayerX.new(animation, userSprite, targetSprite, @vp2, self)
			# Apply a transformation to the animation based on where the user and target
			# actually are. Get the centres of each sprite.
			userHeight = (userSprite && userSprite.bitmap && !userSprite.bitmap.disposed?) ? userSprite.src_rect.height : 128
			if !@atself
				targetHeight = (targetSprite.bitmap && !targetSprite.bitmap.disposed?) ? targetSprite.src_rect.height : 128
			else
				targetHeight = userHeight
			end
			animPlayer.setLineTransform(
				PokeBattle_SceneConstants::FOCUSUSER_X, PokeBattle_SceneConstants::FOCUSUSER_Y,
				PokeBattle_SceneConstants::FOCUSTARGET_X, PokeBattle_SceneConstants::FOCUSTARGET_Y,
				oldUserX - 1,   oldUserY - userHeight/2 + 70,
				oldTargetX - 1, oldTargetY - userHeight/2 + 70)
			# Play the animation
			animPlayer.start
			loop do
				animPlayer.update
				# Update
				update_ingame
				break if animPlayer.animDone?
			end
			animPlayer.dispose
			# Return Pokémon sprites to their original positions
			if userSprite
				userSprite.x  = oldUserX
				userSprite.y  = oldUserY
				userSprite.ox = oldUserOx
				userSprite.oy = oldUserOy
			end
			if targetSprite && !@atself
				targetSprite.x  = oldTargetX
				targetSprite.y  = oldTargetY
				targetSprite.ox = oldTargetOx
				targetSprite.oy = oldTargetOy
			end
		end

	end
end