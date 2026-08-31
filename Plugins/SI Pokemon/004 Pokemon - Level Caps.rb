class Pokemon
  attr_accessor :level_cap
  attr_accessor :level_cap_basic
  attr_accessor :level_cap_bonus
  attr_accessor :stored_exp

  alias _SI_Level_Cap_init initialize
  def initialize(*args)
    _SI_Level_Cap_init(*args)
    @stored_exp     = 0
    @level_cap_bonus     = 0
    @level_cap_basic     = pbPersonalLevelCap(self).to_i
    @level_cap = @level_cap_basic.to_i
  end
  
   def stored_exp
   @stored_exp = 0 if @stored_exp.nil?
   return @stored_exp
   end
   

   def level_cap
   @level_cap_basic = pbPersonalLevelCap(self) if @level_cap_basic.nil?
   @level_cap = @level_cap_basic if @level_cap.nil?
   return @level_cap
   end
 
 
   def update_level_cap
      @level_cap = @level_cap_basic + @level_cap_bonus
   end
   
   def update_level_cap_for_shadow
      cap = pbPersonalLevelCap(self)
	  if cap > @level_cap_basic
	   @level_cap_basic = cap
	  end
	  update_level_cap
   end
end 