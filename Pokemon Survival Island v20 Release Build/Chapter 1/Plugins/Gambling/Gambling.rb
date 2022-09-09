def pbblackJack

  if Kernel.pbConfirmMessage(_INTL("Do you want to try your luck?"))
    if $PokemonGlobal.coins>0
  params=ChooseNumberParams.new
  params.setMaxDigits(9)
  params.setRange(1,99) 
  params.setInitialValue($PokemonGlobal.coins) 
  params.setCancelValue(0)
  qty=Kernel.pbMessageChooseNumber(_INTL("How much do you want to bet?"),params) 
    num=rand(14)+1
    numo=rand(21)+1
    Kernel.pbMessage(_INTL("Your number is{1}",num))
    
if Kernel.pbConfirmMessage(_INTL("Do you want another card?"))
  numot=rand(14)+1
  num=num+numot
  Kernel.pbMessage(_INTL("You have a total of {1}",num))
  if num>21
    Kernel.pbMessage(_INTL("Bust!"))
  else
    num=num
    end
else
  Kernel.pbMessage(_INTL("You got {1}",num)) 
end

if num>numo
    Kernel.pbMessage(_INTL("You got {1}. Your opponent got {2}. You won!",num,numo))
  $PokemonGlobal.coins=$PokemonGlobal.coins+qty*2
  pbCommonEvent(30)
  
  elsif num==numo
  Kernel.pbMessage(_INTL("You got {1}. Your opponent got {2}. Draw!",num,numo))
  pbCommonEvent(30)

   else
    Kernel.pbMessage(_INTL("You got {1}. Your opponent got {2}.",num,numo))
  $PokemonGlobal.coins=$PokemonGlobal.coins-qty
  pbCommonEvent(30)
  
end

else
    Kernel.pbMessage(_INTL("You don't have enough money!"))
    end
else
  Kernel.pbMessage(_INTL("Talk to me if you ever want to play"))
end

end

######################################INSTRUCTIONS####################################
###  1. in your event call Pokepoker.new(X,Y) script command
###       X is the fee to enter the game
###       Y is the value of the blind
###     example -  Pokepoker.new(500,10) will start a game where everyone will have
###     500 chips at the start and a blind value of 10 chips
###  2. if you want npc names to never change set @randomnpcnames in line 15 to false
###  3. set @chipsvariable in line 14 to the number of an empty game variable
######################################################################################

