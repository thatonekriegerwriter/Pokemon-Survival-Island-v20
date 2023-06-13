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
 
# Given a string and a bool, returns an array and a var representing the array number.
# accessory: A string representing an item in the array that the user wants to access.
# convertation: A Bool which determines whether or not the names specific to a
# players gender are returned (true), or the entire array (false).
def retArrayAndNumber(accessory,convertation=true)
(bodypart=HAIR_ITEMS; var=1) if cnvrtStrArr(HAIR_ITEMS).include?(accessory)
(bodypart=TOP_ITEMS; var=2) if cnvrtStrArr(TOP_ITEMS).include?(accessory)
(bodypart=BOTTOM_ITEMS; var=3) if cnvrtStrArr(BOTTOM_ITEMS).include?(accessory)
(bodypart=HEADGEAR_ITEMS; var=4) if cnvrtStrArr(HEADGEAR_ITEMS).include?(accessory)
(bodypart=ACCESSORY_ITEMS; var=5) if cnvrtStrArr(ACCESSORY_ITEMS).include?(accessory)
return [cnvrtStrArr(bodypart),var] if convertation
return [bodypart,var]
end
 
# Returns a boolean indicating if the character can be customized given settings
# set by the creator and the player's current state.
def characterizationException
return true if CHARACTER_CUSTOMIZATION==false
return true if UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT==false &&
$player.character_customization==false
return true if !$player
return true if !$player.hair
return false
end
 
# Creates a new array from the items specific to the player's gender.
# array: An array representing the options for a specific component of the outfit
# characterization of the character (ie. HAIR_ITEMS)
def cnvrtStrArr(array)
ret=[]
for i in 0...array.length
ret.push(array[i][0][$player&.character_ID])
end
return ret
end
 
#cnvrtBoolArr: Creates a new array with only the booleans which define the items within the array.
#array: An array representing the options for a specific component of the outfit characterization of the character (ie. HAIR_ITEMS)
#output: A boolean array representing which items within the component array are locked and unlocked; represented by booleans.
def cnvrtBoolArr(array)
ret=[]
for i in 0...array.length
if ((array[i][1] == true) || (array[i][1] == false))
ret.push(array[i][1])
else
ret[i]=[]
for j in 0...array[i][1].length
ret[i].push(array[i][1][j][1])
end
end
end
return ret
end
 
#Creates a new array with only the unlocked elements of the given array.
#clothes: One of the arrays defining the gendered items and properties for
# a specific attribute (ie. cnvrtStrArr(HEADGEAR_ITEMS))
def retUnlockedAccessoryArray(clothes)
arr=retArrayAndNumber(clothes[0])
var=arr[1]
ret=[]
for i in 0...clothes.length
if ($player.clothesUnlocking[var-1][i]==false || $player.clothesUnlocking[var-1][i]==true)
ret.push clothes[i] if $player.clothesUnlocking[var-1][i]==true
else
check=false
for j in 0...$player.clothesUnlocking[var-1][i].length
check=(check||$player.clothesUnlocking[var-1][i][j])
endclothesUnlocking
ret.push clothes[i] if check
end
end
if ret[0].nil?
 ret[0] = "[NONE]"
end
return ret
end
end
#Creates a new array with only the unlocked elements of the given array.
#clothes: One of the arrays defining the gendered items and properties for
# a specific attribute (ie. cnvrtStrArr(HEADGEAR_ITEMS))
def retUnlockedAccessoryArray2(clothes,itemnum)
arr=retArrayAndNumber(clothes[0],false)
var=arr[1]
ret=[]
for i in 0...arr[0][itemnum][1].length
if $player.clothesUnlocking[var-1][itemnum][i]
ret.push arr[0][itemnum][1][i][0]
end
end
if ret[0].nil?
 ret[0] = "[NONE]"
end
return ret
end
 
#Fetches the file names corresponding to a given array.
#files: An array where all the file names will be stored. Should be the empty array initially
#array: An array of clothing items (ie. HAIR_ITEMS)
#folder: The folder from which these file names will correspond to.
def individualArrayFiles(files,array,folder)
for i in 0...array.length
if ((array[i][1] == true) || (array[i][1] == false))
files.push(folder+"/#{i}"+($player&.character_ID+65).chr)
else
for j in 0...array[i][1].length
files.push(folder+"/#{i}/#{j}"+($player&.character_ID+65).chr)
end
end
end
end
 
