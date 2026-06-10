class Game_Character
  attr_accessor :world_height



    alias :gc_reinit :initialize
	def initialize(map = nil)
	  gc_reinit(map)
      @world_height = map.get_current_height(@x,@y) if map
    end
    
	
	def world_height
      @world_height = $game_map.get_current_height(@x,@y) if @world_height.nil?
	 return @world_height
	
	end
	
	
    alias :gcefaf_update :update
	def update
	  gcefaf_update
	  if $game_map 
       @world_height = $game_map.get_current_height(@x,@y) if @world_height.nil?
	   wh = $game_map.get_current_height(@x,@y,@world_height)
	   @world_height = wh if @world_height!=wh
	  end
	end
end