


class Game_MineEvent < Game_Event
  attr_accessor :event
  attr_accessor :type

  def initialize(type, map_id, event, map=nil)
    super(map_id, event, map)
    @type  = type
  end
  def type=(value)
    @type = value
  end
  def type
    return @type
  end
end

 
  module MiningSpots
  
  class << self 
  
   def setup
     map_id = $game_map.map_id
	 minedata = GameData::Mine.try_get(map_id)
	 if minedata
       ensure_timer(minedata, map_id)
	   return if (pbGetTimeNow.to_i - $PokemonGlobal.mining_spot_timer[map_id]) < minedata.timer
	   max_spots = minedata.max_mining_spots
	   max_spots += 2 if $player.hiker?(10)
	   min_spots = minedata.min_mining_spots
	   minedata.area_amt.times do |i|
	      spots = ([[rand(minedata.roll_times) + 1, max_spots].min, min_spots].max).to_i
          base_x, base_y = minedata.offset_for(i)
          tile_distance = minedata.distance_for(i)
	      invalid_pos = []
	      tile = nil
	      spots.times do |j|
		    ore = get_ore(minedata)
			loop_amt = 0
            loop do
	         tile = [(base_x + rand(tile_distance)), (base_y + rand(tile_distance))]
		  	 next if !minedata.valid_tile?(tile[0], tile[1])
	         break if !invalid_pos.include?(tile)
			 break if loop_amt>50
			 loop_amt += 1
            end
            if tile
			  pbPlaceOre(tile[0], tile[1], ore) 
	          invalid_pos << tile 
			
			end 
		  end
	   end 
	    $PokemonGlobal.mining_spot_timer[map_id] = pbGetTimeNow.to_i + rand(-minedata.rnd_amt..minedata.rnd_amt)
	 end 
   end
 
  
  def ensure_timer(minedata, map_id)
   if $PokemonGlobal.mining_spot_timer[map_id].nil?
    $PokemonGlobal.mining_spot_timer[map_id] = pbGetTimeNow.to_i-minedata.timer
   end
 end 


  
  def get_ore(minedata)
	rarity = weighted_random([[:common_rewards, 70], [:uncommon_rewards, 25], [:rare_rewards, 5]])
    ores = minedata.send(rarity)
    if rarity == :rare_rewards && $player.real_collector?(15) && !ores.any? { |item, _| item == :STARPIECE }
      ores = ores + [[:STARPIECE, 10]]
    end
	return weighted_random(ores)
  end 

def weighted_random(weights)
  total = weights.sum { |_, weight| weight }
  roll = rand(total)

  weights.each do |item, weight|
    return item if roll < weight
    roll -= weight
  end
end
 end 
 end 
 
 
 

EventHandlers.add(:on_enter_map, :setup_mining_spots,
  proc { |_old_map_id|
    MiningSpots.setup
  }
)




def ov_mining(type)
 interp = pbMapInterpreter
 this_event = interp.get_self
 if $player.playerstamina>=8
 if hasPickaxe?
  image = nil
  sideDisplay(_INTL("You hack away at it with a Pickaxe."))
   amt = rand(4)+1
  case type 
   when :TUMBLEROCK
     image = "Legends_Tumblestone"
   when :STONE
     image = "Legends_Tumblestone"
   
   when :IRON2
     image = "Legends_Tumblestone"
   else
     image = "Legends_Tumblestone"
  end
   amt *= 2 if $player.hiker?(5) && rand(100) <= 25
  route = [PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 1,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 2,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 3,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 0]
  pbMoveRoute2(this_event,route)
  if !$bag.add(type,amt)
  pbMessage(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)
   pbSetEventTime

  end
 else 
  pbMessage(_INTL("While you don't have a pickaxe, you chip off a piece of the #{GameData::Item.get(type).name}."))
   amt = rand(2)+1
   amt *= 2 if $player.is_it_this_class?(:HIKER,false) && rand(100)<=25
  if !$bag.add(type,amt)
  pbMessage(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)
  pbSetEventTimeB

  end
 end
  decreaseStamina(8)
 end

end


