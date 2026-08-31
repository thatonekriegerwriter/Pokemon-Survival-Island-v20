class ItemModifiers
  attr_reader :modifiers 
  attr_reader :effects 
  def initialize(item)
    @item = item
    @modifiers = {}
	@modifiers_length = 3 
    @effects = ItemEffects.new(@item)
  end
  
  def add(modifier)
    return false if @modifiers.length >= @modifiers_length
    return false if @modifiers.keys.include?(modifier.id)
    @modifiers[modifier.id] = modifier
	ModifierManager.trigger(modifier, @item)
	return true 
  end 
  
  def get_modifiers
    @modifiers.keys 
  end 
  
  def length
    @modifiers.length
  end
  
  def max_length
    @modifiers_length
  end 
  
end 

module ModifierManager
  Modifier = HandlerHashBasic.new
  class << self
    def trigger(modifier)
	 ret = Modifier.trigger(modifier)
     return (!ret.nil?) ? ret : false
	end
  end 
end 

