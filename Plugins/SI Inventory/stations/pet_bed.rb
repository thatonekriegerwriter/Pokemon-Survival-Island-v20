module InventoryScene
  module Stations
    class PetBed < BaseStation
      def initialize(event_data:, container:)
        event_data.give_feather
        super
      end
	  
      def slot_count = 1
      def background_key = "PETBED"
      def uses_recipe_grid? = false
      def craft_slots_hold_pokemon? = true
      def shows_search_ui? = false

      # The shared pick-up/place/swap logic just needs something
      # array-like with one slot. This proxy wraps PetBedData so that
      # assigning into it (`store[0] = pokemon`, `store[0] = nil`) calls
      # place_pokemon/remove_pokemon as a side effect - which is what
      # actually spawns/despawns the Pokemon on the map. Keeping that
      # here, rather than teaching the generic DraggableSlots/
      # PartyInteraction code about PetBed specifically, is what lets
      # every other station stay untouched by this.
      #
      # KNOWN GAP: if place_pokemon returns false (pbPlacePokemon refused
      # - fainted, blocked tile), []= here just silently no-ops rather
      # than telling the caller the drop failed. The generic drop-handling
      # code (handle_pokemon_drop) doesn't currently check for that and
      # will still render the Pokemon as "placed" in the slot regardless.
      # Flagging this rather than guessing at how you'd want a failed
      # placement surfaced to the player (message? bounce back to hand?).
      class SlotProxy
        def initialize(bed_data) = @bed_data = bed_data
        def length = 1
        def [](_index) = @bed_data.pokemon

        def []=(_index, value)
          value.nil? ? @bed_data.remove_pokemon : @bed_data.place_pokemon(value)
        end
      end

      def pokemon_box
        @pokemon_box_proxy ||= SlotProxy.new(event_data)
      end

      # Nothing item-based to save - PetBed only ever holds the one
      # Pokemon, and PetBedData already owns that directly.
      def finalize_container = nil
	  
	  def get_current_action
        return "" unless event_data.pokemon 
        return "" unless event_data.movement_type
	    movement_type = event_data.movement_type
	    case movement_type
		 when :EGG
		  pkmn = event_data.pokemon 
		  eggstate = _INTL("It looks like this Egg will take a long time to hatch.")
          eggstate = _INTL("What will hatch from this? It doesn't seem close to hatching.") if pkmn.steps_to_hatch < 10_200
          eggstate = _INTL("It appears to move occasionally. It may be close to hatching.") if pkmn.steps_to_hatch < 2550
          eggstate = _INTL("Sounds can be heard coming from inside! It will hatch soon!") if pkmn.steps_to_hatch < 1275
		  return eggstate
		 when :MOVING_TO_WORK
		  return "Going to Work"
		 when :MOVING_TO_BED
		  return "Returning to Bed"
		 when :INBED
		  poke_event = event_data.spawned_event
		  return "Breeding" if event_data.breeding
		  return "Sleeping" if poke_event.sleeping?
		  return "Resting"
		 when :WORKING
		  return "Working"
		 when :WANDER
		  return "Wandering"
		 when :FOLLOW
		  return "Following"
		 else 
		  return "Messing Around"
		end
        return "" 
	  end 
	  
	  def folder
	    background_key == "PETBED" ? "petbed" : "petbedo"
	  end 
	  
      def handle_object_click(object_key)
        return unless object_key == "assign_button"
 
        toggle_assignment_mode
      end

      private

      def render_station
        sprites["craft_slots0"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots0"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/#{folder}/placeholder_slot")
        sprites["craft_slots0"].z = -2
        sprites["craft_slots0"].x = bonus_1 + 44
        sprites["craft_slots0"].y = bonus_2 + 60
        sprites["pokemon_hp"] = IconSprite.new(0, 0, viewport)
        sprites["pokemon_hp"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/petbed/hp")
        sprites["pokemon_hp"].z = 0
        sprites["pokemon_hp"].x = sprites["craft_slots0"].x + 106
        sprites["pokemon_hp"].y = sprites["craft_slots0"].y - 14
        sprites["pokemon_hp"].visible = event_data.pokemon &&  !event_data.pokemon.egg?
		sprites["pokemon_hp_overlay"] = IconSprite.new(0, 0, viewport)
        sprites["pokemon_hp_overlay"].setBitmap("Graphics/Pictures/Summary/overlay_hp")
        sprites["pokemon_hp_overlay"].src_rect.width = 0
        sprites["pokemon_hp_overlay"].src_rect.height = 6
        sprites["pokemon_hp_overlay"].x =  sprites["pokemon_hp"].x + 30
        sprites["pokemon_hp_overlay"].y = sprites["pokemon_hp"].y + 2
        sprites["pokemon_hp_overlay"].z = 1
        sprites["pokemon_hp_overlay"].visible = sprites["pokemon_hp"].visible
		create_text_centered("pokemon_hp_text","",sprites["pokemon_hp"].x + 46,sprites["pokemon_hp"].y + 24)
        render_pokemon_icon(:craft, 0, event_data.pokemon) if event_data.pokemon
		
		render_assign_button
        create_text_centered("pokemon_bedlabel", "", sprites["craft_slots0"].x + 20, sprites["craft_slots0"].y - 28)
		if event_data.pokemon
		  update_text_centered("pokemon_bedlabel", event_data.pokemon.name)
		else
		 
		  update_text_centered("pokemon_bedlabel", "")
		end 
      end


       def refresh_pokemon_hp
	    pokemon_grabbed = grabbed_item && event_data.pokemon == grabbed_item.item
        pokemon = event_data.pokemon

        unless pokemon &&  !pokemon.egg? && !pokemon_grabbed
          sprites["pokemon_hp"].visible = false
          sprites["pokemon_hp_overlay"].visible = sprites["pokemon_hp"].visible
          update_text_centered("pokemon_hp_text", "")
          return
        end

        sprites["pokemon_hp"].visible = true
        sprites["pokemon_hp_overlay"].visible = sprites["pokemon_hp"].visible
        update_text_centered("pokemon_hp_text","#{pokemon.hp}/#{pokemon.totalhp}")
        w = pokemon.hp * 96 / pokemon.totalhp.to_f
        w = 1 if w < 1
        w = ((w / 2).round) * 2

        hpzone = 0
        hpzone = 1 if pokemon.hp <= (pokemon.totalhp / 2).floor
        hpzone = 2 if pokemon.hp <= (pokemon.totalhp / 4).floor

        sprites["pokemon_hp_overlay"].src_rect.x = 0
        sprites["pokemon_hp_overlay"].src_rect.y = hpzone * 6
        sprites["pokemon_hp_overlay"].src_rect.width = w
        sprites["pokemon_hp_overlay"].src_rect.height = 6
      end


      def render_assign_button
        objects["assign_button"] = IconSprite.new(0, 0, viewport)
        objects["assign_button"].x = bonus_1 + 123
        objects["assign_button"].y = bonus_2 + 104
        objects["assign_button"].z = 0
        objects["assign_button"].visible = event_data.pokemon && !event_data.pokemon.egg?
        #text = assigning_from_this_bed? ? "Assigning..." : assigned? ? "Assigned" : "Assign"
        create_text_centered("current_task_label", get_current_action, sprites["craft_slots0"].x + 180, sprites["craft_slots0"].y - 20)
        create_text_centered("assigned_to_label", "", sprites["craft_slots0"].x + 20, sprites["craft_slots0"].y - 16, MessageConfig::DARK_TEXT_MAIN_COLOR, nil, 11)
        refresh_assign_button
      end


	  
      def toggle_assignment_mode
        return unless event_data.pokemon # nothing to assign if the bed's empty
        return unless event_data.pokemon.able?
 
        if assigning_from_this_bed? || assigned?
		  event_data.remove_worker
		  event_data.assigned_job = nil
          $game_temp.assignment_mode = false
          $game_temp.assignment_source = nil
        else
          $game_temp.assignment_mode = true
          $game_temp.assignment_source = event_data
        end
        refresh_assign_button
      end
 
      def assigning_from_this_bed?
        $game_temp.assignment_mode && $game_temp.assignment_source.equal?(event_data)
      end
      
	  def assigned?
	    !event_data.assigned_job.nil?
	  end 
	  
      # Pressed/active bitmap while this bed is the one currently
      # selecting an assignment target - same up/down toggle convention
      # as Bag's equipment_button. Re-checked every frame (not just
      # right after a click) so the button also reflects reality if
      # assignment_mode gets cleared some other way (completed by
      # walking up to a station, or cancelled below).
      def refresh_assign_button
	    pokemon_grabbed = grabbed_item && event_data.pokemon && event_data.pokemon == grabbed_item.item
        bitmap = (assigned? || assigning_from_this_bed?) ? "smallbutton_down" : "smallbutton_up"
        objects["assign_button"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/petbed/#{bitmap}")
       # text = assigning_from_this_bed? ? "Assigning..." : assigned? ? "Assigned" : "Assign"
	    if event_data.pokemon && !pokemon_grabbed
		  update_text_centered("current_task_label", get_current_action)
		else
		  update_text_centered("current_task_label", "")
		end 
		if event_data.pokemon && assigned? && !pokemon_grabbed
		  assignment_text = "Works at #{event_data.work_name}"
		  update_text_centered("assigned_to_label", assignment_text)
		elsif event_data.pokemon && !event_data.pokemon.egg? && !pokemon_grabbed
		  update_text_centered("assigned_to_label", "Unassigned")
		else 
		  update_text_centered("assigned_to_label", "")
		end 
        pokemon = event_data.pokemon
		if pokemon && !pokemon.egg? && !pokemon_grabbed
        objects["assign_button"].visible = true 
		else
        objects["assign_button"].visible = false 
		end 
      end
      
	  def refresh_text
	    pokemon_grabbed = grabbed_item && event_data.pokemon == grabbed_item.item
		if event_data.pokemon && !pokemon_grabbed
		  update_text_centered("pokemon_bedlabel", event_data.pokemon.name)
		else
		  update_text_centered("pokemon_bedlabel", "")
		end 
	  end
	  
      # Removing the resting Pokemon always unassigns its job (per your
      # earlier rule) - this extends that to also cancel an in-progress
      # selection, so the button doesn't stay stuck "on" for an empty bed.
      def cancel_assignment_if_orphaned
        return unless assigning_from_this_bed? && event_data.pokemon.nil?
        $game_temp.assignment_mode = false
        $game_temp.assignment_source = nil
      end
 
      def station_update
        cancel_assignment_if_orphaned
        refresh_assign_button
		refresh_text
		refresh_pokemon_hp
      end



    end
  end
end


module InventoryScene
  module Stations
    class PetBedOutdoor < PetBed
      def background_key = "PETBEDOUTDOOR"
	end
  end
end 