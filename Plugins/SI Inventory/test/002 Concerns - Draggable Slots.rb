module InventoryScene
  module Concerns
    # Generic pick-up / drop / stack / split behavior for any slot that
    # holds an [item, qty] pair - bag slots, craft grid slots, equipment
    # slots, a Pokemon's held-item inventory slots. Pokemon-holding slots
    # (party, PkmnCrate) are handled separately in PartyInteraction since
    # swapping a Pokemon is a different operation from stacking an item.
    #
    # This is what replaces the original's ~25 duplicated copies of the
    # "clear the grabbed item's icon + source slot" block, and the two
    # ~450-line left_click_item / right_click_item methods.
    module DraggableSlots
      ITEM_KINDS = %i[bag craft equipment pokemon_inventory].freeze
      CANTEEN_FILLABLE_DRINKS = %i[WATER MOOMOOMILK BERRYJUICE FRESHWATER SITRUSJUICE TEA].freeze
      CANTEEN_ID = :WATERBOTTLE
    SEARCH_DIM_OPACITY = 90

      # ---- where a kind keeps its [item, qty] pairs -------------------

      def backing_store_for(kind)
        case kind
        when :bag then current_pocket
        when :craft then craft
        when :party then party
        when :box then pokemon_box
        when :equipment then equip
        when :pokemon_inventory then pokemon_inventory
        else
          raise NotImplementedError, "#{self.class} has no backing store for #{kind.inspect}"
        end
      end

      def store_index_for(kind, index)
        kind == :equipment && index.is_a?(Integer) ? index - 100 : index
      end

      # ---- rendering ----------------------------------------------------

      def icon_key(source, index, part)
        gi = GrabbedItem.allocate # cheap way to reuse the suffix logic without a full stack
        gi.instance_variable_set(:@source, source)
        suffix = part == :text ? gi.text_icon_suffix : gi.image_icon_suffix
        "#{index}#{suffix}"
      end

      def slot_position(kind, index)
        case kind
        when :bag then sprite_xy(sprites["slots#{index}"])
        when :craft, :equipment then sprite_xy(sprites["craft_slots#{index}"])
        when :pokemon_inventory then sprite_xy(sprites["pkmn_slots#{index}"])
        when :result then s = sprites["craft_slots_result"]; s ? [s.x + 8, s.y + 8] : [0, 0]
        else [-128, -128]
        end
      end

      def sprite_xy(sprite) = sprite ? [sprite.x, sprite.y] : [-128, -128]

      def render_slot_icon(kind, index, item, amt)
        image_key = icon_key(kind, index, :image)
        text_key  = icon_key(kind, index, :text)
        slot_x, slot_y = slot_position(kind, index)
		
        # Always dispose whatever was already at this key first. Every
        # caller used to assume the slot was empty before rendering into
        # it - true for a plain drop onto an empty slot, but false for a
        # swap (the destination slot already has an icon+text pair for
        # the item being swapped OUT) or for re-rendering an occupied
        # slot in general. Without this, the old sprite just gets
        # overwritten in the hash and orphaned on screen - a ghost icon
        # that nothing ever disposes again.
        remove(icons[image_key])
        remove(icons[text_key])
		
        icons[image_key] = IconSprite.new(0, 0, viewport)
        icons[image_key].visible = false 
        icons[image_key].bitmap = resize_item_for_slot(item)
        icons[image_key].z = 98
        icons[image_key].x = slot_x + (SLOT_SIZE - icons[image_key].bitmap.width) / 2
        icons[image_key].y = slot_y + (SLOT_SIZE - icons[image_key].bitmap.height) / 2
        icons[image_key].opacity = matches_search?(item) ? 255 : SEARCH_DIM_OPACITY


        text = amt.to_i > 1 ? amt.to_s : ""
        icons[text_key] = Window_UnformattedTextPokemon.new(text)
        icons[text_key].visible = false 
        icons[text_key].contents.font.size = 18
        icons[text_key].refresh
        pbPrepareWindow(icons[text_key])
        icons[text_key].resizeToFit(text)
        usable_width = icons[image_key].width - 12
        center_x = icons[image_key].x + 18 + usable_width / 2
        icons[text_key].x = center_x - icons[text_key].width / 2
        icons[text_key].y = slot_y + 18 - icons[text_key].contents.font.size
        icons[text_key].windowskin = nil
        icons[text_key].baseColor = Color.new(248, 248, 248)
        icons[text_key].shadowColor = Color.new(0, 0, 0)
        icons[text_key].text = text
        icons[text_key].viewport = viewport
        icons[text_key].z = 98
        icons[image_key].visible = true 
        icons[text_key].visible = true
        update_star_visibility(kind, index, item)
        [icons[image_key], icons[text_key]]
      end

      def update_slot_text(kind, index, amt)
        key = icon_key(kind, index, :text)
        icons[key].text = amt.to_i > 1 ? amt.to_s : "" if icons[key]
      end

      def remove_slot_icon(kind, index)
        remove(icons[icon_key(kind, index, :image)])
        remove(icons[icon_key(kind, index, :text)])
        update_star_visibility(kind, index, nil)
      end

      # Diffs a slot's CURRENT backing-store contents against what was
      # last actually rendered there, and refreshes only if they differ.
      # Every other slot update in this file happens in direct reaction
      # to a player click - nothing watches for a slot changing for any
      # OTHER reason (a station's event_data mutating its own persistent
      # storage in the background, e.g. Grinder's internal_storage). This
      # is that watcher, meant to be called once a frame (from a
      # station's own station_update) for whatever range of indices that
      # station's backing store spans.
      #
      # Skips whatever slot the player is CURRENTLY holding an item from
      # (grabbed_item still aliased to it) - that slot's on-screen icon
      # IS grabbed_item.icon, the one actively following the mouse. Diff-
      # refreshing it here would dispose the exact sprite the drag is
      # tracking out from under it.
      def sync_slot_visuals!(kind, index)
        return if grabbed_item && grabbed_item.from_fixed_slot? && grabbed_item.source == kind && grabbed_item.index == index

        store = backing_store_for(kind)
        slot = store[store_index_for(kind, index)]
        snapshot = (@slot_visual_snapshot ||= {})
        key = "#{kind}:#{index}"
        last = snapshot[key]

        current_item = slot ? slot[0] : nil
        current_qty  = slot ? slot[1] : nil

        if current_item.nil?
          remove_slot_icon(kind, index) unless last.nil?
        elsif last.nil? || !same_visual_item?(last[0], current_item)
          render_slot_icon(kind, index, current_item, current_qty)
        elsif last[1] != current_qty
          update_slot_text(kind, index, current_qty)
        end

        snapshot[key] = slot ? [current_item, current_qty] : nil
      end

      def sync_slots_visuals!(kind, range)
        range.each { |i| sync_slot_visuals!(kind, i) }
      end

      def same_visual_item?(a, b)
        return a.equal?(b) unless a.respond_to?(:identical) && b.respond_to?(:identical)

        a.identical(b)
      end


      # ---- search (dims non-matching icons in place, positions never
      # move) ---------------------------------------------------------
 
      def matches_search?(item)
        return true if search_query.empty?
        return true unless item.respond_to?(:name)
 
        item.name.downcase.include?(search_query.downcase)
      end
 
      # Called whenever the query changes to re-dim everything already on
      # screen. Walks the actual backing arrays (not the icon hash) since
      # we already know the item at each index there - covers the bag
      # grid fully live, and covers craft-slot storage (ItemCrate/Icebox)
      # too, though craft slots on ordinary recipe stations rarely have
      # enough items in them for this to matter.
      def reapply_search_dim
        current_pocket.each_with_index { |slot, i| apply_item_dim(:bag, i, slot) } if has_bag_grid?
 
        if craft_slots_hold_pokemon?
          # pokemon_box may be a plain Array (PkmnCrate) or a proxy
          # object (Pet Bed) that only guarantees []/length, not
          # Enumerable - hence index-based iteration rather than
          # each_with_index here.
          box = pokemon_box
          box.length.times { |i| apply_pokemon_dim(:craft, i, box[i]) }
        else
          craft.each_with_index { |slot, i| apply_item_dim(:craft, i, slot) }
        end
 
        party.each_with_index { |pkmn, i| apply_pokemon_dim(:party, i, pkmn) } if has_party_sidebar?
      end

 
      def apply_item_dim(kind, index, slot)
        return unless slot
 
        item, = slot
        opacity = matches_search?(item) ? 255 : SEARCH_DIM_OPACITY
        img = icons[icon_key(kind, index, :image)]
        txt = icons[icon_key(kind, index, :text)]
        img.opacity = opacity if img && !img.disposed?
        txt.contents_opacity = opacity if txt && !txt.disposed?

      end
      def apply_pokemon_dim(kind, index, pokemon)
        return unless pokemon
 
        img = icons[icon_key(kind, index, :image)]
        img.opacity = matches_search?(pokemon) ? 255 : SEARCH_DIM_OPACITY if img && !img.disposed?
      end

      # GUESS, please confirm/replace: I don't know how your project
      # captures free text from the player. This uses pbMessageFreeText
      # (the same on-screen-keyboard flow common to Essentials name-entry
      # screens) as the safest universally-available default - confirm
      # to apply the whole string at once, not truly live per-keystroke.
      # If your build supports live keystroke capture instead, that can
      # replace this method entirely; matches_search?/reapply_search_dim
      # don't care how the string arrives, only that search_query= gets
      # called with it.
      def open_search_prompt
        return unless shows_search_ui?
        toggle_legend
        result = pbMessageFreeText(_INTL("Search for an item..."), search_query, false, 20)
		toggle_legend
        self.search_query = result if result
      end


      def resize_item_for_slot(item)
        path = GameData::Item.icon_filename(item)
        parts = path.split("/", 3)
        dir = "#{parts[0..1].join('/')}/"
        original = RPG::Cache.load_bitmap(dir, parts[2])
        resized = Bitmap.new(32, 32)
        src_w = [original.width, 48].min
        src_h = [original.height, 48].min
        resized.stretch_blt(Rect.new(0, 0, 32, 32), original, Rect.new(0, 0, src_w, src_h))
        resized
      end

      # ---- grabbing / releasing -----------------------------------------
      
	  def can_drop?(kind, index)
	    return false if kind == :craft && index == extra_slot_index && bonus_slot_function==:READ
	    return false if kind == :craft && index == extra_slot_index && background_key == "WARDINGTOTEM" && ![:REPEL, :SUPERREPEL, :MAXREPEL].include?(slot[0].id)
	    return true 
	  end 
	  def can_pickup?(kind, index)
	    return false if kind == :craft && index == extra_slot_index && bonus_slot_function==:WRITE
	    return true 
	  end 
	  
      def pick_up(kind, index)
	    return unless can_pickup?(kind, index)
        store = backing_store_for(kind)
        slot_item = store[store_index_for(kind, index)]

        return unless slot_item

        icon = icons[icon_key(kind, index, :image)]
        return unless icon

        self.grabbed_item = GrabbedItem.new(icon:, stack: slot_item, index:, source: kind, store: store)
      end

      def pick_up_half(kind, index)
	    return unless can_pickup?(kind, index)
        store = backing_store_for(kind)
        slot_item = store[store_index_for(kind, index)]

        return unless slot_item

        item, amt = slot_item
        if amt > 1
          taken = (amt / 2.0).ceil
          slot_item[1] -= taken
          update_slot_text(kind, index, slot_item[1])
          held_icon, = render_slot_icon(:held, "held", item, taken)
          self.grabbed_item = GrabbedItem.new(icon: held_icon, stack: [item, taken], index: "held", source: :held)
        else
          pick_up(kind, index)
        end
      end

      # The consolidated replacement for the original's repeated cleanup
      # block: dispose the grabbed item's icon pair and, unless it's a
      # split-off "held" stack (which was never in a backing array to
      # begin with), clear the slot it came from.
      def release_grabbed_item
        return unless grabbed_item

        remove(grabbed_item.icon)
        remove(icons[icon_key(grabbed_item.source, grabbed_item.index, :text)])

        if grabbed_item.from_fixed_slot?
          store = grabbed_item.store
		  if store 
          idx = store_index_for(grabbed_item.source, grabbed_item.index)
		  if store && within_bounds?(store, idx)
            store[idx] = nil
            update_star_visibility(grabbed_item.source, grabbed_item.index, nil)
		  end 
		  end
        end

        self.grabbed_item = nil
      end

      def drop_onto(kind, index)
        return unless grabbed_item && !grabbed_item.pokemon?
        return unless can_drop?(kind, index)

        store = backing_store_for(kind)
		store_idx = store_index_for(kind, index)
        existing = store[store_idx]

        if existing.nil?
          place_new_stack(store, kind, store_idx)
        elsif canteen_fillable?(existing)
          fill_canteen(existing)
        elsif existing[0].respond_to?(:identical) && existing[0].identical(grabbed_item.item)
		 
          merge_stack(kind, store_idx, existing)
        else
          swap_stack(store, kind, store_idx, existing)
        end
      end


      def canteen_fillable?(existing)
        return false unless grabbed_item
 
        drink = grabbed_item.item
        target = existing[0]
        drink_id = drink.respond_to?(:id) ? drink.id : drink
        target_id = target.respond_to?(:id) ? target.id : target
        CANTEEN_FILLABLE_DRINKS.include?(drink_id) && target_id == CANTEEN_ID
      end


      def fill_canteen(existing)
        drink = grabbed_item.item
        canteen = existing[0]
      
        bottle = drink.respond_to?(:bottle) ? drink.bottle : nil
 
        if pbFillCanteen(canteen, drink)
         $bag.add(bottle, 1) if bottle
         shrink_grabbed_by(1)
		end
      end


      def drop_one(kind, index)
        return unless grabbed_item && !grabbed_item.pokemon?
        return unless can_drop?(kind, index)

        store = backing_store_for(kind)
        store_idx = store_index_for(kind, index)
        existing = store[store_idx]

        if existing.nil?
          store[index] = [grabbed_item.item, 1]
          render_slot_icon(kind, index, grabbed_item.item, 1)
          shrink_grabbed_by(1)
        elsif existing[0].respond_to?(:identical) && existing[0].identical(grabbed_item.item) && existing[1] < existing[0].stack_size
          existing[1] += 1
          update_slot_text(kind, index, existing[1])
          shrink_grabbed_by(1)
        end
      end
      
	  def drop_merge(kind, index)
        return unless grabbed_item && !grabbed_item.pokemon?
        return unless can_drop?(kind, index)

        store = backing_store_for(kind)
        store_idx = store_index_for(kind, index)
        existing = store[store_idx]

        if existing.nil?
          store[index] = [grabbed_item.item, 1]
          render_slot_icon(kind, index, grabbed_item.item, 1)
          shrink_grabbed_by(1)
        elsif existing[0].respond_to?(:identical) && existing[0].identical(grabbed_item.item) && existing[1] < existing[0].stack_size
		 if existing[1]==1
		  put_back_grabbed_item
		 else
          existing[1] += 1
          update_slot_text(kind, index, existing[1])
          shrink_grabbed_by(1)
		 end 
        end
	  
	  
	  end 
	  
      # ---- click routing --------------------------------------------

      def handle_left_click(kind, index)
        if grabbed_item.nil?
          pick_up(kind, index)
		  update_selected_tab(kind, index)
        elsif grabbed_item.from_fixed_slot? && grabbed_item.source == kind && grabbed_item.index == index
          merge_grabbed_item(kind, index) # clicked the exact slot you picked up from - it never left, so just re-settle it
        else
          drop_onto(kind, index)
        end
      end

      def handle_right_click(kind, index)
        if grabbed_item.nil?
          pick_up_half(kind, index)
		  update_selected_tab(kind, index)
        elsif grabbed_item.from_fixed_slot? && grabbed_item.source == kind && grabbed_item.index == index
          drop_merge(kind, index)
        else
          drop_one(kind, index)
        end
      end
      
      def qstar_sprite_key(kind, index)
        kind == :bag ? "slots_qstar#{index}" : "craft_slots_qstar#{index}"
      end
      def star_sprite_key(kind, index)
        kind == :bag ? "slots_star#{index}" : "craft_slots_star#{index}"
      end
 
      def update_star_visibility(kind, index, item)
        key = star_sprite_key(kind, index)
        sprites[key].visible = item ? $bag.registered?(item) : false if sprites[key]
        key = qstar_sprite_key(kind, index)
        sprites[key].visible = item ? quick_access_identical?(item) : false if sprites[key]
      end
	  
 
      # Pulls every OTHER stack of the same item in `store` into the
      # currently-grabbed one, up to stack_size, excluding the slot the
      # grab itself came from. Puts the grabbed item back where it
      # started if nothing else matches - there's nothing to do, so the
      # gesture just cancels cleanly rather than leaving it floating.
      def merge_grabbed_item(kind, index)
        return unless grabbed_item && !grabbed_item.pokemon?
        return unless can_drop?(kind, index)
        store = backing_store_for(kind)
        identical = store.each_with_index.filter_map do |slot, i|
          next if i == store_index_for(kind, index)
          next unless slot
          next unless slot[0].respond_to?(:identical)
          next unless slot[0].identical(grabbed_item.item)
 
          [slot, i]
        end
 
        if identical.empty? || grabbed_item.qty >= grabbed_item.item.stack_size
          put_back_grabbed_item
          return
        end
 
        identical.each do |slot, i|
          break if grabbed_item.qty >= grabbed_item.item.stack_size
 
          space = grabbed_item.item.stack_size - grabbed_item.qty
          moved = [space, slot[1]].min
          grabbed_item.qty += moved
          slot[1] -= moved
 
          # Per-slot updates instead of a full-grid refresh -
          # refresh_bag_grid only rebuilds :bag-keyed icons, so it
          # silently did nothing for :craft-keyed ones (ItemCrate/
          # Icebox's storage IS the craft grid), leaving stale sprites
          # and stale quantity text behind for any kind other than :bag.
          if slot[1] <= 0
            store[i] = nil
            remove_slot_icon(kind, i)
            update_star_visibility(kind, i, nil)
          else
            update_slot_text(kind, i, slot[1])
            update_star_visibility(kind, i, slot[0])
          end
		  
        end
      end

      # Picking up a whole stack never actually detaches it from its slot
      # (grabbed_item.stack IS the same array as the slot's data, not a
      # copy) - that's deliberate, it's what lets a partial merge keep
      # both sides in sync for free. So "put it back" needs to do nothing
      # to the backing store, only redraw the icon in place and drop the
      # floating drag icon. This is NOT the same as release_grabbed_item,
      # which assumes the item is leaving its slot for good and clears
      # it - using that here was the bug that made putting an item back
      # in its own slot delete it.
      def put_back_grabbed_item
        return unless grabbed_item

        remove(grabbed_item.icon)
        remove(icons[icon_key(grabbed_item.source, grabbed_item.index, :text)])
		if grabbed_item.from_fixed_slot?
		 if grabbed_item.source == :party
          render_pokemon_icon(grabbed_item.source, grabbed_item.index, grabbed_item.item)
		 else
          render_slot_icon(grabbed_item.source, grabbed_item.index, *grabbed_item.stack)
		 end
		end 
        self.grabbed_item = nil
      end

  def view_item
    return if !@grabbed_item
    index = slot_from_mouse
	crafting_index = crafting_slot_from_mouse
    if !index.nil?
	  item = current_pocket[index]
	  item[0].identical_check(grabbed_item.stack[0]) if item 
	elsif !crafting_index.nil?
	  item = @craft[crafting_index]
	  item[0].identical_check(grabbed_item.stack[0]) if item 
	end 
  
  end 
  
      def process_input
        # Always reset first, unconditionally - none of this drag state
        # must survive past the button actually being released, or a
        # later unrelated click can inherit stale state from a previous
        # drag before that click's own logic has even run.
        if Input.release?(Input::MOUSELEFT) && @drag_distribute_slots
          # The button's actually up now - this is the one point where a
          # remainder of exactly 0 really does mean "done, nothing left
          # in hand," since no further slot can join the drag to change
          # it. Everywhere else (mid-drag) deliberately leaves this alone.
          if @drag_distribute_slots && grabbed_item && grabbed_item.source == :held && grabbed_item.qty <= 0
            remove(grabbed_item.icon)
            remove(icons[icon_key(grabbed_item.source, grabbed_item.index, :text)])
            self.grabbed_item = nil
          end
          @drag_distribute_slots = nil
          @drag_distribute_total = nil
          @drag_distribute_item = nil
          @drag_distribute_origin = nil
        end
        if Input.triggerex?(:O)
          puts current_pocket.inspect
          puts party.inspect
        elsif Input.triggerex?(:N)
		  puts craft.inspect if craft && !craft.empty?
		  puts pokemon_box.inspect if pokemon_box && !pokemon_box.empty?
        elsif Input.triggerex?(:Y)
	      view_item
        elsif Input.trigger?(Input::LEFT)
		  unless grabbed_item
          self.current_tab = (current_tab - 1) % Settings::BAG_MAX_POCKET_SIZE.size
          refresh_bag_grid
		  end 
        elsif Input.trigger?(Input::RIGHT)
		  unless grabbed_item
          self.current_tab = (current_tab + 1) % Settings::BAG_MAX_POCKET_SIZE.size
          refresh_bag_grid
		  end 
        elsif (Input.trigger?(Input::USE) || Input.trigger?(Input::MOUSEMIDDLE)) && !Input.trigger?(Input::MOUSELEFT)
          end_item = use_item
          if end_item
            exit!(end_item)
          else
            open_pokemon_inventory
          end
        elsif (Input.trigger?(Input::INVENTORY) || Input.trigger?(Input::BACK)) && !Input.trigger?(Input::MOUSERIGHT)
          exit!(nil) unless grabbed_item
        elsif Input.trigger?(Input::MOUSELEFT)
          if grabbed_item.nil? && Input.press?(Input::SHIFT) 
            quick_transfer_click
          else
           left_click_tab unless grabbed_item
           dispatch_click(:left)
            # Record where this drag started (nil if the click didn't end
            # up holding anything) - distribute mode only engages once
            # the mouse actually leaves this slot, not merely because the
            # button's still held over the same spot.
            @drag_distribute_slots = []
            @drag_distribute_total = nil
            @drag_distribute_item = nil
            @drag_distribute_origin = grabbed_item ? drag_paint_target_under_mouse : nil
          end
        elsif Input.press?(Input::MOUSELEFT) && @drag_distribute_slots
          continue_drag_distribute
        elsif Input.trigger?(Input::MOUSERIGHT)
          dispatch_click(:right)
        elsif Input.press?(Input::NOTEBOOK)
          pbFadeOutIn(99_999) { NoteOpen.openWindow }
        elsif Input.triggerex?(:TAB)
          toggle_favorite_under_mouse
        elsif Input.triggerex?(:F)
          toggle_quick_access_under_mouse
		  refresh_bag_grid
        elsif Input.triggerex?(:I)
          show_info_under_mouse
        elsif Input.triggerex?(:S)
          open_search_prompt

        end
      end

      # Determines what's under the cursor and routes to the right
      # handler, in the same priority order the original's giant
      # if/elsif chain used: bag slot, then party/box Pokemon slot (owned
      # by PartyInteraction), then craft/result slot, then equipment slot,
      # then held-item-inventory slot, then any other clickable object
      # (equipment toggle button, the "eat/use on self" player square).      # ---- shift-click quick transfer (bag <-> this station's craft
      # grid) - Minecraft-style: empty-handed only, moves as much of the
      # stack as fits, merging into matching stacks before using empty
      # slots, and leaves the remainder behind if it doesn't all fit.
      # Doubles as "shift-click into the container" for ItemCrate/Icebox,
      # since their storage IS the craft grid. No-ops harmlessly on
      # stations with no craft grid or whose craft slots hold Pokemon.
      def quick_transfer_click
        if (hit = slot_from_mouse)
          quick_transfer(:bag, hit[0]) if bag_slot_usable?(hit[0])
        elsif (hit = crafting_slot_from_mouse) && !craft_slots_hold_pokemon? && hit.is_a?(Integer) && hit < 100
          quick_transfer(:craft, hit)
        elsif pokemon_slot_hit? && craft_slots_hold_pokemon?
          quick_transfer_pokemon(:party, hit_pokemon_index)
        elsif (hit = crafting_slot_from_mouse) && craft_slots_hold_pokemon? && hit.is_a?(Integer)
          quick_transfer_pokemon(:box, hit)
        elsif (hit = crafting_slot_from_mouse) && !craft_slots_hold_pokemon? && hit == "_result"
          quick_craft_result!
        end
      end

      def quick_transfer_pokemon(kind, index)
        store = backing_store_for(kind)
        pokemon = store[store_index_for(kind, index)]
        return unless pokemon
        target_kind = kind == :party ? :box : :party
        moved = target_kind == :party ? distribute_into_party(pokemon) : distribute_into_crate(pokemon)
        if moved
          store[store_index_for(kind, index)] = nil
		  icon_kind = kind == :party ? :party : :pokemon_slot 
          remove_slot_icon(icon_kind, index)
        end
      end
 

      def quick_transfer(kind, index)
        store = backing_store_for(kind)
        slot_item = store[store_index_for(kind, index)]
        return unless slot_item

        item, amt = slot_item
        target_kind = :bag == other_kind ? :craft : :bag
        moved = target_kind == :bag ? distribute_into_bag(item, amt) : distribute_into_craft(item, amt)
        return if moved <= 0

        remaining = amt - moved
        if remaining <= 0
          store[store_index_for(kind, index)] = nil
          remove_slot_icon(kind, index)
        else
          slot_item[1] = remaining
          update_slot_text(kind, index, remaining)
        end

        switch_tab_to_item_pocket(item) if target_kind == :bag
      end
 

      def quick_craft_result!
        return unless result

        recipe = result.recipe
        return unless can_afford?(recipe, craft)

        item = ItemData.new(result.result[0])
        set_max_durability(item)
        apply_bottle_contents(item)
        amt = result.yield
        switch_tab_to_item_pocket(item)
        moved = distribute_into_bag(item, amt)
		refresh_bag_grid
        return if moved <= 0
        remaining = amt - moved
        if remaining <= 0
          remove_amounts(recipe)
          on_craft_consumed(recipe)
          clear_result if craft_empty_or_nil? || !can_afford?(recipe, craft)
        else
		   if grabbed_item && !grabbed_item.pokemon? && item.identical(grabbed_item.item) && grabbed_item.qty < item.stack_size
             grabbed_item.qty = [grabbed_item.qty + amt, item.stack_size].min
           else
             icon, = render_slot_icon(:crafted, "_crafted", item, amt)
            self.grabbed_item = GrabbedItem.new(icon:, stack: [item, amt], index: "_crafted", source: :craft)
           end
        end

      end

      def distribute_into_bag(item, amt)
        itm = GameData::Item.get(item)
        pocket_index = itm.pocket
        pocket_array = pockets[pocket_index]
        max_slots = Settings::BAG_MAX_POCKET_SIZE[pocket_index - 1] || pocket_array.length
        remaining = amt

        pocket_array.each do |slot|
          break if remaining <= 0
          next unless slot && slot[0].respond_to?(:identical) && slot[0].identical(item) && slot[1] < slot[0].stack_size
          space = slot[0].stack_size - slot[1]
          moved = [space, remaining].min
          slot[1] += moved
          remaining -= moved
        end

        max_slots.times do |i|
          break if remaining <= 0
          next if pocket_array[i]

          moved = [item.stack_size, remaining].min
          pocket_array[i] = [item, moved]
          remaining -= moved
        end

        amt - remaining
      end

      def distribute_into_craft(item, amt)
        remaining = amt

        slot_count.times do |i|
          break if remaining <= 0
          slot = craft[i]
          next unless slot && slot[0].respond_to?(:identical) && slot[0].identical(item) && slot[1] < slot[0].stack_size

          space = slot[0].stack_size - slot[1]
          moved = [space, remaining].min
          slot[1] += moved
          remaining -= moved
          update_slot_text(:craft, i, slot[1])
        end

        slot_count.times do |i|
          break if remaining <= 0
          next if craft[i]

          moved = [item.stack_size, remaining].min
          craft[i] = [item, moved]
          render_slot_icon(:craft, i, item, moved)
          remaining -= moved
        end

        amt - remaining
      end

      def distribute_into_crate(pokemon)
        slot_count.times do |i|
         next if pokemon_box[i]
         pokemon_box[i] = pokemon
         render_pokemon_icon(:craft, i, pokemon_box[i])
         return true
        end
       false
      end


      def distribute_into_party(pokemon)
        Settings::MAX_PARTY_SIZE.times do |i|
          next unless party[i].nil?
          party[i] = pokemon
          render_pokemon_icon(:party, i, party[i] )
          return true
        end

        false
      end

      # Minecraft-accurate: the WHOLE held amount gets divided evenly
      # across every distinct slot the drag has touched so far,
      # recomputed each time a new slot joins - not "place 1 and move
      # on," which is what this used to do. Only engages once the mouse
      # has actually left the slot the drag started on (not merely held
      # the button on the same spot), so a plain click-and-hold-still
      # never triggers it.
      def continue_drag_distribute
        target = drag_paint_target_under_mouse
        return unless target
        return if target == @drag_distribute_origin && @drag_distribute_total.nil?
        return if @drag_distribute_slots.include?(target)

        engage_distribute_mode if @drag_distribute_total.nil?
        return unless @drag_distribute_total
        return if @drag_distribute_slots.include?(target) # engage may have just claimed this exact slot as the origin

        try_add_distribute_slot(target)
      end

      # Fires exactly once per drag, the first time the mouse leaves the
      # slot it started on. Captures the full amount being distributed,
      # and - critically - fully detaches the grabbed stack from
      # whatever slot it's still aliased into (see release_grabbed_item's
      # comment for why that aliasing exists) since we're about to
      # rewrite that slot's contents ourselves as part of the split.
      # Leaving it aliased here would mean put_back_grabbed_item/
      # release_grabbed_item later assume that slot's array still holds
      # the original data when it no longer does - the exact "two things
      # silently referencing the same state" shape every bug in this
      # feature has had so far.
      def engage_distribute_mode
        return unless grabbed_item && !grabbed_item.pokemon? && grabbed_item.qty > 0

        @drag_distribute_total = grabbed_item.qty
        @drag_distribute_item = grabbed_item.item
        return unless grabbed_item.from_fixed_slot?

        origin_kind = grabbed_item.source
        origin_index = grabbed_item.index
        origin_store = grabbed_item.store
        origin_idx = store_index_for(origin_kind, origin_index)
        return unless origin_store && within_bounds?(origin_store, origin_idx)

        origin_store[origin_idx] = nil
        remove_slot_icon(origin_kind, origin_index)
        @drag_distribute_slots << [origin_kind, origin_index]

        # Re-key the grabbed stack as a plain "held" stack (same as any
        # other split/swap-off stack) now that its old slot no longer
        # holds it.
        old_icon = grabbed_item.icon
        stack = grabbed_item.stack
        remove(old_icon)
        new_icon, = render_slot_icon(:held, "held", stack[0], stack[1])
        self.grabbed_item = GrabbedItem.new(icon: new_icon, stack:, index: "held", source: :held)
      end

      def try_add_distribute_slot(target)
        kind, index = target
        store = backing_store_for(kind)
        existing = store[store_index_for(kind, index)]
        return unless existing.nil? # only spreads into EMPTY slots - merging into a partial matching stack mid-drag isn't handled here

        prospective_count = @drag_distribute_slots.length + 1
        return if (@drag_distribute_total / prospective_count).zero? # not enough left to give this slot anything without starving the others already in the split

        @drag_distribute_slots << target
        redistribute!
      end

      def redistribute!
        count = @drag_distribute_slots.length
        return if count.zero?

        per_slot = @drag_distribute_total / count
        remainder = @drag_distribute_total - (per_slot * count)

        @drag_distribute_slots.each do |(kind, index)|
          store = backing_store_for(kind)
          store[store_index_for(kind, index)] = [@drag_distribute_item, per_slot]
          render_slot_icon(kind, index, @drag_distribute_item, per_slot)
        end

        update_distribute_cursor(remainder)
      end

      # Keeps the floating "what's still in hand" icon in sync with the
      # remainder as it's recomputed. Deliberately does NOT dispose it
      # here even when the remainder hits exactly 0 - adding another
      # slot to an ongoing drag can raise it again (10 split across 2 is
      # 5/5, remainder 0; add a third and it's 3/3/3, remainder 1).
      # Finalizing only happens once the mouse is actually released -
      # see process_input's reset block.
      def update_distribute_cursor(remainder)
        if grabbed_item
          grabbed_item.qty = remainder
        elsif remainder > 0
          # Shouldn't normally happen given the above, but if the cursor
          # was ever cleared mid-drag some other way, rebuild it rather
          # than silently lose track of the remainder.
          icon, = render_slot_icon(:held, "held", @drag_distribute_item, remainder)
          self.grabbed_item = GrabbedItem.new(icon:, stack: [@drag_distribute_item, remainder], index: "held", source: :held)
        end
      end

      def drag_paint_target_under_mouse
        if (hit = slot_from_mouse) && bag_slot_usable?(hit[0])
          [:bag, hit[0]]
        elsif (hit = crafting_slot_from_mouse) && !craft_slots_hold_pokemon? && hit.is_a?(Integer) && hit < 100
          [:craft, hit]
        end
      end
      def dispatch_click(button)
        if (hit = slot_from_mouse)
          route(:bag, hit[0], button) if bag_slot_usable?(hit[0])
        elsif pokemon_slot_hit?
          # The original never wired a right-click behavior for party
          # portraits, so this is left-click only, matching that.
          handle_pokemon_click(:party, party, hit_pokemon_index) if button == :left
        elsif (hit = crafting_slot_from_mouse)
          route_craft(hit, button)
        elsif (hit = equipment_slot_from_mouse)
          route(:equipment, hit, button)
        elsif (hit = pokemon_inventory_slot_hit?)
          route(:pokemon_inventory, hit, button)
        elsif item_box_hovered?
          # Same category as player_square below - an arbitrary screen
          # region outside the slot-grid system, not something
          # slot_from_mouse/crafting_slot_from_mouse detect. Left as a
          # stub since the actual "select this item" behavior is
          # $OverworldMenu's, not this scene's, to define.
		  
           handle_item_box_drop if button == :left
        elsif (object = clicked_object?)
          handle_object_click(object)
        end
		
      end

      def route(kind, index, button)
        button == :left ? handle_left_click(kind, index) : handle_right_click(kind, index)
      end
      # Matches the original's guard on bag-slot interaction: a slot
      # rendered with the "_2" (disabled/oversized-for-this-pocket)
      # bitmap was never actually clickable, only decorative. I'd missed
      # this entirely, which is how items ended up droppable into those
      # slots.
      def bag_slot_usable?(index)
        sprites["slots#{index}"]&.name != "Graphics/Pictures/craftingMenu/placeholder_slot_2"
      end
      
	  
      def route_craft(index, button)
        if craft_slots_hold_pokemon?
          handle_pokemon_click(:pokemon_slot, pokemon_box, index) if button == :left
        elsif index == "_result"
          craft_result! if button == :left # right-click on a result does nothing, matching the original
        else
          button == :left ? handle_left_click(:craft, index) : handle_right_click(:craft, index)
          handle_station_click(:craft, index)
        end
      end

      # Overridden to true by PkmnCrate, whose craft-slot grid holds
      # Pokemon rather than items.
      def craft_slots_hold_pokemon? = false

      def clicked_object?
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        objects.each do |key, sprite|
          next unless sprite&.visible

          return key if mouse_x >= sprite.x && mouse_x < sprite.x + sprite.width &&
                        mouse_y >= sprite.y && mouse_y < sprite.y + sprite.height
        end
        nil
      end

      # ---- hover / drag-ghost / highlight -------------------------------

      def update_drag_ghost
        return unless grabbed_item

        mouse_x, mouse_y = Mouse.getMousePos
        return unless mouse_x

        icon = grabbed_item.icon
        return if icon.nil? || icon.disposed?

        text_icon = icons[icon_key(grabbed_item.source, grabbed_item.index, :text)]
        if grabbed_item.pokemon?
          icon.x = mouse_x - 10
          icon.y = mouse_y + 10 - icon.height / 2
          icon.z = 10_000
        else
          icon.x = mouse_x - icon.width / 2
          icon.y = mouse_y - icon.height / 2
          icon.z = 10_000
          if text_icon
            text_icon.x = mouse_x - icon.width / 2 + 4
            text_icon.y = mouse_y - icon.height / 2
            text_icon.z = 10_001
            text_icon.text = grabbed_item.qty > 1 ? grabbed_item.qty.to_s : ""
          end
        end
      end

      def item_hovered?
	   hit = crafting_slot_from_mouse
        if hit.is_a?(Integer)
          return pokemon_box[hit] if craft_slots_hold_pokemon? && pokemon_box[hit]
          return craft[hit] if !craft_slots_hold_pokemon? && craft[hit]
        elsif hit == "_result"
          return result.result if result
        end
        if pokemon_slot_hit?
          pkmn = party[hit_pokemon_index]
          return pkmn if pkmn
        end
        if (hit = slot_from_mouse)
          return current_pocket[hit[0]]
        end
        if (hit = equipment_slot_from_mouse)
		  hit -= 100
          return equip[hit]
        end
        nil
      end

      def update_hover_tooltip
        stack = item_hovered?
        return show_empty_tooltip if stack.nil?

        item = stack.is_a?(Array) ? stack[0] : stack
        if item.is_a?(Pokemon)
          show_pokemon_tooltip(item)
        else
          show_item_tooltip(item.is_a?(Symbol) ? ItemData.new(item) : item)
        end
      end

      def show_empty_tooltip
        tooltip.show({})
        sprites["msgwindow"].visible = false if sprites["msgwindow"].visible
        self.item_hovered = nil
      end

      def show_item_tooltip(item)
	    return if item_hovered && item_hovered.is_a?(Pokemon)
        return if (item_hovered && item_hovered.identical(item)) && sprites["cmdwindow"].visible == false
        self.item_hovered = item
        hash = { name: [item.name, 0, 0] }
        if !item.durability.nil? && !item.is_spoiling? && !item.dont_display_durability
          hash[:durability] = [item.durability, 0, 0]
          hash[:maxdurability] = [item.max_durability, 0, 0]
        end
        if GameData::BerryPlant::WATERING_CANS.include?(item.id) || (!item.water.nil? && item.id!=:GLASSBOTTLE)
          hash[:water] = [item.water, 0, 0]
          hash[:maxwater] = [100, 0, 0]
        end
        hash[:description] = [item.data.description, 0, 0]
        tooltip.show(hash)
      end

      def show_pokemon_tooltip(pokemon)
        return if item_hovered == pokemon

        self.item_hovered = pokemon
        status = pokemon_status_label(pokemon)
		gender = ""
		gender = "♂" if pokemon.male? && !pokemon.egg?
		gender = "♀" if pokemon.female? && !pokemon.egg?
        hash = { name: ["#{pokemon.name} #{gender} #{status}", 0, 0] }
        unless pokemon.egg?
          hash[:health] = [pokemon.hp, 0, 0]
          hash[:maxhealth] = [pokemon.totalhp, 0, 0]
	      thespecies = GameData::Species.get_species_form(pokemon.species, pokemon.form)
          hash[:description] = [pbPokedexEntry(thespecies), 0, 0]
        end
        tooltip.show(hash)
      end

      def pokemon_status_label(pokemon)
        return "" if pokemon.egg?
        return "[DED]" if pokemon.dead?
        return "[FNT]" if pokemon.fainted?
        return "[PKRS]" if pokemon.pokerusStage == 1
        return "" if pokemon.status == :NONE

        %w[[SLP] [PSN] [BRN] [PAR] [FRZ]][GameData::Status.get(pokemon.status).icon_position] || ""
      end
      # A single priority chain, same order the original checked in: bag
      # slot, then craft/equipment/result slot, then party portrait, then
      # held-item-inventory slot, else nothing. My first pass split this
      # into two independent methods that both ran every frame - besides
      # dropping the party/pokemon-inventory cases entirely, running them
      # independently meant one could stomp the other's visibility change
      # instead of there being one clear "what's under the mouse right
      # now" answer.
      def update_highlight
        update_open_inventory_highlight

        hit = slot_from_mouse
        if hit
          highlight_bag_slot(hit[0])
        elsif (hit = crafting_slot_from_mouse)
          highlight_craft_slot(hit)
        elsif (hit = equipment_slot_from_mouse)
          highlight_equipment_slot(hit)
        elsif pokemon_slot_hit?
          highlight_pokemon_slot
        elsif (hit = pokemon_inventory_slot_hit?)
          highlight_pokemon_inventory_slot(hit)
        else
          sprites["highlight"].visible = false
        end
      end

      def highlight_bag_slot(index)
        icon = sprites["slots#{index}"]
        return sprites["highlight"].visible = false unless icon

        if bag_slot_usable?(index)
          sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
          sprites["highlight"].x, sprites["highlight"].y = icon.x, icon.y
          sprites["highlight"].visible = true
        else
          sprites["highlight"].visible = false
        end
      end

      def highlight_craft_slot(index)
        if index == "_result"
          icon = sprites["craft_slots_result"]
          return sprites["highlight"].visible = false unless icon && !hides_result_highlight?

          sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight2")
          sprites["highlight"].x, sprites["highlight"].y = icon.x, icon.y
          sprites["highlight"].visible = true
        else
          icon = sprites["craft_slots#{index}"]
          return sprites["highlight"].visible = false unless icon

          sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
          sprites["highlight"].x, sprites["highlight"].y = icon.x, icon.y
          sprites["highlight"].visible = true
        end
      end
      def highlight_equipment_slot(index)
          icon = sprites["craft_slots#{index}"]
          return sprites["highlight"].visible = false unless icon && @buttons["equipment_button"]
          sprites["highlight"].x, sprites["highlight"].y = icon.x, icon.y
          sprites["highlight"].visible = true
      end

      def highlight_pokemon_slot
        icon = sprites["#{hit_pokemon_index}_slotimagepkmn"]
        return sprites["highlight"].visible = false unless icon

        sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
        sprites["highlight"].x, sprites["highlight"].y = icon.x, icon.y
        sprites["highlight"].visible = true
      end

      def highlight_pokemon_inventory_slot(index)
        icon = sprites["pkmn_slots#{index}"]
        return sprites["highlight"].visible = false unless icon

        sprites["highlight"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
        sprites["highlight"].x, sprites["highlight"].y = icon.x, icon.y
        sprites["highlight"].visible = true
      end

      # The persistent (non-hover) marker showing which party member's
      # held-item inventory is currently open - independent of the mouse.
      def update_open_inventory_highlight
        icon = nil 
	    if render_pokemon_inventory?
		  kind, index = current_pokemon_for_inventory_slot
         icon = kind == :party ? sprites["#{index}_slotimagepkmn"] : sprites["craft_slots#{index}"]
		end 
		
		
        if icon&.visible
          sprites["highlight2"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot_highlight")
          sprites["highlight2"].x, sprites["highlight2"].y = icon.x, icon.y
          sprites["highlight2"].visible = true
        else
          sprites["highlight2"].visible = false
        end
      end

      # Some recipe stations never show a highlight on their result slot
      # at all in the original (the crafted item there isn't "grabbable"
      # the same way - APRICORNCRAFTING/APRICORNMACHINE/CAULDRON/
      # MEDICINEPOT). Default false everywhere else.
      def hides_result_highlight? = false

      # Used by PartyInteraction too (e.g. using up a held item on a
      # Pokemon), so this stays public rather than tucked under `private`.
      def shrink_grabbed_by(n)
        grabbed_item.qty -= n
        release_grabbed_item if grabbed_item.qty <= 0
      end

      private

      def place_new_stack(store, kind, index)
        item, amt = grabbed_item.stack
        store[index] = [item, amt]
		index += 100 if kind == :equipment
        render_slot_icon(kind, index, item, amt)
        release_grabbed_item
      end

      def merge_stack(kind, index, existing)
        item, amt = existing
        return if amt >= item.stack_size

        moved = [grabbed_item.qty, item.stack_size - amt].min
        existing[1] += moved
        grabbed_item.qty -= moved
        update_slot_text(kind, index, existing[1])
        release_grabbed_item if grabbed_item.qty <= 0
      end

      def swap_stack(store, kind, index, existing)
        remove(grabbed_item.icon)
        remove(icons[icon_key(grabbed_item.source, grabbed_item.index, :text)])

        # Fresh array for the destination, and explicitly clear the slot
        # this item is leaving - it used to just assign grabbed_item.stack
        # (the SAME array object still referenced by its origin slot)
        # straight into the destination, so after a swap two slots ended
        # up pointing at one array. The next interaction with either one
        # would silently duplicate the item.
        incoming = [grabbed_item.item, grabbed_item.qty]
        outgoing = existing.dup

        if grabbed_item.from_fixed_slot?
          origin_store = grabbed_item.store
          origin_store[grabbed_item.index] = nil if within_bounds?(origin_store, grabbed_item.index)
          if origin_store && within_bounds?(origin_store, grabbed_item.index)
            origin_store[grabbed_item.index] = nil
            update_star_visibility(grabbed_item.source, grabbed_item.index, nil)
          end
        end

        store[index] = incoming
        render_slot_icon(kind, index, *incoming)

        held_icon, = render_slot_icon(:held, "held", outgoing[0], outgoing[1])
        self.grabbed_item = GrabbedItem.new(icon: held_icon, stack: outgoing, index: "held", source: :held)
      end


      def within_bounds?(store, index)
        index.is_a?(Integer) && index >= 0 && index < store.length
      end
    end
  end
end
