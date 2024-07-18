#===============================================================================
# * Character Costumization by Wolf Heretic
# * Based Heavily on a script by shiney570
# Version: 2.0.0
#===============================================================================
#
# NOTES:
# - Do not name two different items the same name. (Ie. If I have a headgear item
# called Ring and an accessory called Ring, this will lead to undefined behavior
# and could make your game crash)
# - You cannot lock all of the items for some bodypart. This will cause the game
# to crash in the characterization screen.
# - This script alters how a character's metadata is called and how the game loads
# and saves data. Be aware of this ifyou're using other scripts which edit these
# aspects of default essentials.
# - pbChooseBaseGraphic should only be called after the player's character (In
# default essentials gender) and name are defined.
#
# Set to false to disable the Character Customization.
CHARACTER_CUSTOMIZATION = true
# Set to false to lock the Character Customization to unlock it manually at a
# point later in the game.
UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT = true
# whether to also fusion the base graphic or not. Remember:
USE_BASE_GRAPHIC = false

module CustomCharacterSettings
CHARACTERIDS = [11,12]



end
=begin
ROUGH EXPLANATION FOR CLOTHING ARRAYS:
When setting up the arrays below, its important to note the following structure
of the arrays representing the possible costumes a player can equip.
 
1. The initial array describes the Bodypart (ie. Hair, Top, Accessories).
It is an array which is made up of multiple "Items", or subarrays representing
each item that can be equipped by the player.
 
2. The second layer describes each item (Ie. For Headgear, the items could be
glasses, a tophat, and a helmet). Each item is an array with two entries, the
"Names" of the item for each character(in default essentials each gender) and
either a "Variant" array representing the different types/colors of the item the
player can equip or a boolean representing whether the item is unlocked by default.
a. Names: An array of strings representing the names of an item for different
characters. The number of names in this array should equal the number
of characters your game has. In default essentials, there are two characters (Male character
& female), so if you haven't changed that there should be two names in this array.
b. Variant: Is optional. If the player only wants one version of the item, instead
of writing an array they should write either true or false for whether they want
the item initially unlocked. Variant is explained in more detail next.
 
3. The third layer describes each variant of the previous item, if there is more
than one (Ie. If the item selected was a T-shirt, then the variants could be Blue,
Red, Yellow, etc. for each color of the T-shirt). Each variant array consists of
the name of the variant and a boolean representing whether the variant of that
item is unlocked by default.
a. Name: The name of the variant (ie. "Orange"). Should be a string.
b. Unlocked?: A true or false value representing whether or not this specific
variant should be unlocked initially.
 
Also here's a diagram for what everything all of the items consist of
 
[ Bodypart ]
||
\/
[Item[0], Item[1],...]
||
\/
[Names, Variants(Optional)]
|| ||
\/ \/
[BoyName,GirlName] [Variant[0], Variant[1],...]
(Default Essentials) ||
\/
[Name, Unlocked?]
 
Hope this helped! If not then maybe you can get something from the initial
arrays down below.
 
=end
 
# Names of the hairstyles in order. (true= unlocked by default, false=locked by default)
HAIR_ITEMS=[
[["Bald", "Bald"], true],
[["Spikey", "Long"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
["Red",false], ["White",true]]],
[["Short", "Short"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
["Red",false], ["White",true]]],
[["Medium", "Medium"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
["Red",false], ["White",true]]],
[["Slicked Back", "Ponytail"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
["Red",false], ["White",true]]]
]
 
