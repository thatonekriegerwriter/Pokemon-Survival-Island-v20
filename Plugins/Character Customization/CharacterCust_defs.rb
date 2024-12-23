#Checks whether or not a trainer has been defined.
def pbTrainerNotDefined
if !defined?($player)
if $DEBUG
pbMessage("The player is not a Trainer at this point. Implement the script into your game after you call the script pbTrainerName in your intro event.")
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
def addAdditionalBitmap(filepath,formerBitmap)
puts filepath
puts File.exists?(filepath)
if File.exists?(filepath)
formerBitmap.blt(0,0,Bitmap.new(filepath),Rect.new(0,0,Graphics.width,Graphics.height))
end
return formerBitmap
end
 
#Draws a specific bitmap for the player sprite.
def drawCharacterCustomizedBitmap(folder,folder2,bmp,player=$player)
return nil if !folder.is_a?(String)
return bmp if !player
basefilepath = "Graphics/Plugins/Character Customization/"+folder2+"/base graphics/"+folder+"/"
if !player.base.nil?
bmp = addAdditionalBitmap(basefilepath + player.base.image,bmp)
end
oldfilepath = "Graphics/Plugins/Character Customization/"+folder2+"/"+folder+"/"
# Adding Bottom Bitmap
if !player.bottom.nil?
filepath = "Graphics/Plugins/Character Customization/" + player.bottom.pack + "/" + folder + "/"
bmp = addAdditionalBitmap(filepath + player.bottom.folder + "/"+player.bottom.style + "/"+player.bottom.image ,bmp)
end
# Adding Top Bitmap
if !player.top.nil?
filepath = "Graphics/Plugins/Character Customization/" + player.top.pack + "/" + folder + "/"
bmp = addAdditionalBitmap(filepath + player.top.folder + "/"+player.top.style + "/"+player.top.image ,bmp)
end
# Adding Hair Bitmap
if !player.hair.nil?
filepath = "Graphics/Plugins/Character Customization/" + player.hair.pack + "/" + folder + "/"
addAdditionalBitmap(filepath + player.hair.folder + "/" + player.hair.style + "/" + player.hair.image ,bmp)
end
# Adding Headgear Bitmap
if !player.headgear.nil?
filepath = "Graphics/Plugins/Character Customization/" + player.headgear.pack + "/" + folder + "/"
addAdditionalBitmap(filepath + player.headgear.folder + "/" + player.headgear.style + "/" + player.headgear.image ,bmp)
end
# Adding Accessory Bitmap
if !player.accessory.nil?
filepath = "Graphics/Plugins/Character Customization/" + player.accessory.pack + "/" + folder + "/"

bmp = addAdditionalBitmap(filepath + player.accessory.folder + "/" +player.accessory.style + "/" + player.accessory.image ,bmp)
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
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   filename = "#{getFilenames[0]}_curr.png"
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld walk",$player.base.pack,bmp)
   item = bmp.save_to_png("Graphics/Characters/#{filename}")
   refreshPlayerSprite("Graphics/Characters/",filename)
   return filename
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
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld walk",$player.base.pack,bmp)
   item = bmp.save_to_png("Graphics/Characters/#{getFilenames[0]}"+".png")
   refreshPlayerSprite("Graphics/Characters/","#{getFilenames[0]}.png")
   return getFilenames[0]
end
end

def buildrun
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld run",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[1]+".png")
   refreshPlayerSprite("Graphics/Characters/#{getFilenames[1]}.png")
   return getFilenames[1]
end
end

def buildcycle
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld bike",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[2]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[2]}.png")
   return getFilenames[2]
end
end

def buildsurf
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld surf",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[3]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[3]}.png")
   return getFilenames[3]
end
end

def builddive
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld dive",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[4]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[4]}.png")
   return getFilenames[4]
end
end

def buildfish
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld fish",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[5]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[5]}.png")
   return getFilenames[5]
end
end

def buildsurffish
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("overworld fishsurf",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[6]+".png")
   RPG::Cache.forget("Graphics/Characters/#{getFilenames[6]}.png")
   return getFilenames[6]
end
end

def buildtrainerback
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("trainer back",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[7]+".png")
   RPG::Cache.forget("Graphics/Trainers/#{getFilenames[7]}")
   return getFilenames[7]
  end
end

def buildtrainerfront
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("trainer front",$player.base.pack,bmp)
   item = bmp.save_to_png(getFilenames[9]+".png")
   RPG::Cache.forget("Graphics/Trainers/#{getFilenames[8]}")
   return getFilenames[8]
  end
end
  
def buildtrainermap
  bitmap = "Graphics/Plugins/Character Customization/" + $player.base.pack + "/base graphics/overworld walk/" + $player.base.image
  if pbResolveBitmap(bitmap)
   bmp=Bitmap.new(bitmap)
   bmp = drawCharacterCustomizedBitmap("trainer map",$player.base.pack,bmp)
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
