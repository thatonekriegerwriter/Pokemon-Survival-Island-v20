#===============================================================================
# Adventure Guide content.
#
# `unlocks_book:` on a chapter reveals that book (by id) plus its first
# chapter once the chapter has been read to the end. Reordering or adding
# chapters within a book never needs a change in Adventure_Guide.rb.
#===============================================================================

AdventureGuide.register_book(
  id: :survival_guide,
  name: "Survival Situations",
  description: "A guide to wilderness survival for stranded explorers.",
  enabled: true,
  chapters: [
    {
      name: "Chapter 1: Basics",
      enabled: true,
      unlocks_book: :flora,
      description: "In a survival situation, assess what are your most pressing needs. If there are any dangerous Pokémon around, your top priority should be locating a safe place away from them, lest you end up attacked. Some of the most suitable areas are abandoned caves. The most ideal locations should be near sources of water, and easy sources of food, like berries. Remember to not eat all your berries however, leave one for replanting!  If you reach a safe place, and you have bedding, be sure to set it up and rest at it, sleeping allows your body to rest and recover, the same with any Pokémon you may have."
    },
    {
      name: "Chapter 2: Supplies",
      enabled: false,
      description: "Once set up in a safe location, the most pressing object to find resources for is a base field workbench. To create this, you may have to obtain wood from weaker trees in the area, they may often be found near other plants in the area, like Berry Trees. From that point, the most suggested thing to create would be a fishing rod. Raw fish is the safest kind of food to consume, and you can obtain Pokémon that way for self-defense, albeit a weak one. On top of that, a bowl is highly important, as it can be used to obtain water from clean water sources. While it may not be the most healthy, unboiled water can still be used to stave off thirst. "
    },
    {
      name: "Chapter 3:  Exploration P1",
      enabled: false,
      unlocks_book: :cooking,
      description: "When departing from your shelter, sandy areas are the most pressing areas to comb, as beach combing can be a source of various useful materials. Another highly pressing material to collect is stones, which can be randomly found on the ground, or found by looking around larger stones in the environment. Stones are best used for the creation of a Furnace, and if Iron is found while beach combing, priority should be given to creating a Shovel, as it can rapidly accelerate beach combing, and allow for easier acquisition of sand, which can be smelted into glass for glass bottles, which can be cooked to purify water."
    },
    {
      name: "Chapter 4: Exploration P2",
      enabled: false,
      description: "Travelling further from your encampment may reward more interesting or useful items, but exploring also comes with greater risks if you are in an unsafe environment. If you are in an area with aggressive Pokémon, use your own Pokémon or equipment against them. If you are in an environment lacking resources for self-defense, prioritize being out of its line of sight. Particularly aggressive Pokémon could fire attacks at you from a distance, or rush you down. If a Pokémon is running you down, do not stop moving, and attempt to bait it into running into a wall. An intelligent Pokémon may understand what you are trying to do, however, so continue making distance. "
    },
    {
      name: "Chapter 5: Security",
      enabled: false,
      unlocks_book: :pokemon_care,
      description: "Once basic supplies are obtained, focus should be brought into your own defense, and offenses. Various tools for survival, like a machete, can both be used to cut thicker trees, and also attack Pokémon, though putting yourself in direct combat with a Pokémon is extremely dangerous. It can be made safer by approaching with proper equipment, like a Buckler. The safest way, however, is to obtain your own Pokémon. If you can locate Tumblestones and Apricorns in your environment, those can be used to make primitive Pokéballs to obtain Pokémon with. You will need to craft a specialized Pokéball Workstation for this, but it uses many basic items you should have so far, and Tumblestones. While it may not be the most helpful, an old wives tale from ancient Johto says that when seeking your first partner, the first Apricorn Ball you throw will always catch your target, so pick your new partner carefully."
    },
    {
      name: "Chapter 6: Resources",
      enabled: false,
      description: "Your bag only has a limited amount of room for Pokémon and Items, so once you are in a secure place, and have a good amount of resources, a high priority should be given to places where these can be stored. Items are less pressing, but a place to store Pokémon should be highly pressing, as any excess Pokémon you catch will be sent to an available storage. When moving around storage, Pokémon and Items will remain inside, but will not be available for storage until the storage is interacted with again. It is highly advised to store any perishables in something like an Ice Box, if materials are available to make such a thing. Otherwise, keep items in their own dedicated storage."
    },
    {
      name: "Chapter 7: Structures",
      enabled: false,
      unlocks_book: :structures1,
      description: "Naturally occurring caves and other such structures in the environment carry no small risk of danger. Caves can be regarded as safer than larger, abandoned or ruined structures, but still carry no small risk. Both are likely to contain powerful Pokémon, but structures are more likely to contain especially powerful and organized groups of Pokémon that will require extreme preparation to deal with, even then, tread with caution. Upon entering these areas, expect your exit to have the chance to be impeded at some point. If exit *is* available, there is no shame in retreat if it is needed. One small luxury is any caves you may open up yourself are always guaranteed to be secure, unlike naturally occurring caves, which carry the aforementioned risk. Caves you open up also have a high likelihood of containing materials which can be obtained with a Pickaxe. Visit these caves periodically, as you may find materials you did not see before."
    },
    {
      name: "Chapter 8: Final Advice",
      enabled: false,
      description: "While offense and defense are important, there are various ways to protect yourself against Pokémon, bright lights placed around areas will make most Pokémon unlikely to approach, but will not prevent them entirely, sufficiently smelly smells will repel Pokémon from approaching yourself or structures. Pokémon are not likely to enter interiors occupied by a person out of fear, but this may not deter larger groups of Pokémon from doing so. The presence of wild Pokémon is not only a risk, but defeating these Pokémon may allow you to obtain rare materials used for crafting. Most of all, rarely, in locales where humans are extremely uncommon, you may find extremely intelligent Pokémon. These Pokémon may be willing to engage with you in a peaceful manner, and very well could be a source of materials. The world is wide, and while the basics may protect you, and may allow you to survive, having an explorative mind will allow you to thrive."
    }
  ]
)