# checks whether or not an inputed array is multi-dimensional at a given index.
# arr: An array of clothing items (ie. HAIR_ITEMS)
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
arr=HAIR_ITEMS if bodypart==0
arr=TOP_ITEMS if bodypart==1
arr=BOTTOM_ITEMS if bodypart==2
arr=HEADGEAR_ITEMS if bodypart==3
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
# Adding Bottom Bitmap
if trainerClass.bottom[1] == -1
addAdditionalBitmap(oldfilepath+"bottoms/"+(trainerClass.bottom[0]).to_s+
($player&.character_ID+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"bottoms/"+(trainerClass.bottom[0]).to_s+
"/"+(trainerClass.bottom[1]).to_s+($player&.character_ID+65).chr+".png",bmp)
end
# Adding Top Bitmap
if trainerClass.top[1] == -1
addAdditionalBitmap(oldfilepath+"tops/"+(trainerClass.top[0]).to_s+
($player&.character_ID+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"tops/"+(trainerClass.top[0]).to_s+
"/"+(trainerClass.top[1]).to_s+($player&.character_ID+65).chr+".png",bmp)
end
# Adding Accessory Bitmap
if trainerClass.accessory[1] == -1
addAdditionalBitmap(oldfilepath+"accessories/"+(trainerClass.accessory[0]).to_s+
($player&.character_ID+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"accessories/"+(trainerClass.accessory[0]).to_s+
"/"+(trainerClass.accessory[1]).to_s+($player&.character_ID+65).chr+".png",bmp)
end
# Adding Hair Bitmap
if trainerClass.hair[1] == -1
addAdditionalBitmap(oldfilepath+"hair/"+(trainerClass.hair[0]).to_s+
($player&.character_ID+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"hair/"+(trainerClass.hair[0]).to_s+
"/"+(trainerClass.hair[1]).to_s+($player&.character_ID+65).chr+".png",bmp)
end
# Adding Headgear Bitmap
if trainerClass.headgear[1] == -1
addAdditionalBitmap(oldfilepath+"headgear/"+(trainerClass.headgear[0]).to_s+
($player&.character_ID+65).chr+".png",bmp)
else
addAdditionalBitmap(oldfilepath+"headgear/"+(trainerClass.headgear[0]).to_s+
"/"+(trainerClass.headgear[1]).to_s+($player&.character_ID+65).chr+".png",bmp)
end
end
 
# saves a specific bitmap to a given folder.
def saveCustomizedBitmapToFolder(filepath,folder)
return if !$player
return if !filepath.is_a?(String) || !folder.is_a?(String)
if !USE_BASE_GRAPHIC
bmp=Bitmap.new(filepath)
else
bmp=Bitmap.new(filepath+"_base")
end
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
 
 
#==============================================================================================
# Influences how the metadata is called so that an outfit is temporarily stored when changed.
#==============================================================================================
 
def pbGetMetadata(mapid,metadataType)
meta=pbLoadMetadata
if (mapid == 0) && (metadataType >= MetadataPlayerA) && (metadataType < MetadataPlayerA+7) && ($game_temp.savedoutfit == false)
ret=[]
ret.push(meta[mapid][metadataType][0])
for i in 1...meta[mapid][metadataType].length
ret.push(meta[mapid][metadataType][i]+"_curr")
end
return ret
else
return meta[mapid][metadataType] if meta[mapid]
return nil
end
end
 
def pbTrainerHeadFile(type)
return nil if !type
bitmapFileName = sprintf("Graphics/Pictures/mapPlayer%s",getConstantName(PBTrainers,type)) rescue nil
if !pbResolveBitmap(bitmapFileName) && $game_temp.savedoutfit
bitmapFileName = sprintf("Graphics/Pictures/mapPlayer%03d",type)
elsif !pbResolveBitmap(bitmapFileName)
sprintf("Graphics/Pictures/mapPlayer%03d_curr",type)
end
return bitmapFileName
end
 
def pbTrainerSpriteFile(type)
return nil if !type
bitmapFileName = sprintf("Graphics/Characters/trainer%s",getConstantName(PBTrainers,type)) rescue nil
if !pbResolveBitmap(bitmapFileName) && $game_temp.savedoutfit
bitmapFileName = sprintf("Graphics/Characters/trainer%03d",type)
elsif !pbResolveBitmap(bitmapFileName)
bitmapFileName = sprintf("Graphics/Characters/trainer%03d_curr",type)
end
return bitmapFileName
end
 
def pbTrainerSpriteBackFile(type)
return nil if !type
bitmapFileName = sprintf("Graphics/Trainers/trback%s",getConstantName(PBTrainers,type)) rescue nil
if !pbResolveBitmap(bitmapFileName) && $game_temp.savedoutfit
bitmapFileName = sprintf("Graphics/Trainers/trback%03d",type)
elsif !pbResolveBitmap(bitmapFileName)
bitmapFileName = sprintf("Graphics/Trainers/trback%03d_curr",type)
end
return bitmapFileName
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
 
#===============================================================================
# * Edit to the class Game_Player to erase the .png extension in the name.
#===============================================================================
=begin
class Game_Player
def character_name
if !@defaultCharacterName
@defaultCharacterName=""
end
if @defaultCharacterName!=""
return @defaultCharacterName.gsub(/\0/,"v")#(/\.png/,"")
end
if !moving? && !@move_route_forcing && $PokemonGlobal
meta=pbGetMetadata(0,MetadataPlayerA+$player&.character_ID)
if $player&.character_ID>=0 && meta &&
!$PokemonGlobal.bicycle && !$PokemonGlobal.diving && !$PokemonGlobal.surfing
if meta[4] && meta[4]!="" && Input.dir4!=0 && passable?(@x,@y,Input.dir4) && pbCanRun?
# Display running character sprite
@character_name=pbGetPlayerCharset(meta,4)
else
# Display normal character sprite
@character_name=pbGetPlayerCharset(meta,1)
end
end
end
return @character_name.gsub(/\.png/,"")
end
end
=end 