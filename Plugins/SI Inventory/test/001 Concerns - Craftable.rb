module InventoryScene
  module Concerns
    # Mixed into every station with a recipe grid feeding a result slot.
    # get_recipe/can_afford?/remove_amounts are a straight behavioral port
    # of the original; update_result_slot and craft_result! consolidate
    # what used to be duplicated inline in `update` and in both
    # left_click_item/right_click_item's "_result" branches.
    module Craftable
      BOTTLE_ITEMS = %i[
        BOWL GLASSBOTTLE SOUPBROTH WATER FRESHWATER WEAKPOTION
        POTION SUPERPOTION HYPERPOTION MAXPOTION FULLRESTORE HPUP PPUP
        CARBOS PROTEIN IRON CALCIUM ZINC REPEL SUPERREPEL MAXREPEL ETHER
        MAXETHER ELIXIR MAXELIXIR
      ].freeze
      CONTAINER_ITEMS = %i[BOWL GLASSBOTTLE].freeze

      def crafting_data
        @crafting_data ||= GameData::Recipe::DATA.values.select do |recipe|
          recipe.station.include?(recipe_station_key) && (!recipe.locked || $recipe_book.unlocked?(recipe.id))
        end
      end

      # Default: the station's own class-ish key. Bag overrides this to
      # :POCKET (the original special-cased `@type=="Inventory" ? :POCKET
      # : @type`); every other station's key matches its background_key.
      def recipe_station_key = background_key.to_sym

      # Furnace overrides this to exclude the fuel slot (craft[1]) from
      # recipe matching - everyone else matches against the whole grid.
      def recipe_matching_slots = craft

      def craft_empty_or_nil?
        craft.empty? || craft.all?(&:nil?)
      end

      def normalize_ingredients(list)
        return [] if list.nil?

        list.filter_map do |entry|
          next if entry.nil?

          item, qty = entry.is_a?(Array) ? entry : [entry, 1]
          item = item.id if item.is_a?(ItemData)
          [item, qty || 1]
        end.sort_by { |item, qty| [item.to_s, qty] }
      end

      def get_recipe(ingredients)
        inventory = normalize_ingredients(ingredients)

        crafting_data.select do |recipe|
          required = normalize_ingredients(recipe.recipe)
          required = required.reject { |item, _| item == :MACHINEBOX } if $player.is_it_this_class?(:ENGINEER, false)

          next false unless inventory.map(&:first).sort == required.map(&:first).sort
          next false unless inventory.size == required.size

          remaining = inventory.map(&:dup)
          required.all? do |req_item, req_qty|
            idx = remaining.index { |inv_item, inv_qty| inv_item == req_item && inv_qty >= req_qty }
            next false unless idx

            remaining.delete_at(idx)
            true
          end
        end
      end

      def can_afford?(recipe, ingredients)
        return false unless station_can_afford_extra_cost?

        normalized_recipe = normalize_ingredients(recipe)
        normalized_inventory = normalize_ingredients(ingredients)

        normalized_recipe.all? do |item, qty|
          have = normalized_inventory.select { |inv_item, _| inv_item == item }.sum { |_, q| q }
          have >= qty
        end
      end

      # Stations that gate crafting on a resource (furnace fuel, grinder
      # stamina) override this; everything else is free.
      def station_can_afford_extra_cost? = true

      def remove_amounts(recipe)
        return if recipe.empty?



        recipe.each do |item, qty_needed|
          remaining = qty_needed
          next if remaining <= 0

          while remaining > 0
          taken_any = false
		  
          craft.each_with_index do |inv_item, index|
            next unless inv_item && inv_item[0].id == item && inv_item[1] > 0

            inv_item[1] -= 1
            remaining -= 1
            taken_any = true
            update_slot_text(:craft, index, inv_item[1])
            remove_slot_icon(:craft, index) if inv_item[1] <= 0
            break if remaining <= 0
          end
          break unless taken_any
		  end
        end




        craft.each_with_index { |inv_item, index| craft[index] = nil if inv_item && inv_item[1] <= 0 }
      end

      # ---- result slot -------------------------------------------------

      def update_result_slot
        if craft_empty_or_nil?
          clear_result
          return
        end

        matches = get_recipe(recipe_matching_slots)
        return clear_result if matches.empty?
        return if result == matches[0]

        self.result = matches[0]
        remove_slot_icon(:result, "_result")
        item, amt = result.result[0], result.yield
        render_slot_icon(:result, "_result", item, amt)
      end

      def clear_result
        return if result.nil?

        remove_slot_icon(:result, "_result")
        self.result = nil
      end

      # The consolidated replacement for the original's two near-identical
      # "produce the crafted item" blocks (one in left_click_item, one in
      # right_click_item's "_result" branch). Building a ready-to-drop
      # ItemData for the result, then either merging it into whatever's
      # already grabbed, or handing the player a freshly-grabbed stack.
      def craft_result!
        return unless result

        recipe = result.recipe
        return unless can_afford?(recipe, craft)

        itemdata = ItemData.new(result.result[0])
        set_max_durability(itemdata)
        apply_bottle_contents(itemdata)
        amt = result.yield

        if grabbed_item && !grabbed_item.pokemon? && itemdata.identical(grabbed_item.item) && grabbed_item.qty < itemdata.stack_size
          grabbed_item.qty = [grabbed_item.qty + amt, itemdata.stack_size].min
        else
          icon, = render_slot_icon(:crafted, "_crafted", itemdata, amt)
          self.grabbed_item = GrabbedItem.new(icon:, stack: [itemdata, amt], index: "_crafted", source: :craft)
        end

        remove_amounts(recipe)
        on_craft_consumed(recipe)
        pocket = GameData::Item.get(itemdata).pocket
        self.current_tab = pocket - 1
        refresh_bag_grid

        clear_result if craft_empty_or_nil? || !can_afford?(recipe, craft)
      end

      # NOTE: the original read `modifier_item = @craft[4]` here for
      # ApricornMachine (the 5th slot, distinct from the 4-slot recipe) but
      # never did anything further with it in the code I was given - the
      # feature reads as unfinished/dead in the source. I've left it as a
      # hook (ApricornMachine#modifier_item) rather than guessing at
      # intended behavior; flag if it's supposed to do something.
      def apply_bottle_contents(itemdata)
        bottle_entry = craft.each_with_index.find { |(item, _qty), _i| item && BOTTLE_ITEMS.include?(item.id) }
        return unless bottle_entry

        bottle_item, = bottle_entry[0]
        bottle = CONTAINER_ITEMS.include?(bottle_item.id) ? bottle_item : bottle_item.bottle
        itemdata.set_bottle(bottle) if bottle
      end

      def set_max_durability(item)
        item.max_durability = 10 if %i[WHITEFLUTE BLACKFLUTE].include?(item.id)
        item.max_durability = 25 if CONTAINER_ITEMS.include?(item.id)
        item.durability = item.max_durability
      end
    end
  end
end
