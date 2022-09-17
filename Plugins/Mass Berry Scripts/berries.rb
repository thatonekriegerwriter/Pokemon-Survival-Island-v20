################################################################################
# Mass Berry Picker Script by:
# - PurpleZaffre
# Please give credits when using this.
################################################################################

# num1 : lowest ID of all the berry tree events
# num2 : highest ID of all the berry tree events
# map  : ID of the map where the berries are (if left blank, the ID of the map
# where the player currently is will be used)
def pbMassBerryWater(num1,num2,map=nil)
  map = $game_map.map_id if map == nil
  for i in num1..num2
    berryData = $PokemonGlobal.eventvars[[map,i]]
    if berryData
      berryToReceive=berryData[1]
      if berryData[1] && berryData[4]<100
        berryData[4]=100
      end
    end
end
end