module GameVersion
  # Required constants for game validation / update
  # Constantes requeridas para validación / actualización del juego
  POKE_UPDATER_CONFIG = {}
  POKE_UPDATER_LOCALES = {}
  ENABLED = true
  AUTO_UPDATE = false
end

def pbFillUpdaterConfig()
  trueValues = ['true', 'y', 'si', 'yes', 's']
  falseValues = ['false', 'n', 'no']
  return if !File.exists?('pu_config')
  File.foreach('pu_config'){|line|
      splittedLine = line.split('=')
      next if !splittedLine
      
      splittedLine[1] = splittedLine[1].strip
      GameVersion::POKE_UPDATER_CONFIG[splittedLine[0].strip] = splittedLine[1]
      
      if trueValues.include?(splittedLine[1].downcase) || falseValues.include?(splittedLine[1].downcase)
        GameVersion::POKE_UPDATER_CONFIG[splittedLine[0].strip] = true ? trueValues.include?(splittedLine[1].downcase) : false        
      elsif splittedLine[1].strip.match(/\d+\.\d+/)
        GameVersion::POKE_UPDATER_CONFIG[splittedLine[0].strip] = splittedLine[1].strip
      end
    }
     
    return if !File.exists?('pu_locales')
    File.foreach('pu_locales'){|line|
      splittedLine = line.split('=')
      next if !splittedLine
      
      splittedLine[1] = splittedLine[1].strip
      texts = splittedLine[1].split('|')
      GameVersion::POKE_UPDATER_LOCALES[splittedLine[0].strip] = []
      for text in texts
        GameVersion::POKE_UPDATER_LOCALES[splittedLine[0].strip].push(text)
      end
    }

end
  

def getLanguage()
  return 7 if $joiplay
  getUserDefaultLangID=Win32API.new("kernel32","GetUserDefaultUILanguage","","i") rescue nil
  ret=0
  if getUserDefaultLangID
    ret=getUserDefaultLangID.call()&0x3FF
  end
  if ret==0 # Unknown
    ret=MiniRegistry.get(MiniRegistry::HKEY_CURRENT_USER, "Control Panel\\Desktop\\ResourceLocale","",0)
    ret=MiniRegistry.get(MiniRegistry::HKEY_CURRENT_USER, "Control Panel\\International","Locale","0").to_i(16) if ret==0
    ret=ret&0x3FF
    return 0 if ret==0  # Unknown
  end
  return 1 if ret==0x11 # Japanese
  return 2 if ret==0x09 # English
  return 3 if ret==0x0C # French
  return 4 if ret==0x10 # Italian
  return 5 if ret==0x07 # German
  return 7 if ret==0x0A # Spanish
  return 8 if ret==0x12 # Korean
  return 7 # Use 'Spanish' by default
end
  
def pbGetPokeUpdaterText(textName, variable=nil)
  lang = getLanguage()
  if GameVersion::POKE_UPDATER_LOCALES && GameVersion::POKE_UPDATER_LOCALES[textName] && GameVersion::POKE_UPDATER_LOCALES[textName][lang] && GameVersion::POKE_UPDATER_LOCALES[textName][lang] != ""
    if GameVersion::POKE_UPDATER_LOCALES[textName][lang].include?('#{variable}')
      textToReturn = GameVersion::POKE_UPDATER_LOCALES[textName][lang]
      textToReturn['#{variable}'] = variable.to_s
      return textToReturn
    end
    return GameVersion::POKE_UPDATER_LOCALES[textName][lang]
  end
  case textName
    when 'NEW_VERSION'
      return "New Version available: #{variable}."
    when 'BUTTON_UPDATE'
      return "To update Survival Island, please use the button on the menu."
    when 'MANUAL_UPDATE'
      return "Please check the server for the new update."
    when 'UPDATE'
      return "The game will auto update and the updated version will start automatically, this can take a few minutes. Your saves WON'T be affected during the update."
    when 'NO_NEW_VERSION'
      return "You are on the latest version of the game."
    when 'JOIPLAY_UPDATE'
      return "Please check the server for the new update."
    when 'UPDATER_NOT_FOUND'
      return 'Error 200: The Updater was not found.'
	when 'NO_NEW_VERSION_OR_INTERNET'
	  return 'Error 201: There is not a new version available.'
	when 'NO_PASTEBIN_URL'
	  return 'Error 202: There is not a new version available.'
  when 'ASK_FOR_UPDATE'
    return 'Would you like to update the game?'
  when 'FORCE_UPDATE_ON'
    return 'The update is mandatory the game will close.'
  when 'UPDATER_MISCONFIGURATION'
    return 'Error 203: Updater misconfiguration error.'
  end
