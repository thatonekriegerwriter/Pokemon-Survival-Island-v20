#===============================================================================
# * DrDoom ItemHandler
#===============================================================================

ItemHandlers::UseFromBag.add(:BALANCECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:CATCHINGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:COLORCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:COLORCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:CLOVERCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:CLOVERCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:COINCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:COINCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:DISABLECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:DISABLECHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:FRUGALCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:FRUGALCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:GOLDCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:GOLDCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:HEALINGCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:HEALINGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:HEARTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:HEARTCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:IVCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:IVCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:KEYCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:KEYCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:LURECHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:LURECHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:MERCYCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:MININGCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:PROMOCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:PROMOCHARM)
  end
  next 1
})


ItemHandlers::UseFromBag.add(:SLOTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:SLOTCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:SMARTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:SMARTCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:SPIRITCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:SPIRITCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:STABCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:STABCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:TWINCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:TWINCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:VIRALCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(:VIRALCHARM)
  end
  next 1
})

ItemHandlers::UseFromBag.add(:WISHINGCHARM, proc { |item|
  pbWishingStar
  next 1
})