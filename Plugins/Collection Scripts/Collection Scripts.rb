

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
  vbberries=[:CHERIBERRY,:CHESTOBERRY,:PECHABERRY,:RAWSTBERRY,:ASPEARBERRY,:LEPPABERRY,:ORANBERRY,:PERSIMBERRY,:LUMBERRY,:SITRUSBERRY,:FIGYBERRY,:WIKIBERRY,:MAGOBERRY,:AGUAVBERRY,:IAPAPABERRY,:RAZZBERRY,:BLUKBERRY,:NANABBERRY,:WEPEARBERRY,:PINAPBERRY,:POMEGBERRY,:KELPSYBERRY,:QUALOTBERRY,:HONDEWBERRY,:GREPABERRY,:TAMATOBERRY,:CORNNBERRY,:MAGOSTBERRY,:RABUTABERRY,:NOMELBERRY,:SPELONBERRY,:PAMTREBERRY,:WATMELBERRY,:DURINBERRY,:BELUEBERRY,:OCCABERRY,:PASSHOBERRY,:WACANBERRY,:RINDOBERRY,:YACHEBERRY,:CHOPLEBERRY,:KEBIABERRY,:SHUCABERRY,:COBABERRY,:PAYAPABERRY,:TANGABERRY,:CHARTIBERRY,:KASIBBERRY,:HABANBERRY,:COLBURBERRY,:BABIRIBERRY,:CHILANBERRY,:LIECHIBERRY,:GANLONBERRY,:SALACBERRY,:PETAYABERRY,:APICOTBERRY,:LANSATBERRY,:STARFBERRY,:ENIGMABERRY,:MICLEBERRY,:CUSTAPBERRY,:JABOCABERRY,:ROWAPBERRY,:ROSELIBERRY,:KEEBERRY,:MARANGABERRY,:REDAPRICORN,:BLUEAPRICORN,:BLACKAPRICORN,:YELLOWAPRICORN,:GREENAPRICORN,:WHITEAPRICORN,:PINKAPRICORN,:ACORN,:REVIVALHERB,:ARGOSTBERRY,:PURPLEAPRICORN]
   chanceBerry=rand(6)  #Encounters 2/10 of the time
  if  chanceBerry==0 ||  chanceBerry==2 ||  chanceBerry==3 || chanceBerry==5 ||  chanceBerry==4
    vbberry = vbberries[rand(80)]
    pbItemBall(vbberry)
  else
    pbEncounter(:BerryTree)
	if rand(2)==0
     pbMessage("Other pokemon took the berries left on the tree away...")
	else
	 vbberry = vbberries[rand(80)]
     pbItemBall(vbberry)
	end
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
  
def pbCollectionMain
  vbItems = [:SOFTSAND, :SOFTSAND, :SOFTSAND, :SOFTSAND, :STONE, :STONE, :STONE, :STONE, :CHARCOAL, :BIGROOT, :LIGHTCLAY, :BLACKSLUDGE, :DAMPROCK, :SHOALSHELL, :SHOALSALT, :PEARL, :BIGPEARL, :KINGSROCK, :DEEPSEATOOTH, :DEEPSEASCALE, :IRONORE, :CLEVERFEATHER, :SWIFTFEATHER, :SWIFTFEATHER, :SWIFTFEATHER]

  rare_items = [:IRONORE,:IRONORE,:IRONORE, :PEARL, :BIGPEARL, :KINGSROCK]
  collector_bonus_items = [:ICESTONE,:ICYROCK,:SILVERORE,:GOLDORE,:COPPERORE] 
  pool = $player.real_collector?(20) ? vbItems + collector_bonus_items : vbItems

  chanceCollect = rand(6)  # Encounters 2/10 of the time
  if chanceCollect == 0 || chanceCollect == 2 || chanceCollect == 3 || chanceCollect == 5
    vbItem = pool[rand(pool.length)]
    vbItem = rare_items[rand(rare_items.length)] if $player.real_collector?(10) && !rare_items.include?(vbItem) && rand(100) < 25
    amt = $player.collector? ? 2 : 1
    pbItemBall(vbItem, amt)
  elsif chanceCollect == 1 || chanceCollect == 4
    pbMessage("You didn't find anything.")
  end
end