AdventureGuide.register_book(
  id: :flora,
  name: "Flora Foundations",
  description: "A guide to wild plants for estranged inventors.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "Multiple types of plants dominate the varieties of floral life in the world, but the most common of all is berries, able to be found in every Region of the planet. These can be fed to Pokémon for various effects, or used in food and meals for both yourself and your Pokémon. The second most common is various types of Crops, like Wheat, or Potatoes, can be used for even hardier dishes than berries can provide, but are uncommon to find outside of farms, unlike wild berries. The third most common type of Flora that can be found in the world is the Apricorn, which was classically used for the creation of the Pokéball alongside Tumblestones before modern manufacturing methods. Finally, there are medicinal herbs which can have unique effects on Pokemon, they do not like them."
    },
    { name: "Chapter 2: Berries", enabled: false, 
	description: "It may be self-evident, but Berry trees are plants that may yield berries. There is no guarantee of this. They may be found. They may grow naturally. You may collect berries from them if there is a yield. They are edible, and enjoyed by both people and Pokémon. Some types of berries resemble some types of crops. They may be used in place of those crops. A Tamato Berry is not a Tomato. It will suffice as one if you are lacking. A Berry may be used on a Pokémon. A berry may be given to a Pokémon to use. Berries are the best kind of flora for a Floral Inventor to begin learning Floral Inventing with. They are simple. The most common ones grow quickly." },
    { name: "Chapter 3: Crops", enabled: false, 
	description: "Crops are farmed by farmers. Farmers do not like when you disturb their Crops. I have not been able to obtain many seeds. Farmers are not afraid to have their Tauros charge you if you are trying to learn about their Crops. Crops, unlike Berries, take longer to grow, and are less common than them, but they make for very good meals. This is wasteful for a dedicated Floral Inventor. They must be planted. The few Crops I have must be tended to more frequently than berries. When partaking in serious Floral Inventing, they seem to attract pests more frequently. Rattatas took the only Crops I had." },
    { name: "Chapter 4: Apricorns", enabled: false, 
	description: "Apricorns are not the easiest to invent with. They are the easiest to obtain with highly specific uses. I attempt to think of something to use Apricorns for. Apricorns take forever to grow, give many Apricorns, and then I stare at them because I can only realistically use them for Pokéballs. I do not own Pokémon. I do not know how to make carved Pokéballs. I do not want to waste them in a Blender. I do not like Aprijuice. I do not own Pokémon for it to be useful for. I have too many Apricorns.\n\nI have returned to this chapter to note that the Rattatas have eaten the Apricorns as well. Problem solved, as they only ate the excess. I may still use them for Floral Inventing." },
    { name: "Chapter 5: Herbs", enabled: false, 
	description: "Herbs are enjoyable to grow. I obtained a set of various herbs and roots. They are chiefly used for Pokémon, but seem to be best for Advanced Floral Inventing. A Sitrus Berry and an Energy Root creates a type of Berry I have never seen before. Fascinating. The Herbs are hard to find more of. They grow slowly. I have spent the last 12 hours watching Herbs grow. I have never been so titillated." },
    { name: "Chapter 6: Other", enabled: false, 
	description: "I am told I should note other plants. Trees exist. Mushrooms exist. I am sure they are useful. I have not found out how. Mushrooms just make more mushrooms. I have obtained seeds I have never seen before on Pokémon. I plant them. They sprout and give me more seeds. Miracles lead to Mastery. Mastery dyed in Purple is an Enigma. These may be valuable to sell to continue research.\n\nThe Rattata ate my plants again. I will have to start from the beginning." },
    { name: "Chapter 7: General Advice", enabled: false, 
	description: "Plants all have different rates of growth and different stages of life, some plants don’t need very much water, some plants do. Some benefit from colder biomes. Some like the heat. All of these factors simply affect how and *if* a plant will grow. It does not harm you to take notes about a plant to learn about its conditions. It does not harm you to time how long these plants grow. If you are focusing on these plants extensively, having this information will allow you to retain as much of your time as possible. A truly dedicated Floral Inventor understands notes and understanding are key. " },
    { name: "Chapter 8: Crossbreeding",
      unlocks_book: :beekeeping, enabled: false, 
	description: "What I call Advanced Floral Research, many call Crossbreeding. Careful planting and placement of plants connected with cropsticks leads to traits being traded between the two. Some are nonobvious. A wintry plant being bred with a summer plant may lead to a summer plant that thrives in winter. More curiously is when mutations occur. They cannot be measured. They are random. Pests only arrive with cropsticks. Weeds only appear with cropsticks. Mutations only appear with cropsticks. Transmission of traits only appears with cropsticks. A truly dedicated Floral Inventor can understand randomness itself and variables that go into it. Bee type Pokémon help scare Rattatas away. They do not guarantee it. Bee type Pokémon increase likelihood of progression of Advanced Floral Research. They do not guarantee it. I need more Apricorns. I need more Pokéballs. I need more Bees. Research has surpassed what the Rattatas took. I appreciate my new Research Partners." },
  ]
)

