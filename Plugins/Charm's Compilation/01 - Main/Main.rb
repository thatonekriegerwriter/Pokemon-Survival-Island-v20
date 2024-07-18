#===============================================================================
# * Main
#===============================================================================

class Player
  attr_accessor :charmsActive
  attr_accessor :charmlist
  attr_accessor :elementCharmlist
  attr_accessor :last_wish_time

  def initializeCharms
    @last_wish_time ||= 0
    @charmlist = [
        :BALANCECHARM, :BERRYCHARM, :CATCHINGCHARM, :CLOVERCHARM, :COINCHARM, :CORRUPTCHARM, :DISABLECHARM,
        :EASYCHARM, :EFFORTCHARM, :EXPALLCHARM, :EXPCHARM, :FRUGALCHARM, :GENECHARM, :GOLDCHARM, :HARDCHARM,
        :HEALINGCHARM, :HEARTCHARM, :IVCHARM, :KEYCHARM, :LURECHARM, :MERCYCHARM, :MININGCHARM, :OVALCHARM,
        :PROMOCHARM, :PURIFYCHARM, :SHINYCHARM, :SLOTSCHARM, :SMARTCHARM, :SPINNINGCHARM, :SPIRITCHARM,
        :STABCHARM, :STEPCHARM, :TWINCHARM, :VIRALCHARM, :WISHINGCHARM
      ]
    @elementCharmList = [
        :BUGCHARM, :DARKCHARM, :DRAGONCHARM, :ELECTRICCHARM, :FAIRYCHARM, :FIGHTINGCHARM,
        :FIRECHARM, :FLYINGCHARM, :GHOSTCHARM, :GRASSCHARM, :GROUNDCHARM, :ICECHARM,
        :NORMALCHARM, :PSYCHICCHARM, :POISONCHARM, :ROCKCHARM, :STEELCHARM, :WATERCHARM
      ]
    @charmsActive = {
    #Default Charms
      :CATCHINGCHARM    => false,
      :EXPCHARM         => false,
      :OVALCHARM        => false,
      :SHINYCHARM       => false,
    #Lin Charms
      :CORRUPTCHARM	=> false,
      :EASYCHARM	=> false,
      :EFFORTCHARM	=> false,
      :FRIENDSHIPCHARM	=> false,
      :GENECHARM	=> false,
      :HARDCHARM	=> false,
      :HERITAGECHARM	=> false,
      :HIDDENCHARM	=> false,
      :PURECHARM	=> false,
      :STEPCHARM	=> false,
    #Tech Charms
      :BERRYCHARM       => false,
      :SPINNINGCHARM    => false,
    #DrDoom Charms
      :BALANCECHARM     => false,
      :CLOVERCHARM      => false,
      #:COLORCHARM       => false,
      :COINCHARM        => false,
      :DISABLECHARM     => false,
      :EXPALLCHARM	=> false,
      :FRUGALCHARM      => false,
      :GOLDCHARM        => false,
      :HEARTCHARM       => false,
      :HEALINGCHARM     => false,
      #:ITEMFINDERCHARM  => false,
      :IVCHARM          => false,
      :KEYCHARM         => false,
      :LINKCHARM	=> false,
      :LURECHARM        => false,
      :MERCYCHARM       => false,
      :MININGCHARM      => false,
      :PROMOCHARM       => false,
      :SLOTSCHARM       => false,
      :SMARTCHARM       => false,
      :SPIRITCHARM      => false,
      :STABCHARM	=> false,
      :TWINCHARM        => false,
      :VIRALCHARM       => false,
      :WISHINGCHARM     => false,
    #DrDoom Elemental Charms
      :BUGCHARM         => false,
      :DARKCHARM        => false,
      :DRAGONCHARM      => false,
      :ELECTRICCHARM    => false,
      :FAIRYCHARM       => false,
      :FIGHTINGCHARM    => false,
      :FIRECHARM        => false,
      :FLYINGCHARM      => false,
      :GHOSTCHARM       => false,
      :GRASSCHARM       => false,
      :GROUNDCHARM      => false,
      :ICECHARM         => false,
      :NORMALCHARM      => false,
      :PSYCHICCHARM     => false,
      :POISONCHARM      => false,
      :ROCKCHARM        => false,
      :STEELCHARM       => false,
      :WATERCHARM       => false
    }
  end
