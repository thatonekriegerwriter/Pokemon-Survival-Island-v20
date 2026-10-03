## CURRENT_STATE 
## X is complete, - is half complete, empty is not worked on.
### Core Gameplay 

### UI

### Pokemon
- [ ] Wire in Fear effects into obedience/etc.
- [x] Reset interaction menu returning to stored page
- [x] 'Interaction' menu for petting/grooming/speaking to/whip etc.
- [x] Talk command list

### Interact 
- [ ] Feed — increases Happiness; food preference/nature can modify the amount. Brings up a menu with a list of foods.
- [ ] Play — basically a different face for Pet.
- [ ] Train — increases Loyalty, but can increase Fear if done too much consecuatively.
- [ ] Rest — Tells they can sleep.
- [x] Direct - Opens up direction menu.

### Talk
- [ ] Praise — increases Happiness and possibly Loyalty, but only for a short time after completing a task/combat.
- [ ] Scold — causes obedience for a very short time at the cost of happiness. Stackable. Using this too many times in a row increases fear.
- [ ] Comfort — basically a different face for Pet.
- [ ] Reassure — Can be used after a scolding to gain back some happiness, but less effective at higher fear amounts. Less effect the more scolds there have been within the last hour, and less effective for every reassurance in the past hour.
- [ ] Command — an interaction that basically does an obedience check without being in combat.

### Placeables

### Items
- [ ] Whip. Opens the Blue Click menu, and if nothing in clicked, it cracks, and cracking makes Pokemon used to the whip obey. Clicking a Pokemon cracks near them, decreasing happiness, and increasing loyalty, increases their whip tolerance and makes them obey. Obedience only lasts a few hours. Clicking a Pokemon that has already been cracked near gets properly whipped, damaging them, once again increasing their loyalty, and massively decreasing their happiness. This, however, increases all their stat stages by 1. If whipping a hostile Pokemon, it damages them, and greatly increases its fear and loyalty. If fear and loyalty reach max before it dies, it joins you.
- [ ] Prod - Puts them into a proded state that immediately goes back to work. A proded Pokemon will continue working past its Stamina being zero, once it is zero, it will start draining happiness. Needless prods while proded increase Fear.
- [ ] Tether - Locks a Pokemon to stay in one place, and they will not move for any reason. If a Pokemon is tethered for too long, it will slowly drain happiness. If a Pokemon is scolded while tethered, it will be "grounded" which increases obedience at the cost of fear, and will stop losing happiness from the tether while its under the grounded effect.
- [ ] Flute - Can play one of multiple songs to various effect. Blue Flute wake up song, Yellow Flute unconfuse song,  Red Flute uncharm song, Black Flute Song (reduces encounter rate while increasing level), White Flute Song (increases encounter rate by 50%, and decreases level), Song to sooth fear, a Song of Time that can be played at the Seaside Alter of summon Celebi (one week cooldown), attack song that damages friend and foe. The Flute does not work on Pokemon with Soundproof. 
### Food 

### Combat

### Buildings

### World
- [ ] Finish First Temple (Second to last)

### First Temple
- [ ] Verify Patrollers work.
- [ ] Verify Dungeon Progression functions.
- [ ] Locate what the last thing I worked on was.
- [x] Verify dungeon heightmap is functional.
- [ ] Verify dungeon pokemon can cross bridges
- [ ] Remake Boss Logic.

### Misc Mechanics

 ### Player Classes

A calming item that touches only Fear, nothing else — Brush moves all three stats at once, Reassure has built-in diminishing returns. Something that's purely "lower Fear, no Happiness or Loyalty side effect" gives the player a dedicated recovery tool after a bad Scold/Whip stretch, distinct from both.
A passive, worn item rather than a used-on-demand one — everything so far is an action the player performs. Something a Pokémon simply wears that slowly nudges one stat (slower Fear decay, or small passive Loyalty gain) introduces a different kind of care: an ongoing gift rather than a repeated action.
A restraint that trades control for restriction, as the opposite of the Whip — keeps a skittish or disobedient Pokémon close and manageable without the Fear/Happiness cost, but at the price of something else (can't be sent to work, moves slower, can't be sent out to Hunt/Search). Whip is "risky, no limits." This would be "safe, but limited" — a second path to control that isn't just a weaker Whip.
A capture-support item specifically for the Whip's wild-Pokémon path — something that softens resistance or speeds the Fear/Loyalty climb specifically during a capture attempt, mirroring how Poké Balls get status-synergy items in the mainline games. This ties directly into the one mechanic Whip already has that nothing else interacts with.
