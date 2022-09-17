=begin

Use AdventureGuide.list(hash)
	hash stores information of big title (Hash)
	Value in this hash:
		name -> it's title of this guide, big title (String)
		description -> it's description of big title (String)
		sub -> it's array to store all of sub-title, small title (Array)
			Each value in array is Hash, they are these values:
			name -> it's name of sub-title
			description -> it's description of small title

In description, when you want to create new line right away, just use \n.
Look at examples to write.

=end

# This is examples
# You can delete or edit it or add =begin below this line and add =end above line 'Add new list here'

AdventureGuide.list({
	:name => "Surviving in the Wilderness (1)",
	:description => "It's as easy as A,B,C,D.",
	:sub => [
		{:name => "Chapter 1: Basic Needs", :description => "In a survival situation, access what is your most pressing needs. If you are in an area with aggressive Pokémon your top priority should be shelter, as to not be attacked. Once you have located a shelter, check your needs with a tap of the 'Z' button, or the 'A' Button. Berries are a good basic source of food and liquids to tide you over until you can get better sources of both. When looking for berries, generally berries edible by Pokémon are edible by humans, so look for loamy soil housing berry trees once your shelter is set up."},
		{:name => "Chapter 2: Defense ", :description => "When going out to look for food and water from your shelter, you may encounter wild Pokémon. With skilled evasion, some of these encounters may be avoided, but some may get the jump upon you if you are walking in Tall Grass. If you end up getting into a battle with a Pokémon, your POKeDEX will not be able to report the level of the Pokémon if the area in question has not been throughly explored, so you may need to be careful when approaching wild Pokémon for the safety of your own Pokémon. If your Pokémon are damaged, return to your shelter, and give them, and yourself, a much needed rest."},
		{:name => "Chapter 3: Exploration", :description => "When exploring the wilderness around you, there may be items laying around that are not readily visible for you to see, the most common places for unseen items to be are near sources of water, most especially the beach, but such items could be anywhere in the world, so if you are missing that one thing to craft what you want, start searching throughly, and it may show up."},
		{:name => "Chapter 4: Crafting", :description => "During your exploration of the environment, you may have come across weaker trees you could tear down, and gain logs from. While your ability to craft without a Workbench is limited, you can create a Workbench with 5 Wooden Planks, which are gained via cutting down wood in the Crafting Menu. Upon the Creation of the Workbench, your options for Survival are greatly expanded. Top priorities should be a Pokémon Crate, and an Item Crate, for storage of your Pokémon, and Personal Effects. "},
		{:name => "Chapter 5: Structures", :description => "If there are any abandoned structures in your environment, take proper caution in approaching them, they could contain powerful Pokémon, and upon entry, exit may be impeded by said Pokémon. In some of these locations, it is best to send a single Pokémon if possible, otherwise, tread with caution, and make sure you have taken proper preparation."},
	]
})

AdventureGuide.list({
	:name => "Surviving in the Wilderness (1)",
	:description => "",
	:sub => [
		{:name => "Sub 5", :description => "Hello, this is descript of Sub 1 of A"},
	]
})

# Add new list here