end

module GameData
  class Item
    def is_charm?
      charms_ids = $player.charmlist
      charm = charm_ids.include?(self.id.to_sym)
      return charm
    end

    def is_echarm?
      echarm_ids = $player.elementCharmList
      echarm = echarm_ids.include?(self.id.to_sym)
      return echarm
    end
  end
end

def activeCharm?(charm)
  if CharmConfig::ACTIVE_CHARM
    $player.initializeCharms if !$player.charmsActive
    return $player.charmsActive[charm]
  else
    return $bag.has?(charm)
  end
end

def pbToggleCharm(charm)
  $player.initializeCharms if !$player.charmsActive
  charmData = GameData::Item.get(charm)
  if $player.charmsActive[charm]
    $player.charmsActive[charm] = false
    pbMessage(_INTL("The {1} was turned off.", charmData.name))
  else
    $player.charmsActive[charm] = true
    pbMessage(_INTL("The {1} was turned on.", charmData.name))
  end
  pbCheckCharm(charm)
end

def pbCheckCharm(charm)
  typeCharms = $player.elementCharmList
  activeElem = false
  case charm
  when :CORRUPTCHARM
    pbMessage(_INTL("The Pure Charm was turned off.")) if $player.charmsActive[:PURECHARM]
    $player.charmsActive[:PURECHARM] = false
  when :EASYCHARM
    pbMessage(_INTL("The Hard Charm was turned off.")) if $player.charmsActive[:HARDCHARM]
    $player.charmsActive[:HARDCHARM] = false
  when :HARDCHARM
    pbMessage(_INTL("The Easy Charm was turned off.")) if $player.charmsActive[:EASYCHARM]
    $player.charmsActive[:EASYCHARM] = false
  when :HEARTCHARM
    pbMessage(_INTL("The Mercy Charm was turned off.")) if $player.charmsActive[:MERCYCHARM]
    $player.charmsActive[:MERCYCHARM] = false
  when :MERCYCHARM
    pbMessage(_INTL("The Heart Charm was turned off.")) if $player.charmsActive[:HEARTCHARM]
    $player.charmsActive[:HEARTCHARM] = false
  when :PURECHARM
    pbMessage(_INTL("The Corrupt Charm was turned off.")) if $player.charmsActive[:CORRUPTCHARM]
    $player.charmsActive[:CORRUPTCHARM] = false
  when :SLOTSCHARM
    pbMessage(_INTL("The Spinning Charm was turned off.")) if $player.charmsActive[:SPINNINGCHARM]
    $player.charmsActive[:SPINNINGCHARM] = false
  when :SPINNINGCHARM
    pbMessage(_INTL("The Slots Charm was turned off.")) if $player.charmsActive[:SLOTSCHARM]
    $player.charmsActive[:SLOTSCHARM] = false
  when :BALANCECHARM
    typeCharms.each do |type_charm|
      activeElem = true if $player.charmsActive[type_charm]
      $player.charmsActive[type_charm] = false
    end
    pbMessage(_INTL("The elemental charms were turned off.")) if activeElem
  when typeCharms.include?(charm)
    pbMessage(_INTL("The Balance Charm was turned off.")) if $player.charmsActive[:BALANCECHARM]
    $player.charmsActive[:BALANCECHARM] = false
    typeCharms.each do |type_charm|
      next if type_charm == charm
      activeElem = true if $player.charmsActive[type_charm]
      $player.charmsActive[type_charm] = false
    end
    pbMessage(_INTL("Other elemental charms were turned off.")) if activeElem
  end
end