class Player
  attr_accessor :charmsActive
  attr_accessor :charmlist
  attr_accessor :elementCharmlist
  attr_accessor :last_wish_time
  attr_accessor :twin_charm_data
  attr_accessor :twin_charm_fled
	def initializeCharms
	@twin_charm_data ||= {}
	@twin_charm_fled ||= {}
	@last_wish_time ||= 0
    @charmlist ||= []
    @elementCharmList ||= []
	@charmsActive = {
		:BALANCECHARM     => false,
		:BERRYCHARM       => false,
		:CATCHINGCHARM    => false,
		:CLOVERCHARM      => false,
		:COINCHARM        => false,
		:CORRUPTCHARM	  => false,
		:DISABLECHARM     => false,
		:EASYCHARM		  => false,
		:EFFORTCHARM	  => false,
		:EXPALLCHARM	  => false,
		:EXPCHARM         => false,
	    :FRUGALCHARM      => false,
		:GENECHARM		  => false,
		:GOLDCHARM        => false,
		:HARDCHARM		  => false,
		:HEALINGCHARM     => false,
		:HEARTCHARM       => false,
		:IVCHARM          => false,
		:KEYCHARM         => false,
		:LURECHARM        => false,
		:MERCYCHARM       => false,
		:MININGCHARM      => false,
		:OVALCHARM        => false,
		:PROMOCHARM       => false,
		:PURIFYCHARM	  => false,
		:SHINYCHARM       => false,
		:SLOTSCHARM       => false,
		:SMARTCHARM		  => false,
		:SPIRITCHARM      => false,
		:STABCHARM		  => false,
		:STEPCHARM		  => false,
		:TWINCHARM        => false,
		:VIRALCHARM       => false,
		:WISHINGCHARM     => false,
    #Elemental Charms
	:BUGCHARM         => false,
    :DARKCHARM        => false,
	:DRAGONCHARM      => false,
	:ELECTRICCHARM    => false,
	:FAIRYCHARM       => false,
    :FIGHTINGCHARM    => false,
	:FIRECHARM        => false,
	:FLYINGCHARM      => false,
    :GHOSTCHARM       => false,
    :GRASSCHARM       => false,
    :GROUNDCHARM      => false,
	:ICECHARM         => false,
	:NORMALCHARM      => false,
    :PSYCHICCHARM     => false,
    :POISONCHARM      => false,
    :ROCKCHARM        => false,
    :STEELCHARM       => false,
	:WATERCHARM       => false
		}
		
	end
end
module GameData
  class Item
    def is_charm?
      charm_ids = [
        :BALANCECHARM, :BERRYCHARM, :CATCHINGCHARM, :CLOVERCHARM,  :COINCHARM,   :CORRUPTCHARM, :DISABLECHARM, :EFFORTCHARM, :EASYCHARM,  :EXPALLCHARM, :EXPCHARM,  :FRUGALCHARM, 
		:GENECHARM,    :GOLDCHARM,  :HARDCHARM,     :HEALINGCHARM, :HEARTCHARM,  :IVCHARM,      :KEYCHARM,     :LURECHARM,   :MERCYCHARM, :MININGCHARM, :OVALCHARM, :PROMOCHARM,  
		:PURIFYCHARM,  :SHINYCHARM, :SLOTSCHARM,    :SMARTCHARM,   :SPIRITCHARM, :STABCHARM,    :STEPCHARM,    :TWINCHARM,   :VIRALCHARM, :WISHINGCHARM
      ]
      charm = charm_ids.include?(self.id.to_sym)
      return charm
    end
	def is_echarm?
	echarm_ids = [
	    :BUGCHARM, :DARKCHARM, :DRAGONCHARM, :ELECTRICCHARM, :FAIRYCHARM,
        :FIGHTINGCHARM, :FIRECHARM, :FLYINGCHARM, :GHOSTCHARM, :GRASSCHARM,
        :GROUNDCHARM, :ICECHARM, :NORMALCHARM, :PSYCHICCHARM, :POISONCHARM,
        :ROCKCHARM, :STEELCHARM, :WATERCHARM
	]
	echarm = echarm_ids.include?(self.id.to_sym)
	return echarm
	end
  end
end