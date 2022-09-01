EventHandlers.add(:on_player_step_taken_can_transfer, :effefefefefehhttj,
  proc {
if $PokemonBag.pbHasItem?(:SPRINKLER)
  $game_switches[410]=true 
end

if $PokemonBag.pbHasItem?(:COALGENERATOR)
  $game_switches[409]=true 
end


if $PokemonBag.pbHasItem?(:UPGRADEDCRAFTINGBENCH)
  $game_switches[402]=true 
end

if $PokemonBag.pbHasItem?(:MEDICINEPOT)
  $game_switches[405]=true 
end

if $PokemonBag.pbHasItem?(:FURNACE)
  $game_switches[403]=true 
end

if $PokemonBag.pbHasItem?(:CAULDRON)
  $game_switches[147]=true 
end

if $PokemonBag.pbHasItem?(:CRAFTINGBENCH)
  $game_switches[150]=true 
end

if $PokemonBag.pbHasItem?(:APRICORNCRAFTING)
  $game_switches[144]=true 
end

if $PokemonBag.pbHasItem?(:PORTABLEPC)
  $game_switches[406]=true 
end

if $PokemonBag.pbHasItem?(:ITEMCRATE)
  $game_switches[406]=true 
end

if $PokemonBag.pbHasItem?(:BEDROLL)
  $game_switches[407]=true 
end

if $PokemonBag.pbHasItem?(:SEWINGMACHINE)
  $game_switches[411]=true 
end

if $PokemonBag.pbHasItem?(:ELECTRICPRESS)
  $game_switches[412]=true 
end

if $game_variables[256]==(:GHOSTMAIL) && rand(100) == 5
end

  
if $game_switches[421]==true
  if $game_switches[943]==true
     $game_variables[291]+=1
  end
  if $game_switches[944]==true
     $game_variables[291]+=1
  end
  if $game_switches[945]==true
     $game_variables[291]+=1
  end
  if $game_switches[946]==true
     $game_variables[291]+=1
  end
  if $game_switches[947]==true
     $game_variables[291]+=1
  end
  if $game_switches[948]==true
     $game_variables[291]+=1
  end
  if $game_switches[949]==true
     $game_variables[291]+=1
  end
  if $game_switches[950]==true
     $game_variables[291]+=1
  end
end

if $game_switches[420]==true
end

if $game_switches[419]==true
end

if $game_switches[418]==true
end  
  if $game_switches[96]==true
    $game_variables[4993]-=1
	if $game_map.terrain_tag($game_player.x, $game_player.y).w_current && $game_variables[4993]!=-1
	 #:3
	else
	 $game_variables[4993]=2
	end
  end
})

