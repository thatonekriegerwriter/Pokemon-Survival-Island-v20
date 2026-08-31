#===============================================================================
#                             **  Settings here! **
#
# RANGE sets the... range of detection! If it is set to 0 it will take the
# value x from 'Trainer(x)' (Event's name!)
#
# BAR_OPACITY is used to set the transparency to the focus bars.
#
# SELF_SWITCH is used to identify those trainers you already fought against of.
#
# BAR_HEIGHT sets the the focus bars' height value.
#
# BAR_GRAPHIC allows you to load your own graphic from 'Graphics/Pictures/'
# if it is set to "" or nil, the system will create them for you. If not, then
# the BAR_HEIGHT will be ignored as well as the BAR_OPACITY constant.
#===============================================================================
module TrainerSensor
  RANGE       = 3
  BAR_OPACITY = 255/2
  SELF_SWITCH = "A"
  BAR_HEIGHT  = Graphics.height/6
  BAR_GRAPHIC = ""
  # If you use EBS, a good option is set this value to "EBS/newBattleMessageBox"
end
  

#===============================================================================
# **  
#===============================================================================
class TensionBars
  attr_accessor :triggered
  attr_accessor :top
  attr_reader :viewport
  
  def initialize(viewport)
     @viewport = viewport 
     create
  end
  
  def create
     @top = Sprite.new(@viewport)
     @top.z = 0
     @bottom = Sprite.new(@viewport)
     @bottom.z = @top.z
     @triggered = false
     @custom_graphic = false
     @created = false
    if ["", nil].include?(TrainerSensor::BAR_GRAPHIC)
      @top.bitmap = Bitmap.new(Graphics.width, TrainerSensor::BAR_HEIGHT)
      @top.bitmap.fill_rect(0,0,@top.bitmap.width,@top.bitmap.height,
        Color.new(-255,-255,-255, TrainerSensor::BAR_OPACITY))
    else
      @top.bitmap = BitmapCache.load_bitmap("Graphics/Pictures/#{TrainerSensor::BAR_GRAPHIC}")
      @top.ox = @top.bitmap.width/2
      @top.x = Graphics.width/2
      @top.y = -@top.bitmap.height
      @top.mirror = true
      @top.angle = 180
      @custom_graphic = true
    end
    @top.oy = @top.bitmap.height
    @bottom.bitmap = @top.bitmap.clone
    if @custom_graphic
      @bottom.ox = @bottom.bitmap.width/2
      @bottom.x = Graphics.width/2
    end
    @bottom.y = Graphics.height
    @created = true
  end
  
  def triggered?
    @triggered
  end
  def disposed?
    @top.disposed? && @bottom.disposed?
  end  
  def show
    @triggered = true
  end
  
  def hide
    @triggered = false
  end
  
  def update
    return if !@created
	create if disposed?
    if @triggered
      if @top.y < (@custom_graphic ? 0 : (TrainerSensor::BAR_HEIGHT - 6) )
        @top.y += 6
        @bottom.y -= 6
      end
    else
      if @top.y > (@custom_graphic ? -@top.bitmap.height : 0 )
        @top.y -= 6
        @bottom.y += 6
      end    
    end
  end
  
  # Function to check if the player is in an event's range
  def inRange?(event, event2, distance)
    distance = TrainerSensor::RANGE if distance.nil?
    return false if distance<=0
    rad = (Math.hypot((event.x - $game_player.x),(event.y - $game_player.y))).abs
    return true if (rad <= distance)
    return false
  end
end

# Change it to Events.StepTaken if you want this to scan the events on each step
# the player gives.
EventHandlers.add(:on_step_taken, :tension_screen,
  proc { |mevent|
    next if !$scene.is_a?(Scene_Map)
	 next if $PokemonSystem.tension_screen==1
    #next if mevent != $game_player && $game_temp.current_pkmn_controlled==false && !TrainerSensor.triggered?
    #next if $game_temp.current_pkmn_controlled!=false && mevent != $game_temp.current_pkmn_controlled && !TrainerSensor.triggered?
	event2 = $game_player if $game_temp.current_pkmn_controlled==false
	event2 = $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled!=false
	
	events = $game_map.events.values + $DynamicEvents.events_for_map
  for event in events
    if (event.name[/^Trainer\((\d+)\)$/] && event.isOff?(TrainerSensor::SELF_SWITCH)) || event.is_a?(Game_PokeEvent)
      distance=$~[1].to_i if !event.is_a?(Game_PokeEvent)
      distance=event.counter.to_i if event.is_a?(Game_PokeEvent)
      if $tensionbars.inRange?(event, event2, distance)
        $tensionbars.show()
        break
      else
        $tensionbars.hide() if $tensionbars.triggered?
      end
    else
      $tensionbars.hide() if $tensionbars.triggered?
    end

  end
}

)
class PokemonSystem
  attr_accessor :tension_screen
  
  def tension_screen
   @tension_screen = 1 if @tension_screen.nil?
    return @tension_screen
  end
end