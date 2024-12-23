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
return true
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
pbMessage("The game is missing one or more graphic files for the Character Customization.")
ret=pbConfirmMessage("Would you like to add these files as blank placeholder sprites in order to let this Script work properly?")
if ret
files_to_add.length.times {|i| blank_bitmap.save_to_png(files_to_add[i])}
pbMessage("The missing files were added to the Graphics/Characters/ folder. The script will continue working as supposed now.")
else
pbMessage("The script stopped running until these neccessary files were added:")
files_to_add.length.times{|i| pbMessage(files_to_add[i])}
end
return ret
end
return true
end
 
def get_accessory_file(folder_path, accessorylist, item)
  Dir.glob(folder_path + '/*') do |file|
    #puts "Checking file: #{file}"
    #puts "Source item: #{item}"
    #puts "Is directory: #{File.directory?(file)}"
    #puts "Is in accessory list: #{accessorylist.include?(File.basename(file).to_sym)}"
    #puts "Item matches file: #{item == File.basename(file).upcase}"
    if File.directory?(file) && accessorylist.include?(File.basename(file).to_sym) && item == File.basename(file).upcase
      #puts "Match found: #{File.basename(file).upcase}"
      return File.basename(file).upcase
    end
  end
end
def get_accessory_path(accessorylist,accessorypath,movementtype="overworld walk",pack="default")
 
   folder_path = "Graphics/Plugins/Character Customization/#{pack.downcase}/#{movementtype.downcase}/#{accessorypath.downcase}"

   folder = nil
   #puts "IndexR: #{@indexR}"
   #puts "accessorylist: #{@accessorylist.to_s}"
   item = accessorylist[@indexR].to_s
   #puts "item: #{@item}"
   folder = get_accessory_file(folder_path,accessorylist,item)
  return (folder_path + '/' + folder) if !folder.nil?
  return nil
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


def get_item_variations(folder)
colors = []
Dir.glob(folder + '/*') do |file|
  colors << File.basename(file).gsub(/\.png/,"")
end
return colors

end 

 
# returns the list of the right hand command box.
def getObjectsList
@list = []
@list.push("[REMOVE]") if !get_current_equip_for_type.nil?
@list = @list+get_current_list
if @secondSelection==false
list   = get_raw_list
folder = get_accessory_path(list,@accessoryNames[@index])
@list = get_item_variations(folder) if folder
end




@list.push("Back") if !@list.include?("Back") && @list.length>0
return @list
end
 
 
 def getBodypartList(accessory)
  list = get_raw_list
  return list if list.include?(accessory)
 end
 
 
 # updates the Accessory bitmap
def updateAccessoryBitmap
   @sprites["playerAccessory"].bitmap.clear
   item = get_raw_list[@indexR]
   name="overworld walk/" + @accessoryNames[@index] + "/" + item.to_s
   item_path = "Graphics/Plugins/Character Customization/default/"+name
   puts 
   if File.exists?(item_path) && pbResolveBitmap(item_path)
   @sprites["playerAccessory"].charset=item_path 
   else
     puts "We cannot find an image 1."
     puts item_path
   end


end
 

 
 # Another method for updating the Accessory bitmap
def updateAccessoryBitmap2
   @sprites["playerAccessory"].bitmap.clear
   item = get_raw_list[@indexR]
   if item.nil?
   return 
   @sprites["playerAccessory"].charset=nil
   end
   frontname= "overworld walk/" + @accessoryNames[@index] + "/"+ item.to_s
   name= frontname + "/" + getCurrentVariant(item,@list[@cmdwindow2.index],@accessoryNames[@index])
   
   
   
   item_path = "Graphics/Plugins/Character Customization/default/"+name
   
   
   if File.exists?(item_path) && pbResolveBitmap(item_path)
     @sprites["playerAccessory"].charset=item_path
   else
     puts "We cannot find an image 2."
     puts item_path
   end
