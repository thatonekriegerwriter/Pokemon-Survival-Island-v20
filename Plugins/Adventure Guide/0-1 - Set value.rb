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
	:name => "Surviving in the Wilderness",
	:description => "It's as easy as A,B,C,Died.",
	:sub => [
		{:name => "Chapter 1: Basic Needs", :description => "In a survival situation, access what is your most pressing needs. If you are in an area with aggressive Pokémon your top priority should be shelter, as to not be attacked. Once you have located a shelter, check your needs with a tap of the 'Z' button, or the 'A' Button. Berries are a good basic source of food and liquids to tide you over until you can get better sources of both. When looking for berries, generally berries edible by Pokémon are edible by humans, so look for loamy soil housing berry trees once your shelter is set up."},
		{:name => "Chapter 2: Defense ",    :description => "When going out to look for food and drink from your shelter, you may encounter wild Pokémon. With skilled evasion, some of these encounters may be avoided, but some may get the jump upon you if you are walking in Tall Grass. If you cannot evade a POKeMON, attempt to take it's approach head on, lest it could attack you and do damage to you and yours, If you end up getting into a battle with a Pokémon, your POKeDEX will not be able to report the level of the Pokémon if the area in question has not been throughly explored, so you may need to be careful when approaching wild Pokémon for the safety of your own Pokémon. If your Pokémon are damaged, return to your shelter, and give them, and yourself, a much needed rest."},
        {:name => "Chapter 3: Exploration",  :description => "When venturing far from home, it would not only be a good idea to have a good amount of food and water ready, but portable shelter is also a must for ones ability to comfortably sleep, if you must stay in an area for a long amount of time, however, prioritize locating shelter in the local area."},	
		{:name => "Chapter 4: Hidden Items", :description => "When exploring the wilderness around you, there may be items laying around that are not readily visible for you to see, the most common places for unseen items to be are near sources of water, but such items could be anywhere in the world, so if you are missing that one thing to craft what you want, start searching throughly, and it may show up."},
		{:name => "Chapter 5: Crafting",    :description => "During your exploration of the environment, you may have come across weaker trees you could tear down, and gain logs from. While your ability to craft without a Workbench is limited, you can create a Workbench with 5 Wooden Planks, which are gained via cutting down wood in the Crafting Menu. Upon the Creation of the Workbench, your options for Survival are greatly expanded. Top priorities should be a Pokémon Crate, and an Item Crate, for storage of your Pokémon, and Personal Effects. "},
		{:name => "Chapter 6: Structures",  :description => "If there are any abandoned structures in your environment, take proper caution in approaching them, they could contain powerful Pokémon, and upon entry, exit may be impeded by said Pokémon. In some of these locations, it is best to send a single Pokémon if possible, otherwise, tread with caution, and make sure you have taken proper preparation."},
		{:name => "Chapter 7: Adventures",  :description => "If you have a good amount of POKeMON at your disposal, it may be a good idea to send them out upon their own. They can bring back items, or locate new POKeMON for your use. For more, please check our companion book, 'Pokemon Adventures'"},
		{:name => "Chapter 8: Yourself",  :description => "While you may be out in the wilderness, it may be a good idea to become acquainted with yourself and your skills. You are quite special in what you can do, if it be your ability to sprint, your ability to recover POKeBALLs, or even working with electronics. This can be accessed with a tap of the 'A' Button, with a short description, like 'Runner' or 'Breeder'."},
		{:name => "Chapter 9: Your Bag",  :description => "Remember to be careful! You can't carry everything you see! You will need some form of storage for your excess! Invest in an Item Box if you like collecting! As for your bag, each slot has a limit of 99, and a general size limit of 20! Thankfully, you can use the 1-9 num keys at the top of your keyboard to quickly navigate your bag, beyond that, most kinds of food can be Registered for use with the 'D' button!"},
		
	]
})

AdventureGuide.list({
	:name => "A Basic Guide to Modern POKeMON Care",
	:description => "",
	:sub => [
		{:name => "Chapter 1: Aging and Lifespan", :description => "POKeMON are complex creatures, they age and die like we can. Some Trainers worry about this less than others, but for those concerned with it, it is easy to learn what a POKeMONs remaining lifespan is at any POKeMON Center, and an enterprising Trainer should always know their POKeMON's age, easily viewable from the Summary Screen, as simple logic dictates, the older a POKeMON is, the closer it is to death. Beyond that, a POKeMON's lifespan suffers the more frequently they are knocked out or badly damaged, or as it is stated in the next chapter, dehydrated or starving. Mind the health of your POKeMON carefully."},
		{:name => "Chapter 2: Basic Needs", :description => "Always be sure to have approprate amounts of food and drink for your POKeMON around, they need much less than use humans, but you still must be mindful. Thankfully, POKeMON get proper amounts of rest while in their POKeBALLs, so it is not something to worry too hard about, however, if a POKeMON is starving or dehydrated, their lifespan will begin decreasing rapidly, meaning they will die."},
		{:name => "Chapter 3: Natures", :description => "Each POKeMON's personality is as varied as can be. This impacts the kind of food and drink they enjoy, all the way to the kind of play they like. Some POKeMON could be exceptionally loving, easy to gain its trust and affection, while another could be hateful, wanting nothing to do with humanity as a whole. Be mindful of your POKeMON's nature throughout your care for it, as your treatment of your POKeMON could even change its nature depending on your treatment of it."},
		{:name => "Chapter 4: Happiness", :description => "What makes a POKeMON happy is dependent on its nature, but something universal is a happy POKeMON will go out of its way for you more often than not, like toughing it out in combat, or doing a critical! However, while this is nice, it is not as important as what we will talk about in the next chapter."},
		{:name => "Chapter 5: Loyalty", :description => "A POKeMON's obedience has always been a mystery, is it dependent on ones badges? The POKeMON's level? It could be argued to be a mixture of these things, but the most influencial aspect is a POKeMON's loyalty to its trainer. The more Loyal a POKeMON is, the more likely it is to obey in combat. The less loyal a POKeMON is, the more likely they are to disobey, even if they have a large amount of happiness. While it's hard to know exactly how a POKeMON feels, upon the same Summary Screen as the Food and Water, there should be a short line summarizing your POKeMON's feelings at the current time."},
	]
})

AdventureGuide.list({
	:name => "Pokemon Adventures",
	:description => "",
	:sub => [
		{:name => "Chapter 1: Primer", :description => "Many people forget that at the end of the day, POKeMON are more used to the outdoors than we humans are. Collectively, they are excellent scavengers, and great hunters. Some Trainers choose to send their POKeMON out on their own, and the results can be quite surprising, level ups, mountains of items, and more!"},
		{:name => "Chapter 2: Eggs", :description => "While not advisable, you can send out an Egg with another member of your Adventuring Party, wherein the egg can be cared for by the POKeMON, and not counting towards your primary party limit. Note that Eggs hatched this way may be less happy or loyal than their in party counterparts."},
	]
})

# Add new list here