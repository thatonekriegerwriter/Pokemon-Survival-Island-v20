class Game_Event < Game_Character
  def should_update?(recalc = false)
    return @to_update if !recalc
    return true if @trigger && (@trigger == 3 || @trigger == 4)
    return true if @move_route_forcing || @moveto_happened
    return true if @event.name[/update/i]
    return true if @event.name[/vanishingEncounter/]
    return true if @event.name[/PlayerPkmn/]
    range = 2   # Number of tiles
    return false if self.screen_x - (@sprite_size[0] / 2) > Graphics.width + (range * Game_Map::TILE_WIDTH)
    return false if self.screen_x + (@sprite_size[0] / 2) < -range * Game_Map::TILE_WIDTH
    return false if self.screen_y_ground - @sprite_size[1] > Graphics.height + (range * Game_Map::TILE_HEIGHT)
    return false if self.screen_y_ground < -range * Game_Map::TILE_HEIGHT
    return true
  end
end

class Game_Character
  def move_type_toward_player2
    sx = @x + (@width / 2.0) - ($game_player.x + ($game_player.width / 2.0))
    sy = @y - (@height / 2.0) - ($game_player.y - ($game_player.height / 2.0))
    if sx.abs + sy.abs >= 20
      move_random
      return
    end
    case rand(6)
    when 0..4 then move_toward_player
    when 5    then move_random
    end
  end

  def move_frequency
    return @move_frequency
  end

  def lock
    return if @locked
    @prelock_direction = 0   # Was @direction but disabled
    turn_toward_player if !self.is_a?(Game_PokeEvent)
    @locked = true
  end

  def move_speed
    return @move_speed
  end
end

 def pbMovePokeEventTowardsPlayer(event,target)
	event.follow_target(target)
 end
 
class Game_PokeEvent < Game_Event
  attr_accessor :event
  attr_accessor :id
  attr_accessor :pokemon # contains the original pokemon of class Pokemon
  attr_accessor :remaining_steps #counts the remaining steps of an overworld encounter before vanishing 
  attr_accessor :parasteps_steps
  attr_accessor :map_id # contains the map_id
  attr_accessor :battle_timer # contains the map_id
  attr_accessor :movement_type # contains the map_id
  attr_accessor :movement_timer # contains the map_id
  attr_accessor :still_timer # contains the map_id
  attr_accessor :angry_at # contains the map_id
  attr_accessor :angy_at_cur_tar # contains the map_id
  attr_accessor :attacked_last_call # contains the map_id
  attr_accessor :dont_attack # contains the map_id
  attr_accessor :times_not_attacking # contains the map_id
  attr_accessor :counter # the sight line of the pokemon
  attr_accessor :movement_hit_logic # contains the map_id
  attr_accessor :default_move_frequency # contains the map_id
  attr_accessor :default_move_speed # contains the map_id
  attr_accessor :steps_taken # contains the map_id
  attr_accessor :youarealreadydead # contains the map_id
  attr_accessor :iveattacked # contains the map_id
  
  def initialize(map_id, event, pokemon, map=nil)
    super(map_id, event, map)
	@event = event
    @id  = event.id
    @map_id  = map_id
    @pokemon  = pokemon
	@iveattacked = false
	@remaining_steps  = VisibleEncounterSettings::DEFAULT_STEPS_BEFORE_VANISH
    @parasteps_steps  = 7
	@angry_at = []
    @angy_at_cur_tar  = nil
	@steps_taken  = 0
	@youarealreadydead  = false
	
	
	@movement_type = :WANDER
	@cannot_move = false
	@movement_timer = 0
	@ov_movement_timer = 7
	@still_timer = 0
	sight_line = my_sight_line
	@counter = sight_line
	
    @battle_timer  = 0
    @battle_timer  = get_battle_timer
	@times_not_attacking = 0
	@attacked_last_call = false
	@dont_attack = false
	@attacking = false
	@movement_hit_logic = false
	
	
	@default_move_frequency = self.move_frequency
	@default_move_speed = self.move_speed
  end
   def stages
    return @pokemon.stages
   end
   def dont_attack
	 @dont_attack = false if @dont_attack.nil?
    return @dont_attack
   end
   def effects
    return @pokemon.effects
   end
   
    def attack_cooldowns
     return [@battle_timer]
   end


   def get_battle_timer
    return @battle_timer + rand(Graphics.frame_rate)+Graphics.frame_rate
   end
  
  alias original_update update
  def update

    if !$game_temp.in_menu

      for anim in VisibleEncounterSettings::Perma_Enc_Animations
        anim_method = anim[0]
        anim_value = anim[1]
        anim_id = anim[2]
        if self.pokemon.method(anim_method).call == anim_value && $data_animations[anim_id]
          #spam every (animationframes + 4) frames
          if Graphics.frame_count % ($data_animations[anim_id].frames.length + 4) == 0
            #check if event on screen
            if (self.screen_x >= 0 && self.screen_x <= Graphics.width) || (self.screen_y-16 >= 0 && self.screen_y-16 <= Graphics.height)
              #Show shiny animation
              #check if event on same map as player
              if @map_id!= $game_map.map_id #different map
                sx = self.screen_x - $game_player.screen_x
                sy = self.screen_y - $game_player.screen_y
                newx = $game_player.x + (sx/32)
                newy = $game_player.y + (sy/32)
                $scene.spriteset.addUserAnimation(anim_id,newx,newy,true,1)
              else #same map
                $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
              end
            end
          end
        end
      end
    end
    original_update
  end
   
