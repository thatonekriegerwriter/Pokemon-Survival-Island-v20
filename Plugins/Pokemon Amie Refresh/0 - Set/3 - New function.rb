class Pokemon
	attr_accessor :amie_affection, :amie_fullness, :amie_enjoyment, :hunger

	alias amie_init initialize
	def initialize(species, level, owner = $Trainer, withMoves = true, recheck_form = true)
		amie_init(species, level, owner, withMoves, recheck_form)
		@amie_affection = 0
		@amie_fullness  = 0
		@amie_enjoyment = 0
		@hunger = 0
	end

	# Old: getAmieStatLevel, getAffectionLevel, getFullnessLevel, getEnjoymentLevel
	def amie_stats(value=0)
		points = value==0 ? @amie_affection : value==1 ? @amie_fullness : value==2 ? @amie_enjoyment : 0
		return 0 if points == 0
		return 5 if points == PkmnAR::MAX_AMIE
		return 4 if points.between?(150, PkmnAR::MAX_AMIE - 1)
		return points / 50 + 1
  end

	# Old: resetAffection
	def reset_affection
		@amie_affection = 0
		@amie_fullness  = 0
		@amie_enjoyment = 0
	end
end