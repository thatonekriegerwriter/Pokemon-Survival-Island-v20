#-------------------------------------------------------------------------------
# Adventure: code for sending pokemon adventuring
#-------------------------------------------------------------------------------
module PokeventureConfig
  Updatesteps = 100 # How many steps should be taken before the Adventure progresses
  CustomMusic = "Mystery Dungeon Guild" # Custom music to play in the menue. Must be in the BGM folder
  #Item Collection
  CollectRandomItem = true #Collect Items from the Table below
  CollectItemsFromBattles = true # Collect Items from defeated Pokemon
  # Form of this list is [ItemID,chance]
  Items = [
    [:ORANBERRY,15], [:SITRUSBERRY,10], [:ACORN,5], [:STONE,5], [:HEARTSCALE,1],
    [:IRONORE,3], [:POTATO,2], [:COPPERORE,3], [:GOLDORE,3], [:TEALEAF,3],
    [:SILVERORE,2], [:COAL,5], [:WATER,5],
	[:FIRESTONE,5],[:LEAFSTONE,5],[:THUNDERSTONE,5],
	[:COCOABEAN,3], [:EXPCANDYS,1],[:REVIVALHERB,1], [:ENERGYROOT,3], [:MOOMOOMILK,1], [:LEMON,5],
    [:GLASSBOTTLE,1], [:PEARL,1]
  ]
  ChanceToGetEnemyItem = 100 # as a 1 in x chance
  # Friends
  FindFriends = true # If there is Space should there be a chance for wild pokèmon to join you.
  ChanceToFindFriend = 200 # as a 1 in x chance
  AreFoundFriendsBrilliant = true #have higher ivs and a higher shiny chance
  ChanceToFindEggs = true
  # Exp
  GainExp = true # should the pokemon gain exp through adventuring
  # Wild Pokemon
  GlobalPkmn = false # should this script use the global encounter list everywhere instead of the specific map encounters.
  # Form of this list is [ItemID,chance]
  PkmnList = [[:PIKACHU,1], [:CHARMANDER,3], [:SQUIRTLE,3], [:BULBASAUR,3], [:EEVEE,1]]
  # Form of this list is [ItemID,chance]
  EggList = [[:PICHU,5],[:CLEFFA,5],[:IGGLYBUFF,5],[:TOGEPI,5],[:TYROGUE,5],[:SMOOCHUM,5],[:ELEKID,5],[:MAGBY,5],[:BUDEW,5],
            [:CHINGLING,5],[:BONSLY,5],[:MIMEJR,5],[:HAPPINY,5],[:MUCHLAX,5],[:RIOLU,5],[:MANTYKE,5],[:PUPPERON,5],
            [:VULPIII,5],[:SMUJJ,5]]
  GlobalLeveling = false # makes the level of the encounters balanced around the number of badges instead of the location (always on if globalPkmn is on)
  #level per badge [min,max] can add more if you have more badges in your game
  PkmnLevel = [
	[2,15],		#0 Badges
	[11,25],	#1 Badge
	[21,35],	#2 Badges...
	[31,40],
	[41,50],
	[51,60],
	[61,70],
	[71,80],
	[81,90]		#8Badges
  ]
  # Trigering Abilities
  # Enter all the functions of Abilities that should be triggered after battle here (like Pickup and Honeygather )
  def self.pbAdventureAbilities(pkmn)
	pbPickup(pkmn)
	pbHoneyGather(pkmn)
  end
end

#-------------------------------------------------------------------------------
# EncounterTypes
#-------------------------------------------------------------------------------
GameData::EncounterType.register({
  :id => :Adventure,
  :type => :none,
  :trigger_chance => 1,
  :old_slots => [50, 20, 10, 5, 5, 5, 5],
})

GameData::EncounterType.register({
  :id => :AdventureEggs,
  :type => :none,
  :trigger_chance => 1,
  :old_slots => [50, 20, 10, 5, 5, 5, 5],
})

SaveData.register(:adventure_party) do
  ensure_class :Adventure 
  save_value { $Adventure  }
  load_value { |value| $Adventure = value }
  new_game_value {
    Adventure.new
  }
end

EventHandlers.add(:on_player_step_taken, :continue_adventure,
  proc {
    $Adventure.newStep
  }
)

