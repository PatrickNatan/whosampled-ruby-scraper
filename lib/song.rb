class Song
  def initialize(song_url)
    @song_url = song_url
  end

  def call
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{song_url}"))

    song = {
      name: page.css('div.trackInfo').css('h1').css('meta')[0].attributes['content'].value,
      year: page.css('div.metainfo-wrapper').css('h3.label-details').css('a').text.to_i,
      artist: page.css('div.trackInfo').css('h1').css('span.trackArtistNames').css('a').text,
      genre: page.css('section.track-meta').css('a')[0].text
    }

    sections = page.css('div.leftContent').css('section')

    connections(sections).reduce(song, :merge)
  end

  private

  attr_reader :song_url

  def connections(sections)
    list = sections.map do |section|
      section unless section.css('header.sectionHeader').empty?
    end.compact!

    list.map do |data|
      header = data.css('header')
      more_songs = header.css('a.moreButton')
      number_of_songs = header.text.scan(/\d+/)[0].to_i
      text = header.text.split[0..2].join('_').downcase
      if number_of_songs < 4
        Hash[text.to_sym, data.search('div.listEntry').map { |song| sub_song(song) }]
      else
        Hash[text.to_sym, more_data(more_songs[0]['href'])]
      end
    end
  end

  def more_data(url)
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{url}"))

    number_of_songs = page.css('header.sectionHeader').text.scan(/\d+/)[0].to_i
    if number_of_songs > 16
      sub_song_list(page, url)
    else
      page.search('div.listEntry').map { |song| sub_song(song) }
    end
  end

  def sub_song_list(page, url)
    total_pages = page.css('div.pagination').css('span.page').last.text.to_i
    all_songs = Array.new(page.search('div.listEntry').map { |song| sub_song(song) })
    all_songs << 2.upto(total_pages).map do |t|
      page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{url}?cp=#{t}"))
      page.search('div.listEntry').map { |song| sub_song(song) }
    end
    all_songs.flatten
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
