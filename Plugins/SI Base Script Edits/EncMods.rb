EventHandlers.add(:on_wild_pokemon_created, :make_shadow_switch,
  proc { |pkmn|
  chance = rand(1024)
  if $game_switches[1194]==true &&  5 > chance && (pkmn.species != :XATU || pkmn.species != :NATU || pkmn.species != :SHAYMIN)
    pkmn.makeShadow 
  end
  }
)




# Used in the random dungeon map. Makes the levels of all wild Pokémon in that
# map depend on the levels of Pokémon in the player's party.
# This is a simple method, and can/should be modified to account for evolutions
# and other such details.  Of course, you don't HAVE to use this code.


maps= [54]

EventHandlers.add(:on_wild_pokemon_created, :level_depends_on_party2,
  proc { |pkmn|

if maps.include?($game_map.map_id) && GameData::EncounterType.get($PokemonTemp.encounterType).type == :land
if $game_variables[4974]=="ADALYNN"||$game_variables[4974]=="Adalynn"||$game_variables[4974]=="adalynn"
  pkmn = e[0]
  if rand(8)==0
  pkmn.species = :VULPIX
  pkmn.level = 80
  pkmn.happiness = 255
  pkmn.learn_move(:FLAMETHROWER)
  pkmn.learn_move(:HEADBUTT)
  pkmn.learn_move(:FIREBLAST)
  pkmn.learn_move(:AURORABEAM)
  pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Pallet Town @ Day"
  pkmn.iv[:HP] = 22
  pkmn.iv[:ATTACK] = 31
  pkmn.iv[:DEFENSE] = 12
  pkmn.iv[:SPECIAL_ATTACK] = 18
  pkmn.iv[:SPECIAL_DEFENSE] = 18
  pkmn.iv[:SPEED] = 10
  pkmn.calc_stats
  elsif rand(8)==1
  pkmn.species = :POLITOED
  pkmn.level = 80
pkmn.happiness = 255
pkmn.learn_move(:SURF)
pkmn.learn_move(:LOVELYKISS)
pkmn.learn_move(:CROSSCHOP)
pkmn.learn_move(:WHIRLPOOL)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Route 22 @ Night"
pkmn.iv[:HP] = 14
pkmn.iv[:ATTACK] = 20
pkmn.iv[:DEFENSE] = 26
pkmn.iv[:SPECIAL_ATTACK] = 2
pkmn.iv[:SPECIAL_DEFENSE] = 2
pkmn.iv[:SPEED] = 13
  pkmn.calc_stats
  elsif rand(8)==2
  pkmn.species = :DRAGONITE
  pkmn.level = 80
pkmn.happiness = 255
pkmn.learn_move(:HYPERBEAM)
pkmn.learn_move(:THUNDERBOLT)
pkmn.learn_move(:EARTHQUAKE)
pkmn.learn_move(:OUTRAGE)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Goldenrod City @ Day"
pkmn.iv[:HP] = 20
pkmn.iv[:ATTACK] = 22
pkmn.iv[:SPECIAL_ATTACK] = 14
pkmn.iv[:SPECIAL_DEFENSE] = 14
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 22
  pkmn.calc_stats
  elsif rand(8)==3
  pkmn.species = :ESPEON
  pkmn.level = 80
pkmn.happiness = 255
pkmn.learn_move(:PSYBEAM)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:PSYCHIC)
pkmn.learn_move(:PSYCHUP)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Celadon City @ Day"
pkmn.iv[:HP] = 20
pkmn.iv[:ATTACK] = 2
pkmn.iv[:SPECIAL_ATTACK] = 4
pkmn.iv[:SPECIAL_DEFENSE] = 4
pkmn.iv[:DEFENSE] = 8
pkmn.iv[:SPEED] = 31
  pkmn.calc_stats
  elsif rand(8)==4
  pkmn.species = :CROBAT
  pkmn.level = 80
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Mt Moon @ Night"
pkmn.learn_move(:WINDATTACK)
pkmn.learn_move(:FLY)
pkmn.learn_move(:GIGADRAIN)
pkmn.learn_move(:SHADOWBALL)
pkmn.item = :LUCKYEGG
pkmn.iv[:HP] = 24
pkmn.iv[:ATTACK] = 14
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 14
pkmn.iv[:SPEED] = 12
  pkmn.calc_stats
  elsif rand(8)==5
  pkmn.species = :DONPHAN
  pkmn.level = 80
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Route 34 @ Night"
pkmn.learn_move(:EARTHQUAKE)
pkmn.learn_move(:ANCIENTPOWER)
pkmn.learn_move(:RAPIDSPIN)
pkmn.learn_move(:STRENGTH)
pkmn.item = :LUCKYEGG
pkmn.iv[:HP] = 20
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 4
pkmn.iv[:SPECIAL_DEFENSE] = 4
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 31
  pkmn.calc_stats
  elsif rand(8)==6
  pkmn.species = :BELLOSSOM
  pkmn.name = "Adalyne"
  pkmn.level = 47
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Goldenrod City"
pkmn.learn_move(:HIDDENPOWER)
pkmn.learn_move(:STUNSPORE)
pkmn.learn_move(:SLEEPPOWDER)
pkmn.learn_move(:ACID)
pkmn.item = :EXPSHARE
pkmn.shiny = true
pkmn.iv[:HP] = 8
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 20
  pkmn.calc_stats
elsif rand(8)==7
  pkmn.species = :MAGNEMITE
  pkmn.level = 5
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.shiny = true
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Route 34 @ Day"
pkmn.iv[:HP] = 0
pkmn.iv[:ATTACK] = 4
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 20
  pkmn.calc_stats
  elsif rand(8)==8
  pkmn.species = :WOBBUFFET
  pkmn.level = 10
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Dark Cave @ Night"
pkmn.learn_move(:COUNTER)
pkmn.learn_move(:MIRRORCOAT)
pkmn.learn_move(:SAFEGUARD)
pkmn.learn_move(:DESTINYBOND)
pkmn.item = :EXPSHARE
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 31
pkmn.iv[:SPECIAL_DEFENSE] = 31
pkmn.iv[:DEFENSE] = 14
pkmn.iv[:SPEED] = 26
  pkmn.calc_stats
end
elsif $game_variables[4974]=="SNOW"||$game_variables[4974]=="Snow"||$game_variables[4974]=="snow"
  if rand(4)==0
  pkmn.species = :MEGANIUM
  pkmn.name = "Peepo"
  pkmn.level = 65
pkmn.happiness = 255
pkmn.learn_move(:CUT)
pkmn.learn_move(:ANCIENTPOWER)
pkmn.learn_move(:SOLARBEAM)
pkmn.learn_move(:RAZORLEAF)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Pallet Town"
pkmn.iv[:HP] = 6
pkmn.iv[:ATTACK] = 28
pkmn.iv[:SPECIAL_ATTACK] = 14
pkmn.iv[:SPECIAL_DEFENSE] = 14
pkmn.iv[:DEFENSE] = 12
pkmn.iv[:SPEED] = 2
  pkmn.calc_stats
  elsif rand(4)==1
  pkmn.species = :SCIZOR
  pkmn.name = "Lilac"
  pkmn.level = 40
pkmn.happiness = 255
pkmn.learn_move(:FALSESWIPE)
pkmn.learn_move(:FLY)
pkmn.learn_move(:METALCLAW)
pkmn.learn_move(:GUILLOTINE)
pkmn.item = :QUICKCLAW
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "National Park"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 2
pkmn.iv[:SPECIAL_ATTACK] = 26
pkmn.iv[:SPECIAL_DEFENSE] = 26
pkmn.iv[:DEFENSE] = 22
pkmn.iv[:SPEED] = 22
  pkmn.calc_stats
  elsif rand(4)==2
  pkmn.species = :GYARADOS
  pkmn.name = "Finn"
  pkmn.level = 35
pkmn.happiness = 255
pkmn.shiny = true
pkmn.learn_move(:WHIRLPOOL)
pkmn.learn_move(:SURF)
pkmn.learn_move(:STRENGTH)
pkmn.learn_move(:ROCKSMASH)
pkmn.item = :EXPSHARE
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Route 3 @ Night"
pkmn.iv[:HP] = 16
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 10
pkmn.iv[:SPECIAL_DEFENSE] = 10
pkmn.iv[:DEFENSE] = 10
pkmn.iv[:SPEED] = 10
  pkmn.calc_stats
  elsif rand(4)==3
  pkmn.species = :VENUSAUR
  pkmn.name = "Sunflower"
  pkmn.level = 41
pkmn.happiness = 255
pkmn.learn_move(:GIGADRAIN)
pkmn.learn_move(:RAZORLEAF)
pkmn.learn_move(:LEECHSEED)
pkmn.learn_move(:ANCIENTPOWER)
pkmn.item = :EXPSHARE
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Ilex Forest @ Day"
pkmn.iv[:HP] = 0
pkmn.iv[:ATTACK] = 20
pkmn.iv[:SPECIAL_ATTACK] = 4
pkmn.iv[:SPECIAL_DEFENSE] = 4
pkmn.iv[:DEFENSE] = 12
pkmn.iv[:SPEED] = 12
  pkmn.calc_stats
  elsif rand(4)==4
  pkmn.species = :VAPOREON
  pkmn.name = "Noel"
  pkmn.level = 32
pkmn.happiness = 255
pkmn.learn_move(:ICEBEAM)
pkmn.learn_move(:BITE)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:HEADBUTT)
pkmn.item = :EXPSHARE
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 18
pkmn.iv[:ATTACK] = 26
pkmn.iv[:SPECIAL_ATTACK] = 10
pkmn.iv[:SPECIAL_DEFENSE] = 10
pkmn.iv[:DEFENSE] = 28
pkmn.iv[:SPEED] = 8
  pkmn.calc_stats
