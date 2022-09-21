

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