def ov_mining2(type)
 interp = pbMapInterpreter
 this_event = interp.get_self
 puts "Disabled? #{this_event.disabled}"
 return if this_event.disabled
      current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
 if isSelectedThisItem?(:IRONPICKAXE)
  if $player.playerstamina>=8
    this_event.disabled = true
    ore_type = [:STONE,:TUMBLEROCK,:IRONORE,:GOLDORE,:SILVERORE,:COPPERORE,:COAL]
	if ore_type.include?(type)
     amt = rand(4)+1
	else
     amt = rand(2)+1
    end
   amt *= 2 if $player.hiker?(5) && rand(100) <= 25
   if !$bag.can_add?(type,amt)
  sideDisplay(_INTL("You don't have space!"))
  return
  end
  image = nil
  image = getObjectImage2(type)
  if type== :TUMBLEROCK
  route = [PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 1,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 2,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 3,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 0,
		  PBMoveRoute::Script, "get_own_event.removeThisEventfromMap"]
  else
  route = [PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 4, 0,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 6, 0,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 8, 0,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 0, 0,
		  PBMoveRoute::Script, "get_own_event.removeThisEventfromMap"]
  end 
  if pbMoveRoute2(this_event,route,true)
   current_selection.decrease_durability(1)
  if !$bag.add(type,amt)
  sideDisplay(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)

  end
  
  end 
  decreaseStamina(8)
 end
 end
end





if false
EventHandlers.add(:on_leave_map, :delete_mining_spots,
  proc { |new_map_id, new_map|
    maps = [71,76,15,18,31]
   next if !maps.include?($game_map.map_id)
  $DynamicEvents.delete_events_for_map
  }
)
end 

class PokemonGlobalMetadata
  attr_accessor :mining_spot_timer
  
  def mining_spot_timer
    @mining_spot_timer = {} if @mining_spot_timer.nil?
    return @mining_spot_timer
  end
  

end



