class Game_PokeEventA < Game_Event
 module FollowerMovement

 


def perform_movement
  update_movement_animation
  if confused?
    pbMoveRoute2(self, [PBMoveRoute::Random])
	decrease_attack_opportunity(2) if @attack_opportunity>0 && rand(10)<6
    return
  end
#  puts "================"
#  puts pokemon.name
#  puts [self.x, self.y].inspect
#  puts @movement_type 
  case @movement_type
  when :MOVEBEHINDPLAYER
    move_behind_player
  when :FOLLOW
    follow_movement
  when :WANDER
    wander_movement
  when :STILL
    still_movement
  when :FINDENEMY
    find_enemy_movement
  when :SEARCH
    search_movement
  when :EGG
    egg_movement
  when :INBED
    inbed_movement
  when :MOVING_TO_WORK
    to_work_movement
  when :MOVING_TO_BED
    to_bed_movement
  when :WORKING
    working_movement
  else
    pbMoveRoute2(self, [PBMoveRoute::Random])
  end
end 

def in_attacking_movement_state?
 return true if work_event && work_event.type == :GUARDPOST && @movement_state == :WORKING
 return false if [:EGG, :INBED, :MOVING_TO_WORK, :MOVING_TO_BED, :WORKING, :SEARCH].include?(@movement_state)
 return true 
end 
 
 def can_be_knocked_out_of_state?
 return false if sleeping?
 return false if work_event && work_event.type == :GUARDPOST && @movement_state == :WORKING
 return false if [:EGG].include?(@movement_state)
 return true 
 end 
 
def move_behind_player
  return if sleeping?
  $game_temp.following_ov_pokemon[@id] = [@id, @type, self]

  if @following.nil?
    if alreadyfollowing == false
      if $game_temp.current_pkmn_controlled != false
        @following = $game_temp.current_pkmn_controlled
      else
        @following = $game_player
      end
    elsif alreadyfollowingmon.id != @id
      @following = alreadyfollowingmon
    end
  end

  decrease_attack_opportunity(1) if @attack_opportunity > 0

  self.move_toward_player(@following)

  @movement_type = :FOLLOW
end

def follow_movement
  return if sleeping?
  decrease_attack_opportunity(1) if
    @attack_opportunity > 0 && rand(10) < 6

  if @playercoords != [@following.x, @following.y]
    if @following.nil?
      if alreadyfollowing == false
        if $game_temp.current_pkmn_controlled != false
          @following = $game_temp.current_pkmn_controlled
        else
          @following = $game_player
        end
      elsif alreadyfollowingmon.id != @id
        @following = alreadyfollowingmon
      end
    end

    follow_leader(@following)

    look_at_location(@event.id, @following.x, @following.y)
    @playercoords = [@following.x, @following.y]
  end
end

def wander_movement
	@started_working_at = nil if !@started_working_at.nil?
  return if sleeping?
  pbMoveRoute2(self, [PBMoveRoute::Random])
  metadata = GameData::MapMetadata.try_get($game_map.map_id)
  
  if metadata.base_map && rand(100) < 51
    pbMoveRoute2(self, [PBMoveRoute::TurnTowardPlayer])
    pbMoveRoute2(self, [PBMoveRoute::TowardPlayer])
  end

  decrease_attack_opportunity(2) if
    @attack_opportunity > 0 && rand(10) < 6
end

def still_movement
  return if sleeping?
  decrease_attack_opportunity(3) if
    @attack_opportunity > 0 && rand(10) < 3

  if @still_timer == -1 &&
     rand(255) == 0 &&
     ![:PARALYSIS, :SLEEP].include?(@type.status)
    turn_random
  end

  @still_timer -= 1 if @still_timer > 0

  if @still_timer == 0
    @movement_type = :WANDER
  end
end

def find_enemy_movement
  return if sleeping?
  metadata = GameData::MapMetadata.try_get($game_map.map_id)
  return if metadata.base_map

  $game_temp.preventspawns = true

  @target2 = getRandomOverworldHostilePokemon if @target2.nil?

  unless @target2.nil?
    if self.move_with_maps(@target2.map_id, @target2.x, @target2.y)
      loops = 0

      if [self.x, self.y] != [@target2.x, @target2.y]
        while !within_one_tile?(
          self.x, self.y, @target2.x, @target2.y
        )
          Input.update
          Graphics.update
          $scene.miniupdate

          loops += 1 unless self.moving?

          break if within_one_tile?(
            self.x, self.y, @target2.x, @target2.y
          )

          break if loops >= 60 && !self.moving?
        end

        if within_one_tile?(
          self.x, self.y, @target2.x, @target2.y
        )
          if @target2.is_a?(Game_PokeEvent)
            look_at_location(
              self.id,
              @target2.x,
              @target2.y
            )

            self.add_target(event_in_question, @target2)
            self.following = @target2
            self.movement_type = :FOLLOW

          elsif @target2.is_a?(Game_Player)
            # Player-specific behavior goes here.

          else
            self.move_toward_the_coordinate(
              @target2.x,
              @target2.y
            )
          end
        end
      end
    end

    if @attack_opportunity <= 0
      thefight = $PokemonGlobal.ov_combat
      distance = get_event_distance(@target2, 3)

      unless distance.nil?
        thefight.autobattle(self)
        @target2 = nil if @target2.pokemon.fainted?
      end
    else
      @attack_opportunity -= 1
    end
  end

  $game_temp.preventspawns = false

  @movement_type = :STILL
  @still_timer = 120