end
elsif $game_variables[4974]=="TWIGS"||$game_variables[4974]=="Twigs"||$game_variables[4974]=="twigs"
pkmn.species = :ONIX
pkmn.level = 16
pkmn.happiness = 255
pkmn.owner.name = "TWIGS"
pkmn.obtain_text = "Granite Cave"
pkmn.learn_move(:IRONTAIL)
pkmn.learn_move(:EXPLOSION)
pkmn.learn_move(:FLAMETHROWER)
pkmn.learn_move(:DIG)
pkmn.iv[:HP] = 28
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 0
pkmn.iv[:SPECIAL_DEFENSE] = 0
pkmn.iv[:DEFENSE] = 31
pkmn.iv[:SPEED] = 31
pkmn.calc_stats
elsif $game_variables[4974]=="POTS"||$game_variables[4974]=="Pots"||$game_variables[4974]=="pots"
if rand(4)==0
pkmn.species = :SKARMORY
pkmn.level = 100
pkmn.happiness = 255
pkmn.learn_move(:DRILLPECK)
pkmn.learn_move(:STEELWING)
pkmn.learn_move(:RETURN)
pkmn.learn_move(:SPIKES)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 28
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 0
pkmn.iv[:SPECIAL_DEFENSE] = 0
pkmn.iv[:DEFENSE] = 18
pkmn.iv[:SPEED] = 31
pkmn.calc_stats
elsif rand(4)==1
pkmn.species = :DRAGONITE
pkmn.name = "Wyrmheim"
pkmn.level = 100
pkmn.item = :KINGSROCK
pkmn.happiness = 255
pkmn.learn_move(:WATERFALL)
pkmn.learn_move(:OUTRAGE)
pkmn.learn_move(:EXTREMESPEED)
pkmn.learn_move(:HYPERBEAM)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 22
pkmn.iv[:SPECIAL_DEFENSE] = 22
pkmn.iv[:DEFENSE] = 31
pkmn.iv[:SPEED] = 22
  pkmn.calc_stats
  elsif rand(4)==2
  pkmn.species = :ALAKAZAM
  pkmn.level = 100
