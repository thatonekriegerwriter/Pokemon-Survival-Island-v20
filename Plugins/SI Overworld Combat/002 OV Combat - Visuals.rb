

class PBAnimation < Array


 def playAnimationSound(pokemon)
 
    @timing.each do |i|
	   next if i.timingType!=0
        if i.name && i.name != ""
          pbSEPlay("Anim/" + i.name, i.volume, i.pitch)
        else
          name = GameData::Species.cry_filename_from_pokemon(pokemon)
          pbSEPlay(name, i.volume, i.pitch) if name
        end

    end
  end

end





class OverworldCombat

  def pbFindMoveAnimDetails(move2anim, moveID, idxUser, hitNum = 0)
    real_move_id = GameData::Move.get(moveID).id
    noFlip = false
    if (idxUser & 1) == 0   # On player's side
      anim = move2anim[0][real_move_id]
    else                # On opposing side
      anim = move2anim[1][real_move_id]
      noFlip = true if anim
      anim = move2anim[0][real_move_id] if !anim
    end
    return [anim + hitNum, noFlip] if anim
    return nil
  end

def pbLoadMoveToAnim
  $game_temp = Game_Temp.new if !$game_temp
  if !$game_temp.move_to_battle_animation_data
    $game_temp.move_to_battle_animation_data = load_data("Data/move2anim.dat") || []
  end
  return $game_temp.move_to_battle_animation_data
end


  def pbFindMoveAnimation(moveID, idxUser, hitNum)
    begin
      move2anim = pbLoadMoveToAnim
      # Find actual animation requested (an opponent using the animation first
      # looks for an OppMove version then a Move version)
      anim = pbFindMoveAnimDetails(move2anim, moveID, idxUser, hitNum)
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
          anim = pbFindMoveAnimDetails(move2anim, anims[moveKind], idxUser)
        end
        if !anim && moveKind >= 3 && GameData::Move.exists?(anims[moveKind - 3])
          anim = pbFindMoveAnimDetails(move2anim, anims[moveKind - 3], idxUser)
        end
        if !anim && GameData::Move.exists?(anims[2])
          anim = pbFindMoveAnimDetails(move2anim, anims[2], idxUser)
        end
      end
      return anim if anim
      # Default animation for the move's type not found, use Tackle's animation
      if GameData::Move.exists?(:TACKLE)
        return pbFindMoveAnimDetails(move2anim, :TACKLE, idxUser)
      end
    rescue
    end
    return nil
  end

def pbLoadBattleAnimations
  $game_temp = Game_Temp.new if !$game_temp
  if !$game_temp.battle_animations_data && pbRgssExists?("Data/PkmnAnimations.rxdata")
    $game_temp.battle_animations_data = load_data("Data/PkmnAnimations.rxdata")
  end
  return $game_temp.battle_animations_data
end

def sound_from_move(moveID, pokemon)
    animID = pbFindMoveAnimation(moveID, 0, 1)
    return if !animID
    anim = animID[0]
    animations = pbLoadBattleAnimations
    animation = animations[anim]
    return if !animation
	animation.playAnimationSound(pokemon)
end

def sound_from_animation(animName, pokemon)
    return if nil_or_empty?(animName)
    animations = pbLoadBattleAnimations
    return if !animations
    animations.each do |animation|
      next if !animation || animation.name != "Common:" + animName
	    animation.playAnimationSound(pokemon)
      return
    end
	animations.playAnimationSound(pokemon)
end

def start_glow(attacker,bonus=0)
 sprite=nil
 $scene.spriteset.character_sprites.each do |character_sprite|
  if character_sprite.character == attacker
    sprite = character_sprite
  end
 end
 
 return if sprite.nil?
fadeTime = Graphics.frame_rate * 4 / 10
toneDiff = (255.0 / fadeTime).ceil
if Settings::TIME_SHADING && $game_map.metadata&.outdoor_map
   basetone = PBDayNight.getTone
