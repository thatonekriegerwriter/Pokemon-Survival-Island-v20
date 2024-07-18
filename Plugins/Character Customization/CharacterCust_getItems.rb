# Given a string and a bool, returns an array and a var representing the array number.
# accessory: A string representing an item in the array that the user wants to access.
# convertation: A Bool which determines whether or not the names specific to a
# players gender are returned (true), or the entire array (false).
def retArrayAndNumber(accessory,potato)
(bodypart=getList($player.hairList); var=1) if getList($player.hairList).include?(accessory)
(bodypart=getList($player.topList); var=2) if getList($player.topList).include?(accessory)
(bodypart=getList($player.bottomList); var=3) if getList($player.bottomList).include?(accessory)
(bodypart=getList($player.headgearList); var=4) if getList($player.headgearList).include?(accessory)
(bodypart= getList($player.accessoryList); var=5) if getList($player.accessoryList).include?(accessory)
return [bodypart,var]
end

class TrainerWalkingCharSprite2 < Sprite
  def initialize(charset, viewport = nil)
    super(viewport)
    @animbitmap = nil
    self.charset = charset
    @animframe      = 0   # Current pattern
    @frame          = 0   # Frame counter
    self.animspeed  = 5   # Animation speed (frames per pattern)
  end

  def charset=(value)
    @animbitmap&.dispose
    @animbitmap = nil
	if value.include?("Plugins")
	bitmapFileName = value
	else
    bitmapFileName = sprintf("Graphics/Characters/%s", value)
	end
    @charset = pbResolveBitmap(bitmapFileName)
    if @charset
      @animbitmap = AnimatedBitmap.new(@charset)
      self.bitmap = @animbitmap.bitmap
      self.src_rect.set(0, 0, self.bitmap.width / 4, self.bitmap.height / 4)
    else
      self.bitmap = nil
    end
  end

  def altcharset=(value)   # Used for box icon in the naming screen
    @animbitmap&.dispose
    @animbitmap = nil
    @charset = pbResolveBitmap(value)
    if @charset
      @animbitmap = AnimatedBitmap.new(@charset)
      self.bitmap = @animbitmap.bitmap
      self.src_rect.set(0, 0, self.bitmap.width / 4, self.bitmap.height)
    else
      self.bitmap = nil
    end
  end

  def animspeed=(value)
    @frameskip = value * Graphics.frame_rate / 40
  end

  def dispose
    @animbitmap&.dispose
    super
  end

  def update
    @updating = true
    super
    if @animbitmap
      @animbitmap.update
      self.bitmap = @animbitmap.bitmap
    end
    @frame += 1
    if @frame >= @frameskip
      @animframe = (@animframe + 1) % 4
      self.src_rect.x = @animframe * @animbitmap.bitmap.width / 4
      @frame -= @frameskip
    end
    @updating = false
  end
end



class CharacterCustomizationScene


 
def addNecessaryFiles
files=[]
basefiles=[]
# Pushing all files that could possibly be missing into the files array.
individualArrayFiles(files,getList($player.hairList),"hair")
individualArrayFiles(files,getList($player.bottomList),"bottoms")
individualArrayFiles(files,getList($player.topList),"tops")
individualArrayFiles(files,getList($player.headgearList),"headgear")
individualArrayFiles(files,getList($player.accessoryList),"accessories")


# Creating a blank bitmap
files_to_add=[]
for i in 0...basefiles.length
if !File.exists?(basefiles[i]+".png")
files_to_add.push(basefiles[i]+".png")
end
end
size_check=Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
blank_bitmap=Bitmap.new(size_check.width,size_check.height)
# Pushing non existent files into the files_to_add array.
for i in 0...files.length
if !File.exists?("Graphics/Characters/overworld walk/#{files[i]}"+".png")
  folder_parts = files[i].split('/')
  truncated_folder = folder_parts[0..1].join('/')
if !File.directory?("Graphics/Characters/overworld walk/#{truncated_folder}")
  Dir.mkdir("Graphics/Characters/overworld walk/" + truncated_folder)
end
files_to_add.push("Graphics/Characters/overworld walk/#{files[i]}"+".png")
end
end
if !files_to_add.empty? && false
Kernel.pbMessage("The game is missing one or more graphic files for the Character Customization.")
ret=Kernel.pbConfirmMessage("Would you like to add these files as blank placeholder sprites in order to let this Script work properly?")
if ret
files_to_add.length.times {|i| blank_bitmap.save_to_png(files_to_add[i])}
Kernel.pbMessage("The missing files were added to the Graphics/Characters/ folder. The script will continue working as supposed now.")
else
Kernel.pbMessage("The script stopped running until these neccessary files were added:")
files_to_add.length.times{|i| Kernel.pbMessage(files_to_add[i])}
end
return ret
end
return true
end
 
 
# returns the index of the item in the actual list.
def getAccessoryIndex(index)
if @secondSelection
item=@list[index]
else
item=@list2[index]
end
arr=getList($player.hairList) if @accessoryNames[@index]=="hair"
arr=getList($player.topList) if @accessoryNames[@index]=="tops"
arr=getList($player.bottomList) if @accessoryNames[@index]=="bottoms"
arr=getList($player.headgearList) if @accessoryNames[@index]=="headgear"
arr=getList($player.accessoryList) if @accessoryNames[@index]=="accessories"
for i in 0...arr.length
return i if arr[i]==item
end
end