pkmn.item = :AMULETCOIN
pkmn.happiness = 255
pkmn.learn_move(:PSYCHIC)
pkmn.learn_move(:ICEPUNCH)
pkmn.learn_move(:THIEF)
pkmn.learn_move(:RECOVER)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 18
pkmn.iv[:SPECIAL_DEFENSE] = 18
pkmn.iv[:DEFENSE] = 22
pkmn.iv[:SPEED] = 14
  pkmn.calc_stats
  elsif rand(4)==3
  pkmn.species = :PORYGON2
  pkmn.name = "Big Duckum"
  pkmn.level = 100
pkmn.item = :LEFTOVERS
pkmn.happiness = 255
pkmn.learn_move(:ICEBEAM)
pkmn.learn_move(:TRIATTACK)
pkmn.learn_move(:RECOVER)
pkmn.learn_move(:THUNDERBOLT)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 24
pkmn.iv[:ATTACK] = 10
pkmn.iv[:SPECIAL_ATTACK] = 16
pkmn.iv[:SPECIAL_DEFENSE] = 16
pkmn.iv[:DEFENSE] = 22
pkmn.iv[:SPEED] = 24
  pkmn.calc_stats
  elsif rand(4)==4
  pkmn.species = :UMBREON
  pkmn.level = 100