# Names of the top items in order. (true= unlocked by default, false=locked by default)
TOP_ITEMS=[
[["No Top","No Top"],true],
[["Beach Top","Beach Top"], [["Black",false],["Blue",false],["Green",false],["Pink",false],
["Red",false]]],
[["Classy Top","Classy Top"], [["Beige",false],["Black",false],["Grey",false],
["Navy",false], ["Wine",false]]],
[["Collared Shirt","Collared Shirt"], [["Black",true], ["Light Blue",true], ["Navy",true],
["White",true], ["Wine",true]]],
[["Formal Top","Formal Top"], [["Black",true], ["Beige",true], ["Blue",true],
["Pink",true], ["Red",true]]],
[["Hoodie","Hoodie"], [["Black",true], ["Blue",true], ["Green",true], ["Purple",true],
["Red",true]]],
[["Jumpsuit Top","Jumpsuit Top"], [["Black",true], ["Blue",true], ["Green",true],
["Red",true], ["Yellow",true]]],
[["Alternate Jumpsuit Top","Alternate Jumpsuit Top"], [["Blue",false],["Green",false],
["Red",false], ["Black",false], ["Yellow",false]]],
[["Lord Suit Top","Lord Suit Top"], [["Purple",false],["Red",false]]],
[["Open Jacket","Open Jacket"], [["Blue",true], ["Green",true], ["Orange",true],
["Pink",true], ["Red",true]]],
[["Scarf Shirt","Scarf Shirt"], [["Black",true], ["Blue",true], ["Brown",true],
["Red",true], ["Yellow",true]]],
[["Schoolboy Top","Schoolgirl Top"], [["Light",false],["Dark",false]]],
[["Shirt Combo","Shirt Combo"], [["Black",true], ["Blue",true], ["Red",true],
["White",true], ["Wine",true]]],
[["Tank Top","Tank Top"], [["Black",true], ["Green",true], ["Navy",true],
["Pink",true], ["Red",true]]],
[["Trenchcoat","Trenchcoat"], [["Beige",true], ["Black",true], ["Navy",true],
["Purple",true], ["Red",true]]],
[["T-Shirt","T-Shirt"], [["Black",true], ["Blue",true], ["Green",true], ["Red",true],
["White",true]]],
[["Turtleneck","Turtleneck"], [["Beige",false], ["Black",false], ["Green",false],
["White",false], ["Wine",false]]],
[["Vest","Vest"], [["Black",false], ["Blue",false], ["Brown",false], ["Grey",false],
["Wine",false]]],
[["V-Neck","V-Neck"], [["Black",true], ["Green",true], ["Orange",true], ["Purple",true],
["Yellow",true]]]
]
 
# Names of the bottoms in order. (true= unlocked by default, false=locked by default)
BOTTOM_ITEMS=[
[["No Bottom","No Bottom"],true],
[["Beach Bottom","Beach Bottom"], [["Black",false],["Blue",false],["Green",false],
["Pink",false], ["Red",false]]],
[["Capris","Capris"], [["Aqua",true], ["Beige",true], ["Black",true], ["Green",true],
["Navy",true]]],
[["Classy Bottom","Classy Bottom"], [["Beige",false],["Black",false],["Grey",false],
["Navy",false], ["Wine",false]]],
[["Formal Bottom","Formal Bottom"], [["Black",true], ["Blue",true], ["Brown",true],
["Grey",true], ["Pink",true]]],
[["Jeans","Jeans"], [["Aqua",true], ["Black",true], ["Grey",true], ["Light Blue",true],
["Navy",true]]],
[["Jumpsuit Pants","Jumpsuit Pants"], [["Black",true], ["Blue",true], ["Green",true],
["Red",true], ["Yellow",true]]],
[["Alternate Jumpsuit Pants","Alternate Jumpsuit Pants"], [["Blue",false],
["Green",false], ["Red",false], ["Black",false], ["Yellow",false]]],
[["Lord Suit Pants","Lord Suit Pants"], false],
[["Long Skirt","Long Skirt"], [["Black",true], ["Blue",true], ["Green",true],
["Pink",true], ["Purple",true]]],
[["Pants & Boots","Pants & Boots"], [["Beige",true], ["Black",true], ["Grey",true],
["Light Blue",true], ["Navy",true]]],
[["Pencil Skirt","Pencil Skirt"], [["Black",true], ["Green",true], ["Grey",true],
["Navy",true], ["Wine",true]]],
[["Ribbon Skirt","Ribbon Skirt"], [["Blue",false], ["Green",false], ["Pink",false],
["Red",false], ["Black",false]]],
[["Schoolboy Pants","Schoolgirl Skirt"], [["Light",false],["Dark",false]]],
[["Shorts","Shorts"], [["Black",true], ["Blue",true], ["Green",true],
["Red",true], ["White",true]]],
]
 
