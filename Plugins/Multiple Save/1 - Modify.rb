# Store save file after load save file
$storenamefilesave = nil
# Some method for checking save file
module FileSave
	# Set name of folder
	DIR_SAVE_GAME = "Save Game"
	# Set name of file for saving:
	# Ex: Game1,Game2,etc
	FILENAME_SAVE_GAME = "Game"
	# Create dir
	def self.createDir(dir = DIR_SAVE_GAME)
		Dir.mkdir(dir) if !safeExists?(dir)
	end
	# Return location
	def self.location(dir = DIR_SAVE_GAME)
		self.createDir
		return "#{dir}"
	end
	# Array file
	def self.count(arr = false, dir = DIR_SAVE_GAME, file = FILENAME_SAVE_GAME, type = "rxdata")
		self.createDir(dir)
		File.rename("#{dir}/#{file}.#{type}", "#{dir}/#{file}1.#{type}") if File.file?("#{dir}/#{file}.#{type}")
		return arr ? Dir.glob("#{dir}/#{file}*.#{type}") : Dir.glob("#{dir}/#{file}*.#{type}").size
	end
	# Rename
	def self.rename(dir = DIR_SAVE_GAME, file = FILENAME_SAVE_GAME, type = "rxdata")
		arr = self.count(true)
		return if arr.size<=0
		name = []
		arr.each { |f| name << ( File.basename(f, ".#{type}").gsub(/[^0-9]/, "") ) }
		needtorewrite = false
		(0...arr.size).each { |i|
			needtorewrite = true if arr[i]!="#{dir}/#{file}#{name[i]}.#{type}"
		}
		if needtorewrite
			numbername = []
			name.each { |n| numbername << n.to_i}
			(0...numbername.size).each { |i|
				loop do
					break if i==0
					diff = numbername.index(numbername[i])
					break if diff==i
					numbername[i] += 1
				end
				Dir.mkdir("#{dir}/#{numbername[i]}")
				File.rename("#{arr[i]}", "#{dir}/#{numbername[i]}/#{file}#{numbername[i]}.#{type}")
			}
			(0...name.size).each { |i|
				name2 = "#{dir}/#{numbername[i]}/#{file}#{numbername[i]}.#{type}"
				File.rename(name2, "#{dir}/#{file}#{numbername[i]}.#{type}")
				Dir.delete("#{dir}/#{numbername[i]}")
			}
		end
		arr.size.times { |i|
			num = 0
			namef = sprintf("%d", i + 1)
			loop do
				break if File.file?("#{dir}/#{file}#{namef}.#{type}")
				num    += 1
				namef2  = sprintf("%d", i + 1 + num)
				File.rename("#{dir}/#{file}#{namef2}.#{type}", "#{dir}/#{file}#{namef}.#{type}") if File.file?("#{dir}/#{file}#{namef2}.#{type}")
			end
		}
	end
	# Save
	def self.name(n = nil, re = true, dir = DIR_SAVE_GAME, file = FILENAME_SAVE_GAME, type = "rxdata")
		self.rename if re
		return "#{dir}/#{file}1.rxdata" if n.nil?
		if !n.is_a?(Numeric)
			p "Set number for file save"
			return
		end
		return "#{dir}/#{file}#{n}.rxdata"
	end
	# Old file save
	def self.title
		return System.game_title.gsub(/[^\w ]/, '_')
	end
	# Version 19
	def self.dir_new(dir = DIR_SAVE_GAME, file = FILENAME_SAVE_GAME, type = "rxdata")
		game_title = self.title
		return if !File.directory?(System.data_directory)
		old_file = System.data_directory + '/Game.rxdata'
		return if !File.file?(old_file)
		self.rename
		size = self.count
		File.move(old_file, "#{dir}/#{file}#{size+1}.#{type}")
	end
	# Version 18
	def self.dir_old(dir = DIR_SAVE_GAME, file = FILENAME_SAVE_GAME, type = "rxdata")
		game_title = self.title
		home = ENV['HOME'] || ENV['HOMEPATH']
    return if home.nil?
    old_location = File.join(home, 'Saved Games', game_title)
    return if !File.directory?(old_location)
    old_file = File.join(old_location, 'Game.rxdata')
    return if !File.file?(old_file)
		self.rename
		size = self.count
    File.move(old_file, "#{dir}/#{file}#{size+1}.#{type}")
	end
end