pkmn.item = :LUCKYEGG
pkmn.happiness = 255
pkmn.learn_move(:FEINTATTACK)
pkmn.learn_move(:CONFUSERAY)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:TRIATTACK)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 22
pkmn.iv[:SPECIAL_DEFENSE] = 22
pkmn.iv[:DEFENSE] = 5
pkmn.iv[:SPEED] = 14
  pkmn.calc_stats
  elsif rand(4)==5
  pkmn.species = :TOGETIC
  pkmn.level = 100
pkmn.happiness = 255
pkmn.learn_move(:FEINTATTACK)
pkmn.learn_move(:CONFUSERAY)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:TRIATTACK)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 0
pkmn.iv[:ATTACK] = 0
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 28
pkmn.iv[:SPEED] = 20
  pkmn.calc_stats
end
  
else
end
end
}
)

#EventHandlers.add(:on_wild_pokemon_created, :level_depends_on_party,
#  proc { |pkmn|
#
#   pokemon=e[0]
#   if $game_switches[76]#Earthquakes
#     pokemon.name="Jörmungandr"
#     pokemon.form=1
#     pokemon.learn_move(:BIND)
#     pokemon.learn_move(:EARTHQUAKE)
#     pokemon.learn_move(:MAGNITUDE)
#     pokemon.learn_move(:IRONTAIL)
#   elsif $game_switches[77]#Sea#DONE
#     pokemon.name="Aegir"
#     pokemon.form=1
#   elsif $game_switches[78]#Storms
#     pokemon.name="Tempestas"
#     pokemon.form=1
#   elsif $game_switches[79]#Snow#DONE
#     pokemon.name="Ullr"
#     pokemon.form=1
#   elsif $game_switches[80]#Forests
#     pokemon.name="Silvanus"
#     pokemon.form=1
#   elsif $game_switches[81]#Underworld
#     pokemon.name="Veles"
#     pokemon.form=1
#    elsif $game_switches[83]#Fire#DONE
#    pokemon.name="Hestia"
#     pokemon.form=1
#   end
#  }
#)


# This is the basis of a trainer modifier. It works both for trainers loaded
# when you battle them, and for partner trainers when they are registered.
# Note that you can only modify a partner trainer's Pokémon, and not the trainer
# themselves nor their items this way, as those are generated from scratch
# before each battle.
#EventHandlers.add(:on_trainer_load, :put_a_name_here,
#  proc { |trainer|
#    if trainer   # An NPCTrainer object containing party/items/lose text, etc.
#      YOUR CODE HERE
#    end
#  }
#)


