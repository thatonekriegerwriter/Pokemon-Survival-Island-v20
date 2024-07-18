#===============================================================================
# * Lin ItemHandler
#===============================================================================

ItemHandlers::UseFromBag.add(:GENECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:GENECHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:EFFORTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:EFFORTCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:HIDDENCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:HIDDENCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:HERITAGECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:HERITAGECHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:STEPCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:STEPCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:FRIENDSHIPCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:FRIENDSHIPCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:PURECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:PURECHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:CORRUPTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:CORRUPTCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:EASYCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:EASYCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:HARDCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:HARDCHARM)
  end
  next 1
})