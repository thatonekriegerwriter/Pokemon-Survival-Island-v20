class ItemData
  attr_accessor :id
  attr_accessor :display_name
  attr_accessor :flags
   
  def initialize(id, durability = nil, water = nil )
    @id         = id
    @display_name = self.data.real_name
    @flags      = []
  end


	

   def data
    return GameData::Item.get(@id)
   end
	
	
	def name
	  return data.name
	end
	def name_plural
	  return data.name_plural
	end

	def description
	  return data.description
	end
	def pocket
	  return data.pocket
	end 
   
   def stack_size
	 return data.stack_size if defined?(data.stack_size)
	 return 1 if data.is_placeable?
	 return 64 if @id==:JACKETEDCABLE
	 return 12 if data.has_flag?("CraftingMaterial")
	 return 1 if data.is_shoes? || data.is_shirt? || data.is_pants?
	 return 1 if data.is_machine?
	 return 1 if (data.is_weapon? && !data.is_dart? && @id!=:STONE && @id!=:BAIT)  || GameData::BerryPlant::WATERING_CANS.include?(@id) 
	 return 1 if data.is_medicine? 
	 return 3 if (data.is_foodwater? && !data.is_berry?)
	 return 6 if data.is_dart? || @id==:GLASSBOTTLE
	 return 12 if data.is_pokeball?
	 return 24 if data.is_berry? && !data.is_apricorn?
     return 36
     return Settings::BAG_MAX_PER_SLOT	 
   end
   alias max_per_slot stack_size
   

	 def has_flag(flag)
	   return view_flags.include?(flag)
	 end
	
	
	def flags_add(flag)
	  @flags<<flag
	end
	
	def flags_remove(flag)
	  @flags.remove(flag)
	end
 

	def view_flags
	 flags = []
	 own_flags = @flags
	 own_flags << "Can" if GameData::BerryPlant::WATERING_CANS.include?(@id)
	 flags = (flags + own_flags)
	 data_flags = GameData::Item.get(@id).flags
	 data_flags.each do |flag|
	    if flag.include?("Fling") || flag=="Overworld" || flag=="Coal" || flag=="Durable" || flag=="OffItem" || flag=="HMItem" || flag=="NoSpoiling" || flag=="Apricorn" || flag=="KeyItem"
	    elsif flag=="PlacingItem"
		 flags << "Placeable"
	    elsif flag=="PokeBall"
		 flags << "Pokeball"
	    elsif flag=="TypeGem"
		 flags << "Type Gem"
	    elsif flag=="EvolutionStone"
		 flags << "Evo Stone"
	    elsif flag=="FoodWater"
		 flags << "Food or Water"
	    else
		 flags << flag
		end
	 end
     flags << "TM" if  GameData::Item.get(@id).is_TM?
     flags << "HM" if  GameData::Item.get(@id).is_HM?
     flags << "TR" if  GameData::Item.get(@id).is_TR?
	 return flags
	end

   def identical(item)
     @modifiers = ItemModifiers.new(self) if @modifiers.nil? || !@modifiers.is_a?(ItemModifiers)
     return @id==item if item.is_a?(Symbol)
	 @durability = nil if @durability==false
	 item.durability = nil if item.durability==false
	 @water = nil if @water==false
	 item.water = nil if item.water==false
     return @id==item.id && @flags==item.flags && @durability==item.durability && @water==item.water && @modifiers.modifiers==item.modifiers.modifiers if item.is_a?(ItemData)
   end
   def identical_check(item)
     puts item.is_a?(ItemData) ? "#{item.name} is a ItemData" : "#{item} is a Symbol"
	 if item.is_a?(ItemData)
	 @durability = nil if @durability==false
	 item.durability = nil if item.durability==false
	 @water = nil if @water==false
	 item.water = nil if item.water==false
     puts "#{@id==item.id} (#{@id}/#{item.id})"
     puts "#{@flags==item.flags} (#{@flags}/#{item.flags})"
     puts "#{@durability==item.durability} (#{@durability}/#{item.durability})"
     puts "#{@water==item.water} (#{@water}/#{item.water})"
     puts "#{@modifiers.modifiers==item.modifiers.modifiers} (#{@modifiers.modifiers}/#{item.modifiers.modifiers})"
	 puts "Stack Size: #{stack_size}/#{item.stack_size}"
	 end
   end

   
   def update(spoil_amt)
     internal_data.update if internal_data && internal_data.respond_to?(:update) && !internal_data.is_a?(ResearchTableData)
     return if @id==:SPOILEDFOOD
     item = GameData::Item.get(@id)
     return unless item.is_foodwater? && !item.is_berry?
     return if item.is_apricorn?
     return if item.has_flag?("NoSpoiling")
   #  puts self.name 
   #  puts "Old Durability: #{self.durability}/#{self.max_durability}"
	 if @durability==false || @durability.nil?
	 @durability = 100 
	 @max_durability = @durability
	 end 
 	 @stats = ItemStats.new(self) if @stats.nil?
	 amt = spoil_amt * @stats.spoiling_rate
	 amt = amt/2.0 if item.is_berry?
     if @durability - amt <= 0
	   @id = :SPOILEDFOOD
	   @durability=nil
	   @max_durability=nil
	 else 
       @durability -= amt
	 end 
   #  puts "New Durability: #{self.durability}/#{self.max_durability}"
   #  puts self.name 
	# puts "======================"


   end 
   
   def ponder
	itemname = self.name
    if GameData::Research.can_research?(@id) 
	  word = itemname.starts_with_vowel? ? "an" : "a"
	  sideDisplay(_INTL("You have a gut feeling you can use #{word} #{itemname} for something."))
	else
	  word = itemname.starts_with_vowel? ? "an" : "a"
	  sideDisplay(_INTL("You can't even get an inkling of an idea for what to do with #{word} #{itemname}."))
	end 
   end 
   
end


