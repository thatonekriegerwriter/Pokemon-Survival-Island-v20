module InventoryScene
  module Stations
    # Fully self-contained, deliberately NOT built on GrabbedItem/
    # render_slot_icon/etc. Moves aren't items (no quantity, no
    # .identical) or Pokemon, and the pool is a non-depleting catalog -
    # picking a move doesn't remove it from what's learnable, only from
    # what's currently SHOWN (filtered live against the Pokemon's
    # current moveset, see visible_pool_moves). That's different enough
    # from every other slot-content type in this codebase that reusing
    # the shared machinery would mean bending it to fit, rather than
    # fitting it - so this builds its own small pick-up/hold/drop loop
    # instead, following the same PATTERN (not the same code) as
    # everywhere else.
    class MoveRelearner < BaseStation
      POOL_COLS = 4
      POOL_ROWS = 3
      POOL_VISIBLE = POOL_COLS * POOL_ROWS

      def background_key = "MOVERELEARNER"
      def uses_recipe_grid? = false
      def has_bag_grid? = false
      def shows_search_ui? = false
      def shows_legend? = false
      def slot_count = 0
      def finalize_container = nil

      def initialize(event_data:, container:)
        @edited_pokemon = event_data[0] if event_data # the Pokemon passed in to start editing
		@relearn_move = event_data[1] if event_data
        @grabbed_move = nil
        @move_origin_index = nil # nil = came from the pool, 0-3 = an equipped slot
        @hovered_move = nil
        @pool_scroll_offset = 0
        @relearn_move_ids = []
        refresh_relearn_list if @edited_pokemon
        super
      end

      private

      # ---- data ----------------------------------------------------

      def refresh_relearn_list
        @relearn_move_ids = relearnable_move_ids(@edited_pokemon)
        @pool_scroll_offset = 0
      end

      # Ported from the original pbGetRelearnableMoves, unchanged except
      # returning bare move ID symbols throughout (the original already
      # did this) and current_map-style renames don't apply here.
      def relearnable_move_ids(pkmn)
  #This also needs to be updated in LAMR.
        return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?

        moves = []
        pkmn.getMoveList.each do |m|
          next if m[0] > pkmn.level || pkmn.hasMove?(m[1])

          moves.push(m[1]) unless moves.include?(m[1])
        end
        tmoves = []
        pkmn.first_moves&.each { |i| tmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) }
        pkmn.extra_moves&.each { |i| tmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) }
        pkmn.species_data.tutor_moves.each { |m| tmoves.push(m) }
        (tmoves + moves).uniq
      end

      def current_move_ids
        @edited_pokemon.moves.compact.map(&:id)
      end

      # Live-filtered, not a one-time removal - a move taught out of the
      # pool stops appearing because it's now a current move, and
      # reappears on its own if later displaced back out. No separate
      # "remove from list" bookkeeping needed.
      def visible_pool_moves
        known = current_move_ids
        @relearn_move_ids.reject { |id| known.include?(id) }
      end

      # ---- rendering -------------------------------------------------

      def render_station
        render_pokemon_icon_display if @edited_pokemon
		render_pokemon_text
        render_equipped_moves if @edited_pokemon
        render_pool
        render_move_info(nil)
      end

      def render_pokemon_icon_display
          sprites["edited_pokemon_icon"] = PokemonIconSprite.new(@edited_pokemon, viewport)
          sprites["edited_pokemon_icon"].zoom_x = sprites["edited_pokemon_icon"].zoom_y = 0.5
          sprites["edited_pokemon_icon"].x = bonus_1 + 26
          sprites["edited_pokemon_icon"].y = bonus_2 + 36
          sprites["edited_pokemon_icon"].z = 70
      end
      
	  def render_pokemon_text
        info_x = bonus_1 + 78
        info_y = bonus_2 + 62
        text = @edited_pokemon ? @edited_pokemon.name : ""
		puts text 
        if sprites["pokemon_name_rl"]
		  update_text_centered("pokemon_name_rl", text.empty? ? " " : text)
          sprites["pokemon_name_rl"].z = 70
        else
          create_text_centered("pokemon_name_rl", text.empty? ? " " : text, info_x, info_y)
          sprites["pokemon_name_rl"].z = 70
        end
	  
	  end 
	  
      #def equipped_slot_x(i) = bonus_1 + 20 + (i % 2) * SLOT_SIZE
      #def equipped_slot_y(i) = bonus_2 + 20 + (i / 2) * SLOT_SIZE
      def equipped_slot_x(i) = bonus_1 + 36 + i * SLOT_SIZE
      def equipped_slot_y(i) = bonus_2 + 80
	  
      def render_equipped_moves
        4.times do |i|
          sprites["equipped_slot#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["equipped_slot#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["equipped_slot#{i}"].z = 70
          sprites["equipped_slot#{i}"].x = equipped_slot_x(i)
          sprites["equipped_slot#{i}"].y = equipped_slot_y(i)

          render_move_icon("equipped_move#{i}", equipped_slot_x(i), equipped_slot_y(i), @edited_pokemon.moves[i])
        end
      end

      def pool_slot_x(col) = bonus_1 + 192 + col * SLOT_SIZE
      def pool_slot_y(row) = bonus_2 + 24 + row * SLOT_SIZE

      def render_pool
        moves = visible_pool_moves if @edited_pokemon
        POOL_VISIBLE.times do |i|
          col = i % POOL_COLS
          row = i / POOL_COLS
          sprites["pool_slot#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["pool_slot#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["pool_slot#{i}"].z = 70
          sprites["pool_slot#{i}"].x = pool_slot_x(col)
          sprites["pool_slot#{i}"].y = pool_slot_y(row)
          if @edited_pokemon
          move_id = moves[@pool_scroll_offset + i]
          render_move_icon("pool_move#{i}", pool_slot_x(col), pool_slot_y(row), move_id ? Pokemon::Move.new(move_id) : nil) if move_id 
		  end 
        end
      end

      # Your snippet, used as given - move.id is called unconditionally,
      # so every move passed in here (equipped or pool) needs to already
      # be a Pokemon::Move instance, never a bare symbol. Pool entries
      # are wrapped via Pokemon::Move.new(id) above specifically so this
      # works uniformly for both.
      def move_icon_path(move)
        imagepath = "Graphics/UI/OV HUD/#{move.id}"
        image = imagepath if pbResolveBitmap(imagepath)
        if move.is_a?(Pokemon::Move) && image.nil?
          imagepath = "Graphics/UI/OV HUD/#{move.type}"
          image = imagepath if pbResolveBitmap(imagepath)
        end
        image
      end


      def resize_for_slot(path)
        parts = path.split("/", 3)
        dir = "#{parts[0..1].join('/')}/"
        original = RPG::Cache.load_bitmap(dir, parts[2])
        resized = Bitmap.new(32, 32)
        src_w = [original.width, 48].min
        src_h = [original.height, 48].min
        resized.stretch_blt(Rect.new(0, 0, 32, 32), original, Rect.new(0, 0, src_w, src_h))
        resized
      end


      def render_move_icon(key, x, y, move)
        remove(icons["#{key}_image"])
        icons.delete("#{key}_image")
        return unless move

        path = move_icon_path(move)
        return unless path
        icons["#{key}_image"] = IconSprite.new(0, 0, viewport)
        icons["#{key}_image"].bitmap = resize_for_slot(path) if path
        icons["#{key}_image"].z = 98
        icons["#{key}_image"].x = x + (SLOT_SIZE - icons["#{key}_image"].bitmap.width) / 2
        icons["#{key}_image"].y = y + (SLOT_SIZE - icons["#{key}_image"].bitmap.height) / 2
      end

      # ---- hover info, replacing where the bag/item-detail area would
      # normally be - this station has neither -------------------------

      def render_move_info(move)
        info_x = bonus_1 + 120
        info_y = bonus_2 + 190
        text, description = move ? move_info_text(move) : ["", ""]
        if sprites["move_info"]
		  update_text_centered("move_info", text.empty? ? " " : text)
        else
          create_text_centered("move_info", text.empty? ? " " : text, info_x, info_y)
        end
        if sprites["move_desc"]
		  update_text_centered_wrapped("move_desc", description.empty? ? " " : description)
        else
          create_text_centered_wrapped("move_desc", description.empty? ? " " : description, info_x + 60, info_y + 60, 260)
        end
      end

      def move_info_text(move)
        data = GameData::Move.get(move.id)
        power = data.base_damage.positive? ? data.base_damage.to_s : "---"
        acc = data.accuracy.positive? ? "#{data.accuracy}%" : "---"
        category = %w[Physical Special Status][data.category] || "?"
        ["#{data.name} (#{GameData::Type.get(data.type).name})\n#{category}  PWR #{power}  ACC #{acc}", data.description]
      end

      # ---- geometry --------------------------------------------------

      def equipped_slot_from_mouse
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        4.times do |i|
          sprite = sprites["equipped_slot#{i}"]
          next unless sprite && within_sprite?(sprite, mouse_x, mouse_y)

          return i
        end
        nil
      end

      def pool_slot_from_mouse
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        POOL_VISIBLE.times do |i|
          sprite = sprites["pool_slot#{i}"]
          next unless sprite && within_sprite?(sprite, mouse_x, mouse_y)

          return i
        end
        nil
      end

      def pool_area_hovered?
        !pool_slot_from_mouse.nil?
      end

      # ---- click handling ---------------------------------------------

      def handle_custom_click(button)
        return false unless button == :left

        if (i = equipped_slot_from_mouse)
          handle_equipped_click(i)
          true
        elsif (i = pool_slot_from_mouse)
          handle_pool_click(i)
          true
        elsif pokemon_slot_hit?
          switch_edited_pokemon(hit_pokemon_index)
          true
        else
          false
        end
      end

      def handle_equipped_click(index)
        if @grabbed_move.nil?
          move = @edited_pokemon.moves[index]
          return unless move

          @move_origin_index = index
          @grabbed_move = move
          render_move_icon("equipped_move#{index}", equipped_slot_x(index), equipped_slot_y(index), nil) # matches the item convention - the origin slot visually empties, the same icon effectively becomes the floating one
          render_floating_move
        elsif @move_origin_index == index
          # Put it back where it came from - nothing was ever actually
          # mutated, so this is just re-rendering, not a data change.
          release_grabbed_move
        else
          teach_move(index)
        end
      end

      def handle_pool_click(visible_index)
        moves = visible_pool_moves
        move_id = moves[@pool_scroll_offset + visible_index]
        return unless move_id

        if @grabbed_move.nil?
          @move_origin_index = nil
          @grabbed_move = Pokemon::Move.new(move_id)
          render_floating_move
        elsif @move_origin_index.nil? && @grabbed_move.id == move_id
          release_grabbed_move
        else
          # Pool is a catalog, not a real slot - "picking" a different
          # one just swaps what's held, nothing to put back anywhere.
          @move_origin_index = nil
          @grabbed_move = Pokemon::Move.new(move_id)
          render_floating_move
        end
      end

      def teach_move(target_index)
        displaced = @edited_pokemon.add_move_at_index(@grabbed_move.id, target_index)

        # Reordering (came from another equipped slot): give the
        # displaced move back to the slot it was taken from. Came from
        # the pool, or dropped on the same slot: the displaced move is
        # simply forgotten, matching normal move-learning.
        @edited_pokemon.add_move_at_index(displaced.id, @move_origin_index) if @move_origin_index && @move_origin_index != target_index

        release_grabbed_move
        refresh_relearn_list
        render_equipped_moves
        render_pool
      end

      def release_grabbed_move
        remove(icons["held_move_image"])
        icons.delete("held_move_image")
        @grabbed_move = nil
        @move_origin_index = nil
        render_equipped_moves # restores whatever was visually cleared at pickup
      end

      def render_floating_move
        return unless @grabbed_move

        icons["held_move_image"] = IconSprite.new(-128, -128, viewport)
        path = move_icon_path(@grabbed_move)
        icons["held_move_image"].bitmap = resize_for_slot(path)
        icons["held_move_image"].z = 10_000
      end

      def switch_edited_pokemon(party_index)
        pkmn = party[party_index]
        return unless pkmn
        return if pkmn.egg? || pkmn.shadowPokemon?

        release_grabbed_move if @grabbed_move # carrying a move across a Pokemon switch doesn't make sense
        @edited_pokemon = pkmn
        refresh_relearn_list
        remove(sprites["edited_pokemon_icon"])
        render_pokemon_icon_display
		render_pokemon_text
        render_equipped_moves
        render_pool
      end

      # ---- scroll + hover, every frame --------------------------------

      def station_update
        update_pool_scroll
        update_hover_info
        if @grabbed_move
          mouse_x, mouse_y = Mouse.getMousePos
          icon = icons["held_move_image"]
          if icon && mouse_x
            icon.x = mouse_x - icon.bitmap.width / 2
            icon.y = mouse_y - icon.bitmap.height / 2
          end
        end
      end

      def update_pool_scroll
        return unless @edited_pokemon
        return unless pool_area_hovered?

        moves = visible_pool_moves
        max_offset = [moves.length - POOL_VISIBLE, 0].max
        if Input.jumping_up? && @pool_scroll_offset.positive?
          @pool_scroll_offset -= POOL_COLS
          @pool_scroll_offset = [@pool_scroll_offset, 0].max
          render_pool
        elsif Input.jumping_down? && @pool_scroll_offset < max_offset
          @pool_scroll_offset += POOL_COLS
          @pool_scroll_offset = [@pool_scroll_offset, max_offset].min
          render_pool
        end
      end

      def update_hover_info
	    return unless @edited_pokemon
        move = hovered_move
        return if move == @hovered_move

        @hovered_move = move
        render_move_info(move)
      end

      def hovered_move
        if (i = equipped_slot_from_mouse)
          return @edited_pokemon.moves[i]
        elsif (i = pool_slot_from_mouse)
          moves = visible_pool_moves
          id = moves[@pool_scroll_offset + i]
          return id ? Pokemon::Move.new(id) : nil
        end
        nil
      end
    end
  end
end