=begin
Events.onTrainerPartyLoad += proc { |_sender, trainer|
  if trainer[0] # I saw this on other codes so I put it in
    party = trainer[0].party   # trainer[0][2] from old code no longer exists. This seems to be where that same value is now located
    if $game_switches[141]==true # Feel free to change which Switch you want or condition to trigger this.
      if pbBalancedLevel($Trainer.party) > pbBalancedLevel(trainer[0].party) + 3 #Used to see if levels even should be adjusted. The +3 makes it so your party level needs to be 3 levels higher before this kicks in. Feel free to adjust.
      levelAdjust = pbBalancedLevel($Trainer.party) - pbBalancedLevel(trainer[0].party) #Calculate the difference before the for loop incase values change in the middle of the loop
        for i in party
          # Increases level by the party level difference. Allowing the pokemon in the team to keep their level differences from each other.
          #I add to the level instead of overriding it so that the internal team level differences don't change and are not random.
          newlevel = i.level + levelAdjust + rand(5*$game_variables[30]) # Change this if you want to adjust the levels. The -3 keeps the team 3 levels lower on average.
          if newlevel > 255
            newlevel = 255
          end
          i.level = newlevel
          i.calc_stats
          i.reset_moves
        end
      end
    end
  end
}
=end
def pbGrassEvolutionStone
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Gloom"
    Kernel.pbMessage(_INTL("Gloom evolves into Vileplume."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VILEPLUME)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Weepingbell"
    Kernel.pbMessage(_INTL("Weepingbell evolves into Victreebell."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VECTREEBEL)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Exeggcute" 
    Kernel.pbMessage(_INTL("Exeggcute evolves into Exeggcutor."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EXEGGCUTOR)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Eevee"
    Kernel.pbMessage(_INTL("Eevee evolves into Leafeon."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:LEAFEON)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Nuzleaf"
    Kernel.pbMessage(_INTL("Nuzleaf evolves into Shiftry."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SHIFTRY)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Pansage"
    Kernel.pbMessage(_INTL("Pansage evolves into Semisage."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SEMISAGE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Cherubi"
    Kernel.pbMessage(_INTL("Cherubi evolves into Cherrim."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:STEENEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
     when "Bounsweet"
    Kernel.pbMessage(_INTL("Bounsweet evolves into Steenee."))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:CHERRIM)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
	 else
    Kernel.pbMessage(_INTL("That does not seem to be able to evolve with this stone."))
  end
end


def pbEeveelution
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Eevee"
    Kernel.pbMessage(_INTL("We can't do anything with Eevee, just Eeveelutions."))
	
     when "Jolteon","Vaporeon","Sylveon","Leafeon","Flareon","Glaceon","Umbreon","Espeon"
    Kernel.pbMessage(_INTL("Stand back!"))
	pkmn=$Trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EEVEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
	 else
    Kernel.pbMessage(_INTL("That... isn't an Eevee"))
  end
end


def pbDayChecker(month,day,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month && d == day #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
 end

def pbIndigoPlateauDays(month1,day1,day2,day3,day4,day5,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month1 && d == day2 || m == month1 && d == day3 || m == month1 && d == day4 || m == month1 && d == day5  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end

def pbIndigoPlateauDays2(month1,day1,month2,day2,month3,day3,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month2 && d == day2 || m == month3 && d == day3  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end




	
def pbNextChampionShip
    $game_variables[421]=rand(40)
end





def pbOakFix
  pbChoosePokemon(1,3)
  pkmn = pbGetPokemon(1)
  pkmn.permaFaint=false
  pkmn.heal_HP
  $game_variables[472] = pkmn.clone
  if $Trainer.firstPokemon.isSpecies?(:pkmn)
     $Trainer.remove_pokemon_at_index(0)
  elsif $Trainer.secondPokemon.isSpecies?(:pkmn)
     $Trainer.remove_pokemon_at_index(1)
  elsif $Trainer.thirdPokemon.isSpecies?(:pkmn)
     $Trainer.remove_pokemon_at_index(2)
  elsif $Trainer.fourthPokemon.isSpecies?(:pkmn)
     $Trainer.remove_pokemon_at_index(3)
  elsif $Trainer.fifthPokemon.isSpecies?(:pkmn)
     $Trainer.remove_pokemon_at_index(4)
  elsif $Trainer.sixthPokemon.isSpecies?(:pkmn)
     $Trainer.remove_pokemon_at_index(5)
  end
end




#===============================================================================
# Check compatibility of Pokémon in the Day Care.
#===============================================================================




def pbIsDitto2?(pkmn)
  return pkmn.species_data.egg_groups.include?(:Ditto)
end

def pbCompatibleGender?(pkmn1, pkmn2)
  return true if pkmn1.female? && pkmn2.male?
  return true if pkmn1.male? && pkmn2.female?
  ditto1 = pbIsDitto?(pkmn1)
  ditto2 = pbIsDitto?(pkmn2)
  return true if ditto1 && !ditto2
  return true if ditto2 && !ditto1
  return false
end

def pbBreedingGetCompat
  return 0 if $game_variables[496] < 2
  pkmn1 = $game_variables[497]
  pkmn2 = $game_variables[498]
  # Shadow Pokémon cannot breed
  return 0 if pkmn1.shadowPokemon? || pkmn2.shadowPokemon?
  # Pokémon in the Undiscovered egg group cannot breed
  egg_groups1 = pkmn1.species_data.egg_groups
  egg_groups2 = pkmn2.species_data.egg_groups
  return 0 if egg_groups1.include?(:Undiscovered) ||
              egg_groups2.include?(:Undiscovered)
  # Pokémon that don't share an egg group (and neither is in the Ditto group)
  # cannot breed
  return 0 if !egg_groups1.include?(:Ditto) &&
              !egg_groups2.include?(:Ditto) &&
              (egg_groups1 & egg_groups2).length == 0
  # Pokémon with incompatible genders cannot breed
  return 0 if !pbCompatibleGender?(pkmn1, pkmn2)
  # Pokémon can breed; calculate a compatibility factor
  ret = 1
  ret += 1 if pkmn1.species == pkmn2.species
  ret += 1 if pkmn1.owner.id != pkmn2.owner.id
  return ret
end

def pbDayCareGetCompatibility(variable)
  $game_variables[variable] = pbBreedingGetCompat
end


def pbBreedingGetCompat1
  return 0 if $game_variables[496] < 4
  pkmn1 = $game_variables[499]
  pkmn2 = $game_variables[500]
  # Shadow Pokémon cannot breed
  return 0 if pkmn1.shadowPokemon? || pkmn2.shadowPokemon?
  # Pokémon in the Undiscovered egg group cannot breed
  egg_groups1 = pkmn1.species_data.egg_groups
  egg_groups2 = pkmn2.species_data.egg_groups
  return 0 if egg_groups1.include?(:Undiscovered) ||
              egg_groups2.include?(:Undiscovered)
  # Pokémon that don't share an egg group (and neither is in the Ditto group)
  # cannot breed
  return 0 if !egg_groups1.include?(:Ditto) &&
              !egg_groups2.include?(:Ditto) &&
              (egg_groups1 & egg_groups2).length == 0
  # Pokémon with incompatible genders cannot breed
  return 0 if !pbCompatibleGender?(pkmn1, pkmn2)
  # Pokémon can breed; calculate a compatibility factor
  ret = 1
  ret += 1 if pkmn1.species == pkmn2.species
  ret += 1 if pkmn1.owner.id != pkmn2.owner.id
  return ret
end

def pbDayCareGetCompatibility(variable)
  $game_variables[variable] = pbBreedingGetCompat
end

#===============================================================================
# Generate an Egg based on Pokémon in the Day Care.
#===============================================================================
def pbGenerateEggHome
  return if $game_variables[496] < 2
  raise _INTL("Can't store the egg.") if $Trainer.party_full?
  pkmn0 = $game_variables[497]
  pkmn1 = $game_variables[498]
  mother = nil
  father = nil
  babyspecies = nil
  ditto0 = pbIsDitto?(pkmn0)
  ditto1 = pbIsDitto?(pkmn1)
  if pkmn0.female? || ditto0
    mother = pkmn0
    father = pkmn1
    babyspecies = (ditto0) ? father.species : mother.species
  else
    mother = pkmn1
    father = pkmn0
    babyspecies = (ditto1) ? father.species : mother.species
  end
  # Determine the egg's species
  babyspecies = GameData::Species.get(babyspecies).get_baby_species(true, mother.item_id, father.item_id)
  case babyspecies
  when :MANAPHY
    babyspecies = :PHIONE if GameData::Species.exists?(:PHIONE)
  when :NIDORANfE, :NIDORANmA
    if GameData::Species.exists?(:NIDORANfE) && GameData::Species.exists?(:NIDORANmA)
      babyspecies = [:NIDORANfE, :NIDORANmA][rand(2)]
    end
  when :VOLBEAT, :ILLUMISE
    if GameData::Species.exists?(:VOLBEAT) && GameData::Species.exists?(:ILLUMISE)
      babyspecies = [:VOLBEAT, :ILLUMISE][rand(2)]
    end
  when :VULPIX
    if babyspecies == :VULPIX && father.hasType?(:ICE) && rand(100)<10
      egg.form = 1
    end
  end
  # Generate egg
  egg = Pokemon.new(babyspecies, Settings::EGG_LEVEL)
  # Randomise personal ID
  pid = rand(65536)
  pid |= (rand(65536)<<16)
  egg.personalID = pid
  # Inheriting form
  if [:BURMY, :SHELLOS, :BASCULIN, :FLABEBE, :PUMPKABOO, :ORICORIO, :ROCKRUFF, :MINIOR].include?(babyspecies)
    newForm = mother.form
    newForm = 0 if mother.isSpecies?(:MOTHIM)
    egg.form = newForm
  end
  # Inheriting Alolan form
  if [:RATTATA, :SANDSHREW, :VULPIX, :DIGLETT,
      :MEOWTH, :GEODUDE, :GRIMER, :PONYTA,
      :SLOWPOKE, :FARFETCHD, :MRMIME, :CORSOLA,
      :ZIGZAGOON, :DARUMAKA, :YAMASK, :STUNFISK].include?(babyspecies)
    if mother.form == 1
      egg.form = 1 if mother.hasItem?(:EVERSTONE)
    elsif father.species_data.get_baby_species(true, mother.item_id, father.item_id) == babyspecies
      egg.form = 1 if father.form == 1 && father.hasItem?(:EVERSTONE)
    end
    if mother.form == 2
      egg.form = 2 if mother.hasItem?(:EVERSTONE)
    elsif pbGetBabySpecies(father.species,mother.item,father.item)==babyspecies
      egg.form = 2 if father.form == 2 && father.hasItem?(:EVERSTONE)
    end
  end
  # Inheriting Moves
  moves = []
  othermoves = []
  movefather = father
  movemother = mother
  if pbIsDitto?(movefather) && !mother.female?
    movefather = mother
    movemother = father
  end
  # Initial Moves
  initialmoves = egg.getMoveList
  for k in initialmoves
    if k[0] <= Settings::EGG_LEVEL
      moves.push(k[1])
    elsif mother.hasMove?(k[1]) && father.hasMove?(k[1])
      othermoves.push(k[1])
    end
  end
  # Inheriting Natural Moves
  for move in othermoves
    moves.push(move)
  end
  # Inheriting Machine Moves
  if Settings::BREEDING_CAN_INHERIT_MACHINE_MOVES
    GameData::Item.each do |i|
      atk = i.move
      next if !atk
      next if !egg.compatible_with_move?(atk)
      next if !movefather.hasMove?(atk)
      moves.push(atk)
    end
  end
  # Inheriting Egg Moves
  babyEggMoves = egg.species_data.egg_moves
  if movefather.male?
    babyEggMoves.each { |m| moves.push(m) if movefather.hasMove?(m) }
  end
  if Settings::BREEDING_CAN_INHERIT_EGG_MOVES_FROM_MOTHER
    babyEggMoves.each { |m| moves.push(m) if movemother.hasMove?(m) }
  end
  # Volt Tackle
  lightball = false
  if (father.isSpecies?(:PIKACHU) || father.isSpecies?(:RAICHU)) &&
      father.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if (mother.isSpecies?(:PIKACHU) || mother.isSpecies?(:RAICHU)) &&
      mother.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if lightball && babyspecies == :PICHU && GameData::Move.exists?(:VOLTTACKLE)
    moves.push(:VOLTTACKLE)
  end
  moves = moves.reverse
  moves |= []   # remove duplicates
  moves = moves.reverse
  # Assembling move list
  first_move_index = moves.length - Pokemon::MAX_MOVES
  first_move_index = 0 if first_move_index < 0
  finalmoves = []
  for i in first_move_index...moves.length
    finalmoves.push(Pokemon::Move.new(moves[i]))
  end
  # Inheriting Individual Values
  ivs = {}
  GameData::Stat.each_main { |s| ivs[s.id] = rand(Pokemon::IV_STAT_LIMIT + 1) }
  ivinherit = []
  for i in 0...2
    parent = [mother,father][i]
    ivinherit[i] = :HP if parent.hasItem?(:POWERWEIGHT)
    ivinherit[i] = :ATTACK if parent.hasItem?(:POWERBRACER)
    ivinherit[i] = :DEFENSE if parent.hasItem?(:POWERBELT)
    ivinherit[i] = :SPECIAL_ATTACK if parent.hasItem?(:POWERLENS)
    ivinherit[i] = :SPECIAL_DEFENSE if parent.hasItem?(:POWERBAND)
    ivinherit[i] = :SPEED if parent.hasItem?(:POWERANKLET)
  end
  num = 0
  r = rand(2)
  2.times do
    if ivinherit[r]!=nil
      parent = [mother,father][r]
      ivs[ivinherit[r]] = parent.iv[ivinherit[r]]
      num += 1
      break
    end
    r = (r+1)%2
  end
  limit = (mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)) ? 5 : 3
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !ivinherit.include?(s.id) }
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
    parent = [mother,father][rand(2)]
    ivs[r] = parent.iv[r]
    ivinherit.push(r)
    num += 1
    break if num>=limit
  end
  # Inheriting nature
  new_natures = []
  new_natures.push(mother.nature) if mother.hasItem?(:EVERSTONE)
  new_natures.push(father.nature) if father.hasItem?(:EVERSTONE)
  if new_natures.length > 0
    new_nature = (new_natures.length == 1) ? new_natures[0] : new_natures[rand(new_natures.length)]
    egg.nature = new_nature
  end
  # Masuda method and Shiny Charm
  shinyretries = 0
  shinyretries += 5 if mother.shiny?
  shinyretries += 5 if father.shiny?
  shinyretries += 5 if father.owner.language != mother.owner.language
  shinyretries += 2 if GameData::Item.exists?(:SHINYCHARM) && $PokemonBag.pbHasItem?(:SHINYCHARM)
  if shinyretries>0
    shinyretries.times do
      break if egg.shiny?
      egg.personalID = rand(2**16) | rand(2**16) << 16
    end
  end
  # Inheriting ability from the mother
  if !ditto0 || !ditto1
    parent = (ditto0) ? father : mother   # The non-Ditto
    if parent.hasHiddenAbility?
      egg.ability_index = parent.ability_index if rand(100) < 60
    elsif !ditto0 && !ditto1
      if rand(100) < 80
        egg.ability_index = mother.ability_index
      else
        egg.ability_index = (mother.ability_index + 1) % 2
      end
    end
  end
  # Inheriting Poké Ball from the mother (or father if it's same species as mother)
  if !ditto0 || !ditto1
    possible_balls = []
    if mother.species == father.species
      possible_balls.push(mother.poke_ball)
      possible_balls.push(father.poke_ball)
    else
      possible_balls.push(pkmn0.poke_ball) if pkmn0.female? || ditto1
      possible_balls.push(pkmn1.poke_ball) if pkmn1.female? || ditto0
    end
    possible_balls.delete(:MASTERBALL)    # Can't inherit this Ball
    possible_balls.delete(:CHERISHBALL)   # Can't inherit this Ball
    if possible_balls.length > 0
      egg.poke_ball = possible_balls[0]
      egg.poke_ball = possible_balls[rand(possible_balls.length)] if possible_balls.length > 1
    end
  end
  # Set all stats
  egg.happiness = 120
  egg.iv = ivs
  egg.moves = finalmoves
  egg.calc_stats
  egg.obtain_text = _INTL("Found at home.")
  egg.name = _INTL("Egg")
  egg.steps_to_hatch = egg.species_data.hatch_steps
  egg.givePokerus if rand(65536) < Settings::POKERUS_CHANCE
  # Add egg to party
  $Trainer.party[$Trainer.party.length] = egg
end

def pbGenerateEggHome2
  return if $game_variables[496] < 4
  raise _INTL("Can't store the egg.") if $Trainer.party_full?
  pkmn0 = $game_variables[499]
  pkmn1 = $game_variables[500]
  mother = nil
  father = nil
  babyspecies = nil
  ditto0 = pbIsDitto?(pkmn0)
  ditto1 = pbIsDitto?(pkmn1)
  if pkmn0.female? || ditto0
    mother = pkmn0
    father = pkmn1
    babyspecies = (ditto0) ? father.species : mother.species
  else
    mother = pkmn1
    father = pkmn0
    babyspecies = (ditto1) ? father.species : mother.species
  end
  # Determine the egg's species
  babyspecies = GameData::Species.get(babyspecies).get_baby_species(true, mother.item_id, father.item_id)
  case babyspecies
  when :MANAPHY
    babyspecies = :PHIONE if GameData::Species.exists?(:PHIONE)
  when :NIDORANfE, :NIDORANmA
    if GameData::Species.exists?(:NIDORANfE) && GameData::Species.exists?(:NIDORANmA)
      babyspecies = [:NIDORANfE, :NIDORANmA][rand(2)]
    end
  when :VOLBEAT, :ILLUMISE
    if GameData::Species.exists?(:VOLBEAT) && GameData::Species.exists?(:ILLUMISE)
      babyspecies = [:VOLBEAT, :ILLUMISE][rand(2)]
    end
  when :VULPIX
    if babyspecies == :VULPIX && father.hasType?(:ICE) && rand(100)<10
      egg.form = 1
    end
  end
  # Generate egg
  egg = Pokemon.new(babyspecies, Settings::EGG_LEVEL)
  # Randomise personal ID
  pid = rand(65536)
  pid |= (rand(65536)<<16)
  egg.personalID = pid
  # Inheriting form
  if [:BURMY, :SHELLOS, :BASCULIN, :FLABEBE, :PUMPKABOO, :ORICORIO, :ROCKRUFF, :MINIOR].include?(babyspecies)
    newForm = mother.form
    newForm = 0 if mother.isSpecies?(:MOTHIM)
    egg.form = newForm
  end
  # Inheriting Alolan form
  if [:RATTATA, :SANDSHREW, :VULPIX, :DIGLETT,
      :MEOWTH, :GEODUDE, :GRIMER, :PONYTA,
      :SLOWPOKE, :FARFETCHD, :MRMIME, :CORSOLA,
      :ZIGZAGOON, :DARUMAKA, :YAMASK, :STUNFISK].include?(babyspecies)
    if mother.form == 1
      egg.form = 1 if mother.hasItem?(:EVERSTONE)
    elsif father.species_data.get_baby_species(true, mother.item_id, father.item_id) == babyspecies
      egg.form = 1 if father.form == 1 && father.hasItem?(:EVERSTONE)
    end
    if mother.form == 2
      egg.form = 2 if mother.hasItem?(:EVERSTONE)
    elsif pbGetBabySpecies(father.species,mother.item,father.item)==babyspecies
      egg.form = 2 if father.form == 2 && father.hasItem?(:EVERSTONE)
    end
  end
  # Inheriting Moves
  moves = []
  othermoves = []
  movefather = father
  movemother = mother
  if pbIsDitto?(movefather) && !mother.female?
    movefather = mother
    movemother = father
  end
  # Initial Moves
  initialmoves = egg.getMoveList
  for k in initialmoves
    if k[0] <= Settings::EGG_LEVEL
      moves.push(k[1])
    elsif mother.hasMove?(k[1]) && father.hasMove?(k[1])
      othermoves.push(k[1])
    end
  end
  # Inheriting Natural Moves
  for move in othermoves
    moves.push(move)
  end
  # Inheriting Machine Moves
  if Settings::BREEDING_CAN_INHERIT_MACHINE_MOVES
    GameData::Item.each do |i|
      atk = i.move
      next if !atk
      next if !egg.compatible_with_move?(atk)
      next if !movefather.hasMove?(atk)
      moves.push(atk)
    end
  end
  # Inheriting Egg Moves
  babyEggMoves = egg.species_data.egg_moves
  if movefather.male?
    babyEggMoves.each { |m| moves.push(m) if movefather.hasMove?(m) }
  end
  if Settings::BREEDING_CAN_INHERIT_EGG_MOVES_FROM_MOTHER
    babyEggMoves.each { |m| moves.push(m) if movemother.hasMove?(m) }
  end
  # Volt Tackle
  lightball = false
  if (father.isSpecies?(:PIKACHU) || father.isSpecies?(:RAICHU)) &&
      father.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if (mother.isSpecies?(:PIKACHU) || mother.isSpecies?(:RAICHU)) &&
      mother.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if lightball && babyspecies == :PICHU && GameData::Move.exists?(:VOLTTACKLE)
    moves.push(:VOLTTACKLE)
  end
  moves = moves.reverse
  moves |= []   # remove duplicates
  moves = moves.reverse
  # Assembling move list
  first_move_index = moves.length - Pokemon::MAX_MOVES
  first_move_index = 0 if first_move_index < 0
  finalmoves = []
  for i in first_move_index...moves.length
    finalmoves.push(Pokemon::Move.new(moves[i]))
  end
  # Inheriting Individual Values
  ivs = {}
  GameData::Stat.each_main { |s| ivs[s.id] = rand(Pokemon::IV_STAT_LIMIT + 1) }
  ivinherit = []
  for i in 0...2
    parent = [mother,father][i]
    ivinherit[i] = :HP if parent.hasItem?(:POWERWEIGHT)
    ivinherit[i] = :ATTACK if parent.hasItem?(:POWERBRACER)
    ivinherit[i] = :DEFENSE if parent.hasItem?(:POWERBELT)
    ivinherit[i] = :SPECIAL_ATTACK if parent.hasItem?(:POWERLENS)
    ivinherit[i] = :SPECIAL_DEFENSE if parent.hasItem?(:POWERBAND)
    ivinherit[i] = :SPEED if parent.hasItem?(:POWERANKLET)
  end
  num = 0
  r = rand(2)
  2.times do
    if ivinherit[r]!=nil
      parent = [mother,father][r]
      ivs[ivinherit[r]] = parent.iv[ivinherit[r]]
      num += 1
      break
    end
    r = (r+1)%2
  end
  limit = (mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)) ? 5 : 3
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !ivinherit.include?(s.id) }
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
    parent = [mother,father][rand(2)]
    ivs[r] = parent.iv[r]
    ivinherit.push(r)
    num += 1
    break if num>=limit
  end
  # Inheriting nature
  new_natures = []
  new_natures.push(mother.nature) if mother.hasItem?(:EVERSTONE)
  new_natures.push(father.nature) if father.hasItem?(:EVERSTONE)
  if new_natures.length > 0
    new_nature = (new_natures.length == 1) ? new_natures[0] : new_natures[rand(new_natures.length)]
    egg.nature = new_nature
  end
  # Masuda method and Shiny Charm
  shinyretries = 0
  shinyretries += 5 if mother.shiny?
  shinyretries += 5 if father.shiny?
  shinyretries += 5 if father.owner.language != mother.owner.language
  shinyretries += 2 if GameData::Item.exists?(:SHINYCHARM) && $PokemonBag.pbHasItem?(:SHINYCHARM)
  if shinyretries>0
    shinyretries.times do
      break if egg.shiny?
      egg.personalID = rand(2**16) | rand(2**16) << 16
    end
  end
  # Inheriting ability from the mother
  if !ditto0 || !ditto1
    parent = (ditto0) ? father : mother   # The non-Ditto
    if parent.hasHiddenAbility?
      egg.ability_index = parent.ability_index if rand(100) < 60
    elsif !ditto0 && !ditto1
      if rand(100) < 80
        egg.ability_index = mother.ability_index
      else
        egg.ability_index = (mother.ability_index + 1) % 2
      end
    end
  end
  # Inheriting Poké Ball from the mother (or father if it's same species as mother)
  if !ditto0 || !ditto1
    possible_balls = []
    if mother.species == father.species
      possible_balls.push(mother.poke_ball)
      possible_balls.push(father.poke_ball)
    else
      possible_balls.push(pkmn0.poke_ball) if pkmn0.female? || ditto1
      possible_balls.push(pkmn1.poke_ball) if pkmn1.female? || ditto0
    end
    possible_balls.delete(:MASTERBALL)    # Can't inherit this Ball
    possible_balls.delete(:CHERISHBALL)   # Can't inherit this Ball
    if possible_balls.length > 0
      egg.poke_ball = possible_balls[0]
      egg.poke_ball = possible_balls[rand(possible_balls.length)] if possible_balls.length > 1
    end
  end
  # Set all stats
  egg.happiness = 120
  egg.iv = ivs
  egg.moves = finalmoves
  egg.calc_stats
  egg.obtain_text = _INTL("Found at home.")
  egg.name = _INTL("Egg")
  egg.steps_to_hatch = egg.species_data.hatch_steps
  egg.givePokerus if rand(65536) < Settings::POKERUS_CHANCE
  # Add egg to party
  $Trainer.party[$Trainer.party.length] = egg
end

#===============================================================================
# Code that happens every step the player takes.
#===============================================================================
EventHandlers.add(:on_player_step_taken_can_transfer, :effefefefefehhttjyjjyjyjyyjjyjy,
  proc {
  # Make an egg available at the Day Care
  deposited = $game_variables[496]
  if deposited>=2 && $game_variables[494]==0
    $game_variables[494] = 0 if !$game_variables[495]
    $game_variables[495] += 1
    if $game_variables[495]==256
      $game_variables[495] = 0
      compatval = [0,20,50,70][pbBreedingGetCompat]
      if GameData::Item.exists?(:OVALCHARM) && $PokemonBag.pbHasItem?(:OVALCHARM)
        compatval = [0,40,80,88][pbBreedingGetCompat]
      end
      $game_variables[494] = 1 if rand(100)<compatval   # Egg is generated
    end
  end
  
  
  deposited = $game_variables[496]
  if deposited>=2 && $game_variables[494]==0
    $game_variables[494] = 0 if !$game_variables[495]
    $game_variables[495] += 1
    if $game_variables[495]==256
      $game_variables[495] = 0
      compatval = [0,20,50,70][pbBreedingGetCompat1]
      if GameData::Item.exists?(:OVALCHARM) && $PokemonBag.pbHasItem?(:OVALCHARM)
        compatval = [0,40,80,88][pbBreedingGetCompat1]
      end
      $game_variables[494] = 1 if rand(100)<compatval   # Egg is generated
    end
  end
})




ItemHandlers::UseInField.add(:PORTABLEPC,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if $game_switches[414] == true
    Kernel.pbMessage(_INTL("You already have an Item Crate placed, these take the same spot.",item))
    next 0
  else
   if maps.include?($game_map.map_id)
    Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
    $game_switches[406] = true
     next 3
  else
    Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
  end
})

ItemHandlers::UseInField.add(:BEDROLL,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[407] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:GRINDER,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[404] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:UPGRADEDCRAFTINGBENCH,proc { |item|
  maps = [10,20,40,97,41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[402] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})
ItemHandlers::UseInField.add(:MEDICINEPOT,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[405] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:FURNACE,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[403] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:CAULDRON,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[147] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:CRAFTINGBENCH,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[150] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:APRICORNCRAFTING,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[144] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})
ItemHandlers::UseInField.add(:CUTTER,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[411] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ITEMCRATE,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if $game_switches[406] == true
    Kernel.pbMessage(_INTL("You already have an Pokemon Crate placed, these take the same spot.",item))
    next 0
  else
   if maps.include?($game_map.map_id)
    Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
    $game_switches[414] = true
     next 3
  else
    Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
  end
})

ItemHandlers::UseInField.add(:SEWINGMACHINE,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[411] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ELECTRICPRESS,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[412] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})
ItemHandlers::UseInField.add(:APRICORNMACHINE,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[415] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ELECTRICFURNACE,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[416] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ELECTRICGRINDER,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[417] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:COALGENERATOR,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[409] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:SOLARGENERATOR,proc { |item|
  maps = [54]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[418] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:HYDROGENERATOR,proc { |item|
  maps = [54]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[419] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:WINDGENERATOR,proc { |item|
  maps = [54]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[420] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:POKEGENERATOR,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[421] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})







class Game_Map
  def spawnCraftingEvent(x,y)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    fname = ("Graphics/Characters/Object ball.png")
    event.pages[0].graphic.character_name = fname
    parameter = "pbCommonEvent(20)"
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_Event.new(@map_id, event, self)
    gameEvent.id = key_id
  
    @events[key_id] = gameEvent
  end
end




################################################################################
# Simple Exit Arrows - by Tustin2121
#
# To use, set the graphic of your exit warp event to an arrow with 
# the desired hue and name it "ExitArrow" (without the quotes). 
#
# The below code will do the work of hiding and showing the arrow when needed.
################################################################################



class Game_Character
  # Add accessors for some otherwise hidden options
  attr_accessor :step_anime
  attr_accessor :direction_fix
end
def pxCheckCraftingStations(init=false)
  px = $game_player.x
  py = $game_player.y
  for event in $game_map.events.values
  if (event.name[/^POT$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^POT$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^POT$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^POT$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^POT$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^CraftingTable$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Press$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^Press$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^Press$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^Press$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^Press$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^Sewing Machine$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^Cutter$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^PlaceHere$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^PlaceHere2$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^PlaceHere3$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^PlaceHere4$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^PlaceHere4$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^PlaceHere4$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^PlaceHere4$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^PlaceHere4$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif event.name[/^Grinder$/] && (pbCheckSelfSwitchState(event,a)!=true || pbCheckSelfSwitchState(event,b)!=true || pbCheckSelfSwitchState(event,c)!=true || pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^Grinder$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Crate$/] && pbCheckSelfSwitchState(event,a)!=true) || (event.name[/^Crate$/] && pbCheckSelfSwitchState(event,b)!=true) || (event.name[/^Crate$/] && pbCheckSelfSwitchState(event,c)!=true) || (event.name[/^Crate$/] && pbCheckSelfSwitchState(event,d)!=true)
    next if !event.name[/^Crate$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Egg1$/] && $game_switches[288]==true) 
    next if !event.name[/^Egg1$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Egg2$/] && $game_switches[289]==true) 
    next if !event.name[/^Egg2$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Egg3$/] && $game_switches[290]==true) 
    next if !event.name[/^Egg3$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Egg4$/] && $game_switches[291]==true) 
    next if !event.name[/^Egg4$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Egg5$/] && $game_switches[292]==true) 
    next if !event.name[/^Egg5$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif (event.name[/^Egg6$/] && $game_switches[293]==true) 
    next if !event.name[/^Egg6$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  elsif $game_switches[1]==true
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
  end
  end
  end

# Checks if the player is standing next to the exit arrow, facing it.
def pxCheckExitArrows(init=false)
  px = $game_player.x
  py = $game_player.y
  for event in $game_map.events.values
   if event.name[/^ExitArrow$/]
    next if !event.name[/^ExitArrow$/]
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
    end
    if init
      # This homogenizes the Exit Arrows to all act the same, that is
      # a slow flashing arrow. If you want to change the behavior, 
      # change the values below.
      event.move_speed = 1
      event.walk_anime = false
      event.step_anime = true
      event.direction_fix = true
    end
  else
    next if !event.name[/^Bedroll$/]
	next if !event.name[/^Bedroll(1,2)$/]
	next if !event.name[/^PokeStation(4,3)$/]
	next if !event.name[/^PokemonPlace$/]
	next if !event.name[/^Pokeball$/]
	next if !event.name[/^Furnace$/]
	next if !event.name[/^Grinder$/]
	next if !event.name[/^CraftingTable$/]
	next if !event.name[/^Press$/]
	next if !event.name[/^Sewing Machine$/]
	next if !event.name[/^Cutter$/]
	next if !event.name[/^PlaceHere$/]
	next if !event.name[/^PlaceHere2$/]
	next if !event.name[/^PlaceHere3$/]
	next if !event.name[/^Egg1$/]
	next if !event.name[/^Egg2$/]
	next if !event.name[/^Egg3$/]
	next if !event.name[/^Egg4$/]
	next if !event.name[/^Egg5$/]
	next if !event.name[/^Egg6$/]
	next if !event.name[/^PlaceHere$/]
	next if !event.name[/^POT$/]
	next if !event.name[/^Grinder$/]
	next if !event.name[/^Crate$/] 
    next if (event.name[/^Bedroll$/] && pbCheckSelfSwitchState(event,a)==true)
    next if (event.name[/^Bedroll$/] && pbCheckSelfSwitchState(event,b)==true)
    next if (event.name[/^Bedroll$/] && pbCheckSelfSwitchState(event,c)==true)
    next if (event.name[/^Bedroll$/] && pbCheckSelfSwitchState(event,d)==true)
    next if (event.name[/^Bedroll(1,2)$/] && pbCheckSelfSwitchState(event,a)==true)
    next if (event.name[/^Bedroll(1,2)$/] && pbCheckSelfSwitchState(event,b)==true)
    next if (event.name[/^Bedroll(1,2)$/] && pbCheckSelfSwitchState(event,c)==true)
    next if (event.name[/^Bedroll(1,2)$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^PokeStation(4,3)$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^PokeStation(4,3)$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^PokeStation(4,3)$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^PokeStation(4,3)$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^PokemonPlace$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^PokemonPlace$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^PokemonPlace$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^PokemonPlace$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Pokeball$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Pokeball$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Pokeball$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Pokeball$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Furnace$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Furnace$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Furnace$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Furnace$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^CraftingTable$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Press$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Press$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Press$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Press$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Sewing Machine$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Cutter$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^PlaceHere$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^PlaceHere2$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^PlaceHere3$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^POT$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^POT$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^POT$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^POT$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Grinder$/] && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Crate$/]  && pbCheckSelfSwitchState(event,a)==true)
	next if (event.name[/^Crate$/]  && pbCheckSelfSwitchState(event,b)==true)
	next if (event.name[/^Crate$/]  && pbCheckSelfSwitchState(event,c)==true)
	next if (event.name[/^Crate$/]  && pbCheckSelfSwitchState(event,d)==true)
	next if (event.name[/^Egg1$/] && $game_switches[288]==true) 
	next if (event.name[/^Egg2$/] && $game_switches[289]==true) 
	next if (event.name[/^Egg3$/] && $game_switches[290]==true) 
	next if (event.name[/^Egg4$/] && $game_switches[291]==true) 
	next if (event.name[/^Egg5$/] && $game_switches[292]==true) 
	next if (event.name[/^Egg6$/] && $game_switches[293]==true) 
	next if $game_switches[1]==true
    case $game_player.direction
      when 2 #down
        event.transparent = !(px==event.x && py==event.y-1)
      when 8 #up
        event.transparent = !(px==event.x && py==event.y+1)
      when 4 #left
        event.transparent = !(px==event.x+1 && py==event.y)
      when 6 #right
        event.transparent = !(px==event.x-1 && py==event.y)
  
  end
end
end
end
# Run on scene change, init them as well
EventHandlers.add(:on_map_or_spriteset_change, :ouukhlluh,
  proc {
  pxCheckExitArrows(true)
})

# Run on every step taken
EventHandlers.add(:on_leave_tile, :wagbshehe,
  proc {
  pxCheckExitArrows
})

def pbCheckName
name = pbEntryName(_INTL("What do you put?"), 0, Settings::MAX_PLAYER_NAME_SIZE)
if name.nil? || name.empty?
  return false
else
 $game_variables[4974]=name
  Kernel.pbMessage(_INTL("You are unsure on what it would have done."))
  return true
end
end