else
   basetone = Tone.new(0, 0, 0, 0)
end
   
 dir = attacker.direction #we have 16 frames to play with

(1..fadeTime).each do |index|
   update_package
   next if sprite.nil?
   next if sprite.disposed?
    case dir
	  when 2 #DOWN
	   if index<3
	    sprite.nuy-=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nuy-=0
	   else
	    sprite.nuy+=5
	   end
	  when 4 #LEFT
	   if index<3
	    sprite.nux+=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nux-=0
	   else
	    sprite.nux-=5
	   end
	  when 6 #RIGHT
	   if index<3
	    sprite.nux-=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nux-=0
	   else
	    sprite.nux+=5
	   end
	  when 8 #UP
	   if index<3
	    sprite.nuy+=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nuy-=0
	   else
	    sprite.nuy-=5
	   end
	end


  sprite.tone.set(((index+bonus) * toneDiff) + basetone.red, ((index+bonus) * toneDiff) + basetone.green, basetone.blue, basetone.gray)
end

 #start_ov_sprite_movement(attacker,sprite)

end


def start_attacked_glow(attacked,attacker,bonus=0)
 pbTurnTowardEvent(attacked,attacker)
 sprite=nil
 $scene.spriteset.character_sprites.each do |character_sprite|
  if character_sprite.character == attacked
    sprite = character_sprite
  end
 end
 
 return if sprite.nil?
fadeTime = Graphics.frame_rate * 4 / 10
toneDiff = (255.0 / fadeTime).ceil
if Settings::TIME_SHADING && $game_map.metadata&.outdoor_map
   basetone = PBDayNight.getTone
else
   basetone = Tone.new(0, 0, 0, 0)
end
   
 dir = attacked.direction #we have 16 frames to play with

(1..fadeTime).each do |index|
   update_package
   next if sprite.nil?
   next if sprite.disposed?
    case dir
	  when 2 #DOWN
	   if index<3
	    #sprite.nuy+=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nuy-=0
	   else
	    sprite.nuy-=5
	   end
	  when 4 #LEFT
	   if index<3
	    #sprite.nux-=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nux-=0
	   else
	    sprite.nux+=5
	   end
	  when 6 #RIGHT
	   if index<3
	    #sprite.nux+=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nux-=0
	   else
	    sprite.nux-=5
	   end
	  when 8 #UP
	   if index<3
	    #sprite.nuy-=5
	   elsif (index>3 && index<=6) || (index>13)
	    sprite.nuy-=0
	   else
	    sprite.nuy+=5
	   end
	end


  sprite.tone.set(((index+bonus) * toneDiff) + basetone.red, basetone.green, basetone.blue, basetone.gray)
end

 #start_ov_sprite_movement(attacker,sprite)

end



def start_ov_sprite_movement(attacker,sprite=nil)
 dir = attacker.direction
  if sprite.nil?
 $scene.spriteset.character_sprites.each do |character_sprite|
  if character_sprite.character == attacker
    sprite = character_sprite
  end
 end
  end
(1..21).each_with_index do |number,index|
   update_package
   next if sprite.nil?
   next if sprite.disposed?
    case dir
	  when 2 #DOWN
	   if index<=4
	    sprite.nuy-=5
	   elsif (index>4 && index<=7) || (index>=18)
	    sprite.nuy-=0
	   else
	    sprite.nuy+=5
	   end
	  when 4 #LEFT
	   if index<=4
	    sprite.nux+=5
	   elsif (index>4 && index<=7) || (index>=18)
	    sprite.nux-=0
	   else
	    sprite.nux-=5
	   end
	  when 6 #RIGHT
	   if index<=4
	    sprite.nux-=5
	   elsif (index>4 && index<=7) || (index>=18)
	    sprite.nux-=0
	   else
	    sprite.nux+=5
	   end
	  when 8 #UP
	   if index<=4
	    sprite.nuy+=5
	   elsif (index>4 && index<=7) || (index>=18)
	    sprite.nuy-=0
	   else
	    sprite.nuy-=5
	   end
	end