end

def search_movement
  return if sleeping?
  pokemonsearch(self)

  @movement_type = :STILL
  @still_timer = 120
end

def egg_movement
  self.walk_anime = false if egg?
  self.step_anime = false if egg?
end

def inbed_movement
  @movement_type = :WANDER if @pet_bed.nil?
  return unless @pet_bed
  if sleeping? || egg?
    self.step_anime = false
    self.walk_anime = false

    if sleeping?
      wake_chance = PBDayNight.isDay? ? 25 : 1
      time_now = pbGetTimeNow.to_i

      if rand(100) < wake_chance && (@started_sleeping_at.nil? || time_now - @started_sleeping_at >= @sleep_duration)
        wake_up
        $scene.spriteset.addUserAnimation(
          3, self.x, self.y, true, 1
        )
      end
    end

  elsif !get_pet_bed.breeding? && get_pet_bed.pokemon_in_bed?
    if rand(255) == 0 && @type.status == :NONE
      sleep_chance = PBDayNight.isNight? ? 25 : 1
      time_now = pbGetTimeNow.to_i
      rnd_amt = PBDayNight.isNight? ? 100 : 255

      if rand(rnd_amt) < sleep_chance && (@woke_up_at.nil? || time_now - @woke_up_at >= 1800)
        @type.status = :SLEEP
        @started_sleeping_at = time_now
		@sleep_duration = rand(1..8) * 3600
        @woke_up_at = nil
        $scene.spriteset.addUserAnimation(
          12, self.x, self.y, true, 1
        )
      else
        turn_random unless [:PARALYSIS, :SLEEP].include?(@type.status)
      end
    end

  elsif get_pet_bed.breeding? && get_pet_bed.pokemon_in_bed?
    # Breeding-specific behavior goes here.

  else
    turn_random if
      rand(255) == 0 &&
      ![:PARALYSIS, :SLEEP].include?(@type.status)
  end
end

def to_work_movement
  return if sleeping?
  if pokemon.stamina <= 0
   @movement_type = :MOVING_TO_BED 
   return 
  end
  if @pet_bed.nil?
   @movement_type = :WANDER 
   return
  end
  owner_pet_bed = get_pet_bed
  return @movement_type = :WANDER if owner_pet_bed.nil?
  return @movement_type = :MOVING_TO_BED if owner_pet_bed.work_event.nil?

  work_x = owner_pet_bed.work_x
  work_y = owner_pet_bed.work_y
  work_spots = [
    [work_x + 1, work_y],
    [work_x - 1, work_y],
    [work_x, work_y + 1],
    [work_x, work_y - 1]
  ]
  work_spot = work_spots.find do |x, y|
    next false unless $game_map.passablenoevents?(x, y, 0)
    event_id = $game_map.check_event(x, y)
	event = $game_map.events[event_id]
	!event || event == self || !(event.is_a?(Game_PokeEventA) || event.is_a?(Game_OVEvent))
  end

  return @movement_type = :MOVING_TO_BED if work_spot.nil?
#  puts work_spot.inspect
  if [self.x, self.y] == work_spot
    @movement_type = :WORKING
  else
    move_toward_the_coordinate(work_spot[0], work_spot[1])
  end
end 

def to_bed_movement
  return if sleeping?
	@started_working_at = nil if !@started_working_at.nil?
  @movement_type = :WANDER if @pet_bed.nil?
  return unless @pet_bed
   owner_pet_bed = get_pet_bed
  if owner_pet_bed.x == self.x && owner_pet_bed.y == self.y
    @movement_type = :INBED
  else 
    move_toward_the_coordinate(owner_pet_bed.x, owner_pet_bed.y)
  end 
end 

def work_event
  owner_pet_bed = get_pet_bed
  return nil unless owner_pet_bed
  owner_pet_bed.work_event
end 

def working_movement
  @movement_type = :WANDER if @pet_bed.nil?
  return unless @pet_bed

  unless sleeping?
    owner_pet_bed = get_pet_bed
    return @movement_type = :WANDER if owner_pet_bed.nil?
    return @movement_type = :MOVING_TO_BED if owner_pet_bed.work_event.nil?
	
	@started_working_at = pbGetTimeNow.to_i if @started_working_at.nil?
    pbTurnTowardEvent(self, owner_pet_bed.work_event)
  else
    self.step_anime = false
    self.walk_anime = false
  end
end

 
 end 
end 

