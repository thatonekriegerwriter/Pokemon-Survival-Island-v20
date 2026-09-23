## SYSTEMS CHECKLIST 
## X is complete, - is half complete, empty is not worked on.
### Core Gameplay 
- [-] Finish Player Classes

### UI
- [ ] Record Demo, and patch back in video player in Scene_Intro (130) - pbPlayIntroVideo
- [ ] Xatu give radiant quests and give you Star Pieces if you beat them?
- [ ] Rework Xatu quest to be data driven.
- [ ] Quest to repair statue
- [ ] Reputation System?


### Pokemon
- [ ] Custom Evolutions (remember to patch back in leafstone)
- [ ] Stations use https://bulbapedia.bulbagarden.net/wiki/Performance
- [ ] Released Pokemon Array and Released Pokemon events
- [ ] Add Releasing
- [ ] Early Pokemon Evolution
- [ ] Update Foreign Pokemon for Encounter Spawns. Add "Papas" Togepi.
- [ ] Trade evolution Pokemon
- [ ] Pokemon Tasks
- [ ] Allow Pokemon to be spawnable by Pokeball on other maps
- [ ] Milking station can just be Pet Bed + Pokemon that has hands or a psychic
- [ ] Potential
- [ ] Bees do not work at night
- [ ] Too low loyalty for too long, and being unattended risks Pokemon abandoning you.
- [ ] Pokemon Mood
- [ ] Limit HMs based on physical features


### Placeables
- [ ] FLAG - Right now, Pokemon only 'sleep' while you share maps with them, a Pokemon working on another map will basically work forever. There does need to be some level of "catch up simulation" when a map is loaded so you don't get 100% effectiveness of your Stationed Pokemon just because you aren't standing by them. Simulated Stamina Loss/Rest Time.
- [ ] Shelf - Allows you to store multiple crates in one position.
- [ ] Punch Bag
- [ ] Ice Types can provide passive cold to Icebox/Electric Icebox. This requires a rewriting of IceBox data I don't want to do.
- [ ] Steam Engine: Upgraded Water Mill that is just https://tekkitclassic.fandom.com/wiki/Water_Strainer + https://tekkitclassic.fandom.com/wiki/Steam_Engine has to have water pumped in.
- [ ] Geothermal Generator/Combustion Engine: https://tekkitclassic.fandom.com/wiki/Geothermal_Generator + https://tekkitclassic.fandom.com/wiki/Combustion_Engine Must be placed on lava and powered.
- [ ] Biogas Engine: https://feed-the-beast.fandom.com/wiki/Biogas_Engine Can be given various things like honey and used to generate power.
- [ ] Engines: Engines require an existing power source to fuel it, but it takes its two inputs, and outputs even more power.
- [ ] Make adventure output work like Quarry. Unsure.

### Character

### Combat
- [ ] Battle Styles for Overworld
- [ ] Focus Meter for Overworld
- [ ] Move Mastery for Overworld
- [ ] Moves that need overworld state need it implmented.
- [ ] Finish move effects. (Requires combat state)
- [ ] Finish class effects
- [ ] Rework player damage calculation, perhaps use the ethos behind the safari damage system.
- [ ] Add natures to Safari Combat
- [ ] Rebuild Boss fight logic
- [ ] reeval Boss Fight for Rangers
- [ ] Create Modifier and Effects
- [ ] Check if Aerial Ace is broken
- [ ] Charm moves invert targets team



### Buildings
- [ ] Player Base create for Oil Tanker needs to be AFTER the Rockets are defeated.

### World
- [ ] Make sure S.S Glittering is accessible
- [-] Update Mineshaft UI. (Needs player stats and way to refresh weapon)
- [ ] Outbreaks
- [ ] Update Dungeons (Possibly can move to later)
- [ ] Define Phenomena
- [ ] For maps with identical encounter lists, uses Encounter Alias
- [ ] Hostile Pokemon crossing borders
- [ ] Fix the map of the Chilled Plains and Temperate Highlands
- [ ] Add Dungeon Under the Xatu Town
- [ ] Overhaul the injured Xatu.
- [ ] Lineage Collector Xatu, has items concerned with Pokemon growth, families, and inheritance, keep 1-2 items consistent.
- [ ] Survival Collector Xatu, has items concerned with survival in the Highlands, keep 1-2 items consistent.
- [ ] The Wandering Xatu, has random items available on the island, is uncommon.
- [ ] The Foraging Xatu, has random berries, herbs, cooking ingredients.
- [ ] The Mining Xatu, has random stones, ores, etc.
- [ ] The Dungeon Xatu, has dungeon stock.
- [ ] Give the Xatu schedules.
- [ ] Move between two particular maps enough times and you get send to the Egg room.
- [ ] Remap western temperate and bee forest
- [ ] Rework Dungeons
- [-] Raids
- [-] Fix held item across map boundries, there is slight visual jitter, but its fine

### Misc Mechanics
- [ ] Disease

### Items
- [ ] Wide Lens for Seed Analyzer (Req: Item Data for Seeds, which is complete)
- [ ] Zoom Lens for Bee Analyzer (Req: More Complex Bee Data for Bee type Pokemon)
- [ ] Scope Lens for Pokemon Analyzer (Req: Nothing, all prereqs complete)
- [ ] New Sewing Machine recipe for clothes.
- [ ] Reshellable Balls
- [ ] Cell Battery for Battery, and charge battery in machine 
- [ ] Capture Styler charging
- [ ] Blow Dart & Generic Dart
- [ ] Pokeball Trap
- [ ] Pokemon nature impacts perferred food, feeding them preferred food makes them happier, and their unpreferred food unhappy. (Req Consumable Data)
- [ ] Modifiers for Food require a Prep Station. (Req: Item Data)
 
 ### Food 
