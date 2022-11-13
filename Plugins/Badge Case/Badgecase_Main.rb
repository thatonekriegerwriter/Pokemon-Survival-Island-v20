#===============================================================================
# Badgecase UI
# Are you tired of the old fashion badge case inside your trainer card? This plugin is for you!
#===============================================================================
# Badgecase_Main
# Main script for the plugin's backend
#===============================================================================
# Class to define a badge with all the data we want
#===============================================================================
class Badge
  attr_accessor :id
  attr_accessor :name
  attr_accessor :type
  attr_accessor :leadername
  attr_accessor :leadersprite
  attr_accessor :location
  attr_accessor :acepokemon

  def initialize(id,name,type,leadername,leadersprite,location,acepokemon)
    self.id           = id
    self.name         = name
    self.type         = type
    self.leadername   = leadername
    self.leadersprite = leadersprite
    self.location     = location
    self.acepokemon   = acepokemon
  end
end

class Badgecase
  attr_accessor :obtained_badges
  attr_accessor :unobtained_badges

  def initialize
    @obtained_badges = []
    @unobtained_badges = []
  end

  def addBadge(badge)
    for i in 0...@unobtained_badges.length
      if @unobtained_badges[i].id == badge.id
        return
      end
    end
    for i in 0...@obtained_badges.length
      if @obtained_badges[i].id == badge.id
        return
      end
    end
    @unobtained_badges.push(badge)
  end

  def getBadge(badge)
    for i in 0...@obtained_badges.length
      if @obtained_badges[i].id == badge
        return
      end
    end
    for i in 0...@unobtained_badges.length
      if @unobtained_badges[i].id == badge
        @obtained_badges.push(@unobtained_badges[i])
        @unobtained_badges.delete_at(i)
        break
      end
    end
  end

  def badge_count
    return @obtained_badges.length
  end

  def badge_max
    return (@obtained_badges.length + @unobtained_badges.length)
  end
end

#===============================================================================
# Adding badge data to our game storage
#===============================================================================
class PokemonGlobalMetadata

  def badges
    @badges = Badgecase.new if !@badges
    return @badges
  end
    
  alias badges_init initialize
  def initialize
    badges_init
    @badges = Badgecase.new
    addAllBadge
  end
end

#===============================================================================
# Changing and adding functions for our $player
# Added the function $player.badge_max (get the maximum number the player can obtain)
#===============================================================================
class Player < Trainer

  def badge_count
    return 0 if !$PokemonGlobal
    return $PokemonGlobal.badges.badge_count
  end

  def badge_max
    return 0 if !$PokemonGlobal
    return $PokemonGlobal.badges.badge_max
  end
end

#===============================================================================
# Two helping functions, you should not use them
# addBadge(badge)- Adding a badge data to our badgelist
# getBadge(badge)- Moving a badge from the unobtained list to the obtained list
#===============================================================================
def addBadge(badge)
  return if !$PokemonGlobal
  newBadge = Badge.new(badge[:ID],badge[:NAME],badge[:TYPE],badge[:LEADERNAME],badge[:LEADERSPRITE],badge[:LOCATION],badge[:ACEPOKEMON])
  $PokemonGlobal.badges.addBadge(newBadge)
end

def getBadge(badge)
  return if !$PokemonGlobal
  $PokemonGlobal.badges.getBadge(badge)
end

def addAllBadge
  for i in 0...Badges::BADGES.length
    addBadge(Badges::BADGES[i])
  end
end