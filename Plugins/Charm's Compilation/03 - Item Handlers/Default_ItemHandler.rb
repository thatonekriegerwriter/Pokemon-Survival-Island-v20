#===============================================================================
# * Default ItemHandler
#===============================================================================

ItemHandlers::UseFromBag.add(:CATCHINGCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:CATCHINGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:EXPCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:EXPCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:OVALCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:OVALCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:SHINYCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:SHINYCHARM)
  end
  next 1
})