AdventureGuide.register_book(
  id: :beekeeping,
  name: "Bee Behaviors",
  description: "A guide to beekeeping for estranged inventors.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "While Advanced Floral Research slowly progresses idly, I have decided to put focus on my Research Partners, the Bee type Pokémon I have collected. I have not located a sufficient criteria for what a ‘bee’ is when it comes to Pokémon. It is not all pollinators, as some do not work amiably with others, and it can even change within a group of Pokémon. A Weedle is not a bee. A Beedrill is a Bee in spite of its common classification as a hornet. You will be able to tell if it is a bee because when in an Apiary it will do bee things slowly. Eventually when it is done doing bee things, there will be honey. I do not know what to do with the honey." },
    { name: "Chapter 2: Produce", enabled: false, 
	description: "Bees assigned to Floral Research produce honey first and foremost. Occasionally, rarely, they produce other things. Much like Crops from my Floral Research, all of this is useless. While attempting to dump useless Honey and useless Crops, I met a Trainer named Tori. She seemed very annoyed that I was ‘wasting perfectly good food’. She is now paying me for the excess ‘produce’ from my experiments. I do not quite understand what it is useful for, but I will not object to more funds for Floral Research." },
    { name: "Chapter 3: New Bees", enabled: false, 
	description: "My bees stopped producing. They are not going out. I do not understand. I asked Tori to help. Tori arrived, and when studying my research partners, seemed annoyed with me. She taught me that within the Bee hives, there is a big bee. She is called the Queen. I did not know about the Queen. The Queen is dead. I was sure  this was the end of my research, before Tori revealed a Queen only dies in such a manner after laying eggs in the ‘nest’, which also contains a new Princess to replace the Queen. I do not like this process. I did not know the Queen, but she was a good research partner. There was a lot of honey and resources left from when she was gone, but I do not want any of it right now. I do not even want money for it right now." },
    { name: "Chapter 4: Frames", enabled: false, 
	description: "Tori brought ‘frames’ today. They are for storage of honey. There are various levels of them. I let her install them. I was busy making sure the new Queen did not die. Tori seemed to understand something I didn’t, and offered to sit with me and hold my hand. I do not like hand holding. It helped. Tori told me all about how this is natural, and I asked her if it was like when Rattatas eat your plants, and after a moment, she said yes. It will be sad when the Queen dies. It will happen, but it is natural. Like Rattatas eating your plants." },
    { name: "Chapter 5: New Queen", enabled: false, 
	description: "The Bees slowed down today, and Tori helped me move the new Queen to a safe place. She is much more careful than me. The bees seem to like her. The bees also like her food. She uses my crops and the Bee’s honey in her restaurant. I also like Tori’s food." },
    { name: "Chapter 6: Farm", enabled: false, 
	description: "I have forgotten to make notes for quite some time. Tori and I were focusing heavily on the bees, and she was helping me with the Floral Resea- Farm. Tori was helping me with the farm. The Bees need a lot of trees to pollenate, which will lead to more mutations in my part of the farm, while making crops grow faster in Tori’s side of the farm. Tori asked if she could bring in farm animals.I do not like farm animals. They are loud, and Tauros attacked me before. When Tori is around they are nice. Tori tells me they will be nice when I am not around as well. I do not believe her. Apparently more than just Bee Pokemon interact with plants. Environmental variables can alter the produce Bees create, but all Pokemon can help me with Floral Research. It is… nice seeing Tori’s Bulbasaur help with the collection of finished plants. They hold the plants still while I study them. They respond well to praise. I also respond well when Tori praises me. I do not have to prove my research is worth something when Tori is around. I like Tori. I also like Tori’s food. Her food we create on our farm. I am a Farmer. I will not attack Floral Researchers with Tauros." },
]
)


