# Pokegear HGSS
# Credit: bo4p5687, Richard PT (graphics)

class PokemonGlobalMetadata
	attr_accessor :featurePokegear
	attr_accessor :backgroundPokegear

  alias pokegear_HGSS_ini initialize
  def initialize
    pokegear_HGSS_ini
		# Set 'seen' feature
		@featurePokegear = {}
		# Store background (color)
		@backgroundPokegear = 0
  end

end

module PokegearHGSS
	@@list = {}

	def self.error(error=nil)
		p error
		Kernel.exit!
	end

	# Set list
	def self.list(name=nil,hash=nil)
		return if name.nil?
		if !hash.is_a?(Hash)
			self.error("Use #{name} with Hash! Please, read or see examples!")
			return
		end
		@@list[name.to_sym] = hash
	end

	# Set seen or not
	def self.seen(name=nil,seen=true)
		return if name.nil?
		if !@@list[name.to_sym]
			self.error("Set this #{name} with method PokegearHGSS.list() to use")
			return
		end
		$PokemonGlobal.featurePokegear[name.to_sym] = seen
	end

	def self.set_begin_seen
		return if @@list.size <= 0
		@@list.each { |k,_|
			next if !$PokemonGlobal.featurePokegear[k].nil?
			$PokemonGlobal.featurePokegear[k] = true
		}
	end

	# Check quantity of pokegear's feature
	def self.seenGear
		PokegearHGSS.set_begin_seen
		return [] if !$PokemonGlobal.featurePokegear || $PokemonGlobal.featurePokegear.size <= 0
		hash = $PokemonGlobal.featurePokegear
		matcher = ->(_,v) { v }
		return hash.select(&matcher).keys
	end

	def self.features
		# Store value (check)
		features = []
		number   = []
		feature  = {}
		order    = PokegearHGSS.seenGear
		@@list.each { |k,v|
			order.each { |i|
				next if i!=k
				number << v[:order]
				feature[k] = v[:order]
			}
		}
		check = number.uniq!
		self.error("Check order number!") if !check.nil?
		feature = feature.sort_by(&:last)
		# Stored
		feature.each { |i| features << i[0] }
		return features
	end

	def self.rList; @@list; end
	
end