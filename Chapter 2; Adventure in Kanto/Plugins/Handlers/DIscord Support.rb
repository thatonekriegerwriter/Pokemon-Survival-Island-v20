def pbDiscord
  $DiscordRPC.large_image = "243435"
  $DiscordRPC.large_image_text = "Pokemon Survival Island"
  $DiscordRPC.party_size = $Trainer.party.length
  $DiscordRPC.party_max = 6
 if $game_map.name=="Temperate Zone" || $game_map.name=="Home Interior"
   $DiscordRPC.state = "In the Temperate Zone"
 elsif $game_map.name=="Mountain Zone"
   $DiscordRPC.state = "In the Mountain Zone"
 elsif $game_map.name=="Swamp Zone"
   $DiscordRPC.state = "In the Swamp Zone"
 else 
  $DiscordRPC.state=$game_map.name
 end
 if $game_map.name=="Temperate Base" || $game_map.name=="Mountain Base" || $game_map.name=="Swamp Base" || $game_map.name=="Blue's Cave"
   $DiscordRPC.details = "In their Base"
 elsif $game_map.name=="Home Interior"
   $DiscordRPC.details = "In their House"
 else 
   $DiscordRPC.details = "Walking Around"
 end
 if $Trainer.playerhealth == "0"
    $DiscordRPC.details = "Dying"
 end
 $DiscordRPC.update
end

# reset battle status and clear trainer name
EventHandlers.add(:on_end_battle, :iffkgein, proc {|sender,e|
  $DiscordRPC.details = "Walking around."
  $DiscordRPC.update
})