## CURRENT_STATE 
## X is complete, - is half complete, empty is not worked on.
### Quik Notes
- [x] Change the cap for Pokemon spawns to be the inverse of what it currently is
- [x] Increase downtime timer for Mining Spots, right now they are just too good, tbf.
- [x] Ponder button to tell you if a hovered item can be researched.
- [x] At Berry Pots and Berry Plants, Water Types water the plant while working, Grass tends to and harvests plants, while all other types to the same as Grass but weaker.
- [x] Fire Types can provide passive heat to furnaces.
- [x] All Pokemon can work Grinders. Ground and Rock types have an improved rate.
- [x] Graves, Cremation, etc
- [x] All types working at Pet Bed provide Passive Bonus to egg growth, fire types give slightly greater, one of the parents gives slightly greater, fire type with that one ability gives a large boost on top of existing ones.
- [x] All types working at Research table provide Passive Bonus to research Speed, serious Pokemon give a greater boost
- [x] Rework Adventure screen.
- [x] Make sure pokemon working in stations return to work after combat. 
- [x] Fix middle mouse selection
- [x] Butchering table
- [x] Placeable Stations Recipes

### Core Gameplay 
- [x] You can assign Pokemon to tasks around the base.
- [x] Electronics Connections and Electrical System

### UI
- [x] Electronics UI
- [x] Machine Box UI
- [x] Modifier Station Functionality  + UI, modifiers are highly complex if  they have stacks, and need their internal data deep cloned.
- [x] The item modifier infrastructure is updated, but we don't have a table for it, nor effects
- [x] Summary Screen Happiness, Loyalty, and Inventory rework.
- [x] Inventory Screen middle mouse click to open Pokemon inventory.
- [x] Slow the title screen pan down fuckwad its too fast (I can't.)
- [x] Fix the Tutorial.
- [x] Add Notebook and Inventory controls to the book
- [x] Do a notebook pass, and add the intro text to the notebook.
- [x] Animate title screen Pokemon (This was the continue menu not being animated)
- [x] Furnace fire UI lessens
- [x] Issue: Crafting using an item that originated from the crafting station will make you lose the item.
- [x] Right clicking with an item on its original position just places it back down.
- [x] Prevent placables from stacking
- [x] Fix Middle Mouse Selection
- [x] Update Options Menu and Controls Menu
- [x] Make Relearn Screen a conventional Inventory screen, just without inventory.

### Pokemon
- [x] Possible relearnable move storage

### Sprites
- [x] Berry Pot 
- [x] Hydro Generator
- [x] Wind Generator
- [x] Solar Generator
- [x] Electric Icebox
- [x] Apricorn Machine, will autofill recipes, but also needs Pokemon assigned to work properly.
- [x] Sewing Machine
- [x] Panner 
- [x] Electric Press: Presses items into prates.
- [x] Electric Sawmill: Cuts wood more effectively.
- [x] Electric Miner: A 3x3 rig that automines, but ruins soil quality around it. Cannot be placed within 4 tiles of water, and the noise increases Pokemon spawns, and cancels out warding totems. Can only be used on stone.
- [x] Sprinklers: Waters Berry Plants automatically.
- [x] Electric Pump: Pumps water out of water sources.
- [x] Sifter: Turns sand into other materials commonly found in sand.
- [x] Electric Sifter: Turns sand into other materials commonly found in sand.
- [x] Electric Water Purifier: Turns Water pumped in into Purified water.

### Placeables
- [x] Electric Types can provide electricity to PokeGenerators.
- [x] Graves have a low chance of respawning as a Ghost Type
- [x] Pet bed 
- [x] Berry Pot 
- [x] Hydro Generator
- [x] Wind Generator
- [x] Solar Generator
- [x] Figure out how Research Works
- [x] Apiaries improve likelihood of berry plant crossbreeding
- [x] Sewing Machine
- [x] Electric Press: Presses items into plates.
- [x] Electric Sawmill: Cuts wood more effectively.
- [x] Apricorn Machine, will autofill recipes, but also needs Pokemon assigned to work properly.
- [x] Sifter: Turns sand into other materials commonly found in sand.
- [x] Electric Sifter: Turns sand into other materials commonly found in sand.
- [x] Sifted Ore.
- [x] Panner 
- [x] Electric Miner: A 3x3 rig that automine. Can only be used on stone.
- [-] Electric Icebox
- [x] Poke Generator
- [x] Outdoor Pet Beds close to diggable terrain, with a Rock or Ground type will go around digging up sand.
- [x] Pipes, the equalvent of Cables. Can be used to pipe water.
- [x] Remove Upgrade Slots from Machine Box
- [x] Electric Pump: Pumps water out of water sources.
- [x] Electric Water Purifier: Turns Water pumped in into Purified water.
- [x] Electric Ore Washer
- [x] Sprinklers: Waters Berry Plants automatically.
- [x] Coal Generator: Different Fuel Types give different wattage output
- [x] Add Watering Cans to the tank system

### Combat
- [x] Rework moveexecution to be within OverworldCombat::MoveExecution.
- [x] Combat state in battle_data, last used move, resetting counters, etc.
- [x] Bright Powder can be used to paralyze.
- [x] Rework loyalty and disobedience.

### Buildings
- [x] Add Shoreline equipment

### World
- [x] Clean up directing Pokemon across map borders.
- [x] FIX THE RENDERING PROBLEM ASSHOLE.
- [x] Fix Berry Plant updating
- [x] Check to see if crafting stations are working as intended.
- [x] Rework Berry Plants to work off of the Hotbar, rather than pbBerryPlant.
- [x] Make the mining spot in the Ice Cave a *mining spot.* Maybe make that part of the room a mining spot???
- [x] Make simulated combat system
- [x] Update weather for GameData::Zones

### Misc Mechanics
- [x] Statues still eat energy if you back out of saving.
- [x] Renamable Items
- [x] Ambient Temp

### Items
- [x] Grooming Brush
- [x] Whistle item that automatically selects all Pokemon
- [x] Bottle type items milk cows
- [x] Make sure food and water feed pokemon in harder modes.
- [x] Make Bait no longer a plant, but a crafted item from meat, when bait is thrown, it should cause a Crisis Battle if its on a Pokemon, if not, it should spawn a bait encounter.

 