#===============================================================================
# * DrDoom Elemental ItemHandler
#===============================================================================

ItemHandlers::UseFromBag.add(:ELECTRICCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:ELECTRICCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:FIRECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:FIRECHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:WATERCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:WATERCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:GRASSCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:GRASSCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:NORMALCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:NORMALCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:FIGHTINGCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:FIGHTINGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:FLYINGCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:FLYINGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:POISONCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:POISONCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:GROUNDCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:GROUNDCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:ROCKCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:ROCKCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:BUGCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:BUGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:STEELCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:STEELCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:PSYCHICCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:PSYCHICCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:ICECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:ICECHARM)
  end
  next 1
})


ItemHandlers::UseFromBag.add(:DRAGONCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:DRAGONCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:DARKCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:DARKCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:FAIRYCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:SPIRITFAIRYCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:GHOSTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:GHOSTCHARM)
  end
  next 1
})