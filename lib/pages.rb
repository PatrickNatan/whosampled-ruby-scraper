require 'nokogiri'
require 'open-uri'
require 'pry'

class Pages
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def call
    arr = []

      list = data.css('div.leftContent').css('div.artistContent')

      list.search('article').each do |article|
        song = article.css('h3.trackName')
        puts "-----------------------"
        n =  song.css('a').css('span').text
        puts n
        if n == "Lasier Martins Levando Choque Na Festa Da Uva" || n == "This Major Force"
          puts 'Pulando...'
          next
        end
        puts "-----------------------"
        arr << {
          name: song.css('a').css('span').text,
          year:song.css('span.trackYear').text.gsub(/[^\d]/, '').to_i,
          artist:article.css('span.trackArtistName').css('a').text
        }.merge(sample(song.css('a')[0]['href']))
      end
      return arr
    end

  def sample(url)
    arrSample = []
    arrSampled = []
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com" + url))
    sections = page.css("div.leftContent").css("section")
    list = sections.map do |section|
      section unless section.css("header.sectionHeader").empty?
    end.compact!

    list.each do |data|
      header = data.css("header")
      show_more_songs = header.css("a.moreButton")
      if header.text.include?("samples")
        unless show_more_songs.empty?
          arrSample << more_data(show_more_songs[0]["href"])
        else
          data.search("div.listEntry").each do |song|
            arrSample << sub_song(song)
          end
        end
      else
        unless show_more_songs.empty?
          arrSampled << more_data(show_more_songs[0]["href"])
        else
          data.search("div.listEntry").each do |song|
            arrSampled << sub_song(song)
          end
        end
      end
    end

    genre = page.css('section.track-meta').css('a')[0].text
    {genre: genre, sample: arrSample.flatten}.merge({sampled: arrSampled.flatten})
  end

  def more_data(url)
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com" + url))
    page.search('div.listEntry').map do |song|
      sub_song(song)
    end
  end

  def sub_song(song)
    genre = song.css("div.trackBadge").css("span.bottomItem").text
    if genre.empty?
      genre = song.css("div.trackBadge").css("span.topItem").text
    end
    {
      name: song.css("a.trackName").text,
      year: song.css("span.trackArtist").text[-6..-3].to_i,
      artist: song.css("span.trackArtist").css("a")[0].text,
      genre: genre
    }
  end
end
