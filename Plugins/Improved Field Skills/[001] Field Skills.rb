#===============================================================================
# Field Skill species data.
#===============================================================================
module GameData
  class Species
    attr_accessor :field_skills
    
    alias fieldskill_initialize initialize
    def initialize(hash)
      fieldskill_initialize(hash)
      @field_skills = []
    end
    
    def has_skill?(skill)
      skill = skill.upcase.to_sym if skill.is_a?(String)
      return @field_skills.any? { |s| s == skill }
    end
  end
end


#===============================================================================
# Miscellaneous checks for Field Skills.
#===============================================================================
def pbBadgeFromSkill(skill)
  case skill
  when :CUT       then badge = 0
  when :FLY       then badge = 0
  when :DIVE      then badge = 0
  when :FLASH     then badge = 0
  when :ROCKSMASH then badge = 0
  when :STRENGTH  then badge = 0
  when :SURF      then badge = 0
  when :WATERFALL then badge = 0
  else badge = -1
  end
  return badge
end

class Pokemon
  def has_field_skill?
    return false if egg?
    # Checks for HM Skills.
    Settings::HM_SKILLS.each do |skill| 
      next if !GameData::Move.exists?(skill)
      next if !HiddenMoveHandlers.hasHandler(skill)
      if Settings::HM_SKILLS_REQUIRE_BADGE
        badge = pbBadgeFromSkill(skill)
        next if badge > 0 && !pbCheckHiddenMoveBadge(badge, false)
      end
      return true if self.species_data.has_skill?(skill) || self.hasMove?(skill)
    end
    # Checks for Misc. Skills.
    Settings::MISC_SKILLS.each do |skill|
      next if !GameData::Move.exists?(skill)
      next if !HiddenMoveHandlers.hasHandler(skill)
      next if Settings::MISC_SKILLS_REQUIRE_MOVE && !self.hasMove?(skill)
      return true if self.species_data.has_skill?(skill) || self.hasMove?(skill)
    end
    # Checks for Heal Skills.
    Settings::HEAL_SKILLS.each do |skill|
      next if !GameData::Move.exists?(skill)
      next if Settings::HEAL_SKILLS_REQUIRE_MOVE && !self.hasMove?(skill)
      return true if self.species_data.has_skill?(skill) || self.hasMove?(skill)
    end
    # Checks for other skills
    Settings::CUSTOM_SKILLS.each do |skill|
      next if !GameData::Move.exists?(skill)
      next if Settings::CUSTOM_SKILLS_REQUIRE_MOVE && !self.hasMove?(skill)
      return true if self.species_data.has_skill?(skill) || self.hasMove?(skill)
    end
    return false
  end
end

class Trainer
  def get_pokemon_with_move(move)
    pokemon_party.each { |pkmn| return pkmn if pkmn.hasMove?(move) || pkmn.species_data.has_skill?(move) }
    return nil
  end
  
  def get_pokemon_with_skill(skill)
    pokemon_party.each { |pkmn| return pkmn if pkmn.species_data.has_skill?(skill) }
    return nil
  end
end
  

