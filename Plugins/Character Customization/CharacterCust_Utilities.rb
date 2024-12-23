#===============================================================================
# * Character Costumization by Wolf Heretic
# * Based Heavily on a script by shiney570
# Version: 2.0.0
#===============================================================================
# This part of the script focuses mostly on how outfits customized are saved as
# well as various functions used throughout the script. Includes (In Order):
# - Utility methods
# - Initial saving of outfit
# - Permanent Save of outfit when player saves game
# - Edits how metadata is called to help distinguish between saved and non-saved
# outfits.
# - Edits png extention
#
#
#==================================================================================
# *Utility Methods used throughout this script
#==================================================================================
 

 
# Returns a boolean indicating if the character can be customized given settings
# set by the creator and the player's current state.
def characterizationException
return true if !$player.character_customization
return true if !$player
return true if !$player.hair
return false
end
 


 
#Fetches the file names corresponding to a given array.
#files: An array where all the file names will be stored. Should be the empty array initially
#array: An array of clothing items (ie. getList($player.hairList))
#folder: The folder from which these file names will correspond to.
def individualArrayFiles(files,array,folder)
for i in 0...array.length
if ((array[i][1] == true) || (array[i][1] == false))
files.push(folder+"/#{i}"+($player.gender+65).chr)
else
for j in 0...array[i][1].length
files.push(folder+"/#{i}/#{j}"+($player.gender+65).chr)
end
end
end
end
 
 



#===============================================================================
# Creates a method which saves a character's outfit permanently when the game is saved.
#===============================================================================
 
#Saves a specific outfit when pbSave is called.
def saveOutfit(filepath)
if (File.exists?(filepath+".png") && File.exists?(filepath+"_curr.png"))
File.delete(filepath+".png")
bmp=Bitmap.new(filepath+"_curr.png")
bmp.save_to_png(filepath+".png")
else
if $DEBUG
p "ERROR: Unable to save file at #{filepath}"
end
end
return
end
 
#Saves all of the outfits when pbSave is called.
def saveAllOutfits
return if !$player
$game_temp.savedoutfit = true
if !reqFilesExist
$game_temp.savedoutfit = false
return
end
meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
filepath="Graphics/Characters/"
filenames=[pbGetPlayerCharset(meta.walk_charset),pbGetPlayerCharset(meta.run_charset),pbGetPlayerCharset(meta.cycle_charset),pbGetPlayerCharset(meta.surf_fish_charset),pbGetPlayerCharset(meta.fish_charset)]
for i in 0...filenames.length
if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
saveOutfit(filepath+filenames[i])
end
end

# Trainer backsprite
saveOutfit("Graphics/Trainers/trback00#{$player&.character_ID}")
# Intro Image/Trainercard Image
filepath="Graphics/Pictures/"
filepath+= $player.female? ? "introGirl" : "introBoy"
saveOutfit(filepath)
# Map Player
saveOutfit("Graphics/Pictures/mapPlayer00#{$player&.character_ID}")
return
end
 
#Checks to see if all of the required files exist before trying to save all of the outfits.
def reqFilesExist
# Trainer charsets
meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
filenames=[pbGetPlayerCharset(meta.walk_charset),pbGetPlayerCharset(meta.run_charset),pbGetPlayerCharset(meta.cycle_charset),pbGetPlayerCharset(meta.surf_fish_charset),pbGetPlayerCharset(meta.fish_charset)]
for i in 0...filenames.length
if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
if !File.exists?("Graphics/Characters/#{filenames[i]}.png")
return false
end
if !File.exists?("Graphics/Characters/#{filenames[i]}"+"_curr.png")
return false
end
end
end
# Trainer backsprite
filepath="Graphics/Trainers/trback00#{$player&.character_ID}"
if (!File.exists?(filepath+".png") || !File.exists?(filepath+"_curr.png"))
return false
end
# Intro Image/Trainercard Image
filepath="Graphics/Pictures/"
filepath+= $player.female? ? "introGirl" : "introBoy"
if (!File.exists?(filepath+".png") || !File.exists?(filepath+"_curr.png"))
return false
end
# Map Player
filepath="Graphics/Pictures/mapPlayer00#{$player&.character_ID}"
if (!File.exists?(filepath+".png") || !File.exists?(filepath+"_curr.png"))
return false
end
return true
end
 
 

 
#===============================================================================
# * Edit to the pbSave function to make sure outfit is saved for future load.
#===============================================================================
module SaveData
   class Value
  alias :saveold :save
def save(safesave=false)
if $game_temp.savedoutfit == false #ADDED CODE
saveAllOutfits #ADDED CODE
end
saveold
end
end
end
