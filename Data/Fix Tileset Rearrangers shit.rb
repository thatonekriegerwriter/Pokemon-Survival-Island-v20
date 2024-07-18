require 'fileutils'

# Define the directory where your files are located
directory = 'C:\Users\Owner\Documents\GitHub\Pokemon-Survival-Island-v20\Data' # Change this to your directory path

# Iterate through each file in the directory
Dir.foreach(directory) do |filename|
  # Check if the filename contains '_backup'
  if filename.include?('_backup')
    # Derive the original filename by removing '_backup' and the file extension
    original_filename = filename.sub('_backup', '')
    
    # Create full paths for original and backup files
    original_file_path = File.join(directory, original_filename)
    backup_file_path = File.join(directory, filename)

    # Check if the original file exists and delete it
    if File.exist?(original_file_path)
      File.delete(original_file_path)
      puts "Deleted: #{original_file_path}"
    end

    # Rename the backup file to the original filename
    FileUtils.mv(backup_file_path, original_file_path)
    puts "Renamed: #{backup_file_path} to #{original_file_path}"
  end
end

puts "Script completed."
