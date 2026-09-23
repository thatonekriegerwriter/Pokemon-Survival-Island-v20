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
- [x] Feeder UI
- [x] Machine Box UI
- [x] Guard Post UI
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
- [x] Too low happiness for too long begins dragging down loyalty.
- [x] Overhaul Happiness to be ephemerial.
- [x] Update happiness calls to call loyalty mods depending on circumstances.
- [-] Bridge Aware.
- [x] Possible relearnable move storage
- [x] Verify Pokemon sending out in the water.
- [-] Hide the Stats page? Or at least lock some of it behind items.
- [x] pkmn.ability can be used to override ability_index, meaning a Pokemon COULD recieve an ability from a parent that isn't the same species using that.

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
- [x] Prep Station: A modifier station but for modification of food, having a higher modifier yield, but once something is modified, it can't be *unmodified.*  (Req: Item Data)
- [x] Bees decrease likelhood of pest spawns
- [x] Make sure guards aren't locked to STANDING at their station + Functionality.
- [x] Electric Types can provide electricity to PokeGenerators.
- [x] Graves have a low chance of respawning as a Ghost Type
- [x] Pet bed 
- [x] Berry Pot 
- [x] Feeder functionality
- [x] Hydro Generator
- [x] Wind Generator
- [x] Solar Generator
- [x] Figure out how Research Works
- [x] Apiaries improve likelihood of berry plant crossbreeding
- [x] Sewing Machine
- [x] Electric Press: Presses items into plates.
- [x] Electric Sawmill: Cuts wood more effectively.
- [x] Spawn Pest for Berry Plant
- [x] Apricorn Machine, will autofill recipes, but also needs Pokemon assigned to work properly.
- [x] Sifter: Turns sand into other materials commonly found in sand.
- [x] Electric Sifter: Turns sand into other materials commonly found in sand.
- [x] Sifted Ore.
- [x] Humanlike OR Psychic for Apricorn Machine
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
- [x] Torches lower spawn rates, but do not prevent them.

### Combat
- [x] Rework moveexecution to be within OverworldCombat::MoveExecution.
- [x] Combat state in battle_data, last used move, resetting counters, etc.
- [x] Bright Powder can be used to paralyze.
- [x] Rework loyalty and disobedience.

### Buildings
- [x] Add Shoreline equipment

### World
- [x] Lock off unavailable statues (Safety for later demo releases)
- [x] Clean up directing Pokemon across map borders.
- [x] FIX THE RENDERING PROBLEM ASSHOLE.
- [x] Fix Berry Plant updating
- [x] Check to see if crafting stations are working as intended.
- [x] Rework Berry Plants to work off of the Hotbar, rather than pbBerryPlant.
- [x] Make the mining spot in the Ice Cave a *mining spot.* Maybe make that part of the room a mining spot???
- [x] Make simulated combat system
- [x] Update weather for GameData::Zones
- [x] Test Mineshaft
- [x] Block off areas

### Misc Mechanics
- [x] Statues still eat energy if you back out of saving.
- [x] Renamable Items
- [x] Ambient Temp

