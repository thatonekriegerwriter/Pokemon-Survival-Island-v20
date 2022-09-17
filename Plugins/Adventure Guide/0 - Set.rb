module AdventureGuide
	@@list = []

	def self.error(error=nil)
		p error
		Kernel.exit!
	end

	# Set list
	def self.list(hash=nil)
		if !hash.is_a?(Hash)
			self.error("Use Hash with this method! Please, read or see examples!")
			return
		end
		@@list << hash
	end

	def self.r_list = @@list

end