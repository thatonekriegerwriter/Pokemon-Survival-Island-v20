class Player < Trainer #HELD ITEM

  attr_reader :held_item
  attr_reader :held_item_object
  
  
     alias _SI2_Player_Init initialize
     def initialize(name, trainer_type)
       _SI2_Player_Init(name, trainer_type)
       @held_item           = nil
       @held_item_object = nil
     end

    def held_item_event_id
	  @held_item_object
	end 
    def held_item_event_id=(value)
	  @held_item_object = value
	end 	
	
	def held_item_event
	  $game_map.events[self.held_item_event_id]
	end 
	
	
    def held_item=(value)
       @held_item = value
    end
	
    def held_item_object=(value)
       @held_item_object = value
    end
   
   
   
   
    def held_item?
	  return !@held_item_object.nil? && !@held_item.nil?
	end
    
	
	
	def store_in_inv
	  @held_item.reset_data
	  $bag.add(@held_item)
	  self.held_item_event.removeThisEventfromMap
	  @held_item = nil
	  @held_item_object = nil
	end
	
    def hold(item)
	 return false if @held_item 
	 @held_item=item
	 pbShowTipCard(:OVERWORLDITEMS) if !pbSeenTipCard?(:OVERWORLDITEMS)
	 Placeable.hold($game_player.x,$game_player.y-1,item,true)
	 return true
    end
    

    def place(x,y)
	 return false if @held_item.nil?
	 item = @held_item
	 event = self.held_item_event
	 direction = event.direction
	 
	 if Placeable.place(x, y, item, false, direction, true)
	  event.removeThisEventfromMap
      @held_item=nil
	  @held_item_object=nil
      return true
	 
	 
	 end 
	 return false
    end

















end

