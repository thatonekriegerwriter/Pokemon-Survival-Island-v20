module InventoryScene
  module Concerns
    # Party sidebar (HP bars, status icons, drag/swap), a Pokemon's
    # held-item inventory panel, and use_item_on_pokemon. Also provides
    # #handle_pokemon_click, shared by the party sidebar AND PkmnCrate's
    # box grid, since "pick up / place / swap a Pokemon" is identical
    # logic over two different backing arrays.
    module PartyInteraction
      # ---- party sidebar construction -----------------------------------

      def build_party_sidebar
        sprites["pkmnside"] = IconSprite.new(0, 0, viewport)
        sprites["pkmnside"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/sidepkmn")
        sprites["pkmnside"].z = 0
        sprites["pkmnside"].x = Graphics.width - 56 - 72 - 12
        sprites["pkmnside"].y = 14

        Settings::MAX_PARTY_SIZE.times do |i|
          build_party_slot_sprites(i)
          if party[i]
            render_pokemon_icon(:party, i, party[i])
            create_text3("#{i}_slottextpkmn", party[i].name, sprites["#{i}_slotimagepkmn"].x + 28, sprites["#{i}_slotimagepkmn"].y + 16, MessageConfig::LIGHT_TEXT_MAIN_COLOR, nil, 11)
            sprites["slotimagepkmnstar#{i}"].visible = true if $bag.registered?(party[i])
          else
            create_text3("#{i}_slottextpkmn", "             ", sprites["#{i}_slotimagepkmn"].x + 28, sprites["#{i}_slotimagepkmn"].y + 16, MessageConfig::LIGHT_TEXT_MAIN_COLOR, nil, 11)
          end
          create_status_sprite(i, sprites["#{i}_slotimagepkmn"].x + 20, sprites["#{i}_slotimagepkmn"].y)
          build_bar("party#{i}", "", sprites["#{i}_slotimagepkmn"].x + 36 + 6, sprites["#{i}_slotimagepkmn"].y + 16, "", "")
        end
      end

      def build_party_slot_sprites(i)
        slot_size = 36
        sprites["#{i}_slotimagepkmn"] = IconSprite.new(0, 0, viewport)
        sprites["#{i}_slotimagepkmn"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
        sprites["#{i}_slotimagepkmn"].x = sprites["pkmnside"].x - 4 + sprites["#{i}_slotimagepkmn"].width / 2
        sprites["#{i}_slotimagepkmn"].y = sprites["pkmnside"].y - 4 + (slot_size * i) + sprites["#{i}_slotimagepkmn"].height / 2
        sprites["#{i}_slotimagepkmn"].z = 1

        sprites["slotimagepkmnstar#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["slotimagepkmnstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/star")
        sprites["slotimagepkmnstar#{i}"].z = 9998
        sprites["slotimagepkmnstar#{i}"].x = sprites["#{i}_slotimagepkmn"].x + 26
        sprites["slotimagepkmnstar#{i}"].y = sprites["#{i}_slotimagepkmn"].y + 2
        sprites["slotimagepkmnstar#{i}"].visible = false

        sprites["slotimagepkmnqstar#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["slotimagepkmnqstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/redstar")
        sprites["slotimagepkmnqstar#{i}"].z = 9998
        sprites["slotimagepkmnqstar#{i}"].x = sprites["#{i}_slotimagepkmn"].x + 26
        sprites["slotimagepkmnqstar#{i}"].y = sprites["#{i}_slotimagepkmn"].y + 2
        sprites["slotimagepkmnqstar#{i}"].visible = false
      end

      def create_status_sprite(index, x, y)
        icons["status_sprites#{index}"] = IconSprite.new(x, y, viewport)
        icons["status_sprites#{index}"].bitmap = sprites["statuses"].bitmap
        icons["status_sprites#{index}"].zoom_x = icons["status_sprites#{index}"].zoom_y = 0.5
        icons["status_sprites#{index}"].x = x + 56
        icons["status_sprites#{index}"].y = y + 6
        icons["status_sprites#{index}"].z = 0
        icons["status_sprites#{index}"].src_rect = Rect.new(0, 0, 0, 0)
        icons["status_sprites#{index}"].visible = false
      end

      def update_status_sprite(index, pokemon)
        sprite = icons["status_sprites#{index}"]
        return unless sprite

        if pokemon.nil? || pokemon.egg?
          sprite.visible = false
          return
        end

        status = if pokemon.dead? then GameData::Status.count + 1
                 elsif pokemon.fainted? || pokemon.pokerusStage == 1 then GameData::Status.count - 1
                 elsif pokemon.status != :NONE then GameData::Status.get(pokemon.status).icon_position
                 else -1
                 end
        return sprite.visible = false if status < 0

        sprite.src_rect.set(0, 16 * status, 44, 16)
        sprite.visible = true
      end

      # ---- party bars ----------------------------------------------------

      def update_party_bars
        Settings::MAX_PARTY_SIZE.times do |i|
          key = "party#{i}"
          pkmn = party[i]
          sprites["slotimagepkmnstar#{i}"].visible = false
          if pkmn
		    if grabbed_item && pkmn == grabbed_item.stack[0]
              set_bar_visible(key, false)
              sprites["slotimagepkmnstar#{i}"].visible = false
              sprites["#{i}_slottextpkmn"].visible = false if sprites["#{i}_slottextpkmn"]
              update_status_sprite(i, nil)
              next
			end 
            sprites["#{i}_slottextpkmn"].setTextToFit(pkmn.name) if sprites["#{i}_slottextpkmn"].text != pkmn.name
            sprites["#{i}_slottextpkmn"].visible = true
            sprites["slotimagepkmnstar#{i}"].visible = $bag.registered?(pkmn)
            sprites["slotimagepkmnqstar#{i}"].visible = quick_access_identical?(pkmn)
            if pkmn.egg?
              set_bar_visible(key, false)
              next
            end
            update_bar(key, "HP", pkmn.hp, pkmn.totalhp)
            update_status_sprite(i, pkmn)
            set_bar_visible(key, true)
          else
            set_bar_visible(key, false)
            sprites["#{i}_slottextpkmn"].visible = false if sprites["#{i}_slottextpkmn"]
            update_status_sprite(i, nil)
          end
        end
      end

      def set_bar_visible(key, visible)
        %w[bartext barfill barborder].each { |part| sprites["#{key}#{part}"]&.visible = visible }
      end

      def build_bar(key, word, x, y, min, max)
        width, height, amt = 56, 6, 2
        fill_w, fill_h = width - amt, height - amt
        sprites["#{key}barborder"] = BitmapSprite.new(width, height, viewport)
        sprites["#{key}barborder"].x, sprites["#{key}barborder"].y = x, y
        sprites["#{key}barborder"].bitmap.fill_rect(Rect.new(0, 0, width, height), Color.new(32, 32, 32))
        sprites["#{key}barborder"].bitmap.fill_rect((width - fill_w) / 2, (height - fill_h) / 2, fill_w, fill_h, Color.new(96, 96, 96))
        sprites["#{key}barfill"] = BitmapSprite.new(fill_w, fill_h, viewport)
        sprites["#{key}barfill"].x = sprites["#{key}barborder"].x + amt / 2
        sprites["#{key}barfill"].y = sprites["#{key}barborder"].y + amt / 2
        minmax = min != "" && max != "" ? ": #{min}/#{max}" : ""
        create_text3("#{key}bartext", "#{word}#{minmax}", sprites["#{key}barborder"].x - 16, sprites["#{key}barborder"].y + 20, MessageConfig::LIGHT_TEXT_MAIN_COLOR, nil, 11)
      end

      def update_bar(key, word, min, max)
        colors = fill_bar_bitmap(key, min, max)
        sprites["#{key}bartext"]&.setTextToFit("#{word}: #{min}/#{max}")
        colors
      end

      # The bitmap-fill half of update_bar, split out so the Bag station's
      # player stat bars (which have their own text/color rules - see
      # stations/bag.rb) can reuse the drawing logic without inheriting
      # update_bar's "always show numbers" behavior.
      def fill_bar_bitmap(key, min, max, saturation_sensitive = false)
        fill = sprites["#{key}barfill"]
        fill.bitmap.clear
        fill_amount = (min.zero? || max.zero?) ? 0 : min * fill.bitmap.width / max
        colors = bar_colors(min, max)
        colors = bar_colors_alt(min, max) if saturation_sensitive && $player.playersaturation > 0
        if fill_amount > 0
          fill.bitmap.fill_rect(Rect.new(0, 0, fill_amount, 2), colors)
          fill.bitmap.fill_rect(Rect.new(0, 2, fill_amount, fill.bitmap.height - 2), colors)
        end
        colors
      end

      def bar_colors(value, maxvalue)
        quarter, half = maxvalue / 4.0, maxvalue / 2.0
        return Color.new(139, 0, 0) if value < 1
        return Color.new(255, 55, 55) if value < quarter
        return Color.new(255, 125, 55) if value < half
        return Color.new(255, 255, 55) if value < half + quarter

        Color.new(55, 255, 55)
      end
	  
      # Matches the original's CurrentColorsAlt - a fixed color used for
      # the food/water bars specifically while the player has active
      # saturation, regardless of the actual value.
      def bar_colors_alt(_value, _maxvalue) = Color.new(152, 208, 248)
	  
      # ---- pokemon-held-item inventory panel ------------------------

      def build_pokemon_inventory_panel
        sprites["pkmn_inventory"] = IconSprite.new(0, 0, viewport)
        sprites["pkmn_inventory"].x = sprites["pkmnside"].x + 8
        sprites["pkmn_inventory"].y = sprites["pkmnside"].y + sprites["pkmnside"].height + 2
        sprites["pkmn_inventory"].setBitmap("Graphics/Pictures/craftingMenu/pokemoninventory")
        sprites["pkmn_inventory"].z = 0
        sprites["pkmn_inventory"].visible = false

        3.times do |i|
          col = i % 3
          sprites["pkmn_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["pkmn_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["pkmn_slots#{i}"].z = 70
          sprites["pkmn_slots#{i}"].x = sprites["pkmn_inventory"].x + 10 + col * BaseStation::SLOT_SIZE
          sprites["pkmn_slots#{i}"].y = sprites["pkmn_inventory"].y + 9
          sprites["pkmn_slots#{i}"].visible = false

          sprites["pkmn_slots_star#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["pkmn_slots_star#{i}"].setBitmap("Graphics/Pictures/craftingMenu/star")
          sprites["pkmn_slots_star#{i}"].z = 70
          sprites["pkmn_slots_star#{i}"].x = sprites["pkmn_slots#{i}"].x + 26
          sprites["pkmn_slots_star#{i}"].y = sprites["pkmn_slots#{i}"].y + 2
          sprites["pkmn_slots_star#{i}"].visible = false
          sprites["pkmn_slots_qstar#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["pkmn_slots_qstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/redstar")
          sprites["pkmn_slots_qstar#{i}"].z = 9999
          sprites["pkmn_slots_qstar#{i}"].x = sprites["pkmn_slots#{i}"].x + 26
          sprites["pkmn_slots_qstar#{i}"].y = sprites["pkmn_slots#{i}"].y + 2
          sprites["pkmn_slots_qstar#{i}"].visible = false
        end
      end

      def render_pokemon_inventory?  = !pokemon_inventory.nil?

      def refresh_pokemon_inventory
        icons.each { |key, icon| remove(icon) if key.to_s.end_with?("_invimage") || key.to_s.end_with?("_invtext") }
        icons.delete_if { |key, _| key.to_s.end_with?("_invimage") || key.to_s.end_with?("_invtext") }
        visible = render_pokemon_inventory?
        sprites["pkmn_inventory"].visible = visible
        3.times { |i| sprites["pkmn_slots#{i}"].visible = visible }
        return unless visible

        pokemon_inventory.each_with_index do |slot, index|
          next if slot.nil?

          item, amt = slot
          sprites["pkmn_slots_star#{index}"].visible = $bag.registered?(item)
          render_slot_icon(:pokemon_inventory, index, item, amt)
        end
      end

      def open_pokemon_inventory
        return if grabbed_item
         kind = nil
        if pokemon_index = hit_pokemon_index
         pkmn = party[pokemon_index]
         kind = :party 
		elsif (pokemon_index = crafting_slot_from_mouse).is_a?(Integer) && craft_slots_hold_pokemon?
         pkmn = pokemon_box[pokemon_index]
         kind = :box 
		else
		 return 
		end
        if pkmn && !pkmn.egg?
          pbPlayDecisionSE
          if render_pokemon_inventory? && current_pokemon_for_inventory == pkmn
            close_pokemon_inventory
          else
            self.pokemon_inventory = pkmn.inventory
            self.current_pokemon_for_inventory = pkmn
            self.current_pokemon_for_inventory_slot = [kind, pokemon_index]
          end
        elsif render_pokemon_inventory?
          pbPlayCancelSE
          close_pokemon_inventory
        end
        refresh_pokemon_inventory
      end

      def close_pokemon_inventory
        current_pokemon_for_inventory.inventory = pokemon_inventory if current_pokemon_for_inventory && !current_pokemon_for_inventory.egg?
        self.pokemon_inventory = nil
        self.current_pokemon_for_inventory = nil
        self.current_pokemon_for_inventory_slot = nil
      end

      def save_party_and_equipment
        $player.party = party.compact
        close_pokemon_inventory if current_pokemon_for_inventory
      end

      # ---- pokemon icon rendering -----------------------------------

      def render_pokemon_icon(kind, index, pokemon)
        image_key = icon_key(kind, index, :image)
        remove(icons[image_key]) if icons[image_key]
		position = :craft 
		position = :adventure_party if kind == :adventure_party
        slot_x, slot_y = kind == :party ? sprite_xy(sprites["#{index}_slotimagepkmn"]) : slot_position(position, index)
        icons[image_key] = PokemonIconSprite.new(pokemon, viewport)
        icons[image_key].zoom_x = icons[image_key].zoom_y = 0.5
        icons[image_key].z = kind == :party ? 1 : -1
        scaled_w = icons[image_key].width * icons[image_key].zoom_x
        scaled_h = icons[image_key].height * icons[image_key].zoom_y
        icons[image_key].x = slot_x + (BaseStation::SLOT_SIZE - scaled_w) / 2
        icons[image_key].y = slot_y + (BaseStation::SLOT_SIZE - scaled_h) / 2
        icons[image_key].opacity = matches_search?(pokemon) ? 255 : SEARCH_DIM_OPACITY
        icons[image_key]
      end



	  def reserved_for_egg?(kind, index)
	    kind == :pokemon_slot && index == 0 && event_data.is_a?(PetBedData) && event_data.reserved_for_egg
	  end 
	  def bee_comb?(kind, index)
	    kind == :pokemon_slot && [2,3,4,5,6,7,8,9,10,11].include?(index) && event_data.is_a?(BeehiveData)
	  end 
	  def can_place_in_queen_slot?(kind, index)
        return true unless event_data.is_a?(BeehiveData)
        return true unless kind == :pokemon_slot && [0].include?(index)
	    return false unless grabbed_item
	    pkmn = grabbed_item.item
		evolutions = pkmn.species_data.get_evolutions
	    pkmn.bee? && pkmn.female? && evolutions.empty?
	  end 
	  def can_place_in_breeder_slot?(kind, index)
        return true unless event_data.is_a?(BeehiveData)
        return true unless kind == :pokemon_slot && [1].include?(index)
	    return false unless grabbed_item
	    pkmn = grabbed_item.item
	    pkmn.bee? && pkmn.male?
	  end 
	  
	  def filled_grave?(kind, index)
	    kind == :pokemon_slot && index == 0 && event_data.is_a?(CraftingStationData) && background_key == "GRAVE" && !event_data.result_slot.nil?
	  end 
	  def alive_in_grave?(kind, index)
	    kind == :pokemon_slot && index == 0 && event_data.is_a?(CraftingStationData) && background_key == "GRAVE" && grabbed_item.pokemon? && !grabbed_item.item.dead?
	  end 
	  
	  def can_drop_pokemon?(kind, index)
	    return false if reserved_for_egg?(kind, index)
		return false if bee_comb?(kind, index)
		return false if filled_grave?(kind, index)
		return false if alive_in_grave?(kind, index)
        return false unless can_place_in_queen_slot?(kind, index)
        return false unless can_place_in_breeder_slot?(kind, index)
		
		return true 
	  end 
	  
      # ---- shared pokemon pick-up/place/swap, used by the party
      # sidebar AND PkmnCrate's box grid --------------------------------

      def handle_pokemon_click(kind, store, index)
        if grabbed_item.nil?
          pkmn = store[index]
          return unless pkmn

          icon = icons[icon_key(kind, index, :image)]
		  pkmn2 = pkmn.is_a?(Array) ? pkmn : [pkmn, 1]
          self.grabbed_item = GrabbedItem.new(icon:, stack: pkmn2, index:, source: kind, store: store)
		  on_pokemon_removed(kind, index, pkmn)
		  if pkmn.is_a?(Array) && pkmn[0].is_a?(ItemData)
		   switch_tab_to_item_pocket(pkmn[0])
		  end 
        elsif grabbed_item.pokemon?
		 if can_drop_pokemon?(kind, index)
          handle_pokemon_drop(kind, store, index) 
		 elsif reserved_for_egg?(kind, index)
		  sideDisplay(_INTL("You have a feeling you shouldn't put something there."))
		 end 
		elsif grabbed_item.item?
		 if can_drop?(kind, index)
          handle_pokemon_drop(kind, store, index) 
		 elsif reserved_for_egg?(kind, index)
		  sideDisplay(_INTL("You have a feeling you shouldn't put something there."))
		 end 
        else
          use_item_on_slot_pokemon(store[index])
        end
      end

      def handle_pokemon_drop(kind, store, index)
        target = store[index]
        if target.nil?
          clear_pokemon_source
          store[index] = grabbed_item.item
          remove(grabbed_item.icon)
          render_pokemon_icon(kind, index, grabbed_item.item)
          self.grabbed_item = nil
		  on_pokemon_placed(kind, index, store[index])
        elsif target == grabbed_item.item
          remove(grabbed_item.icon)
          render_pokemon_icon(kind, index, target)
          self.grabbed_item = nil
		  on_pokemon_placed(kind, index, target)
        else
          clear_pokemon_source
          remove(grabbed_item.icon)
          incoming = grabbed_item.item
          store[index] = incoming
          render_pokemon_icon(kind, index, incoming)
          held_icon = render_pokemon_icon(:held, "held", target)
          self.grabbed_item = GrabbedItem.new(icon: held_icon, stack: [target, 1], index: "held", source: :held)
		  on_pokemon_placed(kind, index, incoming)
		  on_pokemon_removed(kind, index, target)
        end
      end

      def clear_pokemon_source
        return if grabbed_item.index == "held"

        source_store = grabbed_item.source == :party ? party : backing_store_for_pokemon(grabbed_item.source)
        source_store[grabbed_item.index] = nil
      end

      # PkmnCrate is the only other pokemon-holding store today; extend
      # this if another one shows up.
      def backing_store_for_pokemon(kind)
        kind == :party ? party : pokemon_box
      end

      def use_item_on_slot_pokemon(pkmn)
        return unless pkmn && pkmn.is_a?(Pokemon)

        item = grabbed_item.item
		item = item[0] if item.is_a?(Array)
        itm = GameData::Item.get(item)
        return if pkmn.hyper_mode && !itm&.is_scent?
        return unless pbCanUseOnPokemon?(itm)

        if itm.is_machine?
          return if pkmn.hasMove?(itm.move) || !pkmn.compatible_with_move?(itm.move)
        end
        use_item_on_pokemon(pkmn)
      end

      # Ported close to verbatim from the original - this is the
      # "use this held item on this specific Pokemon" flow (TMs, potions,
      # etc.), distinct from use_item (the bag right-click command menu).
      def use_item_on_pokemon(pkmn)
        item = grabbed_item.item
        itm = GameData::Item.get(item)

        if itm.is_machine?
          machine = itm.move
          return false unless machine

          movename = GameData::Move.get(machine).name
          if pkmn.shadowPokemon?
            pbMessage(_INTL("Shadow Pokémon can't be taught any moves."))
          elsif !pkmn.compatible_with_move?(machine)
            pbMessage(_INTL("{1} can't learn {2}.", pkmn.name, movename))
          else
            pbMessage(_INTL("\\se[PC access]You booted up {1}.\1", itm.name))
            if pbConfirmMessage(_INTL("Do you want to teach {1} to {2}?", movename, pkmn.name)) && pbLearnMove(pkmn, machine, false, true)
              shrink_grabbed_by(1) if itm.consumed_after_use?
              return true
            end
          end
          return false
        end

        max_at_once = [ItemHandlers.triggerUseOnPokemonMaximum(item, pkmn), grabbed_item.qty].min
        qty = max_at_once > 1 ? pbChooseNumber(_INTL("How many {1} do you want to use?", itm.name), max_at_once) : 1
        return false if qty <= 0

        ret = ItemHandlers.triggerUseOnPokemon(item, qty, pkmn, self)
        shrink_grabbed_by(qty) if ret && itm.consumed_after_use?
        ret
      end

      # ---- mouse geometry for pokemon/held-item slots --------------------

      def pokemon_slot_hit?
        !hit_pokemon_index.nil?
      end

      def hit_pokemon_index
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        Settings::MAX_PARTY_SIZE.times do |i|
          sprite = sprites["#{i}_slotimagepkmn"]
          next unless sprite

          return i if mouse_x >= sprite.x && mouse_x < sprite.x + sprite.bitmap.width &&
                      mouse_y >= sprite.y && mouse_y < sprite.y + sprite.bitmap.height
        end
        nil
      end

      def pokemon_inventory_slot_hit?
        return nil unless render_pokemon_inventory?

        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        rel_x = mouse_x - (sprites["pkmn_inventory"].x + 10)
        rel_y = mouse_y - (sprites["pkmn_inventory"].y + 9)
        return nil if rel_x < 0 || rel_y < 0 || rel_x >= 3 * BaseStation::SLOT_SIZE || rel_y >= BaseStation::SLOT_SIZE

        rel_x / BaseStation::SLOT_SIZE
      end

      def create_text3(key, text, x, y, color = MessageConfig::DARK_TEXT_MAIN_COLOR, shadowcolor = nil, size = 14)
        sprites[key] = Window_UnformattedTextPokemon.new(text)
        s = sprites[key]
        s.contents.font.size = size
        s.refresh
        pbPrepareWindow(s)
        s.resizeToFit(text)
        s.x = x
        s.y = y - 16 - s.contents.font.size
        s.windowskin = nil
        s.baseColor = color
        s.shadowColor = shadowcolor
        s.text = text
        s.viewport = viewport
        s.z = 10
        s.visible = true
      end

def create_text_centered(key, text, x, y, color = MessageConfig::DARK_TEXT_MAIN_COLOR, shadowcolor = nil, size = 14)
  sprites[key] = Window_UnformattedTextPokemon.new(text)
  s = sprites[key]

  s.contents.font.size = size
  s.refresh
  pbPrepareWindow(s)
  s.resizeToFit(text)

  s.x = x - (s.width / 2)
  s.y = y - 16 - s.contents.font.size
  s.instance_variable_set(:@center_text_x, x)
  s.instance_variable_set(:@center_text_y, y)

  s.windowskin = nil
  s.baseColor = color
  s.shadowColor = shadowcolor
  s.text = text
  s.viewport = viewport
  s.z = 10
  s.visible = true
end

def update_text_centered(key, text)
  s = sprites[key]
  s.setTextToFit(text)
  s.x = s.instance_variable_get(:@center_text_x) - (s.width / 2)
  s.y = s.instance_variable_get(:@center_text_y) - 16 - s.contents.font.size
end 

def create_text_centered_wrapped(key, text, x, y, width,
                                 color = MessageConfig::DARK_TEXT_MAIN_COLOR,
                                 shadowcolor = nil, size = 14)
  sprites[key] = Window_UnformattedTextPokemon.new("")
  s = sprites[key]

  s.contents.font.size = size
  
  wrapped = wrap_text(text, width, s.contents)

  s.text = wrapped
  s.refresh
  pbPrepareWindow(s)

  s.resizeToFit(wrapped)

  s.x = x - (s.width / 2)
  s.y = y - 16 - s.contents.font.size
  s.instance_variable_set(:@text_width, width)
  s.instance_variable_set(:@center_text_x, x)
  s.instance_variable_set(:@center_text_y, y)

  s.windowskin = nil
  s.baseColor = color
  s.shadowColor = shadowcolor
  s.viewport = viewport
  s.z = 10
  s.visible = true
end
def wrap_text(text, width, bitmap)
  words = text.split
  lines = []
  line = ""

  words.each do |word|
    test = line.empty? ? word : "#{line} #{word}"

    if bitmap.text_size(test).width > width
      lines << line unless line.empty?
      line = word
    else
      line = test
    end
  end

  lines << line unless line.empty?
  lines.join("\n")
end
def update_text_centered_wrapped(key, text)
  s = sprites[key]
  width = s.instance_variable_get(:@text_width)

  wrapped = wrap_text(text, width, s.contents)

  s.text = wrapped
  s.refresh
  pbPrepareWindow(s)

  s.resizeToFit(wrapped)

  s.x = s.instance_variable_get(:@center_text_x) - (s.width / 2)
  s.y = s.instance_variable_get(:@center_text_y) - 16 - s.contents.font.size
end

    end
  end
end
