

#==============================================================================#
#                                                                               
#                         GALAR BERRY TREE Script                               
#                            By BhagyaJyoti                                     
#                       Originally By #Not Important                            
#                           Help from Zeak6464                                  
#                          For Essentials v18                                   
#                         Complete plug-n-play                                  
#                                                                               
#==============================================================================#
BERRY_TREE_GALAR = true                                                         
#Disable this if you only want to use a single script command for the Berry Tree.
#Enable this if you want realistic time-based berry tree. See example event.
                                                                                
def pbBerryTreeMain
  vbberries=[:CHERIBERRY,:CHESTOBERRY,:PECHABERRY,:RAWSTBERRY,:ASPEARBERRY,:LEPPABERRY,:ORANBERRY,:PERSIMBERRY,:LUMBERRY,:SITRUSBERRY,:FIGYBERRY,:WIKIBERRY,:MAGOBERRY,:AGUAVBERRY,:IAPAPABERRY,:RAZZBERRY,:BLUKBERRY,:NANABBERRY,:WEPEARBERRY,:PINAPBERRY,:POMEGBERRY,:KELPSYBERRY,:QUALOTBERRY,:HONDEWBERRY,:GREPABERRY,:TAMATOBERRY,:CORNNBERRY,:MAGOSTBERRY,:RABUTABERRY,:NOMELBERRY,:SPELONBERRY,:PAMTREBERRY,:WATMELBERRY,:DURINBERRY,:BELUEBERRY,:OCCABERRY,:PASSHOBERRY,:WACANBERRY,:RINDOBERRY,:YACHEBERRY,:CHOPLEBERRY,:KEBIABERRY,:SHUCABERRY,:COBABERRY,:PAYAPABERRY,:TANGABERRY,:CHARTIBERRY,:KASIBBERRY,:HABANBERRY,:COLBURBERRY,:BABIRIBERRY,:CHILANBERRY,:LIECHIBERRY,:GANLONBERRY,:SALACBERRY,:PETAYABERRY,:APICOTBERRY,:LANSATBERRY,:STARFBERRY,:ENIGMABERRY,:MICLEBERRY,:CUSTAPBERRY,:JABOCABERRY,:ROWAPBERRY,:ROSELIBERRY,:KEEBERRY,:MARANGABERRY,:REDAPRICORN,:BLUEAPRICORN,:BLACKAPRICORN,:YELLOWAPRICORN,:GREENAPRICORN,:WHITEAPRICORN,:PINKAPRICORN]
  chanceBerry=rand(6)  #Encounters 2/10 of the time
  if  chanceBerry==0 ||  chanceBerry==2 ||  chanceBerry==3 || chanceBerry==5
    vbberry = vbberries[rand(76)]
    pbItemBall(vbberry)
  elsif  chanceBerry==1 ||  chanceBerry==4
    pbEncounter(EncounterTypes::BerryTree)
    pbMessage("Other pokemon took the berries left on the tree away...")
  end
end

def pbBerryTree
  pbMessage("This is a Berry Tree.")
  if pbConfirmMessage(_INTL("Would you like to shake it?"))
      pbBerryTreeMain
  else
    pbMessage(_INTL("Left it alone."))
  end
end                                                                               
def pbBerryGift
  vbberries=[:CHERIBERRY,:CHESTOBERRY,:PECHABERRY,:RAWSTBERRY,:ASPEARBERRY,:LEPPABERRY,:ORANBERRY,:PERSIMBERRY,:LUMBERRY,:SITRUSBERRY,:FIGYBERRY,:WIKIBERRY,:MAGOBERRY,:AGUAVBERRY,:IAPAPABERRY,:RAZZBERRY,:BLUKBERRY,:NANABBERRY,:WEPEARBERRY,:PINAPBERRY,:POMEGBERRY,:KELPSYBERRY,:QUALOTBERRY,:HONDEWBERRY,:GREPABERRY,:TAMATOBERRY,:CORNNBERRY,:MAGOSTBERRY,:RABUTABERRY,:NOMELBERRY,:SPELONBERRY,:PAMTREBERRY,:WATMELBERRY,:DURINBERRY,:BELUEBERRY,:OCCABERRY,:PASSHOBERRY,:WACANBERRY,:RINDOBERRY,:YACHEBERRY,:CHOPLEBERRY,:KEBIABERRY,:SHUCABERRY,:COBABERRY,:PAYAPABERRY,:TANGABERRY,:CHARTIBERRY,:KASIBBERRY,:HABANBERRY,:COLBURBERRY,:BABIRIBERRY,:CHILANBERRY,:LIECHIBERRY,:GANLONBERRY,:SALACBERRY,:PETAYABERRY,:APICOTBERRY,:LANSATBERRY,:STARFBERRY,:ENIGMABERRY,:MICLEBERRY,:CUSTAPBERRY,:JABOCABERRY,:ROWAPBERRY,:ROSELIBERRY,:KEEBERRY,:MARANGABERRY,:REDAPRICORN,:BLUEAPRICORN,:BLACKAPRICORN,:YELLOWAPRICORN,:GREENAPRICORN,:WHITEAPRICORN,:PINKAPRICORN,:ACORN,:REVIVALHERB,:ARGOSTBERRY,:PURPLEAPRICORN]
  chanceBerry=rand(6)  #Encounters 2/10 of the time
  if  chanceBerry==0 ||  chanceBerry==2 ||  chanceBerry==3 || chanceBerry==5
    vbberry = vbberries[rand(80)]
    pbReceiveItem(vbberry)
    pbMessage("Take that berry! You deserve it!")
  elsif  chanceBerry==1 ||  chanceBerry==4
    pbMessage("I dont have anything to give you today, I'm sorry!")
  end
