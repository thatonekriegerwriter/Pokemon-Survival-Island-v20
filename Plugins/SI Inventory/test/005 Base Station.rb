module InventoryScene
  SLOT_SIZE = 36
  BAG_COLS = 9
  BAG_ROWS = 4
  # Owns storage (sprites/icons/objects, party, pockets, craft slots,
  # grabbed-item state), the shared chrome every station has (background
  # image, pocket tabs, bag slot grid, party sidebar), and the top-level
  # update/input/exit loops.
  #
  # Subclasses MUST implement:
  #   #render_station                 -> this station's specific slot sprites
  #   #slot_count                     -> how many craft slots this station has
  #   #background_key                 -> suffix used in the background image
  #                                       path, e.g. "FURNACE" ->
  #                                       .../craftingPageFURNACE
  #
  # Subclasses MAY override:
  #   #on_craft_consumed(recipe)      -> station-specific cost (fuel, stamina)
  #   #station_can_afford_extra_cost? -> gate crafting on a resource
  #   #handle_station_click(kind, index) -> station-specific click behavior
  #                                          beyond the generic drag/drop pool
  #   #finalize_container             -> what happens to @craft/@container on
  #                                       exit (defaults to dumping @craft
  #                                       into $bag)
  #   #has_party_sidebar?, #has_bag_grid? -> both default true; Bedroll is
  #                                       the only station that turns them off
  #   #station_update                 -> anything that needs to run every
  #                                       frame beyond the shared loop
  #   #uses_recipe_grid?              -> whether the generic result-slot
  #                                       crafting flow (Concerns::Craftable)
  #                                       applies at all - false for
  #                                       ItemCrate/Icebox/PkmnCrate/Bedroll,
  #                                       which don't produce anything
  class BaseStation
    include InventoryScene::Concerns::Craftable
    include InventoryScene::Concerns::DraggableSlots
    include InventoryScene::Concerns::PartyInteraction
    include InventoryScene::Concerns::ItemCommands

    BAG_COLS = InventoryScene::BAG_COLS
    BAG_ROWS = InventoryScene::BAG_ROWS
    SLOT_SIZE = InventoryScene::SLOT_SIZE
    PARTY_SIZE = 6


    attr_reader :viewport, :sprites, :icons, :objects, :tooltip, :buttons
    attr_reader :event_data, :container, :party, :pockets
    attr_reader :bonus_1, :bonus_2, :start_x, :start_y, :mamtx, :mamty
    attr_accessor :craft, :current_tab, :result, :grabbed_item
    attr_reader :search_query
    attr_accessor :pokemon_inventory, :current_pokemon_for_inventory, :item_hovered
    attr_accessor :current_pokemon_for_inventory_slot

    def initialize(event_data:, container:)
      $game_temp.in_inventory = true
      $OverworldMenu.should_refresh = true 
	  $hud.hideMainHUD
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99_999

      @sprites, @icons, @objects, @buttons = {}, {}, {}, {}
      @grabbed_item = nil
      @result = nil
      @exiting = false
      @return_value = nil
      @search_query = ""
      @item_hovered = nil
      @pokemon_inventory = nil
      @current_pokemon_for_inventory = nil
      @current_pokemon_for_inventory_slot = nil

      @event_data = event_data
      @container  = container
      @party      = $player.party
      @pockets    = $bag.pockets
      @current_tab = $bag.last_viewed_pocket - 1
      @craft = initial_craft_contents

      @tooltip = Tooltip.new
      build_offsets
      build_shared_chrome
      build_background
      build_tabs
	  @legend_visible = true 
	  build_legend if @legend_visible
      if has_party_sidebar?
        build_party_sidebar
        build_pokemon_inventory_panel
      end
      build_bag_grid if has_bag_grid?
      build_search_ui if shows_search_ui?

      render_station
      pbDeactivateWindows(@sprites)
    end

    # ---- shared update/exit loop -----------------------------------

    def update
      tooltip.update
      pbUpdateSpriteHash(sprites)
      update_tab_highlight
      update_drag_ghost
      update_highlight
      update_hover_tooltip
      update_party_bars if has_party_sidebar?
      update_result_slot if uses_recipe_grid?
      update_pokemon_icon_tones
      station_update if respond_to?(:station_update, true)
    end
    alias pbUpdate update

    def pbEndScene
      salvage_held_item 
      finalize_container
      save_party_and_equipment if respond_to?(:save_party_and_equipment, true)
      pbDisposeSpriteHash(icons)
      pbDisposeSpriteHash(sprites)
      pbDisposeSpriteHash(objects)
      tooltip.dispose
      viewport.dispose unless viewport.nil? || viewport.disposed?
    end
	
    def salvage_held_item
      return unless grabbed_item && !grabbed_item.pokemon?
      return if grabbed_item.from_fixed_slot? # still aliased into its origin array - already saved normally, adding it again would duplicate it
 
      $bag.add(grabbed_item.item, grabbed_item.qty)
      self.grabbed_item = nil
    end

    def pbSelectcraft
      overlay = sprites["overlay"].bitmap
      overlay.clear
      pbSetSystemFont(overlay)
      $game_temp.just_update_anyways = true
      loop do
        Graphics.update
        $PokemonGlobal.addNewFrameCount
		$OverworldMenu.createSprites unless $OverworldMenu.hasSprites?
        $OverworldMenu.refresh
        $OverworldMenu.update
		$OverworldMenu.revealBallHUD
	    $OverworldMenu.hideSmallBallHUD
        $sidedisplay.update
        Input.update

        if @exiting
          $bag.last_viewed_pocket = current_tab + 1
          pbEndScene
          $game_temp.just_update_anyways = false
          return @return_value
        end

        update
        process_input
        break if $game_temp.fly_destination && !grabbed_item
      end
      @return_value
    end

    # ---- default hooks (overridable) --------------------------------

    def initial_craft_contents      = []
    def finalize_container          = craft.each { |data| $bag.add(data[0], data[1]) if data }
    def on_craft_consumed(_recipe)  = nil
    def has_party_sidebar?          = true
    def extra_slot_result_sized?    = false
    def has_bag_grid?               = true
    def uses_recipe_grid?           = true
    def handle_station_click(_kind, _index) = nil
    def shows_search_ui?            = true
    def search_query=(value)
      @search_query = value.to_s
      reapply_search_dim
      update_search_label
    end

    def legend_entries
      entries = [["Middle-Click", "Interact"], ["I", "Summary"], ["V", "Notebook"], ["F", "Quick Access"], ["Tab", "Favorite"]]
      entries
    end

    def current_pocket = pockets[current_tab + 1]

    def exit!(return_value = nil)
      @return_value = return_value
      @exiting = true
    end

    # Only Bag builds equipment slots / a Pokemon box grid; any other
    # station reaching these has a bug in its click routing, so this
    # fails loudly rather than silently doing nothing.
    def equip = raise(NotImplementedError, "#{self.class} has no equipment slots")
    def pokemon_box = raise(NotImplementedError, "#{self.class} has no Pokemon box")

    # Bag overrides this to toggle the equipment panel / feed items to
    # the player; every other station has no clickable objects.
    def handle_object_click(_object_key) = nil
	def bonus_slot_function = nil
    # Stub - what "select this item" actually does belongs to
    # $OverworldMenu, not this scene. Fill this in (or override per-
    # station if it should ever behave differently in one).
    def handle_item_box_drop = nil

    # Generic move-validation for Pokemon-holding slots (party sidebar,
    # PkmnCrate, Pet Bed) - checked before a Pokemon can be picked up
    # from a slot, or placed into one, respectively. Both default to
    # "always allowed"; override per-station for rules like "can't move
    # a Pokemon that's fainted" or "this slot is full."
    def pokemon_leavable?(_kind, _index, _pokemon) = true
    def pokemon_placeable?(_kind, _index, _pokemon) = true

    # Side-effect hooks, called AFTER a move actually succeeds (unlike
    # the two above, which gate whether it's allowed to happen at all).
    # Needed for cases like Adventure setting current_map/on_adventure
    # when a Pokemon lands in its adventuring-party grid - the generic
    # swap logic only moves the reference, it has no idea a station
    # might need field mutations alongside that.
    def on_pokemon_placed(_kind, _index, _pokemon) = nil
    def on_pokemon_removed(_kind, _index, _pokemon) = nil

    # Hook for stations whose interaction model doesn't fit the standard
    # slot-grid system at all - return true to consume a click and skip
    # every other routing check for it. Checked first, before bag/craft/
    # equipment/pokemon slot detection.
    def handle_custom_click(_button) = false

    # ---- generic scene API expected by ItemHandlers/pbUseItem/etc ------
    # (item effect handlers call back into whatever scene invoked them,
    # so these need to exist on every station, not just the bag)

    def pbDisplay(msg, _brief = false) = UIHelper.pbDisplayStatic2(sprites["msgwindow"], msg)
    def pbDisplayStatic2(msg)          = UIHelper.pbDisplayStatic2(sprites["msgwindow"], msg)
    def pbDisplayStatic(msg)           = UIHelper.pbDisplayStatic(sprites["msgwindow"], msg) { pbUpdate }
    def pbConfirm(msg)                 = UIHelper.pbConfirm(sprites["cmdwindow"], msg) { pbUpdate }
    def pbChooseNumber(helptext, maximum, initnum = 1)
      UIHelper.pbChooseNumber(sprites["cmdwindow"], helptext, maximum, initnum) { pbUpdate }
    end
    def pbShowCommands(helptext, commands, index = 0)
      UIHelper.pbShowCommands(sprites["cmdwindow"], helptext, commands, index) { pbUpdate }
    end
    def pbRefresh = nil
    def pbPrepareWindow(window)
     window.visible=true
     window.letterbyletter=false
    end
	
	
    def handle_item_box_drop 
      return unless grabbed_item
      item = grabbed_item.item
      $PokemonGlobal.set_hud_for(item)
	  put_back_grabbed_item 
	end 
	
    private

    # ---- shared geometry / background -------------------------------

    # Matches the original's magic numbers - untouched so every station's
    # slot math (ported straight from the setup_*_ui methods) still lines
    # up against the same background art.
    def build_offsets
      @mamtx = 66
      @mamty = 30
      @bonus_1 = 6
      @bonus_2 = 12
      @start_x = @bonus_1 + 92 - @mamtx - 4
      @start_y = @bonus_2 + 194 - @mamty
    end

    def build_background
      sprites["type"] = IconSprite.new(0, 0, viewport)
      path = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingPage#{background_key}"
      path = "Graphics/Pictures/craftingMenu/newCraftingPages/craftingPage" unless pbResolveBitmap(path)
      sprites["type"].setBitmap(path)
      sprites["type"].z = -3
      sprites["type"].x = @bonus_1 - @mamtx
      sprites["type"].y = @bonus_2 - @mamty

      sprites["background"] = IconSprite.new(0, 0, viewport)
      sprites["background"].setBitmap("Graphics/Pictures/craftingMenu/placeholder")
      sprites["background"].z = 0
      sprites["background"].x = @bonus_1 - @mamtx
      sprites["background"].y = @bonus_2 - @mamty
    end

    # Position is a guess (top-left corner of the tab bar area) - move it
    # wherever actually fits your background art. Shows a hint when
    # empty, the live query once you've typed something.
    def build_search_ui
      sprites["searchtab"] = IconSprite.new(0, 0, viewport)
      sprites["searchtab"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/poptab2")
      sprites["searchtab"].z = 70
      sprites["searchtab"].x = @start_x - 14
      sprites["searchtab"].y = @start_y - 172
      create_text3("search_label", search_hint_text, @start_x - 20, @start_y - 152, MessageConfig::DARK_TEXT_MAIN_COLOR, nil, 12)
      sprites["search_label"].z = 71
    end
 
    def search_hint_text
      search_query.empty? ? "[S] Search..." : "Search: #{search_query}"
    end


    # Bottom-left of the WHOLE screen (absolute Graphics coordinates,
    # not bonus_1/bonus_2 - that region is inside the background art and
    # is already cramped), same "poptab" bitmap/text convention as the
    # Grinder's stamina readout, just stacked one per hotkey instead of
    # one per stat. Toggled on/off rather than always shown, since a
    # permanent legend doesn't fit and this is meant to answer "what do
    # my keys do" on demand rather than sit there as clutter.
    def toggle_legend
      @legend_visible = !@legend_visible
      @legend_visible ? build_legend : clear_legend
    end

    def build_legend
      clear_legend
      entries = legend_entries
      tab_height = 18
	  start_x = @bonus_1
      start_y = Graphics.height - tab_height
      spacing = 6
	  
	  
      entries.each_with_index do |(key, desc), i|
        sprites["legend_tab#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["legend_tab#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/legend")


        column = i / 2
        row = i % 2
        x = start_x + column * (sprites["legend_tab#{i}"].bitmap.width + spacing)
        y = start_y - row * 18
		z = i.even? ? 9990 : 9989
        sprites["legend_tab#{i}"].z = z
        sprites["legend_tab#{i}"].x = x 
        sprites["legend_tab#{i}"].y = y

        create_text3("legend_text#{i}", "#{key}: #{desc}", x, y + 20, MessageConfig::DARK_TEXT_MAIN_COLOR, nil, 12)
        sprites["legend_text#{i}"].z = 9991 # create_text3 defaults to z=10, which would sit BEHIND the tab bitmap above
      end
    end

    def clear_legend
      sprites.keys.select { |k| k.to_s.start_with?("legend_") }.each do |k|
        remove(sprites[k])
        sprites.delete(k)
      end
    end

    def update_search_label
      sprites["search_label"]&.setTextToFit(search_hint_text)
    end


    def build_shared_chrome
      sprites["statuses"] = AnimatedBitmap.new(_INTL("Graphics/Pictures/statuses"))
      %w[highlight highlight2].each do |key|
        sprites[key] = IconSprite.new(0, 0, viewport)
        sprites[key].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
        sprites[key].z = 9999
        sprites[key].visible = false
      end
      sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
      sprites["msgwindow"].visible = false
      sprites["msgwindow"].viewport = viewport
      sprites["cmdwindow"] = Window_AdvancedTextPokemon.new("")
      sprites["cmdwindow"].visible = false
      sprites["cmdwindow"].viewport = viewport
      sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, viewport)
      sprites["overlay"].z = 99
    end

    # Pocket tabs are always built, even for Bedroll - the original built
    # them unconditionally too (only `left_click_tab` special-cased Bedroll
    # to ignore clicks on them). Kept as-is rather than "fixed", since I
    # can't tell from the source alone whether that's deliberate (tabs
    # visible-but-inert while sleeping) or an oversight - worth you
    # confirming in-engine.
    def build_tabs
      Settings.bag_pocket_names.each_with_index do |name, i|
        sprites["#{name}_image"] = IconSprite.new(0, 0, viewport)
        sprites["#{name}_image"].setBitmap(i == current_tab ? "Graphics/Pictures/notebooktab" : "Graphics/Pictures/notebooktabu")
        tab_width = i.zero? ? nil : sprites["#{Settings.bag_pocket_names[0]}_image"].width - 36
        sprites["#{name}_image"].x = i.zero? ? @start_x : @start_x + 2 + tab_width * i
        sprites["#{name}_image"].y = @start_y - 22
        sprites["#{name}_image"].z = i == current_tab ? 49 : i + 10

        sprites["#{name}_icon"] = IconSprite.new(0, 0, viewport)
        sprites["#{name}_icon"].setBitmap("Graphics/Pictures/craftingMenu/bag/bagPocket#{i + 1}")
        offset = name == "Battle Items" ? 8 : (name == "Poké Balls" ? 10 : 16)
        sprites["#{name}_icon"].x = i.zero? ? @start_x + 8 : @start_x + offset + tab_width * i
        sprites["#{name}_icon"].y = @start_y - 16
        sprites["#{name}_icon"].zoom_x = sprites["#{name}_icon"].zoom_y = 0.5
        sprites["#{name}_icon"].z = i == current_tab ? 50 : i + 10

        build_tab_label(name, i)
      end
    end

    def build_tab_label(name, i)
      sprites["#{name}_text"] = Window_UnformattedTextPokemon.new(name)
      sprites["#{name}_text"].contents.font.size = 14
      sprites["#{name}_text"].refresh
      pbPrepareWindow(sprites["#{name}_text"])
      sprites["#{name}_text"].resizeToFit(name)
      image_sprite = sprites["#{name}_image"]
      usable_width = image_sprite.width - 12
      center_x = image_sprite.x + 12 + usable_width / 2
      sprites["#{name}_text"].x = name == "Battle Items" ? 5 + center_x - sprites["#{name}_text"].width / 2 : center_x - sprites["#{name}_text"].width / 2
      sprites["#{name}_text"].y = @start_y - 16 - sprites["#{name}_text"].contents.font.size
      sprites["#{name}_text"].windowskin = nil
      sprites["#{name}_text"].baseColor = MessageConfig::DARK_TEXT_MAIN_COLOR
      sprites["#{name}_text"].shadowColor = i == current_tab ? Color.new(248, 248, 248) : Color.new(190, 190, 190)
      sprites["#{name}_text"].text = name
      sprites["#{name}_text"].viewport = viewport
      sprites["#{name}_text"].z = i == current_tab ? 50 : i + 10
      sprites["#{name}_text"].visible = true
    end

    def update_tab_highlight
      Settings.bag_pocket_names.each_with_index do |name, i|
        selected = current_tab == i
        sprites["#{name}_image"].setBitmap(selected ? "Graphics/Pictures/notebooktab" : "Graphics/Pictures/notebooktabu")
        sprites["#{name}_image"].z = selected ? 49 : i + 10
        sprites["#{name}_text"].z = sprites["#{name}_icon"].z = selected ? 50 : i + 10
        sprites["#{name}_text"].shadowColor = selected ? Color.new(248, 248, 248) : Color.new(190, 190, 190)
      end
    end

    def left_click_tab
      tabs = Settings.bag_pocket_names.map { |name| sprites["#{name}_image"] }.sort_by { |s| -s.z }
      tabs.each do |sprite|
        next unless tab_clicked?(sprite)

        name = sprites.key(sprite).sub("_image", "")
        self.current_tab = Settings.bag_pocket_names.index(name)
        refresh_bag_grid
        break
      end
    end

    def tab_clicked?(sprite)
      return false if grabbed_item

      mouse_x, mouse_y = Mouse.getMousePos
      return false if mouse_x.nil?

      local_x = mouse_x - sprite.x
      local_y = mouse_y - sprite.y
      return false if local_x < 0 || local_y < 0 || local_x >= sprite.bitmap.width || local_y >= sprite.bitmap.height

      sprite.bitmap.get_pixel(local_x, local_y).alpha > 0
    end

    # ---- bag slot grid (the player's actual bag, not a craft grid) ----

    def build_bag_grid
      max_slots = Settings::BAG_MAX_POCKET_SIZE.max
      max_slots.times do |i|
        col = i % BAG_COLS
        row = i / BAG_COLS
        sprites["slots#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
        sprites["slots#{i}"].z = 70
        sprites["slots#{i}"].x = @start_x + col * SLOT_SIZE
        sprites["slots#{i}"].y = @start_y + row * SLOT_SIZE

        sprites["slots_star#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["slots_star#{i}"].setBitmap("Graphics/Pictures/craftingMenu/star")
        sprites["slots_star#{i}"].z = 9998
        sprites["slots_star#{i}"].x = sprites["slots#{i}"].x + 26
        sprites["slots_star#{i}"].y = sprites["slots#{i}"].y + 2
        sprites["slots_star#{i}"].visible = false

        sprites["slots_qstar#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["slots_qstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/redstar")
        sprites["slots_qstar#{i}"].z = 9999
        sprites["slots_qstar#{i}"].x = sprites["slots#{i}"].x + 26
        sprites["slots_qstar#{i}"].y = sprites["slots#{i}"].y + 2
        sprites["slots_qstar#{i}"].visible = false
      end
      refresh_bag_grid
    end


  
	def should_persist_icon?(key)
	 return key.to_s.include?("_result") || key.to_s.include?("held") || key.to_s.include?("_crafted")
	end 
	
      def switch_tab_to_item_pocket(item)
        return unless item

        pocket = GameData::Item.get(item).pocket
        self.current_tab = pocket - 1
        refresh_bag_grid
      end
	def update_selected_tab(kind, index)
	  store = backing_store_for(kind)
      slot_item = store[store_index_for(kind, index)]
	  return unless slot_item
	  item = slot_item[0]
	  pocket = item.pocket - 1
	  return if self.current_tab == pocket
      self.current_tab = pocket
	  refresh_bag_grid
	end 
	
    def refresh_bag_grid
	  return unless has_bag_grid?
      icons.each { |key, icon| remove(icon) if (key.to_s.end_with?("_image") || key.to_s.end_with?("_text")) && !should_persist_icon?(key) }
      icons.delete_if { |key, _| (key.to_s.end_with?("_image") || key.to_s.end_with?("_text")) && !should_persist_icon?(key)}

      pocket_index = current_tab + 1
      pockets[pocket_index].fill(nil, pockets[pocket_index].length...Settings::BAG_MAX_POCKET_SIZE.max)
      max_slots = Settings::BAG_MAX_POCKET_SIZE.max
      max_slots_for_pocket = Settings::BAG_MAX_POCKET_SIZE[current_tab]
      items = pockets[pocket_index]

      items.each_with_index do |slot, index|
        next if slot.nil?

        item, amt = slot
        render_slot_icon(:bag, index, item, amt)
      end

      max_slots.times do |i|
        sprites["slots#{i}"].setBitmap(i < max_slots_for_pocket ? "Graphics/Pictures/craftingMenu/placeholder_slot" : "Graphics/Pictures/craftingMenu/placeholder_slot_2")
		if items[i]
          item, amt = items[i]
          sprites["slots_star#{i}"].visible = $bag.registered?(item)
          sprites["slots_qstar#{i}"].visible = quick_access_identical?(item)
		else 
         sprites["slots_star#{i}"].visible = false 
         sprites["slots_qstar#{i}"].visible = false 
		end 
      end
    end

    # ---- mouse geometry -----------------------------------------------
      def adventure_slot_from_mouse
        return nil unless self.is_a?(InventoryScene::Stations::AdventureFlag)
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        InventoryScene::Stations::AdventureFlag::PARTY_SIZE.times do |i|
          sprite = sprites["adv_slots#{i}"]
          next unless sprite && within_sprite?(sprite, mouse_x, mouse_y)

          return i
        end
        nil
      end
	  
    def slot_from_mouse
      mouse_x, mouse_y = Mouse.getMousePos
      return if mouse_x.nil?

      rel_x = mouse_x - @start_x
      rel_y = mouse_y - @start_y
      return if rel_x < 0 || rel_y < 0 || rel_x >= BAG_COLS * SLOT_SIZE || rel_y >= BAG_ROWS * SLOT_SIZE

      col = rel_x / SLOT_SIZE
      row = rel_y / SLOT_SIZE
      [row * BAG_COLS + col, col, row]
    end

    def crafting_slot_from_mouse
      mouse_x, mouse_y = Mouse.getMousePos
      return if mouse_x.nil?

      slot_count.times do |i|
        sprite = sprites["craft_slots#{i}"]
        next unless sprite && within_sprite?(sprite, mouse_x, mouse_y)

        return i
      end

      if extra_slot_index
        extra_sprite = sprites["craft_slots#{extra_slot_index}"]
        return extra_slot_index if extra_sprite && within_sprite?(extra_sprite, mouse_x, mouse_y)
      end

      result_sprite = sprites["craft_slots_result"]
      return "_result" if result_sprite && within_sprite?(result_sprite, mouse_x, mouse_y)

      nil
    end

    # ApricornMachine is the only station with a slot outside the main
    # 0...slot_count range (its "extra" slot at index 5, rendered but not
    # part of the recipe match - see stations/apricorn_machine.rb).
    def extra_slot_index = nil

    def equipment_slot_from_mouse
      return nil unless buttons["equipment_button"]

      mouse_x, mouse_y = Mouse.getMousePos
      return if mouse_x.nil?

      3.times do |i|
        sprite = sprites["craft_slots#{i + 100}"]
        next unless sprite && within_sprite?(sprite, mouse_x, mouse_y)

        return i + 100
      end
      nil
    end

    def within_sprite?(sprite, mouse_x, mouse_y)
      x1, y1 = sprite.x, sprite.y
      mouse_x >= x1 && mouse_x < x1 + sprite.bitmap.width && mouse_y >= y1 && mouse_y < y1 + sprite.bitmap.height
    end


    # $OverworldMenu's Item Box - not part of this UI at all, but a valid
    # drop target for it. Blocked while a Pokemon's held-item inventory
    # panel is open, per your note.
    def item_box_hovered?
      return false if render_pokemon_inventory?
 
      sprite = $OverworldMenu.item_box
      return false if sprite.nil?
 
      mouse_x, mouse_y = Mouse.getMousePos
      return false if mouse_x.nil?
 
      local_x = mouse_x - sprite.x
      local_y = mouse_y - sprite.y
      result = local_x >= 20 && local_x < 71 && local_y >= 15 && local_y < 65
	  return result 
    end
    

    def update_pokemon_icon_tones
      icons.each_value do |value|
        next unless value.is_a?(PokemonIconSprite) && !value.disposed?

        if value.pokemon&.dead?
          value.tone = Tone.new(64, -64, -64, 255)
        elsif value.pokemon&.fainted?
          value.tone = Tone.new(0, 0, 0, 255)
        elsif value.pokemon
          value.tone = Tone.new(0, 0, 0, 0)
          value.update
        end
      end
    end

    def remove(icon)
      return if icon.nil? || icon.disposed?

      icon.visible = false if icon.respond_to?(:visible=)
      icon.dispose
    end
  end
end
