module InventoryScene
  module Stations
    # Two view modes:
    #   :list   - the 6 adventuring Pokemon (normal drag-and-drop against
    #             the home party sidebar, same mechanics as any other
    #             Pokemon-holding slot in this codebase), the collected-
    #             item storage row (drag into the bag - has_bag_grid? is
    #             back on), "Call Back All"
    #   :detail - one adventuring Pokemon's traveling partners (now
    #             interactive - drag them out to the home party), its
    #             scrollable adventure log, "Call Back" for just that one
    # Middle-click on an adventuring Pokemon switches to :detail instead
    # of opening a held-item inventory.
    #
    # "Call back" sets a flag (pkmn.called_back), it does not move the
    # Pokemon - that happens once it's actually walked back, at which
    # point picking it up is just a normal Pokemon-slot pickup like
    # PkmnCrate, gated by pokemon_leavable? (on the current map, no
    # traveling partners left). That's what makes this NOT need the
    # complex all-or-nothing box-fallback logic my first draft had - by
    # the time removal is even allowed, there's nothing left to cascade.
	

	
    class AdventureFlag < BaseStation
      PARTY_SIZE = 6

      def slot_count = 9
      def background_key = "ADVENTURE"
      def uses_recipe_grid? = false

      def initial_craft_contents = event_data.internal_storage
      def finalize_container = nil

      def initialize(event_data:, container:)
        # $Adventure.party is assumed to be (or is padded here to be) a
        # fixed PARTY_SIZE array with nil for empty slots - same
        # convention as party/pokemon_box everywhere else in this
        # codebase. If it's actually a dynamic/splicing list instead,
        # this whole grid needs a different shape (a scrollable list,
        # not fixed slots) - flagging this as a real open question, not
        # a confident assumption.
        short_by = PARTY_SIZE - $Adventure.party.length
        $Adventure.party.concat(Array.new(short_by)) if short_by.positive?

        @view_mode = :list
        @detail_pokemon_index = nil
        @log = nil
        super
      end

      def open_pokemon_inventory
        return if grabbed_item
        return unless @view_mode == :list

        i = adventure_slot_from_mouse
        return unless i
        return unless $Adventure.party[i]

        @detail_pokemon_index = i
        @view_mode = :detail
        refresh_view!
      end

      # ---- move validation / side effects, for the :adventure_party
      # and :traveling_partner kinds specifically -----------------------

      def pokemon_leavable?(kind, _index, pokemon)
        return true unless kind == :adventure_party

        unless pokemon.current_map == $game_map.map_id
          sideDisplay(_INTL("{1} hasn't made it back yet.", pokemon.name))
          return false
        end
        partners = pokemon.traveling_partners
        if partners && !partners.compact.empty?
          sideDisplay(_INTL("{1} is still traveling with others - remove them first from its detail view.", pokemon.name))
          return false
        end
        true
      end

      def pokemon_placeable?(kind, _index, pokemon)
        return true unless kind == :adventure_party

        if pokemon.inworld
          sideDisplay(_INTL("{1} is in the world currently!", pokemon.name))
          return false
        end
        true
      end

      # Ported from your original pbMoveToAdventure's success path.
      def on_pokemon_placed(kind, _index, pokemon)
        return unless pokemon.is_a?(Pokemon)
        return unless kind == :adventure_party

        pokemon.play_cry
        pokemon.current_map = $game_map.map_id
        pokemon.on_adventure = true
      end

      # GUESS: the mirror of on_pokemon_placed above - your original
      # script never showed a "just returned" side effect separate from
      # the whole pbMoveToParty method (which also did the party-append/
      # box-fallback this design no longer needs). Clearing on_adventure
      # here is my best guess at what should happen; confirm/correct.
      def on_pokemon_removed(kind, _index, pokemon)
        return unless pokemon.is_a?(Pokemon)
        return unless kind == :adventure_party

        pokemon.on_adventure = false
      end

      def backing_store_for_pokemon(kind)
        case kind
        when :adventure_party then $Adventure.party
        when :traveling_partner then current_detail_pokemon&.traveling_partners || []
        else super
        end
      end

      private

      def handle_custom_click(button)
        return false unless button == :left # matches the existing pattern - no right-click behavior for Pokemon portraits anywhere in this codebase

        case @view_mode
        when :list then handle_list_click
        when :detail then handle_detail_click
        else false
        end
      end

      def handle_list_click
        if (i = adventure_slot_from_mouse)
          pkmn = $Adventure.party[i]
          if pkmn && grabbed_item.nil? && pkmn.current_map && pkmn.current_map != $game_map.map_id
            request_call_back(pkmn)
          else
            handle_pokemon_click(:adventure_party, $Adventure.party, i)
          end
          true
        elsif clicked_object? == "call_back_all"
          call_back_all
          true
        else
          false
        end
      end

      def handle_detail_click
        if (i = traveling_partner_slot_from_mouse)
          handle_pokemon_click(:traveling_partner, current_detail_pokemon&.traveling_partners || [], i)
          true
        else
          case clicked_object?
          when "detail_back"
            switch_to_list_view
            true
          when "call_back_this"
            request_call_back(current_detail_pokemon)
            true
          else
            false
          end
        end
      end

      def current_detail_pokemon
        return nil unless @detail_pokemon_index

        $Adventure.party[@detail_pokemon_index]
      end

      # A request, not a move - the actual return trip is presumably
      # simulated elsewhere (station_update's $Adventure.update, or a
      # map-tick system like Pet Bed's). GUESS at the target map_id -
      # your script never showed where this value should come from for
      # this exact call; using the current map since that's what the
      # original pbMoveToAdventure used symmetrically for the outbound
      # trip, but confirm this is actually right for the return trip too.
      def request_call_back(pkmn)
        return unless pkmn
        return unless pkmn.location && pkmn.location != $game_map.map_id
        return if pkmn.called_back

        pkmn.called_back = $game_map.map_id
        sideDisplay(_INTL("Called {1} back.", pkmn.name))
      end

      def call_back_all
        $Adventure.party.each { |pkmn| request_call_back(pkmn) if pkmn }
      end

      # ---- LIST VIEW -----------------------------------------------

      def render_station
        clear_list_sprites
        clear_detail_sprites
        case @view_mode
        when :list then render_list_view
        when :detail then render_detail_view
        end
      end

      def render_list_view
        render_adventure_party_slots
        render_item_storage_row
        render_call_back_all_button
      end

      # Positioned in the station's own content area (bonus_1/bonus_2),
      # same as every other station's craft slots - never start_x/
      # start_y, which is the bag grid's own coordinate origin.
      def render_adventure_party_slots
        x = bonus_1 + 40
        y = bonus_2 + 20
        PARTY_SIZE.times do |i|
          sprites["adv_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["adv_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["adv_slots#{i}"].z = -2
          sprites["adv_slots#{i}"].x = x + (i % 3) * SLOT_SIZE
          sprites["adv_slots#{i}"].y = y + (i / 3) * SLOT_SIZE

          pkmn = $Adventure.party[i]
          render_pokemon_icon(:adventure_party, i, pkmn) if pkmn
        end
      end

      def render_item_storage_row
        x = bonus_1 + 22
        y = bonus_2 + 100
        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          sprites["craft_slots#{i}"].x = x + i * SLOT_SIZE
          sprites["craft_slots#{i}"].y = y
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end
      end

      def render_call_back_all_button
        objects["call_back_all"] = IconSprite.new(0, 0, viewport)
        objects["call_back_all"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up")
        objects["call_back_all"].z = 70
        objects["call_back_all"].x = bonus_1 + 220
        objects["call_back_all"].y = bonus_2 + 30
        create_text3("call_back_all_label", "Call Back All", objects["call_back_all"].x, objects["call_back_all"].y + 20)
      end


	def adventuring?(pokemon)
	  return false unless pokemon 
	  pokemon.on_adventure && pokemon.current_map!=$game_map.map_id
	end 

    def update_pokemon_icon_tones
      icons.each_value do |value|
        next unless value.is_a?(PokemonIconSprite) && !value.disposed?

        if value.pokemon&.dead?
          value.tone = Tone.new(64, -64, -64, 255)
        elsif value.pokemon&.fainted?
          value.tone = Tone.new(0, 0, 0, 255)
        elsif adventuring?(value.pokemon) && @view_mode!=:detail
          value.tone = Tone.new(55, 55, 55, 255)
        elsif value.pokemon
          value.tone = Tone.new(0, 0, 0, 0)
          value.update
        end
      end
    end
      # ---- DETAIL VIEW -----------------------------------------------

      def render_detail_view
        pkmn = current_detail_pokemon
        return switch_to_list_view unless pkmn

        render_traveling_partners(pkmn)
        render_detail_log(pkmn)
        render_detail_buttons
      end

      def render_traveling_partners(pkmn)
        partners = pkmn.traveling_partners || []
        x = bonus_1 + 40
        y = bonus_2 + 30
        partners.each_with_index do |partner, i|
          sprites["partner_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["partner_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["partner_slots#{i}"].z = -2
          sprites["partner_slots#{i}"].x = x + i * SLOT_SIZE
          sprites["partner_slots#{i}"].y = y
          render_pokemon_icon(:traveling_partner, i, partner) if partner
        end
      end

      def render_detail_log(pkmn)
        @log ||= ScrollableLog.new(viewport:, x: bonus_1 + 20, y: bonus_2 + 80, width: 260, height: 100)
        @log.text = pkmn.adventure_log.to_s
      end

      def render_detail_buttons
        objects["detail_back"] = IconSprite.new(0, 0, viewport)
        objects["detail_back"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up")
        objects["detail_back"].z = 70
        objects["detail_back"].x = bonus_1 + 20
        objects["detail_back"].y = bonus_2 + 60
        create_text3("detail_back_label", "Back", objects["detail_back"].x, objects["detail_back"].y + 20)

        objects["call_back_this"] = IconSprite.new(0, 0, viewport)
        objects["call_back_this"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up")
        objects["call_back_this"].z = 70
        objects["call_back_this"].x = bonus_1 + 120
        objects["call_back_this"].y = bonus_2 + 60
        create_text3("call_back_this_label", "Call Back", objects["call_back_this"].x, objects["call_back_this"].y + 20)
      end

      def traveling_partner_slot_from_mouse
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        partners = current_detail_pokemon&.traveling_partners || []
        partners.length.times do |i|
          sprite = sprites["partner_slots#{i}"]
          next unless sprite && within_sprite?(sprite, mouse_x, mouse_y)

          return i
        end
        nil
      end

      def switch_to_list_view
        @view_mode = :list
        @detail_pokemon_index = nil
        refresh_view!
      end

      def refresh_view!
        clear_list_sprites
        clear_detail_sprites
        case @view_mode
        when :list then render_list_view
        when :detail then render_detail_view
        end
      end

      def clear_list_sprites
        sprites.keys.select { |k| k.to_s.start_with?("adv_slots") }.each { |k| remove(sprites[k]); sprites.delete(k) }
        PARTY_SIZE.times { |i| remove(icons[icon_key(:adventure_party, i, :image)]); icons.delete(icon_key(:adventure_party, i, :image)) }
        slot_count.times do |i|
          remove_slot_icon(:craft, i)
          remove(sprites["craft_slots#{i}"])
          sprites.delete("craft_slots#{i}")
        end
        remove(objects["call_back_all"])
        objects.delete("call_back_all")
        remove(sprites["call_back_all_label"])
        sprites.delete("call_back_all_label")
      end

      def clear_detail_sprites
        sprites.keys.select { |k| k.to_s.start_with?("partner_slots") }.each { |k| remove(sprites[k]); sprites.delete(k) }
        icons.keys.select { |k| k.to_s =~ /\A\d+_tpartner\z/ }.each { |k| remove(icons[k]); icons.delete(k) } # :traveling_partner icons (default suffix)
        %w[detail_back call_back_this].each { |k| remove(objects[k]); objects.delete(k) }
        %w[detail_back_label call_back_this_label].each { |k| remove(sprites[k]); sprites.delete(k) }
        @log&.dispose
        @log = nil
      end

      def station_update
	    event_data.update
	    $Adventure.update_active_battles
        @log&.update if @view_mode == :detail
        sync_slots_visuals!(:craft, 0...slot_count) if @view_mode == :list
        unless pbGetTimeNow.to_i < $Adventure.last_check + $Adventure.timer
	    $Adventure.party.each { |pkmn| pkmn.update if pkmn }
        $Adventure.adventuring
		end 
      end
    end
 
  end
end
