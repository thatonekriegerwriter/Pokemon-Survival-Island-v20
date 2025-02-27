#TODO: Get revisiting tip cards to be functional
def pbRevisitTipCards
    return Console.echo_warn "No available tips to show" if !$stats.tip_cards_seen || $stats.tip_cards_seen.empty?
    arr = []
    $stats.tip_cards_seen.each { |tip| arr.push(tip) unless $PokemonGlobal.tipcards[tip] && 
        $PokemonGlobal.tipcards[tip][:HideRevisit]}
    pbShowTipCard(*arr)
end

def pbRevisitTipCardsGrouped(*groups, continuous: false)
    groups = Settings::TIP_CARDS_GROUPS.keys if !groups || groups.empty?
    sections = []
    groups.each_with_index do |group, i|
        group = Settings::TIP_CARDS_GROUPS[group]
        next unless group
        group[:Tips].each do |tip|
            next if !$PokemonGlobal.tipcards[tip] || $PokemonGlobal.tipcards[tip][:HideRevisit] || 
                !pbSeenTipCard?(tip)
            sections.push(groups[i])
            break
        end
    end
    if sections.length > 1 || (sections.length == 1 && Settings::TIP_CARDS_SINGLE_GROUP_SHOW_HEADER)
        scene = TipCardGroups_Scene.new(sections, true, continuous)
        screen = TipCardGroups_Screen.new(scene)
        screen.pbStartScreen
    elsif sections[0]
        tips = Settings::TIP_CARDS_GROUPS[sections[0]][:Tips]
        arr = []
        tips.each do |tip| 
            next if !$PokemonGlobal.tipcards[tip] || $PokemonGlobal.tipcards[tip][:HideRevisit] || 
            !pbSeenTipCard?(tip)
            arr.push(tip)
        end
        pbShowTipCard(*arr)
    else
        Console.echo_warn "No available tips to show"
    end
end

def getTipCardGroups
    return [] if !$stats.tip_cards_seen || $stats.tip_cards_seen.empty?
    groups = Settings::TIP_CARDS_GROUPS.keys if !groups || groups.empty?
    sections = []
    groups.each_with_index do |group, i|
        group = Settings::TIP_CARDS_GROUPS[group]
        next unless group
        group[:Tips].each do |tip|
            next if !$PokemonGlobal.tipcards[tip] || $PokemonGlobal.tipcards[tip][:HideRevisit] || 
                !pbSeenTipCard?(tip)
            sections.push(groups[i])
            break
        end
    end

    return sections
end

def getTipCard(card)
    return [] if !$stats.tip_cards_seen || $stats.tip_cards_seen.empty?
    arr = []
    $stats.tip_cards_seen.each { |tip_id| arr.push(tip_id) if card==tip_id }
    return arr
end
def pbTipIsInAGroup(thetip)
    groups = Settings::TIP_CARDS_GROUPS.keys if !groups || groups.empty?

    groups.each_with_index do |group, i|
        group = Settings::TIP_CARDS_GROUPS[group]
        next unless group
        return group[:Tips].include?(thetip)
    end
end

def isthisAGroup(item)
   group = Settings::TIP_CARDS_GROUPS[item]
   return true if group
   return false
end


def getAllTips
  tips = []
  getTipCardGroups.each do |group|
  tips << group
  end
  $PokemonGlobal.tipcards.each do |tip|
   next !$stats.tip_cards_seen.include?(tip)
   next pbTipIsInAGroup(tip)
   tips << tip
		
  end

  return tips
end


def pbSetTipCardSeen(tip_id, seen = true)
    $stats.tip_cards_seen ||= []
    if seen
        $stats.tip_cards_seen.push(tip_id) unless $stats.tip_cards_seen.include?(tip_id)
    else
        $stats.tip_cards_seen.delete(tip_id) if $stats.tip_cards_seen.include?(tip_id)
    end
end

def pbSeenTipCard?(tip_id)
    return false if !$stats.tip_cards_seen || $stats.tip_cards_seen.empty?
    return $stats.tip_cards_seen.include?(tip_id)
end

#===============================================================================
# GameStats
#===============================================================================

class GameStats
    attr_accessor :tip_cards_seen

    alias tdw_tip_cards_stats_init initialize
    def initialize
        tdw_tip_cards_stats_init
        @tip_cards_seen = []
    end
end

#===============================================================================
# Item
#===============================================================================

ItemHandlers::UseFromBag.add(:ADVENTUREGUIDE, proc { |item|
    pbRevisitTipCardsGrouped
    next 1
})

ItemHandlers::UseInField.add(:ADVENTUREGUIDE, proc { |item|
    pbRevisitTipCardsGrouped
    next true
})