end


def pbValidateGameVersionAndUpdate(from_update_button=false)
    pbFillUpdaterConfig if (GameVersion::POKE_UPDATER_CONFIG).empty?
  return if !GameVersion::POKE_UPDATER_CONFIG
  if !GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN'] || GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN'] == ''
    Kernel.pbMessage(pbGetPokeUpdaterText('NO_PASTEBIN_URL')) if from_update_button
    return
  end
  pbValidateVersion(GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN'], true, from_update_button)
end

def pbValidateGameVersion(from_update_button=false)
    pbFillUpdaterConfig if (GameVersion::POKE_UPDATER_CONFIG).empty?
  return if !GameVersion::POKE_UPDATER_CONFIG 
  if !GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN'] || GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN'] == ''
	  Kernel.pbMessage(pbGetPokeUpdaterText('NO_PASTEBIN_URL')) if from_update_button
	  return
  end
  pbValidateVersion(GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN'], false, from_update_button)
end

def pbCheckForUpdates(from_update_button=false)
	if !$joiplay || major_version >= 19 # Esto es para evitar correr este codigo en Joiplay
	  pbFillUpdaterConfig()
	  if GameVersion::POKE_UPDATER_CONFIG && GameVersion::POKE_UPDATER_CONFIG
		  pbValidateGameVersion(from_update_button)
	  end
	end
end

def forcetheupdate
    pbFillUpdaterConfig if (GameVersion::POKE_UPDATER_CONFIG).empty?
    potato = GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN']
	return false if potato.empty? || potato.nil?
	data = pbDownloadData(potato)
	rescue MKXPError
  	forceit = false
	if data
		lines = data.split("\n")
		for line in lines
			if line.include?("FORCE")
				forceit = line&.strip&.split("=")[1]&.strip == 'true'
				break
			end
		end
   end
	 return forceit
end

def getUpdate
    return true if $DEBUG && Input.press?(Input::CTRL)
    pbFillUpdaterConfig if (GameVersion::POKE_UPDATER_CONFIG).empty?
    potato = GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN']
	return false if potato.empty? || potato.nil?
	data = pbDownloadData(potato)
  	newVersion = nil
	currentVersion = GameVersion::POKE_UPDATER_CONFIG['CURRENT_GAME_VERSION'].gsub!(/(?!^[.0-9]*$)/, '')
	if data
		lines = data.split("\n")
		for line in lines
			if line.include?("GAME_VERSION")
				newVersion = line&.strip&.split("=")[1]&.strip
				break
			end
		end
       
	  return compare_versions(newVersion, currentVersion)
   end

	 return false
end

def pbValidateVersion(url, update=false, from_update_button=false)
	data = pbDownloadData(url)
	rescue MKXPError
  	newVersion = nil
	if data
		# check that the pastebin has the GAME_VERSION value
		lines = data.split("\n")
		for line in lines
			if line.include?("GAME_VERSION")
				newVersion = line&.strip&.split("=")[1]&.strip
				break
			end
		end
       if $DEBUG && Input.press?(Input::CTRL)
	    do_the_update
		return
	   end
		if !newVersion
			Kernel.pbMessage("#{pbGetPokeUpdaterText('UPDATER_MISCONFIGURATION')}")
			return
		end

		if GameVersion::POKE_UPDATER_CONFIG
      		newVersion = newVersion.gsub!(/(?!^[.0-9]*$)/, '')
			if !newVersion
				Kernel.pbMessage("#{pbGetPokeUpdaterText('UPDATER_MISCONFIGURATION')}")
				return
			end
      		
			currentVersion = GameVersion::POKE_UPDATER_CONFIG['CURRENT_GAME_VERSION'].gsub!(/(?!^[.0-9]*$)/, '')
			if !currentVersion
				Kernel.pbMessage("#{pbGetPokeUpdaterText('UPDATER_MISCONFIGURATION')}")
				return
			end

		  	if compare_versions(newVersion, currentVersion)
				newVersionText = pbGetPokeUpdaterText('NEW_VERSION', newVersion)  
				Kernel.pbMessage("#{newVersionText}")

			if $joiplay
				Kernel.pbMessage("#{pbGetUpdaterText('JOIPLAY_UPDATE')}")
				return
			end

			if !pbConfirmMessage("#{pbGetPokeUpdaterText('ASK_FOR_UPDATE')}")
				return if !GameVersion::POKE_UPDATER_CONFIG['FORCE_UPDATE']
				Kernel.pbMessage("#{pbGetPokeUpdaterText('FORCE_UPDATE_ON')}")
				Kernel.exit!
			else
				update = true
			end

			if !GameVersion::POKE_UPDATER_CONFIG['FORCE_UPDATE'] && !update
				if GameVersion::POKE_UPDATER_CONFIG['HAS_UPDATE_BUTTON'] 
					Kernel.pbMessage("#{pbGetPokeUpdaterText('BUTTON_UPDATE')}")
				else
					Kernel.pbMessage("#{pbGetPokeUpdaterText('MANUAL_UPDATE')}")
				end
				return
			end
        
			if GameVersion::POKE_UPDATER_CONFIG['FORCE_UPDATE'] || update  #THIS IS WHAT UPDATES
				if !File.exists?(GameVersion::POKE_UPDATER_CONFIG['UPDATER_FILENAME'])
					Kernel.pbMessage("#{pbGetPokeUpdaterText('UPDATER_NOT_FOUND')}")
					return
				end
				do_the_update
			end
			else
				Kernel.pbMessage(pbGetPokeUpdaterText('NO_NEW_VERSION')) if from_update_button
			end 
		end
	else
	  return
	end
end

def do_the_update
  
   if GameVersion::AUTO_UPDATE==true
	handle_saves(true)
	Kernel.pbMessage("#{pbGetPokeUpdaterText('UPDATE')}")
	IO.popen(GameVersion::POKE_UPDATER_CONFIG['UPDATER_FILENAME'])
	Kernel.exit!
   else
    potato = GameVersion::POKE_UPDATER_CONFIG['VERSION_PASTEBIN']
	return false if potato.empty? || potato.nil?
	data = pbDownloadData(potato)
  	url = nil
	if data
		lines = data.split("\n")
		for line in lines
			if line.include?("DOWNLOAD_URL")
				url = line&.strip&.split("=")[1]&.strip
				break
			end
		end
       
   end
   if !url.nil?
     if pbConfirmMessage(_INTL("Would you like to open the download link in the browser?"))
	   System.launch(url)
	  else
	  pbMessage("Update URL has been copied to clipboard.")
	  puts url
      Input.clipboard = url
	  puts Input.clipboard
	  end
   end
   end
end

def handle_saves(updating=false)
 save_dir2 = System.data_directory + "/Saves"
 file_name = "#{save_dir2}/UPDATE.rxdata"
  if File.exist?("./.DS_Store")
    File.delete("./.DS_Store")
  end
  if File.exist?(file_name) && updating==false
   File.delete(file_name)
    SaveData::AUTO_SLOTS.each do |slot|
      full_path2 = SaveData.get_full_path_original_directory(slot)
      full_path3 = SaveData.get_full_path(slot)
      if File.file?(full_path2)
        file_copy(full_path2, full_path3)
	  end
	end
  elsif updating==true
    SaveData::AUTO_SLOTS.each do |slot|
      full_path = SaveData.get_full_path(slot)
      if File.file?(full_path)
        file_copy(full_path, save_dir2)
	  end
	end
    File.open(file_name, "wb") do |file|
      file.write(Marshal.dump(""))
    end
  end
end


def compare_versions(new_version, current_version)
	old_version_split = current_version.split('.')
	new_version_split = new_version.split('.')
	version_len = [new_version_split.length, old_version_split.length].min
	
	(0...version_len).each do |i|
	  return true if new_version_split[i] > old_version_split[i]
	end
	
	# Version number is the same when comparing shorter version number, validate if this is a smaller patch with a non-standard versioning format
	# If there is no difference found, then version number is the same
	return new_version_split.length > old_version_split.length
end

def major_version
	ret = 0
	if defined?(Essentials)
		ret = Essentials::VERSION.split(".")[0].to_i
	elsif defined?(ESSENTIALS_VERSION)
		ret = ESSENTIALS_VERSION.split(".")[0].to_i
	elsif defined?(ESSENTIALSVERSION)
		ret = ESSENTIALSVERSION.split(".")[0].to_i
	end
	return ret
end