### Items
- [x] Finish the internal data for items. (Pokeball Done. Berry framework done, not details, but those arent required. Styler done. Important part of weapons done. Consumable incomplete.
- [x] Ocean Trading Xatu
- [x] Grooming Brush
- [x] Harvestable Cherubi Ball, Slowpoke Tail, and Chansey Egg, and Leek. Tropius.
- [x] Update Adventure Manual
- [x] Whistle item that automatically selects all Pokemon
- [x] Bottle type items milk cows
- [x] Make sure food and water feed pokemon in harder modes.
- [x] Make Bait no longer a plant, but a crafted item from meat, when bait is thrown, it should cause a Crisis Battle if its on a Pokemon, if not, it should spawn a bait encounter.
- [x] Limit Pokeball throw range based on internal stat
- [x] Limit Pokeball height based on internal stat
- [x] Change Pokeball Stamina cost based on internal stat
- [x] Change Pokeball Catch Rate based on internal stat
- [x] Change Pokeball Catch Starting Happiness based on quality
- [x] Change Pokeball $bag.remove likelihood based on recoverable.
- [x] Refresh Capture Styler 'health' over time, or by putting it in a electric machine.
- [x] Update Crossbreeding paths, this needs internal data for plants. (Req: Item Data)
- [x] Check and Update food for Cherubi Ball, Slowpoke Tail, and Chansey Egg, and Leek. Tropius Banana.
- [x] Fill out consumable flavor, and berry flavour
- [x] Berry Plant dominance and recessiveness
- [x] Check if we like the mutation table for berries

 ### Player Classes
- [-] Gain PlayerEXP from other things. 
- [x] Cap player class level at 20, remove shadow Pokemon cap.
 
 - [x] Level 0 - Actors pokemon have a chance to not use PP when the Actor is not acting.
- [-] Level 5 - Actors can take on the role of another class for a day. They can't use all abilities, just specific ones. Three Days cooldown.
- [x] Level 10 - Changes cooldown to two days.
- [x] Level 15 - Changes cooldown to one day.
- [x] Level 20 - No cooldown.


- [x] Level 0 - Tri-Athletes are as fast as a pair of running shoes while running. (Actable)
- [x] Level 5 - Tri-Athletes use less stamina while running.
- [x] Level 10 - Tri-Athletes have an improved stamina recovery rate while moving.
- [x] Level 15 - Tri-Athletes move faster both normally and while running. (Actable)
- [x] Level 20 - If a Pole is held, and you are running, you naturally vault objects.


- [x] Level 0 - Experts have a fully filled out Journal, even if they haven't caught everything in an area.
- [x] Level 5 - Experts Pokemon gain experience at a doubled rate if working at a station. (Actable)
- [x] Level 20 - Experts don't have level caps on Pokemon. (Remove level cap setting in settings, I think)


- [x] Level 0 - Coordinator - 'You perform moves with style that can awe your foes, and your teamwork with your POKeMON on the Overworld is supreme.' (No Disobedience)  (Actable)
- [x] Level 5 - Coordinator - Your POKeMON's Happiness decays slower. half negative gain on happiness loss
- [x] Level 10 - Coordinator - A Coordinators Pokemon does not lose loyalty from happiness loss, only things that target loyalty directly.
- [x] Level 15 - Coordinator - Coordinators Pokemon gain more loyalty and happiness from positive interactions.  (Actable)
- [x] Level 20 - Coordinator - A Coordinators Pokemon can awe enemies into joining them during Adventures or in Dungeons.


- [x] Level 0 - Gardener - Plants you care for will always give a berry back if they die, or you dig them up.
- [x] Level 5 - Gardener - All Berries you have planted will grow slightly faster.  (Actable)
- [x] Level 10 - Gardener - You will never get pests or weeds on your plants.
- [x] Level 15 - Gardener - Your Pokemon, if assigned to a plant, give larger bonuses, and don't use PP for watering, if applicable. (Actable)
- [x] Level 20 - Gardener - Your plants will be able to grow irregardless of environmental conditions (No need for local water).


- [x] Level 0 - Collector - You will find twice as many items when scavenging.  (Actable)
- [x] Level 5 - Collector - You have a chance not to use a consumable item.
- [x] Level 10 - Collector - You will have a higher chance to find rare items while scavenging.
- [x] Level 15 - Collector - You will come across currency more often. (Right now this just means Collectors can find Star Pieces in any mines)  (Actable)
- [x] Level 20 - Collector - You can find items that would otherwise be unavailable in an area.


- [x] Level 0 - Hiker - When holding a Pole, you move faster in mountainous areas.
- [x] Level 5 - Hiker - Overworld Ore will occasionally give double.  (Actable)
- [x] Level 10 - Hiker - When mining in a mineshaft, you have more hits before the mine collapses, and have more items in your mines.  (Actable)
- [x] Level 15 - Hiker - When in a cave with a mineshaft, Pokemon spawns are dramatically lowered.
- [x] Level 20 - Hiker - Quarries produce twice as many items.


- [x] Level 0 - Engineer - You can craft most machines without Machine Boxes.
- [x] Level 10 - Engineer - PokeGenerators have a higher effectiveness.  (Actable)


- [x] Level 0 - Breeder - Eggs will hatch faster for you by default.  (Actable)
- [x] Level 5 - Breeder - Has an improved groom action when using a grooming brush.
- [x] Level 10 - Breeder - Pokemon that are working that still breed eggs.
- [x] Level 15 - Breeder - Pokémon are more likely to produce an Egg.
- [x] Level 20 - Breeder - Pokémon can produce Eggs irregardless of if two Pokemon can normally breed.  (Actable)


- [x] Level 0 - Nurse - Sleeping and health items recover more health for both you and your POKeMON.  (Actable)
- [x] Level 5 - Nurse - Petting or Grooming your Pokemon restores their health.
- [x] Level 10 - Nurse - Pokemon always fully heal in bed. (Pokemon cannot die of damage in their sleep, but can of old age, and not being secured in the overworld.)  (Actable)
- [x] Level 15 - Nurse - You passively heal while on the Overworld. This is implimented just... check it. Make sure it isn't busted. Add this to not work while in combat.
- [x] Level 20 - Nurse - Full Restores restore your max health to its max value.


- [x] Level 0 - Fisher - You can even get meat off of a Magikarp.
- [x] Level 5 - Fisher - You catch things faster while fishing.
- [x] Level 10 - Fisher - Fishing up items increases in likelihood.  (Actable)
- [x] Level 15 - Fisher - You can encounter fish while fishing that are one rank higher than your current Rod.  (Actable)
- [x] Level 20 - Fisher - You have the option to avoid a Pokemon encounter while fishing.


- [x] Level 5 - Cook - When in a Crisis Battle, you can feed Pokemon to connect with them. (Associated functionality may not implimented for demo)
- [x] Level 10 - Cook - Food made by a cook keeps extremely well (No Spoiling by age or prep station)
- [x] Level 20 - Cook - Cooks produce twice as much food when cooking food items.


- [x] Level 0 - Black Belt - you can use various forms of punches.
- [x] Level 5 - Black Belt - Punch type moves have far less stamina cost.  (Actable)
- [x] Level 10 - Black Belt - Black Belts have higher accuracy with Punch Type moves.
- [x] Level 15 - Black Belt - Black Belts can block with their fists in the place of a Buckler, causing their incoming damage to be reduced.  (Actable)
- [x] Level 20 - Black Belt - When Blocking with fists, and attacked,  Black Belts will counter with a basic punch.


- [x] Level 0 - Rangers have a Capture Styler. Pokeballs are blocked from use. Rangers only have Pokemon temporarily. Once a Pokemon is 'partnered' it needs an internal timer. This alters combat fundamentally.
- [x] Level 5 - Rangers need a way to mark a Pokemon as a 'partner' which makes them never leave, but you can only have one. (Actable)
- [x] Level 10 - Rangers can flee turnbased combat (almost) anytime.
- [x] Level 20 - Second Partner. (Actable)



 ### PlayerEXP
 - [x] Gardener - Harvesting a berry plant, bonus for mutation) 
 - [x] Cook — cooking a recipe
 - [x] Engineer — crafting a machine
 - [x] Breeder — an egg successfully produced (perform_breeding); an egg hatched
 - [x] Ranger — capturing with the Capture Styler; a successful Assist (once built)
 - [x] Fisher — a successful catch while fishing
 - [x] Collector — a successful scavenging pull (pbCollectionMain/pbCollectionMain2); a successful comet pull
 - [x] Hiker — a successful mine hit (ov_mining/ov_mining2); clearing a mining spot
 - [x] Coordinator — a successful happiness/loyalty gain interaction; successfully awe-recruiting an ally
 - [x] Nurse — healing a Pokémon via bed, item, with cooldown.
 - [x] Tri-Athlete — distance covered while running; you're already tracking distance_walked/distance_cycled/distance_surfed, so this could be "every N tiles run, grant exp" rather than a new counter. 