- [ ] other bee byproducts.
- [ ] More foods
 
 ### Player Classes


- [ ] Level 10 - Experts allow Pokemon to learn "Potential Moves"  (Associated functionality may not implimented for demo)
- [ ] Level 15 - Experts allow certain Pokemon to evolve early. (Actable) (Associated functionality may not implimented for demo)


- [ ] Level 5 - Engineer - Portable devices drain power slower. (Associated functionality not implimented for demo)
- [ ] Level 15 - Engineer - Pokemon assigned to Pokemon Generators cannot run away.  (Actable) (Associated functionality not implimented for demo)
- [ ] Level 20 - Engineer - Pokemon will not run away when assigned to work at any station.  (Associated functionality not implimented for demo)


- [ ] Level 0 - Cook - Feeding Pokemon improves their mood, and its happiness. (Actable) (Associated functionality may not implimented for demo)
- [ ] Level 15 - Cook - Food made by a Cook produces stronger modifiers at the Prep Station. (Current buff +1 basically) (Actable)

- [ ] Level 15 - The Styler unlocks "Assists".  (Associated functionality not implimented for demo)
 
 
 
 ### PlayerEXP
 - [ ] Expert — completing a Journal task (you already have num_tasks_completed) 
 - [ ] Cook — feeding a Pokémon with cooldown
 - [ ] Black Belt — landing a punch-type move in battle (once punches exist)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 For example, the Xatu don't need elaborate schedules. Small changes can sell life:

One Xatu is near the shop in the morning, then later near the Temple.
A Xatu who normally sits outside occasionally moves indoors during bad weather.
Some Xatu are present during the day but absent at night.
A Xatu might be seen carrying something between buildings.
Two Xatu occasionally stand together and have a conversation.
A Xatu who is usually outside the village may return with a new item.

The player does not need a simulation. They need evidence that the simulation exists.

The other important thing is that Xatu are not humans.

A human village might feel wrong if everyone stood silently for hours.

A group of Xatu being still is actually more believable.

They are a species associated with observation, patience, and ritual. A Xatu standing somewhere and staring into the distance is not automatically suspicious.

The question is whether their stillness feels intentional.

A Xatu standing by a shrine:

"They are watching over something."

A Xatu standing next to a shop forever:

"This is a vending machine with feathers."

The village probably benefits from having roles more than activities.

A few examples:

The elder Xatu who is always near the Temple.
The Xatu who maintains the Statue.
The Xatu who watches the Mystery Dungeon entrance.
The Xatu who tends the village's few berry plants.
The Xatu who studies strange objects.
The Xatu who trains younger Pokémon.

They don't need to walk around constantly. They need to have a reason to be where they are.

The market is easier because commerce naturally creates movement:

traders arrive,
stock changes,
items disappear,
visitors come and go.

The rest of the village needs a different source of life.

I actually think your weekly traders could help because they create periodic disruption:

A player returns and thinks:

"Wait, that Xatu wasn't here before."

Then the village feels like a place where things happen.

Another possibility that fits your game especially well: let time matter.

If the player leaves for 20 in-game days and returns, the village should not look identical.

Not necessarily huge changes, but little things:

a repaired object,
a new decoration,
a different Xatu visiting,
a quest completed,
someone mentioning a past event.

Because your game already has birthdays and aging, the player is primed to notice time passing.

The funny thing is that your village's biggest strength is also its biggest danger.

Having Xatu as NPCs is memorable because they are not just random shopkeepers. They are the first sign that Pokémon are a society.

But once you make Pokémon into people, players start applying the same expectations they have for people.

They start asking:

"What does this Xatu do when I'm not here?"

You probably don't need to answer that for every single one.

You just need enough small signals that the answer feels like:

"Something."







I think what the most interesting answer for how Sun would open up a Shadow Pokemons heart is just telling the player to do the exact things they do with every other Pokemon. People keep saying "It's Heart is closed"

Sun could just say "You haven't given it a reason to open it yet."

That is probably one of the strongest possible answers for Sun Aipom because it completely reframes what a Shadow Pokémon is.

Most purification narratives treat the Shadow state as a lock:

"The heart is closed. Find the key."

Sun Aipom's answer would be:

"Why are you looking for a key? You haven't knocked yet."

The distinction is huge.

The Xatu/technical perspective might see Shadow Pokémon as a condition:

corrupted bond,
artificial closure,
blocked connection,
something to be repaired.

Sun Aipom sees it as a relationship:

this Pokémon has been hurt,
this Pokémon does not trust you,
this Pokémon has no reason to open up.

And those lead to completely different solutions.

It also fits the player's entire journey.

The player has already been doing this with every other Pokémon:

feeding them,
caring for them,
spending time with them,
respecting them,
helping them.

But when a Shadow Pokémon appears, people suddenly switch mentalities:

"How do we force it back to normal?"

Sun Aipom points out the contradiction.

You are treating this Pokémon differently because it is damaged.

But a damaged Pokémon needs the same things — perhaps more.

The line:

"You haven't given it a reason to open it yet."

is especially good because it avoids making the Shadow Pokémon passive.

It is not:

"The Pokémon is broken and needs fixing."

It is:

"The Pokémon is protecting itself."

That is much more sympathetic.

And it creates a fascinating contrast with Team Rocket.

Team Rocket's assumption:

"The heart is the problem. Remove it."

The Xatu's assumption:

"The heart is damaged. Restore it."

Sun Aipom's assumption:

"The heart is there. Reach it."

All three are responses to the same situation.