end


end




def end_glow(attacker,bonus=0)
 return if attacker.sprite.nil?
fadeTime = Graphics.frame_rate * 4 / 10
toneDiff = (255.0 / fadeTime).ceil
if Settings::TIME_SHADING && $game_map.metadata&.outdoor_map
   basetone = PBDayNight.getTone
else
   basetone = Tone.new(0, 0, 0, 0)
end
(1..fadeTime).each do |i|
  attacker.sprite.tone.set(255 - ((i+bonus) * toneDiff) + basetone.red, basetone.green, basetone.blue, basetone.gray)
end



end


def is_near_combat
   x = $game_temp.current_pkmn_controlled.x if $game_temp.current_pkmn_controlled!=false
   y = $game_temp.current_pkmn_controlled.y if $game_temp.current_pkmn_controlled!=false
   x = $game_player.x if $game_temp.current_pkmn_controlled==false
   y = $game_player.y if $game_temp.current_pkmn_controlled==false
    events = [] 
  (-7..7).each do |dx|
    (-7..7).each do |dy|
	  event_id=$game_map.check_event(x+dx,y+dy)
      if event_id.is_a?(Integer)
	     if !$game_map.events[event_id].nil?
  			if $game_map.events[event_id].is_a?(Game_PokeEvent)
			  if getParticipant(:ENEMIES).include?(event_id)
              events << event_id 
			 end
			end
		 end
      end
    end
  return true if events.length>0
  return false
end

end


def set_bgm
      testbgm = pbGetWildBGM + "_alt"
   duris = is_near_combat
       if duris
	   if testbgm!=$game_system.getPlayingBGM&.name
         if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
            $game_system.bgm_pause
            $game_temp.memorized_bgm = $game_system.getPlayingBGM
            $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
         end
         bgm = pbStringToAudioFile(testbgm) if testbgm
         pbBGMPlay(bgm) if testbgm
	   end
         else
     if $game_temp.memorized_bgm && $game_system.is_a?(Game_System) && testbgm==$game_system.getPlayingBGM&.name
        $game_system.bgm_pause
       $game_system.bgm_position = $game_temp.memorized_bgm_position
       $game_system.bgm_resume($game_temp.memorized_bgm)
		$game_temp.memorized_bgm = nil
		$game_temp.memorized_bgm_position = nil
	 end  
     
		 
		 
		 end



end





def turning_prep(attacker,target)
  return if $game_temp.bossfight==true
  pbTurnTowardEvent(attacker,target) 
end






end
def pbOverworldCombat
 return $PokemonGlobal.ov_combat
end

class PokemonGlobalMetadata
    attr_accessor :collection_maps
    attr_accessor :water_playing
    attr_accessor :ov_combat
	
    alias init__psisss_original initialize
	 def initialize
	  @ov_combat = OverworldCombat.new
	  @collection_maps = {} 
	  @water_playing = false 
	  init__psisss_original
	 end
	 
	def ov_combat
	@ov_combat = OverworldCombat.new if @ov_combat.nil?
	return @ov_combat
	end
	 
	def collection_maps
	@collection_maps = {} if @collection_maps.nil?
	return @collection_maps
	end
	def water_playing
	@water_playing = false if @water_playing.nil?
	return @water_playing
	end	
end




