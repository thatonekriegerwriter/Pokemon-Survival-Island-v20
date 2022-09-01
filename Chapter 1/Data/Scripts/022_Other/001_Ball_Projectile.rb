#===============================================================================
# OW Ball Projectile by Vendily
#   (only for v19.1)
#===============================================================================
class OWBallThrowSprite
  BALL_MOVE_SPEED = 32
  BALL_ANIM_SPEED = 9.6
  BALL_CATCH_ANIM_ID = 29
  BALL_RELEASE_ANIM_ID = 30
  BALL_SUCCESS_ANIM_ID = 3
  BALL_CATCH_WAIT_FRAMES = Graphics.frame_rate # 1 second
  #x/5
  BALL_PROBABILITIES={
    :POKEBALL => 3,
    :GREATBALL => 4,
    :ULTRABALL => 5,
    :PREMIERBALL => 3,
    :HEAVYBALL => 4,
    :HEALBALL => 4,
    :QUICKBALL => 4,
    :STONE => 0,
    :BAIT => 0
  }
  # 1/x chance to drop nothing
  ITEM_DROP_RATE = 4
  ITEM_DROP_TABLE = [:ORANBERRY]
  
  def initialize(start_end,ball_used,map,viewport=nil)
    @start_coord=start_end[0]
    @end_coord=start_end[1]
    @map=map
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
    graphic = "Graphics/Characters/throw_ball_#{ball_used.to_s}"
    graphic = "Graphics/Characters/throw_ball" unless graphic
    @ball.setBitmap(graphic)
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.z = self.screen_y_ground
    @ball.src_rect=Rect.new(0,@dir*32,32,32)
    @disposed=false
    @catch_rate_bonus = 0
    @escapeFactor = 50
    @phase=0
    @frames=0
    @event=nil
    @catch=false
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
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y_ground
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
  end
  
  def screen_y
    ret = self.screen_y_ground
    jump_fraction = ((@jump_distance_left.to_f / @jump_distance.to_f) - 0.5).abs   # 0.5 to 0 to 0.5
    ret += @jump_peak.to_f * (4 * jump_fraction**2 - 1)
    return ret
  end
  
  def update
    return if !@ball || @disposed
    @ball.update
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
      if event_id > 0 && @map.events[event_id].name[/vanishingEncounter/]
        @phase = 2
        @event=@map.events[event_id]
        catch_rate=BALL_PROBABILITIES[@ball_used] || 3
        catch_rate+=1 if @event.direction == [2,4,6,8][@dir]
        @catch=rand(5)<catch_rate
        $scene.spriteset.addUserAnimation(BALL_CATCH_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
        @event.removeThisEventfromMap
      else
        @phase = 5
      end
    when 2
      @frames+=1
      @phase=(@catch ? 3 : 4) if @frames>=BALL_CATCH_WAIT_FRAMES
    when 3
      script=nil
      for cmd in @event.list
        if cmd.code==111
          script=cmd.parameters[1]
          break
        end
      end
      if script
        script[/\(:(\w+),(\d+), \$game_map\.events\[\d+\]\.map\.map_id, \$game_map\.events\[\d+\]\.x, \$game_map\.events\[\d+\]\.y,(\d+|nil),(\d+|nil),(\w+)\)/]
        species=$~[1].to_sym
        level=$~[2].to_i
        gender=eval($~[3])
        form=eval($~[4])
        shiny=eval($~[5])
        pkmn=Pokemon.new(species, level)
        pkmn.gender=gender
        pkmn.form=form
        pkmn.shiny=shiny
        pbAddPokemonSilent(pkmn)
        raise _INTL("I got 3:3",)
        $scene.spriteset.addUserAnimation(BALL_SUCCESS_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
        pkmnAnim(pkmn)
        gain_party_exp(pkmn) if $Trainer.party.length > 0
        if rand(ITEM_DROP_RATE)>0
          item=ITEM_DROP_TABLE[rand(ITEM_DROP_TABLE.length)]
          item = GameData::Item.get(item)
          if item && $PokemonBag.pbStoreItem(item)
            itemAnim(item)
          end
        end
      end
      @phase=5
      return
    when 4
      $scene.spriteset.addUserAnimation(BALL_RELEASE_ANIM_ID, @end_coord[0], @end_coord[1], true, 1)
      @phase=5
      return
    when 5
      self.dispose
      return
    end
    @ball.x = self.screen_x
    @ball.y = self.screen_y
    @ball.zoom_x = 1.0
    @ball.zoom_y = @ball.zoom_x
    pbDayNightTint(@ball)
  end
  
  def gain_party_exp(caughtmon)
    caughtmon_level=caughtmon.level
    $Trainer.pokemon_party.each do |pkmn|
      next if pkmn.egg?
      next if pkmn==caughtmon
      old_level=pkmn.level
      growth_rate = pkmn.growth_rate
      # Don't bother calculating if gainer is already at max Exp
      next if pkmn.exp>=growth_rate.maximum_exp
      exp=caughtmon_level*caughtmon.base_exp
      # Scale the gained Exp based on the gainer's level (or not)
      if Settings::SCALED_EXP_FORMULA
        exp /= 5
        levelAdjust = (2*caughtmon_level+10.0)/(pkmn.level+caughtmon_level+10.0)
        levelAdjust = levelAdjust**5
        levelAdjust = Math.sqrt(levelAdjust)
        exp *= levelAdjust
        exp = exp.floor
        exp += 1
      else
        exp /= 7
      end
      isOutsider = (pkmn.owner.id != $Trainer.id ||
                   (pkmn.owner.language != 0 && pkmn.owner.language != $Trainer.language))
      if isOutsider
        if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language
          exp = (exp*1.7).floor
        else
          exp = (exp*1.5).floor
        end
      end
      # Modify Exp gain based on pkmn's held item
      i = BattleHandlers.triggerExpGainModifierItem(pkmn.item,pkmn,exp)
      exp = i if i>=0
      # Make sure Exp doesn't exceed the maximum
      expFinal = growth_rate.add_exp(pkmn.exp, exp)
      expGained = expFinal-pkmn.exp
      next if expGained<=0
      curLevel = pkmn.level
      newLevel = growth_rate.level_from_exp(expFinal)
      tempExp1 = pkmn.exp
      loop do   # For each level gained in turn...
        # EXP Bar animation
        levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
        levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
        tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
        pkmn.exp = tempExp2
        tempExp1 = tempExp2
        curLevel += 1
        if curLevel>newLevel
          # Gained all the Exp now, end the animation
          pkmn.calc_stats
          break
        end
        # Levelled up
        pkmn.changeHappiness("levelup")
        movelist = pkmn.getMoveList
        for i in movelist
          next if i[0]!=pkmn.level
          pbLearnMove(pkmn,i[1],true)
        end
      end
      # Check for evolution
      if pkmn.level>old_level
        newspecies = pkmn.check_evolution_on_level_up
        if newspecies
          pbFadeOutInWithMusic {
            evo = PokemonEvolutionScene.new
            evo.pbStartScreen(pkmn,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
          }
        end
      end
    end
  end
end

def pbThrowOWBall
  active_ball=Sprite_BallHUD::BALL_ORDER[$PokemonGlobal.ball_hud_index]
  if $PokemonBag.pbQuantity(active_ball)<=0
    pbPlayBuzzerSE
    return
  end
  $PokemonBag.pbDeleteItem(active_ball)
  start_coord=[$game_player.x,$game_player.y]
  landing_coord=[$game_player.x,$game_player.y]
  case $game_player.direction
  when 2; landing_coord[1]+=3
  when 4; landing_coord[0]-=3
  when 6; landing_coord[0]+=3
  when 8; landing_coord[1]-=3
  end
  $scene.spriteset.addUserSprite(OWBallThrowSprite.new([start_coord,landing_coord],active_ball,$game_map,Spriteset_Map.viewport))
end