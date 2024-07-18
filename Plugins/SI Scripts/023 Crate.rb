#===============================================================================
#
#===============================================================================
class TrainerCrate
  def shouldShow?
    return true
  end

  def name
    return _INTL("{1}'s Crate",$player.name)
  end

  def access
    pbMessage(_INTL("\\se[Voltorb Flip Tile]You opened up your Crate.",$player.name))
    pbTrainerCrateMenu
  end
end

#===============================================================================
#
#===============================================================================
class SaveSystemCrate
  def shouldShow?
    return true
  end

  def name
      return _INTL("Save")
  end

  def access
        pbFadeOutIn {
          scene = PokemonSave_Scene.new
          screen = PokemonSaveScreen.new(scene)
          return true if screen.pbSaveScreen
        }
  end
end
#===============================================================================
#
#===============================================================================
class StorageSystemCrate
  def shouldShow?
    return true
  end

  def name
      return _INTL("Pokemon Crate")
  end

  def access
    pbMessage(_INTL("\\se[Voltorb Flip Tile]The Pokémon Storage System was opened."))
    command = 0
    loop do
      command = pbShowCommandsWithHelp(nil,
         [_INTL("Organize Boxes"),
         _INTL("Withdraw Pokémon"),
         _INTL("Deposit Pokémon"),
         _INTL("See ya!")],
         [_INTL("Organize the Pokémon in Boxes and in your party."),
         _INTL("Move Pokémon stored in Boxes to your party."),
         _INTL("Store Pokémon in your party in Boxes."),
         _INTL("Return to the previous menu.")],-1,command
      )
      if command>=0 && command<3
        if command==1   # Withdraw
          if $PokemonStorage.party_full?
            pbMessage(_INTL("Your party is full!"))
            next
          end
        elsif command==2   # Deposit
          count=0
          for p in $PokemonStorage.party
            count += 1 if p && !p.egg? && p.hp>0
          end
        end
        pbFadeOutIn {
          scene = PokemonStorageScene.new
          screen = PokemonStorageScreen.new(scene,$PokemonStorage)
          screen.pbStartScreen(command)
        }
      else
        break
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
module PokemonCrateList
  @@pclist = []

  def self.registerCrate(pc)
    @@pclist.push(pc)
  end

  def self.getCommandList
    commands = []
    for pc in @@pclist
      commands.push(pc.name) if pc.shouldShow?
    end
    commands.push(_INTL("Exit"))
    return commands
  end

  def self.callCommand(cmd)
    return false if cmd<0 || cmd>=@@pclist.length
    i = 0
    for pc in @@pclist
      next if !pc.shouldShow?
      if i==cmd
        pc.access
        return true
      end
      i += 1
    end
    return false
  end
end

#===============================================================================
# PC menus
#===============================================================================
def pbCrateItemStorage(storage)
  command = 0
  loop do
    command = pbShowCommandsWithHelp(nil,
       [_INTL("Withdraw Item"),
       _INTL("Deposit Item"),
       _INTL("Toss Item"),
       _INTL("Exit")],
       [_INTL("Take out items from the Crate."),
       _INTL("Store items in the Crate."),
       _INTL("Throw away items stored in the Crate."),
       _INTL("Go back to the previous menu.")],-1,command
    )
    case command
    when 0   # Withdraw Item
      if storage.empty?
        pbMessage(_INTL("There are no items."))
      else
        pbFadeOutIn {
          scene = WithdrawItemScene.new
          screen = PokemonBagScreen.new(scene,$PokemonBag)
          screen.pbWithdrawItemScreen(storage)
        }
      end
    when 1   # Deposit Item
      pbFadeOutIn {
        scene = PokemonBag_Scene.new
        screen = PokemonBagScreen.new(scene,$PokemonBag)
        screen.pbDepositItemScreen(storage)
      }
    when 2   # Toss Item
      if storage.empty?
        pbMessage(_INTL("There are no items."))
      else
        pbFadeOutIn {
          scene = TossItemScene.new
          screen = PokemonBagScreen.new(scene,$PokemonBag)
          screen.pbTossItemScreen(storage)
        }
      end
    else
      break
    end
  end
end

def pbTrainerCrateMenu(storage)
  command = 0
  loop do
    command = pbMessage(_INTL("What do you want to do?"),[
       _INTL("Item Storage"),
       _INTL("Clothes"),
       _INTL("Close Crate")
       ],-1,nil,command)
    case command
    when 0 then pbCrateItemStorage(storage)
    when 1 then pbCrateClothes
    else        break
    end
  end
end

def pbTrainerCrate(storage)
  pbMessage(_INTL("\\se[Voltorb Flip Tile]{1} opened up the Crate.",$player.name))
  pbTrainerCrateMenu(storage)
  pbSEPlay("Voltorb Flip mark")
end

def pbStorageCrateMenu
  command = 0
  loop do
    command = pbMessage(_INTL("What do you want to do?"),[
       _INTL("Pokemon Storage"),
       _INTL("Save"),
       _INTL("Close Crate")
       ],-1,nil,command)
    case command
    when 0 then pbStorageCrateStorage
    when 1 then pbPCSave
    else        break
    end
  end
end

def pbStoragePC
  pbMessage(_INTL("\\se[Voltorb Flip Tile]{1} opened up the Crate.",$player.name))
  pbStoragePCMenu
  pbSEPlay("Voltorb Flip mark")
end

def pbStorageCrateStorage
    pbMessage(_INTL("\\se[Voltorb Flip Tile]You open up your Storage Crate."))
    command = 0
    loop do
      command = pbShowCommandsWithHelp(nil,
         [_INTL("Organize Crate"),
         _INTL("Withdraw Pokémon"),
         _INTL("Deposit Pokémon"),
         _INTL("See ya!")],
         [_INTL("Organize the Pokémon in the Crate and in your party."),
         _INTL("Move Pokémon stored in the Crate to your party."),
         _INTL("Store Pokémon in your party in the Crate."),
         _INTL("Exit.")],-1,command
      )
      if command>=0 && command<3
        if command==1   # Withdraw
          if $PokemonStorage.party_full?
            pbMessage(_INTL("Your party is full!"))
            next
          end
        elsif command==2   # Deposit
          count=0
          for p in $PokemonStorage.party
            count += 1 if p && !p.egg? && p.hp>0
          end
        end
        pbFadeOutIn {
          scene = PokemonStorageScene.new
          screen = PokemonStorageScreen.new(scene,$PokemonStorage)
          screen.pbStartScreen(command)
        }
      else
        break
      end
    end
  end
  
def pbPCSave
        pbFadeOutIn {
          scene = PokemonSave_Scene.new
          screen = PokemonSaveScreen.new(scene)
          return true if screen.pbSaveScreen
        }
end
#===============================================================================
#
#===============================================================================
PokemonCrateList.registerCrate(StorageSystemCrate.new)
PokemonCrateList.registerCrate(TrainerCrate.new)
PokemonCrateList.registerCrate(SaveSystemCrate.new)
   


GameData::EncounterType.register({
  :id             => :OverworldLand,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandDay,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandNight,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandMorning,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandAfternoon,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandEvening,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCave,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveDay,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveNight,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveMorning,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveAfternoon,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveEvening,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWater,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterDay,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterNight,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterMorning,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterAfternoon,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterEvening,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldBugContest,
  :type           => :contest,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})