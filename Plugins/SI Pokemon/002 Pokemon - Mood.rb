class Pokemon
 class Mood
   alias _SI_Mood_init initialize
   def initialize(*args)
     _SI_Mood_init(*args)
     @anger =  rand(100)
	 @anxiety =  rand(100)
	 @affection =  rand(100)
   end 
   
   def set_values(anger, anxiety, affection)
      set_anger(anger)
      set_anxiety(anxiety)
      set_affection(affection)
   end 
   
   def set_anger(value)
     @anger = value
   end 
   
   def set_anxiety(value)
     @anxiety = value
   end
   
   def set_affection(value)
     @affection = value
   end
   
   def bubble
     #return :sleepy if tired?
     return :injured if self.hp < self.totalhp / 4
     return :panic if @anxiety > 180 && @anger > 150
     return :clingy if @anxiety > 150 && @affection > 150
     return :angry   if @anger > 180
     return :nervous if @anxiety > 180
     return :happy   if @affection > 180

     :neutral
   end
 
 end 
alias _SI_PokemonMood_init initialize
attr_reader :mood 
def initialize(*args)
 _SI_PokemonMood_init(*args)
  @mood = Pokemon::Mood.new


end 

   def mood
    @mood = Pokemon::Mood.new if @mood.nil? || !@mood.is_a?(Pokemon::Mood)
	return @mood 
   end 


end 



EventHandlers.add(:on_player_step_taken, :interacted_with,
  proc {
    $PokemonGlobal.interactedSteps = 0 if !$PokemonGlobal.interactedSteps
    $PokemonGlobal.interactedSteps += 1
    next if $PokemonGlobal.interactedSteps < 64
    $player.party.each do |pkmn|
      pkmn.update_interacted
    end
    $PokemonGlobal.interactedSteps = 0
  }
)

class PokemonGlobalMetadata
  attr_accessor :interactedSteps
  def interactedSteps
    @interactedSteps = 0 if @interactedSteps.nil?
	@interactedSteps
  end 
end 