AdventureGuide.register_book(
  id: :cooking,
  name: "Enterprising Eats",
  description: "A guide to cooking and recipes for resourceful gourmand.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "An enterprising Trainer tends to find themselves in situations where they aren’t near a town, are out of money, and are out of supplies, I have found myself in that position many-a-time. Don’t fret, however! Ancient Trainers knew something modern Trainers have no clue about, but I will bless you with this knowledge.\n\nBasically anything a Pokémon can eat, we can eat too! You see that Rattata going for that Oran Berry? Fight em for it. You can cook that on a campfire and live another day! You see that Ursaring in the water? You can drink that! …well maybe not THAT water, that’s the Ursaring’s water and you don’t wanna die, but if you find water that DON’T have an Ursaring in it and maybe a Luvdisc or something you are good. That’s your water now. Drink it. Eat all the fish in it. Cook all the fish in it. Stab the Luvdisc with a knife and eat that too. Don’t stab the Ursaring though, personal experience, they react really poorly to being stabbed. Either way, I got a list of recipes I wanna share with you that I made up when I couldn’t find where the nearest town was from Mount Coronet! With enough effort though, you can get out of any kind of sticky wicket." },
    { name: "Chapter 2: Cooked Oran, Apple, and Potato", 
	enabled: false, description: "If you got a campfire or some kinda heat, you can just shove a bunch of Oran Berries in there. They don’t… fill that much, but it’s real easy to cook! You can do the same thing with Apples and Potatoes to a similar result, but they taste real good. One drawback with the Oran Berries though is that cooking em like that cooks out a lot of the healing juices. The first C you gotta do in any situation is: Cook in my opinion." },
    { name: "Chapter 3: Meats", enabled: false, 
	description: "Look we all do things we ain’t proud of, but when you are starvin, that Goldeen in the water looks a lot more appealing as something well… *to catch* over something… *to catch.* A lot of Pokémon taste a lot better than you think they would. Ain’t no shame in just… takin some of the meat leftover from beating up a Pokémon. It’s better to eat wild Pokémon than to be starvin and thinking of eating your own. …but if you both are starvin, better for one of you to get somethin to eat than both of you die. All Pokémon cook real well, well… most do. Metal ain’t too healthy to eat. Neither are rocks." },
    { name: "Chapter 4: Stews", enabled: false, 
	description: "If you got a lot of bones around you, ain’t no harm in makin that into a broth, you just need some water, to make a basic broth, and then some meats for a full on stew. Lot more filling than meat and berries, but unlike the prior options, you need a big ol’ cauldron or somethin to cook it in. Still nice when you can get somethin’ so fillin." },
    { name: "Chapter 5: Drinks", enabled: false,
      unlocks_book: :cooking2, description: "Talkin about berries last time made me realize one of the best uses for berries! If you mash some Oran Berries and Sitrus Berries together, you can take that mashed up set of berries, mix it into a bottle with some sugar, and make a real tasty drink. You can also make some juice out of Oran Berries by themselves. Theres other stuff you can find around to make drinks with, like Lemons for Lemonade, or Tea Leaves for Tea. Most of this junk does need clean water though, which is why the best thing you can drink is just water straight from the river! If it ain’t kill Pokemon, it ain’t kill me!" }
  ]
)

AdventureGuide.register_book(
  id: :cooking2,
  name: "Culinary Curiosities",
  description: "A guide to meals for a clever culinarian.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "Papa was a very impulsive man, but he loved food early. When I was a little girl, he taught me many things, and I loved him dearly. Papa’s disappearance taught me something about his passions that he never seemed to realize. Some Pokémon avoid certain foods. Things may not kill you, but they may, in fact, disagree with you personally.  Not every flavor agrees with you, but there are five core flavors. \n\nSpicy\nDry, which some may call Fresh, or even Salty\nSweet\nBitter\nSour\n\nSome flavors are liked, some flavors are disliked. I have a personal distaste for dry flavors, myself, while I am quite partial to spice. " },
    { name: "Chapter 2: Prepping", enabled: false, 
	description: "My restaurant has two prep stations in it, a prep station for preparing to cook, and a Prep Station for adding the finishing touches before bringing it out. Both are important, but Papa tended to focus more on the act of cooking itself as a means to an end, whereas cooking should be something one enjoys. The ways you add to a food after someone like Papa would call it complete can have more effects than one could think, it could be more filling, it could change its flavor profile, it could pull the texture of the meal in a totally different direction. Growing up, I was not the best at this, and Papa would tell me ‘Tori, your puttin too much into it, you ruined the meal!’. There is always a risk when finishing a meal like this that carelessly adding ingredients makes the meal much worse. Care must be taken when prepping a meal. A meal should always be high quality, after all, a low quality meal is ruined." },
    { name: "Chapter 3: Sharing", enabled: false, 
	description: "Food exists to be shared, you have to make enough for yourself, your friends, and your Pokémon. Food has a surprising amount of effects depending on what you use it in? A Poffin has a surprising amount of effect on… what is a good way of putting this… condition, perhaps? Poffins are highly nutritious for Pokémon, and can affect their coat, and other such things. Vice versa, something like Aprijuice affects a Pokémon’s overall… como se dice.. performance. They are a lot more ready to help at tasks. General meals just tend to restore energy for both yourself and who or whatever you are sharing it with." },
    { name: "Chapter 4: Tangent", enabled: false, 
	description: "Perdona, I will use this space for a bit of a tangent today. I was heading into Saffron to purchase some ingredients, and I saw a man dumping perfectly good food into a dumpster! I was ready to chew him out! Things like Potatoes, and Carrots take a good deal of effort to grow, and can be used in meals! Potatoes are such a useful dry ingredient, and Carrots are a useful sweet ingredient! But not as useful as the full honeycombs he was dumping! It occurred to me soon afterwards that he did not seem to realize the true value of what he had." },
    { name: "Chapter 5: Journal", enabled: false, 
	description: "I am afraid that what was going to be a cookbook like Papas is becoming my own journal, but I have to get my thoughts out. I have not had the resources to upkeep my restaurant, generally, that is what the book was originally going to help with, you see. But sales have been up since Piers has shared his produce with me, and I have been able to have money to spare, even. I fear I am taking advantage of him, however. I have visited him a few times since our initial meeting to get a good grounding on his situation, and he needs a lot more than what he has right now. The least I can do is give him money to support his fledgling farm, even if he doesn’t seem to be aware that he has one. When cooking, it is important to work with and support where you source ingredients. …Sometimes that means getting your hands dirty. Papa enjoyed getting his hands dirty in ways I tend to feel were a bit too gruesome, but Papa is not incorrect that sometimes it is eat or be eaten, and meat is the strongest ingredient you can use while prepping a meal. I am hoping Piers will enjoy it." },
    { name: "Chapter 6: Likes and Dislikes", enabled: false, 
	description: "Having been at Pier’s farm more recently, a lot more Pokémon have been drawn over as of late, Piers seems to have an intense dislike of Rattata, which makes some level of sense from what he told me about his ‘Floral Inventing’, but Pokémon like Baltoy aren’t too common to the region. A lot of my time has been spent learning what all these new Pokémon like and dislike. I mentioned it in passing in an earlier chapter, but it is very important to give space for it here. A Pokémon’s personality heavily impacts the kind of flavour profiles it likes. By taking care to learn what flavors a Pokémon likes, it helps them warm up to you and feel less isolated. On the other hand, Pokémon will react extremely negatively to things they dislike. Much like Piers, admittedly. Both Piers and all the Pokémon showing up need some love shown to them by a good meal. I wish I could have paired it with some of Papa’s stories though. He always had the silliest ones." },
    { name: "Chapter 7: Farming", enabled: false, 
	description: "A lot of the newer Pokémon that showed up ended up reacting poorly to the butcher, admittedly. I… should have seen that coming. A lot of Pokémon understand that some Pokémon can just be… food sometimes. More emotionally fragile ones don’t. Baltoy stayed, though, my niece says he’s just like Piers, so she’s called him Piers Jr. They both seem a little Serious, they both make weird faces whenever you give them something Sweet. ‘Piers Jr’ tends to go help Piers with the bees, and has even started mimicking his tendency to take notes. Piers Jr aside, and butchering aside, the farm is going well. Piers was worried for a while the Pokémon might eat his crops, but he’s started accepting their help. The former Champion Agatha actually showed up at our restaurant yesterday, and she said something I agree with a lot. ‘Food helps people open up their hearts to each other, dearie, especially when a soul has been emotionally starved.’" },
]
)