def my_sight_line
     counter_match = @event.name.match(/counter\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match

  return number.to_i if number
  return 3 
end

  def type
   return @pokemon
  end
  
   def id=(value)
     @event.id = value
   end

 def change_angry_at_target
 
 
    return nil
 end

def pkmnmovement2
     event = self
     pokemon = self.pokemon
	 @default_move_frequency =  event.move_frequency if @default_move_frequency.nil?
	 @default_move_speed = event.move_speed if @default_move_speed.nil?
   
     makeAggressive(event) if $PokemonGlobal.cur_challenge!=false && !pokemon.is_aggressive?
	
     event.move_frequency=@default_move_frequency if @movement_type != :CHASE
     event.move_frequency=@default_move_frequency+1 if @movement_type == :CHASE
     if rand(2)==0
       target = $game_player
     else
       target = nil
     end
	  rate = $PokemonGlobal.ov_combat.getRate(event,target)
	  @battle_timer-=1 if @battle_timer>0
	  @battle_timer= 0 if @battle_timer<0
	  @ov_movement_timer-=1 if @ov_movement_timer>0
	  @ov_movement_timer= 0 if @ov_movement_timer<0
	  



   if @movement_hit_logic == false && @ov_movement_timer <= 0 && !@starting && rand(100)<=rate
     self.start
     @movement_hit_logic = true
   end
	
	
     $game_temp.auto_move=false if $game_temp.auto_move.nil?
     if @cannot_move == false && @movement_hit_logic == false
       case @movement_type
         when :WANDER
          event.move_type_random
         when :STILL
          @still_timer-=1 if @still_timer>0
          @movement_type = :WANDER if @still_timer==0
         when :IMMOBILE
    
         when :CHASE
          if @angy_at_cur_tar.nil?
	         @angy_at_cur_tar = @angry_at[rand(@angry_at.length)]
          elsif @angry_at.length>1
	         target = change_angry_at_target
		      @angy_at_cur_tar = target if !target.nil?
          end
          if @angy_at_cur_tar==$game_player
		      event.move_type_toward_player2 
			elsif !@angy_at_cur_tar.nil?
		      event.move_type_toward_event(@angy_at_cur_tar)
          end
         when :FINDENEMY
          return if $game_temp.preventspawns==true
          $game_temp.preventspawns=true
          pkmn = getRandomOverworldOtherPokemon(event)
          if !pkmn.nil?
          end
          $game_temp.preventspawns=false
           @movement_type = :STILL
           @still_timer=120
         else
          event.move_type_random
       end
     end



   if @movement_hit_logic == false && @ov_movement_timer <= 0 && !@starting && rand(100)<=rate
     self.start
   end





     @movement_hit_logic = false
   end


  def is_the_styler_near_me
    mouse_loc = get_tile_mouse_on
    distance = (self.x - mouse_loc[0]).abs + (self.y - mouse_loc[1]).abs
    return distance <= 3
  end


  alias original_increase_steps increase_steps
  def increase_steps
   if self.is_a?(Game_PokeEvent)
    if @parasteps_steps.nil?
    @parasteps_steps  = 7
	end
    if @parasteps_steps <= 0 && @pokemon.status = :PARALYSIS
      @pokemon.status = :NONE
      @parasteps_steps  = 7
    else
      @parasteps_steps-=1
    end
    if @remaining_steps <= 0 && $PokemonGlobal.cur_challenge==false
	   if $game_temp.lockontarget!=false
	   if $game_temp.lockontarget.pokemon == @pokemon
	     $game_temp.lockontarget=false
	   end 
	   end
      removeThisEventfromMap
    else
      @remaining_steps-=1 if @remaining_steps>0
      @remaining_steps=40 if @remaining_steps>40
    end
   end

  end

 
  def remaining_steps
	sideDisplay("#{@pokemon.name} has #{@remaining_steps} steps left!") if @remaining_steps<11 && $PokemonGlobal.cur_challenge!=false
   @remaining_steps=40 if @remaining_steps>40
   return @remaining_steps
  end
  
  def removeThisEventfromMap
    if @pokemon.fainted?
	  pbSEPlay("faint")
	end
	
    if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
	 pbRemoveParticleEffectfromEvent(self)
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[$game_map.map_id].character_sprites
          if sprite.character==self
            $scene.spritesets[$game_map.map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
		$ExtraEvents.removethisEvent(:POKEMON,extra_events_id)
      $game_map.events.delete(@id)
    else
      if $map_factory
        for map in $map_factory.maps
          if map.events.has_key?(@id) and map.events[@id]==self
            if defined?($scene.spritesets) && $scene.spritesets[self.map_id] && $scene.spritesets[self.map_id].character_sprites
              for sprite in $scene.spritesets[self.map_id].character_sprites
                if sprite.character==self
                  $scene.spritesets[map.map_id].character_sprites.delete(sprite)
                  sprite.dispose
                  break
                end
              end
            end
		    $ExtraEvents.removethisEvent(:POKEMON,extra_events_id)
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end


  def pbFacingEvent(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
    $game_map.events.each_value do |event|
      next if !event.at_coordinate?(new_x, new_y)
      next if event.jumping? || event.over_trigger?
      return event
    end
    # If the tile in front is a counter, check one tile beyond that for events
    if $game_map.counter?(new_x, new_y)
      new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
      new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
      $game_map.events.each_value do |event|
        next if !event.at_coordinate?(new_x, new_y)
        next if event.jumping? || event.over_trigger?
        return event
      end
    end
    return nil
  end



end



