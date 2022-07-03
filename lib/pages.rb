Bundler.require(:default)

class Pages
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def call
    list = data.css('div.leftContent').css('div.artistContent')

    list.search('article').map do |article|
      song = article.css('h3.trackName')
      puts '-----------------------'
      name_song =  song.css('a').css('span').text
      puts name_song
      puts '-----------------------'
      {
        name: name_song,
        year: song.css('span.trackYear').text.gsub(/[^\d]/, '').to_i,
        artist: article.css('span.trackArtistName').css('a').text
      }.merge(sample(song.css('a')[0]['href']))
    end
  end

  def sample(url)
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{url}"))
    sections = page.css('div.leftContent').css('section')

    list = sections.map do |section|
      section unless section.css('header.sectionHeader').empty?
    end.compact!

    connections = list.map do |data|
      header = data.css('header')
      more_songs = header.css('a.moreButton')
      number_of_songs = header.text.scan(/\d+/)[0].to_i
      text = header.text.split[0..2].join("_").downcase
      if number_of_songs < 4
        Hash[text.to_sym, data.search('div.listEntry').map { |song| sub_song(song) }]
      else
        Hash[text.to_sym, more_data(more_songs[0]['href'])]
      end
    end

    genre = page.css('section.track-meta').css('a')[0].text
    connections.reduce({ genre: genre }, :merge)
  end

  def more_data(url)
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{url}"))
    page.search('div.listEntry').map { |song| sub_song(song)}
  end

  def sub_song(song)
    genre = song.css('div.trackBadge').css('span.bottomItem').text
    genre = song.css('div.trackBadge').css('span.topItem').text if genre.empty?
    {
      name: song.css('a.trackName').text,
      year: song.css('span.trackArtist').text[-6..-3].to_i,
      artist: song.css('span.trackArtist').css('a')[0].text,
      genre: genre
    }
  end
end
