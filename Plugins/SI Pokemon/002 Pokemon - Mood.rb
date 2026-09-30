class Pokemon
attr_reader :mood 
alias _SI_PokemonMood_init initialize

def initialize(*args)
 _SI_PokemonMood_init(*args)
  @mood = Pokemon::Mood.new


end 

   def mood
    @mood = Pokemon::Mood.new if @mood.nil? || !@mood.is_a?(Pokemon::Mood)
	return @mood 
   end 

 class Mood
   def initialize
     @assertiveness = rand(100) #1-255
	 @anxiety =  rand(100) #1-255
	 @affection =  rand(100) #1-255
   end 
   
   def increase_assertiveness(amt, pkmn)
     if @anger 
       @assertiveness = @anger
	   @anger = nil
	 end 
	 @assertiveness = rand(100) if @assertiveness.nil?
     old_assertiveness = @assertiveness
     @assertiveness += amt

     ((old_assertiveness / 50) + 1).upto(@assertiveness / 50) do |threshold|
       pkmn.loyalty += 10
     end
   end
   def increase_affection(amt, pkmn)
     old_affection = @affection
     @affection += amt

     ((old_affection / 50) + 1).upto(@affection / 50) do |threshold|
       pkmn.happiness += 10
     end
	  
   end 
   def increase_anxiety(amt, pkmn)
     old_anxiety = @anxiety
     @anxiety += amt

     ((old_anxiety / 50) + 1).upto(@anxiety / 50) do |threshold|
       pkmn.fear += 10
     end
	  
   end 
   

   
   def set_values(assertiveness, anxiety, affection, pkmn = nil)
      if @anger 
       @assertiveness = @anger
	   @anger = nil
	  end 
	  @assertiveness = rand(100) if @assertiveness.nil?
      set_assertiveness(assertiveness)
      set_anxiety(anxiety)
      set_affection(affection)
	  if pkmn
	    pkmn.reinitialize_hlf
        pkmn.loyalty += @assertiveness / 5
        pkmn.happiness += @affection / 5
        pkmn.fear += @anxiety / 5
	  end 
   end 
   
   def set_assertiveness(value)
     @assertiveness = value
   end
   
   def set_anxiety(value)
     @anxiety = value
   end
   
   def set_affection(value)
     @affection = value
   end
   
   def bubble
      if @anger 
       @assertiveness = @anger
	   @anger = nil
	  end 
	  @assertiveness = rand(100) if @assertiveness.nil?
     #return :sleepy if tired?
     return :injured if self.hp < self.totalhp / 4
     return :panic if @anxiety > 180 && @assertiveness > 150
     return :clingy if @anxiety > 150 && @affection > 150
     return :angry   if @assertiveness > 180
     return :nervous if @anxiety > 180
     return :happy   if @affection > 180

     :neutral
   end
 
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