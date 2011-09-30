require_relative 'webloc.rb'
require_relative 'pinboard.rb'

puts "Enter Pinboard.in username: "
u = gets.chomp
puts "and the password: "
p = gets.chomp

pb = Pinboard.new(:username=>u, :password=>p)

posts_array = pb.getHashes.to_hash['posts']['post']

posts_array.each { |post|
  wl = Webloc.new post['href']
  filename = post['description'].gsub("/"," ").gsub(":"," ")
  wl.save("bookmarks/#{filename}.webloc")
}

