module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }
  
  # Here's the simplest example of a single-stage quest with everything specified
  PSIMQ1 = {
    :ID => "1",
    :Name => "Survival Island (I)",
    :QuestGiver => "nil",
    :Stage1 => "Find your bag.",
    :Stage2 => "Look through everything in your bag throughly.",
    :Stage3 => "Survive.",
    :Stage4 => "Thrive.",
    :Location1 => "nil",
    :QuestDescription => "Your Ship has crashed on this island, try and survive.",
    :RewardString => "nil"
  }
  
  # Here's an extension of the above that includes multiple stages
  PSISQ1 = {
    :ID => "2",
    :Name => "Climbing Gear",
    :QuestGiver => "nil",
    :Stage1 => "Find your Climbing Gear.",
    :Stage2 => "Maybe your Climbing Gear is in there.",
    :Location1 => "nil",
    :QuestDescription => "Find your climbing gear.",
    :RewardString => "nil"
  }
  
  PSISQDS = {
    :ID => "3",
    :Name => "Ol' Cro's Boat",
    :QuestGiver => "Ol' Cro",
    :Stage1 => "Make a large boat for Old Cro'",
    :Location1 => "nil",
    :QuestDescription => "The Old Crogunk on the River wants a boat to head down the river with, he's a water type, so that's weird.",
    :RewardString => "nil"
  }
  
  PSIMQ2 = {
    :ID => "4",
    :Name => "Survival Island (II)",
    :QuestGiver => "nil",
    :Stage1 => "Explore the Island.",
    :Location1 => "nil",
    :QuestDescription => "You've met a few people on your Travels, see if you can meet more.",
    :RewardString => "nil"
  }
  
  #Stage 2 is for without the Partner.
  #Stage 3 is for with the partner.
  PSISQ2 = {
    :ID => "5",
    :Name => "Pollyanna",
    :QuestGiver => "nil",
    :Stage1 => "Hear them out.",
    :Stage2 => "Locate the Missing Pokemon.",
    :Stage3 => "Return the Missing Pokemon.",
    :Location1 => "Temperate Swamp",
    :QuestDescription => "Someone has had their POKeMON stolen! Quick! Find them!",
    :RewardString => "nil"
  }
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }

end
