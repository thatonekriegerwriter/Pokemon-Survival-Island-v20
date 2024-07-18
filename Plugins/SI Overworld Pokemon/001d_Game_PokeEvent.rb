
class Game_PokeEvent < Game_Event
  attr_accessor :event
  attr_accessor :pokemon # contains the original pokemon of class Pokemon

  def initialize(map_id, event, map=nil)
    super(map_id, event, map)
  end
  

  
  
  def increase_steps
    if @parasteps_steps.nil?
    @parasteps_steps  = 7
	end
    if @parasteps_steps <= 0 && @pokemon.status = :PARALYSIS
      @pokemon.status = :NONE
      @parasteps_steps  = 7
    else
      @parasteps_steps-=1
    end
    if @remaining_steps <= 0
	   if $game_temp.lockontarget!=false
	   if $game_temp.lockontarget.pokemon == @pokemon
	     $game_temp.lockontarget=false
	   end 
	   end
      removeThisEventfromMap
    else
      @remaining_steps-=1
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


class Game_PokeEvent < Game_Event
  attr_accessor :remaining_steps #counts the remaining steps of an overworld encounter before vanishing 
  attr_accessor :parasteps_steps
  attr_accessor :map_id # contains the map_id
  attr_accessor :ov_battle # contains the map_id
  attr_accessor :stages # contains the map_id
  attr_accessor :battle_variables # contains the map_id
  attr_accessor :battle_timer # contains the map_id
  attr_accessor :movement_type # contains the map_id
  attr_accessor :movement_timer # contains the map_id
  attr_accessor :still_timer # contains the map_id
  attr_accessor :angry_at # contains the map_id
  attr_accessor :attacked_last_call # contains the map_id
  attr_accessor :times_not_attacking # contains the map_id
  attr_accessor :counter # contains the map_id
  attr_accessor :sprite # contains the map_id
  
  
  
  
  
  
  alias o_initialize initialize
  def initialize(map_id, event, map=nil)
    o_initialize(map_id, event, map)
    @remaining_steps  = VisibleEncounterSettings::DEFAULT_STEPS_BEFORE_VANISH
    @parasteps_steps  = 7
    @map_id  = map_id
    @ov_battle  = nil
    @stages  = {}
    @battle_variables  = {}
    @battle_timer  = rand(10)+5
	@event = event
	@movement_type = :WANDER
	@movement_timer = 0
	@ov_movement_timer = 7
	@still_timer = 0
	@angry_at = nil
	@attacked_last_call = false
	@times_not_attacking = 0
	@counter = 0
	@sprite = nil
  end
  
  def type
   return @pokemon
  end
  
  
  

def pkmnmovement2
    event = self
    pokemon = self.pokemon
	if @movement_type != :CHASE 
     event.move_frequency=3 
	
	else
     event.move_frequency=4
	end
	@battle_timer-=1 if @battle_timer>0
	@battle_timer= 0 if @battle_timer<0
	@ov_movement_timer-=1 if @ov_movement_timer>0
	@ov_movement_timer= 0 if @ov_movement_timer<0
   $game_temp.auto_move=false if $game_temp.auto_move.nil?
   $game_temp.preventspawns=true

   if @battle_timer==0 && false
  pkmn = event.pbSurroundingEvent
  if !pkmn.nil? && rand(100)<16 && @movement_type == :WANDER
  if besidethis?(event,pkmn) && pkmn.name[/PlayerPkmn/]

	end
  end
 if @ov_movement_timer==0
 

 

   
    if @counter==0
  counter_match = @event.name.match(/counter\(\d+\)/)
  counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match
	 @counter = number.to_i if number
	 @counter = 3 if !number
    target = event.pbEventWithin(@counter)
 else
  target = event.pbEventWithin(@counter)
end
  if !target.nil?
   if @ov_battle.nil?
     @ov_battle=OverworldCombat.new(self)
   end
   if @ov_battle.movement_attack(self,@ov_battle.controlled,@counter)
	@battle_timer=15
	@attacked_last_call=true
   end
	target=nil
  end
   
@ov_movement_timer=20

 end
  end









  $game_temp.preventspawns=false
 
 
 
 case @movement_type
  when :WANDER
     if true
    event.move_type_random
    end
  when :STILL
    if true
    @still_timer-=1 if @still_timer>0
	if @still_timer==0
	@movement_type = :WANDER
	end
    end
  when :IMMOBILE
    
  when :CHASE
   if @angry_at==$game_player
    event.move_type_toward_player 
	else
	event.move_type_toward_event(@angry_at)
	end
  when :FINDENEMY
    if true
     return if $game_temp.preventspawns==true
     $game_temp.preventspawns=true
     pkmn = getRandomOverworldOtherPokemon(event)
     if !pkmn.nil?
	 end
     $game_temp.preventspawns=false
      
	  @movement_type = :STILL
     @still_timer=120
    end
  else
    event.move_type_random
  end
 
 
 
 
 
 
 
   end



  
  
  # self.map_id bzw. @map_id

  def removeThisEventfromMap
    if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[$game_map.map_id].character_sprites
          if sprite.character==self
            $scene.spritesets[$game_map.map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
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
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end




end



class Game_PokeEvent < Game_Event
  alias anim_update update
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
    anim_update
  end
end
