## SYSTEMS CHECKLIST 
## X is complete, - is half complete, empty is not worked on.
### Quik Notes
- [ ] Map more of the Chilled Plains and Temperate Highlands
- [x] Change the cap for Pokemon spawns to be the inverse of what it currently is
- [ ] Charm moves invert targets team
- [x] Increase downtime timer for Mining Spots, right now they are just too good, tbf.
- [-] The item modifier infrastructure is updated, but we don't have a table for it, nor effects
- [ ] Aerial Ace is broken
- [ ] Bright Powder can be used to paralyze.
- [x] At Berry Pots and Berry Plants, Water Types water the plant while working, Grass tends to and harvests plants, while all other types to the same as Grass but weaker.
- [x] Fire Types can provide passive heat to furnaces.
- [ ] Ice Types can provide passive cold to Icebox/Electric Icebox
- [ ] Electric Types can provide electricity to PokeGenerators.
- [x] All Pokemon can work Grinders. Ground and Rock types have an improved rate.
- [ ] Graves, Cremation, etc
- [x] All types working at Pet Bed provide Passive Bonus to egg growth, fire types give slightly greater, one of the parents gives slightly greater, fire type with that one ability gives a large boost on top of existing ones.
- [x] All types working at Research table provide Passive Bonus to research Speed, serious Pokemon give a greater boost
- [ ] Rework Adventure screen.
- [ ] Make sure pokemon working in stations return to work after combat. Make sure guards aren't locked to STANDING at their station.
- [x] Butchering table

### Core Gameplay 
- [ ] Overhaul Happiness to be ephemerial.
- [ ] Too low happiness for too long begins dragging down loyalty.
- [ ] Too low loyalty for too long, and being unattended risks Pokemon abandoning you.
- [ ] You can assign Pokemon to tasks around the base.
- [ ] Pokemon moods.
- [ ] Pokemon nature impacts perferred food.

### UI
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


### Pokemon
- [ ] Pokemon Mood
- [ ] Released Pokemon Array and Released Pokemon events
- [ ] Update Adventure Various
- [ ] Fix Middle Mouse Selection

### Placeables
- [x] Pet bed (Needs UI)
- [x] Berry Pot (Needs UI)
- [ ] Machine Box UI
- [x] Figure out how Research Works
- [ ] Electronics UI


### Combat
- [x] Rework moveexecution to be within OverworldCombat::MoveExecution.
- [x] Combat state in battle_data, last used move, resetting counters, etc.
- [ ] Moves that need overworld state need it implmented.
- [ ] Finish move effects. (Requires combat state)
- [x] Rework loyalty and disobedience.
- [ ] Finish class effects
- [ ] Rework player damage calculation, perhaps use the ethos behind the safari damage system.
- [ ] Add natures to Safari Combat
- [ ] Rebuild Boss fight logic

### Buildings
- [ ] Player Base create for Oil Tanker needs to be AFTER the Rockets are defeated.
- [x] Add Shoreline equipment

### World
- [x] Fix Berry Plant updating
- [x] Check to see if crafting stations are working as intended.
- [x] FIX THE RENDERING PROBLEM ASSHOLE.
- [ ] Add cooldowns for Iron Axe and Trees + Collecting Acorns.
- [ ] Finish the internal data for items, like how much food it restores, the effect of the Pokeball.
- [ ] Move between two particular maps enough times and you get send to the Egg room.
- [-] Make simulated combat system
- [-] Raids
- [ ] Update weather for GameData::Zones
- [ ] Finish First Temple
- [ ] Rework Dungeons
- [x] Rework Berry Plants to work off of the Hotbar, rather than pbBerryPlant.


### Misc Mechanics
- [x] Statues still eat energy if you back out of saving.
- [ ] Drop items on death?
- [ ] Able to store food in placed pokemon storage so they can eat?
- [ ] Disease

### Items
- [x] Grooming Brush
- [ ] Whistle item that automatically selects all Pokemon
- [x] Bottle type items milk cows
- [x] Make sure food and water feed pokemon in harder modes.
- [x] Make Bait no longer a plant, but a crafted item from meat, when bait is thrown, it should cause a Crisis Battle if its on a Pokemon, if not, it should spawn a bait encounter.

 