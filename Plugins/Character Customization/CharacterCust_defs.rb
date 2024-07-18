#Checks whether or not a trainer has been defined.
def pbTrainerNotDefined
if !defined?($player)
if $DEBUG
Kernel.pbMessage("The player is not a Trainer at this point. Implement the script into your game after you call the script pbTrainerName in your intro event.")
end
return true
else
return false
end
end
 
 
def pbFullCustomization
$game_temp.savedoutfit = false
updateTrainerOutfit
pbChooseBaseGraphic
pbCustomizeCharacter

end


#Character Customization Script game designer can use
def pbCustomizeCharacter
CharacterCustomizationScene.new
end
 
#Script in which the player can choose the base graphic they will use for their
# character.
#Can be used to choose your player's skin tone.
#Should be used after the player selects their name and gender (or character).
def pbChooseBaseGraphic
ChooseBase.new
end
 
# Method for changing a certain item. Used by game designer
# item: String representing item player will put on.
# variant (Use when accessory has variants): The variant of the item to be put on.
def pbDressAccessory(item,variant=nil)
dressAccessory(item,variant)
end
 
# Gives the player randomized clothes (e.g good thing for randomizer challenges)
def pbRandomizeOutfit
return false if pbTrainerNotDefined
for i in 0...5 #0 to Number of bodyparts (change if adding/deleting bodyparts)
randomizeOutfitHelper(i)
end
saveAllCustomizedBitmapsToFolder
updateTrainerOutfit
$game_temp.savedoutfit = false
end
 


 

#
 
#==================================================================================
# * Complete code of methods game designer calls
#==================================================================================


   
   
   

 def pbGetCustomCharset(ret)
  if pbResolveBitmap("Graphics/Characters/" + ret + ($player.gender+65).chr + ".png")
    ret = ret + ($player.gender+65).chr + ".png"
  end
  return ret
end


# Method to add an additional bitmap to another bitmap.
def addAdditionalBitmap2(filepath,formerBitmap)
if File.exists?(filepath)
formerBitmap.blt(0,0,Bitmap.new(filepath),Rect.new(0,0,Graphics.width,Graphics.height))
end
return formerBitmap
end
 
#Draws a specific bitmap for the player sprite.
def drawCharacterCustomizedBitmap2(folder,folder2,bmp,trainerClass=$player)
return nil if !folder.is_a?(String)
return bmp if !trainerClass
basefilepath = "Graphics/Plugins/Character Customization/"+folder2+"/base graphics/"+folder+"/"
if trainerClass.base!="None"
bmp = addAdditionalBitmap2(basefilepath + trainerClass.base[1],bmp)
end
oldfilepath = "Graphics/Plugins/Character Customization/"+folder2+"/"+folder+"/"
# Adding Bottom Bitmap
if trainerClass.bottom!="None"
bmp = addAdditionalBitmap2(oldfilepath + trainerClass.bottom[1] + "/"+trainerClass.bottom[2] + "/"+trainerClass.bottom[3] ,bmp)
end
# Adding Top Bitmap
if trainerClass.top!="None"
bmp = addAdditionalBitmap2(oldfilepath + trainerClass.top[1] + "/"+trainerClass.top[2] + "/"+trainerClass.top[3] ,bmp)
end
# Adding Accessory Bitmap
if trainerClass.accessory!="None"
bmp = addAdditionalBitmap2(oldfilepath + trainerClass.accessory[1] + "/" +trainerClass.accessory[2] + trainerClass.accessory[3] ,bmp)
end
# Adding Hair Bitmap
if trainerClass.hair!="None"
addAdditionalBitmap2(oldfilepath + trainerClass.hair[1] + "/" + trainerClass.hair[2] + "/" + trainerClass.hair[3] ,bmp)
end
# Adding Headgear Bitmap
if trainerClass.headgear!="None"
addAdditionalBitmap2(oldfilepath + trainerClass.headgear[1] + "/" + trainerClass.headgear[2] + "/" + trainerClass.headgear[3] ,bmp)
end

return bmp
end



# This method updates the trainer outfit
def updateTrainerOutfit
next_id=($player.gender==1 ? CustomCharacterSettings::CHARACTERIDS[1] : CustomCharacterSettings::CHARACTERIDS[0])
main_id=($player.gender==0 ? CustomCharacterSettings::CHARACTERIDS[0] : CustomCharacterSettings::CHARACTERIDS[1])
id=$player&.character_ID
pbChangePlayer(next_id)
pbWait(1)
if CustomCharacterSettings::CHARACTERIDS.include?(id)
pbChangePlayer(id)
else
pbChangePlayer(main_id)
end
end


def pbBuildCharset
   data = buildwalkscreen
  return data
