class Pokemon
  attr_reader :happiness
  attr_reader :loyalty
  attr_accessor :time_last_pet
  attr_accessor :time_last_brush
  attr_accessor :time_last_milk

alias _SI_Pokemon_Loyalty_init initialize
 def initialize(*args)
    _SI_Pokemon_Loyalty_init(*args)
	species_data = GameData::Species.get(@species)
    @happiness        = species_data.happiness || 100
    @loyalty          = species_data.loyalty || 70
    @time_last_pet = pbGetTimeNow.to_i-3600
    @time_last_brush = pbGetTimeNow.to_i-3600
    @time_last_milk = pbGetTimeNow.to_i-3600
 end

   def time_last_pet
   @time_last_pet = pbGetTimeNow.to_i-3600 if @time_last_pet.nil?
   return @time_last_pet
   end
   
   def time_last_brush
   @time_last_brush = pbGetTimeNow.to_i-3600 if @time_last_brush.nil?
   return @time_last_brush
   end
   
   def time_last_milk
   @time_last_milk = pbGetTimeNow.to_i-3600 if @time_last_milk.nil?
   return @time_last_milk
   end


  
  def calculate_disobedience_chance(loyalty,happiness)
    amt = 0
    case loyalty
    when 0..10
      amt = 80
    when 11..50
      amt = 60
    when 51..64
      amt = 45
    when 65..149
      amt = 30
    when 150..224
      amt = 15
    else
      amt = 0
    end
    amt-= (happiness/20).floor
    amt = 0 if amt<0
    return amt
  end
  
  def should_disobey?
    rand(256)+1<= self.calculate_disobedience_chance(@loyalty, @happiness)
  end 



  
def disobeying_direction(pkmn)
     r = rand(256)
    if r <= 30 && r >= 20 && @status != :SLEEP && @happiness >= 200
      sideDisplay(("#{@name} wants you to praise it before it does anything!"))
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && @happiness >= 199
      sideDisplay(("#{@name} wants to play!"))
      return false 
    end
    case rand(4)
    when 0 then sideDisplay(("#{@name} won't obey!"))
    when 1 then sideDisplay(("#{@name} turned away!"))
    when 2 then sideDisplay(("#{@name} is loafing around!"))
    when 3 then sideDisplay(("#{@name} pretended not to notice!"))
    end
	return false
end  



    
end 