# Names of the headgear in order. (true= unlocked by default, false=locked by default)
HEADGEAR_ITEMS=[
[["No Headgear", "No Headgear"], true],
[["Beanie","Beanie"], [["Black",true],["Purple",true]]],
[["Glasses","Glasses"],[["Blue",true],["Red",true]]],
[["Youngster Cap","Youngster Cap"],[["Yellow",true],["Blue",true]]],
[["Bonnet","Bonnet"],true],
[["Feather Hat","Feather Hat"],true],
[["Fedora","Fedora"],true],
[["Ribbon","Ribbon"],true],
[["Straw Hat","Straw Hat"],true],
[["Sun Hat","Sun Hat"],true],
[["Crown","Crown"], [["Gold",false],["Silver",false]]],
[["Flower","Flower"], [["Blue",false],["Red",false]]],
[["Beret","Beret"],false],
[["Cat","Cat"],false],
[["Devil","Devil"],false],
[["Hair Band","Hair Band"],false],
[["Head Band","Head Band"],false],
[["Miner Helmet","Miner Helmet"],false],
[["Poop","Poop"],false]
]
 
# Names of the accessories in order. (true= unlocked by default, false=locked by default)
ACCESSORY_ITEMS=[
[["No Accessory", "No Accessory"],true],
[["Bag","Bag"], [["Black",true], ["Blue",true], ["Green",true], ["Magenta",true],
["Orange",true], ["Purple",true], ["Red",true], ["White",true], ["Yellow",true]]],
[["Rucksack","Rucksack"], [["Black",true], ["Blue",true], ["Green",true], ["Magenta",true],
["Orange",true], ["Purple",true], ["Red",true], ["White",true], ["Yellow",true]]],
[["Sporty Backpack","Sporty Backpack"], [["Black",true], ["Blue",true], ["Green",true],
["Magenta",true], ["Orange",true], ["Purple",true], ["Red",true], ["White",true],
["Yellow",true]]]
] 
#==================================================================================
#This section defines the Base graphic names with a double array. Each item in the
# initial array represents each base, while the number of items in those base arrays
# is the base name for each character (In default essentials, for boy and girl).


BASE_GRAPHICS=["Pale","Fair","Tanned","Dark"]
 
#==================================================================================
 
#This hash specifies which folders certain character sprites will be retrieved from
# when making new character sprites.
#Update this whenever the player has added another sprite sheet for a character
# (ie. if a player had a specific swimming sprite sheet)
SPRITE_CONVERT_HASH = { "trchar000" => "overworld walk",
"boy_bike" => "overworld bike",
"boy_surf" => "overworld surf", #changed for V17.2
"boy_run" => "overworld run",
"boy_dive_offset" => "overworld dive",
"boy_fish_offset" => "overworld fish",
"boy_fishsurf_offset" => "overworld fishsurf",
"trback000" => "trainer back",
"introBoy" => "trainer front",
"mapPlayer000" => "trainer map",
"trchar001" => "overworld walk",
"girl_bike" => "overworld bike",
"girl_surf" => "overworld surf", #changed for V17.2
"girl_run" => "overworld run",
"girl_dive_offset" => "overworld dive",
"girl_fish_offset" => "overworld fish",
"girl_fishsurf_offset" => "overworld fishsurf",
"trback001" => "trainer back",
"introGirl" => "trainer front",
"mapPlayer001" => "trainer map"}

SPRITE_CONVERT_ARRAY = ["overworld walk","overworld bike","overworld surf","overworld run","overworld dive","overworld fish",
"overworld fishsurf","trainer back","trainer front","trainer map"]

 
WALK_FOLDER = "overworld walk"
 

#==================================================================================
# * Character Customization Scene
#==================================================================================

 
class CharacterCustomizationScene
 
def initialize
@meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
@savegetup = true
if !defined?($player.clothesUnlocking) # Checks if the Script is functional.
Kernel.pbMessage("Your game is missing some Variables of the Character Costumization Script. In order to fix this you'll need to save the game.")
if Kernel.pbConfirmMessage("Would you like to save the game now?")
if !$player
Kernel.pbMessage("Unable to save the game since the player is not a trainer at this point. Do not use the CharacterCustomization Script before you call the script pbTrainerName in your intro event.")
else
pbSave
Kernel.pbMessage("The game was saved, try again now.")
end
end
return
end
if $game_temp.savedoutfit == false
$game_temp.savedoutfit = true
@savegetup = false
end
return if !addNecessaryFiles
if @savegetup.nil?
 @savegetup = false
end
if @savegetup == false
$game_temp.savedoutfit = false
end


@index=0
@index2=0
@indexR=-1
@new_val=2


@firstSelection=true 
@secondSelection=true
@selectionChange=false



