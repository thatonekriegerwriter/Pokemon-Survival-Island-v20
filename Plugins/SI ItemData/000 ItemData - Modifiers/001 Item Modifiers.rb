class ItemModifiers
  attr_accessor :item 
  attr_reader :modifiers 
  attr_reader :effects 
  def initialize(item)
    @item = item
    @modifiers = {}
	@modifiers_length = 3 
    @effects = ItemEffects.new(@item)
  end

  def initialize_copy(original)
    super
    @modifiers = original.modifiers.dup
    @effects = original.effects.dup
    @effects.item = self.item if @effects.respond_to?(:item=)
  end
 
  def add(modifier_item)
    return false if @modifiers.length >= @modifiers_length
    return false if @modifiers.keys.include?(modifier_item.id)
	if ModifierManager.trigger(modifier_item, @item)
     @modifiers[modifier_item.id] = modifier_item
	 return true 
	else
	 return false 
	end 
  end 
  
  def remove(modifier_id)
    return false unless @modifiers.keys.include?(modifier_id)
    modifier_item = @modifiers[modifier_id]
	if ModifierManager.remove(modifier_item, @item)
	 @modifiers.delete(modifier_id)
	 return true 
	end 
	return false 
  end 
  
  def get_modifiers
    @modifiers.keys 
  end 
  
  def get_itemdata
    @modifiers.values 
  end 
  
  def length
    @modifiers.length
  end
  
  def max_length
    @modifiers_length
  end 
  
  def to_a
    @modifiers.to_a
  end 
end 

module ModifierManager
  Modifier = HandlerHashBasic.new
  ModifierRemove = HandlerHashBasic.new
  class << self
    def trigger(modifier_item, item)
	 ret = Modifier.trigger(modifier_item.id, modifier_item, item)
     return (!ret.nil?) ? ret : false
	end
    def remove(modifier_item, item)
	 ret = ModifierRemove.trigger(modifier_item.id, modifier_item, item)
     return (!ret.nil?) ? ret : false
	end
  end 
end 

