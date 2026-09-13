#===============================================================================
# BridgeAware
#-------------------------------------------------------------------------------
# A mixin for any Game_Character-based class (Game_Event, Game_PokeEvent,
# Game_PokeEventA, Game_Follower, future custom events, etc.) that gives that
# individual character its OWN bridge height, independent of
# $PokemonGlobal.bridge - which only ever reflects the real player's state.
#
# There are two situations a bridge-aware character can be in:
#
#   1. MOVING ON ITS OWN (wandering, patrolling, a move route, chasing a
#      target). Each time it settles on a new tile, it should check whether a
#      "bridge control" event is standing there - i.e. a Player Touch event
#      whose script calls pbBridgeOn/pbBridgeOff - and copy what that script
#      WOULD have set. It never actually calls pbBridgeOn/pbBridgeOff itself;
#      doing so would incorrectly change the real player's bridge state.
#
#   2. FOLLOWING A LEADER (the player, or another bridge-aware character
#      ahead of it in a chase/train). In this case it shouldn't bother doing
#      its own tile detection - it just copies the leader's height directly,
#      every tick, since the leader already resolved it.
#
# TO ADD THIS TO A NEW CLASS:
#
#   class Game_WhateverEvent < Game_Event
#     include BridgeAware
#
#     # Only needed if this class can ever follow/chase something; return
#     # the thing being followed, or nil while moving independently.
#     def bridge_leader
#       @following   # or @target, @angry_at_cur_tar, whatever this class
#                     # already uses to track who it's tracking
#     end
#   end
#
#   # Then, once per tick, from wherever the class already reacts to having
#   # moved (an update_move override, the end of a moveto, an AI tick, etc):
#   bridge_aware_update
#
# If the class already tracks its own "how elevated am I" variable under a
# different name (e.g. Game_PokeEvent's existing @height_level), don't add a
# second ivar for the same thing - alias bridge_height/bridge_height= onto
# the existing accessor instead. See the Game_PokeEvent integration example
# for exactly how.
#===============================================================================
module BridgeAware
  # Text that identifies a "bridge control" event, whether it shows up in the
  # event's own NAME (cheap to check) or in its Player Touch script text
  # (only checked when the name doesn't already give it away).
  BRIDGE_ON_MARKER  = "pbBridgeOn"
  BRIDGE_OFF_MARKER = "pbBridgeOff"

  # Player Touch trigger, per RPG::Event::Page#trigger.
  PLAYER_TOUCH_TRIGGER = 1
  # Event command codes for "Script" and its continuation lines.
  SCRIPT_CODES = [355, 655]

  # Per-map cache of event id => [list_object_id, result]. Keeping the
  # list's object_id alongside the result means the cache automatically
  # invalidates itself if the event's active page ever changes (a self
  # switch flips, a new page becomes active, etc) - nothing needs to
  # manually clear it.
  @@cache = {}

  #-----------------------------------------------------------------------------
  # Default accessor - "not on a bridge". Override/alias in the including
  # class if it already has an equivalent ivar (see notes above).
  #-----------------------------------------------------------------------------
  def bridge_height
    @bridge_height ||= 0
  end

  def bridge_height=(value)
    @bridge_height = value
  end

  #-----------------------------------------------------------------------------
  # Override in the including class: return the character currently being
  # followed/chased, or nil if this character is moving under its own
  # control. Default: never following anyone.
  #-----------------------------------------------------------------------------
  def bridge_leader
    nil
  end

  #-----------------------------------------------------------------------------
  # Call this once per tick, from wherever the including class already
  # notices it has moved (see the class-specific examples). Cheap to call
  # even when nothing changed - it only does real work when the character's
  # map/x/y is different from the last time it was called.
  #-----------------------------------------------------------------------------
  def bridge_aware_update
    pos = [self.map_id, self.x, self.y]
    return if pos == @bridge_last_pos
    @bridge_last_pos = pos
    update_bridge_height
  end

  #-----------------------------------------------------------------------------
  # Does the actual work. Usually you want bridge_aware_update above (which
  # only recalculates when the position actually changed); call this
  # directly instead if you already know exactly when a step just completed
  # (e.g. right after a moveto).
  #-----------------------------------------------------------------------------
  def update_bridge_height(map = self.map, x = self.x, y = self.y)
    leader = bridge_leader
    if leader
      self.bridge_height = leader.is_a?(Game_Player) ? $PokemonGlobal.bridge :
                            (leader.respond_to?(:bridge_height) ? leader.bridge_height : self.bridge_height)
      return
    end
    info = BridgeAware.detect_bridge_control(map, x, y)
    return if !info   # No bridge control event here - leave height as it was
    self.bridge_height = info[:on] ? info[:height] : 0
  end

  #=============================================================================
  # Module-level detection + cache. Not meant to be called directly by
  # including classes - use update_bridge_height/bridge_aware_update instead.
  #=============================================================================
  def self.detect_bridge_control(map, x, y)
    return nil if !map
    map_cache = (@@cache[map.map_id] ||= {})
    map.events.each_value do |event|
      next if !event.at_coordinate?(x, y)
      list_id = event.list.object_id
      cached = map_cache[event.id]
      return cached[1] if cached && cached[0] == list_id
      info = scan_event(event)
      map_cache[event.id] = [list_id, info]
      return info
    end
    return nil
  end

  # Only looks at the event's CURRENTLY ACTIVE page - @trigger/@list are
  # already resolved by Game_Event#refresh based on switches/self switches,
  # so this re-checks itself for free whenever the event's page changes.
  def self.scan_event(event)
    return nil if event.trigger != PLAYER_TOUCH_TRIGGER
    # Cheap check first: the vast majority of events on a map are never
    # going to be a bridge control tile, so skip the (more expensive)
    # script-text scan for all of them by checking the event's own name.
    name = event.name || ""
    if name.include?(BRIDGE_ON_MARKER)
      return { on: true, height: extract_height(name) }
    elsif name.include?(BRIDGE_OFF_MARKER)
      return { on: false, height: 0 }
    end
    # Name didn't say - fall back to actually reading its script commands.
    text = script_text(event.list)
    if text.include?(BRIDGE_ON_MARKER)
      return { on: true, height: extract_height(text) }
    elsif text.include?(BRIDGE_OFF_MARKER)
      return { on: false, height: 0 }
    end
    return nil
  end

  def self.script_text(list)
    return "" if !list
    text = +""
    list.each do |cmd|
      next if !SCRIPT_CODES.include?(cmd.code)
      text << cmd.parameters[0] << "\n"
    end
    return text
  end

  def self.extract_height(text)
    match = text.match(/pbBridgeOn\s*\(?\s*(\d+)?/)
    return (match && match[1]) ? match[1].to_i : 2   # 2 = pbBridgeOn's own default
  end

  # Only needed if you regenerate/replace an event's pages at runtime in a
  # way that reuses the same @list object (rare) - normally the object_id
  # check above handles invalidation automatically.
  def self.clear_cache(map_id = nil)
    map_id ? @@cache.delete(map_id) : @@cache.clear
  end
end
