require_relative 'my_google_drive'

drive = MyGoogleDrive.new

list = drive.list
puts 'Files:'
puts 'No files found' if list.items.empty?
list.items.each do |file|
  puts "#{file.title} (#{file.id})"
end

folder = drive.find_or_create_folder('reports')
drive.upload('Hello World', File.expand_path('../files_to_upload/hello.txt'), folder)