AdventureGuide.register_book(
  id: :pokemon_care,
  name: "Poké Pursuits",
  description: "A guide to Pokémon care for aspiring caretakers.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, description: "Pokémon, as lovely as they are, are complex creatures. Much like us, they can age, and they can die. Most Pokémon can, at least. Most Trainers can get their Pokémon checked out at Pokémon centers to see how well they are, feed them medicines, and do their best to prolong their lives. Ghost types lack these problems, overall. Pokemon if loved, and cared for deeply, when laid to rest, will eventually return to you. This does not mean you should not mind the health of those you are still living with. You must be as attentive to them as you are to any other, and this does not mean you should not be attentive to those who have returned after passing.\n\nAll Pokemon deserve constant love, care, and attention." },
    { name: "Chapter 2: Needs", enabled: false, description: "A Pokémon needs more than just love, obviously. It needs food, and water. They may not be as pressing for some Pokémon as others, but I am sure even if a Pokémon does not require it, giving it is appreciated. A Pokémon needs rest, and not just rest inside their Pokéballs, as that is not truly restful for the poor dears. A proper rest in a proper bed, either with you, or in their own cute little one will be enough to cure them of even their most mortal woes. Beauty sleep helps everyone, dearie, and speaking of beauty, Pokémon need grooming and attention. They need love and pets. They need every bit of love you can give them." },
    { name: "Chapter 3: Natures", enabled: false, description: "Each Lil Pokémon’s personality as as varied as can be, this impacts the kinds of foods the lil ones enjoy, and the kinds of play they like. Some Pokémon are especially loving, some are sturdy as a brick mountain, others as serious as an old fuddyduddy, and then some poor darlings could have their hearts filled with hate. Caring for a Pokémon requires being attentive to that personality of it’s, as how you treat the little one can close or open its heart. An open heart means the Pokémon is happy and comfortable, like every lil one should be." },
    { name: "Chapter 4: Happiness", enabled: false, description: "What makes a Pokémon happy is as different as there are stars in the sky, but basic things like grooming and petting are always a start. Keeping them with you, letting them explore, letting them get stronger, and grow. Sometimes this means things will happen to bring down the poor dears mood. You help them through it, you help make sure they are stronger so that meanie can never hurt them again. And when they are back to the normal happy self, playing with the others, and busy having fun.\n\nYou go and personally make sure that meanie can never hurt them again." },
    { name: "Chapter 5: Loyalty", enabled: false,
      unlocks_book: :pokemon_adventures , description: "I see people point to badges, and levels, and so many things that cause a Pokémon to be ‘obedient’. I don’t see meanies like evil Teams have a bunch of badges or levels, they are often pathetically weak at best. Yet their Pokémon still listen to them, they may be hurting and lack affection, but by some miracle, they are still *loyal.* The less loyal a Pokémon is, the more likely they are to disobey, even if the dear is happy. It’s hard for some people to accept that, I think. That Pokémon are their own people. That’s when they get mean, that’s when they are liable to be their most evil. My Pokémon may leave, they might not be loyal, but that’s okay. I don’t hold it against them, because that’s their choice. But when other people take that choice away from their Pokémon, oh it just… twists me up into knots. I go and help the poor dears, I make the problem go away, and I help them be happy again, so they can forget about that old meanie that used to own them. They are free to do whatever they want." },
    { name: "Chapter 6: Foods", enabled: false, description: "Pokémon have different foods they like, and depending on what you feed them, they might react positively, negatively, or not feel too strongly about it. You don’t need to always be feeding your Pokémon their favorite foods, and it’s cruel to me to give them something they hate. I do understand however that sometimes when the budget is tight and you only have so much you *can* give that the poor dears have to make do. I’ve had to live with that a few times, myself. Learning what your Pokémon likes or dislikes is a lot of  trial and error, but it's always worth it. It twists me up in knots when I see someone not even trying to learn, though. It’s not a hard problem to fix. The new dears always tend to hate the exact food their previous owners always fed them." },
    { name: "Chapter 7: Moods", enabled: false, description: "Pokémon aren’t static, just like you and me they go through a lot of feelings in one day. They can be happy with you, they can be loyal to you, but that does not mean they are in a happy mood. Sometimes the dears are sad. Sometimes they are angry. Sometimes they are so full of energy that they just… don’t know what to do with. Feelings aren’t bad, but Pokémon certainly appreciate paying attention and reacting to how they feel. The dears can’t speak, but they can certainly be heard if you have an ear out. So many people don’t have an ear out. So many people can’t even read a Pokémon’s expression. My Pokémon love me because I try to understand their moods, uplift them when they are down, listen to their frustrations when they are angry, listen to their joy when they are happy, and play with them when they are zooming around. And one day, when the dearies pass, I know they will come back to me as ghosts. That’s a luxury their previous owners thankfully don’t have." }
  ]
)