class Pokepoker
 
  def initialize(fee,blindvalue)
    @chipsvariable = 292
    @randomnpcnames = false
    @deck = [
    [1,"Two of Spades",2,"Spades"],
    [2,"Three of Spades",3,"Spades"],
    [3,"Four of Spades",4,"Spades"],
    [4,"Five of Spades",5,"Spades"],
    [5,"Six of Spades",6,"Spades"],
    [6,"Seven of Spades",7,"Spades"],
    [7,"Eight of Spades",8,"Spades"],
    [8,"Nine of Spades",9,"Spades"],
    [9,"Ten of Spades",10,"Spades"],
    [10,"Jack of Spades",11,"Spades"],
    [11,"Queen of Spades",12,"Spades"],
    [12,"King of Spades",13,"Spades"],
    [13,"Ace of Spades",14,"Spades"],
    [14,"Two of Clubs",2,"Clubs"],
    [15,"Three of Clubs",3,"Clubs"],
    [16,"Four of Clubs",4,"Clubs"],
    [17,"Five of Clubs",5,"Clubs"],
    [18,"Six of Clubs",6,"Clubs"],
    [19,"Seven of Clubs",7,"Clubs"],
    [20,"Eight of Clubs",8,"Clubs"],
    [21,"Nine of Clubs",9,"Clubs"],
    [22,"Ten of Clubs",10,"Clubs"],
    [23,"Jack of Clubs",11,"Clubs"],
    [24,"Queen of Clubs",12,"Clubs"],
    [25,"King of Clubs",13,"Clubs"],
    [26,"Ace of Clubs",14,"Clubs"],
    [27,"Two of Diamonds",2,"Diamonds"],
    [28,"Three of Diamonds",3,"Diamonds"],
    [29,"Four of Diamonds",4,"Diamonds"],
    [30,"Five of Diamonds",5,"Diamonds"],
    [31,"Six of Diamonds",6,"Diamonds"],
    [32,"Seven of Diamonds",7,"Diamonds"],
    [33,"Eight of Diamonds",8,"Diamonds"],
    [34,"Nine of Diamonds",9,"Diamonds"],
    [35,"Ten of Diamonds",10,"Diamonds"],
    [36,"Jack of Diamonds",11,"Diamonds"],
    [37,"Queen of Diamonds",12,"Diamonds"],
    [38,"King of Diamonds",13,"Diamonds"],
    [39,"Ace of Diamonds",14,"Diamonds"] ,
    [40,"Two of Hearts",2,"Hearts"],
    [41,"Three of Hearts",3,"Hearts"],
    [42,"Four of Hearts",4,"Hearts"],
    [43,"Five of Hearts",5,"Hearts"],
    [44,"Six of Hearts",6,"Hearts"],
    [45,"Seven of Hearts",7,"Hearts"],
    [46,"Eight of Hearts",8,"Hearts"],
    [47,"Nine of Hearts",9,"Hearts"],
    [48,"Ten of Hearts",10,"Hearts"],
    [49,"Jack of Hearts",11,"Hearts"],
    [50,"Queen of Hearts",12,"Hearts"],
    [51,"King of Hearts",13,"Hearts"],
    [52,"Ace of Hearts",14,"Hearts"]      
    ]
    @pot = 0
    @playersup = 0 
    @comcard1 = 0
    @comcard2 = 0
    @comcard3 = 0
    @comcard4 = 0
    @comcard5 = 0
    @roundover = 0
    @noraise = 5
    @playing = 0 ###highlight whos playing
    @call = 0 #value to call
    @skips = 1 #value to check if round is over
    @deckp = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,
    27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52]
    @blind = 0
    @blindvalue = blindvalue
    @round = 1
    @gameover = 0
    @previousbet = 0
    @fee = fee
    @players = [[0,1,1,$Trainer.name],
                [0,1,1,"Xatu"],
                [0,1,1,"Xatu"],
                [0,1,1,"Xatu"]]  ### #1- chips  #2- is up for round? #3- out of chips? #4- name
                
    ### if randomnpcnames is true it will randomize the player names                
    if @randomnpcnames == true
      @randomnames = ["Jack","Sue","Chad","Ted","Barney","Lily","Robin","Marshall","Jim","Jack","Tom","Sarah","Anna"]
      @randomnames.shuffle!                      
      @players[1][3] = @randomnames[0]
      @players[2][3] = @randomnames[1]
      @players[3][3] = @randomnames[2]
    end
    @players[0][0] += @fee
    @players[1][0] += @fee
    @players[2][0] += @fee
    @players[3][0] += @fee
    @player1card1 = 0
    @player1card2 = 0
    @player2card1 = 0
    @player2card2 = 0
    @player3card1 = 0
    @player3card2 = 0
    @player4card1 = 0
    @player4card2 = 0
    @decision = 0
    @raisevalue = 0
    @player1srr = 0
    @player2srr = 0
    @player3srr = 0
    @player4srr = 0     
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)  ## viewport for background table
    @viewport.z=1
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height) ##viewport for stuff that goes on table
    @viewport2.z=2
    @viewport3=Viewport.new(0,0,Graphics.width,Graphics.height) ##viewport for written stuff
    @viewport3.z=3
    @viewport4=Viewport.new(0,0,Graphics.width,Graphics.height) ##viewport for the bet / raise
    @viewport4.z=4    
    @viewport5=Viewport.new(0,0,Graphics.width,Graphics.height) ##viewport for select arrow
    @viewport5.z=5
    @sprites={}
    @sprites["background"] = Sprite.new(@viewport)   
    @sprites["background"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/pokerbg") ###table sprite
    @sprites["player1border"] = Sprite.new(@viewport2)
    @sprites["player1border"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/names")
    @sprites["player1border"].x = 16
    @sprites["player1border"].y = 254
    @sprites["player2border"] = Sprite.new(@viewport2)
    @sprites["player2border"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/names")
    @sprites["player2border"].x = 16
    @sprites["player2border"].y = 16
    @sprites["player3border"] = Sprite.new(@viewport2)
    @sprites["player3border"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/names")
    @sprites["player3border"].x = 370
    @sprites["player3border"].y = 16    
    @sprites["player4border"] = Sprite.new(@viewport2)
    @sprites["player4border"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/names")
    @sprites["player4border"].x = 370
    @sprites["player4border"].y = 254
    @sprites["player1chips"] = Sprite.new(@viewport2)
    @sprites["player1chips"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/chipscounter")
    @sprites["player1chips"].x = 16
    @sprites["player1chips"].y = 210
    @sprites["player2chips"] = Sprite.new(@viewport2)
    @sprites["player2chips"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/chipscounter")
    @sprites["player2chips"].x = 16
    @sprites["player2chips"].y = 60
    @sprites["player3chips"] = Sprite.new(@viewport2)
    @sprites["player3chips"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/chipscounter")
    @sprites["player3chips"].x = 432
    @sprites["player3chips"].y = 60   
    @sprites["player4chips"] = Sprite.new(@viewport2)
    @sprites["player4chips"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/chipscounter")
    @sprites["player4chips"].x = 432
    @sprites["player4chips"].y = 210    
    @sprites["roundcounter"] = Sprite.new(@viewport2)
    @sprites["roundcounter"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/roundcounter")
    @sprites["roundcounter"].x = 203
    @sprites["roundcounter"].y = 6 
    @sprites["potcounter"] = Sprite.new(@viewport2)
    @sprites["potcounter"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/potcounter")
    @sprites["potcounter"].x = 214
    @sprites["potcounter"].y = 234
    @sprites["p1name"] = Sprite.new(@viewport3)
    @sprites["p1name"].bitmap = Bitmap.new(114,24)
    @sprites["p1name"].x = 22
    @sprites["p1name"].y = 260
    textarray = [[@players[0][3],57,0,2,Color.new(0,0,0),Color.new(255,255,255),false]]
    pbDrawTextPositions(@sprites["p1name"].bitmap,textarray)
    @sprites["p2name"] = Sprite.new(@viewport3)
    @sprites["p2name"].bitmap = Bitmap.new(114,24)
    @sprites["p2name"].x = 22
    @sprites["p2name"].y = 22
    textarray = [[@players[1][3],57,0,2,Color.new(0,0,0),Color.new(255,255,255),false]]
    pbDrawTextPositions(@sprites["p2name"].bitmap,textarray)
    @sprites["p3name"] = Sprite.new(@viewport3)
    @sprites["p3name"].bitmap = Bitmap.new(114,24)
    @sprites["p3name"].x = 376
    @sprites["p3name"].y = 22
    textarray = [[@players[2][3],57,0,2,Color.new(0,0,0),Color.new(255,255,255),false]]
    pbDrawTextPositions(@sprites["p3name"].bitmap,textarray)
    @sprites["p4name"] = Sprite.new(@viewport3)
    @sprites["p4name"].bitmap = Bitmap.new(114,24)
    @sprites["p4name"].x = 376
    @sprites["p4name"].y = 260
    textarray = [[@players[3][3],57,0,2,Color.new(0,0,0),Color.new(255,255,255),false]]
    pbDrawTextPositions(@sprites["p4name"].bitmap,textarray)
    @sprites["p1chips"] = Sprite.new(@viewport3)
    @sprites["p1chips"].bitmap = Bitmap.new(52,24)
    @sprites["p1chips"].x = 22
    @sprites["p1chips"].y = 216
    textarray = [[@players[0][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["p1chips"].bitmap,textarray)    
    @sprites["p2chips"] = Sprite.new(@viewport3)
    @sprites["p2chips"].bitmap = Bitmap.new(52,24)
    @sprites["p2chips"].x = 22
    @sprites["p2chips"].y = 66
    textarray = [[@players[1][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["p2chips"].bitmap,textarray)        
    @sprites["p3chips"] = Sprite.new(@viewport3)
    @sprites["p3chips"].bitmap = Bitmap.new(52,24)
    @sprites["p3chips"].x = 438
    @sprites["p3chips"].y = 66
    textarray = [[@players[2][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["p3chips"].bitmap,textarray)            
    @sprites["p4chips"] = Sprite.new(@viewport3)
    @sprites["p4chips"].bitmap = Bitmap.new(52,24)
    @sprites["p4chips"].x = 438
    @sprites["p4chips"].y = 216
    textarray = [[@players[3][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["p4chips"].bitmap,textarray)                
    @sprites["potvalue"] = Sprite.new(@viewport3)
    @sprites["potvalue"].bitmap = Bitmap.new(52,24)
    @sprites["potvalue"].x = 230
    @sprites["potvalue"].y = 250
    textarray = [[@pot.to_s,26,0,2,Color.new(255,255,255),Color.new(248,240,160),false]]
    pbDrawTextPositions(@sprites["potvalue"].bitmap,textarray)
    @sprites["bet"] = Sprite.new(@viewport4)
    @sprites["bet"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/betborder")
    @sprites["bet"].x = 304
    @sprites["bet"].y = 237
    @sprites["bet"].opacity = 0
    @sprites["betvalue"] = Sprite.new(@viewport5)
    @sprites["betvalue"].bitmap = Bitmap.new(52,24)
    @sprites["betvalue"].x = 310
    @sprites["betvalue"].y = 243
    textarray = [[@raisevalue.to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["betvalue"].bitmap,textarray)    
    @sprites["betvalue"].opacity = 0
    @select = 1
    @sprites["p1_1"] = Sprite.new(@viewport2)
    @sprites["p1_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p1_1"].x = 84
    @sprites["p1_1"].y = 204
    @sprites["p1_1"].opacity = 0
    @sprites["p1_2"] = Sprite.new(@viewport2)
    @sprites["p1_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p1_2"].x = 124
    @sprites["p1_2"].y = 204
    @sprites["p1_2"].opacity = 0
    @sprites["p2_1"] = Sprite.new(@viewport2)
    @sprites["p2_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p2_1"].x = 84
    @sprites["p2_1"].y = 54
    @sprites["p2_1"].opacity = 0
    @sprites["p2_2"] = Sprite.new(@viewport2)
    @sprites["p2_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p2_2"].x = 124
    @sprites["p2_2"].y = 54
    @sprites["p2_2"].opacity = 0
    @sprites["p3_1"] = Sprite.new(@viewport2)
    @sprites["p3_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p3_1"].x = 356
    @sprites["p3_1"].y = 54
    @sprites["p3_1"].opacity = 0
    @sprites["p3_2"] = Sprite.new(@viewport2)
    @sprites["p3_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p3_2"].x = 396
    @sprites["p3_2"].y = 54
    @sprites["p3_2"].opacity = 0
    @sprites["p4_1"] = Sprite.new(@viewport2)
    @sprites["p4_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p4_1"].x = 356
    @sprites["p4_1"].y = 204
    @sprites["p4_1"].opacity = 0
    @sprites["p4_2"] = Sprite.new(@viewport2)
    @sprites["p4_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["p4_2"].x = 396
    @sprites["p4_2"].y = 204
    @sprites["p4_2"].opacity = 0
    @sprites["c1"] = Sprite.new(@viewport2)
    @sprites["c1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["c1"].x = 160
    @sprites["c1"].y = 129
    @sprites["c1"].opacity = 0
    @sprites["c2"] = Sprite.new(@viewport2)
    @sprites["c2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["c2"].x = 200
    @sprites["c2"].y = 129
    @sprites["c2"].opacity = 0
    @sprites["c3"] = Sprite.new(@viewport2)
    @sprites["c3"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["c3"].x = 240
    @sprites["c3"].y = 129
    @sprites["c3"].opacity = 0
    @sprites["c4"] = Sprite.new(@viewport2)
    @sprites["c4"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["c4"].x = 280
    @sprites["c4"].y = 129
    @sprites["c4"].opacity = 0
    @sprites["c5"] = Sprite.new(@viewport2)
    @sprites["c5"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
    @sprites["c5"].x = 320
    @sprites["c5"].y = 129
    @sprites["c5"].opacity = 0
    @sprites["sq1"] = Sprite.new(@viewport2)
    @sprites["sq1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
    @sprites["sq1"].x = 210
    @sprites["sq1"].y = 46
    @sprites["sq2"] = Sprite.new(@viewport2)
    @sprites["sq2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
    @sprites["sq2"].x = 234
    @sprites["sq2"].y = 46
    @sprites["sq3"] = Sprite.new(@viewport2)
    @sprites["sq3"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
    @sprites["sq3"].x = 258
    @sprites["sq3"].y = 46
    @sprites["sq4"] = Sprite.new(@viewport2)
    @sprites["sq4"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
    @sprites["sq4"].x = 282
    @sprites["sq4"].y = 46
    @sprites["betui"] = Sprite.new(@viewport4)
    @sprites["betui"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/betui")
    @sprites["betui"].x = 370
    @sprites["betui"].y = 66
    @sprites["betui"].opacity = 0
    @sprites["selectarrow"] = Sprite.new(@viewport5)
    @sprites["selectarrow"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/selectarrow")
    @sprites["selectarrow"].x = 384
    @sprites["selectarrow"].y = 86
    @sprites["selectarrow"].opacity = 0    
    pbpokepokerstart
  end 
  
  ### anounces round number
  def roundannouncement
    if @round == 1
      @sprites["round"] = Sprite.new(@viewport3)
      @sprites["round"].bitmap = Bitmap.new(94,24)
      @sprites["round"].x = 209
      @sprites["round"].y = 12
      @sprites["round"].opacity = 0
      roundtext = "Round " + @round.to_s
      textarray = [[roundtext,47,0,2,Color.new(0,0,0),Color.new(255,255,255),false]]
      pbDrawTextPositions(@sprites["round"].bitmap,textarray)
      10.times do
        @sprites["round"].opacity += 25.5
        pbWait(1)
      end
    else
      10.times do
        @sprites["round"].opacity -= 25.5
        pbWait(1)
      end
      @sprites["round"].bitmap.clear
      @sprites["round"].opacity = 0
      roundtext = "Round " + @round.to_s
      textarray = [[roundtext,47,0,2,Color.new(0,0,0),Color.new(255,255,255),false]]
      pbDrawTextPositions(@sprites["round"].bitmap,textarray)
      10.times do
        @sprites["round"].opacity += 25.5
        pbWait(1)
      end      
    end
    Kernel.pbMessage("Round #{@round} has started.")
  end
 
  ### 2 cards to each player whos in game [i][2] == 1
  ### defines card values (even the face down cards)
  ### reveals player cards
  ### turns on 1st greensq to signal pre flop phase
 def drawcards
    @sprites["sq1"].bitmap.clear
    @sprites["sq1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/greensq")
   if @players[0][2] > 0
    @sprites["p1_1"].opacity = 255
    pbWait(8)
    @sprites["p1_2"].opacity = 255
    pbWait(16)
  end
  if @players[1][2] > 0
    @sprites["p2_1"].opacity = 255
    pbWait(8)
    @sprites["p2_2"].opacity = 255
    pbWait(16)
  end
  if @players[2][2] > 0
    @sprites["p3_1"].opacity = 255
    pbWait(8)
    @sprites["p3_2"].opacity = 255
    pbWait(16)
  end
  if @players[3][2] > 0
    @sprites["p4_1"].opacity = 255
    pbWait(8)
    @sprites["p4_2"].opacity = 255
    pbWait(16)
  end 
    pbWait(20)
    #player 1cards
    if @players[0][2] > 0
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player1card1 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player1card2 = @deck[randomcardvalue-1]
    end
    ##player2 cards
    if @players[1][2] > 0
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player2card1 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player2card2 = @deck[randomcardvalue-1]
    end
    ##player3cards
    if @players[2][2] > 0
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player3card1 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player3card2 = @deck[randomcardvalue-1]
    end
    #player 4 cards
    if @players[3][2] > 0
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player4card1 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @player4card2 = @deck[randomcardvalue-1]
    end
    #### com cards
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @comcard1 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @comcard2 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @comcard3 = @deck[randomcardvalue-1]
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @comcard4 = @deck[randomcardvalue-1] 
    randomcard = rand(@deckp.length)
    randomcardvalue = @deckp[randomcard]
    @deckp.delete_at(randomcard)
    @comcard5 = @deck[randomcardvalue-1]      
    ###chooses a random number from @deckp and assigns the respective card value
    ###the chosen number is the nremoved from @deckp in order to avoid repeated cards
    @sprites["p1_1"].opacity = 0
    @sprites["p1_1"].bitmap.clear
    @sprites["p1_1"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player1card1[0]))
    pbWait(8)
    @sprites["p1_1"].opacity = 255
    pbWait(8)
    @sprites["p1_2"].opacity = 0
    @sprites["p1_2"].bitmap.clear
    @sprites["p1_2"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player1card2[0]))
    pbWait(8)
    @sprites["p1_2"].opacity = 255
    pbWait(8)
  end ## drawcards
 
  ## auxiliary function that handles the whole call raise fold shenanigans
  ## it also sets the @playing that will control who plays next, it will
  ## select the 1st available player to left - pre flop only
  def fsubround
    @previousbet = @blindvalue if @previousbet == 0   ##in pre flop (fsubround) previous bet is blind value
    while @players[@playing%4][1] == 0                ## selects who plays next (skips if player folded)
      @playing += 1
    end
    
    if @playing >= 4      ##if its higher then 3, 4=0, 5=1, 6=2, 7=3
      @playing -= 4
    end
    
    case @playing
    when 0 #player turn
      action = 0                 ##action loop is to make betscene compatible with cancel
      while action == 0
      cmds = [_INTL("Call"),_INTL("Raise"),_INTL("Fold"),_INTL("Quit Game")]
      cmd = Kernel.pbMessage(_INTL("What will you do?"),cmds)
        if cmd == 0
          Kernel.pbMessage("#{@players[0][3]} calls.")
          if @player1bet != @previousbet    ##if there was changes to player coins with this call
            @players[0][0]-= (@previousbet - @player1bet)  ##update player coins
            updatechips(0)  ##update chips bitmap
            @pot += (@previousbet - @player1bet) ##update pot value
            updatepot  ##update pot bitmap
          end
          @noraise -= 1  ##@noraise keeps track of when there's 4 (assigned by playersup) calls to move to next phase
          @player1bet += (@previousbet - @player1bet) ##adds the changed amount to the player1bet 
          action = 1   ##breaks action loop -> next player turn
        elsif cmd == 1
          pbPlayDecisionSE()
          betscene
          if @raisevalue > 0  ##there's a raise
            raise = @raisevalue  
            @pot += (@previousbet - @player1bet + raise) 
            updatepot
            @players[0][0]-= (@previousbet - @player1bet + raise) ##reduces player chips
            updatechips(0)
            @noraise = @playersup  ##since there was a raise the @noraise counter is reseted with @playersup
            @player1bet += (@previousbet - @player1bet + raise) ##increases bet, accounts for the diference player would pay to call
            @previousbet += raise ##increases player bet
            @player1srr += 1      ##signals that there was a raise this sub round -> used for npc ai     
            action = 1
          end
        elsif cmd == 2
          Kernel.pbMessage("#{@players[0][3]} folds.")
          @players[0][1]=0     ## signals the fold, won't take action this round
          @noraise -=1         
          @playersup-=1        ## reduces 1 from playersup, requiring 1 less call to skip to next sub round
          updatefold(0)
          action = 1
        elsif cmd == 3
          Kernel.pbMessage("Oh, it seems #{@players[0][3]} wishes to quit the game.")
          Kernel.pbMessage("You may leave the table after this round, come back anytime.")
          @gameover = 1      ##will break scene loop and exit game on next chance
          @players[0][1] = 0 
          @noraise -=1
          @playersup -=1
          action = 1
          $game_variables[@chipsvariable] = @players[0][0]          ##reward
        end
          @playing=3 if @players[3][1]==1   ##if 1st and 2nd players to the left aren't up it's the 3rd player turn next
          @playing=2 if @players[2][1]==1   ##if 1st player to the left isn't up it's 2nd player turn next
          @playing=1 if @players[1][1]==1   ##if player to the left is up, its his turn next, overwrites previous decisions
      end
          
      when 1 #player2turn
        @decision = npcmove(1)      ##npcmove(X) decides the npc action
        case @decision
        when 1
          Kernel.pbMessage("#{@players[1][3]} calls.")  ##in pre flop u can't check, only call.
          if @player2bet != @previousbet
            @players[1][0]-= (@previousbet - @player2bet)
            updatechips(1)
            @pot += (@previousbet - @player2bet)
            updatepot
          end
        @noraise -=1
        @player2bet += (@previousbet - @player2bet)
        when 2
          rscore = goodcard(1)          ##goodcard(X) judges how good npc hand is, stores 1 2 or 3 in rscore
          b = rand(100)+1
          r1 = 0
          r2 = 0
          lowestchip = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
            lowestchip[i] -= (@previousbet - respectivebet)
          end
          lowestchip.sort!
          ## this determines the lowest effective money any player has to not overbet lowestchip[0]
          ## it reduces the money players would need to call from their effective money to ensure
          ## no one will get negative chips from calling
          r1 = 1 if (@previousbet*3) <= lowestchip[0]   
          r2 = 1 if (@previousbet*4) <= lowestchip[0]
          ## there's 3 types of raise, minimum, medium and high, if r1 = 1 it's okay to make medium bet
          ## if r2 = 1 its okay to make high bet
          case rscore
          ### these chunks decide how high the npc will bet
          when 0
            if b<=100 && b>95 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>80 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=95 && b>80 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=80
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end          
          when 1
            if b<=100 && b>95 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>75 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=95 && b>75 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=75
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end              
          when 2
            if b<=100 && b>90 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=90 && b>65 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>90 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=90 && b>65 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=65
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end              
          end
          sbet = @previousbet*3
          if (@previousbet - @player2bet + sbet) > @players[1][0]
            @raisevalue = (2*@previousbet)            
          end
          if @raisevalue > lowestchip[0]                                                     
            @raisevalue = (2*@previousbet) 
          end
          ### the last 7 lines are a double check, if npc was gonna bet more then
          ### other plays can call it would default to the min raise which is defined elsewhere
          ### to be a safe thing to do - other players can call without geting negative chips
          ### the final 3 is an extra layer of security vs raising too much
          raise = @raisevalue
          Kernel.pbMessage("#{@players[1][3]} raises #{@raisevalue} chips.")
          @pot += (@previousbet - @player2bet + raise)
          updatepot
          @players[1][0]-= (@previousbet - @player2bet + raise)
          updatechips(1)
          @noraise = @playersup
          @player2bet += (@previousbet - @player2bet + raise)
          @previousbet += raise
          @player2srr += 1
        when 3
          Kernel.pbMessage("#{@players[1][3]} folds.")
          @players[1][1]=0
          @noraise -=1
          @playersup-=1
          updatefold(1)
        end
          @playing=0 if @players[0][1]==1
          @playing=3 if @players[3][1]==1
          @playing=2 if @players[2][1]==1
      when 2 #player3turn
        @decision = npcmove(2)
        case @decision
        when 1
          Kernel.pbMessage("#{@players[2][3]} calls.")
          if @player3bet != @previousbet
            @players[2][0]-= (@previousbet - @player3bet)
            updatechips(2)
            @pot += (@previousbet - @player3bet)
            updatepot
          end
        @noraise -=1
        @player3bet += (@previousbet - @player3bet)
        when 2
          rscore = goodcard(2)
          b = rand(100)+1
          r1 = 0
          r2 = 0
          lowestchip = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
            lowestchip[i] -= (@previousbet - respectivebet)
          end
          lowestchip.sort!
          r1 = 1 if (@previousbet*3) <= lowestchip[0]
          r2 = 1 if (@previousbet*4) <= lowestchip[0]
          case rscore
          when 0
            if b<=100 && b>95 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>80 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=95 && b>80 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=80
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end          
          when 1
            if b<=100 && b>95 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>75 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=95 && b>75 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=75
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end              
          when 2
            if b<=100 && b>90 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=90 && b>65 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>90 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=90 && b>65 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=65
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end              
          end
          sbet = @previousbet*3
          if (@previousbet - @player3bet + sbet) > @players[2][0]
            @raisevalue = (2*@previousbet)            
          end
          if @raisevalue > lowestchip[0]                                                     
            @raisevalue = (2*@previousbet) 
          end          
          raise = @raisevalue
          Kernel.pbMessage("#{@players[2][3]} raises #{@raisevalue} chips.")          
          @pot += (@previousbet - @player3bet + raise)
          updatepot
          @players[2][0]-= (@previousbet - @player3bet + raise)
          updatechips(2)
          @noraise = @playersup
          @player3bet += (@previousbet - @player3bet + raise)
          @previousbet += raise
          @player3srr += 1
        when 3
          Kernel.pbMessage("#{@players[2][3]} folds.")
          @players[2][1]=0
          @noraise -=1
          @playersup-=1
          updatefold(2)
        end
        @playing=1 if @players[1][1]==1
        @playing=0 if @players[0][1]==1
        @playing=3 if @players[3][1]==1        
        
      when 3 #player4turn
        @decision = npcmove(3)
        case @decision
        when 1
          Kernel.pbMessage("#{@players[3][3]} calls.")
          if @player4bet != @previousbet
            @players[3][0]-= (@previousbet - @player4bet)
            updatechips(3)
            @pot += (@previousbet - @player4bet)
            updatepot
          end
        @noraise -=1
        @player4bet += (@previousbet - @player4bet)
        when 2 
          rscore = goodcard(3)
          b = rand(100)+1
          r1 = 0
          r2 = 0
          lowestchip = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
            lowestchip[i] -= (@previousbet - respectivebet)
          end
          lowestchip.sort!
          r1 = 1 if (@previousbet*3) <= lowestchip[0]
          r2 = 1 if (@previousbet*4) <= lowestchip[0]
          case rscore
          when 0
            if b<=100 && b>95 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>80 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=95 && b>80 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=80
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end          
          when 1
            if b<=100 && b>95 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>75 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=95 && b>75 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=75
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end              
          when 2
            if b<=100 && b>90 && r2 == 1
              @raisevalue = (4*@previousbet)
            elsif  b<=90 && b>65 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=100 && b>90 && r2 == 0 && r1 == 1
              @raisevalue = (3*@previousbet)
            elsif b<=90 && b>65 && r1 == 0
              @raisevalue = (2*@previousbet)
            elsif b<=65
              @raisevalue = (2*@previousbet)
            else
              @raisevalue = (2*@previousbet)
            end              
          end
          sbet = @previousbet*3
          if (@previousbet - @player4bet + sbet) > @players[3][0]
            @raisevalue = (2*@previousbet)            
          end
          if @raisevalue > lowestchip[0]                                                     
            @raisevalue = (2*@previousbet) 
          end
          raise = @raisevalue
          Kernel.pbMessage("#{@players[3][3]} raises #{@raisevalue} chips.")                    
          @pot += (@previousbet - @player4bet + raise)
          updatepot
          @players[3][0]-= (@previousbet - @player4bet + raise)
          updatechips(3)
          @noraise = @playersup
          @player4bet += (@previousbet - @player4bet + raise)
          @previousbet += raise                    
          @player4srr += 1
        when 3
          Kernel.pbMessage("#{@players[3][3]} folds.")
          @players[3][1]=0
          @noraise -=1
          @playersup-=1
          updatefold(3)
        end
        @playing=2 if @players[2][1]==1
        @playing=1 if @players[1][1]==1
        @playing=0 if @players[0][1]==1        
      end
  end

  def osubround     ##fsubround -> pre flop / osubround -> others
    while @players[@playing%4][1] == 0
      @playing += 1
    end 
    if @playing >= 4
      @playing -= 4
    end
    case @playing
    when 0
      action = 0
      while action == 0
      if @previousbet == 0 ##turns call into check and raise into bet 
        cmds = [_INTL("Check"),_INTL("Bet"),_INTL("Fold"),_INTL("Quit Game")]
      else
        cmds = [_INTL("Call"),_INTL("Raise"),_INTL("Fold"),_INTL("Quit Game")]
      end
      cmd = Kernel.pbMessage(_INTL("What will you do?"),cmds)
        if cmd == 0
          @previousbet == 0 ? Kernel.pbMessage("#{@players[0][3]} checks.") : Kernel.pbMessage("#{@players[0][3]} calls.")
          if @player1bet != @previousbet
            @players[0][0]-= (@previousbet - @player1bet)
            updatechips(0)
            @pot += (@previousbet - @player1bet)
            updatepot
            @player1bet += (@previousbet - @player1bet)
          end
          @noraise -= 1
          action = 1
        elsif cmd == 1
          pbPlayDecisionSE()
          betscene
          if @raisevalue > 0
            raise = @raisevalue
            @pot += (@previousbet - @player1bet + raise)
            updatepot
            @players[0][0]-= (@previousbet - @player1bet + raise)
            updatechips(0)
            @noraise = @playersup
            @player1bet += (@previousbet - @player1bet + raise)
            @previousbet += raise
            @player1srr += 1            
            action = 1
          end          
        elsif cmd == 2
          Kernel.pbMessage("#{@players[0][3]} folds.")
          @players[0][1]=0
          @noraise -=1
          @playersup-=1
          updatefold(0)
          action = 1
        elsif cmd == 3
          Kernel.pbMessage("Oh, it seems #{@players[0][3]} wishes to quit the game.")
          Kernel.pbMessage("You may leave the table after this round, come back anytime.")          
          @gameover = 1
          @players[0][1] = 0
          @noraise -=1
          @playersup -=1
          $game_variables[@chipsvariable] = @players[0][0]    ##reward
          action = 1
        end
          @playing=3 if @players[3][1]==1
          @playing=2 if @players[2][1]==1
          @playing=1 if @players[1][1]==1      
      end
    when 1
      @decision = npcmove(1)
      case @decision
      when 1
        @previousbet == 0 ? Kernel.pbMessage("#{@players[1][3]} checks.") : Kernel.pbMessage("#{@players[1][3]} calls.")
        if @player2bet != @previousbet
          @players[1][0]-= (@previousbet - @player2bet)
          updatechips(1)
          @pot += (@previousbet - @player2bet)
          updatepot
          @player2bet += (@previousbet - @player2bet)
        end
        @noraise -=1
      when 2
          rscore = goodcard(1)
          b = rand(100)+1
          r1 = 0
          r2 = 0
          lowestchip = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
            lowestchip[i] -= (@previousbet - respectivebet)
          end
          lowestchip.sort!
          if @previousbet == 0
            r1 = 1 if (@blindvalue*3) <= lowestchip[0]
            r2 = 1 if (@blindvalue*5) <= lowestchip[0]
          else
            r1 = 1 if (@previousbet*3) <= lowestchip[0]
            r2 = 1 if (@previousbet*4) <= lowestchip[0]
          end
          case rscore
          when 0
            if b<=100 && b>95 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>80 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=95 && b>80 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=80
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end          
          when 1
            if b<=100 && b>95 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>75 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=95 && b>75 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=75
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end              
          when 2
            if b<=100 && b>90 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=90 && b>65 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>90 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=90 && b>65 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=65
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end
          end
          @previousbet == 0 ? sbet = @blindvalue*2 : sbet = @previousbet*3
          if (@previousbet - @player2bet + sbet) > @players[1][0]
            @previousbet == 0 ? @raisevalue = (@blindvalue) : @raisevalue = (2*@previousbet)            
          end
          if @raisevalue > lowestchip[0]                                                     
            @previousbet == 0 ? @raisevalue = (@blindvalue) : @raisevalue = (2*@previousbet) 
          end
          raise = @raisevalue
          if @previousbet == 0
            Kernel.pbMessage("#{@players[1][3]} bets #{@raisevalue} chips.")
          else
            Kernel.pbMessage("#{@players[1][3]} raises #{@raisevalue} chips.")
          end
          @pot += (@previousbet - @player2bet + raise)
          updatepot
          @players[1][0]-= (@previousbet - @player2bet + raise)
          updatechips(1)
          @noraise = @playersup
          @player2bet += (@previousbet - @player2bet + raise)
          @previousbet += raise
          @player2srr += 1
      when 3
        Kernel.pbMessage("#{@players[1][3]} folds.")
        @players[1][1]=0
        @noraise -=1
        @playersup-=1 
        updatefold(1)
      end
        @playing=0 if @players[0][1]==1
        @playing=3 if @players[3][1]==1
        @playing=2 if @players[2][1]==1
    when 2
      @decision = npcmove(2)
      case @decision
      when 1
        @previousbet == 0 ? Kernel.pbMessage("#{@players[2][3]} checks.") : Kernel.pbMessage("#{@players[2][3]} calls.")
        if @player3bet != @previousbet
          @players[2][0]-= (@previousbet - @player3bet)
          updatechips(2)
          @pot += (@previousbet - @player3bet)
          updatepot
          @player3bet += (@previousbet - @player3bet)
        end
        @noraise -=1 
      when 2
          rscore = goodcard(2)
          b = rand(100)+1
          r1 = 0
          r2 = 0
          lowestchip = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
            lowestchip[i] -= (@previousbet - respectivebet)
          end
          lowestchip.sort!
          if @previousbet == 0
            r1 = 1 if (@blindvalue*3) <= lowestchip[0]
            r2 = 1 if (@blindvalue*5) <= lowestchip[0]
          else
            r1 = 1 if (@previousbet*3) <= lowestchip[0]
            r2 = 1 if (@previousbet*4) <= lowestchip[0]
          end
          case rscore
          when 0
            if b<=100 && b>95 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>80 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=95 && b>80 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=80
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end          
          when 1
            if b<=100 && b>95 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>75 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=95 && b>75 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=75
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end              
          when 2
            if b<=100 && b>90 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=90 && b>65 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>90 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=90 && b>65 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=65
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end              
          end
          @previousbet == 0 ? sbet = @blindvalue*2 : sbet = @previousbet*3
          if (@previousbet - @player3bet + sbet) > @players[2][0]
            @previousbet == 0 ? @raisevalue = (@blindvalue) : @raisevalue = (2*@previousbet)            
          end
          if @raisevalue > lowestchip[0]                                                     
            @previousbet == 0 ? @raisevalue = (@blindvalue) : @raisevalue = (2*@previousbet) 
          end          
          raise = @raisevalue
          if @previousbet == 0
            Kernel.pbMessage("#{@players[2][3]} bets #{@raisevalue} chips.")
          else
            Kernel.pbMessage("#{@players[2][3]} raises #{@raisevalue} chips.")
          end
          @pot += (@previousbet - @player3bet + raise)
          updatepot
          @players[2][0]-= (@previousbet - @player3bet + raise)
          updatechips(2)
          @noraise = @playersup
          @player3bet += (@previousbet - @player3bet + raise)
          @previousbet += raise
          @player3srr += 1          
      when 3
        Kernel.pbMessage("#{@players[2][3]} folds.")
        @players[2][1] = 0
        @noraise -=1
        @playersup-=1
        updatefold(2)
      end
        @playing=1 if @players[1][1]==1
        @playing=0 if @players[0][1]==1
        @playing=3 if @players[3][1]==1   
    when 3
      @decision = npcmove(3)
      case @decision
      when 1
        @previousbet == 0 ? Kernel.pbMessage("#{@players[3][3]} checks.") : Kernel.pbMessage("#{@players[3][3]} calls.")
        if @player4bet != @previousbet
          @players[3][0]-= (@previousbet - @player4bet)
          updatechips(3)
          @pot += (@previousbet - @player4bet)
          updatepot
          @player4bet += (@previousbet - @player4bet)
        end
        @noraise -=1        
      when 2
          rscore = goodcard(3)
          b = rand(100)+1
          r1 = 0
          r2 = 0
          lowestchip = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
            lowestchip[i] -= (@previousbet - respectivebet)
          end
          lowestchip.sort!
          if @previousbet == 0
            r1 = 1 if (@blindvalue*3) <= lowestchip[0]
            r2 = 1 if (@blindvalue*5) <= lowestchip[0]
          else
            r1 = 1 if (@previousbet*3) <= lowestchip[0]
            r2 = 1 if (@previousbet*4) <= lowestchip[0]
          end
          case rscore
          when 0
            if b<=100 && b>95 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>80 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=95 && b>80 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=80
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end          
          when 1
            if b<=100 && b>95 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=95 && b>75 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>95 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=95 && b>75 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=75
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end              
          when 2
            if b<=100 && b>90 && r2 == 1
              @previousbet == 0 ? @raisevalue = (5*@blindvalue) : @raisevalue = (4*@previousbet)
            elsif  b<=90 && b>65 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=100 && b>90 && r2 == 0 && r1 == 1
              @previousbet == 0 ? @raisevalue = (3*@blindvalue) : @raisevalue = (3*@previousbet)
            elsif b<=90 && b>65 && r1 == 0
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            elsif b<=65
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            else
              @previousbet == 0 ? @raisevalue = (2*@blindvalue) : @raisevalue = (2*@previousbet)
            end              
          end
          @previousbet == 0 ? sbet = @blindvalue*2 : sbet = @previousbet*3
          if (@previousbet - @player4bet + sbet) > @players[3][0]
            @previousbet == 0 ? @raisevalue = (@blindvalue) : @raisevalue = (2*@previousbet)            
          end          
          if @raisevalue > lowestchip[0]                                                     
            @previousbet == 0 ? @raisevalue = (@blindvalue) : @raisevalue = (2*@previousbet) 
          end          
          raise = @raisevalue
          if @previousbet == 0
            Kernel.pbMessage("#{@players[3][3]} bets #{@raisevalue} chips.")
          else
            Kernel.pbMessage("#{@players[3][3]} raises #{@raisevalue} chips.")
          end
          @pot += (@previousbet - @player4bet + raise)
          updatepot
          @players[3][0]-= (@previousbet - @player4bet + raise)
          updatechips(3)
          @noraise = @playersup
          @player4bet += (@previousbet - @player4bet + raise)
          @previousbet += raise        
          @player4srr += 1          
      when 3
        Kernel.pbMessage("#{@players[3][3]} folds.")
        @players[3][1] = 0
        @noraise -= 1
        @playersup -= 1
        updatefold(3)
      end
        @playing=2 if @players[2][1]==1
        @playing=1 if @players[1][1]==1
        @playing=0 if @players[0][1]==1        
    end
        
  end
  
  
 ## small blind players starts by posting it and increases blind so next player 
 ## posts it in the next round
 ## noraise is defined in subround auxiliary function, when there'sX (players up)
 ## calls or folds in a row it will break the loop and show the 1st 3 community cards
 ## then it will go in the subround and show the 4th comunity card once its over, then
 ## the last community card, after that @roundover == 1 and breaks the loop
 ## then roundwinner function is called in the main function and player hands are rated
 
  def playround
    @totalraises = 0          ##used for npc AI
    @player1bet = 0
    @player2bet = 0
    @player3bet = 0
    @player4bet = 0
    @comcards = 0
    @playersup = 0
    @playersup += 1 if @players[0][0]>0
    @playersup += 1 if @players[1][0]>0
    @playersup += 1 if @players[2][0]>0
    @playersup += 1 if @players[3][0]>0

    while @players[@blind%4][1] == 0   ##selects next player to post the blind, must be in game [i][1] == 1
      @blind += 1
    end
    
    case @blind%4
     when 0
      Kernel.pbMessage("#{@players[0][3]} posts the blind.")
      @players[0][0] -= @blindvalue        ##deducts blind value from players chips
      updatechips(0)
      @pot += @blindvalue
      updatepot
      @skips = 1                           ##fossil variable no longer used, remove it all one of these days
      @call = @blindvalue                  ## ^  
      @player1bet = @blindvalue
     when 1
      Kernel.pbMessage("#{@players[1][3]} posts the blind.")
      @players[1][0] -= @blindvalue
      updatechips(1)
      @pot += @blindvalue
      updatepot
      @skips = 1
      @call = @blindvalue
      @player2bet = @blindvalue
     when 2
      Kernel.pbMessage("#{@players[2][3]} posts the blind.")
      @players[2][0] -= @blindvalue
      updatechips(2)
      @pot += @blindvalue
      updatepot      
      @skips = 1
      @call = @blindvalue
      @player3bet = @blindvalue
     when 3
      Kernel.pbMessage("#{@players[3][3]} posts the blind.")
      @players[3][0] -= @blindvalue
      updatechips(3)
      @pot += @blindvalue
      updatepot      
      @skips = 1
      @call = @blindvalue     
      @player4bet = @blindvalue
    end  ##case   
    @blind +=1            ##control who pays next blind
    @playing = @blind%4   ##controls who plays exactly next
    @noraise = @playersup+1
    while @roundover != 1    ##round loop  - breaks when 4th subround is over
      while @noraise != 1    ##subround loop - breaks when there's #playersup calls in a row
        @comcards == 0 ? fsubround : osubround  ##comcards=0 is the pre flop
      end
      ### resets subround stuff, calculates totalraises before reseting them for npc AI use
      @previousbet = 0
      @totalraises += (@player1srr + @player2srr + @player3srr + @player4srr)
      @player1bet = 0
      @player2bet = 0
      @player3bet = 0
      @player4bet = 0
      @player1srr = 0
      @player2srr = 0
      @player3srr = 0
      @player4srr = 0  

      if @comcards == 3   ##breaks the round loop, round is over
        @roundover == 1             
        break
      end
  
      
      if @comcards == 2  ##shows last card
        
        @sprites["c5"].bitmap.clear
        @sprites["c5"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@comcard5[0]))
        @sprites["c5"].opacity = 255
        pbWait(16)
        @sprites["sq4"].bitmap.clear
        @sprites["sq4"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/greensq")
        
        @comcards += 1
        @noraise = @playersup+1        
      end
      

      if @comcards == 1   ##shows 4th card
        
        @sprites["c4"].bitmap.clear
        @sprites["c4"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@comcard4[0]))
        @sprites["c4"].opacity = 255
        pbWait(16)
        @sprites["sq3"].bitmap.clear
        @sprites["sq3"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/greensq")
        
        @comcards += 1
        @noraise = @playersup+1
      end
      
      
      if @comcards == 0  ##shows 3 1st cards

        
        @sprites["c1"].bitmap.clear
        @sprites["c1"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@comcard1[0]))
        @sprites["c1"].opacity = 255
        pbWait(16)
        @sprites["c2"].bitmap.clear
        @sprites["c2"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@comcard2[0]))
        @sprites["c2"].opacity = 255
        pbWait(16)
        @sprites["c3"].bitmap.clear
        @sprites["c3"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@comcard3[0]))
        @sprites["c3"].opacity = 255
        pbWait(16)
        @sprites["sq2"].bitmap.clear
        @sprites["sq2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/greensq")
        
        @comcards += 1
        @noraise = @playersup+1
      end #comcards == 0
      end #2nd while
    end ###playround
    
  def roundwinner
    @p1score = 0
    @p2score = 0
    @p3score = 0
    @p4score = 0
    #### reveals the cards of every player who's still in round @players[i][1]==1
    if @players[1][1]==1 ##p2 still in round
      @sprites["p2_1"].opacity = 0
      @sprites["p2_1"].bitmap.clear
      @sprites["p2_1"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player2card1[0]))
      pbWait(8)
      @sprites["p2_1"].opacity = 255
      pbWait(8)
      @sprites["p2_2"].opacity = 0
      @sprites["p2_2"].bitmap.clear
      @sprites["p2_2"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player2card2[0]))
      pbWait(8)
      @sprites["p2_2"].opacity = 255
      pbWait(8)
    end
    if @players[2][1]==1 ##p3 still in round
      @sprites["p3_1"].opacity = 0
      @sprites["p3_1"].bitmap.clear
      @sprites["p3_1"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player3card1[0]))
      pbWait(8)
      @sprites["p3_1"].opacity = 255
      pbWait(8)
      @sprites["p3_2"].opacity = 0
      @sprites["p3_2"].bitmap.clear
      @sprites["p3_2"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player3card2[0]))
      pbWait(8)
      @sprites["p3_2"].opacity = 255      
    end
    if @players[3][1]==1 ##p4 still in round
      @sprites["p4_1"].opacity = 0
      @sprites["p4_1"].bitmap.clear
      @sprites["p4_1"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player4card1[0]))
      pbWait(8)
      @sprites["p4_1"].opacity = 255
      pbWait(8)
      @sprites["p4_2"].opacity = 0
      @sprites["p4_2"].bitmap.clear
      @sprites["p4_2"].bitmap = Bitmap.new(sprintf("Graphics/Pictures/Pokepoker/card%d",@player4card2[0]))
      pbWait(8)
      @sprites["p4_2"].opacity = 255    
    end
    
    ### this next chunks runs the handrate function for all players who didnt fold this round, 
    ### then stores in playerscores array the playernumber and its respective score and sorts
    ### the array from the highest score to the lowest
    
    
      @playerscores = [
      [0,0],
      [0,0],
      [0,0],
      [0,0]
      ]
    
      if @players[0][1] == 1
        @p1score = handrate(@player1card1,@player1card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
        @playerscores[0][0] = 1
        @playerscores[0][1] = @p1score
      end
      if @players[1][1] == 1
        @p2score = handrate(@player2card1,@player2card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
        @playerscores[1][0] = 2
        @playerscores[1][1] = @p2score
      end
      if @players[2][1] == 1
        @p3score = handrate(@player3card1,@player3card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
        @playerscores[2][0] = 3
        @playerscores[2][1] = @p3score
      end
      if @players[3][1] == 1
        @p4score = handrate(@player4card1,@player4card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
        @playerscores[3][0] = 4
        @playerscores[3][1] = @p4score
      end
      
      @playerscores.sort! {|a,b| b[1] <=> a[1]}   ##sorts the array by score, 1st one won, if 1st=2nd then both won, etc
      
      wsequence = sequenceannounce(@playerscores[0][1])

      ### the very very unlikely case all 4 scores are equal - 4 players tied
      if (@playerscores[0][1] == @playerscores[1][1]) && (@playerscores[0][1] == @playerscores[2][1]) && (@playerscores[0][1] == @playerscores[3][1])
        Kernel.pbMessage("Did this just happen?")
        Kernel.pbMessage("Every player tied with #{wsequence}!")
        Kernel.pbMessage("The pot is split by everyone.")
        @players[0][0] += (@pot/4)
        @players[1][0] += (@pot/4)
        @players[2][0] += (@pot/4)
        @players[3][0] += (@pot/4)
        updatechips(@playerscores[0][0]-1)
        updatechips(@playerscores[1][0]-1)
        updatechips(@playerscores[2][0]-1)
        updatechips(@playerscores[3][0]-1)
      ### the very unlikely case 3 players tie
      elsif (@playerscores[0][1] == @playerscores[1][1]) && (@playerscores[0][1] == @playerscores[2][1])
        Kernel.pbMessage("Now that's something you don't see every day, a three-way tie!")
        Kernel.pbMessage("They all got #{wsequence}!")
        Kernel.pbMessage("#{@players[(@playerscores[0][0])-1][3]}, #{@players[(@playerscores[1][0])-1][3]} and #{@players[(@playerscores[2][0])-1][3]} split the pot.")
        @players[(@playerscores[0][0])-1][0] += (@pot/3)
        @players[(@playerscores[1][0])-1][0] += (@pot/3)
        @players[(@playerscores[2][0])-1][0] += (@pot/3)
        updatechips(@playerscores[0][0]-1)
        updatechips(@playerscores[1][0]-1)
        updatechips(@playerscores[2][0]-1)
      ### the unlikely case 2 players tie
      elsif (@playerscores[0][1] == @playerscores[1][1])
        Kernel.pbMessage("What a surprise, we have a tie between #{@players[(@playerscores[0][0])-1][3]} and #{@players[(@playerscores[1][0])-1][3]}!")
        Kernel.pbMessage("Both of them got #{wsequence}!")
        Kernel.pbMessage("Each player gets half of the pot.")
        @players[(@playerscores[0][0])-1][0] += (@pot/2)
        @players[(@playerscores[1][0])-1][0] += (@pot/2)
        updatechips(@playerscores[0][0]-1)
        updatechips(@playerscores[1][0]-1)        
      else ### pot goes to the winner
        Kernel.pbMessage("#{@players[(@playerscores[0][0])-1][3]} wins the pot with #{wsequence}!")
        @players[(@playerscores[0][0])-1][0] += @pot
        updatechips(@playerscores[0][0]-1)
      end

      @round +=1          ##increases round, resets deck and round related stuff, updates pot
      @deckp = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,
      27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52]      
      @roundover = 0
      @pot = 0
      updatepot

      @players[0][2] = 0 if @players[0][0] < @blindvalue   ##any player who can't pay the bind is removed from game [i][2]=0
      @players[1][2] = 0 if @players[1][0] < @blindvalue
      @players[2][2] = 0 if @players[2][0] < @blindvalue
      @players[3][2] = 0 if @players[3][0] < @blindvalue
      
      @players[0][2] == 0 ? @players[0][1] = 0 : @players[0][1] = 1    ##if [i][2] == 0 then [i][1] == 0 too just in case of bugs, else (case of fold)
      @players[1][2] == 0 ? @players[1][1] = 0 : @players[1][1] = 1    ## but still ingame, it resets teh [i][1] to 1 so the player can play next round
      @players[2][2] == 0 ? @players[2][1] = 0 : @players[2][1] = 1
      @players[3][2] == 0 ? @players[3][1] = 0 : @players[3][1] = 1
      
      @sprites["p1_1"].opacity = 0
      @sprites["p1_1"].bitmap.clear
      @sprites["p1_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")
      @sprites["p1_2"].opacity = 0
      @sprites["p1_2"].bitmap.clear
      @sprites["p1_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")      
      @sprites["p2_1"].opacity = 0
      @sprites["p2_1"].bitmap.clear
      @sprites["p2_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")      
      @sprites["p2_2"].opacity = 0
      @sprites["p2_2"].bitmap.clear
      @sprites["p2_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")      
      @sprites["p3_1"].opacity = 0
      @sprites["p3_1"].bitmap.clear
      @sprites["p3_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard") 
      @sprites["p3_2"].opacity = 0
      @sprites["p3_2"].bitmap.clear
      @sprites["p3_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")      
      @sprites["p4_1"].opacity = 0
      @sprites["p4_1"].bitmap.clear
      @sprites["p4_1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")            
      @sprites["p4_2"].opacity = 0
      @sprites["p4_2"].bitmap.clear
      @sprites["p4_2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")            
      @sprites["c1"].opacity = 0
      @sprites["c1"].bitmap.clear
      @sprites["c1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")            
      @sprites["c2"].opacity = 0
      @sprites["c2"].bitmap.clear
      @sprites["c2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")                  
      @sprites["c3"].opacity = 0
      @sprites["c3"].bitmap.clear
      @sprites["c3"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")                  
      @sprites["c4"].opacity = 0
      @sprites["c4"].bitmap.clear
      @sprites["c4"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")                  
      @sprites["c5"].opacity = 0
      @sprites["c5"].bitmap.clear
      @sprites["c5"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/backcard")                  
      
      if @players[0][2] == 0   ##player can't pay the blind, is out of the game - game over
        Kernel.pbMessage("You're out of chips, better luck next time.")
        @gameover = 1
      end
      
      updatequitters if @players[0][2] == 1   
      
      if (@players[1][2] == 0) && (@players[2][2] == 0) && (@players[3][2] == 0) ##only player is remaining - victory
        Kernel.pbMessage("You are the only player remaining, congratulations on your victory!")
        @gameover = 1
        $game_variables[@chipsvariable] = @players[0][0]  ##reward
        ### add the playercoins to a game variable to add the coins after game in the event
      end
        @sprites["sq1"].bitmap.clear
        @sprites["sq1"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
        @sprites["sq2"].bitmap.clear
        @sprites["sq2"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
        @sprites["sq3"].bitmap.clear
        @sprites["sq3"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")
        @sprites["sq4"].bitmap.clear
        @sprites["sq4"].bitmap = Bitmap.new("Graphics/Pictures/Pokepoker/redsq")   
  end
  
  def handrate(hand1,hand2,hand3,hand4,hand5,hand6,hand7)
    ##################################
    ## check for royal straight flush
    ##################################    
    
    ### these var will store the amount of elements needed for a royal straight flush
    ### if they reach 5 means the 5 cards required are present
    hroyalf = 0
    droyalf = 0
    sroyalf = 0
    croyalf = 0
    @hand = [
    hand1,
    hand2,
    hand3,
    hand4,
    hand5,
    hand6,
    hand7
    ]    
#    @hand = [
#    [45,"Seven of Hearts",4,"Spades"],
#    [5,"Six of Spades",10,"Clubs"],
#    [47,"Nine of Hearts",10,"Diamonds"],
#    [49,"Jack of Hearts",8,"Hearts"],
#    [41,"Three of Hearts",9,"Hearts"],
#    [6,"Seven of Spades",3,"Spades"],
#    [44,"Six of Hearts",14,"Hearts"]
#    ]
    @tiebreakerhand = []
    for i in 0...7
      @tiebreakerhand.push(@hand[i][2])
    end
    @tiebreakerhand.sort! { |a, b| b <=> a }

    ####### checks every card in @hand, adds +1 to the roayl flush counters - hroalf, droyalf  
    for i in 0...7
      hroyalf += 1 if @hand[i][2] == 10  && @hand[i][3] == "Hearts"
      hroyalf += 1 if @hand[i][2] == 11  && @hand[i][3] == "Hearts"
      hroyalf += 1 if @hand[i][2] == 12  && @hand[i][3] == "Hearts"
      hroyalf += 1 if @hand[i][2] == 13  && @hand[i][3] == "Hearts"
      hroyalf += 1 if @hand[i][2] == 14  && @hand[i][3] == "Hearts"
      droyalf += 1 if @hand[i][2] == 10  && @hand[i][3] == "Diamonds"
      droyalf += 1 if @hand[i][2] == 11  && @hand[i][3] == "Diamonds"
      droyalf += 1 if @hand[i][2] == 12  && @hand[i][3] == "Diamonds"
      droyalf += 1 if @hand[i][2] == 13  && @hand[i][3] == "Diamonds"
      droyalf += 1 if @hand[i][2] == 14  && @hand[i][3] == "Diamonds"
      sroyalf += 1 if @hand[i][2] == 10  && @hand[i][3] == "Spades"
      sroyalf += 1 if @hand[i][2] == 11  && @hand[i][3] == "Spades"
      sroyalf += 1 if @hand[i][2] == 12  && @hand[i][3] == "Spades"
      sroyalf += 1 if @hand[i][2] == 13  && @hand[i][3] == "Spades"
      sroyalf += 1 if @hand[i][2] == 14  && @hand[i][3] == "Spades"
      croyalf += 1 if @hand[i][2] == 10  && @hand[i][3] == "Clubs"
      croyalf += 1 if @hand[i][2] == 11  && @hand[i][3] == "Clubs"
      croyalf += 1 if @hand[i][2] == 12  && @hand[i][3] == "Clubs"
      croyalf += 1 if @hand[i][2] == 13  && @hand[i][3] == "Clubs"
      croyalf += 1 if @hand[i][2] == 14  && @hand[i][3] == "Clubs"
    end
    
    ####### if any of the counters reaches 5 it will return 1000 - the highest 
    ####### value possible
    
    if hroyalf == 5 || droyalf == 5 || sroyalf == 5 || croyalf == 5
      return 40000
    end
    ###########################
    ## check for straight flush
    ###########################
    
    #### each array represents a suit
    
    @hstflush = []
    @dstflush = []
    @sstflush = []
    @cstflush = []
    
    ### this will sort the hand and fill each array suit with the cards values
    
    for i in 0...7
      @hstflush.push(@hand[i][2]) if @hand[i][3] == "Hearts"
      @dstflush.push(@hand[i][2]) if @hand[i][3] == "Diamonds"
      @sstflush.push(@hand[i][2]) if @hand[i][3] == "Spades"
      @cstflush.push(@hand[i][2]) if @hand[i][3] == "Clubs"
    end
    
    ### if the suit array is 5 or bigger then there's 5 cards of the same suit
    ### it will then sort the array from highest to lowest and check for each value
    ### if the value -1, -2, -3 and -4 is present, it will return 2400 + array[i] which is
    ### the highest value of the sequence for tie breaker purposes
    ### the 1st if checks for ace through 5 straight flush, if an ace (14) is present
    ### will check for presence of the values 2 3 4 and 5
    
    if @hstflush.length >= 5
      @hstflush.sort! { |a, b| b <=> a }
      for i in 0...@hstflush.length
        if @hstflush[i]== 14
          if @hstflush.include?(2) &&  @hstflush.include?(3) &&  @hstflush.include?(4) &&  @hstflush.include?(5)
            return 39000 + 5
          end
        end
        if @hstflush.include?((@hstflush[i])-1) && @hstflush.include?((@hstflush[i])-2) && @hstflush.include?((@hstflush[i])-3) && @hstflush.include?((@hstflush[i])-4)
          return 39000 + @hstflush[i]
        end
      end
    end
    if @dstflush.length >= 5
      @dstflush.sort! { |a, b| b <=> a }
      for i in 0...@dstflush.length
        if @dstflush[i]== 14
          if @dstflush.include?(2) &&  @dstflush.include?(3) &&  @dstflush.include?(4) &&  @dstflush.include?(5)
            return 39000 + 5
          end
        end
        if @dstflush.include?((@dstflush[i])-1) && @dstflush.include?((@dstflush[i])-2) && @dstflush.include?((@dstflush[i])-3) && @dstflush.include?((@dstflush[i])-4)
          return 39000 + @dstflush[i]
        end
      end
    end    
    if @sstflush.length >= 5
      @sstflush.sort! { |a, b| b <=> a }
      for i in 0...@sstflush.length
        if @sstflush[i]== 14
          if @sstflush.include?(2) &&  @sstflush.include?(3) &&  @sstflush.include?(4) &&  @sstflush.include?(5)
            return 39000 + 5
          end
        end
        if @sstflush.include?((@sstflush[i])-1) && @sstflush.include?((@sstflush[i])-2) && @sstflush.include?((@sstflush[i])-3) && @sstflush.include?((@sstflush[i])-4)
          return 39000 + @sstflush[i]
        end
      end
    end    
    if @cstflush.length >= 5
      @cstflush.sort! { |a, b| b <=> a }
      for i in 0...@cstflush.length
        if @cstflush[i]== 14
          if @cstflush.include?(2) &&  @cstflush.include?(3) &&  @cstflush.include?(4) &&  @cstflush.include?(5)
            return 39000 + 5
          end
        end
        if @cstflush.include?((@cstflush[i])-1) && @cstflush.include?((@cstflush[i])-2) && @cstflush.include?((@cstflush[i])-3) && @cstflush.include?((@cstflush[i])-4)
          return 39000 + @cstflush[i]
        end
      end
    end  

    ###########################
    ## check for 4 of a kind
    ###########################    
    ### stores the value of every card in the four of a kind array
    ### then sorts the array by descending value
    ### if there's 4 equal cards then they will be adjacent so it checks
    ### i+1 i+2 and i+3, if all they're all of equal 
    ### value returns 2100 (4 of a kind value) + array[i] (the card value)
    @fourofakind = []
    for i in 0...7
      @fourofakind.push(@hand[i][2])
    end
    
    @fourofakind.sort! { |a, b| b <=> a }
    
    for i in 0...@fourofakind.length
      if (@fourofakind[i] == @fourofakind[i+1]) && (@fourofakind[i] == @fourofakind[i+2]) && (@fourofakind[i] == @fourofakind[i+3])
        @tiebreakerhand.delete(@fourofakind[i])
        return 38000 + (@fourofakind[i]*14) + @tiebreakerhand[0]
      end
    end
    
    ###########################
    ## check for full house
    ###########################  
    #### stores hands values by descending order in fullhouse array
    #### if theres 3 values in a row (at this point it already checked for 4 of a kind)
    #### returns the highest trio, it then checks for the highest pair
    #### it returns 1800 + 14x trio value + pair, it could go up to a max of 210
    #### so the value of four a kind is 2100 and this one's base is 1800 to make up for that
    @fullhouse = []
    trio = 0
    pair = 0
    for i in 0...7
      @fullhouse.push(@hand[i][2])
    end
    @fullhouse.sort! { |a, b| b <=> a }
    for i in 0...@fullhouse.length
      if (@fullhouse[i] == @fullhouse[i+1]) && (@fullhouse[i] == @fullhouse[i+2]) && trio == 0
        trio = @fullhouse[i]
      end
      if (@fullhouse[i] == @fullhouse[i+1]) && pair == 0 && (@fullhouse[i] != trio)
        pair = @fullhouse[i]
      end
    end    
    if pair > 0 && trio > 0
      return 37000+(14*trio)+pair
    end
    
    
    ###########################
    ## check for flush
    ###########################  
    ### distributes hand cards to its respective suit array and sorts descending
    ### if any suit array length is 5 or greater returns the 5 highest cards
    
    @hflush = []
    @dflush = []
    @sflush = []
    @cflush = []
    
    for i in 0...7
      @hflush.push(@hand[i][2]) if @hand[i][3] == "Hearts"
      @dflush.push(@hand[i][2]) if @hand[i][3] == "Diamonds"
      @sflush.push(@hand[i][2]) if @hand[i][3] == "Spades"
      @cflush.push(@hand[i][2]) if @hand[i][3] == "Clubs"
    end
    
    if @hflush.length >= 5
      @hflush.sort! { |a, b| b <=> a }
      return 36000 + @hflush[0] + @hflush[1] + @hflush[2] + @hflush[3] + @hflush[4]
    end
    if @dflush.length >= 5
      @dflush.sort! { |a, b| b <=> a }
      return 36000 + @dflush[0] + @dflush[1] + @dflush[2] + @dflush[3] + @dflush[4]
    end
    if @sflush.length >= 5
      @sflush.sort! { |a, b| b <=> a }
      return 36000 + @sflush[0] + @sflush[1] + @sflush[2] + @sflush[3] + @sflush[4]
    end
    if @cflush.length >= 5
      @cflush.sort! { |a, b| b <=> a }
      return 36000 + @cflush[0] + @cflush[1] + @cflush[2] + @cflush[3] + @cflush[4]
    end    
  
  
    ###########################
    ## check for straight
    ###########################  
    ### stores value of cards in straight array, sorts descending
    ### for each value, checks if @straight includes i+1,..i+4 
    @straight = []
    
    for i in 0...7
      @straight.push(@hand[i][2])
    end
    @straight.sort! { |a, b| b <=> a }
    for i in 0...@straight.length
      if @straight[i] == 14
        if @straight.include?(2) && @straight.include?(3) && @straight.include?(4) && @straight.include?(5)
          return 35000 + 1
        end
      end
      if @straight.include?(@straight[i]+1) && @straight.include?(@straight[i]+2) && @straight.include?(@straight[i]+3) && @straight.include?(@straight[i]+4)
        return 35000 + @straight[i]
      end
    end
    
    ###########################
    ## check for 3 of a kind
    ###########################  
    ### stores value of cards in threekind array and sorts descending
    ### for each value, checks if the 2 next values are equal to it
    ### note that by the time this chunk is run if there was a 4 of a kind /
    ### fullhouse, etc it will have already returned so this part only needs 
    ### to check presence of a trio
    
    @threekind = []
    
    for i in 0...7
      @threekind.push(@hand[i][2])
    end
    
    @threekind.sort! { |a, b| b <=> a }
    
    for i in 0...@threekind.length
      if (@threekind[i] == @threekind[i+1]) && (@threekind[i] == @threekind[i+2])
        @tiebreakerhand.delete(@threekind[i])
        return 30000 + (@threekind[i]*140) + (14*@tiebreakerhand[0]) + @tiebreakerhand[1]
      end
    end
   
    
    ###########################
    ## check for 2 pairs
    ###########################  
    ### stores value of cards in doublepair array and sorts descending
    ### for each value, checks if the next values is equal to it
    ### it will store the first pair in pair1 and the second pair in pair2
    ### when paircount == 2 it will stop looking for pairs
    ### returns 600 + 14x 1st pair value + 2nd pair for tiebreaker purposes
    ### range for double pairs in score is 600 - 810
    ### if paircount == 1 it will return 300 + pair1 
    ### if paircount == 0 then it means the player got no "special hand"
    ### and it will return the highest card
    
    pair1 = 0
    pair2 = 0
    paircount = 0
    @doublepair = []
    
    for i in 0...7
      @doublepair.push(@hand[i][2])
    end

    @doublepair.sort! { |a, b| b <=> a }
    
    for i in 0...@doublepair.length
      if (@doublepair[i] == @doublepair[i+1]) && paircount <2
        if pair1 == 0
          pair1 = @doublepair[i]
          paircount += 1
        end
        if pair2 == 0 && (@doublepair[i] != pair1)
          pair2 = @doublepair[i]
          paircount += 1
        end
      end
    end
    if paircount == 2
      @tiebreakerhand.delete(pair1)
      @tiebreakerhand.delete(pair2)
      return 25000 + (140*pair1) + (14*pair2) + @tiebreakerhand[0]
    end
    
    if paircount == 1
      @tiebreakerhand.delete(pair1)
      return 300 + (pair1*1400) + (@tiebreakerhand[0]*140) + (@tiebreakerhand[1]*14) + @tiebreakerhand[2]
    end
    
    if paircount == 0
      if (@hand[0][2]) > (@hand[1][2])
        return 14*@hand[0][2] + @hand[1][2]
      else
        return 14*@hand[1][2] + @hand[0][2]
      end
    end
        
  end #function

  def updatepot
    10.times do
      @sprites["potvalue"].opacity -= 25.5
      pbWait(1)
    end
    pbWait(8)
    @sprites["potvalue"].bitmap.clear
    textarray = [[@pot.to_s,26,0,2,Color.new(255,255,255),Color.new(248,240,160),false]]
    pbDrawTextPositions(@sprites["potvalue"].bitmap,textarray)
    10.times do
      @sprites["potvalue"].opacity += 25.5
      pbWait(1)
    end
  end
  
  def updatechips(player)
    case player
    when 0
      #update p1
      10.times do
        @sprites["p1chips"].opacity -= 25.5
        pbWait(1)
      end
      pbWait(8)
      @sprites["p1chips"].bitmap.clear
      textarray = [[@players[0][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,240),false]]
      pbDrawTextPositions(@sprites["p1chips"].bitmap,textarray)
      10.times do
        @sprites["p1chips"].opacity += 25.5
        pbWait(1)
      end
    when 1
      #update p2
      10.times do
        @sprites["p2chips"].opacity -= 25.5
        pbWait(1)
      end
      pbWait(8)
      @sprites["p2chips"].bitmap.clear
      textarray = [[@players[1][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,240),false]]
      pbDrawTextPositions(@sprites["p2chips"].bitmap,textarray)
      10.times do
        @sprites["p2chips"].opacity += 25.5
        pbWait(1)
      end
    when 2
      #update p3
      10.times do
        @sprites["p3chips"].opacity -= 25.5
        pbWait(1)
      end
      pbWait(8)
      @sprites["p3chips"].bitmap.clear
      textarray = [[@players[2][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,240),false]]
      pbDrawTextPositions(@sprites["p3chips"].bitmap,textarray)
      10.times do
        @sprites["p3chips"].opacity += 25.5
        pbWait(1)
      end
    when 3
      #update p4
      10.times do
        @sprites["p4chips"].opacity -= 25.5
        pbWait(1)
      end
      pbWait(8)
      @sprites["p4chips"].bitmap.clear
      textarray = [[@players[3][0].to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,240),false]]
      pbDrawTextPositions(@sprites["p4chips"].bitmap,textarray)
      10.times do
        @sprites["p4chips"].opacity += 25.5
        pbWait(1)
      end      
    end
  end
  
  def npcmove(npc)
    lowestchip = []
    for i in 0...4
      respectivebet = @player1bet if i == 0
      respectivebet = @player2bet if i == 1
      respectivebet = @player3bet if i == 2
      respectivebet = @player4bet if i == 3
      @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)  ##pushes high number that doesnt matter / else it bugs
      lowestchip[i] -= (@previousbet - respectivebet)  ##this is to avoid players calling and geting negative chips
    end
    lowestchip.sort!
    case npc
    when 1
      pcoins = @players[1][0] - (@previousbet - @player2bet)
      pbet = @player2bet
      subroundraise = @player2srr  ##subround raises, to avoid raisefest npcs only raise once per sub round
    when 2
      pcoins = @players[2][0] - (@previousbet - @player3bet)
      pbet = @player3bet
      subroundraise = @player3srr
    when 3
      pcoins = @players[3][0] - (@previousbet - @player4bet)
      pbet = @player4bet
      subroundraise = @player4srr
    end
    
    return 1 if (@players[0][1] + @players[1][1] + @players[2][1] + @players[3][1]) == 1  ##doesnt raise or fold if 1 player up only
      
    fold = 95
    raisem = 15
    a=rand(100)+1
    
    c = @player1srr + @player2srr + @player3srr + @player4srr 
    
    c < 2 ? raisem -= 5*c : raisem -= 10*c    ##drops chance of raise if there was 1raise this subround, drops dramatically if there was 2 or more
    raisem -= @totalraises if @totalraises > 4 ##if there was more then 4 raises this ROUND, drops slightly and proportionately the chance for more raises
    
    if @previousbet == 0  ##check doesnt cost money, never fold
      fold = 101
    end
    if goodcard(npc) > 0   ##good hand, dont fold
      fold = 101
      raisem += 15 if goodcard(npc) == 1 ##good hand, more chances to raise
      raisem += 30 if goodcard(npc) == 2 ##rly good hand, more chances to raise
    end
    
    raisem -= @totalraises  ##adjust raise threshold for rng
    
    if subroundraise == 1   ##won't raise because already raised this subround
      raisem -= 45
    end
    
    if @previousbet == 0 && (pcoins < @blindvalue)  ##doesnt have money to bet
      raisem -= 45
    end
    
    if @previousbet > 0 && (pcoins < (@previousbet*2)) ##doesnt have money to raise
      raisem -= 45
    end
    
    if @comcards == 0 && ((@previousbet*2) > lowestchip[0]) ##lowest chips player cant call min raise
      raisem -= 45
    end
    
    if @comcards > 0 && (@blindvalue > lowestchip[0]) ##loest chips player cant call min bet
      raisem -= 45
    end
    return 3 if a > fold
    return 2 if a<raisem
    return 1  ##calls / check if doesnt fold or raise
  end #function
  
  def goodcard(npc)
    score = 0
    case npc
    when 1
      score = handrate(@player2card1,@player2card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
    when 2
      score = handrate(@player3card1,@player3card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
    when 3
      score = handrate(@player4card1,@player4card2,@comcard1,@comcard2,@comcard3,@comcard4,@comcard5)
    end
    return 0 if score < 300    ##high card
    return 1 if score < 25000  ##1 pair
    return 2 if score > 25000  ##2 pair -> won't go any further, we don't want cheater npcs
  end
  
  def betscene
    @raisevalue = 0        #### fixes bug with the display of bet value
    @sprites["betvalue"].bitmap.clear
    textarray = [[@raisevalue.to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["betvalue"].bitmap,textarray)
    updateselect
    @raisevalue = 0
    @betplaced = 0
    @select = 1
    @sprites["betui"].opacity = 255
    @sprites["selectarrow"].opacity = 255
    @sprites["betvalue"].opacity = 255
    @sprites["bet"].opacity = 255
    lowestchip = []
    
    for i in 0...4
      respectivebet = @player1bet if i == 0
      respectivebet = @player2bet if i == 1
      respectivebet = @player3bet if i == 2
      respectivebet = @player4bet if i == 3
      @players[i][1] == 1 ? lowestchip.push(@players[i][0]) : lowestchip.push(99999)
      lowestchip[i]-= (@previousbet - respectivebet)
    end
    lowestchip.sort!
    
    loop do
      Graphics.update
      Input.update
      if Input.trigger?(Input::B)  ##cancels raise / bet scene
        #pbPlayCancelSE()
        @raisevalue = 0
        break
      end
      if Input.trigger?(Input::UP)
        pbPlayCursorSE()
        @select == 1 ? @select = 6 : @select -= 1
        updateselect
      end      
      if Input.trigger?(Input::DOWN)
        pbPlayCursorSE()
        @select == 6 ? @select = 1 : @select += 1
        updateselect
      end
      if Input.trigger?(Input::C)
        case @select
        when 1
          if lowestchip[0] < 5 + @raisevalue
            pbPlayBuzzerSE()
            Kernel.pbMessage("Some players can't call that amount.")
          else
          pbPlayDecisionSE()  
          @raisevalue += 5
          updatebet
          end
        when 2
          if lowestchip[0] < 10 + @raisevalue
            pbPlayBuzzerSE()
            Kernel.pbMessage("Some players can't call that amount.")
          else
          pbPlayDecisionSE()  
          @raisevalue += 10
          updatebet
          end
        when 3
          if lowestchip[0] < 50 + @raisevalue
            pbPlayBuzzerSE()
            Kernel.pbMessage("Some players can't call that amount.")
          else
          pbPlayDecisionSE()
          @raisevalue += 50
          updatebet
          end
        when 4
          if lowestchip[0] < 100 + @raisevalue
            pbPlayBuzzerSE()
            Kernel.pbMessage("Some players can't call that amount.")
          else
          pbPlayDecisionSE()
          @raisevalue += 100
          updatebet
          end
        when 5
          allin = []
          for i in 0...4
            respectivebet = @player1bet if i == 0
            respectivebet = @player2bet if i == 1
            respectivebet = @player3bet if i == 2
            respectivebet = @player4bet if i == 3
            @players[i][1] == 1 ? allin.push(@players[i][0]) : allin.push(99999)
            allin[i]-= (@previousbet - respectivebet)
          end
          allin.sort!
          pbPlayDecisionSE()
          @raisevalue = allin[0]
          updatebet
        when 6
          if (@raisevalue<@blindvalue) && @previousbet == 0
            pbPlayBuzzerSE()
            Kernel.pbMessage("You must bet at least the value of the blind.")
          elsif (@raisevalue < (@previousbet*2))
            pbPlayBuzzerSE()
            Kernel.pbMessage("You must raise at least twice the previous bet.")
          elsif (@previousbet - @player1bet + @raisevalue > @players[0][0])
            pbPlayBuzzerSE()
            Kernel.pbMessage("You don't have that amount.")
          elsif (@raisevalue > lowestchip[0])
            pbPlayBuzzerSE()
            Kernel.pbMessage("Some players can't call that amount.")
          else
            if @previousbet == 0
              pbPlayDecisionSE()
              Kernel.pbMessage("#{@players[0][3]} bets #{@raisevalue} chips.")
              @betplaced = 1      ##breaks the bet / raise scene loop
            else
              pbPlayDecisionSE()
              Kernel.pbMessage("#{@players[0][3]} raises #{@raisevalue} chips.")
              @betplaced = 1
            end   ##@previousbet == 0
          end ## if @raisevalue < @blindvalue
          
        end ## case 1 - 6
      end ## if input C
      break if @betplaced == 1
    end  ## loop do
    @sprites["betui"].opacity = 0
    @sprites["selectarrow"].opacity = 0
    @select = 1 ##fixes bug with display of arrow next time betscene is accessed
    @sprites["betvalue"].opacity = 0    
    @sprites["bet"].opacity = 0    
  end ## function
  
  def updateselect
    case @select
    when 1
      @sprites["selectarrow"].x = 384
      @sprites["selectarrow"].y = 86      
    when 2
      @sprites["selectarrow"].x = 384
      @sprites["selectarrow"].y = 118      
    when 3
      @sprites["selectarrow"].x = 384
      @sprites["selectarrow"].y = 150           
    when 4
      @sprites["selectarrow"].x = 384
      @sprites["selectarrow"].y = 182            
    when 5
      @sprites["selectarrow"].x = 384
      @sprites["selectarrow"].y = 214            
    when 6
      @sprites["selectarrow"].x = 384
      @sprites["selectarrow"].y = 246
    end
  end
  
  def updatebet
    10.times do
      @sprites["betvalue"].opacity -= 25.5
      pbWait(1)
    end
    @sprites["betvalue"].bitmap.clear
    textarray = [[@raisevalue.to_s,26,0,2,Color.new(0,0,0),Color.new(240,240,200),false]]
    pbDrawTextPositions(@sprites["betvalue"].bitmap,textarray)
    10.times do
      @sprites["betvalue"].opacity += 25.5
      pbWait(1)
    end
  end
  
  def updatefold(arg)
    case arg
    when 0
      @sprites["p1_1"].opacity = 0
      @sprites["p1_2"].opacity = 0
    when 1
      @sprites["p2_1"].opacity = 0
      @sprites["p2_2"].opacity = 0
    when 2
      @sprites["p3_1"].opacity = 0
      @sprites["p3_2"].opacity = 0
    when 3
      @sprites["p4_1"].opacity = 0
      @sprites["p4_2"].opacity = 0
    end
  end
  
  def updatequitters
    if @players[1][2] == 0 && @sprites["p2name"].opacity == 255
      Kernel.pbMessage("#{@players[1][3]} quits the game.")
      10.times do
        @sprites["p2name"].opacity -= 25.5
        pbWait(1)
      end
      @sprites["p2name"].bitmap.clear
      textarray = [[@players[1][3],57,0,2,Color.new(255,0,0),Color.new(255,255,255),false]]
      pbDrawTextPositions(@sprites["p2name"].bitmap,textarray)
      10.times do
        @sprites["p2name"].opacity += 25.5
        pbWait(1)
      end
    end
    if @players[2][2] == 0 && @sprites["p3name"].opacity == 255
      Kernel.pbMessage("#{@players[2][3]} quits the game.")
      10.times do
        @sprites["p3name"].opacity -= 25.5
        pbWait(1)
      end
      @sprites["p3name"].bitmap.clear
      textarray = [[@players[2][3],57,0,2,Color.new(255,0,0),Color.new(255,255,255),false]]
      pbDrawTextPositions(@sprites["p3name"].bitmap,textarray)
      10.times do
        @sprites["p3name"].opacity += 25.5
        pbWait(1)
      end      
    end
    if @players[3][2] == 0 && @sprites["p4name"].opacity == 255
      Kernel.pbMessage("#{@players[3][3]} quits the game.")
      10.times do
        @sprites["p4name"].opacity -= 25.5
        pbWait(1)
      end
      @sprites["p4name"].bitmap.clear
      textarray = [[@players[3][3],57,0,2,Color.new(255,0,0),Color.new(255,255,255),false]]
      pbDrawTextPositions(@sprites["p4name"].bitmap,textarray)
      10.times do
        @sprites["p4name"].opacity += 25.5
        pbWait(1)
      end      
    end    
  end
  
  def sequenceannounce(score)
    return "a Royal Straight Flush" if score == 40000
    return "a Straight Flush" if score >= 39000
    return "a 4 of a Kind" if score >= 38000
    return "a Full House" if score >= 37000
    return "a Flush" if score >= 36000
    return "a Straight" if score >= 35000
    return "a 3 of a Kind" if score >= 30000
    return "2 Pairs" if score >= 25000
    return "a Pair" if score >= 300
    return "a High Card" 
  end
  
  def pokerdispose ###dispose all graphics
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport2.dispose
    @viewport3.dispose
    @viewport4.dispose
    @viewport5.dispose
  end
  
  
  def pbpokepokerstart
    loop do
      Graphics.update
      Input.update
      Kernel.pbMessage("Welcome to Poke Poker!")
      Kernel.pbMessage("We have at the table #{@players[0][3]}, #{@players[1][3]}, #{@players[2][3]} and #{@players[3][3]}.")
      Kernel.pbMessage("Each player starts with #{@fee} chips, the value of the blind is #{@blindvalue} chips.")
      Kernel.pbMessage("Happy gaming and may the odds be ever in your favor!")
      while @gameover == 0
        roundannouncement
        drawcards
        playround
        roundwinner
      end
      break
    end
    pokerdispose
  end
end #classpokepoker



#===============================================================================
# Racecourse(minigame) by bo4p5687
#===============================================================================
#
# How to use:
#  call script: pbRaceGame
#  
#===============================================================================
#
# To this script works, put it above main.
#
#===============================================================================
#===============================================================================
#------------------------------------------------------------------------------#
# Here, you can change numbers
#------------------------------------------------------------------------------#
# Name of graphics: %w{Name1 Name2 Name3 Namex}
CANDIDAT = %w{001 001 001 001}
NUMBER_RACEGAME = 
[
{
# Number announcement, graphics's name => [x,y]
# x,y: coordinate of the graphic
"1" => [162,71],
"2" => [162,71],
"3" => [162,71]
},
# Name of graphics: %w{Name1 Name2 Name3 Namex}
%w{Number1 Number2 Number3 Number4},
# [x,y]: position number before play
[13,88],
# y value: change after race (+),ex: 88+75
75
]
FIRST_SCREEN_RACEGAME =
# Name of graphics: %w{Name1 Name2 Name3 Namex}
%w{Screen Play Quit Select},
# [x,y] of "above" graphics
[
[0,0],
[220,226],
[220,286],
[170,232,60] # [x,y,i]: y' = y + i 
]
SECOND_SCREEN_RACEGAME = 
# Name of graphics: %w{Name1 Name2 Name3 Namex}
%w{Choice Title},
# [x,y] of "above" graphics
[
[0,0],
[0,0]
]
COIN_RACEGAME = 
{
# Image's name => Coin (number)
"Coin1" => 1,
"Coin2" => 12,
"Coin3" => 5,
"Coin4" => 17,
"Coin5" => 7,
"Coin6" => 24
}
POSITION_COIN_RACEGAME =
[
# [x,y]; x,y: coordinate of the graphic
[20,114],
[271,114],
[20,204],
[271,204],
[20,294],
[271,294]
]
OPACITY_COIN_RACEGAME = 
[
# Opacity [don't choose, choose]
[155,255],
[155,255],
[155,255],
[155,255],
[155,255],
[155,255]
]
SCREEN_CHOICE_POSITION_POKE_RACEGAME = 
[
# [x,y]; x,y: coordinate of the graphic
[120,17],
[322,17],
[120,207],
[322,207]
]
SCREEN_CHOICE_OPACITY_POKE_RACEGAME = 
[
# Opacity [don't choose, choose]
[155,255],
[155,255],
[155,255],
[155,255]
]
# Graphic's name, [x,y]: coordinate of the graphic (first), distance between 2 choices, 
# visible bar when play.
CHOOSE_BAR_RACEGAME = ["Choose", [0,84], 75, true] 
# Position pokemon before race: [x,y]: above, y: distance between 2 pokemon
POSITION_PKM_RACEGAME = [[400,51],75]
CONTINUE_SCREEN_RACEGAME = 
{
# continue screen's name => [x,y] 
# x,y: coordinate of the graphic 
"ScreenContinue" => [0,0],
"Select" => [143,172,110] # [x,y,i]: y' = y + i 
}
#------------------------------------------------------------------------------#
# Don't change below
#------------------------------------------------------------------------------#

class RaceGame
  
  def initialize
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=99998
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z=99997
    @viewport3=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport3.z=99999
    @sprites = {}
    @coin = {}
    @animation = 0
    @range = [0,0,0,0]
    @finish_course =[false,false,false,false]
    @rank_count = [0,0,0,0]
    @marked = [false,false,false,false]
    @win = nil
    @time = 0
    @process = 0
    @select = true; @selecttwo =0; @selectcoin = 0; @choose = 0; @check = true
    @continue = true
    @exit = false
  end
  
#------------------------------------------------------------------------------#
# Draw graphics
#------------------------------------------------------------------------------#

  def drawScene
    # Grass
    @sprites["grass"] = AnimatedPlane.new(@viewport1)
    @sprites["grass"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/Grass")
    # Scene
    @sprites["scene"] = Sprite.new(@viewport1)
    @sprites["scene"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/Race-track")
    @sprites["scene"].x = 0
    @sprites["scene"].y = 0
    @sprites["scene"].src_rect.x = 500
    @sprites["scene"].src_rect.y = 0
  end
  
  def draw_coin_box
    @sprites["coinbox"] = Sprite.new(@viewport3)
    @sprites["coinbox"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/CoinBox")
    @sprites["coinbox"].x = 0
    @sprites["coinbox"].y = 0
    @sprites["coinbox"].visible = false
  end
  
  def coin_box
    @coin = Sprite.new(@viewport3)
    @coin.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @coin.bitmap.font.size = 88
    textposition = []
    textposition.push([_INTL("{1}",$PokemonGlobal.coins.to_s),@sprites["coinbox"].bitmap.width - 64,204,true,Color.new(226,223,223),Color.new(0,0,0)])
    pbDrawTextPositions(@coin.bitmap,textposition)
  end
  
  def draw_choice_first
    (0...FIRST_SCREEN_RACEGAME[0].size).each {|i|
    @sprites["#{FIRST_SCREEN_RACEGAME[0][i]}"] = Sprite.new(@viewport2)
    @sprites["#{FIRST_SCREEN_RACEGAME[0][i]}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{FIRST_SCREEN_RACEGAME[0][i]}")
    @sprites["#{FIRST_SCREEN_RACEGAME[0][i]}"].x = FIRST_SCREEN_RACEGAME[1][i][0]
    @sprites["#{FIRST_SCREEN_RACEGAME[0][i]}"].y = FIRST_SCREEN_RACEGAME[1][i][1]
    }
  end

  def draw_choice_second
    (0...SECOND_SCREEN_RACEGAME[0].size).each {|i|
    @sprites["#{SECOND_SCREEN_RACEGAME[0][i]}"] = Sprite.new(@viewport2)
    @sprites["#{SECOND_SCREEN_RACEGAME[0][i]}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{SECOND_SCREEN_RACEGAME[0][i]}")
    @sprites["#{SECOND_SCREEN_RACEGAME[0][i]}"].x = SECOND_SCREEN_RACEGAME[1][i][0]
    @sprites["#{SECOND_SCREEN_RACEGAME[0][i]}"].y = SECOND_SCREEN_RACEGAME[1][i][1]
    }
  end
  
  def draw_continue
    (0...CONTINUE_SCREEN_RACEGAME.size).each {|i|
    @sprites["Ctn #{CONTINUE_SCREEN_RACEGAME.keys[i]}"] = Sprite.new(@viewport3)
    @sprites["Ctn #{CONTINUE_SCREEN_RACEGAME.keys[i]}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{CONTINUE_SCREEN_RACEGAME.keys[i]}")
    @sprites["Ctn #{CONTINUE_SCREEN_RACEGAME.keys[i]}"].x = CONTINUE_SCREEN_RACEGAME.values[i][0]
    @sprites["Ctn #{CONTINUE_SCREEN_RACEGAME.keys[i]}"].y = CONTINUE_SCREEN_RACEGAME.values[i][1]
    }
  end
  
  def draw_choice_poke
    (0...CANDIDAT.size).each {|i|
    @sprites["poke#{i}"] = Sprite.new(@viewport2)
    if File.exist?("Graphics/Battlers/Front/#{CANDIDAT[i]}.png")
      @sprites["poke#{i}"].bitmap = Bitmap.new("Graphics/Battlers/Front/#{CANDIDAT[i]}")
    else
      @sprites["poke#{i}"].bitmap = Bitmap.new("Graphics/Battlers/#{CANDIDAT[i]}")
    end
    @sprites["poke#{i}"].x = SCREEN_CHOICE_POSITION_POKE_RACEGAME[i][0]
    @sprites["poke#{i}"].y = SCREEN_CHOICE_POSITION_POKE_RACEGAME[i][1]
    @sprites["poke#{i}"].opacity = SCREEN_CHOICE_OPACITY_POKE_RACEGAME[i][0]
    }
  end
  
  def draw_coin
    @sprites["coin"] = Sprite.new(@viewport2)
    @sprites["coin"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/ScreenCoin")
    @sprites["coin"].x = 0; @sprites["coin"].y = 0
    (0...COIN_RACEGAME.size).each {|i|
    @sprites["#{COIN_RACEGAME.keys[i]}"] = Sprite.new(@viewport2)
    @sprites["#{COIN_RACEGAME.keys[i]}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{COIN_RACEGAME.keys[i]}")
    @sprites["#{COIN_RACEGAME.keys[i]}"].x = POSITION_COIN_RACEGAME[i][0]
    @sprites["#{COIN_RACEGAME.keys[i]}"].y = POSITION_COIN_RACEGAME[i][1]
    @sprites["#{COIN_RACEGAME.keys[i]}"].opacity = OPACITY_COIN_RACEGAME[i][0]
    }
  end

  def draw_poke
    (0...CANDIDAT.size).each {|i|
    if @selecttwo == i
      (0...CANDIDAT.size).each {|j|
      @sprites["player#{i} #{j}"] = Sprite.new(@viewport)
      @sprites["player#{i} #{j}"].bitmap = Bitmap.new("Graphics/Characters/#{CANDIDAT[i]}")
      @sprites["player#{i} #{j}"].zoom_x = 1.5
      @sprites["player#{i} #{j}"].zoom_y = 1.5
      @sprites["player#{i} #{j}"].src_rect.width = @sprites["player#{i} #{j}"].bitmap.width/4
      @sprites["player#{i} #{j}"].src_rect.height = @sprites["player#{i} #{j}"].bitmap.height/4
      @sprites["player#{i} #{j}"].src_rect.x = 0
      @sprites["player#{i} #{j}"].src_rect.y = @sprites["player#{i} #{j}"].src_rect.height
      @sprites["player#{i} #{j}"].x = POSITION_PKM_RACEGAME[0][0]
      @sprites["player#{i} #{j}"].y = POSITION_PKM_RACEGAME[0][1] + POSITION_PKM_RACEGAME[1]*j }
    end }
  end
  
  def draw_announcement
    (0...NUMBER_RACEGAME[0].size).each {|i|
    @sprites["announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}"] = Sprite.new(@viewport1)
    @sprites["announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}")
    @sprites["announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}"].x = NUMBER_RACEGAME[0].values[i][0]
    @sprites["announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}"].y = NUMBER_RACEGAME[0].values[i][1]
    @sprites["announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}"].visible = false
    pbWait(20)
    @sprites["announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}"].visible = true
    pbSEPlay("Battle ball drop")
    pbWait(20)
    pbDisposeSprite(@sprites,"announ #{NUMBER_RACEGAME[0].keys[NUMBER_RACEGAME[0].size-1-i]}") }
    pbSEPlay("GUI sel buzzer")
  end
  
  def choice
    @sprites["#{CHOOSE_BAR_RACEGAME[0]}"] = Sprite.new(@viewport3)
    @sprites["#{CHOOSE_BAR_RACEGAME[0]}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{CHOOSE_BAR_RACEGAME[0]}")
    @sprites["#{CHOOSE_BAR_RACEGAME[0]}"].x = CHOOSE_BAR_RACEGAME[1][0]
    @sprites["#{CHOOSE_BAR_RACEGAME[0]}"].y = CHOOSE_BAR_RACEGAME[1][1]
  end
  
  # Rank number
  def number
	(0...CANDIDAT.size).each{|j|
    (0...NUMBER_RACEGAME[1].size).each {|i|
    @sprites["#{NUMBER_RACEGAME[1][i]} #{j}"] = Sprite.new(@viewport1)
    @sprites["#{NUMBER_RACEGAME[1][i]} #{j}"].bitmap = Bitmap.new("Graphics/Pictures/Racecourse/#{NUMBER_RACEGAME[1][i]}")
    @sprites["#{NUMBER_RACEGAME[1][i]} #{j}"].x = NUMBER_RACEGAME[2][0]
    @sprites["#{NUMBER_RACEGAME[1][i]} #{j}"].y = NUMBER_RACEGAME[2][1]
    @sprites["#{NUMBER_RACEGAME[1][i]} #{j}"].visible = false
    }}
  end
  
#------------------------------------------------------------------------------#
# Play 
#------------------------------------------------------------------------------#

  #Start
  def pbStart
    if $PokemonBag.pbQuantity(PBItems::COINCASE)<=0
      pbMessage(_INTL("It's a Racecourse Game."))
    else
      if $PokemonGlobal.coins == 0
        pbMessage(_INTL("\\CNYou don't have enough Coins to play!"))
      else
        # Draw scene (first)
        draw_choice_first
        loop do
          update_ingame # Update graphics, input
          break if @exit
          in_loop_progress
        end
      end
    end
    pbEndScene
  end
  
  def in_loop_progress
    case @process
    when 0
      if Input.trigger?(Input::UP) || Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if @select
          @select = false
          @sprites["#{FIRST_SCREEN_RACEGAME[0][3]}"].y = FIRST_SCREEN_RACEGAME[1][3][1] + FIRST_SCREEN_RACEGAME[1][3][2]
        else
          @select = true
          @sprites["#{FIRST_SCREEN_RACEGAME[0][3]}"].y = FIRST_SCREEN_RACEGAME[1][3][1]
        end
      end
      if Input.trigger?(Input::C)
        # Dispose images
        dispose
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if @select 
          # Draw scene
          draw_choice_second
          draw_choice_poke
          # Set poke's opacity before choice
          select_two_after_choice
          # Next
          @process = 1
        else
          # Exit
          @exit = true
        end
      end
    when 1
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if (CANDIDAT.size) %2 == 0
          @selecttwo += (CANDIDAT.size)/2 
          if @selecttwo %2 == 0
            @selecttwo -= (CANDIDAT.size) if @selecttwo >= (CANDIDAT.size)
          else
            @selecttwo -= (CANDIDAT.size) if @selecttwo > (CANDIDAT.size)
          end
        else
          @selecttwo -= (CANDIDAT.size+1)/2
          @selecttwo = (CANDIDAT.size-1)/2 if @selecttwo == (CANDIDAT.size-1)/2
          if @selecttwo %2 == 0
            @selecttwo -= (CANDIDAT.size)+1 if @selecttwo > (CANDIDAT.size)
          else
            @selecttwo -= (CANDIDAT.size)-1 if @selecttwo >= (CANDIDAT.size)
          end
        end        
        # Set opacity
        select_two_after_choice
      end
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if (CANDIDAT.size)%2 == 0
          @selecttwo -= (CANDIDAT.size)/2 
          if @selecttwo %2 == 0
            @selecttwo = (CANDIDAT.size)-2 if @selecttwo < 0
          else
            @selecttwo = (CANDIDAT.size)-1 if @selecttwo < 1
          end
        else
          @selecttwo -= (CANDIDAT.size+1)/2
          @selecttwo = (CANDIDAT.size-1)/2 if @selecttwo == (CANDIDAT.size-1)/2
          if @selecttwo %2 == 0
            @selecttwo = (CANDIDAT.size)-1 if @selecttwo < 0
          else
            @selecttwo = (CANDIDAT.size)-2 if @selecttwo < 1
          end
        end
        # Set opacity
        select_two_after_choice
      end
      if Input.trigger?(Input::RIGHT)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @selecttwo += 1
        @selecttwo = 0 if @selecttwo == (CANDIDAT.size)
        # Set opacity
        select_two_after_choice
      end
      if Input.trigger?(Input::LEFT)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @selecttwo -= 1
        @selecttwo = (CANDIDAT.size)-1 if @selecttwo < 0
        # Set opacity
        select_two_after_choice
      end
      if Input.trigger?(Input::C)
        # Dispose images
        dispose
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        # Draw
        draw_coin
        draw_coin_box
        # Set coin's opacity before choice
        select_coin_after_choice
        @process = 2
      end
    when 2
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if (POSITION_COIN_RACEGAME.size) %2 == 0
          @selectcoin += (POSITION_COIN_RACEGAME.size)/2 
          if @selectcoin %2 == 0
            @selectcoin -= (POSITION_COIN_RACEGAME.size) if @selectcoin >= (POSITION_COIN_RACEGAME.size)
          else
            @selectcoin -= (POSITION_COIN_RACEGAME.size) if @selectcoin > (POSITION_COIN_RACEGAME.size)
          end
        else
          @selectcoin -= (POSITION_COIN_RACEGAME.size+1)/2
          @selectcoin = (POSITION_COIN_RACEGAME.size-1)/2 if @selectcoin == (POSITION_COIN_RACEGAME.size-1)/2
          if @selectcoin %2 == 0
            @selectcoin -= (POSITION_COIN_RACEGAME.size)+1 if @selectcoin > (POSITION_COIN_RACEGAME.size)
          else
            @selectcoin -= (POSITION_COIN_RACEGAME.size)-1 if @selectcoin >= (POSITION_COIN_RACEGAME.size)
          end
        end
        # Set coin
        select_coin_after_choice
      end
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if (POSITION_COIN_RACEGAME.size)%2 == 0
          @selectcoin -= (POSITION_COIN_RACEGAME.size)/2 
          if @selectcoin %2 == 0
            @selectcoin = (POSITION_COIN_RACEGAME.size)-2 if @selectcoin < 0
          else
            @selectcoin = (POSITION_COIN_RACEGAME.size)-1 if @selectcoin < 1
          end
        else
          @selectcoin -= (POSITION_COIN_RACEGAME.size+1)/2
          @selectcoin = (POSITION_COIN_RACEGAME.size-1)/2 if @selectcoin == (POSITION_COIN_RACEGAME.size-1)/2
          if @selectcoin %2 == 0
            @selectcoin = (POSITION_COIN_RACEGAME.size)-1 if @selectcoin < 0
          else
            @selectcoin = (POSITION_COIN_RACEGAME.size)-2 if @selectcoin < 1
          end
        end
        # Set coin
        select_coin_after_choice
      end
      if Input.trigger?(Input::RIGHT)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @selectcoin += 1
        @selectcoin = 0 if @selectcoin == (POSITION_COIN_RACEGAME.size)
        # Set coin
        select_coin_after_choice
      end
      if Input.trigger?(Input::LEFT)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @selectcoin -= 1
        @selectcoin = ((POSITION_COIN_RACEGAME.size)-1) if @selectcoin < 0
        # Set coin
        select_coin_after_choice
      end
      if Input.trigger?(Input::A)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if @check
          @sprites["coinbox"].visible = true
          coin_box
          @check = false
        else
          @sprites["coinbox"].visible = false
          @coin.visible = false
          @coin.bitmap.clear
          @check = true
        end
      end
      if Input.trigger?(Input::B)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if !@check
          @exit = true
        end
      end
      if Input.trigger?(Input::C)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        # Calc coin
        if $PokemonGlobal.coins < COIN_RACEGAME.values[@selectcoin] || $PokemonGlobal.coins == 0
          pbMessage(_INTL("You don't have enough Coins!"))
        else
          $PokemonGlobal.coins -= COIN_RACEGAME.values[@selectcoin]
          #Dispose images
          dispose
          # Draw
          draw_poke
          drawScene
          choice
          # Position bar
          choose_bar_visible
          @process = 3
        end
      end
    when 3
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choose += 1
        @choose = 0 if @choose == (CANDIDAT.size)
        # Position bar
        choose_bar_visible
      end
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choose -= 1
        @choose = (CANDIDAT.size)-1 if @choose < 0
        # Position bar
        choose_bar_visible
      end
      if Input.trigger?(Input::C)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if CHOOSE_BAR_RACEGAME[3] 
          @sprites["#{CHOOSE_BAR_RACEGAME[0]}"].visible = true
        else
          # Dispose sprite "bar"
          pbDisposeSprite(@sprites,"#{CHOOSE_BAR_RACEGAME[0]}")
        end
        # Draw and display
        draw_announcement
        @process = 4
      end
    when 4
      # Play and next process
      play
    when 5
      # Order pokemon
      define_order
    when 6
      if @choose == @win
        coin_plus_or_minus 
      else
        pbMessage(_INTL("\\wuNothing doing!"))
      end
      # Dispose
      dispose
      # Draw
      draw_continue
      @process = 7
    when 7
      if Input.trigger?(Input::UP) || Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if @continue 
          @sprites["Ctn #{CONTINUE_SCREEN_RACEGAME.keys[1]}"].y = CONTINUE_SCREEN_RACEGAME.values[1][1] + CONTINUE_SCREEN_RACEGAME.values[1][2]
          @continue = false
        else
          @sprites["Ctn #{CONTINUE_SCREEN_RACEGAME.keys[1]}"].y = CONTINUE_SCREEN_RACEGAME.values[1][1]
          @continue = true
        end
      end
      if Input.trigger?(Input::C)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        if @continue
          if $PokemonGlobal.coins == 0
            pbMessage(_INTL("You don't have enough Coins to play!"))
          else
            # Dispose
            dispose
            # Draw scene (first)
            draw_choice_first
            # Reset 
            reset_all
          end
        else
          @exit = true
        end
      end
    end
  end
  
  def select_two_after_choice
    (0...CANDIDAT.size).each{|i|
    @sprites["poke#{i}"].opacity = SCREEN_CHOICE_OPACITY_POKE_RACEGAME[i][0]
    @sprites["poke#{@selecttwo}"].opacity = SCREEN_CHOICE_OPACITY_POKE_RACEGAME[@selecttwo][1] if i == @selecttwo
    }
  end
  
  def select_coin_after_choice
    (0...COIN_RACEGAME.size).each {|i|
    @sprites["#{COIN_RACEGAME.keys[i]}"].opacity = OPACITY_COIN_RACEGAME[i][0]
    @sprites["#{COIN_RACEGAME.keys[i]}"].opacity = OPACITY_COIN_RACEGAME[@selectcoin][1] if i == @selectcoin
    }
  end
  
  def choose_bar_visible
    (0...CANDIDAT.size).each {|i| @sprites["#{CHOOSE_BAR_RACEGAME[0]}"].y = CHOOSE_BAR_RACEGAME[1][1] + CHOOSE_BAR_RACEGAME[2]*@choose}
  end
  
  def candidat_animation(plus=nil,number=0,condition=false,condition_x=0)
    (0...CANDIDAT.size).each {|i| 
    if @selecttwo == i
      (0...CANDIDAT.size).each {|j|
      @sprites["player#{i} #{j}"].src_rect.x += @sprites["player#{i} #{j}"].src_rect.width
      @sprites["player#{i} #{j}"].src_rect.x = 0  if @sprites["player#{i} #{j}"].src_rect.x >= @sprites["player#{i} #{j}"].bitmap.width
      if !condition
        @sprites["player#{i} #{j}"].x += number if plus
        @sprites["player#{i} #{j}"].x -= number if !plus
      elsif condition && @sprites["player#{i} #{j}"].x <= condition_x
        @sprites["player#{i} #{j}"].x += number if plus
        @sprites["player#{i} #{j}"].x -= number if !plus
      end}
    end}
  end
  
  def move_candidat(plus_num=0,minus_num=0,condition_x=0)
    (0...CANDIDAT.size).each {|i| 
    if @selecttwo == i
      (0...CANDIDAT.size).each {|j|
      @sprites["player#{i} #{j}"].x += plus_num
		  @sprites["player#{i} #{j}"].x -= minus_num if @sprites["player#{i} #{j}"].x > condition_x && @range_sort_uniq[0] == @range[j]}
    end}
  end
  
  def check_finish(number=0,define=false)
    (0...CANDIDAT.size).each {|i| 
    if @selecttwo == i
      (0...CANDIDAT.size).each {|j|
      @finish_course[j] = true if !(@finish_course[j]) && @sprites["player#{i} #{j}"].x <= number
      if define
        if @sprites["player#{i} #{j}"].x >= 0 
          @rank_count[j] += number - @sprites["player#{i} #{j}"].x 
        elsif @sprites["player#{i} #{j}"].x < 0
          @rank_count[j] += number*2 - @sprites["player#{i} #{j}"].x 
        end
      end}
    end}
  end
  
  def scene_move(grass=0,scene=0)
    @sprites["grass"].ox += grass
		@sprites["scene"].src_rect.x -= scene
  end
  
  def play
    @animation += 1
    # Animation
    @animation = 0 if @animation == 3 
    @time += 1
    # Begin
    if @time < 500
      if @sprites["scene"].src_rect.x > 340
        candidat_animation(false,4) if @animation%3 == 0
        scene_move(4,1)
      elsif @sprites["scene"].src_rect.x <= 340
        candidat_animation if @animation%2 == 0
        scene_move(7)
        (0...@range.size).each{|i| @range[i] = rand(20)}
        @range_sort_uniq = @range.sort.reverse
        @range_sort_uniq.uniq!
        move_candidat(2,8,200) unless @range_sort_uniq.size != @range.size
      end
    # Middle
    elsif @time >= 500 && @time < 600
      candidat_animation if @animation%2 == 0
      scene_move(5)
    elsif @time >= 600 && @time < 1000
      candidat_animation if @animation%3 == 0
      scene_move(7)
      (0...@range.size).each{|i| @range[i] = rand(10)}
      @range_sort_uniq = @range.sort.reverse
      @range_sort_uniq.uniq!
      move_candidat(2,10,200) unless @range_sort_uniq.size != @range.size
    # End
    elsif @time >= 1000
      if @sprites["scene"].src_rect.x > 0
        candidat_animation(true,2,true,700) if @animation%2 == 0
        scene_move(4,2)
      elsif @sprites["scene"].src_rect.x == 0
        candidat_animation(false,2,true,700) if @animation%2 == 0
        # Stop course
        check_finish(110)
        if !(@finish_course.include? false)
          # Draw number rank
          number
          # Define order (number = number 'above')
          check_finish(110,true)
          @process = 5 
        end
      end
    end
  end
  
  def visible_order
    (0...CANDIDAT.size).each{|i|
    (0...@rank_sort_uniq.size).each{|j|
    if @rank_sort_uniq[j] == @rank_count[i] && !@marked[i]  
      @sprites["#{NUMBER_RACEGAME[1][j]} #{i}"].visible = true 
      @sprites["#{NUMBER_RACEGAME[1][j]} #{i}"].y = NUMBER_RACEGAME[2][1] + NUMBER_RACEGAME[3]*i
      @marked[i] = true
      @win = i if j==0 && @rank_sort_uniq.size == CANDIDAT.size
    end
    }}
  end
  
  def define_order
    @rank_sort_uniq = @rank_count.sort.reverse
    # Delete same number
    @rank_sort_uniq.uniq!
    visible_order
    pbWait(25)
    @process = 6
  end
  
  def coin_plus_or_minus
    (0...COIN_RACEGAME.size).each{|i| 
    if @selectcoin == i 
      $PokemonGlobal.coins += COIN_RACEGAME.values[i]*2
      pbMEPlay("SlotsWin")
      pbMessage(_INTL("\\wuYou've won {1} Coins!",COIN_RACEGAME.values[i]*2))
    end }
  end
  
  def reset_all
    @animation = 0
    @range = [0,0,0,0]
    @finish_course =[false,false,false,false]
    @rank_count = [0,0,0,0]
    @marked = [false,false,false,false]
    @win = nil
    @time = 0
    @select = true; @selecttwo =0; @selectcoin = 0; @choose = 0; @check = true
    @continue = true
    @process = 0
  end
  
  def dispose
    pbDisposeSpriteHash(@sprites)
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def update_ingame
    Graphics.update
    Input.update
    self.update
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end

end

def pbRaceGame
  a = []
  (0...CANDIDAT.size).each {|i| 
  if !File.exist?("Graphics/Characters/#{CANDIDAT[i]}.png")
    a.push false
  else
    a.push true
  end
  }
  if a.include? false
    pbMessage(_INTL("You don't have the sprites. Please add these!"))
  else
    scene=RaceGame.new
    scene.pbStart
  end
end

#===============================================================================
# * Roulette mini-game - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It's the Roulette Game Corner minigame
# from Ruby/Sapphire/Emerald. This minigame isn't an exact adaptation of the
# official one, the ball never stops at an occupied slot, so there's no
# Taillow and Shroomish bonus. The ball chance is 1/free slots quantity.
#
#===============================================================================
#
# To this script works, put it above main, create "Roulette" folder at
# Graphics/Pictures and put the pictures (may works with other sizes):
# -  30x30  ball
# -  16x16  ballicon 
# -  16x16  ballusedicon
# - 116x56  creditbox
# -  56x32  multiplierbox
# - 306x306 roulette
# - 240x46  selectedcolor
# -  46x46  selectedsingle
# -  46x192 selectedspecies
# - 244x196 table
#  
# To call this script, use the script command 'pbRoulette(X)' where X is the
# wager number.
#
#===============================================================================

class RouletteScene
  TABLEPOSITIONS=[
    [1,10, 7,4],
    [5, 2,11,8],
    [9, 6, 3,0]
  ]
  COLUMNS=4
  ROWS=3
  ROUNDS=6 # Before clean the board
  
  class RouletteCursor
    attr_reader :sprite
    attr_reader :indexX
    attr_reader :indexY
    
    def initialize(sprite,playedBalls,tableX,tableY)
      @sprite=sprite
      @sprite.x=8
      @sprite.y=8
      @playedBalls=playedBalls
      @tableX=tableX
      @tableY=tableY
      @frameCount=0
      @indexX=-1
      @indexY=-1
      setIndex(1,1)
    end  
    
    def update
      @frameCount+=1
      @sprite.visible=!@sprite.visible if @frameCount%16==0 # Flash effect
    end  
    
    def resetframeCount
      @frameCount=0
      @sprite.visible=true
    end
    
    def moveUp;   setIndex(@indexX,@indexY-1);end  
    def moveDown; setIndex(@indexX,@indexY+1);end  
    def moveLeft; setIndex(@indexX-1,@indexY);end  
    def moveRight;setIndex(@indexX+1,@indexY);end  
    
    def setIndex(x,y)
      pbPlayCursorSE() if @indexX!=-1 # Ignores first time
      x%=COLUMNS+1
      y%=ROWS+1
      # Small adjustment
      if @indexY==0 && x==0
        x = @indexX==1 ? COLUMNS : 1
      end
      if @indexX==0 && y==0
        y = @indexY==1 ? ROWS : 1
      end
      # Change index format 
      if x==0 && @indexX!=0 
        @sprite.setBitmap("Graphics/Pictures/Roulette/selectedcolor")
      end
      if y==0 && @indexY!=0
        @sprite.setBitmap("Graphics/Pictures/Roulette/selectedspecies")
      end
      if (y!=0 && @indexY<=0) || (x!=0 && @indexX<=0)
        @sprite.setBitmap("Graphics/Pictures/Roulette/selectedsingle")
      end  
      @indexX = x
      @indexY = y
      @sprite.x=@tableX-2+@indexX*48
      @sprite.x+=4 if @indexX==0 
      @sprite.y=@tableY-2+@indexY*48
      @sprite.y+=4 if @indexY==0 
      resetframeCount
    end
    
    def bentPositions
      if @indexX==0
        return TABLEPOSITIONS[@indexY-1]
      elsif @indexY==0
        return TABLEPOSITIONS.transpose[@indexX-1]
      else
        return [TABLEPOSITIONS[@indexY-1][@indexX-1]]    
      end    
    end 
    
    def multiplier # Picks the multiplier value
      checkedPositions=[]
      if @indexX==0
        checkedPositions=@playedBalls[(@indexY-1)*COLUMNS,COLUMNS]
      elsif @indexY==0
        for i in 0...ROWS
          checkedPositions.push(@playedBalls[@indexX-1+i*COLUMNS])
        end  
      else
        checkedPositions.push(@playedBalls[@indexX-1+(@indexY-1)*COLUMNS])
      end  
      div=RouletteScreen.count(checkedPositions,false)
      result=0
      result=COLUMNS*ROWS/div if div!=0
      return result
    end  
  end  
  
  class RouletteObject
    attr_reader :roulette # Sprite
    attr_reader :balls # Sprite Array
    
    def initialize(roulette)
      @roulette=roulette
      @balls=[]
    end   
    
    def addBall(sprite)
      sprite.x=roulette.x
      sprite.y=roulette.y
      sprite.visible=true
      sprite.angle=@roulette.angle-10
      balls.push(sprite)
    end  
    
    def clearBalls
      for ball in @balls
        ball.visible=false
      end  
      @balls.clear
    end 
    
    # Redraws the bitmap with the height and the changed ox and oy where
    # the ball picture will be at the top to create the illusion that the
    # ball is spinning.
    # The lower the height, the lower the distance to the roulette center.
    def adjustBitmapBall(i,height) # 
      bitmapBall = Bitmap.new("Graphics/Pictures/Roulette/ball")
      @balls[i].bitmap=Bitmap.new(30,height)
      @balls[i].bitmap.blt(0,0,bitmapBall,bitmapBall.rect)
      @balls[i].ox=balls[i].bitmap.width/2
      @balls[i].oy=balls[i].bitmap.height
    end  
    
    def sumX(value)
      @roulette.x+=value
      for ball in @balls
        ball.x+=value
      end  
    end
    
    def sumAngle(value)
      @roulette.angle+=value
      for ball in @balls
        ball.angle+=value
      end  
    end  
    
    def update
      sumAngle(2)
    end  
  end  
  
  def update
    pbUpdateSpriteHash(@sprites)
    @cursor.update
    @roulette.update
  end
  
  def pbStartScene(wager)
    @sprites={} 
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    # To change the board color and the used icon color, just change the two
    # below variable. You can set conditions like the wager at official games.
    @backgroundColor=Color.new(192,32,80)
    @usedIconColor=Color.new(248,152,160)
#    if wager>=3 # Activates second table color values
#      @backgroundColor=Color.new(80,192,32) 
#      @usedIconColor=Color.new(160,248,152)
#    end
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].bitmap=Bitmap.new(Graphics.width,Graphics.height)
    @sprites["background"].bitmap.fill_rect(0,0,
        @sprites["background"].bitmap.width, 
        @sprites["background"].bitmap.height, @backgroundColor)
    @sprites["roulette"]=IconSprite.new(0,0,@viewport)
    @sprites["roulette"].setBitmap("Graphics/Pictures/Roulette/roulette")
    @sprites["roulette"].x=@sprites["roulette"].bitmap.width/2+4
    @sprites["roulette"].y=Graphics.height/2    
    @sprites["roulette"].ox=@sprites["roulette"].bitmap.width/2
    @sprites["roulette"].oy=@sprites["roulette"].bitmap.height/2
    @roulette=RouletteObject.new(@sprites["roulette"])
    @sprites["table"]=IconSprite.new(0,0,@viewport)
    @sprites["table"].setBitmap("Graphics/Pictures/Roulette/table")
    @sprites["table"].x=Graphics.width-@sprites["table"].bitmap.width-16
    @sprites["table"].y=Graphics.height-@sprites["table"].bitmap.height-16
    @sprites["multiplierbox"]=IconSprite.new(0,0,@viewport)
    @sprites["multiplierbox"].setBitmap(
        "Graphics/Pictures/Roulette/multiplierbox")
    @sprites["multiplierbox"].x=@sprites["table"].x-12
    @sprites["multiplierbox"].y=@sprites["table"].y+6
    @sprites["creditbox"]=IconSprite.new(0,0,@viewport)
    @sprites["creditbox"].setBitmap("Graphics/Pictures/Roulette/creditbox")
    @sprites["creditbox"].x=Graphics.width-@sprites["creditbox"].bitmap.width-8
    @sprites["creditbox"].y=8
    for i in 0...ROUNDS
      @sprites["ball#{i}"]=IconSprite.new(0,0,@viewport)
      @sprites["ball#{i}"].visible=false
      @sprites["balltable#{i}"]=IconSprite.new(0,0,@viewport)
      @sprites["balltable#{i}"].setBitmap("Graphics/Pictures/Roulette/ball")
      @sprites["balltable#{i}"].visible=false
      @sprites["ballicon#{i}"]=IconSprite.new(0,0,@viewport)
      @sprites["ballicon#{i}"].setBitmap("Graphics/Pictures/Roulette/ballicon")
      # Right to left
      @sprites["ballicon#{i}"].x=(@sprites["creditbox"].x+10+(ROUNDS-i-1)*16)
      @sprites["ballicon#{i}"].y=(
          @sprites["creditbox"].y+@sprites["creditbox"].bitmap.height+2)
    end  
    @sprites["cursor"]=IconSprite.new(0,0,@viewport)
    @playedBalls=[]
    (COLUMNS*ROWS).times do
      @playedBalls.push(false)
    end
    @cursor = RouletteCursor.new(@sprites["cursor"],@playedBalls,
        @sprites["table"].x,@sprites["table"].y)
    @sprites["overlaycredits"]=BitmapSprite.new(
        Graphics.width,Graphics.height,@viewport)
    @sprites["overlaymultiplier"]=BitmapSprite.new(
        Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlaycredits"].bitmap)
    pbSetSystemFont(@sprites["overlaymultiplier"].bitmap)
    @sprites["overlaycredits"].bitmap.font.bold=true
    @sprites["overlaymultiplier"].bitmap.font.bold=true
    @wager=wager
    @centralizeRoulette = false
    @movedDistance = 0
    @waitingMovement = false
    @degreesToSpin = 0
    @exit=false
    pbDrawCredits
    pbFadeInAndShow(@sprites) { update }
    pbMessage(_INTL("Place your wager with the arrows, then press the C key."))
    pbDrawMultiplier
  end
  
  def pbDrawMultiplier
    overlay=@sprites["overlaymultiplier"].bitmap
    overlay.clear     
    multiplier=@cursor.multiplier
    return if multiplier==0
    textPosition=[multiplier.to_s,
       @sprites["multiplierbox"].x+@sprites["multiplierbox"].bitmap.width-8,
       @sprites["multiplierbox"].y,
       true,Color.new(248,168,136),Color.new(96,96,112)
    ]
    # Color.new(248,168,136)
    # Color.new(248,80,56)
    pbDrawTextPositions(overlay,[textPosition])
  end

  def pbDrawCredits
    overlay=@sprites["overlaycredits"].bitmap
    overlay.clear     
    textPosition=[$PokemonGlobal.coins.to_s,
        @sprites["creditbox"].x+@sprites["creditbox"].bitmap.width-26,
        @sprites["creditbox"].y+26,
        true,Color.new(248,248,248),Color.new(0,0,0)
    ]
    pbDrawTextPositions(overlay,[textPosition])
  end
  
  # Adds the coins and updates the credit box. Return false if coins+number<0
  def pbAddCredits(number)
    return false if $PokemonGlobal.coins+number<0
    $PokemonGlobal.coins+=number
    $PokemonGlobal.coins=getMaxCoins if $PokemonGlobal.coins>getMaxCoins
    pbDrawCredits
    return true
  end  
  
  def pbMessage(message)
    Kernel.pbMessage(message){update}
  end  
  
  def pbConfirmMessage(message)
    return Kernel.pbConfirmMessage(message){update}
  end  
  
  def pbMain
    loop do
      Graphics.update
      Input.update
      self.update
      if @waitingMovement
        pbMovePictures
      elsif @degreesToSpin>0
        pbSpinRoulette
      else
        if Input.trigger?(Input::C) 
          if @cursor.multiplier!=0 # Valid bent
            pbSEPlay("SlotsCoin")
            pbAddCredits(-@wager)
            @centralizeRoulette = !@centralizeRoulette
            @waitingMovement = true
          else  
            pbPlayBuzzerSE()
          end
        end
        break if @exit
        if Input.trigger?(Input::UP);   @cursor.moveUp;   pbDrawMultiplier;end 
        if Input.trigger?(Input::DOWN); @cursor.moveDown; pbDrawMultiplier;end 
        if Input.trigger?(Input::LEFT); @cursor.moveLeft; pbDrawMultiplier;end 
        if Input.trigger?(Input::RIGHT);@cursor.moveRight;pbDrawMultiplier;end 
      end   
    end 
  end
  
  def pbMovePictures
    speed = 12
    speed *= - 1 if !@centralizeRoulette # Reverse the way
    @roulette.sumX(speed/3)
    @sprites["table"].x+=speed
    for i in 0...RouletteScreen.count(@playedBalls,true)
      @sprites["balltable#{i}"].x+=speed
    end
    @sprites["multiplierbox"].x+=speed
    @sprites["cursor"].x+=speed
    @sprites["overlaymultiplier"].x+=speed
    @movedDistance+=speed 
    # The conditions for finish centralize and decentralize
    if ( @centralizeRoulette && Graphics.width<(@sprites["table"].x+48) ||
        !@centralizeRoulette && @movedDistance==0)
      @waitingMovement = false
      @centralizeRoulette ? pbStartSpin : pbEndSpin
    end
  end  
  
  SPINS=[60*30,36*20,30*10,20*3] # Spins quantity and tiers
  
  def pbStartSpin
    i=RouletteScreen.count(@playedBalls,true)
    @sprites["ballicon#{i}"].setBitmap(
        "Graphics/Pictures/Roulette/ballusedicon")
    @sprites["ballicon#{i}"].color=@usedIconColor
    @result=-1    
    loop do
      @result = rand(@playedBalls.size)
      break if !@playedBalls[@result]
    end
    @roulette.addBall(@sprites["ball#{i}"])
    @roulette.adjustBitmapBall(i,148)    
    @variableDegrees=10*3*TABLEPOSITIONS.flatten[@result]+SPINS[3]
    @degreesToSpin=SPINS[0]+SPINS[1]+SPINS[2]+@variableDegrees
    # Rolling Ball ME should starts here.
  end
  
  def pbSpinRoulette
    i=RouletteScreen.count(@playedBalls,true)
    # Spins tier speeds
    if @degreesToSpin>SPINS[1]+SPINS[2]+@variableDegrees
      degrees=30
    elsif @degreesToSpin>SPINS[2]+@variableDegrees
      degrees=20
    elsif @degreesToSpin>@variableDegrees
      degrees=10
    elsif @degreesToSpin>0
      degrees=3
    end  
    @sprites["ball#{i}"].angle-=degrees
    @degreesToSpin-=degrees
    # Makes the ball more near of the center after some spins
    height=0
    if @degreesToSpin==0
      height=74
    elsif @degreesToSpin==@variableDegrees
      height=88
    elsif @degreesToSpin==SPINS[2]/2+@variableDegrees
      height=98
    elsif @degreesToSpin==SPINS[2]+@variableDegrees
      height=108
    elsif @degreesToSpin==SPINS[1]/2+SPINS[2]+@variableDegrees
      height=118
    elsif @degreesToSpin==SPINS[1]+SPINS[2]+@variableDegrees
      height=128
    end
    @roulette.adjustBitmapBall(i,height) if height!=0
    if @degreesToSpin==0 # End
      # Rolling Ball BGS should stops here.
      pbSEPlay("balldrop")
      @centralizeRoulette = !@centralizeRoulette
      @waitingMovement = true
    end  
  end  
  
  def pbEndSpin
    i=RouletteScreen.count(@playedBalls,true)
    @sprites["balltable#{i}"].visible=true
    @sprites["balltable#{i}"].x=6+@sprites["table"].x+(@result%COLUMNS+1)*48
    @sprites["balltable#{i}"].y=6+@sprites["table"].y+(@result/COLUMNS+1)*48
    wins = @cursor.bentPositions.include?(TABLEPOSITIONS.flatten[@result])
    if wins
      multiplier = @cursor.multiplier
      if multiplier==12
        pbMessage(_INTL("\\me[SlotsBigWin]Jackpot!\\wtnp[50]"))
      else
        pbMessage(_INTL("\\me[SlotsWin]It's a hit!\\wtnp[30]"))
      end
      pbMessage(_INTL("You've won {1} Coins!",@wager*multiplier))
      pbAddCredits(@wager*multiplier)
    else  
      pbPlayBuzzerSE()
      pbMessage(_INTL("Nothing doing!"))
    end
    @playedBalls[@result]=true
    if i==(ROUNDS-1) # Clear
      pbMessage(_INTL("The Roulette board will be cleared."))
      @roulette.clearBalls
      @playedBalls.clear
      (COLUMNS*ROWS).times do
        @playedBalls.push(false)
      end  
      for index in 0...ROUNDS
        @sprites["balltable#{index}"].visible=false
        @sprites["ballicon#{index}"].setBitmap(
            "Graphics/Pictures/Roulette/ballicon")
        @sprites["ballicon#{index}"].color=Color.new(0,0,0,0)
      end  
    end  
    pbDrawMultiplier
    if pbConfirmMessage(_INTL("Keep playing?"))
      if $PokemonGlobal.coins<@wager
        pbMessage(_INTL("You don't have enough Coins to play!"))
        @exit=true 
      end
    else  
      @exit=true 
    end  
  end  

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end


class RouletteScreen
  # Added since RGSS Array class doesn't have count
  def self.count(array, value)
    ret=0
    for element in array
      ret+=1 if element==value
    end
    return ret
  end  
  
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(wager)
    @scene.pbStartScene(wager)
    @scene.pbMain
    @scene.pbEndScene
  end
end

def pbRoulette(wager=1)
  if $PokemonBag.pbQuantity(PBItems::COINCASE)<=0
    Kernel.pbMessage(_INTL("It's a Roulette."))
  elsif Kernel.pbConfirmMessage(_INTL(
      "\\CNThe minimum wanger at this table is {1}. Do you want to play?",
      wager))
    if $PokemonGlobal.coins<wager
      Kernel.pbMessage(_INTL("You don't have enough Coins to play!"))
    elsif $PokemonGlobal.coins==getMaxCoins
      Kernel.pbMessage(_INTL("Your Coin Case is full!"))  
    else    
      scene=RouletteScene.new
      screen=RouletteScreen.new(scene)
      screen.pbStartScreen(wager)
    end
  end
end

def getMaxCoins; defined?(MAX_COINS) ? MAX_COINS : MAXCOINS; end