def getAccessoryItem(index)
if @secondSelection
item=@list[index]
else
item=@list2[index]
end
arr=getList($player.hairList) if @accessoryNames[@index]=="hair"
arr=getList($player.topList) if @accessoryNames[@index]=="tops"
arr=getList($player.bottomList) if @accessoryNames[@index]=="bottoms"
arr=getList($player.headgearList) if @accessoryNames[@index]=="headgear"
arr=getList($player.accessoryList) if @accessoryNames[@index]=="accessories"
for i in 0...arr.length
return arr[i] if arr[i]==item
end
end
 

 
# returns the index of the variant in the actual list.
def getAccessoryIndex2
item=@list[@cmdwindow2.index]
arr=getList($player.hairList) if @accessoryNames[@index]=="hair"
arr=getList($player.topList) if @accessoryNames[@index]=="tops"
arr=getList($player.bottomList) if @accessoryNames[@index]=="bottoms"
arr=getList($player.headgearList) if @accessoryNames[@index]=="headgear"
arr=getList($player.accessoryList) if @accessoryNames[@index]=="accessories"
arr2=arr[getAccessoryIndex(@indexR)]
items = getItems(getFolders2(arr2,@list[@cmdwindow2.index],@accessoryNames[@index]))
return items
end


def getFolders(accessory,accessorypath,movementtype="overworld walk",pack="default")
 
   folder_path = "Graphics/Plugins/Character Customization/#{pack.downcase}/#{movementtype.downcase}/#{accessorypath.downcase}"
   folder = nil
  Dir.glob(folder_path + '/*') do |file|
    if File.directory?(file) && accessory.include?(File.basename(file))
	  folder = File.basename(file).upcase
    end
  end
  if !folder.nil?
  return folder_path + '/' + folder 
  end
end


def getFolders2(accessory,curAccessory,accessorypath,movementtype="overworld walk",pack="default")
   folder_path = "Graphics/Plugins/Character Customization/#{pack.downcase}/#{movementtype.downcase}/#{accessorypath.downcase}/#{accessory}"
   folder = nil
  Dir.glob(folder_path + '/*') do |file|
    if curAccessory == File.basename(file).gsub(/\.png/,"")
	  folder = File.basename(file)
    end
  end
  
  if !folder.nil?
  potato = folder_path + '/' + folder 
  return potato
  end
end


def getCurrentVariant(accessory,curAccessory,accessorypath,movementtype="overworld walk",pack="default")
   folder_path = "Graphics/Plugins/Character Customization/#{pack.downcase}/#{movementtype.downcase}/#{accessorypath.downcase}/#{accessory}"
   folder = nil
  Dir.glob(folder_path + '/*') do |file|
    if curAccessory == File.basename(file).gsub(/\.png/,"")
	  folder = File.basename(file)
    end
  end
  if !folder.nil?
  return folder
  end
end


def getItems(folder)
colors = []
Dir.glob(folder + '/*') do |file|
  colors << File.basename(file).gsub(/\.png/,"")
end
if colors.length < 1
return nil
else
return colors
end
end 

 
# returns the list of the right hand command box.
def retListCmdBox2
@list=getList($player.hairList) if @index==0
@list=getList($player.topList) if @index==1
@list=getList($player.bottomList) if @index==2
@list=getList($player.headgearList) if @index==3
@list=getList($player.accessoryList) if @index==4
if @secondSelection==true
else
@list2=@list
arr2=@list2[getAccessoryIndex(@indexR)]
@list=getItems(getFolders(arr2,@accessoryNames[@index]))
#@list=getItems(getFolders2(arr2,@list[@cmdwindow2.index],@accessoryNames[@index]))
end
@list.push("Back") if !@list.include?("Back")
return @list
end
 
 
 
 
 
 # updates the Accessory bitmap
def updateAccessoryBitmap
@sprites["playerAccessory"].bitmap.clear
endname=(getAccessoryItem(@cmdwindow2.index)).to_s
name="overworld walk/"+@accessoryNames[@index]+"/"+endname
if File.exists?("Graphics/Characters/"+name+".png")
@sprites["playerAccessory"].charset=name
end
end
 

 
 # Another method for updating the Accessory bitmap