def pbCollectionMain2
  vbItems = [:STONE, :STONE, :STONE, :STONE, :STONE, :STONE, :STONE, :STONE, :STONE, :IRONORE, :CHARCOAL, :BIGROOT, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :LIGHTCLAY, :BLACKSLUDGE, :DAMPROCK, :SHOALSHELL, :SHOALSALT, :SHOALSALT, :SHOALSALT, :PEARL, :PEARL, :BIGPEARL, :KINGSROCK, :DEEPSEATOOTH, :DEEPSEASCALE, :IRONORE, :IRONORE,
    :HEALTHFEATHER, :MUSCLEFEATHER, :RESISTFEATHER, :GENIUSFEATHER, :SWIFTFEATHER, :PRETTYFEATHER]
  rare_items = [:IRONORE,:IRONORE,:IRONORE, :PEARL, :BIGPEARL, :KINGSROCK]
  collector_bonus_items = [:ICESTONE,:ICYROCK,:SILVERORE,:GOLDORE,:COPPERORE] 
  pool = $player.real_collector?(20) ? vbItems + collector_bonus_items : vbItems
  amt = $player.collector? ? 2 : 1

  chanceCollect = rand(2)  # Encounters 2/10 of the time
  if chanceCollect == 0
    vbItem = pool[rand(pool.length)]
    vbItem = rare_items[rand(rare_items.length)] if $player.real_collector?(10) && !rare_items.include?(vbItem) && rand(100) < 25
    pbItemBall(vbItem, amt)
  else
    pbItemBall(:SOFTSAND, amt)
  end
end


def pbFishingItem
  vbItems = [:PEARL, :BIGPEARL, :SHOALSALT, :SHOALSHELL, :DEEPSEATOOTH, :DEEPSEASCALE, :SUSHI]
  collector_bonus_items = [:PRISMSCALE, :DRAGONSCALE, :HEARTSCALE, :MYSTICWATER, :LEFTOVERS]
  rare_items = [:STARDUST, :STARPIECE, :WATERSTONE, :WATER, :LUMINOUSMOSS]
  pool = $player.real_collector?(20) ? vbItems + collector_bonus_items : vbItems
  amt = $player.collector? ? 2 : 1

  chanceCollect = rand(2)  # Encounters 2/10 of the time
  if chanceCollect == 0
    vbItem = pool[rand(pool.length)]
    vbItem = rare_items[rand(rare_items.length)] if $player.real_collector?(10) && !rare_items.include?(vbItem) && rand(100) < 25
	if vbItem == :WATER
 	 vbItem = ItemData.new(:WATER)
	 vbItem.set_bottle(ItemData.new(:GLASSBOTTLE))
	end 
    pbItemBall(vbItem, amt)
  else
    default_item = :SHOALSALT
    pbItemBall(default_item, amt)
  end
end


def pbMeteorMain
  vbItems = [:COMETSHARD, :COMETSHARD, :COMETSHARD, :COMETSHARD, :COMETSHARD, :COMETSHARD, :SPEEDCOMET, :DEFENDCOMET, :BALANCEDCOMET, :BALANCEDCOMET, :BALANCEDCOMET, :ATKCOMET, :STARPIECE, :STARPIECE, :STARPIECE, :MOONSTONE, :MOONSTONE, :NEVERMELTICE, :NEVERMELTICE, :NEVERMELTICE, :LIFEORB, :LIFEORB, :SUNSTONE, :SUNSTONE]
  rare_items = [:ATKCOMET :SPEEDCOMET, :DEFENDCOMET]   
  collector_bonus_items = [:ENIGMABERRY,:ICESTONE,:ICYROCK,:FIRESTONE] 
  pool = $player.real_collector?(20) ? vbItems + collector_bonus_items : vbItems

  chanceCollect = rand(6)  # Encounters 2/10 of the time
  if chanceCollect == 0 || chanceCollect == 2 || chanceCollect == 3 || chanceCollect == 5
    vbItem = pool[rand(pool.length)]
    vbItem = rare_items[rand(rare_items.length)] if $player.real_collector?(10) && !rare_items.include?(vbItem) && rand(100) < 25
    amt = $player.collector? ? 2 : 1
    if rand(21) == 5
      pbItemBall(:IRON2, rand(200))
    end
    pbItemBall(vbItem, amt)
  elsif chanceCollect == 1 || chanceCollect == 4
    pbMessage("It's a POKeMON! It leaps at you!")
    pbEncounter(:Comet)
  end
end

#==============================================================================#
#==============================================================================#
                                                                                
def pbMiningMain
  vbItems=[:SOFTSAND,:SOFTSAND,:STONE,:STONE,:STONE,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:TUMBLEROCK,:HARDSTONE,:HARDSTONE,:HARDSTONE,:STONE,:STONE,:STONE,:STONE,:CHARCOAL,:CHARCOAL,:CHARCOAL,:CHARCOAL,:CHARCOAL,:LIGHTCLAY,:DAMPROCK,:IRONORE,:IRONORE,:IRONORE,:COPPERORE,:COPPERORE,:SILVERORE,:GOLDORE]
  chanceCollect=rand(6)  #Encounters 2/10 of the time
  if  chanceCollect==0 ||  chanceCollect==2 ||  chanceCollect==3 || chanceCollect==5 ||  chanceCollect==4
    vbItem = vbItems[rand(33)]
    pbItemBall(vbItem)
  elsif  chanceCollect==1
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
                                                                             

GameData::EncounterType.register({
  :id             => :BerryTree,
  :type           => :none,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})