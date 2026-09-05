class ItemEffects
  def initialize(item)
    @item = item
	@effects = {} 
  end 
  
  def initialize_copy(original)
    super
    @effects = original.instance_variable_get(:@effects).dup
  end
  
  def add(key, effect)
    return false if @effects[[key, effect]]
    @effects[[key, effect]] = effect 
    return true
  end 
  
  def remove(key, effect)
    return false unless @effects[[key, effect]]
    @effects.delete([key, effect])
    return true
  end 
  
  def trigger(key, *args)
    matching_effects = @effects.select { |(effect_key, effect_payload), e| effect_key == key }
	
	
	return args[0] if [:modifyCatchRate].include?(key) && matching_effects.empty?
    return false if matching_effects.empty?
	
	catch_rate  = args[0]
	any_truth = false
	
	
	matching_effects.each do |k, effect|
	  if [:modifyCatchRate].include?(key)
       current_pass_args = [catch_rate] + args[1..-1]
       catch_rate = EffectManager.trigger(key, effect, @item, *current_pass_args)
	  
	  else
       result = EffectManager.trigger(key, effect, @item, *args)
	   any_truth = true if result && result == true 
	  end 
	end
	
    return [:modifyCatchRate].include?(key) ? catch_rate : any_truth
  end 
  
  
  def get_effects
    string = ""
    @effects.keys.each do |key|
	 next unless key
	 string += "#{key[0].to_s}, #{key[1].to_s} \n"
	end 
    return string 
  end 
end 



module EffectManager

  class << self
    def const_missing(name)
      const_set(name, HandlerHashBasic.new)
    end
	
    def trigger(key, effect, item, *args)
      handler = const_get(key)
  	  return args[0] if [:modifyCatchRate].include?(key) && handler.nil?
      return false if handler.nil?
      handler.trigger(effect, item, *args)
    end
	
	
  end
end