class OWBallThrowSprite
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,ball_used,map=nil,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @map.nil?
	@map=$game_map
	end
    @ball_used=ball_used
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
	 if @landing_coord!=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y] && $PokemonGlobal.in_dungeon==false
	 item_name = GameData::Item.try_get(ball_used).id
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
	end
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end

  def pokeball_ov_behavior
    case @phase
    when 0 # flying to landing point
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y
    when 1 # is there an event here?
      @frames=0
      @ball.src_rect.x=0
      event_id=@map.check_event(*@end_coord)
	  if event_id.is_a?(Integer)
      if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
		pbSEPlay("Battle ball hit")
        @event=@map.events[event_id]
		@pkmn = @event.pokemon #pbMapInterpreter.execute_script(script)
		if  @pkmn.status_turns>0
		@pkmn.status_turns-=1 
		@pkmn.status=:NONE if @pkmn.status_turns==0
		end



		if @pkmn.fainted?
        @event.removeThisEventfromMap
        pbPlayerEXP(@pkmn)
        pbHeldItemDropOW(@pkmn,true)
        @phase = 5
		else 
        @phase = 2
		 thefight = $PokemonGlobal.ov_combat
		 @catch=thefight.capture_calcs(@event,@ball_used,@dir)
        $scene.spriteset.addUserAnimation(BALL_CATCH_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
		end



      else
        @phase = 5
	  end
      else
        @phase = 5
	  end
    when 2
      @frames+=1
      @phase=(@catch ? 3 : 4) if @frames>=BALL_CATCH_WAIT_FRAMES
    when 3
	   pbSEPlay("Battle catch click")
	  sideDisplay("The capture was a success!")
        pbPlayerEXP(@pkmn)
		@pkmn = @event.pokemon if !@pkmn.is_a?(Pokemon)
		@pkmn.poke_ball = @ball_used
		 @pkmn.calc_stats
        $scene.spriteset.addUserAnimation(BALL_SUCCESS_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
        pbHeldItemDropOW(@pkmn)
        pkmnAnim(@pkmn)
        pbAddPokemonSilent(@pkmn)
        OverworldPBEffects.onCatch(@ball_used,@pkmn)
        @event.removeThisEventfromMap
        @phase=5
    when 4
		pbSEPlay("Battle recall")
      $scene.spriteset.addUserAnimation(BALL_RELEASE_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
	  sideDisplay("#{@pkmn.name} broke free!")
	  makeAggressive(@event)
      @phase=5
    when 5
      self.dispose
      return
    end

  
  end
  
  
  
  
  def update
    return if !@ball || @disposed
    @ball.update
	pokeball_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
    $game_temp.pokemon_calling=false
  end





  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end



class OWThrowSpriteEgg
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,ball_used,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @map.nil?
	@map=$game_map
	end
    @ball_used=ball_used
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
    graphic = pbResolveBitmap("Graphics/Characters/#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end

  def pokeball_ov_behavior
    case @phase
    when 0 # flying to landing point
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y
    when 1 # is there an event here?
      @frames=0
      @ball.src_rect.x=0
	  $player.place(*@end_coord)
    when 5
      self.dispose
      return
    end

  
  end
  
  
  
  
  def update
    return if !@ball || @disposed
    @ball.update
	pokeball_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
    $game_temp.pokemon_calling=false
  end





  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end




class OWPokemonReleaseSprite
 attr_accessor :event
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,pokemon,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
	if @map.nil?
	@map=$game_map
	end
    @pokemon=pokemon
	ball_used= @pokemon.poke_ball
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
	 if @landing_coord!=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y] && $PokemonGlobal.in_dungeon==false
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{ball_used.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic)
	end
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
    @event=nil
    @pkmn=nil
    @catch=false
  end
  

  def pokemon_ov_behavior
    case @phase
    when 0 # flying to landing point
	
	
	
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end
      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y


    when 1 # is there an event here?
	
	
	
      @frames=0
      @ball.src_rect.x=0
      event_id=@map.check_event(*@end_coord)
	  @phase = 5



	  if event_id.is_a?(Integer) && @phase != 5 
         if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
		 pbSEPlay("Battle ball hit")
         @event=event_id
		 @phase = 5

      else
        @phase = 5
	  end
      else
        @phase = 5
	  end


    when 5
	   $game_temp.pokemon_calling=false
      self.dispose
      return
    end

  
  end
  
  def update
    return if (!@ball || @disposed)
    @ball.update
	pokemon_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
   
	  $game_temp.pokemon_calling=false
  end

  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end




class OWItemUseSprite
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 2
  BALL_RELEASE_ANIM_ID = 2
  BALL_SUCCESS_ANIM_ID = 7
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  # 1/x chance to drop nothing
  
  def initialize(start_end,ball_used,map,viewport=nil,no_peak=false)
    @event=nil
    @pkmn=nil
    @catch=false
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
    @running=false
	@map = $game_map if @map.nil?
    @item_used=ball_used
	
	
    @real_x = @start_coord[0] * Game_Map::REAL_RES_X
    @real_y = @start_coord[1] * Game_Map::REAL_RES_Y
    @dest_x = @end_coord[0] * Game_Map::REAL_RES_X
    @dest_y = @end_coord[1] * Game_Map::REAL_RES_Y
    
    
    x_plus = @end_coord[0] - @start_coord[0]
    y_plus = @end_coord[1] - @start_coord[1]
    
    @dir=0
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        @dir = ((x_plus < 0) ? 1 : 2)
      else
        @dir = ((y_plus < 0) ? 3 : 0)
      end
    end
    
    real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
    distance = [1, real_distance].max
	
	if no_peak==true
    @jump_peak = 0
	else
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8 
	end
    itm = GameData::Item.get(@item_used)
	@itm = itm
	
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max   # Just needs to be non-zero
    
    @ball = IconSprite.new(0,0,viewport)
    @ball.ox=16
    @ball.oy=32
	 item_name = GameData::Item.try_get(ball_used).id
	graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{item_name.to_s}")
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball_#{item_name.to_s.chop}") if graphic.nil?
    graphic = pbResolveBitmap("Graphics/Characters/throw_ball") if graphic.nil?
    @ball.setBitmap(graphic) if @landing_coord!=[$PokemonGlobal.dungeon_x,$PokemonGlobal.dungeon_y] && $PokemonGlobal.in_dungeon==false


    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    
    @phase=0
    @frames=0
	
  end

  
  def itemeffect
    item = @item_used
    item_data=GameData::Item.get(@item_used)
	 facingEvent = $game_player.pbFacingEvent
    if item_data.is_tool?
     case @item_used
     when :MACHETE
	  if facingEvent
	   if facingEvent.name[/cuttree/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
	   end
	  end

     when :IRONPICKAXE

	  if facingEvent
	   if facingEvent.name[/smashrock/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
	   end
	  end


     when :IRONAXE
	  if facingEvent
	   if facingEvent.name[/berryplant/i]
         $stats.cut_count += 1
         #pbSmashEvent(facingEvent)
	   end
	  end
     when :IRONHAMMER
	  if facingEvent
	  end
     when :POLE
	   case $game_player.direction
	     when 2 then jump(0, 3)   # down
	     when 4 then jump(-3, 0)    # left
	     when 6 then jump(3, 0)   # right
	     when 8 then jump(0, -3)    # up
	   end
     when :WOODENPAIL

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		      when :DAMPMULCH
      berry_plant.water(20)
    when :DAMPMULCH2
      berry_plant.water(40)
	else
      berry_plant.water(10)
		        end
		  
		  end
	   end
	  end

	 when :SQUIRTBOTTLE
	 
	 
	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		          when :DAMPMULCH
		            berry_plant.water(50)
		          when :DAMPMULCH2
		            berry_plant.water(75)
		      	else
 		           berry_plant.water(25)
		        end
		  
		  end
	   end
	  end



	 when :SPRAYDUCK

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		      when :DAMPMULCH
		          berry_plant.water(40)
		        when :DAMPMULCH2
		          berry_plant.water(60)
		    	else
		          berry_plant.water(20)
		        end
		  
		  end
	   end
	  end


	 when :WAILMERPAIL

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		          when :DAMPMULCH
      berry_plant.water(60)
    when :DAMPMULCH2
      berry_plant.water(90)
	else
      berry_plant.water(30)
		        end
		  
		  end
	   end
	  end


	 when :SPRINKLOTAD
	 
	 
	 

	  if facingEvent
	   if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		    case berry_plant.mulch_id
		          when :DAMPMULCH
      berry_plant.water(70)
    when :DAMPMULCH2
      berry_plant.water(100)
	else
      berry_plant.water(35)
		        end
		  
		  end
	   end
	  end


	  
	  
	 when :SHOVEL
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
	 coords = [facing[1],facing[2]]
    terrain = $game_map.terrain_tag(facing[1], facing[2], true)
	  if !pbSeenTipCard?(:SHOVEL)
	    pbShowTipCard(:SHOVEL)
	  end
	  
	  
	  if !facingEvent.nil? && facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.getVariable
		  if berry_plant
		  berry = berry_plant.berry_id
    if berry_plant.growing? && berry_plant.growth_stage == 1
        if pbConfirmMessage(_INTL("You may be able to dig up the berry. Dig up the {1}?", GameData::Item.get(berry).name))
            berry_plant.reset
            if rand(100) < 50
                $bag.add(berry)
                pbMessage(_INTL("The dug up {1} was in good enough condition to keep.",GameData::Item.get(berry).name))
            else
                pbMessage(_INTL("The dug up {1} broke apart in your hands.",GameData::Item.get(berry).name))
            end
        end
    end
         end
	   
     elsif terrain.can_dig
	 if $PokemonGlobal.collection_maps[$game_map.map_id].nil?
	  $PokemonGlobal.collection_maps[$game_map.map_id] = []
	 end
	 if !$PokemonGlobal.collection_maps[$game_map.map_id].include?(coords)
	  pbSEPlay("shovel")
      pbCollectionMain2
      pbItemBall(:SOFTSAND)
	  $PokemonGlobal.collection_maps[$game_map.map_id] << coords
	 else
	  pbSEPlay("shovelhittingrock")
	 
    end


     else
	  end
	 
	  
	  
	 when :OLDROD
  itm = GameData::Item.get(:OLDROD)
      self.dispose
        ItemHandlers.triggerUseInField(itm) 
  return true
	 when :GOODROD
  itm = GameData::Item.get(:GOODROD)
      self.dispose
        ItemHandlers.triggerUseInField(itm) 
  return true
	 when :SUPERROD
  itm = GameData::Item.get(:SUPERROD)
      self.dispose
        ItemHandlers.triggerUseInField(itm) 
		
  return true
	 
	 
	 
	 
     end
	else
    end

  return true
  end
  


  def item_ov_behavior
    case @phase
    when 0 # flying to landing point
      if @real_x < @dest_x
        @real_x += BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x > @dest_x - 0.1
      else
        @real_x -= BALL_MOVE_SPEED
        @real_x = @dest_x if @real_x < @dest_x + 0.1
      end
      if @real_y < @dest_y
        @real_y += BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y > @dest_y - 0.1
      else
        @real_y -= BALL_MOVE_SPEED
        @real_y = @dest_y if @real_y < @dest_y + 0.1
      end

      @jump_distance_left = [(@dest_x - @real_x).abs, (@dest_y - @real_y).abs].max
      @frames+=1
      if @frames>(Game_Map::REAL_RES_X / (BALL_ANIM_SPEED * 2.0))
        @frames=0
        @ball.src_rect.x+=32
        @ball.src_rect.x=0 if @ball.src_rect.x>=128
      end
      @phase = 1 if @real_x == @dest_x && @real_y == @dest_y
	  
	  
    when 1 # is there an event here?
      @frames=0
      @ball.src_rect.x=0
      event_id=@map.check_event(*@end_coord)
	  if event_id.is_a?(Integer)
      if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
        @event=event_id
        @phase = 5

	  end
        @phase = 5

	  end
      @phase = 5

	  
	  
	  
	  
    when 5
	
      self.dispose
      return @event
	  
    end

	
  end
  

  
  def update
    return @event,@dir if !@ball || @disposed
    @ball.update
	item_ov_behavior
	if !@ball.disposed?
	@ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
	end
    $game_temp.pokemon_calling=false
	return @event,@dir
  end





  def disposed?
    return @disposed
  end

  def dispose
    @ball.dispose
    @map=nil
    @disposed=true
  end

  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  

end

















def pbThrowOWBall
  active_ball=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
  
  
  
  if $bag.quantity(active_ball)<=0
    pbPlayBuzzerSE
    return
  end
  
  
  
  
  
  
  
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
  
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
  
  $scene.spriteset.addUserSprite(OWBallThrowSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))
end


def pbThrowPokemon




   if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld.nil?
  $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].set_in_world(false)
    end
	
	
	
	
  return if $game_temp.preventspawns == true
  
  
  
  
  
  
  
  if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld==true
  
  
  
  
  
  
  if true
   $game_temp.preventspawns=true
   event = getOverworldPokemonfromPokemon($PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index])
   
   
   
   if !event.nil?
   $game_temp.following_ov_pokemon=false if $game_temp.following_ov_pokemon!=false
   pbReturnPokemon(event,true)
   else
   
   $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].set_in_world(false)  if !defined?($PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld)
   end
  $game_temp.pokemon_calling=false
   
   end
   
   
   
   
   
  else
  
  active_ball=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].poke_ball
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
	
	
	
	
	
	
	
	
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  
  
  
  
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
   pokemon = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
  $scene.spriteset.addUserSprite(OWPokemonReleaseSprite.new([start_coord,landing_coord],pokemon,$game_map,Spriteset_Map.viewport))
  
  
  end






  $game_temp.pokemon_calling=false
