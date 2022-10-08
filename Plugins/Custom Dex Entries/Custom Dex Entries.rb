class Player
  attr_accessor :entries
end


def customEntry?(species)
  if $Trainer.entries && ![nil," ",""].include?($Trainer.entries[species])
    return true
  else
    return false
  end
end


def entry(species,var)
  if customEntry?(species)
      $game_variables[var] = $Trainer.entries[species]
    else
      $game_variables[var] = GameData::Species.get(species).pokedex_entry
  end

end

class PokemonPokedexInfo_Scene

  def drawPageInfo
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokedex/bg_info"))
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88, 88, 80)
    shadow = Color.new(168, 184, 184)
    imagepos = []
    if @brief
      imagepos.push([_INTL("Graphics/Pictures/Pokedex/overlay_info"), 0, 0])
    end
    species_data = GameData::Species.get_species_form(@species, @form)
    # Write various bits of text
    indexText = "???"
    if @dexlist[@index][4] > 0
      indexNumber = @dexlist[@index][4]
      indexNumber -= 1 if @dexlist[@index][5]
      indexText = sprintf("%03d", indexNumber)
    end
    textpos = [
      [_INTL("{1}{2} {3}", indexText, " ", species_data.name),
       246, 48, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)]
    ]
    if @show_battled_count
      textpos.push([_INTL("Number Battled"), 314, 164, 0, base, shadow])
      textpos.push([$player.pokedex.battled_count(@species).to_s, 452, 196, 1, base, shadow])
    else
      textpos.push([_INTL("Height"), 314, 164, 0, base, shadow])
      textpos.push([_INTL("Weight"), 314, 196, 0, base, shadow])
    end
    if $player.owned?(@species)
      # Write the category
      textpos.push([_INTL("{1} Pokémon", species_data.category), 246, 80, 0, base, shadow])
      # Write the height and weight
      if !@show_battled_count
        height = species_data.height
        weight = species_data.weight
        if System.user_language[3..4] == "US"   # If the user is in the United States
          inches = (height / 0.254).round
          pounds = (weight / 0.45359).round
          textpos.push([_ISPRINTF("{1:d}'{2:02d}\"", inches / 12, inches % 12), 460, 164, 1, base, shadow])
          textpos.push([_ISPRINTF("{1:4.1f} lbs.", pounds / 10.0), 494, 196, 1, base, shadow])
        else
          textpos.push([_ISPRINTF("{1:.1f} m", height / 10.0), 470, 164, 1, base, shadow])
          textpos.push([_ISPRINTF("{1:.1f} kg", weight / 10.0), 482, 196, 1, base, shadow])
        end
      end
      # Draw the Pokédex entry text
      entry = species_data.pokedex_entry
      if !$Trainer.entries
        $Trainer.entries = {}
        GameData::Species.each do |sp|
          $Trainer.entries[sp.id]         = ""
        end
      end
      if ![nil," ",""].include?($Trainer.entries[@species])
          entry = $Trainer.entries[@species]
        end
      drawTextEx(overlay, 40, 246, Graphics.width - (40 * 2), 4,   # overlay, x, y, width, num lines
                 entry, base, shadow)
      # Draw the footprint
      footprintfile = GameData::Species.footprint_filename(@species, @form)
      if footprintfile
        footprint = RPG::Cache.load_bitmap("", footprintfile)
        overlay.blt(226, 138, footprint, footprint.rect)
        footprint.dispose
      end
      # Show the owned icon
      imagepos.push(["Graphics/Pictures/Pokedex/icon_own", 212, 44])
      # Draw the type icon(s)
      species_data.types.each_with_index do |type, i|
        type_number = GameData::Type.get(type).icon_position
        type_rect = Rect.new(0, type_number * 32, 96, 32)
        overlay.blt(296 + (100 * i), 120, @typebitmap.bitmap, type_rect)
      end
    else
      # Write the category
      textpos.push([_INTL("????? Pokémon"), 246, 80, 0, base, shadow])
      # Write the height and weight
      if !@show_battled_count
        if System.user_language[3..4] == "US"   # If the user is in the United States
          textpos.push([_INTL("???'??\""), 460, 164, 1, base, shadow])
          textpos.push([_INTL("????.? lbs."), 494, 196, 1, base, shadow])
        else
          textpos.push([_INTL("????.? m"), 470, 164, 1, base, shadow])
          textpos.push([_INTL("????.? kg"), 482, 196, 1, base, shadow])
        end
      end
    end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw all images
    pbDrawImagePositions(overlay, imagepos)
  end

  def pbScene
    GameData::Species.play_cry_from_species(@species, @form)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::ACTION)
        pbSEStop
        GameData::Species.play_cry_from_species(@species, @form) if @page == 1
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        if @page==2   # Area
#          dorefresh = true
        elsif @page==3   # Forms
          if @available.length>1
            pbPlayDecisionSE
            pbChooseForm
            dorefresh = true
          end
        end
      elsif Input.trigger?(Input::ALT) && $Trainer.owned?(@species)
        if @page==1
          if !$Trainer.entries
            $Trainer.entries = {}
            GameData::Species.each do |sp|
              $Trainer.entries[sp.id]         = ""
            end
          end
          $Trainer.entries[@species]=pbMessageFreeText(_INTL("New PokéDex entry?"),"",false,170,Graphics.width)
          dorefresh = true
          drawPageInfo
        end
      elsif Input.trigger?(Input::UP)
        oldindex = @index
        pbGoToPrevious
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          pbSEStop
          (@page==1) ? GameData::Species.play_cry_from_species(@species, @form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN)
        oldindex = @index
        pbGoToNext
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          pbSEStop
          (@page==1) ? GameData::Species.play_cry_from_species(@species, @form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT)
        oldpage = @page
        @page -= 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT)
        oldpage = @page
        @page += 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @index
  end



end