@sprites={}
@sprites["background"]=IconSprite.new(0,0,@viewport)
@sprites["background"].setBitmap("Graphics/Pictures/loadslotsbg")
@accessoryNames=["hair","tops","bottoms","headgear","accessories"]
@viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
@viewport.z=99999
@sprites["window"]=SpriteWindow_Base.new(Graphics.width/2-64,Graphics.height/2-128,128,128)
@sprites["window2"]=SpriteWindow_Base.new(Graphics.width/2-64,Graphics.height/2,128,128)
@sprites["window2"].visible=false
charset = pbBuildCharset
puts charset
@sprites["player"]=TrainerWalkingCharSprite.new(charset,@viewport)
@sprites["player"].x=Graphics.width/2-@sprites["player"].bitmap.width/8
@sprites["player"].y=Graphics.height/2-@sprites["player"].bitmap.height/8 -64
@sprites["player"].z=9999999
$game_temp.savedoutfit = true
temp=WALK_FOLDER+"/"+@accessoryNames[1]+"/"+"0A"
@sprites["playerAccessory"]=TrainerWalkingCharSprite2.new(temp,@viewport)
@sprites["playerAccessory"].x=Graphics.width/2-@sprites["playerAccessory"].bitmap.width/8
@sprites["playerAccessory"].y=Graphics.height/2-@sprites["playerAccessory"].bitmap.height/8 +64
@sprites["playerAccessory"].z=9999999
@sprites["playerAccessory"].ox+=@sprites["playerAccessory"].bitmap.width/16
@sprites["playerAccessory"].oy+=@sprites["playerAccessory"].bitmap.height/16
@sprites["playerAccessory"].zoom_x=2
@sprites["playerAccessory"].zoom_y=2
@sprites["playerAccessory"].visible=false
@playerAccessory=@sprites["playerAccessory"]
charheight=@sprites["player"].bitmap.height
@y=[charheight/4*2,0,charheight/4,charheight/4*3]
@sprites["heading1"]=Window_CommandPokemonEx.new(["BODYPART"])
@sprites["heading1"].viewport=@viewport
@sprites["heading1"].index=1
@sprites["heading2"]=Window_CommandPokemonEx.new(["HAIR"])
@sprites["heading2"].viewport=@viewport
@sprites["heading2"].index=1
@sprites["heading2"].x=Graphics.width-@sprites["heading2"].width



@commands=CommandMenuList.new
@commands.add("hair",{
  "name"        => _INTL("Hair"),
  "parent"      => :main})
@commands.add("tops",{
  "name"        => _INTL("Tops"),
  "parent"      => :main})
@commands.add("bottoms",{
  "name"        => _INTL("Bottoms"),
  "parent"      => :main})
@commands.add("headgear",{
  "name"        => _INTL("Headgear"),
  "parent"      => :main})
@commands.add("accessories",{
  "name"        => _INTL("Accessories"),
  "parent"      => :main})
  
  
  
  
  
@sprites["cmdwindow"]=Window_CommandPokemonEx.new(@commands.list)
@sprites["cmdwindow"].viewport=@viewport
@sprites["cmdwindow"].y=@sprites["heading1"].height
@sprites["cmdwindow2"]=Window_CommandPokemonEx.new(retListCmdBox2)
@sprites["cmdwindow2"].viewport=@viewport
@sprites["cmdwindow2"].y=@sprites["heading2"].height
@sprites["cmdwindow2"].x=Graphics.width-@sprites["cmdwindow2"].width
@sprites["cmdwindow2"].z-=1
@sprites["cmdwindow2"].index=-1
@cmdwindow2=@sprites["cmdwindow2"]
@selectionMade=false
update
end
 
 
 
# updates the scene.
def update
frame=0
@dir=0
loop do
frame+=1
pos=0
Graphics.update
Input.update

@sprites["player"].update
@sprites["playerAccessory"].update










if @firstSelection
@sprites["cmdwindow"].update
@index=@sprites["cmdwindow"].index
else
@cmdwindow2.update
end








if indexChanged #Updates the heading, and the continents of the right command box.
updateHeading2
end




if @selectionChange #Updates the heading, and the continents of the right command box.
updateHeading2
if @secondSelection
@cmdwindow2.index=@indexR
else
@cmdwindow2.index=0
end
@selectionChange=false
end





