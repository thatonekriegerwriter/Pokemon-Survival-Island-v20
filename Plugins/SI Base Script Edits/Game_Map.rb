class Game_Map
  def check_event(x, y)
    events = @events.values + $DynamicEvents.events_for_map
	
    events.each do |event|
      return event.id if event.at_coordinate?(x, y)
    end
      return $game_player if $game_player.x == x && $game_player.y == y
  end
  
  
  alias original_refresh_da refresh
  def refresh
    $DynamicEvents.refresh
    original_refresh_da
  end
  
  
  alias original_update_da update
  def update
    original_update_da
    $DynamicEvents.update
    
  end
  
  

  
end