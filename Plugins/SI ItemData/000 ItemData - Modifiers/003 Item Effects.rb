class ItemEffects
  def initialize(item)
    @item = item
	@effects = {} 
  end 
  
  def add(key, effect)
    @effects[key] = effect 
  end 
  
  def trigger(key, *args)
    effect = @effects[key]
	return args[0] if [:modifyCatchRate].include?(key)
    return false if effect.nil?
	
    return EffectManager.trigger(key, effect, @item, *args)
  end 

end 



module EffectManager

  class << self
    def const_missing(name)
      const_set(name, HandlerHashBasic.new)
    end
	
    def trigger(key, effect, item, *args)
      handler = const_get(key)
  	  return args[0] if [:modifyCatchRate].include?(key)
      return false if handler.nil?
      handler.trigger(effect, item, *args)
    end
	
	
  end
end