class Battle

  def pbGainExp
    # Play wild victory music if it's the end of the battle (has to be here)
    @scene.pbWildBattleSuccess if wildBattle? && pbAllFainted?(1) && !pbAllFainted?(0)
    return if !@internalBattle || !@expGain
    # Go through each battler in turn to find the Pokémon that participated in
    # battle against it, and award those Pokémon Exp/EVs
    expAll = $player.has_exp_all || $bag.has?(:EXPALL)
    p1 = pbParty(0)
    @battlers.each do |b|
      next unless b&.opposes?   # Can only gain Exp from fainted foes
      next if b.participants.length == 0
      next unless b.fainted? || b.captured
      # Count the number of participants
      numPartic = 0
      b.participants.each do |partic|
        next unless p1[partic]&.able? && pbIsOwner?(0, partic)
        numPartic += 1
      end
      # Find which Pokémon have an Exp Share
      expShare = []
      if !expAll
        eachInTeam(0, 0) do |pkmn, i|
          next if !pkmn.able?
          next if !pkmn.hasItem?(:EXPSHARE) && GameData::Item.try_get(@initialItems[0][i]) != :EXPSHARE
          expShare.push(i)
        end
      end
      # Calculate EV and Exp gains for the participants
      if numPartic > 0 || expShare.length > 0 || expAll
        # Gain EVs and Exp for participants
        eachInTeam(0, 0) do |pkmn, i|
          next if !pkmn.able?
          next unless b.participants.include?(i) || expShare.include?(i)
          pbGainEVsOne(i, b)
          pbGainExpOne(i, b, numPartic, expShare, expAll)
        end
        # Gain EVs and Exp for all other Pokémon because of Exp All
        if expAll
          showMessage = true
          eachInTeam(0, 0) do |pkmn, i|
            next if !pkmn.able?
            next if b.participants.include?(i) || expShare.include?(i)
            pbDisplayPaused(_INTL("Your other Pokémon also gained Exp. Points!")) if showMessage
            showMessage = false
            pbGainEVsOne(i, b)
            pbGainExpOne(i, b, numPartic, expShare, expAll, false)
          end
        end
      end
      # Clear the participants array
      b.participants = []
    end
  end
  
   def pbGainEVsOne(idxParty, defeatedBattler)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
    evYield = defeatedBattler.pokemon.evYield
    # Num of effort points pkmn already has
    evTotal = 0
    GameData::Stat.each_main { |s| evTotal += pkmn.ev[s.id] }
    # Modify EV yield based on pkmn's held item
    if !Battle::ItemEffects.triggerEVGainModifier(pkmn.item, pkmn, evYield)
      Battle::ItemEffects.triggerEVGainModifier(@initialItems[0][idxParty], pkmn, evYield)
    end
    # Double EV gain because of Pokérus
    if pkmn   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 1.1 }
    end
    if pkmn.happiness>=200   # Infected or cured
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.age.nil?
      pkmn.age=rand(50)+1
    end
    if pkmn.age>=1 && pkmn.age<=20
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>20 && pkmn.age<=40
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>40 && pkmn.sleep<=60
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>60 && pkmn.age<=80
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>80
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.pokerusStage >= 1   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 3 }
    end
    # Gain EVs for each stat in turn
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id])
        if pkmn.purifiedPokemon?
        evGain = evGain*1.25
        end
		if pkmn.shadowPokemon?
        evGain = evGain*1.5
        end
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.ev[s.id] += evGain
        evTotal += evGain
      end
    end
  



  def pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages = true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining Exp from defeatedBattler
    growth_rate = pkmn.growth_rate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end
    isPartic    = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty)
    level = defeatedBattler.level
    # Main Exp calculation
    exp = 0
    a = level * defeatedBattler.pokemon.base_exp
    if expShare.length > 0 && (isPartic || hasExpShare)
      if numPartic == 0   # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a / (2 * numPartic) if isPartic
        exp += a / (2 * expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a / 2
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a / 2
    end
    return if exp <= 0
    # Pokémon gain more Exp from trainer battles
    exp = (exp * 1.5).floor if Settings::MORE_EXP_FROM_TRAINER_POKEMON && trainerBattle? && !pkmn.shadowPokemon?
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = ((2 * level) + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != pbPlayer.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language))
    if isOutsider && !pkmn.shadowPokemon?
      if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language 
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Exp. Charm increases Exp gained
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    # Modify Exp gain based on pkmn's held item
    i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    if i < 0
      i = Battle::ItemEffects.triggerExpGainModifier(@initialItems[0][idxParty], pkmn, exp)
    end
    exp = i if i >= 0
    # Boost Exp gained with high affection
    if @internalBattle && pkmn.happiness >= 240 && !pkmn.mega?
      exp = exp * 6 / 5
      isOutsider = true   # To show the "boosted Exp" message
    end
    # Make sure Exp doesn't exceed the maximum
    expFinal = growth_rate.add_exp(pkmn.exp, exp)
    expGained = expFinal - pkmn.exp
    if pkmn.shadowPokemon?
        expGained = expGained/1.5
    end
    return if expGained <= 0
    # "Exp gained" message
    if showMessages
      if isOutsider
        pbDisplayPaused(_INTL("{1} got a boosted {2} Exp. Points!", pkmn.name, expGained))
      else
        pbDisplayPaused(_INTL("{1} got {2} Exp. Points!", pkmn.name, expGained))
      end
    end
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    if newLevel < curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
                  pkmn.name, debugInfo)
    end
    # Give Exp
    $stats.total_exp_gained += expGained
    tempExp1 = pkmn.exp
    battler = pbFindBattler(idxParty)
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp < expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
      @scene.pbEXPBar(battler, levelMinExp, levelMaxExp, tempExp1, tempExp2)
      tempExp1 = tempExp2
      curLevel += 1
      if curLevel > newLevel
        # Gained all the Exp now, end the animation
        pkmn.calc_stats
        battler&.pbUpdate(false)
        @scene.pbRefreshOne(battler.index) if battler
        break
      end
      # Levelled up
      pbCommonAnimation("LevelUp", battler) if battler
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
      if battler&.pokemon
        battler.pokemon.changeHappiness("levelup",battler)
        battler.pokemon.changeLoyalty("levelup",battler)
      end
      if pkmn.shadowPokemon?
         potato = pkmn.level
         if potato == 12
          if rand(100) <= 5
          pkmn.nature=:HATEFUL
          end
         elsif potato == 13
          if rand(100) <= 10
          pkmn.nature=:HATEFUL
          end
         elsif potato == 14
          if rand(100) <= 15
          pkmn.nature=:HATEFUL
          end
         elsif potato == 15
          if rand(100) <= 20
          pkmn.nature=:HATEFUL
          end
         elsif potato == 16
          if rand(100) <= 25
          pkmn.nature=:HATEFUL
          end
         elsif potato == 17
          if rand(100) <= 30
          pkmn.nature=:HATEFUL
          end
         elsif potato == 18
          if rand(100) <= 35
          pkmn.nature=:HATEFUL
          end
         elsif potato == 19
          if rand(100) <= 40
          pkmn.nature=:HATEFUL
          end
         elsif potato >= 20
          if rand(100) <= 50
          pkmn.nature=:HATEFUL
          end
         else
       end
      end
      pkmn.calc_stats
      battler&.pbUpdate(false)
      @scene.pbRefreshOne(battler.index) if battler
      pbDisplayPaused(_INTL("{1} grew to Lv. {2}!", pkmn.name, curLevel))
      @scene.pbLevelUp(pkmn, battler, oldTotalHP, oldAttack, oldDefense,
                       oldSpAtk, oldSpDef, oldSpeed)
      # Learn all moves learned at this level
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(idxParty, m[1]) if m[0] == curLevel }
      newspecies=pkmn.check_evolution_on_level_up
          old_item=pkmn.item
          if newspecies
            pbFadeOutInWithMusic(99999){
            evo=PokemonEvolutionScene.new
            evo.pbStartScreen(pkmn,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
            if battler
              @scene.pbChangePokemon(@battlers[battler.index],@battlers[battler.index].pokemon)
              battler.name=pkmn.name
            end
          }
          if battler
            pkmn.moves.each_with_index do |m,i|
              battler.moves[i] = Battle::Move.from_pokemon_move(self,m)
            end
            battler.pbCheckFormOnMovesetChange
            if pkmn.item!=old_item
              battler.item=pkmn.item
              battler.setInitialItem(pkmn.item)
              battler.setRecycleItem(pkmn.item)
            end
          end
        end
    end
  end
  end