AdventureGuide.register_book(
  id: :pokemon_adventures,
  name: "Adventurous Allies",
  description: "A guide to Pokémon independence for overbearing trainers",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "Books tell me Pokémon like going on adventures, big long trips across regions and fighting other trainers and Pokémon, and a lot of Pokémon I have seem to want to do the same. That’s… too scary though. What if I lose? What if one of my Pokémon gets hurt. There’s a lot of safer ways to have Pokémon help you that don’t involve having them… get hurt, and it means you don’t get hurt either! Pokémon are good at different things, and there’s a lot of things around your house they can help with! Humanlike Pokémon and Psychics can do stuff that normally require hands to do, and Ice Type Pokémon can help cool stuff! Fire types can heat stuff up. They are all really useful, and it’s safe too! It’s really easy to avoid Pokémon getting hurt if you just never leave the house, and never let them leave!" },
    { name: "Chapter 2: Exploring", enabled: false,
	description: "Sometimes, when you aren’t making sure your Pokémon are safe, they like to go exploring. They find parts of the house you didn’t know existed, find ways out of the house, or even sometimes fly out the windows just to go outside. Psychic and Ghost types especially can find ways out of the house. I… don’t like that my Pokémon do this, but I can’t really… stop them. I set up a flag outside, and when I blow a whistle they know to come back or else. Sometimes they come back with items! Sometimes they even come back with other Pokémon! Or Eggs! When they come back with Eggs, I make it really clear they have to stay in the house and take care of the Eggs. If they try to leave during this time, I get mad at them. They shouldn’t really act like my parents did when I was growing up." },
    { name: "Chapter 3: Eggs", enabled: false,
	description: "Sometimes when I wake up in the morning, Pokémon that I haven’t really had tasks for recently have left an Egg for me in one of the empty beds laying around. I make sure at least some of the Pokémon take care of it, but I prefer when the Fire Types do it, especially ones like Carkol or Slugma, who get the eggs hatched even faster than other Pokémon. Once they are hatched, I can give them a job and keep them safe. Until they try to leave. \n\nIf they leave though, I will have another empty bed again. For another Egg." },
    { name: "Chapter 4: Risk", enabled: false,
	description: "Baltoy decided to explore again a few days ago. I told it that it shouldn’t. I blew the whistle, and Baltoy didn’t come back. Normally my other little explorers see them when they are off exploring when they don’t think I can see. Normally more of them don’t come back than average. But sometimes… when something happens, all my Pokémon realize how much safer it is at home. Since Baltoy didn’t come back, the others knew better than to explore. They’ll forget how dangerous it is in a few more days, and the cycle will repeat." },
    { name: "Chapter 5: Disloyal", enabled: false,
	description: "I woke up today to an empty house. They all left. I’m sure some of them will come back. I am sure I will see some of them again. They would be happier if they were just loyal and listened to me, but disloyal Pokémon will always be unsafe. Disloyal Pokémon will always be unhappy. The Loyal ones come back, even if they are only loyal because I’m safe. Even if they are only loyal because just like me, they are scared. If they knew better, they would know I’m scarier than the outside when I want to be." },
    { name: "Chapter 6: Control", enabled: false,
	description: "I went to go get milk today for the first time in a long time, normally the Pokémon do it. They were so helpful bringing it back home. I love it when the first ones start coming back home. It’s safe here. They won’t get hurt. They recognize they hurt me when they leave. They recognize they hurt me when they get hurt. The house was so empty with them gone. The second I passed by each one of them and looked them in the eyes, they followed behind me like they hadn’t been Disloyal. Loyalty is so easy when they know better." }
  ]
)



