class PokemonGlobalMetadata
    attr_accessor :follower_pkmn
	
	def follower_pkmn
	 @follower_pkmn = FollowerPkmnManager.new if @follower_pkmn.nil?
	 return @follower_pkmn
	end 
end

class FollowerPkmnManager
  attr_reader :followers
  def initialize
    @followers = []
  end 
  
  def add(event_id)
   return false if @followers.include?(event_id)
    @followers << event_id 
	return true
  end 
  
  def include?(event_id)
    @followers.include?(event_id)
  end 
  
  def replace(index, event_id)
    old = @followers[index]
	@followers[index] = event_id 
	return old 
  end 
  
  def remove(event_id)
    !!@followers.delete(event_id)
  end 
  
  def each
  return enum_for(:each) unless block_given?
  @followers.each { |event_id| yield event_id }
  end
  
  def length
    @followers.length
  end 
  def empty?
    @followers.empty?
  end
  def index(event_id)
    @followers.index(event_id)
  end 
  
  def first_follower
    @followers[0]
  end 
  
  def recent_follower
    @followers[-1]
  end 
  
  def get_follow_target(self_event)
    puts @followers.inspect
    @followers.reverse_each do |event_id|
      next if event_id == self_event.id
      event = $game_map.events[event_id]
      return event if event
   end
	return get_cur_player
  
  end 
  
  def transfer_followers
    @followers.each_with_index do |event_id, i|
      event = $game_map.events[event_id]
      event.map = $game_map
	  event.map_id = $game_map.map_id 
      event.moveto($game_player.x, $game_player.y)
      event.direction = $game_player.direction
      #event.opacity   = 255
    end
  
  
  end 
end 

OUTBREAK_TIME    = 24                   #

def pbPetCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.petTime>=24*60*60
   return true
  else 
   return false
  end
end

def pbGroomCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.groomTime>=24*60*60
   return true
  else 
   return false
  end

end