if @secondSelection
if cmdWindow2IndexChanged && @cmdwindow2.index != -1
if !(@cmdwindow2.index==(@cmdwindow2.itemCount-1)) && !hasVariants
@sprites["window2"].visible=true
@sprites["playerAccessory"].visible=true
$game_temp.savedoutfit = true
updateAccessoryBitmap #if @cmdwindow2.index != @cmdwindow2.
$game_temp.savedoutfit = false
else
@sprites["window2"].visible=false
@sprites["playerAccessory"].visible=false
end
end
elsif cmdWindow2IndexChanged && @cmdwindow2.index != -1
if !(@cmdwindow2.index==(@cmdwindow2.itemCount-1))
@sprites["window2"].visible=true
@sprites["playerAccessory"].visible=true
$game_temp.savedoutfit = true
updateAccessoryBitmap2 
$game_temp.savedoutfit = false
else
@sprites["window2"].visible=false
@sprites["playerAccessory"].visible=false
end
end



if Input.trigger?(Input::USE) && @list[0]!="[NONE]" # Using the Left Command Box when there are items.




if @firstSelection   #If using the left window, move to right window.
@cmdwindow2.index=0
@firstSelection=false
if !hasVariants
@sprites["window2"].visible=true
@sprites["playerAccessory"].visible=true
end





elsif @secondSelection #Go through options in the second window.

# Using the second window to select equipment.


if @cmdwindow2.index==(@cmdwindow2.itemCount-1) # Cancel Button.
@cmdwindow2.index=-1; @cmdwindow2.update
@firstSelection=true
@sprites["window2"].visible=false
@sprites["playerAccessory"].visible=false
puts "kills.... quickly"




elsif !hasVariants #If the item does not have subtypes.
puts "kills"
$game_temp.savedoutfit = true
changeClothes
charset = pbBuildCharset
$game_temp.savedoutfit = false
#@sprites["player"].bitmap.clear
updateTrainerOutfit
@sprites["player"].charset=charset
@selectionMade=true




else #The Most common behavior: Item has a subtype, that you are now selecting.
puts "kills.... slowly"
@indexR=@cmdwindow2.index
@secondSelection=false
@selectionChange=true
@sprites["window2"].visible=true
@sprites["playerAccessory"].visible=true
end




else  





if @cmdwindow2.index==(@cmdwindow2.itemCount-1) # Cancel Button (Again)
@cmdwindow2.index=@indexR; @cmdwindow2.update
@secondSelection=true
@selectionChange=true
@sprites["window2"].visible=false
@sprites["playerAccessory"].visible=false


else   #Applys the selected variant of the item.

puts "Hi?"
$game_temp.savedoutfit = true
changeClothes
charset = pbBuildCharset
$game_temp.savedoutfit = false
#@sprites["player"].bitmap.clear
updateTrainerOutfit
@sprites["player"].charset=charset
@selectionMade=true


end



end


elsif Input.trigger?(Input::USE) && @list[0]=="[NONE]"  #Using the Left Command Box when there are no items. This closes the window.
pbMessage("You have no clothing, so this will close.")
pbDisposeSpriteHash(@sprites)
break
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
# cancels the scene, or takes a step back.
if Input.trigger?(Input::BACK)


if @firstSelection && Kernel.pbConfirmMessage("Have you finished?") #First selection is when you are navigating the left box.
pbBuildCharsetandUpdateMain
updateTrainerOutfit

if @savegetup == true && @selectionMade == false
$game_temp.savedoutfit = true
else
$game_temp.savedoutfit = false
end


pbDisposeSpriteHash(@sprites)
break
# goes back to the left command box.
elsif !@firstSelection && @secondSelection #Second selection is if you are in the second box.
@cmdwindow2.index=-1; @cmdwindow2.update
@firstSelection=true
@sprites["window2"].visible=false
@sprites["playerAccessory"].visible=false
elsif !@firstSelection && !@secondSelection #This if you are in neither, but a secret third thing.
@cmdwindow2.index=@indexR; @cmdwindow2.update
@secondSelection=true
@selectionChange=true
@sprites["window2"].visible=false
@sprites["playerAccessory"].visible=false
end


end





# Allows you to control the item and player facing.
if Input.trigger?(Input::JUMPUP) #A
@dir-=1
@sprites["player"].src_rect.y=@y[@dir%4]
@sprites["playerAccessory"].src_rect.y=@sprites["player"].src_rect.y
elsif Input.trigger?(Input::SPECIAL) #D
@dir+=1
@sprites["player"].src_rect.y=@y[@dir%4]
@sprites["playerAccessory"].src_rect.y=@sprites["player"].src_rect.y
end












