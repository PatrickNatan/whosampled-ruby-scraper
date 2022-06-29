require 'nokogiri'
require 'open-uri'
require 'json'
require_relative 'lib/pages'

tag = "Brazilian%20Rap"

1.times do |t|
  puts '||||||||||||||||||||||'
  puts "PAGINA #{t+1}"
  puts '||||||||||||||||||||||'

  url = "https://www.whosampled.com/song-tag/#{tag}/#{t+1}"
  page = Nokogiri::HTML(URI.open(url))
  data = Pages.new(page).call
  File.write("page#{tag}.json", data.to_json, mode: "a")
end


