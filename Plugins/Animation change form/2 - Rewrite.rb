def pbUseItem(bag,item,bagscene=nil)
  itm = GameData::Item.get(item)
  useType = itm.field_use
  if itm.is_machine?    # TM or TR or HM
    if $Trainer.pokemon_count == 0
      pbMessage(_INTL("There is no Pokémon."))
      return 0
    end
    machine = itm.move
    return 0 if !machine
    movename = GameData::Move.get(machine).name
    pbMessage(_INTL("\\se[PC access]You booted up {1}.\1",itm.name))
    if !pbConfirmMessage(_INTL("Do you want to teach {1} to a Pokémon?",movename))
      return 0

		# Add for using animation item
		# If you don't use animation item, add # this line (below)
    elsif pbMoveTutorChoose(machine,nil,true,itm.is_TR?,item)
		# If you don't use animation item, delete # this line (below)
		# elsif pbMoveTutorChoose(machine,nil,true,itm.is_TR?)

      bag.pbDeleteItem(item) if itm.is_TR?
      return 1
    end
    return 0
  elsif useType==1 || useType==5   # Item is usable on a Pokémon
    if $Trainer.pokemon_count == 0
      pbMessage(_INTL("There is no Pokémon."))
      return 0
    end
    ret = false
    annot = nil
    if itm.is_evolution_stone?
      annot = []
      for pkmn in $Trainer.party
        elig = pkmn.check_evolution_on_use_item(item)
        annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
      end
    end
    pbFadeOutIn {
      scene = PokemonParty_Scene.new
      screen = PokemonPartyScreen.new(scene,$Trainer.party)
      screen.pbStartScene(_INTL("Use on which Pokémon?"),false,annot)
      loop do
        scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
        chosen = screen.pbChoosePokemon
        if chosen<0
          ret = false
          break
        end
        pkmn = $Trainer.party[chosen]
        if pbCheckUseOnPokemon(item,pkmn,screen)

					# Add animation change form
					ret = ItemHandlers.triggerAnimationForm(item, pkmn, screen, chosen)
          ret = ItemHandlers.triggerUseOnPokemon(item,pkmn,screen) if ret.nil?

          if ret && useType==1   # Usable on Pokémon, consumed
            bag.pbDeleteItem(item)
            if !bag.pbHasItem?(item)
              pbMessage(_INTL("You used your last {1}.",itm.name)) { screen.pbUpdate }
              break
            end
          end
        end
      end
      screen.pbEndScene
      bagscene.pbRefresh if bagscene
    }
    return (ret) ? 1 : 0
  elsif useType==2   # Item is usable from Bag
    intret = ItemHandlers.triggerUseFromBag(item)
    case intret
    when 0 then return 0
    when 1 then return 1   # Item used
    when 2 then return 2   # Item used, end screen
    when 3                 # Item used, consume item
      bag.pbDeleteItem(item)
      return 1
    when 4                 # Item used, end screen and consume item
      bag.pbDeleteItem(item)
      return 2
    end
    pbMessage(_INTL("Can't use that here."))
    return 0
  end
  pbMessage(_INTL("Can't use that here."))
  return 0
end

def pbUseItemOnPokemon(item,pkmn,scene)
  itm = GameData::Item.get(item)
  # TM or HM
  if itm.is_machine?
    machine = itm.move
    return false if !machine
    movename = GameData::Move.get(machine).name
    if pkmn.shadowPokemon?
      pbMessage(_INTL("Shadow Pokémon can't be taught any moves.")) { scene.pbUpdate }
    elsif !pkmn.compatible_with_move?(machine)
      pbMessage(_INTL("{1} can't learn {2}.",pkmn.name,movename)) { scene.pbUpdate }
    else
      pbMessage(_INTL("\\se[PC access]You booted up {1}.\1",itm.name)) { scene.pbUpdate }
      if pbConfirmMessage(_INTL("Do you want to teach {1} to {2}?",movename,pkmn.name)) { scene.pbUpdate }

				# Add for using animation item
				# If you don't use animation item, add # this line (below)
				if pbLearnMove(pkmn,machine,false,true,item) { scene.pbUpdate }
				# If you don't use animation item, delete # this line (below)
        # if pbLearnMove(pkmn,machine,false,true) { scene.pbUpdate }

          $PokemonBag.pbDeleteItem(item) if itm.is_TR?
          return true
        end
      end
    end
    return false
  end
  # Other item

	# Add animation change form
	chosen = scene.party.find_index { |i| i == pkmn }
	ret = chosen.nil? ? nil : ItemHandlers.triggerAnimationForm(item, pkmn, scene, chosen) 
  ret = ItemHandlers.triggerUseOnPokemon(item,pkmn,scene) if ret.nil?

  scene.pbClearAnnotations
  scene.pbHardRefresh
  useType = itm.field_use
  if ret && useType==1   # Usable on Pokémon, consumed
    $PokemonBag.pbDeleteItem(item)
    if !$PokemonBag.pbHasItem?(item)
      pbMessage(_INTL("You used your last {1}.",itm.name)) { scene.pbUpdate }
    end
  end
  return ret
end