class Game_PokeEventA < Game_Event
  attr_accessor :event
  attr_accessor :type
  attr_accessor :x
  attr_accessor :y
  attr_accessor :visible
  attr_accessor :invisible_after_transfer
  attr_accessor :trigger
  attr_accessor :movement_timer
  attr_accessor :movement_type
  attr_accessor :still_timer
  attr_accessor :random_attacking
  attr_accessor :attack_mode
  attr_accessor :autobattle
  attr_accessor :playercoords
  attr_accessor :steps_taken
  attr_accessor :fighting
  attr_accessor :targets
  attr_accessor :following
  attr_accessor :sending_handshake
  attr_accessor :recieving_handshake
  attr_accessor :making_an_egg
  attr_accessor :attack_opportunity
  attr_accessor :autoattack_opportunity
  attr_accessor :attack_cooldown
  attr_accessor :fucking_timer
  attr_accessor :currently_moving
  attr_accessor :last_attacked
  attr_accessor :youarealreadydead # contains the map_id
  attr_accessor :pathing 
  attr_accessor :spawn_map_id
  attr_accessor :map_id # contains the map_id
  attr_writer :map # contains the original map 
  attr_reader :counter 
  attr_accessor :last_attacked_by
  attr_accessor :pet_bed 
  attr_accessor :started_working_at  
  attr_accessor :started_sleeping_at  
  attr_accessor :woke_up_at  
 
  include FollowerMovement
  
  def initialize(type, map_id, event, map=nil)
   super(map_id, event, map)
   @type  = type
   @visible                  = true
   @invisible_after_transfer = false
   @spawn_map_id = map_id 
	@event = event
	@steps_taken  = 0
	@movement_timer = 0
	@movement_type = :WANDER
	@still_timer = 0
	@random_attacking = true
	@last_attacked = false
	@attack_mode = :COMMAND
	@autobattle = false
	@playercoords = [0,0]
	@fighting = nil
	@pet_bed = nil
	@sending_handshake = []
	@recieving_handshake = []
	@targets = {}
	@making_an_egg = false
	@fucking_timer = 0
	@attack_opportunity = 0
	@autoattack_opportunity = 0
	@currently_moving = false
	@attacking = false
	@youarealreadydead  = false
	@target = nil
	@target2 = nil
	@pathing = []
	@counter = my_sight_line
	if @type.is_a?(Pokemon)
	@random_attacking = @type.random_attacking if !@type.random_attacking.nil?
	@attack_mode = @type.attack_mode if !@type.attack_mode.nil?
	@autobattle = @type.autobattle if !@type.autobattle.nil?
	@type.associatedevent=@id if @type.associatedevent.nil? || @type.associatedevent!= @id
	end
	@last_attacked_by = nil
	  if sleeping? || egg?
	    self.step_anime = false 
        self.walk_anime = false
	  end 
    
	@started_working_at = nil
	@started_sleeping_at = nil
	@woke_up_at = nil
  end
  
  def use_reaction_move(target, move)
	selected_pkmn.pokemon.attacking=true
	selected_pkmn.autoattack_opportunity += 90
    result = pbOverworldCombat.perform_player_attack(
      self,
      move,
      nil,
	  true
    )
	selected_pkmn.pokemon.attacking=false
	return result 
  end
  
  def wake_up
        @type.status = :NONE
        @woke_up_at = pbGetTimeNow.to_i
		@started_sleeping_at = nil 
  
  end 
  
  def counter
   @counter = my_sight_line if @counter.nil?
   return @counter
  end 
