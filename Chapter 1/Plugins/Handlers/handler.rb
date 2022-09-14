EventHandlers.add(:on_player_step_taken_can_transfer, :effefefefefehhttrfeeffeeffefej,
  proc {
  if $PokemonSystem.playermode == 0 
     if $player.demotimer <= 0 && $game_temp.in_menu == false
	     pbMessage(_INTL("Beep! Beep! Beep! Beep! Beep!"))
	     pbMessage(_INTL("It sounds like an alarm."))
    $game_temp.player_new_map_id    = 1
    $game_temp.player_new_x         = 22
    $game_temp.player_new_y         = 3
    $game_temp.player_new_direction = 1
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
	Game.save
	$PokemonSystem.playermode = 1 
	$scene = pbCallTitle
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
	 else
     $player.demotimer = $player.demotimer.to_i-1
	 end
end


})

def pbRandomEvent
   if rand(100) == 1
     Kernel.pbMessage(_INTL("There was a sound outside."))   #Comet
     $game_switches[450]==true 
     $game_switches[451]==true 
=begin
   elsif rand(1000) == 2
     
   elsif rand(1000) == 3
     
   elsif rand(1000) == 4
     
   elsif rand(1000) == 5
     
   elsif rand(1000) == 6
=end
end
end

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


def pbGrassEvolutionStone
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Gloom"
    Kernel.pbMessage(_INTL("Gloom evolves into Vileplume."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VILEPLUME)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Weepingbell"
    Kernel.pbMessage(_INTL("Weepingbell evolves into Victreebell."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VECTREEBEL)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Exeggcute" 
    Kernel.pbMessage(_INTL("Exeggcute evolves into Exeggcutor."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EXEGGCUTOR)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Eevee"
    Kernel.pbMessage(_INTL("Eevee evolves into Leafeon."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:LEAFEON)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Nuzleaf"
    Kernel.pbMessage(_INTL("Nuzleaf evolves into Shiftry."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SHIFTRY)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Pansage"
    Kernel.pbMessage(_INTL("Pansage evolves into Semisage."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SEMISAGE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Cherubi"
    Kernel.pbMessage(_INTL("Cherubi evolves into Cherrim."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:STEENEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
     when "Bounsweet"
    Kernel.pbMessage(_INTL("Bounsweet evolves into Steenee."))
	pkmn=$player.party[$game_variables[1]]
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
	pkmn=$player.party[$game_variables[1]]
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