end














end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
end


#===============================================================================
# Creates a method which chooses which Base Graphic to build their character on top of
#===============================================================================


class ChooseBase
 
def initialize
if $game_temp.savedoutfit==true
(if $DEBUG; p "Cannot pick base if outfit has already been edited"; end; return)
end
#Version 17.2 Difference Below
@commands=CommandMenuList.new
for i in 0...BASE_GRAPHICS.length
temp=BASE_GRAPHICS[i]
@commands.add(temp.downcase,{
  "name"        => _INTL("#{temp}"),
  "parent"      => :main})
end
#Version 17.2 Difference Above
return false if !addBaseFiles
@index=0
@sprites={}
@viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
@viewport.z=99999
addBackgroundPlane(@sprites, "background", "loadslotsbg", @viewport)
@sprites["window"]=SpriteWindow_Base.new(8,8,128,192)
@sprites["window2"]=SpriteWindow_Base.new(8,208,128,128)
@sprites["window"].viewport=@viewport
@sprites["window2"].viewport=@viewport
@sprites["window"].z=1000
@sprites["window2"].z=1000
temp="base graphics/examples/0"
temp=pbGetCustomCharset(temp)
@sprites["baseRep"]= IconSprite.new(0,0,@viewport)
@sprites["baseRep"].setBitmap("Graphics/Characters/"+temp)
@sprites["baseRep"].x=@sprites["window"].width/2-@sprites["baseRep"].bitmap.width/2 +8
@sprites["baseRep"].y=@sprites["window"].height/2-@sprites["baseRep"].bitmap.height/2 +8
@sprites["baseRep"].z=9999999
charset="base graphics/"+WALK_FOLDER+"/0"
filename=pbGetCustomCharset(charset)
@sprites["walkSprite"]=TrainerWalkingCharSprite.new(filename,@viewport)
@sprites["walkSprite"].x=@sprites["window2"].width/2-@sprites["walkSprite"].bitmap.width/2 +8
@sprites["walkSprite"].y=@sprites["window2"].height/2-@sprites["walkSprite"].bitmap.height/2 +208
@sprites["walkSprite"].ox-=@sprites["walkSprite"].bitmap.width/8
@sprites["walkSprite"].oy-=@sprites["walkSprite"].bitmap.height/8
@sprites["walkSprite"].z=9999999
@sprites["walkSprite"].zoom_x=2
@sprites["walkSprite"].zoom_y=2
@sprites["heading"]=Window_CommandPokemonEx.new(["SKIN TONES"])
@sprites["heading"].viewport=@viewport
@sprites["heading"].index=1
@sprites["heading"].x=Graphics.width-@sprites["heading"].width-8
charheight=@sprites["walkSprite"].bitmap.height
@y=[charheight/4*2,0,charheight/4,charheight/4*3]
@sprites["cmdwindow"]=Window_CommandPokemonEx.new(@commands.list)
@sprites["cmdwindow"].viewport=@viewport
@sprites["cmdwindow"].x=Graphics.width-@sprites["cmdwindow"].width
@sprites["cmdwindow"].y=@sprites["heading"].height+8
@sprites["cmdwindow"].z=999999
@sprites["cmdwindow"].index=0
looping
end
 
def addBaseFiles
return true
files=[]
meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
filenames=[pbGetPlayerCharset(meta.walk_charset),pbGetPlayerCharset(meta.run_charset),pbGetPlayerCharset(meta.cycle_charset),pbGetPlayerCharset(meta.surf_fish_charset),pbGetPlayerCharset(meta.fish_charset)]
root="Graphics/Characters/base graphics/"
# Trainer backsprite
name=0
for j in 0...@commands.list.length
for i in 0...SPRITE_CONVERT_ARRAY.length
name=SPRITE_CONVERT_ARRAY[i]
files.push(root+name+"/#{j}"+($player.gender+65).chr)
end
end
# Creating a blank bitmap
size_check=Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
blank_bitmap=Bitmap.new(size_check.width,size_check.height)
# Pushing non existent files into the files_to_add array.
files_to_add=[]
for i in 0...files.length
if !File.exists?(files[i]+".png")
files_to_add.push(files[i]+".png")
end
end
if !files_to_add.empty? && false
Kernel.pbMessage("The game is missing one or more graphic files for the Character Customization.")
ret=Kernel.pbConfirmMessage("Would you like to add these files as blank placeholder sprites in order to let this Script work properly?")
if ret
files_to_add.length.times {|i| blank_bitmap.save_to_png(files_to_add[i])}
Kernel.pbMessage("The missing files were added to the Graphics/Characters/base graphics/ folder. The script will continue working as supposed now.")
else
Kernel.pbMessage("The script stopped running until these neccessary files were added:")
files_to_add.length.times{|i| Kernel.pbMessage(files_to_add[i])}
end
return ret
end
return true
end
 
