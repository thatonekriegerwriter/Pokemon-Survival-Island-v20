


class Game_MineEvent < Game_Event
  attr_accessor :event

  def initialize(type, map_id, event, map=nil)
    super(map_id, event, map)
  end
end
class Game_MineEvent < Game_Event
  attr_accessor :type
  
  alias o_initialize initialize
  def initialize(type, map_id, event, map=nil)
    o_initialize(type, map_id, event, map)
    @type  = type
  end
  
  def type=(value)
    @type = value
  end
  
  

end