end

def buildwalkscreen
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base[0] + "/base graphics/overworld walk/" + $player.base[1]
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld walk",$player.base[0],bmp)
   item = bmp.save_to_png("Graphics/Characters/#{getFilenames[0]}"+"_curr.png")
   refreshPlayerSprite("Graphics/Characters/","#{getFilenames[0]}_curr.png")
   return getFilenames[0]+"_curr.png"
end
end


def pbBuildCharsetandUpdateMain
    buildwalk
    #buildcycle
    #buildsurf
    #builddive
    #buildfish
    #buildsurffish
    #buildtrainerback
    #buildtrainerfront
    #buildtrainermap
 end

def refreshPlayerSprite(path,filename)
   pbMoveRoute($game_player, [PBMoveRoute::Graphic," ",0,$game_player.direction,0])
   RPG::Cache.forget(path,filename)
   RPG::Cache.retain(path,filename)
   pbMoveRoute($game_player, [PBMoveRoute::Graphic,filename,0,$game_player.direction,0])
end

 

def buildwalk
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base[0] + "/base graphics/overworld walk/" + $player.base[1]
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld walk",$player.base[0],bmp)
   item = bmp.save_to_png("Graphics/Characters/#{getFilenames[0]}"+".png")
   refreshPlayerSprite("Graphics/Characters/","#{getFilenames[0]}.png")
   return getFilenames[0]
end
end

def buildrun
  bitmap = "Graphics/Characters/base graphics/overworld run/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld run",bmp)
   item = bmp.save_to_png(getFilenames[1]+".png")
   refreshPlayerSprite("Graphics/Characters/#{getFilenames[1]}.png")
   return getFilenames[1]
end
end

def buildcycle
  bitmap = "Graphics/Characters/base graphics/overworld bike/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld bike",bmp)
   item = bmp.save_to_png(getFilenames[2]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[2]}.png")
   return getFilenames[2]
end
end

def buildsurf
  bitmap = "Graphics/Characters/base graphics/overworld surf/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld surf",bmp)
   item = bmp.save_to_png(getFilenames[3]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[3]}.png")
   return getFilenames[3]
end
end

def builddive
  bitmap = "Graphics/Characters/base graphics/overworld dive/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld dive",bmp)
   item = bmp.save_to_png(getFilenames[4]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[4]}.png")
   return getFilenames[4]
end
end

def buildfish
  bitmap = "Graphics/Characters/base graphics/overworld fish/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld fish",bmp)
   item = bmp.save_to_png(getFilenames[5]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[5]}.png")
   return getFilenames[5]
end
end

def buildsurffish
  bitmap = "Graphics/Characters/base graphics/overworld fishsurf/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("overworld fishsurf",bmp)
   item = bmp.save_to_png(getFilenames[6]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[6]}.png")
   return getFilenames[6]
end
end

def buildtrainerback
  bitmap = "Graphics/Characters/base graphics/trainer back/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("trainer back",bmp)
   item = bmp.save_to_png(getFilenames[7]+".png")
   RPG::Cache.forget("Graphics/Trainers/#{getFilenames[7]}")
   return getFilenames[7]
  end
end

def buildtrainerfront
  bitmap = "Graphics/Characters/base graphics/trainer front/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("trainer front",bmp)
   item = bmp.save_to_png(getFilenames[9]+".png")
   RPG::Cache.forget("Graphics/Trainers/#{getFilenames[8]}")
   return getFilenames[8]
  end
end
  
  
def buildtrainermap
  bitmap = "Graphics/Characters/base graphics/trainer map/" + $player.base.to_s + ($player.gender+65).chr
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap2("trainer map",bmp)
   item = bmp.save_to_png(getFilenames[9]+".png")
   RPG::Cache.forget("Graphics/Pictures/#{getFilenames[9]}")
   return getFilenames[9]
  end
end

def getFilenames
meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
filenames=[pbGetPlayerCharset(meta.walk_charset),pbGetPlayerCharset(meta.run_charset),pbGetPlayerCharset(meta.cycle_charset),pbGetPlayerCharset(meta.surf_charset),
pbGetPlayerCharset(meta.dive_charset),pbGetPlayerCharset(meta.fish_charset),pbGetPlayerCharset(meta.surf_fish_charset),GameData::TrainerType.player_front_sprite_filename(meta.trainer_type),GameData::TrainerType.player_back_sprite_filename(meta.trainer_type),
GameData::TrainerType.player_map_icon_filename(meta.trainer_type)]
filenames = filenames.compact
filenames2 = []
filenames.each do |file|
file = file.gsub(/\.png/,"")
filenames2 << file
end
return filenames2
end
