require 'bundler'
Bundler.require(:default)
require_relative 'lib/pages'

tag = ARGV[0]
total_pages = ARGV[1] || "1"
data = []

puts '======================'
puts "TAG: #{tag}"
puts "PAGES: #{total_pages}"
puts '======================'

total_pages.to_i.times do |t|
  puts '||||||||||||||||||||||'
  puts "PAGE #{t + 1}"
  puts '||||||||||||||||||||||'

  url = "https://www.whosampled.com/song-tag/#{tag}/#{t + 1}"
  page = Nokogiri::HTML(URI.open(url))
  data << Pages.new(page).call
end

File.write("page#{tag}.json", data.flatten.to_json, mode: 'a')