def updateAccessoryBitmap2
@sprites["playerAccessory"].bitmap.clear
frontname="overworld walk/"+@accessoryNames[@index]+"/"+(getAccessoryItem(@indexR)).to_s
arr=getList($player.hairList) if @accessoryNames[@index]=="hair"
arr=getList($player.topList) if @accessoryNames[@index]=="tops"
arr=getList($player.bottomList) if @accessoryNames[@index]=="bottoms"
arr=getList($player.headgearList) if @accessoryNames[@index]=="headgear"
arr=getList($player.accessoryList) if @accessoryNames[@index]=="accessories"
arr2=arr[getAccessoryIndex(@indexR)]
name=frontname+"/"+ getCurrentVariant(arr2,@list[@cmdwindow2.index],@accessoryNames[@index])
thing = "Graphics/Plugins/Character Customization/default/"+name
if File.exists?(thing) && pbResolveBitmap(thing)
@sprites["playerAccessory"].charset=thing
end
end
 
 
 
 
 
 
#checks whether or not the currently selected item within the list has any variants
def hasVariants
ret=false
name=@list[@cmdwindow2.index]
#Get name of item that is current hovered over
arr=retArrayAndNumber(name,false)
bodypart=arr[0]

#Access original array to check whether or not item has variants.
if !bodypart.nil?
items = getItems(getFolders(bodypart,@accessoryNames[@index]))
if !items.nil?
return true
end
end






return false
end
 
# this updates the heading. since there is no command for updating
# command boxes it'll always create a new fresh command box sprite.

def updateHeading2
@sprites["heading#{@new_val}"].dispose
@sprites["cmdwindow#{@new_val}"].dispose
@new_val+=1
@sprites["heading#{@new_val}"]=Window_CommandPokemonEx.new([@commands.list[@index].upcase])
@sprites["heading#{@new_val}"].viewport=@viewport
@sprites["heading#{@new_val}"].index=1
@sprites["heading#{@new_val}"].x=Graphics.width-@sprites["heading#{@new_val}"].width
@sprites["heading#{@new_val}"].z-=1
@sprites["cmdwindow#{@new_val}"]=Window_CommandPokemonEx.new(retListCmdBox2)
@cmdwindow2=@sprites["cmdwindow#{@new_val}"]
@cmdwindow2.viewport=@viewport
@cmdwindow2.y=@sprites["heading#{@new_val}"].height
@cmdwindow2.x=Graphics.width-@sprites["cmdwindow#{@new_val}"].width
@cmdwindow2.index= -1
end
 
# checks whether the index of the left command box has changed or not.
def indexChanged
if @index2 != @index
@index2=@index
return true
end
return false
end
 
# checks whether the index or the right command box has changed or not.
def cmdWindow2IndexChanged
if !@cmdWindow2Index
@cmdWindow2Index=@cmdwindow2.index
return false
elsif @cmdWindow2Index != @cmdwindow2.index
@cmdWindow2Index=@cmdwindow2.index
return true
end
return false
end



def getFolders3(accessory,curAccessory,accessorypath,movementtype="overworld walk",pack="default")
   folder_path = "Graphics/Plugins/Character Customization/#{pack.downcase}/#{movementtype.downcase}/#{accessorypath.downcase}/#{accessory}"
   folder = nil
  Dir.glob(folder_path + '/*') do |file|
    if curAccessory == File.basename(file).gsub(/\.png/,"")
	  folder = File.basename(file)
    end
  end
     
  if !folder.nil?
  potato = [pack.downcase,accessorypath,accessory,folder]
  return potato
  end
end


# updates the outfit as well as the variables which are responsable for it.
def changeClothes
arr2=@list2[getAccessoryIndex(@indexR)]
puts "arr2.1: #{arr2}"
potato = getFolders3(arr2,@list[@cmdwindow2.index],@accessoryNames[@index])
puts "potato2:#{potato}"

case @sprites["cmdwindow"].index
when 0
if @secondSelection
$player.hair= potato
puts "A. This is what hair is set to:#{$player.hair}"
else
$player.hair= potato
puts "This is what hair is set to:#{$player.hair}"
end
when 1
if @secondSelection
$player.top= potato
else
$player.top= potato
end
when 2
if @secondSelection
$player.bottom= potato
else
$player.bottom= potato
end
when 3
if @secondSelection
$player.headgear= potato
else
$player.headgear= potato
end
when 4
if @secondSelection
$player.accessory= potato
else
$player.accessory= potato
end
end
pbBuildCharset

end
 






end


def pbRemoveAccessory(list,item)
  if list && list.include?(item)
    list.delete(item)
  end
end

def pbGainAccessory(list,item)
  item_data = GameData::Item.try_get(item)
  if item_data.nil?
    return false
  end
  if hasAccessory?(list,item)==false
	list.push(item)
	return true
  end
	
	return false
end


def hasAccessory?(list,item)
  for i in 0...list.length
    if list[i] == item
      return true
    end
  end

return false
end


def getList(list)
nulist = []
list.each do |i|
nulist << i.to_s
end
return nulist
end