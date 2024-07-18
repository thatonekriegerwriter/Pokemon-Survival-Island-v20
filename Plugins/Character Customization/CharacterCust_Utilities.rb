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
 
# checks whether or not an inputed array is multi-dimensional at a given index.
# arr: An array of clothing items (ie. getList($player.hairList))
# num: The index numberof a specific item in the array.
# single(optional): if true, checks if index at given array is singular, otherwise
# checks if not singular.
def checkAccessory(arr,num,single=true)
if (arr[num][1]==true)||(arr[num][1]==false)
return (false^single)
else
return (true^single)
end
end
 
# helperfunction for randomizing outfit.
# bodypart: number corresponding to the specific bodypart array desired.
def randomizeOutfitHelper(bodypart)
arr=getList($player.hairList) if bodypart==0
arr=getList($player.topList) if bodypart==1
arr=getList($player.bottomList) if bodypart==2
arr=getList($player.headgearList) if bodypart==3
arr=ACCESSORY_ITEMS if bodypart==4
fv=rand(arr.length)
if checkAccessory(arr,fv)
case bodypart
when 0
$player.hair=[fv, -1]
when 1
$player.top=[fv, -1]
when 2
$player.bottom=[fv, -1]
when 3
$player.headgear=[fv, -1]
when 4
$player.accessory=[fv, -1]
end
else
case bodypart
when 0
$player.hair=[fv, rand(arr[fv][1].length)]
when 1
$player.top=[fv, rand(arr[fv][1].length)]
when 2
$player.bottom=[fv, rand(arr[fv][1].length)]
when 3
$player.headgear=[fv, rand(arr[fv][1].length)]
when 4
$player.accessory=[fv, rand(arr[fv][1].length)]
end
end
end
 
#===============================================================================
# * Drawing the customized Bitmap
#===============================================================================
 
# Method to add an additional bitmap to another bitmap.
def addAdditionalBitmap(filepath,formerBitmap)
if File.exists?(filepath)
formerBitmap.blt(0,0,Bitmap.new(filepath),Rect.new(0,0,Graphics.width,Graphics.height))
end
end
 
#Draws a specific bitmap for the player sprite.
def drawCharacterCustomizedBitmap(folder,bmp,trainerClass=$player)
return nil if !folder.is_a?(String)
return bitmap if !trainerClass
return bitmap if CHARACTER_CUSTOMIZATION==false
return bitmap if UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT==false &&
trainerClass.character_customization==false
oldfilepath = "Graphics/Characters/"+folder+"/"
if trainerClass.base
addAdditionalBitmap("Graphics/Characters/base graphics/"+folder+"/"+ trainerClass.base.to_s + ($player.gender+65).chr+".png",bmp)
end
# Adding Bottom Bitmap
if trainerClass.bottom[1] == -1
addAdditionalBitmap(oldfilepath+"bottoms/"+(trainerClass.bottom[0]).to_s+
($player.gender+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"bottoms/"+(trainerClass.bottom[0]).to_s+
"/"+(trainerClass.bottom[1]).to_s+($player.gender+65).chr+".png",bmp)
end
# Adding Top Bitmap
if trainerClass.top[1] == -1
addAdditionalBitmap(oldfilepath+"tops/"+(trainerClass.top[0]).to_s+
($player.gender+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"tops/"+(trainerClass.top[0]).to_s+
"/"+(trainerClass.top[1]).to_s+($player.gender+65).chr+".png",bmp)
end
# Adding Accessory Bitmap
if trainerClass.accessory[1] == -1
addAdditionalBitmap(oldfilepath+"accessories/"+(trainerClass.accessory[0]).to_s+
($player.gender+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"accessories/"+(trainerClass.accessory[0]).to_s+
"/"+(trainerClass.accessory[1]).to_s+($player.gender+65).chr+".png",bmp)
end
# Adding Hair Bitmap
if trainerClass.hair[1] == -1
addAdditionalBitmap(oldfilepath+"hair/"+(trainerClass.hair[0]).to_s+
($player.gender+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"hair/"+(trainerClass.hair[0]).to_s+
"/"+(trainerClass.hair[1]).to_s+($player.gender+65).chr+".png",bmp)
end
# Adding Headgear Bitmap
if trainerClass.headgear[1] == -1
addAdditionalBitmap(oldfilepath+"headgear/"+(trainerClass.headgear[0]).to_s+
($player.gender+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"headgear/"+(trainerClass.headgear[0]).to_s+
"/"+(trainerClass.headgear[1]).to_s+($player.gender+65).chr+".png",bmp)
end
end
 
# saves a specific bitmap to a given folder.
def saveCustomizedBitmapToFolder(filepath,folder)
return if !$player
return if !filepath.is_a?(String) || !folder.is_a?(String)
bmp=Bitmap.new(filepath)
# Safety Copy
if !File.exists?(filepath+"_safetyCopy"+".png") && $DEBUG
safetyCopy=Bitmap.new(filepath)
safetyCopy.save_to_png(filepath+"_safetyCopy"+".png")
end
# Deleting old file
if !USE_BASE_GRAPHIC
bmp.clear
end
drawCharacterCustomizedBitmap(folder,bmp)
bmp.save_to_png(filepath+"_curr.png")
end
 
# saves the costumized bitmaps to the actual game folders.
def saveAllCustomizedBitmapsToFolder
return if !$player
# Trainer charsets
meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
filenames=[pbGetPlayerCharset(meta.walk_charset),pbGetPlayerCharset(meta.run_charset),pbGetPlayerCharset(meta.cycle_charset),pbGetPlayerCharset(meta.surf_fish_charset),pbGetPlayerCharset(meta.fish_charset)]
for i in 0...filenames.length
if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
filepath="Graphics/Characters/#{filenames[i]}"
folder=SPRITE_CONVERT_HASH[filenames[i]]
saveCustomizedBitmapToFolder(filepath,folder)
end
end
# Trainer backsprite
helpr="trback00#{$player&.character_ID}"
filepath="Graphics/Trainers/"
folder=SPRITE_CONVERT_HASH[helpr]
saveCustomizedBitmapToFolder(filepath+helpr,folder)
# Intro Image/Trainercard Image
filepath="Graphics/Pictures/"
helpr=$player.female? ? "introGirl" : "introBoy" #Modify this line if you want more than two characters.
folder=SPRITE_CONVERT_HASH[helpr]
saveCustomizedBitmapToFolder(filepath+helpr,folder)
# Map Player
helpr="mapPlayer00#{$player&.character_ID}"
folder=SPRITE_CONVERT_HASH[helpr]
saveCustomizedBitmapToFolder(filepath+helpr,folder)
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
