#===============================================================================
# * Tech ItemHandler
#===============================================================================

ItemHandlers::UseFromBag.add(:BERRYCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:BERRYCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:SPINNINGCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:SPINNINGCHARM)
  end
  next 1
})