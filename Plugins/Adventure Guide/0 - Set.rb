module AdventureGuide
	@@list = []

	def self.error(error=nil)
		p error
		Kernel.exit!
	end

	# Set list
	def self.list(hash=nil)
		@@list << hash
	end

	def self.r_list = @@list

end