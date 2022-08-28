module BerryBlender
FLAVOR = [
# spicy | dry | sweet | bitter | sour
[1,0,0,0,-1],   # Cheri Berry Flavor
[-1,1,0,0,0],   # Chesto Berry Flavor
[0,-1,1,0,0],   # Pecha Berry Flavor
[0,0,-1,1,0],   # Rawst Berry Flavor
[0,0,0,-1,1],   # Aspear Berry Flavor
[1,-1,0,0,0],   # Leppa Berry Flavor
[0,0,0,0,0],    # Oran Berry Flavor
[0,0,0,0,0],    # Persim Berry Flavor
[0,0,0,0,0],    # Lum Berry Flavor
[0,0,0,0,0],    # Sitrus Berry Flavor
[1,0,0,0,-1],   # Figy Berry Flavor
[-1,1,0,0,0],   # Wiki Berry Flavor
[0,-1,1,0,0],   # Mago Berry Flavor
[0,0,-1,1,0],   # Aguav Berry Flavor
[0,0,0,-1,1],   # Iapapa Berry Flavor
[0,1,0,0,-1],   # Razz Berry Flavor
[-1,0,1,0,0],   # Bluk Berry Flavor
[0,-1,0,1,0],   # Nanab Berry Flavor
[0,0,-1,0,1],   # Wepear Berry Flavor
[1,0,0,-1,0],   # Pinap Berry Flavor
[1,-1,0,1,-1],  # Pomeg Berry Flavor
[-1,1,-1,0,1],  # Kelpsy Berry Flavor
[1,-1,1,-1,0],  # Qualot Berry Flavor
[0,1,-1,1,-1],  # Hondew Berry Flavor
[-1,0,1,-1,1],  # Grepa Berry Flavor
[1,1,0,0,-2],   # Tamato Berry Flavor
[-2,1,1,0,0],   # Cornn Berry Flavor
[0,-2,1,1,0],   # Magost Berry Flavor
[0,0,-2,1,1],   # Rabuta Berry Flavor
[1,0,0,-2,1],   # Nomel Berry Flavor
[3,1,0,0,-4],   # Spelon Berry Flavor
[-4,3,1,0,0],   # Pamtre Berry Flavor
[0,-4,3,1,0],   # Watmel Berry Flavor
[0,0,-4,3,1],   # Durin Berry Flavor
[1,0,0,-4,3],   # Belue Berry Flavor
[0,0,0,0,0],    # Occa Berry Flavor   # Generation IV
[0,0,0,0,0],    # Passho Berry Flavor # Generation IV
[0,0,0,0,0],    # Wacan Berry Flavor  # Generation IV
[0,0,0,0,0],    # Rindo Berry Flavor  # Generation IV
[0,0,0,0,0],    # Yache Berry Flavor  # Generation IV
[0,0,0,0,0],    # Chople Berry Flavor # Generation IV
[0,0,0,0,0],    # Kebia Berry Flavor  # Generation IV
[0,0,0,0,0],    # Shuca Berry Flavor  # Generation IV
[0,0,0,0,0],    # Coba Berry Flavor   # Generation IV
[0,0,0,0,0],    # Payapa Berry Flavor # Generation IV
[0,0,0,0,0],    # Tanga Berry Flavor  # Generation IV
[0,0,0,0,0],    # Charti Berry Flavor # Generation IV
[0,0,0,0,0],    # Kasib Berry Flavor  # Generation IV
[0,0,0,0,0],    # Haban Berry Flavor  # Generation IV
[0,0,0,0,0],    # Colbur Berry Flavor # Generation IV
[0,0,0,0,0],    # Babiri Berry Flavor # Generation IV
[0,0,0,0,0],    # Chilan Berry Flavor # Generation IV
[4,-4,4,-1,-3], # Liechi Berry Flavor
[-4,4,-4,4,0],  # Ganlon Berry Flavor
[0,-4,4,-4,4],  # Salac Berry Flavor
[4,0,-4,4,-4],  # Petaya Berry Flavor
[-4,4,0,-4,4],  # Apicot Berry Flavor
[0,0,0,0,0],    # Lansat Berry Flavor
[0,0,0,0,0],    # Starf Berry Flavor
[0,0,0,0,0],    # Enigma Berry Flavor
[0,0,0,0,0],    # Micle Berry Flavor  # Generation IV
[0,0,0,0,0],    # Custap Berry Flavor # Generation IV
[0,0,0,0,0],    # Jaboca Berry Flavor # Generation IV
[0,0,0,0,0],    # Rowap Berry Flavor  # Generation IV
[0,0,0,0,0],    # Roseli Berry Flavor
[0,0,0,0,0],    # Kee Berry Flavor
[0,0,0,0,0],    # Maranga Berry Flavor
]
#-------------------------------------------------------------------------------
# Smoothness (calculate for increasing sheen)
# Add new like this form:
# Smoothness = [ [[Name of berry], number] , [ [Name of berry], number] ]
#-------------------------------------------------------------------------------
Smoothness = [
# Smooth: 25
[["Cheri Berry","Chesto Berry","Pecha Berry","Rawst Berry","Aspear Berry",
"Figy Berry","Wiki Berry","Mago Berry","Aguav Berry","Iapapa Berry"], 25],
# Smooth: 20
[["Leppa Berry","Oran Berry","Persim Berry","Lum Berry","Sitrus Berry",
"Razz Berry","Bluk Berry","Nanab Berry","Wepear Berry","Pinap Berry",
"Pomeg Berry","Kelpsy Berry","Qualot Berry","Hondew Berry","Grepa Berry"], 20],
# Smooth: 30
[["Tamato Berry","Cornn Berry","Magost Berry","Rabuta Berry","Nomel Berry",
"Occa Berry","Passho Berry","Wacan Berry","Rindo Berry","Yache Berry",
"Chople Berry","Kebia Berry","Shuca Berry","Coba Berry","Payapa Berry"], 30],
# Smooth: 35
[["Spelon Berry","Pamtre Berry","Watmel Berry","Durin Berry","Belue Berry",
"Tanga Berry","Charti Berry","Kasib Berry","Haban Berry","Colbur Berry",
"Babiri Berry","Chilan Berry"], 35],
# Smooth: 40
[["Liechi Berry","Ganlon Berry","Salac Berry","Petaya Berry","Apicot Berry"], 40],
# Smooth: 50
[["Lansat Berry","Starf Berry"], 50],
# Smooth: 60
[["Enigma Berry","Micle Berry","Custap Berry","Jaboca Berry","Rowap Berry",
"Roseli Berry","Kee Berry","Maranga Berry"], 60]
]
#-------------------------------------------------------------------------------
# Function
#-------------------------------------------------------------------------------
  module_function
  
  # Calculate for choosing flavor
	def calc(id,berry)
		(0...id.length).each { |i| return i if id[i] == berry }
		return 0
	end
  
	def play(id,berry) = FLAVOR[calc(id,berry)]

  # Calculate smooth of berry (it depends quantity of player)
	def smooth(berry,alone=false)
		Smoothness.each { |s| return s[1] if s[0].include?(GameData::Item.get(berry).name) } if alone
		if !berry.is_a?(Array)
			p "You need to set Array for 'berry'"
			Kernel.exit!
		end
		sum = 0
		berry.each{ |i| 
			Smoothness.each { |s| sum+=s[1] if s[0].include?(GameData::Item.get(i).name) } 
		}
		average = sum/berry.size - berry.size
		average = 99 if average>=99
		return average
	end
	
end