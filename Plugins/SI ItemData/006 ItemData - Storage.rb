class ItemData
  attr_accessor :internal_data
  attr_accessor :crate_storage
  attr_accessor :stored_items
  attr_accessor :bottle
  
  alias old_init_store initialize 
  def initialize(id, durability = nil, water = nil )
	old_init_store(id, durability, water)
    @crate_storage      = []
    @internal_data      = nil

    @stored_items  = []
    @bottle  = nil
	
  end

   def stored_items
    @stored_items  = [] if @stored_items.nil?
    return @stored_items
   end
   def bottle
    @bottle  = nil if @bottle.nil?
    return @bottle
   end

	
    def bottle_type
      return self.bottle
    end	
    
	def set_bottle(bottle)
	  @bottle = bottle
	end
	
   def reset_data
    @internal_data = nil
	@crate_storage.active = false if @crate_storage.respond_to?(:active)
   end 
   
   
   def crate_storage
    @crate_storage = [] if @crate_storage.nil?
    return @crate_storage
   end
   
   def crate_storage=(value)
     @crate_storage = value
    return @crate_storage
   end
end 