#===============================================================================
# Field Skill menu handler.
#===============================================================================
MenuHandlers.add(:party_menu, :field_skill, {
  "name"      => _INTL("Skills"),
  "order"     => 21,
  "condition" => proc { |screen, party, party_idx| next party[party_idx].has_field_skill? },
  "effect"    => proc { |screen, party, party_idx|
    ret = nil
    pkmn = party[party_idx]
    command = 0
    loop do
      skills = []
      commands = []
      #-------------------------------------------------------------------------
      # Adds HM Skills.
      #-------------------------------------------------------------------------
      Settings::HM_SKILLS.each do |skill|
        next if !GameData::Move.exists?(skill)
        next if !HiddenMoveHandlers.hasHandler(skill)
        next if !pkmn.species_data.has_skill?(skill) && !pkmn.hasMove?(skill)
        badge = pbBadgeFromSkill(skill)
        next if Settings::HM_SKILLS_REQUIRE_BADGE && badge > 0 && !pbCheckHiddenMoveBadge(badge, false)
        color = (pbCanUseHiddenMove?(pkmn, skill, false) && pbCheckHiddenMoveBadge(badge, false)) ? 1 : 4
        commands.push([GameData::Move.get(skill).name, color])
        skills.push(skill)
      end
      #-------------------------------------------------------------------------
      # Adds Misc. Skills.
      #-------------------------------------------------------------------------
      Settings::MISC_SKILLS.each do |skill|
        next if !GameData::Move.exists?(skill)
        next if !HiddenMoveHandlers.hasHandler(skill)
        if Settings::MISC_SKILLS_REQUIRE_MOVE
          next if !pkmn.hasMove?(skill)
        else
          next if !pkmn.species_data.has_skill?(skill) && !pkmn.hasMove?(skill)
        end
        color = (pbCanUseHiddenMove?(pkmn, skill, false)) ? 1 : 4
        commands.push([GameData::Move.get(skill).name, color])
        skills.push(skill)
      end
      #-------------------------------------------------------------------------
      # Adds Heal Skills.
      #-------------------------------------------------------------------------
      Settings::HEAL_SKILLS.each do |skill|
        next if !GameData::Move.exists?(skill)
        if Settings::HEAL_SKILLS_REQUIRE_MOVE
          next if !pkmn.hasMove?(skill)
        else
          next if !pkmn.species_data.has_skill?(skill) && !pkmn.hasMove?(skill)
        end
        color = (pkmn.hp >= [(pkmn.totalhp / 5).floor, 1].max) ? 1 : 4
        commands.push([GameData::Move.get(skill).name, color])
        skills.push(skill)
      end
      #-------------------------------------------------------------------------
      # Adds Other Skills.
      #-------------------------------------------------------------------------
      Settings::CUSTOM_SKILLS.each do |skill|
        next if !GameData::Move.exists?(skill)
        if Settings::CUSTOM_SKILLS_REQUIRE_MOVE
          next if !pkmn.hasMove?(skill)
        else
          next if !pkmn.species_data.has_skill?(skill) && !pkmn.hasMove?(skill)
        end
        color = 1
        pkmn.moves.each do |move|
          next if move.id != skill
          color = 4 if move.pp <= 0
        end
        commands.push([GameData::Move.get(skill).name, color])
        skills.push(skill)
      end
      break if skills.empty?
      commands.push("Cancel")
      command = screen.scene.pbShowCommands(_INTL("Do what with {1}?", pkmn.name), commands, command)
      break if command < 0 || command >= commands.length - 1
      movename = commands[command]
      #-------------------------------------------------------------------------
      # Performs Custom Skill effects.
      #-------------------------------------------------------------------------
      if Settings::CUSTOM_SKILLS.include?(skills[command])
        idxMove = 0
        if Settings::CUSTOM_SKILLS_REQUIRE_MOVE
          pkmn.moves.each_with_index { |m, i| idxMove = i if m.id == skills[command] }
          if pkmn.moves[idxMove].pp <= 0
            screen.scene.pbDisplay(_INTL("Not enough PP..."))
            next
          end
        end
        case skills[command]
        #-----------------------------------------------------------------------
        # ***CUSTOM MOVE SECTION***
        #-----------------------------------------------------------------------
        when :RECOVER
          usedMove = pbRecoverPartySkill(pkmn, movename, screen, party_idx)
        when :LIFEDEW, :SYNTHESIS
          usedMove = pbLifeDewPartySkill(pkmn, movename, screen, party, party_idx)
        when :HEALBELL, :AROMATHERAPY
          usedMove = pbStatusPartySkill(pkmn, movename, screen, party, party_idx)
        when :FUTURESIGHT
          usedMove = pbFutureSightPartySkill(pkmn, movename, screen, party, party_idx, idxMove)
        #-----------------------------------------------------------------------
        else
          usedMove = 0
          screen.scene.pbDisplay(_INTL("This move can't be used right now."))
          next
        end
        if Settings::CUSTOM_SKILLS_REQUIRE_MOVE
          move = pkmn.moves[idxMove]
          if usedMove > 0 && move.id == skills[command]
            reduce = [usedMove, move.pp].min
            move.pp -= reduce
            case move.pp
            when 0 then text = "ran out of PP..."
            else        text = "had its PP reduced by #{reduce}!"
            end
            screen.scene.pbDisplay(_INTL("{1}'s {2} {3}", pkmn.name, move.name, text))
          end
        end
      #-------------------------------------------------------------------------
      # Performs Heal Skill effects.
      #-------------------------------------------------------------------------
      elsif Settings::HEAL_SKILLS.include?(skills[command])
        amt = [(pkmn.totalhp / 5).floor, 1].max
        if pkmn.hp <= amt
          screen.scene.pbDisplay(_INTL("Not enough HP..."))
          next
        else
          pbHealPartySkill(pkmn, movename, screen, party, party_idx)
        end
      #-------------------------------------------------------------------------
      # Performs HM and miscellaneous field skill effects.
      #-------------------------------------------------------------------------
      else
        if pbCanUseHiddenMove?(pkmn, skills[command])
          if pbConfirmUseHiddenMove(pkmn, skills[command])
            screen.scene.pbEndScene
            if skills[command] == :FLY
              new_scene = PokemonRegionMap_Scene.new(-1, false)
              new_screen = PokemonRegionMapScreen.new(new_scene)
              ret = new_screen.pbStartFlyScreen
              if ret
                $game_temp.fly_destination = ret
                ret = [pkmn, skills[command]]
                break
              end
              screen.scene.pbStartScene(
                party, (party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
              )
              break
            end
            ret = [pkmn, skills[command]]
          end
          break if ret
        end
      end
    end
    next ret
  }
})


#===============================================================================
# Ready Menu compatibility.
#===============================================================================
def pbUseKeyItem
  real_moves = []
  # Adds available HM Skills.
  Settings::HM_SKILLS.each do |skill|
    next if !GameData::Move.exists?(skill)
    next if !HiddenMoveHandlers.hasHandler(skill)
    $player.party.each_with_index do |pkmn, i|
      next if pkmn.egg?
      next if !pkmn.species_data.has_skill?(skill) && !pkmn.hasMove?(skill)
      if Settings::HM_SKILLS_REQUIRE_BADGE
        badge = pbBadgeFromSkill(skill)
        next if badge > 0 && !pbCheckHiddenMoveBadge(badge, false)
      end
      real_moves.push([skill, i]) if pbCanUseHiddenMove?(pkmn, skill, false)
      break
    end
  end
  # Adds available Misc. Skills.
  Settings::MISC_SKILLS.each do |skill|
    next if !GameData::Move.exists?(skill)
    next if !HiddenMoveHandlers.hasHandler(skill)
    $player.party.each_with_index do |pkmn, i|
      next if pkmn.egg?
      next if Settings::MISC_SKILLS_REQUIRE_MOVE && !pkmn.hasMove?(skill)
      next if !pkmn.species_data.has_skill?(skill) && !pkmn.hasMove?(skill)
      real_moves.push([skill, i]) if pbCanUseHiddenMove?(pkmn, skill, false)
      break
    end
  end
  real_items = []
  $bag.registered_items.each do |i|
    itm = GameData::Item.get(i).id
    real_items.push(itm) if $bag.has?(itm)
  end
  if real_items.length == 0 && real_moves.length == 0
    pbMessage(_INTL("An item in the Bag can be registered to this key for instant use."))
  else
    $game_temp.in_menu = true
    $game_map.update
    sscene = PokemonReadyMenu_Scene.new
    sscreen = PokemonReadyMenu.new(sscene)
    sscreen.pbStartReadyMenu(real_moves, real_items)
    $game_temp.in_menu = false
  end
end


#===============================================================================
# Compiler
#===============================================================================
module Compiler
  module_function
  
  PLUGIN_FILES += ["Improved Field Skills"] 
  
  #-----------------------------------------------------------------------------
  # Compiles species field skills.
  #-----------------------------------------------------------------------------
  def compile_field_skills(path = "PBS/Plugins/Improved Field Skills/field_skills.txt")
    compile_pbs_file_message_start(path)
    File.open(path, "rb") { |f|
      FileLineData.file = path
      idx = 0
      pbEachFileSectionEx(f) { |contents, species_id|
        FileLineData.setSection(species_id, "header", nil)
        id = species_id.to_sym
        next if !GameData::Species.try_get(id)
        species = GameData::Species::DATA[id]
        key = "Skills"
        if nil_or_empty?(contents[key])
          contents[key] = nil
          next
        end
        FileLineData.setSection(species_id, key, contents[key])
        value = pbGetCsvRecord(contents[key], key, [0, "*e", :Move])
        value = nil if value.is_a?(Array) && value.length == 0
        contents[key] = value
        species.field_skills = contents[key]
      }
    }
    process_pbs_file_message_end
    GameData::Species.save
  end
  
  #-----------------------------------------------------------------------------
  # Writes the field_skills.txt PBS file.
  #-----------------------------------------------------------------------------
  def write_field_skills(path = "PBS/Plugins/Improved Field Skills/field_skills.txt")
    write_pbs_file_message_start(path)
    File.open(path, "wb") { |f|
      idx = 0
      GameData::Species.each do |s|
        echo "." if idx % 50 == 0
        idx += 1
        Graphics.update if idx % 250 == 0
        skills = []
        moves = s.get_family_moves
        Settings::HM_SKILLS.each { |skill| skills.push(skill) if moves.include?(skill) }
        Settings::MISC_SKILLS.each { |skill| skills.push(skill) if moves.include?(skill) }
        Settings::HEAL_SKILLS.each { |skill| skills.push(skill) if moves.include?(skill) }
        Settings::CUSTOM_SKILLS.each { |skill| skills.push(skill) if moves.include?(skill) }
        if !skills.empty?
          f.write("\#-------------------------------\r\n")
          f.write(sprintf("[%s]\r\n", s.id))
          f.write(sprintf("Skills = %s\r\n", skills.join(",")))
        end
      end
    }
    process_pbs_file_message_end
  end
end