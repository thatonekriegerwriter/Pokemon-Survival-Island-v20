module Custom_Entries
  attr_accessor :entries


  @entries = []
end



class Player
include Custom_Entries
end


def customEntry?(species)
    idno = GameData::Species.get(species).id_number
  if $Trainer.entries &&
    $Trainer.entries[idno]!=nil &&
    $Trainer.entries[idno]!=" " &&
    $Trainer.entries[idno]!=""
    return true
  else
    return false
  end
end


def entry(species,var)
    idno = GameData::Species.get(species).id_number
  if customEntry?(species)
      $game_variables[var] = $Trainer.entries[idno]
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
          246, 36, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)],
       [_INTL("Height"), 314, 152, 0, base, shadow],
       [_INTL("Weight"), 314, 184, 0, base, shadow]
    ]
    if $Trainer.owned?(@species)
      # Write the category
      textpos.push([_INTL("{1} Pokémon", species_data.category), 246, 68, 0, base, shadow])
      # Write the height and weight
      height = species_data.height
      weight = species_data.weight
      if System.user_language[3..4] == "US"   # If the user is in the United States
        inches = (height / 0.254).round
        pounds = (weight / 0.45359).round
        textpos.push([_ISPRINTF("{1:d}'{2:02d}\"", inches / 12, inches % 12), 460, 152, 1, base, shadow])
        textpos.push([_ISPRINTF("{1:4.1f} lbs.", pounds / 10.0), 494, 184, 1, base, shadow])
      else
        textpos.push([_ISPRINTF("{1:.1f} m", height / 10.0), 470, 152, 1, base, shadow])
        textpos.push([_ISPRINTF("{1:.1f} kg", weight / 10.0), 482, 184, 1, base, shadow])
      end
      # Draw the Pokédex entry text
      entry = species_data.pokedex_entry
      if !$Trainer.entries
        $Trainer.entries = []
        GameData::Species.each do |sp|
          $Trainer.entries[sp.id_number]         = ""
        end
      end
      idno = species_data.id_number
        if $Trainer.entries[idno]!=nil &&
          $Trainer.entries[idno]!=" " &&
          $Trainer.entries[idno]!=""
          entry = $Trainer.entries[idno]
        end
      drawTextEx(overlay, 40, 244, Graphics.width - (40 * 2), 4,   # overlay, x, y, width, num lines
                 entry, base, shadow)
      # Draw the footprint
      footprintfile = GameData::Species.footprint_filename(@species, @form)
      if footprintfile
        footprint = RPG::Cache.load_bitmap("",footprintfile)
        overlay.blt(226, 138, footprint, footprint.rect)
        footprint.dispose
      end
      # Show the owned icon
      imagepos.push(["Graphics/Pictures/Pokedex/icon_own", 212, 44])
      # Draw the type icon(s)
      type1 = species_data.type1
      type2 = species_data.type2
      type1_number = GameData::Type.get(type1).id_number
      type2_number = GameData::Type.get(type2).id_number
      type1rect = Rect.new(0, type1_number * 32, 96, 32)
      type2rect = Rect.new(0, type2_number * 32, 96, 32)
      overlay.blt(296, 120, @typebitmap.bitmap, type1rect)
      overlay.blt(396, 120, @typebitmap.bitmap, type2rect) if type1 != type2
    else
      # Write the category
      textpos.push([_INTL("????? Pokémon"), 246, 68, 0, base, shadow])
      # Write the height and weight
      if System.user_language[3..4] == "US"   # If the user is in the United States
        textpos.push([_INTL("???'??\""), 460, 152, 1, base, shadow])
        textpos.push([_INTL("????.? lbs."), 494, 184, 1, base, shadow])
      else
        textpos.push([_INTL("????.? m"), 470, 152, 1, base, shadow])
        textpos.push([_INTL("????.? kg"), 482, 184, 1, base, shadow])
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
      elsif Input.trigger?(Input::AUX2) && $Trainer.owned?(@species)
        if @page==1
          if !$Trainer.entries
            $Trainer.entries = []
            GameData::Species.each do |sp|
              $Trainer.entries[sp.id_number]         = ""
            end
          end
          species_data = GameData::Species.get_species_form(@species, @form)
          idno = species_data.id_number
          $Trainer.entries[idno]=pbMessageFreeText(_INTL("New PokéDex entry?"),"",false,170,Graphics.width)
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

