module BerryPoffin
  # Store berry for expert
	if !defined?(BerryExpert)
		BerryExpert = [
			"Liechi Berry","Ganlon Berry","Salac Berry","Petaya Berry",
			"Apicot Berry","Lansat Berry","Starf Berry","Enigma Berry",
			"Micle Berry","Custap Berry","Jaboca Berry","Rowap Berry",
			"Roseli Berry","Kee Berry","Maranga Berry"
		]
  end

  module_function
  
  # Return ID of berry
	if !defined?(playerID)
		def playerID
			scene  = PokemonBag_Scene.new
			screen = PokemonBagScreen.new(scene,$PokemonBag)
			berry  = screen.pbChooseItemScreen( Proc.new { |item| GameData::Item.get(item).is_berry? } ) 
			return berry if berry
			return nil
		end
	end
  
	if !defined?(playerChoosed)
		def playerChoosed
			item = self.playerID
			return nil if item.nil?
			berry = GameData::Item.get(item).id
			$PokemonBag.pbDeleteItem(berry, 1)
			return berry
		end
	end
  
	if !defined?(listBerry)
		def listBerry
			list = []
			item = []
			GameData::Item.each { |i| item << i.id }
			item.each { |i| list << i if GameData::Item.get(i).is_berry? }
			return list
		end
	end
  
	if !defined?(random)
  	def random = listBerry.sample
	end
  
	if !defined?(randomExpert)
		def randomExpert
			return nil if BerryExpert.length<=0
			berry = nil
			random = BerryExpert.sample
			item = []
			GameData::Item.each { |i| item << i.id }
			item.each { |i| berry = i if GameData::Item.get(i).name==random && GameData::Item.get(i).is_berry? }
			return berry
		end
	end
  
end