end


def overworld_item_behavior(active_ball)
  itm = GameData::Item.get(active_ball)
  pbSEPlay("Battle throw") if itm.is_pokeball? || @item_used == :BAIT || @item_used == :STONE || itm.is_dart?
  pbSEPlay("Sword") if active_ball==:MACHETE
  
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  amt = 1 
  amt = 3 if itm.is_dart? || active_ball==:STONE
  case $game_player.direction
  when 2; landing_coord[1]+=amt
  when 4; landing_coord[0]-=amt
  when 6; landing_coord[0]+=amt
  when 8; landing_coord[1]-=amt
  end
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
  
  $scene.spriteset.addUserSprite(OWItemUseSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))


end

def bait_is_a_special 
  active_ball=:BAIT
  if Input.trigger?(Input::SHIFT)
  ItemHandlers.triggerUseFromBag(itm)
  else
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
  
	can_do = reduceStaminaBasedOnItem(active_ball)
    return false if can_do==false
  
  $scene.spriteset.addUserSprite(OWBallThrowSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))
  end
end


def pbgetOWEffect
  active_ball=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
  pbPlayBuzzerSE if $bag.quantity(active_ball)<=0
  return if $bag.quantity(active_ball)<=0
  itm = GameData::Item.get(active_ball)
  $bag.remove(active_ball) if itm.is_dart? || active_ball == :STONE || active_ball == :BAIT
  ItemHandlers.triggerUseFromBag(itm) if itm.is_placeitem?
  overworld_item_behavior(active_ball) if itm.is_overworld?
  bait_is_a_special if active_ball==:BAIT
  if active_ball!=:BAIT && !itm.is_overworld? && !itm.is_placeitem? 
   if decreaseStamina(5)
  ItemHandlers.triggerUseFromBag(itm) 
   end
  end
  return
end
