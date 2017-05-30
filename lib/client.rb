require_relative 'my_google_drive'

drive = MyGoogleDrive.new

list = drive.list
puts 'Files:'
puts 'No files found' if list.items.empty?
list.items.each do |file|
  puts "#{file.title} (#{file.id})"
end


drive.upload('Hello World', 'hello.txt')
