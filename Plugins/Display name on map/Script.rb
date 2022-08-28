#-------------------------------------------------------------------------------
# Display name on map
# Credit: bo4p5687
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Set name in comment of event. Write like this:
#
# Display name on map
# Kai
#
# -> It will display Kai on map
#
# Remember:
# 	Just add 2 lines in 1 comment, you can see examples in 'Route 3'
# 	Events: Particle effect
#
# Set switch true to display name.
# Switch's number set in 'module DisplayNameOnMap', 'SWITCH = '
#-------------------------------------------------------------------------------
# Fix event comment
def pbEventCommentInput(*args)
  parameters = []
  list = *args[0].list   # Event or event page
  elements = *args[1]    # Number of elements
  trigger = *args[2]     # Trigger
  return nil if list == nil
  return nil unless list.is_a?(Array)
  for item in list
    next unless item.code == 108 || item.code == 408
    if item.parameters[0] == trigger[0]
      start = list.index(item) + 1
      finish = start + elements[0]
      for id in start...finish
        next if !list[id]
        parameters.push(list[id].parameters[0])
      end
      return parameters
    end
  end
  return nil
end
#-------------------------------------------------------------------------------
# Store Name
#-------------------------------------------------------------------------------
module DisplayNameOnMap
	# Set game switch
	SWITCH = 100

	# Set event, don't touch it
	def self.set(event)
		name = pbEventCommentInput(event, 1, "Display name on map")
		return nil if name.nil?
		name = name[0]
		return nil if name.nil?
		return name
	end

end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class DisplayName
  def initialize(viewport, event, z)
    @sprites = {}
    @viewport = viewport
    @z = z
    # Set event
    @event = event
    @store = DisplayNameOnMap.set(@event) if @event.is_a?(Game_Event)
  end

	def show_name?
		return false unless $game_switches[DisplayNameOnMap::SWITCH]
		return true if @event.is_a?(Game_Player)
		character = @event.character_name
		return false if character == ""
		return false if @store.nil?
		return true
  end

  def create
    @sprites.clear
    drawText
		@sprites.values.each { |sprite| sprite.z = 9999 }
    $game_map.update
  end

  BaseColor   = Color.new(255, 255, 255)
  ShadowColor = Color.new(0,   0,   0)
  def drawText
		@store = DisplayNameOnMap.set(@event) if @event.is_a?(Game_Event)
    if @sprites.include?("overlay")
      @sprites["overlay"].bitmap.clear
    else
      width = Graphics.width
			height = Graphics.height
      @sprites["overlay"] = BitmapSprite.new(width, height, @viewport)
      @sprites["overlay"].z = @z + 1
    end
    x = @event.screen_x
    y = @event.screen_y - 75
		string = $Trainer.name if @event.is_a?(Game_Player)
		string = @store if @event.is_a?(Game_Event)
    text = [[string, x, y, 2, BaseColor, ShadowColor]]
    bitmap = @sprites["overlay"].bitmap
    pbSetSystemFont(bitmap)
    pbDrawTextPositions(bitmap,text)
  end

  def set_visible(value)
    @sprites["overlay"].visible = value if @sprites.include?("overlay")
  end

  def update
		if show_name?
			@sprites.empty? ? create : drawText
      pbUpdateSpriteHash(@sprites)
    else
      dispose if !@sprites.empty?
    end
  end

  def dispose = pbDisposeSpriteHash(@sprites)

end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class Sprite_Character
  alias ini_display_name initialize
  alias visible_display_name visible=
  alias dispose_display_name dispose
  alias update_display_name update

  def initialize(viewport,character=nil)
    @viewport = viewport
    ini_display_name(viewport,character)
  end

  def visible=(value)
    visible_display_name(value)
    @display.set_visible(value) if @display
  end

  def dispose
    dispose_display_name
    @display.dispose if @display
    @display = nil
  end

  def update
    update_display_name
    @display = DisplayName.new(@viewport, @character, self.z) if !@display
    @display.update
  end
end