AdventureGuide.register_book(
  id: :structures1,
  name: "Ruinous Repertoire",
  description: "A guide to surviving in what is left for aged adventurers.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "When one finds themselves in a particular kind of sticky wicket, trapped in a room in the middle of an ancient Pokotopian temple, surrounded on all sides by hostiles, if be man, Pokémon, or both, one must remember the 3 Cs. Consider, Chatter, and Craft. When I found myself trapped atop the Cubone Tree, with those river rapids below me, and that group of angry Fearow after me, did I hesitate? No. I leap, making even the birds think I went into those rapids while I hid in that Cubone tree's skull. Any single structure around you can be your boon, or in the case of that Temple where I was surrounded: Bane. Sometimes you will always be in a place where you can’t do one or more of the C’s. That just means you have to do the last one 3 times as hard. Don’t let yourself get caught out, don’t let yourself be unprepared, and don’t let yourself be caught with your pants down." },
	{ name: "Chapter 2: Dodging Shots", enabled: false, 
	description: "When in that ancient Pokotopian temple, you gotta watch out for not only the devilish Pokémon that thrive within the blood of dead men, but also the traps they lay. That rock? Pass by it and the Geodude opens its devilish inhuman eyes and ATTACKS. That pressure plate that might open the door? Sets off an arrow trap to impale your plucky sidekick in the skull. You gotta be ready for ANYTHING in these places, or they will tear your limb from stinking limb, and your only way out will be through sheer dumb luck and the 3 Cs. Take that shield and block that arrow. Considering if that rock might be in the exact spot to cut you off. Never shut up so they don’t know your next move. And always… ALWAYS bring a snack." },
	{ name: "Chapter 3: Chasing Bandits", enabled: false, 
	description: "You successfully got uncornered, and you are finally up against the BIG GUY, and he’s making his run, and he’s trying his best to show you whats for. Nows the time to consider: Should I talk, or should I craft. And then after that, consider even HARDER, how does this guy attack? Is he following any pattern? Can I hit him from a distance or do I just gotta get in there and beat. him. down. Then remember the FOURTH C.  *Comrades.* If the other guy can come in with his group, trapping you in a sea of hostiles, you can throw out your guys too. Except Togepi. We don’t let babies fight here." },
	{ name: "Chapter 4: Securing Loot", enabled: false, 
	description: "You beat down the BIG GUY, and you and your guys are basking in the afterglow of the experience. You all feel like your potential increased today. Now… *you gotta go back in.* You might have wiped out every guy in that place, and more of em might have even come, but you gotta be sure you got *every* single piece of loot, out of *every single chest.* Maybe more chest appeared while you were fighting that big guy. You ain’t gotta worry about any of your guys, cause no matter how hurt they got, even if  they got knocked out, cause you beat the guy, they are gonna be just fucking peachy, meaning you can go back in and get exactly what you came for." },
	{ name: "Chapter 5: New Place", enabled: false, 
	description: "You beat the BIG GUY, you beat the LITTLE GUYS, you get all the loot. You maybe even got the girl. Now… it’s time to go the NEXT PLACE. Sometimes the next place will be as simple as walking down the stone hall to the next place. Sometimes you have to bring out the FIFTH C. *COMPASS.* And navigate your way to where you gotta be. And if you don’t have a compass. BRING OUT THE SIXTH C. C-MAP. AND IF YOU DONT HAVE A C-MAP, BRING OUT THE SEVENTH C. C-Aimless Wandering. If you go the C-Aimless Wander Route, make sure you have the EIGHTH C. Camping Set. You may not always be able to set up a grand base. But you and your guys can set up a tent. But not Togepi. Don’t let babies set up tents. " },
	{ name: "Chapter 6: Old Place", enabled: false, 
	description: "Just cause you got the new place, you beat up the BIG GUY, you beat up the LITTLE GUYS, you got all the LOOT, and got the GIRL, it doesn’t magically mean places you’ve been to have become POINTLESS. Maybe some of that LOOT allows you to find a NEW PLACE IN THE OLD PLACE. And once you found the NEW PLACE IN THE OLD PLACE, you can find EVEN MORE PLACES. Maybe you can even find NEW LITTLE GUYS IN THE NEW OLD PLACES, OR EVEN NEW BIG GUYS. Or even a SECRET EVIL TEAM THAT MAKES IT THEIR LIFE GOAL TO TURN INNOCENT GUYS INTO NOT SO INNOCENT GUYS. 

The POSSIBILITIES ARE ENDLESS." },
	{ name: "Chapter 7: Places only YOUR GUYS CAN GO", enabled: false, 
	description: "Sometimes when exploring the NEW OLD PLACES, you find places that a man of your stature just can’t make his way into. Sometimes the only guys who can make their way into that kind of sticky wicket are the lil guys. Your lil guys. Sometimes, the entry way to those wickets is so fucking small that you gotta let the baby go. You gotta let that Togepi wander into that CAVE. You gotta let the CHILDREN GO PLACES. Just don’t let Togepi go ALONE. Remember the FOURTH C. COMRADES. And then remember the TWO HUNDRED AND SIXTY NINETH C. SOME CAVES ONLY YOUR GUYS CAN GO IN, AND ALL YOU CAN DO IS STAND  THERE AND WAIT UNTIL THEY GET BACK." },
	{ name: "Chapter 823: Places that you should go back to", enabled: false, 
	description: "You need to remember that one nook on that one mountain that looked PARTICULARLY SUS. And once you have the LOOT that LETS YOU GO TO THAT SPOT ON THAT MOUNTAIN, YOU CAN REACH THE SECRET RAVINE ON THE ISLAND THAT CONTAINS VERSIONS OF THE BIG GUYS YOU CAN ACTUALLY TALK TO AND GET ALONG WITH. AND THEN YOU ALL SING THE 2 MILLIONTH C: CUMBIFUCKINGYA. Just don’t let Togepi say fuck." },
	{ name: "Chapter 9: Remember to take breakies.", enabled: false, 
	description: "Sometimes Togepi needs a lil nippy nap. And when Togepi needs a LIL NIPPY NAP, YOU FIND A PLACE TO MAKE BASE. NOT SET UP A TENT. *MAKE BASE.* BECAUSE TOGEPI NEEDS A FULL ON NIPPY NAP." },
	{ name: "Chapter 10258: Places that you should go back to but probably won’t", enabled: false, hide_once_read: true,
	description: "Home." }
]
)