end
#==============================================================================#
#==============================================================================#

def pbDungeonMain
  vbItems=[:SOFTSAND,:SOFTSAND,:SOFTSAND,:SOFTSAND,:STONE,
  :STONE,:STONE,:STONE,:HARDSTONE,:HARDSTONE,
  :CHARCOAL,:BIGROOT,:LIGHTCLAY,:BLACKSLUDGE,:DAMPROCK,
  :SHOALSHELL,:SHOALSALT,:ORANMASH,:BIGPEARL,:KINGSROCK,
  :DEEPSEATOOTH,:DEEPSEASCALE,:IRONORE,:STARDUST,:STARDUST,
  :STARPIECE,:REDAPRICORN,:SITRUSBERRY,:ORANBERRY,:WOOL,
  :CHARCOAL,:CHARCOAL,:APPLE,:ACORN,:BAIT,:WONDERORB]
  chanceCollect=rand(100)  #Encounters 2/10 of the time
  if  chanceCollect > 5
    vbItem = vbItems[rand(36)]
    pbItemBall(vbItem)
  else 
    pbMessage("It was a Voltorb!.")
    WildBattle.start(:VOLTORB, rand(2)+pbBalancedLevel($player.party))
  end
end
	   
def pbCollectionMain
  vbItems=[:SOFTSAND,:SOFTSAND,:SOFTSAND,:SOFTSAND,:STONE,:STONE,:STONE,:STONE,:CHARCOAL,:BIGROOT,:LIGHTCLAY,:BLACKSLUDGE,:DAMPROCK,:SHOALSHELL,:SHOALSALT,:PEARL,:BIGPEARL,:KINGSROCK,:DEEPSEATOOTH,:DEEPSEASCALE,:IRONORE,:CLEVERFEATHER,:SWIFTFEATHER,:SWIFTFEATHER,:SWIFTFEATHER]
  chanceCollect=rand(6)  #Encounters 2/10 of the time
  if  chanceCollect==0 ||  chanceCollect==2 ||  chanceCollect==3 || chanceCollect==5
    vbItem = vbItems[rand(25)]
    pbItemBall(vbItem)
  elsif  chanceCollect==1 ||  chanceCollect==4
    pbMessage("You didn't find anything.")
  end
end
#==============================================================================#
#==============================================================================#
                                                                                
def pbMiningMain
  vbItems=[:SOFTSAND,:SOFTSAND,:STONE,:STONE,:STONE,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:HARDSTONE,:HARDSTONE,:HARDSTONE,:STONE,:STONE,:STONE,:STONE,:CHARCOAL,:CHARCOAL,:CHARCOAL,:CHARCOAL,:CHARCOAL,:LIGHTCLAY,:DAMPROCK,:IRONORE,:IRONORE,:IRONORE,:COPPERORE,:COPPERORE,:SILVERORE,:GOLDORE]
  chanceCollect=rand(6)  #Encounters 2/10 of the time
  if  chanceCollect==0 ||  chanceCollect==2 ||  chanceCollect==3 || chanceCollect==5
    vbItem = vbItems[rand(33)]
    pbItemBall(vbItem)
  elsif  chanceCollect==1 ||  chanceCollect==4
    pbMessage("You didn't find anything.")
  end
end

def pbMiningMain2
  vbItems=[:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK]
  chanceCollect=rand(6)  #Encounters 2/10 of the time
  if  chanceCollect==0 ||  chanceCollect==2 ||  chanceCollect==3 || chanceCollect==5  ||  chanceCollect==4
    vbItem = vbItems[rand(6)]
    pbItemBall(vbItem)
  elsif  chanceCollect==1
    pbMessage("It shattered, leaving nothing behind.")
  end
end
#==============================================================================#
#==============================================================================#
                                                                             
def pbMeteorMain
  vbItems=[:COMETSHARD,:COMETSHARD,:COMETSHARD,:COMETSHARD,:COMETSHARD,:SPEEDCOMET,:DEFENDCOMET,:BALANCEDCOMET,:BALANCEDCOMET,:BALANCEDCOMET,:ATKCOMET,:STARPIECE,:STARPIECE,:STARPIECE,:MOONSTONE,:MOONSTONE,:NEVERMELTICE,:NEVERMELTICE,:NEVERMELTICE,:LIFEORB,:LIFEORB,:TM13,:SUNSTONE,:COMETSHARD]
  chanceCollect=rand(6)  #Encounters 2/10 of the time
  if  chanceCollect==0 ||  chanceCollect==2 ||  chanceCollect==3 || chanceCollect==5
    pbMessage("You found something!!!")
    vbItem = vbItems[rand(24)]
	if rand(21)==5
	pbItemBall(:IRON2,(rand(200)))
	end
    pbItemBall(vbItem,(rand(2)))
  elsif  chanceCollect==1 ||  chanceCollect==4
    pbMessage("You found something!!!")
    pbMessage("A Pokemon!!!! and it attacks!")
    pbEncounter(EncounterTypes::Comet)
  end
end