def my_sight_line
     counter_match = @event.name.match(/surrounding\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match

  return number.to_i if number
  return 3 
end

def sleeping?
  @type.status == :SLEEP
end 
def egg?
  @type.egg?
end 
def get_pet_bed_event
 $game_map.events[@pet_bed]
end 
def get_pet_bed
 bed_event = get_pet_bed_event
 return nil if bed_event.nil?
 bed_event.type.internal_data
end 


def movement_logic
   return if pokemon.fainted?
   update_confused
   update_combat
   return if movement_blocked?
   perform_movement
end 
alias pkmnmovement movement_logic
 
 def in_battle
   pbOverworldCombat.in_battle?(self) && in_attacking_movement_state?
 end 
 
 def update_confused
    confused = self.pokemon.effects[PBEffects::Confusion] > 0
    if confused
     self.pokemon.effects[PBEffects::Confusion] = [self.pokemon.effects[PBEffects::Confusion] - 1, 0].max
	 sideDisplay("#{self.pokemon.name} snapped out of its confusion.")  if self.pokemon.effects[PBEffects::Confusion]==0
	end 

 
 end 
def update_combat

  if @autoattack_opportunity <= 0 && @attack_opportunity <= 0 && in_battle

    unless @attacking
      @autoattack_opportunity += 30
      @attacking = true

      $PokemonGlobal.ov_combat.autobattle(self)

      @attacking = false
    end

  elsif @attack_opportunity <= 0
    @autoattack_opportunity -= 1 if @autoattack_opportunity > 0
    decrease_attack_opportunity(1) if @attack_opportunity > 0

  else
    decrease_attack_opportunity(1) if @attack_opportunity > 0
  end
end
def movement_blocked?
  $game_temp.interactingwithpokemon == true &&
    $game_temp.auto_move == true
end
def confused?
  pokemon.effects[PBEffects::Confusion] > 0
end
def update_movement_animation
  return if sleeping? || egg?

  self.step_anime = true
  self.walk_anime = true
end



def update_movement_animation
  unless sleeping? || egg?
    self.step_anime = true
    self.walk_anime = true
  end
end


 def update
	@type.deselecttimer-=1 if @type.deselecttimer>0
	pokemon.associatedevent=@id if pokemon.associatedevent.nil? || pokemon.associatedevent!= @id
	pbRemoveFollowerPokemon(@id) if $game_temp.following_ov_pokemon[@id] && $game_temp.following_ov_pokemon[@id][1]==@type && @movement_type != :FOLLOW 
	$game_temp.following_ov_pokemon[@id]=[@id,@type,self] if !$game_temp.following_ov_pokemon[@id] && @movement_type == :FOLLOW 
	
    @following = nil if @movement_type != :FOLLOW && @movement_type != :MOVEBEHINDPLAYER
	if @following && @movement_type == :FOLLOW 
     self.move_frequency=@following.move_frequency
     self.move_speed=@following.move_speed+0.25 
	
	elsif @movement_type != :FOLLOW 
     self.move_speed=3 
     self.move_frequency=4
	
	end
    super 
 end 


  def get_event_distance(event,amt=3)
    distance = (self.x - event.x).abs + (self.y - event.y).abs
    return distance if distance<=amt
	return nil
  end

def get_target
   surrounding = self.pbSurroundingEvents
	    active = []
	   if !surrounding.nil?
	    surrounding.each do |i|
         if @targets.keys.include?(i)
		     theevent = $game_map.events[i]
            if get_events_in_range(self,theevent,3)
			    rate = $PokemonGlobal.ov_combat.getRate2(self,theevent)
				 active << [theevent,rate]
			   end
		   end
	    end
       rate2= active.max_by { |item| item[1] }
	     if !rate2.nil?
       highest_rate = rate2[1]
       highest_rate_items = active.select { |item| item[1] == highest_rate }
        ret = highest_rate_items[rand(highest_rate_items.length)][0]
	     end
	   end
   # ret = self.pbSurroundingEvent if ret.nil?
  return ret 
end



  def removeThisEventfromMap
	if @type.inworld && @type.fainted?
	  sideDisplay(_INTL("{1} has fainted!",  @type.name))
	  @type.changeHappiness("faintbad",@type)
      @type.changeLoyalty("faintbad",@type)
	  pbSEPlay("faint")
	end
	pbOverworldCombat.removeAlly(@id)
	$selection_arrows.remove_sprite("Arrow#{@id}#{@type.name}")
	$hud.removeaChargeBar(@id)
    @type.inworld=false
	@pet_bed = nil
	@type.associatedevent = nil
	pbDeselectThisPokemon(@type)
	if $DynamicEvents.allied_mobs.has_key?(@id) && $DynamicEvents.allied_mobs[@id]==self
	    pbRemoveParticleEffectfromEvent(self)
		pbRemoveLightEffectfromThisEvent(self)
	  	$ExtraEvents.removethisEvent(:SPECIAL,@id,map.map_id)
        $DynamicEvents.allied_mobs.delete(@id)
	    $DynamicEvents.update!
	end 
   end
  


  def increase_steps
    super
    @steps_taken  += 1
  end



  
  def type=(value)
    @type = value
  end
  
  def last_attacked
   @last_attacked = false if @last_attacked.nil?
   return @last_attacked
  end 
  
   def attack_cooldowns
     return [@attack_opportunity, @autoattack_opportunity]
   end


  def add_target(event_id,object)
    return if event_id.nil?
    return if object.nil?
    if @targets[event_id]
	  if @targets[event_id]!=object
	    @targets[event_id]=object
	  end
    else
	    @targets[event_id]=object
	 end
	 $scene.spriteset.addUserAnimation(VisibleEncounterSettings::AGG_ANIMATIONS[0],self.x,self.y,true,1) if object.respond_to?(:pokemon)
  end
  
  
  def remove_target(event_id)
    return if event_id.nil?
    return if object.nil?
    if @targets[event_id]
	  @targets[event_id].delete
	 end
  end
  
  def pokemon
   return @type if @type.is_a?(Pokemon)
   return nil
  end
  
  
    def pbFacingEvent(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
	events = $game_map.events.values + $DynamicEvents.events_for_map
    events.each do |event|
      next if !event.at_coordinate?(new_x, new_y)
      next if event.jumping? || event.over_trigger?
      return event
    end
    # If the tile in front is a counter, check one tile beyond that for events
    if $game_map.counter?(new_x, new_y)
      new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
      new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
	events = $game_map.events.values + $DynamicEvents.events_for_map
    events.each do |event|
        next if !event.at_coordinate?(new_x, new_y)
        next if event.jumping? || event.over_trigger?
        return event
      end
    end
    return nil
  end
  # self.map_id bzw. @map_id
  
   def stages
    return @type.stages
   end
   def effects
    return @type.effects
   end
  
  def decrease_attack_opportunity(amt)
  
    @attack_opportunity-=amt if @attack_opportunity>0
	if @attack_opportunity<=0
    @attack_opportunity=0 
	#pbSEPlay("Vs flash")
	@type.play_cry
	sideDisplay("#{@type.name} can attack again.")
	end
  
  end













  def pbTriggerOverworldMon(user=$game_temp.current_pkmn_controlled)
    return if $game_system.map_interpreter.running?
    # All event loops
      event = user.pbFacingEvent
	  return false if event.nil?
      return false if !event.name.include?(".inter")
      return false if event.jumping?
	  $game_temp.pokemon_interacting=true
      event.start
	  return true
   return false
  end

  def visible?
    return @visible && !@invisible_after_transfer
  end


  def move_through(direction)
    old_through = @through
    @through = true
    case direction
    when 2 then move_down
    when 4 then move_left
    when 6 then move_right
    when 8 then move_up
    end
    @through = old_through
  end

  def move_fancy(direction)
    delta_x = (direction == 6) ? 1 : (direction == 4) ? -1 : 0
    delta_y = (direction == 2) ? 1 : (direction == 8) ? -1 : 0
    new_x = self.x + delta_x
    new_y = self.y + delta_y
    # Move if new position is the player's, or the new position is passable,
    # or self's current position is not passable
    if ($game_player.x == new_x && $game_player.y == new_y) ||
       location_passable?(new_x, new_y, 10 - direction) ||
       !location_passable?(self.x, self.y, direction)
      move_through(direction)
    end
  end

  def jump_fancy(direction, leader)
    delta_x = (direction == 6) ? 2 : (direction == 4) ? -2 : 0
    delta_y = (direction == 2) ? 2 : (direction == 8) ? -2 : 0
    half_delta_x = delta_x / 2
    half_delta_y = delta_y / 2
    if location_passable?(self.x + half_delta_x, self.y + half_delta_y, 10 - direction)
      # Can walk over the middle tile normally; just take two steps
      move_fancy(direction)
      move_fancy(direction)
    elsif location_passable?(self.x + delta_x, self.y + delta_y, 10 - direction)
      # Can't walk over the middle tile, but can walk over the end tile; jump over
      if location_passable?(self.x, self.y, direction)
        if leader.jumping?
          @jump_speed_real = leader.jump_speed_real
        else
          # This is doubled because self has to jump 2 tiles in the time it
          # takes the leader to move one tile.
          @jump_speed_real = leader.move_speed_real * 2
        end
        jump(delta_x, delta_y)
      else
        # self's current tile isn't passable; just take two steps ignoring passability
        move_through(direction)
        move_through(direction)
      end
    end
  end

  def fancy_moveto(new_x, new_y, leader=nil)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy(2)
    elsif self.x - new_x == 2 && self.y == new_y && !leader.nil?
      jump_fancy(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y && !leader.nil?
      jump_fancy(6, leader)
    elsif self.x == new_x && self.y - new_y == 2 && !leader.nil?
      jump_fancy(8, leader)
    elsif self.x == new_x && self.y - new_y == -2 && !leader.nil?
      jump_fancy(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end

  #=============================================================================



  def turn_towards_event(event)
    pbTurnTowardEvent(self, event)
  end


def follow_leader(leader, instant = false, leaderIsTrueLeader = true)
    maps_connected = $map_factory.areConnected?(leader.map.map_id, self.map.map_id)
    target = nil
    # Get the target tile that self wants to move to
    if maps_connected
      behind_direction = 10 - leader.direction
      target = $map_factory.getFacingTile(behind_direction, leader)
      if target && $map_factory.getTerrainTag(target[0], target[1], target[2]).ledge
        # Get the tile above the ledge (where the leader jumped from)
        target = $map_factory.getFacingTileFromPos(target[0], target[1], target[2], behind_direction)
      end
      target = [leader.map.map_id, leader.x, leader.y] if !target
    else
      # Map transfer to an unconnected map
      target = [leader.map.map_id, leader.x, leader.y]
    end
    # Move self to the target
    if self.map.map_id != target[0]
      vector = $map_factory.getRelativePos(target[0], 0, 0, self.map.map_id, @x, @y)
      @map = $map_factory.getMap(target[0])
      # NOTE: Can't use moveto because vector is outside the boundaries of the
      #       map, and moveto doesn't allow setting invalid coordinates.
      @x = vector[0]
      @y = vector[1]
      @real_x = @x * Game_Map::REAL_RES_X
      @real_y = @y * Game_Map::REAL_RES_Y
    end
 

    if instant || !maps_connected
      moveto(target[1], target[2])
    else
      fancy_moveto(target[1], target[2], leader)
    end
  end

def move_with_maps(mapA,x,y,dir=nil)
    if self.x!=x || self.y!=y
      target = [mapA, x, y]
    if self.map.map_id != target[0]
      vector = $map_factory.getRelativePos(target[0], 0, 0, self.map.map_id, @x, @y)
      @map = $map_factory.getMap(target[0])
      # NOTE: Can't use moveto because vector is outside the boundaries of the
      #       map, and moveto doesn't allow setting invalid coordinates.
      @x = vector[0]
      @y = vector[1]
      @real_x = @x * Game_Map::REAL_RES_X
      @real_y = @y * Game_Map::REAL_RES_Y
    end
    if move_to_location(self,target[1], target[2])
	end
   # if !pbMoveTowardCoordinates(self,target[1],target[2])
	#  fancy_moveto(target[1], target[2])
	#end
	else
	if !dir.nil?
	 if dir!=self.direction
	   turn_generic(dir)
	 end
	end
    end
	return true
end


  def update_move
    was_jumping = jumping?
    super
    if was_jumping && !jumping?
      spriteset = $scene.spriteset(map_id)
      spriteset&.addUserAnimation(Settings::DUST_ANIMATION_ID, self.x, self.y, true, 1)
    end
  end





  private


  def location_passable?(x, y, direction)
    this_map = self.map
    return false if !this_map || !this_map.valid?(x, y)
    return true if @through
    passed_tile_checks = false
    bit = (1 << ((direction / 2) - 1)) & 0x0f
    # Check all events for ones using tiles as graphics, and see if they're passable
    this_map.events.each_value do |event|
      next if event.tile_id < 0 || event.through || !event.at_coordinate?(x, y)
      tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[event.tile_id])
      next if tile_data.ignore_passability
      next if tile_data.bridge && $PokemonGlobal.bridge == 0
      return false if tile_data.ledge
      passage = this_map.passages[event.tile_id] || 0
      return false if passage & bit != 0
      passed_tile_checks = true if (tile_data.bridge && $PokemonGlobal.bridge > 0) ||
                                   (this_map.priorities[event.tile_id] || -1) == 0
      break if passed_tile_checks
    end
    # Check if tiles at (x, y) allow passage for followe
    if !passed_tile_checks
      [2, 1, 0].each do |i|
        tile_id = this_map.data[x, y, i] || 0
        next if tile_id == 0
        tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[tile_id])
        next if tile_data.ignore_passability
        next if tile_data.bridge && $PokemonGlobal.bridge == 0
        return false if tile_data.ledge
        passage = this_map.passages[tile_id] || 0
        return false if passage & bit != 0
        break if tile_data.bridge && $PokemonGlobal.bridge > 0
        break if (this_map.priorities[tile_id] || -1) == 0
      end
    end
    # Check all events on the map to see if any are in the way
    this_map.events.each_value do |event|
      next if !event.at_coordinate?(x, y)
      return false if !event.through && event.character_name != ""
    end
    return true
  end



end



class Game_Map

  def generatePokemon(x,y,pokemon)
    key_id = $DynamicEvents.generatePokemon(x,y,pokemon)
	return key_id 
    mapId = $game_map.map_id
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    
	$ExtraEvents.objects = {} if $ExtraEvents.objects.nil?
	amtofkeysinroom = 0
    key_id = ((@events.keys.max)|| -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    event.name = "PlayerPkmn"
	
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    shadow = pokemon.shadowPokemon?
	egg = pokemon.egg?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    graphic_shadow = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")
	fname = "Followers/egg" if egg 

    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = 3
    event.pages[0].move_frequency = 4
    event.pages[0].move_type = 3
    event.pages[0].step_anime = true
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = false #Sets movement type.
    event.pages[0].always_on_top = true if pokemon.types.include?(:FLYING)
    event.pages[0].through = true if pokemon.types.include?(:FLYING)
    event.pages[0].trigger = 0 #Action Button    event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
    event.pages[0].move_route.list[0].code = 52879
    event.pages[0].move_route.list[0].parameters  = ["self.pkmnmovement"]
    #--- event commands of the event -------------------------------------
    #Compiler::push_script(event.pages[0].list,sprintf("self.pkmnmovement"))
    #Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
	
    gameEvent = Game_PokeEventA.new(pokemon, mapId, event, self)
    gameEvent.id = key_id
    gameEvent.type = pokemon
	#if $game_temp.preventspawns==false
    $ExtraEvents.special[[mapId,key_id]] = StoredEvent.new(mapId,event,pokemon)
	 $ExtraEvents.special[[mapId,key_id]].eventdata = gameEvent
	 @events[key_id] = gameEvent
	 
    pokemon.associatedevent = key_id
	pokemon.in_world = true 
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	pbAddParticleEffecttoEvent("soot") if pokemon.shadowPokemon?
	#end
  end

  def passablenoevents?(x, y, d, self_event = nil)
    return false if !valid?(x, y)
    [2, 1, 0].each do |i|
      tile_id = data[x, y, i]
      terrain = GameData::TerrainTag.try_get(@terrain_tags[tile_id])
      # If already on water, only allow movement to another water tile
      if self_event && terrain.can_surf_freely
        [2, 1, 0].each do |j|
          facing_tile_id = data[newx, newy, j]
          next if facing_tile_id == 0
          return false if facing_tile_id.nil?
          facing_terrain = GameData::TerrainTag.try_get(@terrain_tags[facing_tile_id])
          if facing_terrain.id != :None && !facing_terrain.ignore_passability
            return facing_terrain.can_surf_freely
          end
        end
        return false
      # Can't walk onto ice
      elsif terrain.ice
        return false
      elsif self_event && self_event.x == x && self_event.y == y
        # Can't walk onto ledges
        [2, 1, 0].each do |j|
          facing_tile_id = data[newx, newy, j]
          next if facing_tile_id == 0
          return false if facing_tile_id.nil?
          facing_terrain = GameData::TerrainTag.try_get(@terrain_tags[facing_tile_id])
          return false if facing_terrain.ledge
          break if facing_terrain.id != :None && !facing_terrain.ignore_passability
        end
      end
      next if terrain&.ignore_passability
      next if tile_id == 0
      # Regular passability checks
      return false if @passages[tile_id] & 0x0f != 0
      return true if @priorities[tile_id] == 0
    end
    return true
  end

end




def get_events_in_range(eventa,eventb,distance)

	 sx = eventa.x + (eventa.width / 2.0) - (eventb.x + (eventb.width / 2.0))
    sy = eventa.y - (eventa.height / 2.0) - (eventb.y - (eventb.height / 2.0))
    return true if ( sx.abs <= distance || sy.abs  <= distance) 
	return false
end




def besidethis?(eventa,eventb)
return true if eventa.at_coordinate?(eventb.x+1,eventb.y)
return true if eventa.at_coordinate?(eventb.x-1,eventb.y)
return true if eventa.at_coordinate?(eventb.x,eventb.y+1)
return true if eventa.at_coordinate?(eventb.x,eventb.y-1)
return false
end


class Game_Event < Game_Character
  def cardinal?(event)
  dx = (self.x - event.x).abs
  dy = (self.y - event.y).abs
  dx + dy == 1

  end
  def pbGetSurroundingEvent(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter 
	events = $game_map.events.values + $DynamicEvents.events_for_map
    events.each do |event|
      next if !self.cardinal?(event)
      next if event.jumping? || event.over_trigger?
      return event
    end
    return nil
  end
  alias pbSurroundingEvent pbGetSurroundingEvent
  
  def pbSurroundingEvents(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter 
	surrounding = []
	events = $game_map.events.values + $DynamicEvents.events_for_map
    events.each do |event|
      next if !self.cardinal?(event)
      next if event.jumping? || event.over_trigger?
      surrounding << event.id
    end
	 return surrounding
  end

  def pbEventWithin(distance,ignoreInterpreter = false)
	theevents = []
    #return nil if $game_temp.preventspawns==false
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter 
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
	events = $game_map.events.values + $DynamicEvents.events_for_map
    events.each do |event|
	  next if event.name != "PlayerPkmn"
      next if get_events_in_range(self, event,distance)==false
	  theevents << event
    end
	if get_events_in_range(self, $game_player,distance)==true
	  theevents << $game_player
	  theevents << $game_player
	end
    uniqueevent = theevents[rand(theevents.length)]
    return uniqueevent
  end

  def update
    @to_update = should_update?(true)
    return if !@to_update
    @moveto_happened = false
    last_moving = moving?
    super
    if !moving? && last_moving
      $game_player.pbCheckEventTriggerFromDistance([2])
    end
    if @need_refresh
      @need_refresh = false
      refresh
    end
    check_event_trigger_auto
    if @interpreter
      unless @interpreter.running?
        @interpreter.setup(@list, @event.id, @map_id)
      end
      @interpreter.update
    end
  end
end

def pbPlacePokemon(x, y, pokemon)
  if pokemon.fainted?
   pokemon.in_world = false 
   return false 
  end 
  if !pbObjectIsPossible(x,y)
   pokemon.in_world = false 
   return false 
  end
  key_id = $DynamicEvents.generatePokemon(x,y,pokemon)
  event = $game_map.events[key_id]
  pokemon.in_world = true 
  return true
end

def toggle_in_world(pokemon)
  if pokemon.inworld==false
  pokemon.inworld=true
  else
  pokemon.inworld=false
  end
end

def refresh_overworld_pokemon_count
  count = 0

  $player.party.each do |pkmn|
    if pkmn.inworld && pkmn.associatedevent && $game_map.events[pkmn.associatedevent]
      count += 1
      next
    end

    pkmn.inworld = false
    pkmn.associatedevent = nil
  end

  count
end



def pbClosestHiddenItemPokemon(pokemon)
  result = []
  playerX = pokemon.x
  playerY = pokemon.y
	events = $game_map.events.values
    events.each do |event|
    next if !event.name[/hiddenitem/i]
    next if (playerX - event.x).abs >= 8
    next if (playerY - event.y).abs >= 6
    next if $game_self_switches[[$game_map.map_id, event.id, "A"]]
    result.push(event)
  end
  return nil if result.length == 0
  ret = nil
  retmin = 0
  result.each do |event|
    dist = (playerX - event.x).abs + (playerY - event.y).abs
    next if ret && retmin <= dist
    ret = event
    retmin = dist
  end
  return ret
end


def toggle_in_combat
  if $game_temp.in_combat==false
  $game_temp.in_combat=true
  else
  $game_temp.in_combat=false
  end
end


def getOverworldPokemonfromPokemon(pokemon)
 return pokemon.event
end

def getOverworldPokemonfromPokemonMap(pokemon, map)
 return pokemon.event
end




def getRandomOverworldHostilePokemon
  events = $DynamicEvents.hostile_mobs_for_map
  return events.sample
end
def getRandomOverworldAlliedPokemon
  events = $DynamicEvents.allied_mobs_for_map
  return events.sample
end

	
def pbReturnPokemon(key_id,message=false)
  event = $game_map.events[key_id]
  pkmn = event.pokemon
$game_temp.interactingwithpokemon=true
if message==true
if rand(2)==0
text= _INTL("#{pkmn.name}, come back!")
else
text= _INTL("#{pkmn.name}, return!")

end

		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
end


pbSEPlay("Battle recall")
pbRemoveFollowerPokemon(key_id) if $game_temp.following_ov_pokemon[key_id] && $game_temp.following_ov_pokemon[key_id][1]==pkmn
deletefromSISData(key_id,$game_map.map_id)
event.removeThisEventfromMap
$game_temp.preventspawns=false
$game_temp.interactingwithpokemon=false
$game_temp.pokemon_calling=false
end





module FollowingPkmn

  def self.talk2(poke)
    return false if !$game_temp || $game_temp.in_battle || $game_temp.in_menu
    facing = pbFacingTile
    if !$game_map.passable?(facing[1], facing[2], $game_player.direction, $game_player)
      $game_player.straighten
      EventHandlers.trigger(:on_player_interact)
      return false
    end
    first_pkmn = poke
    GameData::Species.play_cry(first_pkmn)
    random_val = rand(6)
    if $PokemonGlobal&.follower_hold_item
      EventHandlers.trigger_2(:following_pkmn_item, first_pkmn, random_val)
    else
      EventHandlers.trigger_2(:following_pkmn_talk, first_pkmn, random_val)
    end
    return true
  end

end



class Game_Character


  def move_type_custom
    return if jumping? || moving?
	  
	@move_route_index = 0 if @move_route.list[0].code ==52879 && @move_route_index > 0
    while @move_route_index < @move_route.list.size
      command = @move_route.list[@move_route_index]
      if command.code == 0
        if @move_route.repeat
          @move_route_index = 0
        else
          if @move_route_forcing
            @move_route_forcing = false
            @move_route       = @original_move_route
            @move_route_index = @original_move_route_index
            @original_move_route = nil
          end
          @stop_count = 0
        end
        return
      end

	  if command.code == 52879
		eval(command.parameters[0])
        @move_route_index = 0
	  end
      if command.code <= 14
        case command.code
        when 1  then move_down
        when 2  then move_left
        when 3  then move_right
        when 4  then move_up
        when 5  then move_lower_left
        when 6  then move_lower_right
        when 7  then move_upper_left
        when 8  then move_upper_right
        when 9  then move_random
        when 10 then move_toward_player
        when 11 then move_away_from_player
        when 12 then move_forward
        when 13 then move_backward
        when 14 then jump(command.parameters[0], command.parameters[1])
        end
        @move_route_index += 1 if @move_route.skippable || moving? || jumping?
        return
      end
      if command.code == 15   # Wait
        @wait_count = (command.parameters[0] * Graphics.frame_rate / 20) - 1
        @move_route_index += 1
        return
      end
      if command.code >= 16 && command.code <= 26
        case command.code
        when 16 then turn_down
        when 17 then turn_left
        when 18 then turn_right
        when 19 then turn_up
        when 20 then turn_right_90
        when 21 then turn_left_90
        when 22 then turn_180
        when 23 then turn_right_or_left_90
        when 24 then turn_random
        when 25 then turn_toward_player
        when 26 then turn_away_from_player
        end
        @move_route_index += 1
        return
      end
      if command.code >= 27
        case command.code
        when 27
          $game_switches[command.parameters[0]] = true
          self.map.need_refresh = true
        when 28
          $game_switches[command.parameters[0]] = false
          self.map.need_refresh = true
        when 29 then self.move_speed = command.parameters[0]
        when 30 then self.move_frequency = command.parameters[0]
        when 31 then @walk_anime = true
        when 32 then @walk_anime = false
        when 33 then @step_anime = true
        when 34 then @step_anime = false
        when 35 then @direction_fix = true
        when 36 then @direction_fix = false
        when 37 then @through = true
        when 38 then @through = false
        when 39
          old_always_on_top = @always_on_top
          @always_on_top = true
          calculate_bush_depth if @always_on_top != old_always_on_top
        when 40
          old_always_on_top = @always_on_top
          @always_on_top = false
          calculate_bush_depth if @always_on_top != old_always_on_top
        when 41
          old_tile_id = @tile_id
          @tile_id = 0
          @character_name = command.parameters[0]
          @character_hue = command.parameters[1]
          if @original_direction != command.parameters[2]
            @direction = command.parameters[2]
            @original_direction = @direction
            @prelock_direction = 0
          end
          if @original_pattern != command.parameters[3]
            @pattern = command.parameters[3]
            @original_pattern = @pattern
          end
          calculate_bush_depth if @tile_id != old_tile_id
        when 42 then @opacity = command.parameters[0]
        when 43 then @blend_type = command.parameters[0]
        when 44 then pbSEPlay(command.parameters[0])
        when 45 then eval(command.parameters[0])
        end
        @move_route_index += 1
      end
    end
  end







end


class Game_ObjectEvent < Game_PokeEventA
end