end
 
 def get_current_list
   arr=getList(get_raw_list)
   return arr
 end
 
 def get_current_equip_for_type
   arr=$player.hair if @accessoryNames[@index]=="hair"
   arr=$player.top if @accessoryNames[@index]=="tops"
   arr=$player.bottom if @accessoryNames[@index]=="bottoms"
   arr=$player.headgear if @accessoryNames[@index]=="headgear"
   arr=$player.accessory if @accessoryNames[@index]=="accessories"
   return arr
 end
 
 def set_current_equip_for_type(value=nil)
   $player.hair = value if @accessoryNames[@index]=="hair"
   $player.top = value if @accessoryNames[@index]=="tops"
   $player.bottom = value if @accessoryNames[@index]=="bottoms"
   $player.headgear = value if @accessoryNames[@index]=="headgear"
   $player.accessory = value if @accessoryNames[@index]=="accessories"
 end
 
 def get_raw_list
   arr=$player.hairList if @accessoryNames[@index]=="hair"
   arr=$player.topList if @accessoryNames[@index]=="tops"
   arr=$player.bottomList if @accessoryNames[@index]=="bottoms"
   arr=$player.headgearList if @accessoryNames[@index]=="headgear"
   arr=$player.accessoryList if @accessoryNames[@index]=="accessories"
   return arr
 end
#checks whether or not the currently selected item within the list has any variants
def hasVariants


   list=get_raw_list
#Access original array to check whether or not item has variants.
if !list.nil?
folder = get_accessory_path(list,@accessoryNames[@index])
return false if folder.nil?

colors = get_item_variations(folder)
return true if !colors.nil?

end






return false
end
 
# this updates the heading. since there is no command for updating
# command boxes it'll always create a new fresh command box sprite.

def updateHeading2(update_index=true)
@sprites["heading#{@new_val}"].dispose
@sprites["cmdwindow#{@new_val}"].dispose
@new_val+=1
@sprites["heading#{@new_val}"]=Window_CommandPokemonEx.new([@commands.list[@index].upcase])
@sprites["heading#{@new_val}"].viewport=@viewport
@sprites["heading#{@new_val}"].index=1
@sprites["heading#{@new_val}"].x=Graphics.width-@sprites["heading#{@new_val}"].width
@sprites["heading#{@new_val}"].z-=1
@sprites["cmdwindow#{@new_val}"]=Window_CommandPokemonEx.new(getObjectsList)
@cmdwindow2=@sprites["cmdwindow#{@new_val}"]
@cmdwindow2.viewport=@viewport
@cmdwindow2.y=@sprites["heading#{@new_val}"].height
@cmdwindow2.x=Graphics.width-@sprites["cmdwindow#{@new_val}"].width
@cmdwindow2.index= -1 if update_index
@cmdwindow2.visible = false
@cmdwindow2.visible = true if getObjectsList.length > 0
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



def get_accessory_object(accessory,curAccessory,accessoryfolder,movementtype="overworld walk",pack="default")
   pack = pack.downcase
   folder_path = "Graphics/Plugins/Character Customization/#{pack}/#{movementtype.downcase}/#{accessoryfolder.downcase}/#{accessory}"
   item_image = nil
  Dir.glob(folder_path + '/*') do |file|
    if curAccessory.to_s == File.basename(file).gsub(/\.png/,"")
	  item_image = File.basename(file)
    end
  end
    return nil if item_image.nil?
     puts folder_path + '/' + item_image
  if !item_image.nil?
  potato = AccessoryObject.new(item_image,accessoryfolder,pack,accessory.to_s)
  return potato
  end
end


# updates the outfit as well as the variables which are responsable for it.
def changeClothes

item = get_raw_list[@indexR]
accessory_object = get_accessory_object(item,@list[@cmdwindow2.index],@accessoryNames[@index])
if !accessory_object.nil?
puts @sprites["cmdwindow"].index
case @sprites["cmdwindow"].index
when 0
$player.hair = accessory_object
puts "A. This is what hair is set to:#{$player.hair}"
when 1
$player.top = accessory_object
when 2
$player.bottom = accessory_object
when 3
$player.headgear = accessory_object
when 4
$player.accessory = accessory_object
puts "A. This is what accessory is set to:#{$player.accessory}"
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



class AccessoryObject
  attr_accessor :image
  attr_accessor :folder
  attr_accessor :pack
  attr_accessor :style
   def initialize(image,folder,pack,style)
       @image = image
       @folder = folder
       @pack = pack
       @style =  style

   end
end

def getList(list)
nulist = []
list.each do |i|
nulist << GameData::Item.get(i).name.to_s
end
return nulist
end