def saveBase(filepath,folder)

filepath = filepath.gsub(/\.png/,"")
return if !$player
return if !filepath.is_a?(String) || !folder.is_a?(String)
name="Graphics/Characters/base graphics/"+folder+"/"+(@sprites["cmdwindow"].index).to_s
if File.exists?(name+($player.gender+65).chr+".png")
bmp=Bitmap.new(name+($player.gender+65).chr)
else
# Creating a blank bitmap
size_check=Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
bmp=Bitmap.new(size_check.width,size_check.height)
end
# Safety Copy
if !File.exists?(filepath+"_safetyCopy"+".png") && $DEBUG
safetyCopy=Bitmap.new(filepath)
safetyCopy.save_to_png(filepath+"_safetyCopy"+".png")
end
bmp.save_to_png(filepath+".png")
end
 
def saveAllBases
return if !$player
# Trainer charsets
meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
filenames=[pbGetPlayerCharset(meta.walk_charset),pbGetPlayerCharset(meta.run_charset),pbGetPlayerCharset(meta.cycle_charset),pbGetPlayerCharset(meta.surf_fish_charset),pbGetPlayerCharset(meta.fish_charset)]
filenames = filenames.compact
for i in 0...filenames.length

if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
filepath="Graphics/Characters/#{filenames[i]}"
folder = 0
folder=SPRITE_CONVERT_ARRAY[i]
saveBase(filepath,folder)

end
end

# Trainer backsprite
helpr="trback00#{$player&.character_ID}"
filepath="Graphics/Trainers/"
folder=SPRITE_CONVERT_HASH[helpr]
saveBase(filepath+helpr,folder)
# Intro Image/Trainercard Image
filepath="Graphics/Pictures/"
helpr=$player.female? ? "introGirl" : "introBoy" #Modify this line if you want more than two characters.
folder=SPRITE_CONVERT_HASH[helpr]
saveBase(filepath+helpr,folder)
# Map Player
helpr="mapPlayer00#{$player&.character_ID}"
folder=SPRITE_CONVERT_HASH[helpr]
saveBase(filepath+helpr,folder)
end
 
def looping
frame=0
@dir=0
loop do
frame+=1
pos=0
Graphics.update
Input.update
@sprites["baseRep"].update
@sprites["walkSprite"].update
@sprites["cmdwindow"].update
if @sprites["cmdwindow"].index != @index
@index=@sprites["cmdwindow"].index
newname="examples/"+(@sprites["cmdwindow"].index).to_s+($player.gender+65).chr
if File.exists?("Graphics/Characters/base graphics/"+newname+".png")
@sprites["baseRep"].name=("Graphics/Characters/base graphics/"+newname)
end
newname=WALK_FOLDER+"/"+(@sprites["cmdwindow"].index).to_s+($player.gender+65).chr
if File.exists?("Graphics/Characters/base graphics/"+newname+".png")
@sprites["walkSprite"].charset=("base graphics/"+newname)
end
end


if Input.trigger?(Input::USE) && Kernel.pbConfirmMessage("So you're choosing #{@commands.list[@index]}?")
$player.base=getFolders4(@commands.list[@index])
saveAllBases
pbDisposeSpriteHash(@sprites)
pbBuildCharsetandUpdateMain
updateTrainerOutfit
break
end





if frame%120==0
@dir+=1
@sprites["walkSprite"].src_rect.y=@y[@dir%4]
end
end
end

def getFolders4(base,movementtype="overworld walk",pack="default")
   base = "#{base}#{$player.gender}"
   
   folder_path = "Graphics/Plugins/Character Customization/#{pack.downcase}/base graphics/#{movementtype.downcase}"
   folder = nil
  Dir.glob(folder_path + '/*') do |file|
    if base == File.basename(file).gsub(/\.png/,"")
	  folder = File.basename(file)
    end
  end
  if !folder.nil?
   potato = [pack.downcase,folder]
  return potato
  end
end


end

