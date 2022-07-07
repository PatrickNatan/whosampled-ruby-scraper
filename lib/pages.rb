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
      logger(song.css('a').css('span').text)
      Song.new(song.css('a')[0]['href']).call
    end
  end

  private

  def logger(song)
    puts '-----------------------'
    puts song
    puts '-----------------------'
  end
end
