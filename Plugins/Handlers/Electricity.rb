EventHandlers.add(:on_player_step_taken_can_transfer, :gegegegegegegeeg,
  proc {

if $game_variables[291]>100
  $game_variables[291]=100 
end

if $game_variables[291]<0
  $game_variables[291]=0 
end


if $game_switches[467]==true
  pbMassBerryWater(2,36,155)
end
if $game_switches[468]==true
  pbMassBerryWater(2,36,147)
end
if $game_switches[469]==true
  pbMassBerryWater(2,36,148)
end
if $game_switches[470]==true
  pbMassBerryWater(2,36,149)
end
if $game_switches[471]==true
  pbMassBerryWater(2,36,150)
end
if $game_switches[472]==true
  pbMassBerryWater(2,36,151)
end
if $game_switches[473]==true
  pbMassBerryWater(2,36,152)
end
if $game_switches[474]==true
  pbMassBerryWater(2,36,153)
end
if $game_switches[475]==true
  pbMassBerryWater(2,36,154)
end

if $game_variables[291]<=100 && $game_variables[290]>0
  $game_variables[291] -= 1 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>2
  $game_variables[291] -= 3 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>4
  $game_variables[291] -= 5 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>6
  $game_variables[291] -= 7 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>8
  $game_variables[291] -= 9 if rand(100) == 5 
elsif $game_variables[291]<=100 && $game_variables[290]>10
  $game_variables[291] -= 11 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>12
  $game_variables[291] -= 13 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>14
  $game_variables[291] -= 15 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>16
  $game_variables[291] -= 17 if rand(100) == 5
elsif $game_variables[291]<=100 && $game_variables[290]>17
  $game_variables[291] -= 19 if rand(100) == 5
end

if $game_variables[291]<=-1
  $game_variables[291]=0 
end

if $game_variables[290]<=-1
  $game_variables[290]=0 
end
})

def pbChargeUp
coal=0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
coal = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_coal? })
}
if coal
$PokemonBag.pbDeleteItem(coal,1)
Kernel.pbMessage(_INTL("\\PWYou toss a {1} in the Power Station.. ",GameData::Item.get(coal).name))
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if coal == :CHARCOAL
 $game_variables[291]+=8
#full belly
elsif coal == :WOODENPLANKS
 $game_variables[291]+=3
elsif coal == :WOODENLOG
 $game_variables[291]+=5
elsif coal == :ACORN
 $game_variables[291]+=1
elsif coal == :HEATROCK
 $game_variables[291]+=25
elsif coal == :FIRESTONE
 $game_variables[291]+=25
else
pbMessage(_INTL("\\GIt got burnt up."))
end
message=_INTL("\\GDo you want to toss {1} in again?",coal)
loop do
if pbConfirmMessage(message)
$PokemonBag.pbDeleteItem(coal,1)
Kernel.pbMessage(_INTL("\\PWYou toss a {1} in the Power Station.. ",GameData::Item.get(coal).name))
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if coal == :CHARCOAL
 $game_variables[291]+=8
#full belly
elsif coal == :WOODENPLANKS
 $game_variables[291]+=3
elsif coal == :ACORN
 $game_variables[291]+=1
elsif coal == :HEATROCK
 $game_variables[291]+=25
elsif coal == :FIRESTONE
 $game_variables[291]+=15
else
pbMessage(_INTL("\\GIt got burnt up."))
end
else
 break
end
end

message=_INTL("\\GDo you want to toss something else in?")
if pbConfirmMessage(message)
 pbChargeUp
end
end
end