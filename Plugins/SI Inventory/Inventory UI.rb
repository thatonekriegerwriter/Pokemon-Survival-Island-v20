module Inventory  
  def self.invWindow(type="Inventory", event_data = nil ,container = [])
  return if $game_temp.in_inventory==true
  $game_temp.in_menu = true
  $game_temp.inv_cooldown = 5
  craftScene=Inv_Scene.new
  craftScene.pbStartScene(type, event_data, container)
  item=craftScene.pbSelectcraft
  craftScene.pbEndScene
  $game_temp.in_inventory = false 
  $game_temp.in_menu = false
  return item if item.is_a?(ItemData)
 end
end

class Inv_Scene
  BOTTLE_ITEMS = [:BOWL, :GLASSBOTTLE,:SOUPBROTH, :WATERBOTTLE, :WATER, :FRESHWATER,:WEAKPOTION,:POTION,:SUPERPOTION,:HYPERPOTION,:MAXPOTION,:FULLRESTORE,:HPUP,:PPUP,:CARBOS,:PROTEIN,:IRON,:CALCIUM,:ZINC,:REPEL,:SUPERREPEL,:MAXREPEL,:ETHER,:MAXETHER,:ELIXIR,:MAXELIXIR]
  CONTAINER_ITEMS = [:BOWL, :GLASSBOTTLE, :WATERBOTTLE]
  
  FUEL_HASH = {
  CHARCOAL: 4,
  COAL: 8,
  ACORN: 0.5,
  WOODENLOG: 2,
  WOODENSTICKS: 0.5,
  WOODENPLANKS: 1,
  HEATROCK: 16,
  FIRESTONE: 32
  }
  def pbStartScene(type, event_data, container)
    $game_temp.in_inventory = true 
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
	@type = type
    @sprites={}
    @icons={}
    @objects={}
	@item_hovered = nil
	@grabbed_item = nil
	@current_tab = $bag.last_viewed_pocket-1
	@pockets = $bag.pockets
	@event_data = event_data
	raise "Incorrect event data type!" if !@event_data.is_a?(ResearchTableData) && @type==:RESEARCHTABLE
	@container = container 
	craft_type = @type=="Inventory" ? :POCKET : @type
	@crafting_data = GameData::Recipe::DATA.values.select do |recipe|
       recipe.station.include?(craft_type) && (!recipe.locked || $recipe_book.unlocked?(recipe.id))
    end
	# [item, qty]
	@craft = []
	@craft = @container.items if @type == :ITEMCRATE || @type == :ICEBOX
	@craft = [[@event_data.researching_item,1]] if @event_data.is_a?(ResearchTableData) && @type==:RESEARCHTABLE && @event_data.researching_item
	@pokemon = []
	if @type == :PKMNCRATE
	 if @container.box.pokemon.length < PokemonBox::BOX_SIZE
	    @container.box.pokemon.concat([nil] * (PokemonBox::BOX_SIZE - @container.box.pokemon.length))
	 elsif @container.box.pokemon.length > PokemonBox::BOX_SIZE
	      @container.box.pokemon.slice!(PokemonBox::BOX_SIZE,@container.box.pokemon.length - PokemonBox::BOX_SIZE)
	 end 
	@pokemon = @container.box.pokemon
	end 
	@result = nil
	@buttons = {}
	@equip = [[$player.playershirt,1],[$player.playerpants,1],[$player.playershoes,1]]
	
    @party = $player.party
    @sprites["statuses"] = AnimatedBitmap.new(_INTL("Graphics/Pictures/statuses"))
	
	
	@tooltip = Tooltip.new
	@sprites["highlight"] = IconSprite.new(0,0,@viewport)
    @sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
	@sprites["highlight"].z = 9999 
	@sprites["highlight"].visible = false 
	
	build_sprites 
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["overlay"].z = 99 
    pbDeactivateWindows(@sprites)
  end
 
  def update 
    @tooltip.update
    pbUpdateSpriteHash(@sprites)
	Settings.bag_pocket_names.each_with_index do |name, i|
	  if @current_tab == i
      @sprites["#{name}_image"].setBitmap("Graphics/Pictures/notebooktab")
      @sprites["#{name}_image"].z= 49
      @sprites["#{name}_text"].z = 50
      @sprites["#{name}_icon"].z = 50
      @sprites["#{name}_text"].shadowColor=Color.new(248, 248, 248)
	 else
      @sprites["#{name}_image"].setBitmap("Graphics/Pictures/notebooktabu")
      @sprites["#{name}_image"].z = i+10
      @sprites["#{name}_text"].z = i+10
      @sprites["#{name}_icon"].z = i+10
      @sprites["#{name}_text"].shadowColor=Color.new(190, 190, 190)
      end
	
	
	
	
	end 
    if @grabbed_item
	  icon = @grabbed_item[:icon]
	  text_icon = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	  amt = @grabbed_item[:stack][1]
      mouse_x, mouse_y = Mouse.getMousePos
	  if mouse_x && mouse_y && icon && text_icon && !@grabbed_item[:stack][0].is_a?(Pokemon)
	   return if icon.disposed?
	   icon.x = mouse_x - icon.width / 2
	   icon.y = mouse_y - icon.height / 2
	   icon.z = 10000
	   text_icon.x = mouse_x - icon.width / 2 + 4#  - text_icon.width / 2
	   text_icon.y = mouse_y - icon.height / 2# - text_icon.height / 2
	   text_icon.z = 10001
	   if amt>1
	    text = amt.to_s
	   else
	    text = ""
	   end
	   text_icon.text = text
	  elsif mouse_x && mouse_y && icon && @grabbed_item[:stack][0].is_a?(Pokemon)
	   icon.x = mouse_x - 10 #- icon.width / 2
	   icon.y = mouse_y + 10 - icon.height / 2
	   icon.z = 10000
	  end
	  
	end 
    update_highlight
    if stack = item_hovered?
	  
	  if (stack.is_a?(Pokemon) || (stack.is_a?(Array) && stack[0].is_a?(Pokemon))) || (@item_hovered && @item_hovered.is_a?(Pokemon))
	  item = stack.is_a?(Array) ? stack[0] : stack
	  if (@item_hovered.nil? || (@item_hovered && @item_hovered!=item)) && @sprites["cmdwindow"].visible == false && item.is_a?(Pokemon)
	    pokemon = item
	    thespecies = GameData::Species.get_species_form(pokemon.species, pokemon.form)
	    text = pbPokedexEntry(thespecies)
	    desc = text.length>0 ? "#{text}" : ""
	    msg = "#{pokemon.name}#{desc}"
	    @item_hovered = pokemon
	    hash = {}
		if pokemon.egg?
          status = ""
		elsif pokemon.dead?
          status = "[DED]"
		elsif pokemon.fainted?
          status = "[FNT]"
		elsif pokemon.status != :NONE
          case GameData::Status.get(pokemon.status).icon_position
		    when 0
              status = "[SLP]"
			when 1
              status = "[PSN]"
			when 2
              status = "[BRN]"
			when 3
              status = "[PAR]"
			when 4
              status = "[FRZ]"
		  end
		elsif pokemon.pokerusStage == 1
          status = "[PKRS]"
		end
	    hash[:name] = ["#{pokemon.name} #{status}",0,0]
	    hash[:health] = [item.hp,0,0] if !pokemon.egg?
	    hash[:maxhealth] = [item.totalhp,0,0] if !pokemon.egg?
        @tooltip.show(hash)
	  end
	  else
	  item = stack[0]
	  item = ItemData.new(item) if item.is_a?(Symbol)
	  if (@item_hovered.nil? || (@item_hovered && !@item_hovered.identical(item))) && @sprites["cmdwindow"].visible == false
	  desc = item.description.length>0 ? "#{item.description}" : ""
	  @item_hovered = item
	  hash = {}
	  hash[:name] = [item.name,0,0]
	  if item.durability!=false && !(GameData::Item.get(item).is_foodwater?  || GameData::Item.get(item).is_berry?)
	  hash[:durability] = [item.durability,0,0] 
	  hash[:maxdurability] = [item.max_durability,0,0] 
	  end 
	  if GameData::BerryPlant::WATERING_CANS.include?(item.id) && item.water != false
	  hash[:water] = [item.water,0,0] 
	  hash[:maxwater] = [100,0,0] 
	  end 
      @tooltip.show(hash)

	  end
	  end 
	else 
	  @tooltip.show({})
      @sprites["msgwindow"].visible = false if @sprites["msgwindow"].visible == true
	  @item_hovered = nil
	end 
    Settings::MAX_PARTY_SIZE.times do |i|
	    key = "party#{i}"
	  if @party[i]
	    @sprites["#{i}_slottextpkmn"].text = @party[i].name if @sprites["#{i}_slottextpkmn"].text!=@party[i].name
        @sprites["#{i}_slottextpkmn"].visible=true
		if @party[i].egg?
         @sprites["#{key}bartext"].visible=false if @sprites["#{key}bartext"]
         @sprites["#{key}barfill"].visible=false if @sprites["#{key}barfill"]
         @sprites["#{key}barborder"].visible=false  if @sprites["#{key}barborder"]
		next 
		
		end 
	    min = @party[i].hp
	    max = @party[i].totalhp
		word = "HP"
        update_bar(key,word,min,max)
	    update_status_sprite(i, @party[i])
        @sprites["#{key}bartext"].visible=true
        @sprites["#{key}barfill"].visible=true
        @sprites["#{key}barborder"].visible=true
      else 
       @sprites["#{key}bartext"].visible=false if @sprites["#{key}bartext"]
       @sprites["#{key}barfill"].visible=false if @sprites["#{key}barfill"]
       @sprites["#{key}barborder"].visible=false  if @sprites["#{key}barborder"]
       @sprites["#{i}_slottextpkmn"].visible=false if @sprites["#{i}_slottextpkmn"]
	   update_status_sprite(i, nil)
      end
	end
    if @type==:RESEARCHTABLE && @event_data.is_a?(ResearchTableData)
      if @event_data.update
		remove(@icons["0_slotimage"])
		remove(@icons["0_slottext"])
	    @craft[0]=nil
	  end 
	end 
	
    if @type!=:RESEARCHTABLE && !craft_empty_or_nil?
	  temp_craft = (@type == :FURNACE) ? [@craft[0]] : @craft
      results = get_recipe(temp_craft)
	  if results.empty?
	    if !@result.nil?
	    #remove(@sprites["craft_slots_result"]) if @sprites["craft_slots_result"]
		  remove(@icons["_result_slotimage"]) #if @icons["_result_slotimage"]
		  remove(@icons["_result_slottext"])
		  @result = nil
		
		
		end 
	  elsif results.length>1
	    if @result.nil? || @result!=results[0]
	      @result = results[0]
		  remove(@icons["_result_slotimage"]) #if @icons["_result_slotimage"]
		  remove(@icons["_result_slottext"]) #if @icons["_result_slottext"]
		  item = @result.result[0]
		  amt = @result.yield 
		  new_icon_result(item, amt, "_result")
		end 
	  else
	    if @result.nil? || @result!=results[0]
		  @result = results[0]
		  remove(@icons["_result_slotimage"]) #if @icons["_result_slotimage"]
		  remove(@icons["_result_slottext"]) #if @icons["_result_slottext"]
		  item = @result.result[0]
		  amt = @result.yield 
		  new_icon_result(item, amt, "_result")
		else 
		  
		end 
	  end 
    
    else 
	  remove(@icons["_result_slotimage"]) #if @icons.key?("_result_slotimage")
	  remove(@icons["_result_slottext"]) #if @icons.key?("_result_slottext")
	end 
    refresh_inventory if @type=="Inventory"
	@sprites["tab_alttext"].text = "STA: #{$player.playerstamina}/#{$player.playermaxstamina}" if @type==:GRINDER
	
	
	 if @type==:FURNACE
	   #@sprites["tab_alttext"].text = "FUEL: #{@event_data.fuel}/100.0"
	   if @event_data.fuel>0
        bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/equals_burning"
	   else
        bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/equals"
	   end 
       @sprites["craft_slots_equals"].setBitmap(bitmap)
	   fuel(@craft[1]) if @craft[1]
	   
	   
	   
	 end 
	 
	  @icons.each do |key, value|
	   next unless value.is_a?(PokemonIconSprite)
	   next if value.disposed?
		if value.pokemon && !(value.pokemon.fainted? || value.pokemon.dead?)
	      value.tone = Tone.new(0,0,0,0)
	      value.update
		elsif value.pokemon && value.pokemon.dead?
	      value.tone = Tone.new(64, -64, -64, 255)
		elsif value.pokemon && value.pokemon.fainted?
	      value.tone = Tone.new(0,0,0,255)
		end 
	 
	  end 
	
  end
  alias pbUpdate update
   

  def get_bg
    case @type
	 when :APRICORNMACHINE
	  return :APRICORNCRAFTING
	 when :ITEMCRATE, :PKMNCRATE, :ICEBOX
	  return "Inventory"
     else 
	  return @type 
	end
  end 
  
    def create_status_sprite(index, x, y)
     @icons["status_sprites#{index}"] = IconSprite.new(x,y,@viewport)
     @icons["status_sprites#{index}"].bitmap = @sprites["statuses"].bitmap  
     @icons["status_sprites#{index}"].zoom_x = 0.5
     @icons["status_sprites#{index}"].zoom_y = 0.5
     @icons["status_sprites#{index}"].x = x + 56
     @icons["status_sprites#{index}"].y = y + 6
     @icons["status_sprites#{index}"].z = 0
     @icons["status_sprites#{index}"].src_rect = Rect.new(0, 0, 0, 0)
     @icons["status_sprites#{index}"].visible = false
    end
  
    def update_status_sprite(index, pokemon)
      sprite = @icons["status_sprites#{index}"]
	  return if sprite.nil?
	  if pokemon.nil?
	    sprite.visible = false
        return 
	  end 
      status = -1
      status_icon_width  = 44
      status_icon_height = 16
	if pokemon.egg?
	  sprite.visible=false
	  return
    elsif pokemon.dead?
      status = GameData::Status.count + 1
    elsif pokemon.fainted?
      status = GameData::Status.count - 1
    elsif pokemon.status != :NONE
      status = GameData::Status.get(pokemon.status).icon_position
    elsif pokemon.pokerusStage == 1
      status = GameData::Status.count - 1
    end
	if status < 0
	 sprite.visible = false
     return 
	end 
    sprite.src_rect.set(0, status_icon_height * status, status_icon_width, status_icon_height)
	
	
	sprite.visible = true
  end
  
  def build_sprites
    @sprites["type"]=IconSprite.new(0,0,@viewport)
	craft_type = get_bg
	if pbResolveBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/craftingPage#{craft_type}")
	  bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingPage#{craft_type}"
	else
	  bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingPage"
	end
    @sprites["type"].setBitmap(bitmap)
    @sprites["type"].z = -3 
    @sprites["background"]=IconSprite.new(0,0,@viewport)
	bitmap = "Graphics/Pictures/craftingMenu/placeholder"
    @sprites["background"].setBitmap(bitmap)
    @sprites["background"].z = 0 
	@mamtx = 66
	@mamty = 30
	@bonus_1 = 6
	@bonus_2 = 12
	@start_x = @bonus_1+92-@mamtx-4
	@start_y = @bonus_2+194-@mamty
	@sprites["background"].x= @bonus_1-@mamtx
	@sprites["background"].y= @bonus_2-@mamty
	@sprites["type"].x= @bonus_1-@mamtx
	@sprites["type"].y= @bonus_2-@mamty
	if @type!=:BEDROLL
    @sprites["pkmnside"]=IconSprite.new(0,0,@viewport)
	bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/sidepkmn"
    @sprites["pkmnside"].setBitmap(bitmap)
    @sprites["pkmnside"].z = 0
	@sprites["pkmnside"].x= Graphics.width - 56 - 72 - 12
	@sprites["pkmnside"].y= 14
	slot_size = 36
	Settings::MAX_PARTY_SIZE.times do |i|
	
      @sprites["#{i}_slotimagepkmn"]=IconSprite.new(0,0,@viewport)
      @sprites["#{i}_slotimagepkmn"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
      @sprites["#{i}_slotimagepkmn"].x = @sprites["pkmnside"].x - 4 + @sprites["#{i}_slotimagepkmn"].width/2
      @sprites["#{i}_slotimagepkmn"].y = @sprites["pkmnside"].y - 4 + (slot_size * i) + @sprites["#{i}_slotimagepkmn"].height/2
      @sprites["#{i}_slotimagepkmn"].z = 1
      @sprites["slotimagepkmnstar#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/star"
      @sprites["slotimagepkmnstar#{i}"].setBitmap(bitmap)
      @sprites["slotimagepkmnstar#{i}"].z = 9998
      @sprites["slotimagepkmnstar#{i}"].x = 26+@sprites["#{i}_slotimagepkmn"].x
      @sprites["slotimagepkmnstar#{i}"].y = 2+@sprites["#{i}_slotimagepkmn"].y
      @sprites["slotimagepkmnstar#{i}"].visible = false 
	  

      @sprites["slotimagepkmnbag#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/pkmnitems"
      @sprites["slotimagepkmnbag#{i}"].setBitmap(bitmap)
      @sprites["slotimagepkmnbag#{i}"].z = 9998
      @sprites["slotimagepkmnbag#{i}"].x = 25+@sprites["#{i}_slotimagepkmn"].x
      @sprites["slotimagepkmnbag#{i}"].y = 24+@sprites["#{i}_slotimagepkmn"].y
      @sprites["slotimagepkmnbag#{i}"].visible = false 
	  

      @sprites["slotimagepkmnfod#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/green_dot"
      @sprites["slotimagepkmnfod#{i}"].setBitmap(bitmap)
      @sprites["slotimagepkmnfod#{i}"].z = 9998
      @sprites["slotimagepkmnfod#{i}"].x = @sprites["#{i}_slotimagepkmn"].x + 2
      @sprites["slotimagepkmnfod#{i}"].y = @sprites["#{i}_slotimagepkmn"].y + 30
      @sprites["slotimagepkmnfod#{i}"].visible = false 
	  

      @sprites["slotimagepkmnH2O#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/green_dot"
      @sprites["slotimagepkmnH2O#{i}"].setBitmap(bitmap)
      @sprites["slotimagepkmnH2O#{i}"].z = 9998
      @sprites["slotimagepkmnH2O#{i}"].x = @sprites["#{i}_slotimagepkmn"].x + 6
      @sprites["slotimagepkmnH2O#{i}"].y = @sprites["#{i}_slotimagepkmn"].y + 30
      @sprites["slotimagepkmnH2O#{i}"].visible = false 
	  
	  if @party[i]
	    new_icon_party(@party[i],i)
		create_text3("#{i}_slottextpkmn",@party[i].name,@sprites["#{i}_slotimagepkmn"].x + 28,@sprites["#{i}_slotimagepkmn"].y + 16,MessageConfig::LIGHT_TEXT_MAIN_COLOR,nil,11)
		@sprites["slotimagepkmnstar#{i}"].visible = true if $bag.registered?(@party[i])
	  else 
		create_text3("#{i}_slottextpkmn","             ",@sprites["#{i}_slotimagepkmn"].x + 28,@sprites["#{i}_slotimagepkmn"].y + 16,MessageConfig::LIGHT_TEXT_MAIN_COLOR,nil,11)
	  end 
	  create_status_sprite(i, @sprites["#{i}_slotimagepkmn"].x + 20, @sprites["#{i}_slotimagepkmn"].y)
	end 
	Settings.bag_pocket_names.each_with_index do |name, i|
	
      @sprites["#{name}_image"]=IconSprite.new(0,0,@viewport)
	  if @current_tab == i
      @sprites["#{name}_image"].setBitmap("Graphics/Pictures/notebooktab")
	  else
      @sprites["#{name}_image"].setBitmap("Graphics/Pictures/notebooktabu")
	  end
      @sprites["#{name}_image"].x = @start_x + 2 - 2 if i == 0
      @sprites["#{name}_image"].x = @start_x + 2 +((@sprites["#{Settings.bag_pocket_names[0]}_image"].width-36)*i) if i != 0
      @sprites["#{name}_image"].y = @start_y - 22
      @sprites["#{name}_image"].z = i+10
      @sprites["#{name}_image"].z = 49 if i == @current_tab
	
	
	
      @sprites["#{name}_icon"]=IconSprite.new(0,0,@viewport)
      @sprites["#{name}_icon"].setBitmap("Graphics/Pictures/craftingMenu/bag/bagPocket#{i+1}")
      @sprites["#{name}_icon"].x = @start_x + 8 if i == 0
	  if name == "Battle Items"
      @sprites["#{name}_icon"].x = @start_x + 8 +((@sprites["#{Settings.bag_pocket_names[0]}_image"].width-36)*i) if i != 0
	  elsif name == "Poké Balls"
      @sprites["#{name}_icon"].x = @start_x + 10 +((@sprites["#{Settings.bag_pocket_names[0]}_image"].width-36)*i) if i != 0
	  else
      @sprites["#{name}_icon"].x = @start_x + 16 +((@sprites["#{Settings.bag_pocket_names[0]}_image"].width-36)*i) if i != 0
	  end
      @sprites["#{name}_icon"].y = @start_y - 16
	  @sprites["#{name}_icon"].zoom_x = 0.5
	  @sprites["#{name}_icon"].zoom_y = 0.5
      @sprites["#{name}_icon"].z = i+10
      @sprites["#{name}_icon"].z = 50 if i == @current_tab
	  
	  
      @sprites["#{name}_text"]=Window_UnformattedTextPokemon.new(name)
	  @sprites["#{name}_text"].contents.font.size = 14 
	  @sprites["#{name}_text"].refresh
      pbPrepareWindow(@sprites["#{name}_text"])
      @sprites["#{name}_text"].resizeToFit(name)
	  
      @sprites["#{name}_text"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @sprites["#{name}_image"]
      text_sprite  = @sprites["#{name}_text"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 12 + usable_width / 2 
	  if name == "Battle Items"
      text_sprite.x = 5 + center_x - text_sprite.width / 2
	  else
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  end
	  
	  
      @sprites["#{name}_text"].y=@start_y - 16 - @sprites["#{name}_text"].contents.font.size
      @sprites["#{name}_text"].windowskin=nil
      @sprites["#{name}_text"].baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
	  if i == @current_tab
      @sprites["#{name}_text"].shadowColor=Color.new(248, 248, 248)
	  else
      @sprites["#{name}_text"].shadowColor=Color.new(190, 190, 190)
	  end
      @sprites["#{name}_text"].text=name
      @sprites["#{name}_text"].viewport=@viewport
      @sprites["#{name}_text"].z = i+10
      @sprites["#{name}_text"].z = 50 if i == @current_tab
      @sprites["#{name}_text"].visible=true
	 # @sprites["#{name}_text"].zoom_x = 0.8 
	 # @sprites["#{name}_text"].zoom_y = 0.8
	  
	  
	  
	#  @sprites["#{name}_image"].zoom_x = 0.8 
	 # @sprites["#{name}_image"].zoom_y = 0.8
	
	end
    end 
    @sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible  = false
    @sprites["msgwindow"].viewport = @viewport
    @sprites["cmdwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["cmdwindow"].visible  = false
     @sprites["cmdwindow"].viewport = @viewport

	if @type!=:BEDROLL
    cols = 9
    rows = 4
	slot_size = 36
	max_slots = Settings::BAG_MAX_POCKET_SIZE.max 
	
	max_slots.times do |i|
     col = i % cols
     row = i / cols
     @sprites["slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot"
     @sprites["slots#{i}"].setBitmap(bitmap)
     @sprites["slots#{i}"].z = 70
     @sprites["slots#{i}"].x = @start_x + col * slot_size
     @sprites["slots#{i}"].y = @start_y + row * slot_size
     @sprites["slots_star#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/star"
     @sprites["slots_star#{i}"].setBitmap(bitmap)
     @sprites["slots_star#{i}"].z = 70
     @sprites["slots_star#{i}"].x = 26+@sprites["slots#{i}"].x
     @sprites["slots_star#{i}"].y = 2+@sprites["slots#{i}"].y
     @sprites["slots_star#{i}"].visible = false 
	
	end
	
	update_selected_tab
	end 
	setup_ui
  
  
  
  
  end 


  def normalize_ingredients(list)
    return [] if list.nil?
    normalized = []
	list.each do |entry|
	 next if entry.nil?
	 item, qty = entry.is_a?(Array) ? entry : [entry, 1]
	 item = item.id if item.is_a?(ItemData)
	 qty ||= 1
	 normalized << [item, qty]
	end 
	normalized.sort_by { |item, qty| [item.to_s, qty] }
  end
  
  def get_recipe(ingredients)
    results = []
    inventory = normalize_ingredients(ingredients)
	
	  if @type == :APRICORNMACHINE
        inventory.delete_at(4)
      end
	
	
	results = @crafting_data.select do |recipe|
      required = normalize_ingredients(recipe.recipe)
      remaining = inventory.map(&:dup)
	  
	  if $player.is_it_this_class?(:ENGINEER, false)
        required = required.reject { |item, _| item == :MACHINEBOX }
      end
	  
      inventory_counts = inventory.map(&:first)
      required_counts = required.map(&:first)
      next false if inventory_counts.sort != required_counts.sort
	  next false unless inventory.size == required.size
	  
	  required.all? do |req_item, req_qty|
		index = remaining.index do |inv_item, inv_qty|
		  inv_item == req_item && inv_qty >= req_qty
		end 
		next false unless index
		remaining.delete_at(index)
		true
	  end 
	  
    end
	return results
  end 
  
  def can_afford?(recipe, ingredients)
    normalized_inventory = normalize_ingredients(ingredients)
    normalized_recipe = normalize_ingredients(recipe)
	if @type==:GRINDER && $player.playerstamina-2<-0
	 return false 
	end 
	if @type==:FURNACE && @event_data.fuel-1<-0
	 return false 
	end 
	if @event_data && @event_data.electronic && @event_data.power<=0
	 return false
	end 
	
    result = normalized_recipe.all? do |item, qty|
      inv_qty = normalized_inventory.select { |inv_item, _| inv_item == item }.sum { |_, q| q }
      inv_qty >= qty
    end
  end
  
  def remove_amounts(recipe)
    return if recipe.empty?
    recipe.each do |item, qty_needed|
	  next if qty_needed <= 0
	  remaining = qty_needed
	  
	  while remaining > 0
       taken_this_round = false
	  
	  
	  @craft.each_with_index do |inv_item, index|
	    next unless inv_item && inv_item[0].id == item && inv_item[1] > 0
		
		
	    inv_item[1] -= 1
		remaining -= 1
        taken_this_round = true
		
		
		text = inv_item[1] > 1 ? inv_item[1].to_s : ""
		@icons["#{index}_slottext"].text = text #if @icons.key?("#{index}_slottext")
		
		
		if inv_item[1] <= 0
		remove(@icons["#{index}_slotimage"])
		remove(@icons["#{index}_slottext"])
		end
		
		break if remaining <= 0
		
		
		
		
	  end 
	
      break unless taken_this_round
	  end 
	
	
	
	end 
  
    @craft.each_with_index do |inv_item, index|
     @craft[index] = nil if inv_item && inv_item[1] <= 0
    end
  end 
  
  def get_slot_amount 
    case @type 
	 when :GRINDER, :ELECTRICFURNACE, :RESEARCHTABLE, :GARBAGEBIN
	   return 1
     when "Inventory", :ELECTRICPRESS, :FURNACE
	   return 2 
     when :CRAFTINGBENCH, :SEWINGMACHINE, :CAULDRON
	   return 3
     when :APRICORNCRAFTING, :APRICORNMACHINE 
	   return 4
     when :UPGRADEDCRAFTINGBENCH, :MEDICINEPOT
	   return 5
	 when :ITEMCRATE
	   return @container.maxsize
	 when :ICEBOX
	   return @container.maxsize
	 when :PKMNCRATE
	   return PokemonBox::BOX_SIZE
	 else
	   return 0
	end 
  
  end 



  def build_bar(key,word,x,y,min,max)
    width= 56
    height= 6
	amt = 2
    fillWidth = width-amt
    fillHeight = height-amt
    @sprites["#{key}barborder"] = BitmapSprite.new(width,height,@viewport)
    @sprites["#{key}barborder"].x = x
    @sprites["#{key}barborder"].y = y
    @sprites["#{key}barborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["#{key}barborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["#{key}barfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["#{key}barfill"].x = @sprites["#{key}barborder"].x+(amt/2)
    @sprites["#{key}barfill"].y = @sprites["#{key}barborder"].y+(amt/2)
	minmax = min!="" && max!="" ? ": #{min}/#{max}" : ""
	create_text3("#{key}bartext","#{word}#{minmax}",@sprites["#{key}barborder"].x-16,@sprites["#{key}barborder"].y+20,MessageConfig::LIGHT_TEXT_MAIN_COLOR,nil,11) if word!=""
  end 
  
  def update_bar(key,word,min,max)
	@sprites["#{key}barfill"].bitmap.clear
    fillAmount = (min==0 || max==0) ? 0 : (
      min*@sprites["#{key}barfill"].bitmap.width/max
    )
    if fillAmount > 0
    hpColors = CurrentColors(min, max)
    shadowHeight = 2
    @sprites["#{key}barfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["#{key}barfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["#{key}barfill"].bitmap.height-shadowHeight
      ), hpColors
    )
	end
	minmax = min!="" && max!="" ? ": #{min}/#{max}" : ""
	@sprites["#{key}bartext"].text = "#{word}#{minmax}" if word!=""
  end 
  
  
  def createBars(viewport)
    x = @bonus_1+150
    width= 56
    height= 6
    fillWidth = width-2
    fillHeight = height-2
	
    tab_name = Settings.bag_pocket_names[@current_tab]

	if true
    @sprites["hpbarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["hpbarborder"].x = @bonus_1+76-width/2
    @sprites["hpbarborder"].y = (@sprites["trainer"].y-height/2)+100
    @sprites["hpbarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["hpbarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["hpbarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["hpbarfill"].x = @bonus_1+76-fillWidth/2
    @sprites["hpbarfill"].y = (@sprites["trainer"].y-fillHeight/2)+100
	create_text2("HP","HP: #{$player.playerhealth}/#{$player.playermaxhealth2}",@sprites["hpbarborder"].x-20,@sprites["hpbarborder"].y)
	end
	
	
	if true
    @sprites["fodbarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["fodbarborder"].x = x-width/2
    @sprites["fodbarborder"].y = (@sprites["trainer"].y-height/2)+18
    @sprites["fodbarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["fodbarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["fodbarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["fodbarfill"].x = x-fillWidth/2
    @sprites["fodbarfill"].y = (@sprites["trainer"].y-fillHeight/2)+18
	create_text("FOD",@sprites["fodbarborder"].x-20,@sprites["fodbarborder"].y)
	end
	
	if true
	
    @sprites["H2Obarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["H2Obarborder"].x = x-width/2
    @sprites["H2Obarborder"].y = (@sprites["trainer"].y-height/2)+38
    @sprites["H2Obarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["H2Obarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["H2Obarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["H2Obarfill"].x = x-fillWidth/2
    @sprites["H2Obarfill"].y = (@sprites["trainer"].y-fillHeight/2)+38
	create_text("H2O",@sprites["H2Obarborder"].x-20,@sprites["H2Obarborder"].y)
	end
	
	
	if true
    @sprites["SLPbarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["SLPbarborder"].x = x-width/2
    @sprites["SLPbarborder"].y = (@sprites["trainer"].y-height/2)+58
    @sprites["SLPbarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["SLPbarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["SLPbarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["SLPbarfill"].x = x-fillWidth/2
    @sprites["SLPbarfill"].y = (@sprites["trainer"].y-fillHeight/2)+58
	create_text("SLP",@sprites["SLPbarborder"].x-20,@sprites["SLPbarborder"].y)
	end
    

  end


  def refresh_inventory
    width= 70
    height= 10
    fillWidth = width-4
    fillHeight = height-4
	if true
	@sprites["hpbarfill"].bitmap.clear
    fillAmount = ($player.playerhealth==0 || $player.playermaxhealth2==0) ? 0 : (
      $player.playerhealth*@sprites["hpbarfill"].bitmap.width/$player.playermaxhealth2
    )
    if fillAmount > 0
    hpColors = CurrentColors($player.playerhealth, $player.playermaxhealth2)
    shadowHeight = 2
    @sprites["hpbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["hpbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfill"].bitmap.height-shadowHeight
      ), hpColors
    )
    end

    @sprites["HP_text"].baseColor=hpColors
    @sprites["HP_text"].text="HP: #{$player.playerhealth}/#{$player.playermaxhealth2}"
   end
   

	if @buttons["equipment_button"]==false 
	if true
	@sprites["fodbarfill"].visible = true
    @sprites["fodbarborder"].visible = true
    @sprites["SLPbarborder"].visible = true
    @sprites["SLPbarfill"].visible = true
    @sprites["H2Obarborder"].visible = true
    @sprites["H2Obarfill"].visible = true
	@sprites["FOD_text"].visible = true
	@sprites["H2O_text"].visible = true
	@sprites["SLP_text"].visible = true
	amt = 3
	amt+=1 if @type == :APRICORNMACHINE
	amt.times do |i|
	 next if @sprites["craft_slots#{i+100}"].nil?
	 @sprites["craft_slots#{i+100}"].visible = false 
	 next if @icons["#{i+100}_slotimage"].nil? || !@icons["#{i+100}_slotimage"].nil? && @icons["#{i+100}_slotimage"].disposed?
	 @icons["#{i+100}_slotimage"].visible = false 
	end 
	end
	if true
	@sprites["fodbarfill"].bitmap.clear
    fillAmount = ($player.playerfood==0 || $player.playermaxfood==0) ? 0 : (
      $player.playerfood*@sprites["fodbarfill"].bitmap.width/$player.playermaxfood
    )
    if fillAmount > 0
	if $player.playersaturation > 0
    foodColors = CurrentColorsAlt($player.playerfood, $player.playermaxfood)
	else
    foodColors = CurrentColors($player.playerfood, $player.playermaxfood)
	end
    shadowHeight = 2
    @sprites["fodbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), foodColors
    )
    @sprites["fodbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["fodbarfill"].bitmap.height-shadowHeight
      ), foodColors
    )
    end

    @sprites["FOD_text"].baseColor=foodColors
   end
	if true
	@sprites["H2Obarfill"].bitmap.clear
    fillAmount = ($player.playerwater==0 || $player.playermaxwater==0) ? 0 : (
      $player.playerwater*@sprites["H2Obarfill"].bitmap.width/$player.playermaxwater
    )
    if fillAmount > 0
	if $player.playersaturation > 0
    waterColors = CurrentColorsAlt($player.playerwater, $player.playermaxwater)
	else
    waterColors = CurrentColors($player.playerwater, $player.playermaxwater)
	end
    shadowHeight = 2
    @sprites["H2Obarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), waterColors
    )
    @sprites["H2Obarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["H2Obarfill"].bitmap.height-shadowHeight
      ), waterColors
    )
    end

    @sprites["H2O_text"].baseColor=waterColors
   end
	if true
	@sprites["SLPbarfill"].bitmap.clear
    fillAmount = ($player.playersleep==0 || $player.playermaxsleep==0) ? 0 : (
      $player.playersleep*@sprites["SLPbarfill"].bitmap.width/$player.playermaxsleep
    )
    if fillAmount > 0
    slpColors = CurrentColors($player.playersleep, $player.playermaxsleep)
    shadowHeight = 2
    @sprites["SLPbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), slpColors
    )
    @sprites["SLPbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["SLPbarfill"].bitmap.height-shadowHeight
      ), slpColors
    )
    end

    @sprites["SLP_text"].baseColor=slpColors



   end
    else
	if true 
	@sprites["fodbarfill"].visible = false
    @sprites["fodbarborder"].visible = false
    @sprites["SLPbarborder"].visible = false
    @sprites["SLPbarfill"].visible = false
    @sprites["H2Obarborder"].visible = false
    @sprites["H2Obarfill"].visible = false
	@sprites["FOD_text"].visible = false
	@sprites["H2O_text"].visible = false
	@sprites["SLP_text"].visible = false
	amt = 3
	amt.times do |i|
	 next if @sprites["craft_slots#{i+100}"].nil?
	 @sprites["craft_slots#{i+100}"].visible = true 
	 next if @icons["#{i+100}_slotimage"].nil? || !@icons["#{i+100}_slotimage"].nil? && @icons["#{i+100}_slotimage"].disposed?
	 @icons["#{i+100}_slotimage"].visible = true 
	end 
	
	
	
	end
    end
   
   
   
   
   
  end

  
  def pbEndScene
    if @type !=:GARBAGEBIN
    if @type == :ITEMCRATE 
	 @container.items = @craft
	else 
	 if @type == :RESEARCHTABLE &&  @craft[0] 
	   if @craft[0][1]>0
	    @craft[0][1]-=1
		if @event_data.researching_item.nil?
	     @event_data.research(@craft[0][0])
		elsif @event_data.researching_item != @craft[0][0] 
	     @event_data.research(@craft[0][0])
		end 
		
		if !@event_data.active_researches.empty?
		 if @craft[0][1]==0
	      @craft[0]=nil 
		 end
		else 
		  @craft[0][1]+=1
	      sideDisplay(_INTL("There are no recipes for #{@craft[0][0].name}."))
		  @event_data.reset
		end
	   end
	 end 
     @craft.each do |data|
	  next if data.nil?
	  $bag.add(data[0],data[1])
	 end 
	end 
    end
    $player.playershirt, $player.playerpants, $player.playershoes = @equip.map { |data| data ? data[0] : nil } if @type == "Inventory"
    pbDisposeSpriteHash(@icons)
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@objects)
	@tooltip.dispose
    @viewport.dispose
  end
  
  
  def use_item_on_pokemon(pkmn)
	  ret = nil
    item = @grabbed_item[:stack][0]
	amt = @grabbed_item[:stack][1]
    itm = GameData::Item.get(item)
      if itm.is_machine?
        machine = itm.move
        return false if !machine
        movename = GameData::Move.get(machine).name
        if pkmn.shadowPokemon?
          pbMessage(_INTL("Shadow Pokémon can't be taught any moves.")) 
        elsif !pkmn.compatible_with_move?(machine)
          pbMessage(_INTL("{1} can't learn {2}.", pkmn.name, movename))
        else
          pbMessage(_INTL("\\se[PC access]You booted up {1}.\1", itm.name)) 
          if pbConfirmMessage(_INTL("Do you want to teach {1} to {2}?", movename, pkmn.name)) 
            if pbLearnMove(pkmn, machine, false, true)
              if itm.consumed_after_use?
	             icon = @grabbed_item[:icon]
	             icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	             remove(icon)
	             remove(icon_text)
			     current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		         @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
              end 			  
              return true
            end
          end
        end
        return false
      end
      qty = 1
      max_at_once = ItemHandlers.triggerUseOnPokemonMaximum(item, pkmn)
      max_at_once = [max_at_once, amt].min
      if max_at_once > 1
      qty = pbChooseNumber(_INTL("How many {1} do you want to use?", itm.name), max_at_once)
	  end
	  return false if qty <= 0
      ret = ItemHandlers.triggerUseOnPokemon(item, qty, pkmn, self)
      if ret && itm.consumed_after_use?
	    @grabbed_item[:stack][1]-=1
		if @grabbed_item[:stack][1]==0
	             icon = @grabbed_item[:icon]
	             icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	             remove(icon)
	             remove(icon_text)
			     current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		         @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
				 @grabbed_item = nil
		end 
	  end
      return ret
	  
  end
  
  
  
  
  



  def pbRefresh
   # update_selected_tab
  end
  def left_click_tab
    return if @type == :BEDROLL
    tab_sprites = Settings.bag_pocket_names.map { |name| @sprites["#{name}_image"] }
    tab_sprites.sort_by! { |s| -s.z }
    tab_sprites.each do |sprite|
      if tab_clicked?(sprite)
        name = @sprites.key(sprite).sub("_image", "")
	    @current_tab = Settings.bag_pocket_names.index(name)
		update_selected_tab
        break 
      end
    end
  end
  
 
  
  def clicked_on?
    mouse_x, mouse_y = Mouse.getMousePos
    return nil if mouse_x.nil? || mouse_y.nil?
    @objects.each do |key, sprite|
    next if sprite.nil? || !sprite.visible

    x1 = sprite.x
    y1 = sprite.y
    x2 = x1 + sprite.width
    y2 = y1 + sprite.height

    return key if mouse_x >= x1 && mouse_x < x2 &&
                     mouse_y >= y1 && mouse_y < y2
    end

  return 
  end 
  
  def crafting_blocked?
    
	return false 
  end 
  
  def equipment_blocked?
    return true if @type == "Inventory" && @buttons["equipment_button"]==false 
  
	return false 
  end 
  
  def set_max_durability(item)
	item.max_durability = 10 if item.id == :WHITEFLUTE || item.id == :BLACKFLUTE
	item.max_durability = 25 if item.id == :BOWL || item.id == :GLASSBOTTLE || item.id == :WATERBOTTLE
    item.durability = item.max_durability
  
  
  
  
  end 
  
  
  def left_click_item
    index, col, row = slot_from_mouse
	crafting_index = crafting_slot_from_mouse
	pokemon_index = pokemon_slot_from_mouse
	if !index.nil?
    if @sprites["slots#{index}"].name != "Graphics/Pictures/craftingMenu/placeholder_slot_2"
    if @grabbed_item.nil?
      slot_item = current_pocket[index]
      icon = @icons["#{index}_image"]
	  if slot_item && icon
        @grabbed_item = { 
		icon: icon,
        stack: current_pocket[index],
        index: index,
		craft: false }
	  end 

    else
	 if !@grabbed_item[:stack][0].is_a?(Pokemon)
	
      slot_item = current_pocket[index]
	  if slot_item
	    if index == @grabbed_item[:index]
	       icon = @grabbed_item[:icon]
	       icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	       remove(icon)
	       remove(icon_text)
           @grabbed_item = nil
		   update_selected_tab
	  
	  
	    elsif slot_item[0].is_a?(ItemData) && slot_item[0].identical(@grabbed_item[:stack][0])
		  item = slot_item[0]
		  amt = slot_item[1]
		  if amt<item.stack_size
			if @grabbed_item[:stack][1]>0
			  nu_amt = [@grabbed_item[:stack][1], item.stack_size - amt].min
		      slot_item[1] += nu_amt
	          @grabbed_item[:stack][1] -= nu_amt
	           text_icon = @icons["#{index}_text"]
	          if slot_item[1]>1
	           text = slot_item[1].to_s
	          else
	           text = ""
	          end
			   text_icon.text = text
			 if @grabbed_item[:stack][1]==0
	             icon = @grabbed_item[:icon]
	             icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	             remove(icon)
	             remove(icon_text)
			     current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		         @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
				 @grabbed_item = nil
			 end
			end
		  end



		end






	  else
	    icon = @grabbed_item[:icon]
	    icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	    icon.z = 98
	     item = @grabbed_item[:stack][0]
		 amt = @grabbed_item[:stack][1]
	     current_pocket[index] = [item, amt]
	     new_icon(item, amt,index,col,row)
	     remove(icon)
	       remove(icon_text)
		 current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
         @grabbed_item = nil
	  end 
    end 



	
	end
    end 

    elsif !pokemon_index.nil? && pokemon_index.is_a?(Integer)
	 if !@grabbed_item.nil?
	  if @grabbed_item[:stack][0].is_a?(Pokemon)
	    if @party[pokemon_index].nil?
		  pokemon = @grabbed_item[:stack][0]
		  icon = @grabbed_item[:icon]
		  if @grabbed_item[:index]!="held"
		  @party.include?(pokemon) ? @party[@grabbed_item[:index]] = nil : @pokemon[@grabbed_item[:index]] = nil
		  end
		  @party[pokemon_index] = pokemon
	      remove(icon)
	      #icon.visible = false 
		  #@icons.delete("craft_slots#{@grabbed_item[:index]}"
		  new_icon_party(pokemon,pokemon_index)
		  @grabbed_item = nil
		elsif @party[pokemon_index] == @grabbed_item[:stack][0]
		  pokemon = @grabbed_item[:stack][0]
		  icon = @grabbed_item[:icon]
	      remove(icon)
		  new_icon_party(pokemon,pokemon_index)
		  @grabbed_item = nil
		else 
		  pokemon1 = @grabbed_item[:stack][0]
		  pokemon2 = @party[pokemon_index]
		  if @grabbed_item[:index]!="held"
		  @party.include?(pokemon1) ? @party[@grabbed_item[:index]] = nil : @pokemon[@grabbed_item[:index]] = nil
		  end
		  icon1 = @grabbed_item[:icon]
		  icon2 = @icons["#{pokemon_index}_partyimage"]
	      remove(icon1)
	      remove(icon2)
		  new_icon_party2(pokemon2,"held",pokemon_index)
		  icon3 = @icons["held_partyimage"]
		  
	      old_crafting_stack = [pokemon2,1]
	      if old_crafting_stack && icon3
            @grabbed_item = { 
		      icon: icon3,
              stack: old_crafting_stack,
              index: "held",
		      craft: false
		    }
	      end 
		  @party[pokemon_index] = pokemon1
		  new_icon_party(pokemon1,pokemon_index)
		  
		  
		end 
	  else
	   if @party[pokemon_index]
	    pokemon = @party[pokemon_index]
	    item = @grabbed_item[:stack][0]
        itm = GameData::Item.get(item)
		if pokemon.hyper_mode && !GameData::Item.get(item)&.is_scent?
		  return 
		end
		if !pbCanUseOnPokemon?(itm)
		  return
		end 
        if itm.is_machine?
          move = itm.move
          return if pokemon.hasMove?(move) || !pokemon.compatible_with_move?(move)
        end
        
		use_item_on_pokemon(pokemon)

       end 
    

      end
     else 
	  if pokemon_index.is_a?(Integer) && @party[pokemon_index]
	     old_crafting_stack = [@party[pokemon_index],1]
	     icon = @icons["#{pokemon_index}_partyimage"]
	    if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: pokemon_index,
		   craft: false
		  }
	    end 
	  end
	 end 
    
    elsif !crafting_index.nil? && @type==:PKMNCRATE && crafting_index.is_a?(Integer)
	 if !@grabbed_item.nil?
	  if @grabbed_item[:stack][0].is_a?(Pokemon)
	    if @pokemon[crafting_index].nil?
		  pokemon = @grabbed_item[:stack][0]
		  icon = @grabbed_item[:icon]
		  if @grabbed_item[:index]!="held"
		  @party.include?(pokemon) ? @party[@grabbed_item[:index]] = nil : @pokemon[@grabbed_item[:index]] = nil
		  end
		  @pokemon[crafting_index] = pokemon
	      remove(icon)
	      #icon.visible = false 
		  #@icons.delete("craft_slots#{@grabbed_item[:index]}"
		  new_icon_pkmncrate2(pokemon,crafting_index)
		  @grabbed_item = nil
		elsif @pokemon[crafting_index] == @grabbed_item[:stack][0]
		  pokemon = @grabbed_item[:stack][0]
		  icon = @grabbed_item[:icon]
	      remove(icon)
		  new_icon_pkmncrate2(pokemon,crafting_index)
		  @grabbed_item = nil
		else 
		  pokemon1 = @grabbed_item[:stack][0]
		  pokemon2 = @pokemon[crafting_index]
		  if @grabbed_item[:index]!="held"
		  @party.include?(pokemon1) ? @party[@grabbed_item[:index]] = nil : @pokemon[@grabbed_item[:index]] = nil
		  end
		  icon1 = @grabbed_item[:icon]
		  icon2 = @icons["#{crafting_index}_slotimage"]
	      remove(icon1)
	      remove(icon2)
		  new_icon_pkmncrate3(pokemon2,"held",crafting_index)
		  icon3 = @icons["held_slotimage"]
		  
	      old_crafting_stack = [pokemon2,1]
	      if old_crafting_stack && icon3
            @grabbed_item = { 
		      icon: icon3,
              stack: old_crafting_stack,
              index: "held",
		      craft: false
		    }
	      end 
		  @pokemon[crafting_index] = pokemon1
		  new_icon_pkmncrate2(pokemon1,crafting_index)
		  
		end 
	  else
	   if @pokemon[crafting_index]
	    pokemon = @pokemon[crafting_index]
	    stack = @grabbed_item[:stack][0]
	    item, amt = stack
        itm = GameData::Item.get(item)
		if pokemon.hyper_mode && !GameData::Item.get(item)&.is_scent?
		  return 
		end
		if !pbCanUseOnPokemon?(itm)
		  return
		end 
        if itm.is_machine?
          move = itm.move
          return if pokemon.hasMove?(move) || !pokemon.compatible_with_move?(move)
        end
		use_item_on_pokemon(pokemon)
		
		
		
       end 
    

      end
     else 
	 
	 
	 

	  if crafting_index.is_a?(Integer) && @pokemon[crafting_index]
	     old_crafting_stack = [@pokemon[crafting_index],1]
	     icon = @icons["#{crafting_index}_slotimage"]
	    if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: crafting_index,
		   craft: false
		  }
	    end 
	  end



	 end 
    elsif !crafting_index.nil? && !crafting_blocked? && (crafting_index=="_result" || (crafting_index.is_a?(Integer) && crafting_index<100))
	  return if @grabbed_item && @grabbed_item[:stack][0].is_a?(Pokemon)
	 if !@grabbed_item.nil? 
	  if crafting_index!="_result"
	  if !@craft[crafting_index]
	    icon = @grabbed_item[:icon]
	    icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	    icon.z = 98
	    item, amt = @grabbed_item[:stack]
	    @craft[crafting_index] = [item, amt]
	    new_icon2(item, amt, crafting_index)
	    remove(icon)
	    remove(icon_text)
	    current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
	    @grabbed_item = nil
	  else
       if @craft[crafting_index][0].identical(@grabbed_item[:stack][0]) && @craft[crafting_index][1]<@craft[crafting_index][0].stack_size
		   old_qty = @craft[crafting_index][1]
		   amt = @grabbed_item[:stack][1]
		   @craft[crafting_index][1]=[@craft[crafting_index][1]+amt, @craft[crafting_index][0].stack_size].min
		   added = @craft[crafting_index][1] - old_qty
		   @grabbed_item[:stack][1] -= added
           item = GameData::Item.get(@craft[crafting_index][0])
		   pocket = item.pocket
	       @current_tab = pocket-1
		   update_selected_tab
		   if @craft[crafting_index][1]>1
	         text = @craft[crafting_index][1].to_s
	       else
	         text = ""
	       end
		   @icons["#{crafting_index}_slottext"].text = text
		   if @grabbed_item[:stack][1]<=0
		      icon = @grabbed_item[:icon]
	          icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	          remove(icon)
	          remove(icon_text)
	          current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		      @grabbed_item = nil
		   end 

		end 
      end 
 
	  
      elsif @result && crafting_index=="_result" 
		recipe = @result.recipe
	    if can_afford?(recipe, @craft)
		 itemdata = ItemData.new(@result.result[0])
		 set_max_durability(itemdata)
		 bottle_entry = @craft.each_with_index.find do |(item, _qty), _i|
           BOTTLE_ITEMS.include?(item&.id)
         end
		 if bottle_entry
          bottle_item, _qty = bottle_entry[0]
		  if CONTAINER_ITEMS.include?(bottle_item.id)
		    bottle = bottle_item
		  else
		    bottle = bottle_item.bottle
		  end 
		  itemdata.set_bottle(bottle) if bottle 
		 end 
		 if @type == :APRICORNMACHINE
		  modifier_item = @craft[4]
		 
		 
		 end 
		 
		 if itemdata.identical(@grabbed_item[:stack][0])
		 if @grabbed_item[:stack][1]<itemdata.stack_size

		   amt = @result.yield 
	       old_crafting_stack = [itemdata,amt]
		   new_crafting_index = "_crafted"
		   
		   @grabbed_item[:stack][1]=[@grabbed_item[:stack][1]+amt, itemdata.stack_size].min
		   
		   remove_amounts(recipe)
           item = GameData::Item.get(old_crafting_stack[0])
		   pocket = item.pocket
	       @current_tab = pocket-1
		   update_selected_tab
		   @event_data.fuel-=1 if @type==:FURNACE
		   $player.playerstamina-=2 if @type==:GRINDER
		   if craft_empty_or_nil? || !can_afford?(recipe, @craft)
		    remove(@icons["#{crafting_index}_slotimage"])
		    remove(@icons["#{crafting_index}_slottext"])
		   end 
		   @result = nil 
         end 
         end 
        end
      end 
     else
	  if @result && crafting_index=="_result"
		recipe = @result.recipe
		
	    if can_afford?(recipe, @craft)
		 itemdata = ItemData.new(@result.result[0])
		 set_max_durability(itemdata)
		 bottle_entry = @craft.each_with_index.find do |(item, _qty), _i|
           BOTTLE_ITEMS.include?(item&.id)
         end
		 if bottle_entry
          bottle_item, _qty = bottle_entry[0]
		  if CONTAINER_ITEMS.include?(bottle_item.id)
		    bottle = bottle_item
		  else
		    bottle = bottle_item.bottle
		  end 
		  itemdata.set_bottle(bottle) if bottle 
		 end 
		 if @type == :APRICORNMACHINE
		  modifier_item = @craft[4]
		 
		 
		 end 
		 amt = @result.yield 
	     old_crafting_stack = [itemdata,amt]
		 new_crafting_index = "_crafted"
	     new_icon_crafted(itemdata, amt, new_crafting_index)
	     icon = @icons["#{new_crafting_index}_slotimage"]
		 
		 remove_amounts(recipe)
         item = GameData::Item.get(old_crafting_stack[0])
		 pocket = item.pocket
	     @current_tab = pocket-1
		   update_selected_tab
		   @event_data.fuel-=1 if @type==:FURNACE
		   $player.playerstamina-=2 if @type==:GRINDER
	     if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: new_crafting_index,
		   craft: true
		  }
	     end 
		 
		 
		 if craft_empty_or_nil? || !can_afford?(recipe, @craft)
		  remove(@icons["#{crafting_index}_slotimage"])
		  remove(@icons["#{crafting_index}_slottext"])
		 end 
		 @result = nil 
		end 
	  elsif (crafting_index.is_a?(Integer) && @craft[crafting_index])
	     old_crafting_stack = @craft[crafting_index]
	     icon = @icons["#{crafting_index}_slotimage"]
        item = GameData::Item.get(old_crafting_stack[0])
		pocket = item.pocket
	    @current_tab = pocket-1
		update_selected_tab
	    if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: crafting_index,
		   craft: true
		  }
	    end 
		@craft[crafting_index] = nil 
		if @result
		 remove(@icons["_result_slotimage"])
		 remove(@icons["_result_slottext"])
		 @result = nil 
		end
	  end
	 end 
    elsif !crafting_index.nil? && !equipment_blocked? && crafting_index.is_a?(Integer) && crafting_index>=100
	  return if @grabbed_item && @grabbed_item[:stack][0].is_a?(Pokemon)
	 if !@grabbed_item.nil?
	 
	  if !@equip[crafting_index-100]
	    icon = @grabbed_item[:icon]
	    icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	    icon.z = 98
	    item, amt = @grabbed_item[:stack]
	    @equip[crafting_index-100] = [item, amt]
	    new_icon2(item, amt, crafting_index)
	    remove(icon)
	    remove(icon_text)
	    current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
	    @grabbed_item = nil
	  else
       if @craft[crafting_index][0].identical(@grabbed_item[:stack][0]) && @equip[crafting_index-100][1]<@equip[crafting_index-100][0].stack_size
		   old_qty = @equip[crafting_index-100][1]
		   amt = @grabbed_item[:stack][1]
		   @equip[crafting_index-100][1]=[@equip[crafting_index-100][1]+amt, @equip[crafting_index-100][0].stack_size].min
		   added = @equip[crafting_index-100][1] - old_qty
		   @grabbed_item[:stack][1] -= added
           item = GameData::Item.get(@equip[crafting_index-100][0])
		   pocket = item.pocket
	       @current_tab = pocket-1
		   update_selected_tab
		   if @equip[crafting_index-100][1]>1
	         text = @equip[crafting_index-100][1].to_s
	       else
	         text = ""
	       end
		   @icons["#{crafting_index}_slottext"].text = text
		   if @grabbed_item[:stack][1]<=0
		      icon = @grabbed_item[:icon]
	          icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	          remove(icon)
	          remove(icon_text)
	          current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		      @grabbed_item = nil
		   end 

		end 
      end 
 
	  



     else
	 
	  if (crafting_index.is_a?(Integer) && @equip[crafting_index-100])
	     old_crafting_stack = @equip[crafting_index-100]
	     icon = @icons["#{crafting_index}_slotimage"]
        item = GameData::Item.get(old_crafting_stack[0])
		pocket = item.pocket
	    @current_tab = pocket-1
		update_selected_tab
	    if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: crafting_index,
		   craft: true
		  }
	    end 
		@equip[crafting_index-100] = nil 
	  end


	 end 
    elsif object = clicked_on?
	  return if @grabbed_item && @grabbed_item[:stack][0].is_a?(Pokemon)
	  if object == "equipment_button"
	    if @buttons["equipment_button"]==false
		  @buttons["equipment_button"]=true
	      bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_down"
          @objects["equipment_button"].setBitmap(bitmap)
	    else
		  @buttons["equipment_button"]=false
	      bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up"
          @objects["equipment_button"].setBitmap(bitmap)
		end 
	  elsif object == "player_square"
	    if !@grabbed_item.nil?
		 item = @grabbed_item[:stack][0]
		 return false if @grabbed_item[:stack][1]<=0
		 itm = GameData::Item.get(item)
		 if itm.is_foodwater? || itm.is_berry?
		   if pbNeoEating(item)
		     @grabbed_item[:stack][1]-=1
			 if @grabbed_item[:stack][1]==0
	            icon = @grabbed_item[:icon]
	            icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	            remove(icon)
	            remove(icon_text)
		        current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		        @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
				@grabbed_item = nil
			 end 
		   end 
		 elsif itm.is_medicine?
		   if pbNeoMedicine(item)
		     @grabbed_item[:stack][1]-=1
			 if @grabbed_item[:stack][1]==0
	            icon = @grabbed_item[:icon]
	            icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	            remove(icon)
	            remove(icon_text)
		        current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		        @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
				@grabbed_item = nil
			 end 
		   end 
		 end 
		
		end 
	  end 
	end 

  end 
  
  
  def right_click_item
    index, col, row = slot_from_mouse
	crafting_index = crafting_slot_from_mouse
	
	if !index.nil?
    if @grabbed_item.nil?
      slot_item = current_pocket[index]
	  if slot_item
	   if current_pocket[index][1]>1
	    item = slot_item[0]
	    new_icon(item, 1,"held",col,row)
        icon = @icons["held_image"]
	    text_icon = @icons["#{index}_text"]
	    amt = (current_pocket[index][1] / 2.0).ceil
	    current_pocket[index][1] -= amt
	    if current_pocket[index][1]>1
	      text = current_pocket[index][1].to_s
	    else
	      text = ""
	    end
	    @icons["#{index}_text"].text = text
	    new_stack = [current_pocket[index][0],amt]
	    if slot_item && icon
         @grabbed_item = { 
		 icon: icon,
         stack: new_stack,
         index: "held",
		 craft: false}
	    end 


	   else
      slot_item = current_pocket[index]
      icon = @icons["#{index}_image"]
	  if slot_item && icon
        @grabbed_item = { 
		icon: icon,
        stack: current_pocket[index],
        index: index,
		craft: false}
	  end 
	  end
     end
    else
	 if true
      slot_item = current_pocket[index]
	  if slot_item
	    if index == @grabbed_item[:index]
	       icon = @grabbed_item[:icon]
	       remove(icon)
	       icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	       remove(icon_text)
           @grabbed_item = nil
		   update_selected_tab
		elsif slot_item[0].is_a?(ItemData) && slot_item[0].identical(@grabbed_item[:stack][0])
		  item = slot_item[0]
		  amt = slot_item[1]



		  
		  if amt<item.stack_size
			if @grabbed_item[:stack][1]>0
	          @grabbed_item[:stack][1] -= 1
		      slot_item[1] += 1
	           text_icon = @icons["#{index}_text"]
	           if slot_item[1]>1
	            text = slot_item[1].to_s
	           else
	            text = ""
	           end
			   text_icon.text = text
			   if @grabbed_item[:stack][1]==0
	             icon = @grabbed_item[:icon]
	             remove(icon)
	            
	             icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	             remove(icon_text)
			     current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		         @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
				 @grabbed_item = nil
			  end
			end


		  end




		else
		
		
		
		
		
		end
	  else
	  icon = @grabbed_item[:icon]
	  icon.z = 98
	   item, amt = @grabbed_item[:stack]
	   current_pocket[index] = [item, 1]
	   new_icon(item, 1,index,col,row)
		 
	   amt -= 1 
       if amt > 0
	     @grabbed_item[:stack][1] = amt
       else 
	     remove(icon)
	       icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	       remove(icon_text)
		 current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
         @grabbed_item = nil
	   end
	  end 
     end 
	end

    elsif !crafting_index.nil? && !equipment_blocked? && crafting_index.to_i>=100

     if !@grabbed_item.nil?
	  if crafting_index.is_a?(Integer)
	    if @equip[crafting_index-100]
	    if crafting_index == @grabbed_item[:index]
	       icon = @grabbed_item[:icon]
	       remove(icon)
	       icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	       remove(icon_text)
           @grabbed_item = nil
		   update_selected_tab
		elsif @equip[crafting_index-100][0].is_a?(ItemData) && @equip[crafting_index-100][0].identical(@grabbed_item[:stack][0])
		  item = @equip[crafting_index-100][0]
		  amt = @equip[crafting_index-100][1]
		  if amt<item.stack_size
			if @grabbed_item[:stack][1]>0
			
              itm = GameData::Item.get(item)
              pocket = itm.pocket
              @current_tab = pocket-1
			  update_selected_tab
	          @grabbed_item[:stack][1] -= 1
		      @equip[crafting_index-100][1] += 1
	           text_icon = @icons["#{crafting_index}_slottext"]
	           if @equip[crafting_index-100][1]>1
	            text = @equip[crafting_index-100][1].to_s
	           else
	            text = ""
	           end
			   text_icon.text = text
			   if @grabbed_item[:stack][1]==0
	             icon = @grabbed_item[:icon]
	             remove(icon)
	            
	             icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	             remove(icon_text)
			     current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
		         @craft[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==true && @grabbed_item[:index]!="_result" && @grabbed_item[:index]!="_crafted"
				 @grabbed_item = nil
			  end
			end


		  end
		end
        else
	    icon = @grabbed_item[:icon]
	    icon.z = 98
	    item, amt = @grabbed_item[:stack]
	    @equip[crafting_index-100] = [item, 1]
	    new_icon2(item, 1,crafting_index)
	    amt -= 1 
       if amt > 0
	     @grabbed_item[:stack][1] = amt
       else 
	     remove(icon)
	     icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	     remove(icon_text)
		 current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
         @grabbed_item = nil
	   end
		
		end 
	  end
	 else
	 
	  if (crafting_index.is_a?(Integer) && @equip[crafting_index-100])
	  
	  	if @equip[crafting_index-100]>1
	    item = @equip[crafting_index-100][0]
	    new_icon3(item, 1,"held", crafting_index)
        icon = @icons["held_image"]
	    text_icon = @icons["#{crafting_index}_slotimage"]
	    amt = (@equip[crafting_index-100][1] / 2.0).ceil
	    @equip[crafting_index-100][1] -= amt
	    if @equip[crafting_index-100][1]>1
	      text =@equip[crafting_index-100][1].to_s
	    else
	      text = ""
	    end
	    @icons["#{crafting_index}_slottext"].text = text
	    new_stack = [@equip[crafting_index-100][0],amt]
	    if @equip[crafting_index-100] && icon
         @grabbed_item = { 
		 icon: icon,
         stack: new_stack,
         index: "held",
		 craft: false}
	    end 


	   else
      icon_old = @icons["#{crafting_index}_slottext"]
	  remove(icon_old)
	  icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	  remove(icon_text)
	  new_icon3(@equip[crafting_index-100][0], @equip[crafting_index-100][1],"held", crafting_index)
	  new_stack = [@equip[crafting_index-100][0],@equip[crafting_index-100][1]]
      icon = @icons["held_image"]
		@equip[crafting_index-100]=nil
	  if new_stack && icon
        @grabbed_item = { 
		icon: icon,
        stack: new_stack,
        index: "held",
		craft: false}
	  end 
	  end


	  end

	 
     end 
    
    elsif !crafting_index.nil? && !crafting_blocked?
     if !@grabbed_item.nil?
	  if @result && crafting_index=="_result"
	   if true 
		recipe = @result.recipe
	    if can_afford?(recipe, @craft)
		 itemdata = ItemData.new(@result.result[0])
		 set_max_durability(itemdata)
		 bottle_entry = @craft.each_with_index.find do |(item, _qty), _i|
           BOTTLE_ITEMS.include?(item&.id)
         end
		 if bottle_entry
          bottle_item, _qty = bottle_entry[0]
		  if CONTAINER_ITEMS.include?(bottle_item.id)
		    bottle = bottle_item
		  else
		    bottle = bottle_item.bottle
		  end 
		  itemdata.set_bottle(bottle) if bottle 
		 end 
		 if @type == :APRICORNMACHINE
		  modifier_item = @craft[4]
		 
		 
		 end 
		 amt = @result.yield 
	     old_crafting_stack = [itemdata,amt]
		 new_crafting_index = "_crafted"
	     new_icon_crafted(itemdata, amt, new_crafting_index)
	     icon = @icons["#{new_crafting_index}_slotimage"]
		 remove_amounts(recipe)
         item = GameData::Item.get(old_crafting_stack[0])
		 pocket = item.pocket
	     @current_tab = pocket-1
		 update_selected_tab
		   @event_data.fuel-=1 if @type==:FURNACE
		   $player.playerstamina-=2 if @type==:GRINDER
	     if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: new_crafting_index,
		   craft: true
		  }
	     end 
		 
		 
		 if craft_empty_or_nil? || !can_afford?(recipe, @craft)
		  remove(@icons["#{crafting_index}_slotimage"])
		  remove(@icons["#{crafting_index}_slottext"])
		 end 
		 @result = nil 
		end 
       end
	  elsif crafting_index.is_a?(Integer) && crafting_index<100
	    if @craft[crafting_index]
	    if crafting_index == @grabbed_item[:index]
	       icon = @grabbed_item[:icon]
	       remove(icon)
	       icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	       remove(icon_text)
           @grabbed_item = nil
		   update_selected_tab
		elsif @craft[crafting_index][0].is_a?(ItemData) && @craft[crafting_index][0].identical(@grabbed_item[:stack][0])
		  item = @craft[crafting_index][0]
		  amt = @craft[crafting_index][1]
		  if amt<item.stack_size
			if @grabbed_item[:stack][1]>0
			
              #itm = GameData::Item.get(item)
              #pocket = itm.pocket
              #@current_tab = pocket-1
			  #update_selected_tab
	          @grabbed_item[:stack][1] -= 1
		      @craft[crafting_index][1] += 1
	           text_icon = @icons["#{crafting_index}_slottext"]
	           if @craft[crafting_index][1]>1
	            text = @craft[crafting_index][1].to_s
	           else
	            text = ""
	           end
			   text_icon.text = text
			   if @grabbed_item[:stack][1]==0
	             icon = @grabbed_item[:icon]
	             remove(icon)
	            
	             icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	             remove(icon_text)
			     current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
				 @grabbed_item = nil
			  end
			end


		  end
		end
        else
	    icon = @grabbed_item[:icon]
	    icon.z = 98
	    item, amt = @grabbed_item[:stack]
	    @craft[crafting_index] = [item, 1]
	    new_icon2(item, 1,crafting_index)
	    amt -= 1 
       if amt > 0
	     @grabbed_item[:stack][1] = amt
       else 
	     remove(icon)
	     icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"]
	     remove(icon_text)
		 current_pocket[@grabbed_item[:index]] = nil if @grabbed_item[:index]!="held" && @grabbed_item[:craft]==false
         @grabbed_item = nil
	   end
		
		end 
	  end
	 else
	 
	  if @result && crafting_index=="_result"
	    if true
		recipe = @result.recipe
		
	    if can_afford?(recipe, @craft)
		 itemdata = ItemData.new(@result.result[0])
		 set_max_durability(itemdata)
		 bottle_entry = @craft.each_with_index.find do |(item, _qty), _i|
           BOTTLE_ITEMS.include?(item&.id)
         end

		 if bottle_entry
          bottle_item, _qty = bottle_entry[0]
		  if CONTAINER_ITEMS.include?(bottle_item.id)
		    bottle = bottle_item
		  else
		    bottle = bottle_item.bottle
		  end 
		  itemdata.set_bottle(bottle) if bottle 
		 end 
		 if @type == :APRICORNMACHINE
		  modifier_item = @craft[4]
		 
		 
		 end 
		 amt = @result.yield 
	     old_crafting_stack = [itemdata,amt]
		 new_crafting_index = "4155555555"
	     new_icon_crafted(itemdata, amt, new_crafting_index)
	     icon = @icons["#{new_crafting_index}_slotimage"]
		 remove_amounts(recipe)
         item = GameData::Item.get(old_crafting_stack[0])
		 pocket = item.pocket
	     @current_tab = pocket-1
		 update_selected_tab
		   @event_data.fuel-=1 if @type==:FURNACE
		   $player.playerstamina-=2 if @type==:GRINDER
	     if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: new_crafting_index,
		   craft: true
		  }
	     end 
		 
		 
		 if craft_empty_or_nil? || !can_afford?(recipe, @craft)
		  remove(@icons["#{crafting_index}_slotimage"])
		  remove(@icons["#{crafting_index}_slottext"])
		 end 
		 @result = nil 
		end 
        end 
	  elsif (crafting_index.is_a?(Integer) && @craft[crafting_index])
	  
	  	if @craft[crafting_index][1]>1
	    item = @craft[crafting_index][0]
	    new_icon3(item, 1,"held", crafting_index)
        icon = @icons["held_image"]
	    text_icon = @icons["#{crafting_index}_slotimage"]
	    amt = (@craft[crafting_index][1] / 2.0).ceil
	    @craft[crafting_index][1] -= amt
	    if @craft[crafting_index][1]>1
	      text =@craft[crafting_index][1].to_s
	    else
	      text = ""
	    end
	    @icons["#{crafting_index}_slottext"].text = text
	    new_stack = [@craft[crafting_index][0],amt]
	    if @craft[crafting_index] && icon
         @grabbed_item = { 
		 icon: icon,
         stack: new_stack,
         index: "held",
		 craft: false}
	    end 


	   else
      icon_old = @icons["#{crafting_index}_slottext"]
	  remove(icon_old)
	  if @grabbed_item
	  icon_text = @grabbed_item[:craft]==true ? @icons["#{@grabbed_item[:index]}_slottext"] : @icons["#{@grabbed_item[:index]}_text"] 
	  remove(icon_text)
	  end
	  new_icon3(@craft[crafting_index][0], @craft[crafting_index][1],"held", crafting_index)
	  new_stack = [@craft[crafting_index][0],@craft[crafting_index][1]]
      icon = @icons["held_image"]
		@craft[crafting_index]=nil
	  if new_stack && icon
        @grabbed_item = { 
		icon: icon,
        stack: new_stack,
        index: "held",
		craft: false}
	  end 
	  end

	  
	  
	  
	    if false
	     old_crafting_stack = @craft[crafting_index]
	     icon = @icons["#{crafting_index}_slotimage"]
        item = GameData::Item.get(old_crafting_stack[0])
		pocket = item.pocket
	    @current_tab = pocket-1
		update_selected_tab
	    if old_crafting_stack && icon
          @grabbed_item = { 
		   icon: icon,
           stack: old_crafting_stack,
           index: crafting_index,
		   craft: true
		  }
	    end 
		@craft[crafting_index] = nil 
		if @result
		 remove(@icons["_result_slotimage"])
		 remove(@icons["_result_slottext"])
		 @result = nil 
		end
		end


	  end

	 
     end 
    
    end
  end
  
  
  
  def fuel(stack)
    item, amt = stack
    base_amt = FUEL_HASH[item.id]
	if base_amt
	  fuel_amt = base_amt*amt
	  result = [@event_data.fuel+fuel_amt,100.0].min
	  @event_data.fuel= result
	  @craft[1][1]=0
	  @craft[1]=nil
	  remove(@icons["1_slotimage"])
	  remove(@icons["1_slottext"])
	end 
  end 
  
  def use_item
    return if @grabbed_item
    index, col, row = slot_from_mouse
	return if index.nil?
    itemdata = current_pocket[index]
	item = itemdata[0] if itemdata 
	ret = 0
    if item
	  itm = GameData::Item.get(item)
      cmdRead     = -1
      cmdEat     = -1
      cmdEquip = -1
      cmdunEquip = -1
      cmdMedicate = -1
      cmdUse      = -1
      cmdRegister = -1
      cmdInfo     = -1
      cmdGive     = -1
      cmdToss     = -1
      cmdDebug    = -1
      commands = []
      # Generate command list
      commands[cmdRead = commands.length] = _INTL("Read") if itm.is_mail?
      commands[cmdEquip = commands.length]       = _INTL("Equip") if itm.is_tool? && $player.equipped_item.nil?
      commands[cmdunEquip = commands.length]       = _INTL("Unequip") if itm.is_tool? && $player.equipped_item==itm 
      commands[cmdEat = commands.length]       = _INTL("Drink") if itm.is_water?
	  commands[cmdEat = commands.length]       = _INTL("Eat") if (itm.is_foodwater? || itm.is_berry?) && !itm.is_water?
      commands[cmdMedicate = commands.length]       = _INTL("Use (Self)") if itm.is_medicine?
      if ItemHandlers.hasOutHandler(item) || (itm.is_machine? && $player.party.length > 0) || itm.field_use == 1
        if ItemHandlers.hasUseText(item)
          commands[cmdUse = commands.length]    = ItemHandlers.getUseText(item)
        else
          commands[cmdUse = commands.length]    = _INTL("Use")
        end
      end
      commands[cmdInfo = commands.length]       = _INTL("Info")
      commands[cmdGive = commands.length]       = _INTL("Give") if $player.pokemon_party.length > 0 && itm.can_hold?
      commands[cmdToss = commands.length]       = _INTL("Toss") if !itm.is_important? || $DEBUG
      if $bag.registered?(item)
        commands[cmdRegister = commands.length] = _INTL("Unfavorite")
      elsif pbCanRegisterItem?(item)
        commands[cmdRegister = commands.length] = _INTL("Favorite")
      end
      commands[cmdDebug = commands.length]      = _INTL("Debug") if $DEBUG
      commands[commands.length]                 = _INTL("Cancel")
      # Show commands generated above
      itemname = itm.name
	  
      @sprites["msgwindow"].visible = false
     loop do
      command = pbShowCommands(_INTL("{1} is selected.", itemname), commands)
      if cmdRead >= 0 && command == cmdRead   # Read mail
        pbFadeOutIn {
          pbDisplayMail(Mail.new(item, "", ""))
        }
      elsif cmdEat >=0 && command==cmdEat   # Eat
        ret = pbEating($bag,item)
        break if ret==2   # End screen
        pbRefresh
        next
      elsif cmdEquip >=0 && command==cmdEquip   # Equip
        $player.equip(item)
		decreaseStamina(1)
	    $PokemonGlobal.ball_order=getCurrentItemOrder
		$PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_order.index(item)
		$PokemonGlobal.ball_hud_enabled=true
        pbRefresh
        next
      elsif cmdunEquip >=0 && command==cmdunEquip   # Unequip
        $player.unequip
		decreaseStamina(1)
		$PokemonGlobal.ball_hud_enabled=false
        pbRefresh
        next
      elsif cmdMedicate>=0 && command==cmdMedicate   # Medicate
        ret = pbMedicine($bag,item)
        # ret: 0=Item wasn't used; 1=Item used; 2=Close Bag to use in field
        break if ret==2   # End screen
        pbRefresh
        next
      elsif cmdUse >= 0 && command == cmdUse   # Use item
        ret = pbUseItem($bag, item)
		decreaseStamina(1)
        # ret: 0=Item wasn't used; 1=Item used; 2=Close Bag to use in field
        break if ret == 2   # End screen
        pbRefresh
        next
      elsif cmdInfo >= 0 && command == cmdInfo   # CHECK THE ITEM FOR ITS DURABILITY AND SHIT
          pbFadeOutIn {
            item = pbItemSummaryScreen(item)
            pbRefresh
          }
      elsif cmdGive >= 0 && command == cmdGive   # Give item to Pokémon
        if $player.pokemon_count == 0
          pbDisplay(_INTL("There is no Pokémon."))
        elsif itm.is_important?
          pbDisplay(_INTL("The {1} can't be held.", itemname))
        else
          pbFadeOutIn {
            sscene = PokemonParty_Scene.new
            sscreen = PokemonPartyScreen.new(sscene, $player.party)
            sscreen.pbPokemonGiveScreen(item)
            pbRefresh
          }
        end


      elsif cmdToss >= 0 && command == cmdToss   # Toss item
        qty = $bag.quantity(item)
        if qty > 1
          helptext = _INTL("Toss out how many {1}?", itm.name_plural)
          qty = pbChooseNumber(helptext, qty)
        end
        if qty > 0
          itemname = itm.name_plural if qty > 1
          if pbConfirm(_INTL("Is it OK to throw away {1} {2}?", qty, itemname))
            pbDisplay(_INTL("Threw away {1} {2}.", qty, itemname))
            qty.times { $bag.remove(item) }
            pbRefresh
          end
        end
      elsif cmdRegister >= 0 && command == cmdRegister   # Register item
        if $bag.registered?(item)
          $bag.unregister(item)
        else
          $bag.register(item)
        end
        pbRefresh
      elsif cmdDebug >= 0 && command == cmdDebug   # Debug
        command = 0
        loop do
          command = pbShowCommands(_INTL("Do what with {1}?", itemname),
                                          [_INTL("Change quantity"),
                                           _INTL("Make Mystery Gift"),
                                           _INTL("Cancel")], command)
					  
          case command
          ### Cancel ###
          when -1, 2
            break
          ### Change quantity ###
          when 0
            qty = $bag.quantity(item)
            itemplural = itm.name_plural
            params = ChooseNumberParams.new
            params.setRange(0, item.stack_size)
            params.setDefaultValue(qty)
            newqty = pbChooseNumber(
              _INTL("Choose new quantity of {1} (max. #{item.stack_size}).", itemplural), params
            ) { pbUpdate }
            if newqty > qty
              $bag.add(item, newqty - qty)
            elsif newqty < qty
              $bag.remove(item, qty - newqty)
            end
            pbRefresh
            break if newqty == 0
          ### Make Mystery Gift ###
          when 1
            pbCreateMysteryGift(1, item)
          end
        end
      else 
	   break
      end
     end
    
    return item if ret==2
	return nil
    end

  
  end
  def craft_empty_or_nil?
  @craft.empty? || @craft.all?(&:nil?)
  end

  
  def update_highlight
    index, col, row = slot_from_mouse
	crafting_index = crafting_slot_from_mouse
	pokemon_index = pokemon_slot_from_mouse
    if index
	  icon = @sprites["slots#{index}"]
	  if icon
	   if icon.name != "Graphics/Pictures/craftingMenu/placeholder_slot_2"
	   
       @sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
	   @sprites["highlight"].x = icon.x
	   @sprites["highlight"].y = icon.y
	   @sprites["highlight"].visible=true 
	   else
	   @sprites["highlight"].visible=false 
	   end 
	  end
	elsif crafting_index
	  icon = @sprites["craft_slots#{crafting_index}"]
	  if icon
	   if crafting_index.is_a?(Integer) && crafting_index >=100
	    if @buttons["equipment_button"]==true
	      @sprites["highlight"].x = icon.x
	      @sprites["highlight"].y = icon.y
	      @sprites["highlight"].visible=true 
	    else
	      @sprites["highlight"].visible=false  
		end 
	   elsif crafting_index.is_a?(String) && crafting_index=="_result"
	    if @type != :APRICORNCRAFTING && @type != :APRICORNMACHINE && @type!=:CAULDRON && @type!=:MEDICINEPOT
          @sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight2")
	      @sprites["highlight"].x = icon.x
	      @sprites["highlight"].y = icon.y
	      @sprites["highlight"].visible=true 
	    else
	      @sprites["highlight"].visible=false 
		end 
	   elsif crafting_index.is_a?(Integer) && crafting_index <100 
       @sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
	   @sprites["highlight"].x = icon.x
	   @sprites["highlight"].y = icon.y
	   @sprites["highlight"].visible=true 
	   end 
	  end
	elsif pokemon_index
	  icon = @sprites["#{pokemon_index}_slotimagepkmn"]
	  if icon
       @sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
	   @sprites["highlight"].x = icon.x 
	   @sprites["highlight"].y = icon.y 
	   @sprites["highlight"].visible=true 
	  end
	else 
	  @sprites["highlight"].visible=false 
	end 
  
  end 
  
  
  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end

  def tab_clicked?(sprite)
    return false if @grabbed_item
    mouse_x, mouse_y = Mouse.getMousePos
    local_x = mouse_x - sprite.x
    local_y = mouse_y - sprite.y
	return false if local_x < 0 || local_y < 0
	return false if local_x >= sprite.bitmap.width || local_y >= sprite.bitmap.height
    pixel_color = sprite.bitmap.get_pixel(local_x, local_y)
	return pixel_color.alpha > 0
  end
  def item_clicked?(icon)
    mouse_x, mouse_y = Mouse.getMousePos
    x1 = icon.x - 2   
    y1 = icon.y - 2   
    x2 = x1 + icon.bitmap.width + 2 
    y2 = y1 + icon.bitmap.height + 2
    mouse_x >= x1 && mouse_x <= x2 && mouse_y >= y1 && mouse_y <= y2
  end
  
  def item_hovered?
    crafting_index = crafting_slot_from_mouse
	if crafting_index
	if crafting_index.is_a?(Integer) && crafting_index <100
	 if @type!=:PKMNCRATE
	  craft = @craft[crafting_index] 
	  return craft if craft
	 else
	  craft = @pokemon[crafting_index] 
	  return craft if craft
	 end 
	elsif crafting_index.is_a?(Integer) && crafting_index >=100 && @buttons["equipment_button"]==true
	  craft = @equip[crafting_index-100] 
	  return craft if craft
	else 
	return @result.result if @result
	end 
	end 
	pokemon_index = pokemon_slot_from_mouse
	if pokemon_index
	if pokemon_index.is_a?(Integer)
	  pokemon = @party[pokemon_index] 
	  return pokemon if pokemon
	end 

	end 
    index, col, row = slot_from_mouse
	return nil if index.nil?
    stack = current_pocket[index]
    return nil if stack.nil?
    return stack
  end 
  
  
  def resize_item_for_slot(item)
  slot_size = 32
  path = GameData::Item.icon_filename(item)
  parts = path.split("/", 3)
  dir = parts[0..1].join("/") + "/"
  filename   = parts[2]  
  original_bitmap = RPG::Cache.load_bitmap(dir,filename)
  resized_bitmap = Bitmap.new(slot_size, slot_size)
  
  resized_bitmap.stretch_blt(
    Rect.new(0, 0, slot_size, slot_size),
    original_bitmap,                       
    Rect.new(0, 0, original_bitmap.width, original_bitmap.height) 
  )
  return resized_bitmap
  end
  
  def remove(icon)
    return if icon.nil?
    return if icon.disposed?
    icon.visible = false if defined?(icon.visible)
	icon.dispose
    
  end 
  
  def current_pocket
    return @pockets[@current_tab+1]
  end 

  def update_selected_tab
    return if @type==:BEDROLL
    @icons.each do |key, icon| 
	 remove(icon) if key.to_s.end_with?("_image") || key.to_s.end_with?("_text")
	end 
    @icons.delete_if { |key, _| key.to_s.end_with?("_image") || key.to_s.end_with?("_text")}
	pocket = @current_tab+1
    @pockets[pocket].fill(nil, @pockets[pocket].length...Settings::BAG_MAX_POCKET_SIZE.max) 
	max_slots = Settings::BAG_MAX_POCKET_SIZE.max 
	max_slots_for_pocket = Settings::BAG_MAX_POCKET_SIZE[@current_tab]
    items = @pockets[pocket]
    cols = 9
    rows = 4
	slot_size = 36
    items.each_with_index do |slot, index|
	 next if slot.nil?
	 item, amt = slot
     col = index % cols
     row = index / cols
	 new_icon(item, amt,index,col,row)
	end 

	max_slots.times do |i|
	  if i < max_slots_for_pocket
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot"
	  else
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot_2"
	 end
     @sprites["slots#{i}"].setBitmap(bitmap)
	 if items[i]
	   @sprites["slots_star#{i}"].visible = true if $bag.registered?(items[i]) 
	 else 
	   @sprites["slots_star#{i}"].visible = false 
	 end 
	end 


  end 
  
  def slot_from_mouse
    mouse_x, mouse_y = Mouse.getMousePos
	return if mouse_x.nil? || mouse_y.nil?
    cols = 9
    rows = 4
	slot_size = 36
    rel_x = mouse_x - @start_x
    rel_y = mouse_y - @start_y
    return if rel_x < 0 || rel_y < 0 || rel_x >= cols * slot_size || rel_y >= rows * slot_size
    col = rel_x / slot_size
    row = rel_y / slot_size
    index = row * cols + col
    return index, col, row
  
  end 
  
  def pokemon_slot_from_mouse
    mouse_x, mouse_y = Mouse.getMousePos
	return nil if mouse_x.nil? || mouse_y.nil?
  	Settings::MAX_PARTY_SIZE.times do |i|
	
 	        sprite = @sprites["#{i}_slotimagepkmn"]
 	        next if sprite.nil?
	     
 	        x1 = sprite.x
 	        y1 = sprite.y
 	        x2 = x1 + sprite.bitmap.width
  	        y2 = y1 + sprite.bitmap.height

 	        if mouse_x >= x1 && mouse_x < x2 && mouse_y >= y1 && mouse_y < y2
 	          return i
 	        end
   
   
	end 

    return nil
  
  
  end 
  def crafting_slot_from_mouse
    mouse_x, mouse_y = Mouse.getMousePos
	return nil if mouse_x.nil? || mouse_y.nil?

	     max_slots = get_slot_amount
	     max_slots.times do |i|
 	        sprite = @sprites["craft_slots#{i}"]
 	        next if sprite.nil?
	     
 	        x1 = sprite.x
 	        y1 = sprite.y
 	        x2 = x1 + sprite.bitmap.width
  	        y2 = y1 + sprite.bitmap.height

 	        if mouse_x >= x1 && mouse_x < x2 && mouse_y >= y1 && mouse_y < y2
 	          return i
 	        end
   
   
   
   
	     end 
	     sprite = @sprites["craft_slots_result"]
	     if !sprite.nil?

 	         x1 = sprite.x
 	         y1 = sprite.y
	         x2 = x1 + sprite.bitmap.width
	         y2 = y1 + sprite.bitmap.height

 	         if mouse_x >= x1 && mouse_x < x2 && mouse_y >= y1 && mouse_y < y2
 	          return "_result"
 	         end
	     end

         if @type == :APRICORNMACHINE
	     sprite = @sprites["craft_slots#{max_slots+1}"]
	     if !sprite.nil?

 	         x1 = sprite.x
 	         y1 = sprite.y
	         x2 = x1 + sprite.bitmap.width
	         y2 = y1 + sprite.bitmap.height

 	         if mouse_x >= x1 && mouse_x < x2 && mouse_y >= y1 && mouse_y < y2
 	          return max_slots+1
 	         end
	     end
         end 


	     3.times do |i|
 	        sprite = @sprites["craft_slots#{i+100}"]
 	        next if sprite.nil?
	     
 	        x1 = sprite.x
 	        y1 = sprite.y
 	        x2 = x1 + sprite.bitmap.width
  	        y2 = y1 + sprite.bitmap.height

 	        if mouse_x >= x1 && mouse_x < x2 && mouse_y >= y1 && mouse_y < y2
 	          return i+100
 	        end
   
   
   
   
	     end 

    return nil
  end 
  
  def pbSummary(pkmn_index, storage, inbattle=false)
    scene = PokemonSummary_Scene.new
    screen = PokemonSummaryScreen.new(scene, inbattle)
    screen.pbStartScreen(storage, pkmn_index)
    yield if block_given?
  
  end 
  

  def pbSelectcraft
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
	end_item = nil
    while true
    Graphics.update
	$PokemonGlobal.addNewFrameCount
      Input.update
	   if rand(100)==0 && @type==:GRINDER
	    player_stamina_logic
	   end 
      self.update
	  if Input.triggerex?(:O)
	    puts current_pocket.inspect
	  end
	  if Input.triggerex?(:L)
	    puts @pokemon.inspect
	  end
	  if Input.triggerex?(:M)
	    puts @party.inspect
	  end
	  if Input.trigger?(Input::LEFT)
	     @current_tab = (@current_tab - 1) % Settings::BAG_MAX_POCKET_SIZE.size
		 update_selected_tab
	  elsif Input.trigger?(Input::RIGHT)
	     @current_tab = (@current_tab + 1) % Settings::BAG_MAX_POCKET_SIZE.size
		 update_selected_tab
	  end
	  if (Input.trigger?(Input::USE) || Input.trigger?(Input::MOUSEMIDDLE)) && !Input.trigger?(Input::MOUSELEFT)
	    end_item = use_item
	  elsif (Input.trigger?(Input::INVENTORY) || Input.trigger?(Input::BACK)) && !Input.trigger?(Input::MOUSERIGHT)
	     @sprites.each do |key, sprite|
          remove(sprite)
        end
	     @icons.each do |key, icon|
          remove(icon)
        end
	     @objects.each do |key, object|
          remove(object)
        end
          @sprites = {}
          @icons = {}
          @objects = {}
		  $bag.last_viewed_pocket = @current_tab+1
        return -1
      elsif Input.trigger?(Input::MOUSELEFT)
	    left_click_tab
		left_click_item
	  elsif Input.time?(Input::MOUSELEFT)>10
	  elsif Input.trigger?(Input::MOUSERIGHT)
		right_click_item
	  elsif Input.triggerex?(:F)
         if !@grabbed_item
           index, col, row = slot_from_mouse
	       crafting_index = crafting_slot_from_mouse
	       pokemon_index = pokemon_slot_from_mouse
		   data = nil 
		   sprite_key = nil 
	       if !index.nil?
             data = current_pocket[index]
			 sprite_key = "slots_star#{index}"
           elsif !crafting_index.nil? && crafting_index.is_a?(Integer)
             data = @craft[crafting_index]
			 data = @pokemon[crafting_index] if data.nil?
			 data = [data] if data.is_a?(Pokemon)
			 sprite_key = "craft_slots_star#{crafting_index}"
           elsif !pokemon_index.nil?
             data = @party[pokemon_index]
			 data = [data] if data.is_a?(Pokemon)
			 sprite_key = "slotimagepkmnstar#{pokemon_index}"
		   end
		   
		   
	       item = data[0] if data 
           if item
             if $bag.registered?(item)
               $bag.unregister(item)
			   @sprites[sprite_key].visible = false if sprite_key
             else
               $bag.register(item)
			   @sprites[sprite_key].visible = true if sprite_key
             end
		   end


         end

	  elsif Input.triggerex?(:I)
         if !@grabbed_item
           index, col, row = slot_from_mouse
	       crafting_index = crafting_slot_from_mouse
	       pokemon_index = pokemon_slot_from_mouse
	       if !index.nil?
           data = current_pocket[index]
	         item = data[0] if data 
             if item
	          pbFadeOutIn {
                item = pbItemSummaryScreen(item)
                pbRefresh
              }
		     end
		   elsif !crafting_index.nil?
		     #itemdata = @craft[crafting_index] pokemon
			 if crafting_index.is_a?(Integer) && crafting_index>=100
			  if @buttons["equipment_button"]==true 
			   data = @equip[crafting_index-100]
			   item = data[0] if data
               if item
	            pbFadeOutIn {
                 item = pbItemSummaryScreen(item)
                 pbRefresh
                }
		       end
			   end
             elsif crafting_index.is_a?(Integer) && crafting_index<100 && @type == :PKMNCRATE 
			   data = @pokemon[crafting_index]
			   if data 
	             pbFadeOutIn {
			       pbSummary(crafting_index, @pokemon)
                   pbRefresh
                 }
               end 
			 elsif crafting_index.is_a?(Integer) && crafting_index<100
			   data = @craft[crafting_index]
			   if data 
			     item = data[0]
			     if item
			      pbFadeOutIn {
                   item = pbItemSummaryScreen(item)
                   pbRefresh
                  }
			     end
			   end 
			 elsif crafting_index=="_result"
			 end 
		   elsif !pokemon_index.nil?
		      if @party[pokemon_index]
	             pbFadeOutIn {
			       pbSummary(pokemon_index, @party)
                   pbRefresh
                 }
			  end 
		   end
         end

	  end
      break if $game_temp.fly_destination
	  break if end_item
	end
    return end_item

  end


  

end

class Inv_Scene

  def setup_ui
      case @type
      when "Inventory"
        setup_inventory_ui
      when :APRICORNCRAFTING, :APRICORNMACHINE
	    setup_pokeball_ui
      when :CAULDRON
	    setup_cauldron_ui
      when :FURNACE
	    setup_furnace_ui
      when :MEDICINEPOT
	    setup_medicinepot_ui
      when :GRINDER
	    setup_grinder_ui
	  when :CRAFTINGBENCH, :UPGRADEDCRAFTINGBENCH
	    setup_craftingtable_ui
	  when :ICEBOX 
	    setup_icebox_ui
	  when :ITEMCRATE 
	    setup_itemcrate_ui
	  when :PKMNCRATE 
	    setup_pkmncrate_ui
	  when :RESEARCHTABLE, :GARBAGEBIN
	    setup_research_ui
	  when :MACHINEBOX 
	  else 
	     setup_craftingtable_ui
      end 
    if @type !=:BEDROLL
	Settings::MAX_PARTY_SIZE.times do |i|
	    key = "party#{i}"
	    min = ""
	    max =""
		word = ""
	    x = @sprites["#{i}_slotimagepkmn"].x + 36 + 6
	    y = @sprites["#{i}_slotimagepkmn"].y + 16
	  if @party[i] && !@party[i].egg?
	    key = "party#{i}"
	    min = @party[i].hp
	    max = @party[i].totalhp
		word = "HP"
	  end 
	     build_bar(key,word,x,y,min,max)
	  
	end 
    end 
  end 
  def setup_research_ui
    x = @bonus_1 + 168
	y = @bonus_2 + 60
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	x2 = 0
	y2 = 0
	max_slots.times do |i|
     col = i % cols
     row = 0
	 bonus = 0
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 1
     x2 = x + col * slot_size
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	 if @craft[i]
	   item, amt = @craft[i]
       new_icon_itemcrate2(item, amt,i)
     end 
	end
  end 

  def setup_medicinepot_ui
    x = @bonus_1 + 77
	y = @bonus_2 + 30
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	x2 = 0
	y2 = 0
	x3 = 0
	max_slots.times do |i|
     col = i % cols
     row = 0
	 bonus = 0
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = x + bonus + col * slot_size 
	 x3 = x2 if i<2
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	end
	 minusamt = 8
	 minusamtx = 20
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].z = 70
     @sprites["craft_slots_equals"].x = x3 + 47 - minusamtx
     @sprites["craft_slots_equals"].y = y2 + 22 - minusamt
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].z = 70
     @sprites["craft_slots_result"].x = @bonus_1 + 161 - minusamtx#x3 + 30
     @sprites["craft_slots_result"].y = @bonus_2 + 82 + 2 - minusamt#y2 + 50 - minusamt

  
  end 
  



  def setup_cauldron_ui
    x = @bonus_1 + 56
	y = @bonus_2 + 56
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	offset_x = 0
	x2 = 0
	y2 = 0
	pos = [
	[114,-30],
    [44,18],
    [184,18]	
	]
	max_slots.times do |i|
     col = i % cols
     row = 0
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/cauldron/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = offset_x + x + pos[i][0]
     y2 = y + pos[i][1]
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	end
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/cauldron/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].x = x2 + 38
     @sprites["craft_slots_equals"].y = y2 + 6
     @sprites["craft_slots_equals"].z = 70
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/cauldron/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].x = x + offset_x + 106
     @sprites["craft_slots_result"].y = y + 10
     @sprites["craft_slots_result"].z = 70
  
  
  end 
  

  def setup_furnace_ui
    x = @bonus_1 + 56
	y = @bonus_2 + 37
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	x2 = 0
	y2 = 0
	max_slots.times do |i|
     col = 1
     row = i % max_slots 
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = x + col * slot_size
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	end
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].z = 70
     @sprites["craft_slots_equals"].x = x2 + 68
     @sprites["craft_slots_equals"].y = y2 - 12
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].z = 70
     @sprites["craft_slots_result"].x = x2 + 136
     @sprites["craft_slots_result"].y = y2 - 24
  
  
  
   # @sprites["tab"]=IconSprite.new(0,0,@viewport)
   # bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/poptab"
   # @sprites["tab"].setBitmap(bitmap)
    #@sprites["tab"].z = 70
   # @sprites["tab"].x = @bonus_1+206
   # @sprites["tab"].y = @bonus_2+118

   # create_text3("tab_alttext","FUEL: #{@event_data.fuel}/100.0",@sprites["tab"].x + 12,@sprites["tab"].y + 20)
	#@sprites["tab_alttext"].z = 71
  end 
  
  def setup_itemcrate_ui
   max_slots = get_slot_amount
   max_per_slot = @container.maxperslot
    y = @bonus_2 + 16
    cols = 9
    rows = 6
	slot_size = 36
   max_slots.times do |i|
     col = i % cols
     row = i / cols
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = -2
     @sprites["craft_slots#{i}"].x = @start_x + col * slot_size
     @sprites["craft_slots#{i}"].y = y + row * slot_size
     @sprites["craft_slots_star#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/star"
     @sprites["craft_slots_star#{i}"].setBitmap(bitmap)
     @sprites["craft_slots_star#{i}"].z = 9998
     @sprites["craft_slots_star#{i}"].x = 26+@sprites["craft_slots#{i}"].x
     @sprites["craft_slots_star#{i}"].y = 2+@sprites["craft_slots#{i}"].y
     @sprites["craft_slots_star#{i}"].visible = false 
	 if @container[i]
	   item, amt = @container[i]
       new_icon_itemcrate(item, amt,i,col,row, y)
       @sprites["craft_slots_star#{i}"].visible = true if $bag.registered?(item) 
     end 
   
   end 
  
  
    @sprites["cover"]=IconSprite.new(0,0,@viewport)
	bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/itemcrate/cover"
    @sprites["cover"].setBitmap(bitmap)
    @sprites["cover"].z = 0 
	@sprites["cover"].x= @bonus_1-@mamtx
	@sprites["cover"].y= @bonus_2-(@mamty+12)
  end 
  def setup_pkmncrate_ui
   max_slots = get_slot_amount
    y = @bonus_2 + 16
    cols = 9
    rows = 6
	slot_size = 36
   max_slots.times do |i|
     col = i % cols
     row = i / cols
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = -2
     @sprites["craft_slots#{i}"].x = @start_x + col * slot_size
     @sprites["craft_slots#{i}"].y = y + row * slot_size
	 
      @sprites["craft_slots_star#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/star"
      @sprites["craft_slots_star#{i}"].setBitmap(bitmap)
      @sprites["craft_slots_star#{i}"].z = 9998
      @sprites["craft_slots_star#{i}"].x = @sprites["craft_slots#{i}"].x + 26
      @sprites["craft_slots_star#{i}"].y = @sprites["craft_slots#{i}"].y + 2
      @sprites["craft_slots_star#{i}"].visible = false
	  

      @sprites["craft_slots_pkmnbag#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/pkmnitems"
      @sprites["craft_slots_pkmnbag#{i}"].setBitmap(bitmap)
      @sprites["craft_slots_pkmnbag#{i}"].z = 9998
      @sprites["craft_slots_pkmnbag#{i}"].x = @sprites["craft_slots#{i}"].x + 25
      @sprites["craft_slots_pkmnbag#{i}"].y = @sprites["craft_slots#{i}"].y + 24
      @sprites["craft_slots_pkmnbag#{i}"].visible = false
	  

      @sprites["craft_slots_pkmnfod#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/green_dot"
      @sprites["craft_slots_pkmnfod#{i}"].setBitmap(bitmap)
      @sprites["craft_slots_pkmnfod#{i}"].z = 9998
      @sprites["craft_slots_pkmnfod#{i}"].x = @sprites["craft_slots#{i}"].x + 2
      @sprites["craft_slots_pkmnfod#{i}"].y = @sprites["craft_slots#{i}"].y + 30
      @sprites["craft_slots_pkmnfod#{i}"].visible = false
	  

      @sprites["craft_slots_pkmnH2O#{i}"]=IconSprite.new(0,0,@viewport)
      bitmap = "Graphics/Pictures/craftingMenu/green_dot"
      @sprites["craft_slots_pkmnH2O#{i}"].setBitmap(bitmap)
      @sprites["craft_slots_pkmnH2O#{i}"].z = 9998
      @sprites["craft_slots_pkmnH2O#{i}"].x = @sprites["craft_slots#{i}"].x + 6
      @sprites["craft_slots_pkmnH2O#{i}"].y = @sprites["craft_slots#{i}"].y + 30
      @sprites["craft_slots_pkmnH2O#{i}"].visible = false
    
	 if @pokemon[i]
	   pokemon = @pokemon[i]
       new_icon_pkmncrate(pokemon,i,col,row, y)
       @sprites["craft_slots_star#{i}"].visible = true if $bag.registered?(@pokemon[i])
     end 
   end 
  
  
    @sprites["cover"]=IconSprite.new(0,0,@viewport)
	bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/itemcrate/cover"
    @sprites["cover"].setBitmap(bitmap)
    @sprites["cover"].z = 0 
	@sprites["cover"].x= @bonus_1-@mamtx
	@sprites["cover"].y= @bonus_2-(@mamty+12)
  end 
  def setup_icebox_ui
   max_slots = 27
   available_slots = get_slot_amount
   max_per_slot = @container.maxperslot
    y = @bonus_2 + 16
    cols = 9
    rows = 6
	slot_size = 36
   max_slots.times do |i|
     col = i % cols
     row = i / cols
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
	 if i <= available_slots-1
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot"
	 else
     bitmap = "Graphics/Pictures/craftingMenu/placeholder_slot_2"
	 end 
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = -2
     @sprites["craft_slots#{i}"].x = @start_x + col * slot_size
     @sprites["craft_slots#{i}"].y = y + row * slot_size
     @sprites["craft_slots_star#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/star"
     @sprites["craft_slots_star#{i}"].setBitmap(bitmap)
     @sprites["craft_slots_star#{i}"].z = 9998
     @sprites["craft_slots_star#{i}"].x = 26+@sprites["craft_slots#{i}"].x
     @sprites["craft_slots_star#{i}"].y = 2+@sprites["craft_slots#{i}"].y
     @sprites["craft_slots_star#{i}"].visible = false 
	 if @container[i]
	   item, amt = @container[i]
       new_icon_itemcrate(item, amt,i,col,row, y)
       @sprites["craft_slots_star#{i}"].visible = true if $bag.registered?(item) 
     end 
   
   end 
  
  
    @sprites["cover"]=IconSprite.new(0,0,@viewport)
	bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/itemcrate/cover"
    @sprites["cover"].setBitmap(bitmap)
    @sprites["cover"].z = 0 
	@sprites["cover"].x= @bonus_1-@mamtx
	@sprites["cover"].y= @bonus_2-(@mamty+12)
  end 


  def setup_grinder_ui
    x = @bonus_1 + 96
	y = @bonus_2 + 58
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	x2 = 0
	y2 = 0
	max_slots.times do |i|
     col = i % cols
     row = 0
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/grinder/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = x + col * slot_size
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	end
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/grinder/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].z = 70
     @sprites["craft_slots_equals"].x = x2 + 68
     @sprites["craft_slots_equals"].y = y2 + 2
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/grinder/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].z = 70
     @sprites["craft_slots_result"].x = x2 + 136
     @sprites["craft_slots_result"].y = y2 - 8
  
  
  
    @sprites["tab"]=IconSprite.new(0,0,@viewport)
    bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/poptab"
    @sprites["tab"].setBitmap(bitmap)
    @sprites["tab"].z = 70
    @sprites["tab"].x = @bonus_1+206
    @sprites["tab"].y = @bonus_2+118

    create_text3("tab_alttext","STA: #{$player.playerstamina}/#{$player.playermaxstamina}",@sprites["tab"].x + 12,@sprites["tab"].y + 20)
	@sprites["tab_alttext"].z = 71
  end 
  

  
  def setup_pokeball_ui
    x = @bonus_1 + 82
	y = @bonus_2 + 36
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	x2 = 0
	y2 = 0
	x3 = 0
	max_slots.times do |i|
     col = i % cols
     row = 0
	 bonus = 0
	 bonus = 26 if i>1
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = x + bonus + col * slot_size 
	 x3 = x2 if i<2
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	end
	 minusamt = 8
	 minusamtx = 20
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].z = 70
     @sprites["craft_slots_equals"].x = x3 + 47 - minusamtx
     @sprites["craft_slots_equals"].y = y2 + 22 - minusamt
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].z = 70
     @sprites["craft_slots_result"].x = @bonus_1 +161 - minusamtx#x3 + 30
     @sprites["craft_slots_result"].y = @bonus_2 + 82 - minusamt#y2 + 50 - minusamt
     if @type == :APRICORNMACHINE
       @sprites["craft_slots#{max_slots+1}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot"
     @sprites["craft_slots#{max_slots+1}"].setBitmap(bitmap)
     @sprites["craft_slots#{max_slots+1}"].z = 70
     @sprites["craft_slots#{max_slots+1}"].x = x3 + 176
     @sprites["craft_slots#{max_slots+1}"].y = y2 + 62 - minusamt
	 
	 
	 end
  
  end 
  


	 # stamina_management_for_ov if @items.empty? && rand(2)==0
  
  def setup_craftingtable_ui
    if @type == :CRAFTINGBENCH
    x = @bonus_1 + 86
	else
    x = @bonus_1 + 56
	end 
	y = @bonus_2 + 56
	max_slots = get_slot_amount
    cols = max_slots
    rows = 1
	slot_size = 36
	x2 = 0
	y2 = 0
	max_slots.times do |i|
     col = i % cols
     row = 0
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = x + col * slot_size
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = x2
     @sprites["craft_slots#{i}"].y = y2
	end
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].z = 70
     @sprites["craft_slots_equals"].x = x2 + 38
     @sprites["craft_slots_equals"].y = y2 + 6
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].z = 70
     @sprites["craft_slots_result"].x = x2 + 66
     @sprites["craft_slots_result"].y = y2 - 8
  
  
  end 
  
  def setup_inventory_ui
    width  = 80  
    height = 80
    @objects["player_square"] = BitmapSprite.new(width,height,@viewport)
    @objects["player_square"].bitmap.fill_rect(
      0, 0, width, height,
      Color.new(0, 0, 0)
    )
    @sprites["trainer"] = IconSprite.new(Graphics.width/2,96,@viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @sprites["trainer"].x = @bonus_1+30
    @sprites["trainer"].y = @bonus_2+24
    @objects["player_square"].x = @bonus_1+34
    @objects["player_square"].y = @bonus_2+24
    @sprites["trainer"].zoom_x = 0.5
    @sprites["trainer"].zoom_y = 0.5
	
    @sprites["trainer"].z = 1
    createBars(@viewport)
    tab_name = Settings.bag_pocket_names[@current_tab]
	
	button_name = "equipment_button"
    @objects[button_name]=IconSprite.new(0,0,@viewport)
	if pbResolveBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up")
	  bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up"
	  #bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_down"
	end
    @objects["#{button_name}"].setBitmap(bitmap)
    @objects["#{button_name}"].x = @bonus_1+116 
    @objects["#{button_name}"].y = @bonus_2+116 
    @objects["#{button_name}"].z = 0 
    @objects["#{button_name}"].visible=true 

	@buttons[button_name]=false
   
	setup_pocket_crafting
	
	setup_equipment_screen
	
  end 
  def setup_equipment_screen
    x = @bonus_1 + 134
	y = @bonus_2 + 20
    cols = 2
    rows = 1
	slot_size = 36
	max_slots = 3
	x2 = 0
	y2 = 0
	max_slots.times do |i|
     col = 0
     row = i
     @sprites["craft_slots#{i+100}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot"
     @sprites["craft_slots#{i+100}"].setBitmap(bitmap)
     @sprites["craft_slots#{i+100}"].z = 70
     x2 = x + col * slot_size
     y2 = y + row * slot_size
     @sprites["craft_slots#{i+100}"].x = x2
     @sprites["craft_slots#{i+100}"].y = y2
     @sprites["craft_slots#{i+100}"].visible = false
	 new_icon2($player.playershirt, 1, i+100) if i+100==100
	 new_icon2($player.playerpants, 1, i+100) if i+100==101
	 new_icon2($player.playershoes, 1, i+100) if i+100==102
	 @icons["#{i+100}_slotimage"].visible = false 
	end

  
  end

  def setup_pocket_crafting
    x = 186
	y = 56
    cols = 2
    rows = 1
	slot_size = 36
	max_slots = get_slot_amount
	x2 = 0
	y2 = 0
	max_slots.times do |i|
     col = i % cols
     row = i / cols
     @sprites["craft_slots#{i}"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot"
     @sprites["craft_slots#{i}"].setBitmap(bitmap)
     @sprites["craft_slots#{i}"].z = 70
     x2 = x + col * slot_size
     y2 = y + row * slot_size
     @sprites["craft_slots#{i}"].x = @bonus_1 + x2
     @sprites["craft_slots#{i}"].y = @bonus_2 + y2
	end
     @sprites["craft_slots_equals"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/equals"
     @sprites["craft_slots_equals"].setBitmap(bitmap)
     @sprites["craft_slots_equals"].z = 70
     @sprites["craft_slots_equals"].x = @bonus_1 + x2 + 38
     @sprites["craft_slots_equals"].y = @bonus_2 + y2 + 6
	 
     @sprites["craft_slots_result"]=IconSprite.new(0,0,@viewport)
     bitmap = "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/result_slot"
     @sprites["craft_slots_result"].setBitmap(bitmap)
     @sprites["craft_slots_result"].z = 70
     @sprites["craft_slots_result"].x = @bonus_1 + x2 + 66
     @sprites["craft_slots_result"].y = @bonus_2 + y2 - 8
   
  
  end 
  
  

  
  def update_ui
    case @type
      when "Inventory"
        update_inventory_ui
      else
    end 
  end
  
  def update_inventory_ui
    tab_name = Settings.bag_pocket_names[@current_tab]
    if tab_name == "Food"
	
	elsif tab_name == "Tools"
	
	elsif tab_name == "Medicine"
	
	else
	
	end 
  end 
   
  

end 


class Inv_Scene
  
  def new_icon(item, amt,index,col,row)
	 @icons["#{index}_image"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_image"].bitmap = resize_item_for_slot(item)
	 slot_x = @start_x + col * 36
     slot_y = @start_y + row * 36
     @icons["#{index}_image"].z = 98
     @icons["#{index}_image"].x = slot_x + (36 - @icons["#{index}_image"].bitmap.width) / 2
     @icons["#{index}_image"].y = slot_y + (36 - @icons["#{index}_image"].bitmap.height) / 2
  
     @icons["#{index}_text"]=Window_UnformattedTextPokemon.new
	 @icons["#{index}_text"].contents.font.size = 18 
	 @icons["#{index}_text"].refresh
      pbPrepareWindow(@icons["#{index}_text"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_text"].resizeToFit(text)
	  
      @icons["#{index}_text"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_image"]
      text_sprite  = @icons["#{index}_text"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_text"].y=slot_y + 18 - @icons["#{index}_text"].contents.font.size
      @icons["#{index}_text"].windowskin=nil
      @icons["#{index}_text"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_text"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_text"].text=text
      @icons["#{index}_text"].viewport=@viewport
      @icons["#{index}_text"].z = 98
      @icons["#{index}_text"].visible=true
  end 


  def new_icon_itemcrate(item, amt,index,col,row, y = 16)
	 @icons["#{index}_slotimage"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_slotimage"].bitmap = resize_item_for_slot(item)
	 slot_x = @start_x + col * 36
     slot_y = y + row * 36
     @icons["#{index}_slotimage"].z = -1
     @icons["#{index}_slotimage"].x = slot_x + (36 - @icons["#{index}_slotimage"].bitmap.width) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - @icons["#{index}_slotimage"].bitmap.height) / 2
  
     @icons["#{index}_slottext"]=Window_UnformattedTextPokemon.new(amt.to_s)
	 @icons["#{index}_slottext"].contents.font.size = 18 
	 @icons["#{index}_slottext"].refresh
      pbPrepareWindow(@icons["#{index}_slottext"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_slottext"].resizeToFit(text)
	  
      @icons["#{index}_slottext"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_slotimage"]
      text_sprite  = @icons["#{index}_slottext"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_slottext"].y=slot_y + 18 - @icons["#{index}_slottext"].contents.font.size
      @icons["#{index}_slottext"].windowskin=nil
      @icons["#{index}_slottext"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_slottext"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_slottext"].text=text
      @icons["#{index}_slottext"].viewport=@viewport
      @icons["#{index}_slottext"].z = -1
      @icons["#{index}_slottext"].visible=true
  end 
  def new_icon_itemcrate2(item, amt,index)
     slot_x = @sprites["craft_slots#{index}"].x
	 slot_y = @sprites["craft_slots#{index}"].y
	 @icons["#{index}_slotimage"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_slotimage"].bitmap = resize_item_for_slot(item)
     @icons["#{index}_slotimage"].z = 2
     @icons["#{index}_slotimage"].x = slot_x + (36 - @icons["#{index}_slotimage"].bitmap.width) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - @icons["#{index}_slotimage"].bitmap.height) / 2
     @icons["#{index}_slottext"]=Window_UnformattedTextPokemon.new(amt.to_s)
	 @icons["#{index}_slottext"].contents.font.size = 18 
	 @icons["#{index}_slottext"].refresh
      pbPrepareWindow(@icons["#{index}_slottext"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_slottext"].resizeToFit(text)
	  
      @icons["#{index}_slottext"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_slotimage"]
      text_sprite  = @icons["#{index}_slottext"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_slottext"].y=slot_y + 18 - @icons["#{index}_slottext"].contents.font.size
      @icons["#{index}_slottext"].windowskin=nil
      @icons["#{index}_slottext"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_slottext"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_slottext"].text=text
      @icons["#{index}_slottext"].viewport=@viewport
      @icons["#{index}_slottext"].z = 2
      @icons["#{index}_slottext"].visible=true
	  @icons["#{index}_slotimage"].visible=true
  end 


  def new_icon_pkmncrate(pokemon,index,col,row, y = 16)
	 @icons["#{index}_slotimage"]=PokemonIconSprite.new(pokemon,@viewport)
	 @icons["#{index}_slotimage"].zoom_x = 0.5
	 @icons["#{index}_slotimage"].zoom_y = 0.5
	 slot_x = @start_x + col * 36
     slot_y = y + row * 36
     @icons["#{index}_slotimage"].z = -1
	 scaled_w = @icons["#{index}_slotimage"].width  * @icons["#{index}_slotimage"].zoom_x
     scaled_h = @icons["#{index}_slotimage"].height * @icons["#{index}_slotimage"].zoom_y
     @icons["#{index}_slotimage"].x = slot_x + (36 - scaled_w) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - scaled_h) / 2
  end 
  def new_icon_party(pokemon,index)
     slot_x = @sprites["#{index}_slotimagepkmn"].x
	 slot_y = @sprites["#{index}_slotimagepkmn"].y
	 @icons["#{index}_partyimage"]=PokemonIconSprite.new(pokemon,@viewport)
	 @icons["#{index}_partyimage"].zoom_x = 0.5
	 @icons["#{index}_partyimage"].zoom_y = 0.5
     @icons["#{index}_partyimage"].z = 1
	 scaled_w = @icons["#{index}_partyimage"].width  * @icons["#{index}_partyimage"].zoom_x
     scaled_h = @icons["#{index}_partyimage"].height * @icons["#{index}_partyimage"].zoom_y
     @icons["#{index}_partyimage"].x = slot_x + (36 - scaled_w) / 2
     @icons["#{index}_partyimage"].y = slot_y + (36 - scaled_h) / 2
  end 
  def new_icon_party2(pokemon,index,slotindex)
     slot_x = @sprites["#{slotindex}_slotimagepkmn"].x
	 slot_y = @sprites["#{slotindex}_slotimagepkmn"].y
	 @icons["#{index}_partyimage"]=PokemonIconSprite.new(pokemon,@viewport)
	 @icons["#{index}_partyimage"].zoom_x = 0.5
	 @icons["#{index}_partyimage"].zoom_y = 0.5
     @icons["#{index}_partyimage"].z = 1
	 scaled_w = @icons["#{index}_partyimage"].width  * @icons["#{index}_partyimage"].zoom_x
     scaled_h = @icons["#{index}_partyimage"].height * @icons["#{index}_partyimage"].zoom_y
     @icons["#{index}_partyimage"].x = slot_x + (36 - scaled_w) / 2
     @icons["#{index}_partyimage"].y = slot_y + (36 - scaled_h) / 2
  end 
  def new_icon_pkmncrate2(pokemon,index)
     slot_x = @sprites["craft_slots#{index}"].x
	 slot_y = @sprites["craft_slots#{index}"].y
	 @icons["#{index}_slotimage"]=PokemonIconSprite.new(pokemon,@viewport)
	 @icons["#{index}_slotimage"].zoom_x = 0.5
	 @icons["#{index}_slotimage"].zoom_y = 0.5
     @icons["#{index}_slotimage"].z = -1
	 scaled_w = @icons["#{index}_slotimage"].width  * @icons["#{index}_slotimage"].zoom_x
     scaled_h = @icons["#{index}_slotimage"].height * @icons["#{index}_slotimage"].zoom_y
     @icons["#{index}_slotimage"].x = slot_x + (36 - scaled_w) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - scaled_h) / 2
  end 
  
  def new_icon_pkmncrate3(pokemon,index,slotindex)
     slot_x = @sprites["craft_slots#{slotindex}"].x
	 slot_y = @sprites["craft_slots#{slotindex}"].y
	 @icons["#{index}_slotimage"]=PokemonIconSprite.new(pokemon,@viewport)
	 @icons["#{index}_slotimage"].zoom_x = 0.5
	 @icons["#{index}_slotimage"].zoom_y = 0.5
     @icons["#{index}_slotimage"].z = -1
	 scaled_w = @icons["#{index}_slotimage"].width  * @icons["#{index}_slotimage"].zoom_x
     scaled_h = @icons["#{index}_slotimage"].height * @icons["#{index}_slotimage"].zoom_y
     @icons["#{index}_slotimage"].x = slot_x + (36 - scaled_w) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - scaled_h) / 2
  end 
  



  def new_icon2(item, amt, index)
     slot_x = @sprites["craft_slots#{index}"].x
	 slot_y = @sprites["craft_slots#{index}"].y
	 @icons["#{index}_slotimage"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_slotimage"].bitmap = resize_item_for_slot(item)
     @icons["#{index}_slotimage"].z = 98
     @icons["#{index}_slotimage"].x = slot_x + (36 - @icons["#{index}_slotimage"].bitmap.width) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - @icons["#{index}_slotimage"].bitmap.height) / 2
  
     @icons["#{index}_slottext"]=Window_UnformattedTextPokemon.new(amt.to_s)
	 @icons["#{index}_slottext"].contents.font.size = 18 
	 @icons["#{index}_slottext"].refresh
      pbPrepareWindow(@icons["#{index}_slottext"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_slottext"].resizeToFit(text)
	  
      @icons["#{index}_slottext"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_slotimage"]
      text_sprite  = @icons["#{index}_slottext"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_slottext"].y=slot_y + 18 - @icons["#{index}_slottext"].contents.font.size
      @icons["#{index}_slottext"].windowskin=nil
      @icons["#{index}_slottext"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_slottext"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_slottext"].text=text
      @icons["#{index}_slottext"].viewport=@viewport
      @icons["#{index}_slottext"].z = 98
      @icons["#{index}_slottext"].visible=true
  end 

  def new_icon3(item, amt, index, slotindex)
     slot_x = @sprites["craft_slots#{slotindex}"].x
	 slot_y = @sprites["craft_slots#{slotindex}"].y
	 @icons["#{index}_image"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_image"].bitmap = resize_item_for_slot(item)
     @icons["#{index}_image"].z = 98
     @icons["#{index}_image"].x = slot_x + (36 - @icons["#{index}_image"].bitmap.width) / 2
     @icons["#{index}_image"].y = slot_y + (36 - @icons["#{index}_image"].bitmap.height) / 2
  
     @icons["#{index}_text"]=Window_UnformattedTextPokemon.new(amt.to_s)
	 @icons["#{index}_text"].contents.font.size = 18 
	 @icons["#{index}_text"].refresh
      pbPrepareWindow(@icons["#{index}_text"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_text"].resizeToFit(text)
	  
      @icons["#{index}_text"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_image"]
      text_sprite  = @icons["#{index}_text"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_text"].y=slot_y + 18 - @icons["#{index}_text"].contents.font.size
      @icons["#{index}_text"].windowskin=nil
      @icons["#{index}_text"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_text"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_text"].text=text
      @icons["#{index}_text"].viewport=@viewport
      @icons["#{index}_text"].z = 98
      @icons["#{index}_text"].visible=true
  end 
  
  def new_icon_result(item, amt, index)
     slot_x = @sprites["craft_slots#{index}"].x + 8
	 slot_y = @sprites["craft_slots#{index}"].y + 8
	 @icons["#{index}_slotimage"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_slotimage"].bitmap = resize_item_for_slot(item)
     @icons["#{index}_slotimage"].z = 98
     @icons["#{index}_slotimage"].x = slot_x + (36 - @icons["#{index}_slotimage"].bitmap.width) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - @icons["#{index}_slotimage"].bitmap.height) / 2
  
     @icons["#{index}_slottext"]=Window_UnformattedTextPokemon.new(amt.to_s)
	 @icons["#{index}_slottext"].contents.font.size = 18 
	 @icons["#{index}_slottext"].refresh
      pbPrepareWindow(@icons["#{index}_slottext"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_slottext"].resizeToFit(text)
	  
      @icons["#{index}_slottext"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_slotimage"]
      text_sprite  = @icons["#{index}_slottext"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_slottext"].y=slot_y + 18 - @icons["#{index}_slottext"].contents.font.size
      @icons["#{index}_slottext"].windowskin=nil
      @icons["#{index}_slottext"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_slottext"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_slottext"].text=text
      @icons["#{index}_slottext"].viewport=@viewport
      @icons["#{index}_slottext"].z = 98
      @icons["#{index}_slottext"].visible=true
  end 
  
  def new_icon_crafted(item, amt, index)
     slot_x = @sprites["craft_slots_result"].x + 8
	 slot_y = @sprites["craft_slots_result"].y + 8
	 @icons["#{index}_slotimage"]=IconSprite.new(0,0,@viewport)
	 @icons["#{index}_slotimage"].bitmap = resize_item_for_slot(item)
     @icons["#{index}_slotimage"].z = 98
     @icons["#{index}_slotimage"].x = slot_x + (36 - @icons["#{index}_slotimage"].bitmap.width) / 2
     @icons["#{index}_slotimage"].y = slot_y + (36 - @icons["#{index}_slotimage"].bitmap.height) / 2
  
     @icons["#{index}_slottext"]=Window_UnformattedTextPokemon.new(amt.to_s)
	 @icons["#{index}_slottext"].contents.font.size = 18 
	 @icons["#{index}_slottext"].refresh
      pbPrepareWindow(@icons["#{index}_slottext"])
	  if amt>1
	  text = amt.to_s
	  else
	  text = ""
	  end
      @icons["#{index}_slottext"].resizeToFit(text)
	  
      @icons["#{index}_slottext"].x = @start_x + 20 #if i == 0
	  
	  
      image_sprite = @icons["#{index}_slotimage"]
      text_sprite  = @icons["#{index}_slottext"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 18 + usable_width / 2 
      text_sprite.x = center_x - text_sprite.width / 2 #if i != 0
	  
	  
	  
      @icons["#{index}_slottext"].y=slot_y + 18 - @icons["#{index}_slottext"].contents.font.size
      @icons["#{index}_slottext"].windowskin=nil
      @icons["#{index}_slottext"].baseColor=Color.new(248, 248, 248)
      @icons["#{index}_slottext"].shadowColor=Color.new(0, 0, 0)#nil
      @icons["#{index}_slottext"].text=text
      @icons["#{index}_slottext"].viewport=@viewport
      @icons["#{index}_slottext"].z = 98
      @icons["#{index}_slottext"].visible=true
  end 
 

  def pbDisplay(msg, brief = false)
    #raise "fuck"
    UIHelper.pbDisplayStatic2(@sprites["msgwindow"], msg)
  end

  def pbDisplayReal(msg, brief = false)
    #raise "fuck"
    UIHelper.pbDisplay(@sprites["msgwindow"], msg, brief) { pbUpdate }
  end

  def pbDisplayStatic2(msg)
    UIHelper.pbDisplayStatic2(@sprites["msgwindow"], msg)
  end

  def pbDisplayStatic(msg)
    UIHelper.pbDisplayStatic(@sprites["msgwindow"], msg) { pbUpdate }
  end


  def pbConfirm(msg)
    UIHelper.pbConfirm(@sprites["cmdwindow"], msg) { pbUpdate }
  end

  def pbChooseNumber(helptext, maximum, initnum = 1)
    return UIHelper.pbChooseNumber(@sprites["cmdwindow"], helptext, maximum, initnum) { pbUpdate }
  end

  def pbShowCommands(helptext, commands, index = 0)
    return UIHelper.pbShowCommands(@sprites["cmdwindow"], helptext, commands, index) { pbUpdate }
  end



  def CurrentColors(hp, totalhp)
    if hp<(totalhp/4.0)
      return Color.new(255,55,55)
    elsif hp<=(totalhp/4.0)
      return Color.new(255,125,55)
    elsif hp<=(totalhp/2.0)
      return Color.new(255,255,55)
    end
    return Color.new(55,255,55)
  end
  def CurrentColorsAlt(hp, totalhp)
      return Color.new(152,208,248)
  end

  
  def create_text(text,x,y)
    @sprites["#{text}_text"]=Window_UnformattedTextPokemon.new(text)
    text_sprite = @sprites["#{text}_text"]
	text_sprite.contents.font.size = 14 
	text_sprite.refresh
    pbPrepareWindow(text_sprite)
    text_sprite.resizeToFit(text)
	text_sprite.x = x
	text_sprite.y= y - 16 - text_sprite.contents.font.size
    text_sprite.windowskin=nil
    text_sprite.baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    text_sprite.shadowColor=nil
    text_sprite.text=text
    text_sprite.viewport=@viewport
    text_sprite.z = 10
    text_sprite.visible=true
  end 
  def create_text2(key,text,x,y)
    @sprites["#{key}_text"]=Window_UnformattedTextPokemon.new(text)
    text_sprite = @sprites["#{key}_text"]
	text_sprite.contents.font.size = 14 
	text_sprite.refresh
    pbPrepareWindow(text_sprite)
    text_sprite.resizeToFit(text)
	text_sprite.x = x
	text_sprite.y= y - 16 - text_sprite.contents.font.size
    text_sprite.windowskin=nil
    text_sprite.baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    text_sprite.shadowColor=nil
    text_sprite.text=text
    text_sprite.viewport=@viewport
    text_sprite.z = 10
    text_sprite.visible=true
  end 
  
  def create_text3(key,text,x,y,color=MessageConfig::DARK_TEXT_MAIN_COLOR,shadowcolor=nil,size=14)
    @sprites["#{key}"]=Window_UnformattedTextPokemon.new(text)
    text_sprite = @sprites["#{key}"]
	text_sprite.contents.font.size = size 
	text_sprite.refresh
    pbPrepareWindow(text_sprite)
    text_sprite.resizeToFit(text)
	text_sprite.x = x
	text_sprite.y= y - 16 - text_sprite.contents.font.size
    text_sprite.windowskin=nil
    text_sprite.baseColor=color
    text_sprite.shadowColor=shadowcolor
    text_sprite.text=text
    text_sprite.viewport=@viewport
    text_sprite.z = 10
    text_sprite.visible=true
  end 
  
  



end 