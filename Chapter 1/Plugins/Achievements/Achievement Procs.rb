################################################################################
############# PLACE THIS IN A NEW SCRIPT SECTION RIGHT ABOVE MAIN! #############
################################################################################

###################################
############# REQUIRED ############
###################################
EventHandlers.add(:on_map_or_spriteset_change, :MESSAGEQUEUE,
  proc {
  if !$achievementmessagequeue.nil?
    $achievementmessagequeue.each_with_index{|m,i|
      $achievementmessagequeue.delete_at(i)
      Kernel.pbMessage(m)
    }
  end
})

###################################
########### END REQUIRED ##########
###################################
EventHandlers.add(:on_player_step_taken_can_transfer, :STEPS,
  proc {
  if !$PokemonGlobal.stepcount.nil?
    Achievements.setProgress("STEPS",$PokemonGlobal.stepcount)
  end
})


