Bundler.require(:default)

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
      puts '-----------------------'
      n =  song.css('a').css('span').text
      puts n
      puts '-----------------------'
      arr << {
        name: song.css('a').css('span').text,
        year: song.css('span.trackYear').text.gsub(/[^\d]/, '').to_i,
        artist: article.css('span.trackArtistName').css('a').text
      }.merge(sample(song.css('a')[0]['href']))
    end
    arr
  end

  def sample(url)
    arr_sample = []
    arr_sampled = []
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{url}"))
    sections = page.css('div.leftContent').css('section')
    list = sections.map do |section|
      section unless section.css('header.sectionHeader').empty?
    end.compact!

    list.each do |data|
      header = data.css('header')
      show_more_songs = header.css('a.moreButton')
      if header.text.include?('samples')
        if show_more_songs.empty?
          data.search('div.listEntry').each do |song|
            arr_sample << sub_song(song)
          end
        else
          arr_sample << more_data(show_more_songs[0]['href'])
        end
      elsif show_more_songs.empty?
        data.search('div.listEntry').each do |song|
          arr_sampled << sub_song(song)
        end
      else
        arr_sampled << more_data(show_more_songs[0]['href'])
      end
    end

    genre = page.css('section.track-meta').css('a')[0].text
    { genre: genre, sample: arr_sample.flatten }.merge({ sampled: arr_sampled.flatten })
  end

  def more_data(url)
    page = Nokogiri::HTML(URI.open("https://www.whosampled.com#{url}"))
    page.search('div.listEntry').map do |song|
      sub_song(song)
    end
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