AdventureGuide.register_book(
  id: :structures2,
  name: "Ceaseless Scamps",
  description: "A guide to scrapping it together for aged adventurers.",
  enabled: false,
  chapters: [
    { name: "Chapter 1: Basics", enabled: false, 
	description: "In those times when you are after your current sticky wicket, and on your way to the next, when your Togepi needs a nippy nap, you may find yourself needing a place to breathe. Caves are the first secure place, trees are the second. I personally prefer tree houses. Either way, you can put down your tools and sit them down with some iron for repairs, and give your pals a place to rest. This is when the 3 Cs are most important: Consider, Chatter, and Craft. Consider what you need to do in what little down time you have. Chatter with your pals, make em feel heard, and craft. Craftin is how you get out of most of your sticky wickets unless you wanna risk your Comrades. You just gotta do something, or you start rememberin home. Do the first C and Cook something for Togepi just to stop thinking about it." },
    { name: "Chapter 2: Caving", enabled: false, 
	description: "In those times when your Togepi is nippy napping and your guys are relaxing around your current base, do your best to source tools in the environment. I remember when I was in that grand ice cave, those crystals twinkling like stars. I found something I hadn’t heard anything about in an age. A gleaming blue Tumblestone. Astonishing. The kind of stuff you can find with your trusty pickaxe and an exceedingly large amount of spare time. Reminds me of the 9th C: Caves are my friend.\n\nUnless it's a really big one. There’s the old Sinnoh adage: A big cave means big misery. If that bitch looks like it has more than one entrance, that cave will take somethin from you." },
    { name: "Chapter 3: Surfing", enabled: false, 
	description: "In those times when your Togepi wants to go for a lil swimmy swim, you gotta remember that the ocean is a *dangerous place for a lil baby.* Not that you can’t take em, but you gotta attend the lil baby. It’s easy for hostile guys to jump you while you are taking to the water, even if you are on the back of your own guy. Thankfully, heading out on the water with your lil baby, you can sometimes find stuff you didn’t think could be out there. Why once, I found a… well, that’s a story for another day." },
    { name: "Chapter 4: Natives", enabled: false, 
	description: "You would not believe how wide the world we live in is. Did you know Kanto once made a clone of a psychic Pokémon so powerful it could talk to humans? People seem to think that was only something man could do. Pokémon have proven themselves as smart as man since day one. Some stories say Lugia, the legendary guardian of the seas, has talked to humans. Some say the Legendary Beasts have. Humans aren’t the only ones with a monopoly on language. Nothing is saying that Meowth you got can’t suddenly start talkin one day. And what happens when you are visiting a place man has never been, but Pokeman has. 
" },
    { name: "Chapter 5: Basics", enabled: false, 
	description: "Sometimes you go into a place, and you think “other humans can’t be here” “this is the ass end of nowhere”, and you think all you have to care about is you and your Pokémon, your *friends*. It’s you against the world. It’s you against the elements. But the first sign you got of seeing someone like you in a place they shouldn’t be well… you gotta remember this if you want to survive.\n\nGone are the Pokémon Centers, Shops, Gyms. Gone are the houses,  villagers, and friendly Professors. Gone is your little girl. It’s just you and however many Pokémon you are trapped with there. And worst of all… you're pretty sure someone out there wants you very, very dead." }
]
)