class MiningGameSceneOld 

  def pbMain
    pbSEPlay("Mining ping")
    pbMessage(_INTL("Something pinged in the wall!\n{1} confirmed!", @items.length))
    loop do
      update
      Graphics.update
      Input.update
      next if @sprites["cursor"].isAnimating?
      # Check end conditions
	   hitsamt = 49
	   hitsamt += 10 if $player.hiker?(10)
      if @sprites["crack"].hits >= hitsamt
        @sprites["cursor"].visible = false
        pbSEPlay("Mining collapse")
        collapseviewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
        collapseviewport.z = 99999
        @sprites["collapse"] = BitmapSprite.new(Graphics.width, Graphics.height, collapseviewport)
        collapseTime = Graphics.frame_rate * 8 / 10
        collapseFraction = (Graphics.height.to_f / collapseTime).ceil
        (1..collapseTime).each do |i|
          @sprites["collapse"].bitmap.fill_rect(0, collapseFraction * (i - 1),
                                                Graphics.width, collapseFraction * i, Color.new(0, 0, 0))
          Graphics.update
        end
        pbMessage(_INTL("The wall collapsed!"))
        break
      end
      foundall = true
      @items.each do |i|
        foundall = false if !i[3]
        break if !foundall
      end
      if foundall
        @sprites["cursor"].visible = false
        pbWait(Graphics.frame_rate * 3 / 4)
        pbSEPlay("Mining found all")
        pbMessage(_INTL("Everything was dug up!"))
        break
      end
      # Input
      #mousetech
      if Input.mouse_in_window?
        if Input.trigger?(Input::MOUSERIGHT)
		  	  # mode: 0=pick, 1=hammer
		   if hasPickaxe? && hasHammer?
              pbSEPlay("Mining tool change")
              newmode = (@sprites["cursor"].mode + 1) % 2
              @sprites["cursor"].mode = newmode
              @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
              @sprites["tool"].y = 254 - (144 * newmode)
		   end
        end
        if Input.mouse_x.between?(0+$PokemonSystem.screenposx,13*32+$PokemonSystem.screenposx) && Input.mouse_y.between?(64+$PokemonSystem.screenposy,64+10*32+$PokemonSystem.screenposy) #Mouse is on board
          x = Input.mouse_x/32
          y = (Input.mouse_y-64)/32
          newpos = x + y*13
          @sprites["cursor"].position = newpos
		 if hasPickaxe? 
		 pick = GameData::Item.get(getPickaxe)
		 name = pick.name
		 #pick.decreaseDurability(1)
		 if !hasPickaxe?
		   pbMessage(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=1
		 end
		end
		if hasHammer?
		 ham = GameData::Item.get(getHammer)
		 name = ham.name
		 #ham.decreaseDurability(1)
		 if !hasHammer?
		   pbMessage(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=0
		 end
		end
		if $PokemonSystem.survivalmode == 0 
          case $player.playerstamina
           when 0
             $player.playersleep -= 10
			 if $player.playersaturation>0
               $player.playersaturation -= 10 #take from saturation
			 else
               $player.playerfood -= 7#take from hunger
               $player.playerwater -= 7#take from drinking
			 end
             if $player.playerfood==0
			    $player.playerhealth-10
			 end
             if $player.playerwater==0
			    $player.playerhealth-10
			 end
          else
             $player.playerstamina -= 1
          end
        end
        break if $player.playerhealth==0
		
		pbMessage(_INTL("You don't have either a Hammer or a Pickaxe!")) if !hasPickaxe? && !hasHammer?
        break if !hasPickaxe? && !hasHammer?
          pbHit if Input.trigger?(Input::MOUSELEFT)
        elsif Input.mouse_x.between?(428+$PokemonSystem.screenposx,508+$PokemonSystem.screenposy) #mouse is by tool icons
          if Input.mouse_y.between?(98+$PokemonSystem.screenposy,216+$PokemonSystem.screenposy) #mouse is by hammer
            if Input.trigger?(Input::MOUSELEFT) && hasHammer?
              pbSEPlay("Mining tool change")
              newmode = 1
              @sprites["cursor"].mode = newmode
              @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
              @sprites["tool"].y = 254 - (144 * newmode)
            end
          elsif Input.mouse_y.between?(242+$PokemonSystem.screenposy,360+$PokemonSystem.screenposy) #mouse is by pick
            if Input.trigger?(Input::MOUSELEFT) && hasPickaxe?
              pbSEPlay("Mining tool change")
              newmode = 0
              @sprites["cursor"].mode = newmode
              @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
              @sprites["tool"].y = 254 - (144 * newmode)
            end
          end
        end
      elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
        if @sprites["cursor"].position >= 13
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position -= 13
        end
      elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
        if @sprites["cursor"].position < (13 * (10 - 1))
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position += 13
        end
      elsif Input.trigger?(Input::LEFT) || Input.repeat?(Input::LEFT)
        if @sprites["cursor"].position % 13 > 0
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position -= 1
        end
      elsif Input.trigger?(Input::RIGHT) || Input.repeat?(Input::RIGHT)
        if @sprites["cursor"].position % 13 < (13 - 1)
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position += 1
        end
      elsif Input.trigger?(Input::ACTION)   # Change tool mode
		   if hasPickaxe? && hasHammer?
        pbSEPlay("Mining tool change")
        newmode = (@sprites["cursor"].mode + 1) % 2
        @sprites["cursor"].mode = newmode
        @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
        @sprites["tool"].y = 254 - (144 * newmode)
		   end
      elsif Input.trigger?(Input::USE) || ( !(Input.mouse_x.between?(0+$PokemonSystem.screenposx,13*32+$PokemonSystem.screenposx) && Input.mouse_y.between?(64+$PokemonSystem.screenposy,64+10*32+$PokemonSystem.screenposy)) && Input.trigger?(Input::MOUSELEFT) )   # Hit
	  # mode: 0=pick, 1=hammer
		if hasPickaxe? 
		 pick = GameData::Item.get(getPickaxe)
		 name = pick.name
		 #pick.decreaseDurability(1)
		 if !hasPickaxe?
		   sideDisplay(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=1
		 end
		end
		if hasHammer?
		 ham = GameData::Item.get(getHammer)
		 name = ham.name
		 #ham.decreaseDurability(1)
		 if !hasHammer?
		   sideDisplay(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=0
		 end
		end
		if $PokemonSystem.survivalmode == 0 
          case $player.playerstamina
           when 0
             $player.playersleep -= 10
			 if $player.playersaturation>0
               $player.playersaturation -= 10 #take from saturation
			 else
               $player.playerfood -= 7#take from hunger
               $player.playerwater -= 7#take from drinking
			 end
             if $player.playerfood==0
			    $player.playerhealth-10
			 end
             if $player.playerwater==0
			    $player.playerhealth-10
			 end
          else
             $player.playerstamina -= 1
          end
        end
        break if $player.playerhealth==0
		
		pbMessage(_INTL("You don't have either a Hammer or a Pickaxe!")) if !hasPickaxe? && !hasHammer?
        break if !hasPickaxe? && !hasHammer?
        pbHit
      elsif Input.trigger?(Input::BACK)   # Quit
        break if pbConfirmMessage(_INTL("Are you sure you want to give up?"))
      end
    end
    pbGiveItems
  end

end 
