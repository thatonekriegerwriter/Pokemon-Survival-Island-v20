if false 
class Pokemon
alias _SI_PokemonBee_init initialize

def initialize(*args)
 _SI_PokemonBee_init(*args)
  @bee_data = Pokemon::BeeData.new if bee?


end 

   def bee_data
    return nil unless bee?
    @bee_data = Pokemon::BeeData.new if @bee_data.nil? || !@bee_data.is_a?(Pokemon::BeeData)
	return @bee_data 
   end 

 class BeeData
   def initialize
   end 

 end 


end 
end 