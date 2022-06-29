require 'spec_helper'
require 'pages'

RSpec.describe Pages do
  context 'one page from specific tag' do
    let(:page) {Nokogiri::HTML(open('./spec/fixtures/example.html'))}

    before do
      first_song = open('./spec/fixtures/exampleMA.html')
      first_song_samples = open('./spec/fixtures/exampleSamples.html')
      first_song_sampled = open('./spec/fixtures/exampleSampled.html')
      allow(URI).to receive(:open).with("https://www.whosampled.com/Racionais-MC%27s/Cap%C3%ADtulo-4,-Vers%C3%ADculo-3/").and_return(first_song)
      allow(URI).to receive(:open).with("https://www.whosampled.com/Racionais-MC%27s/Cap%C3%ADtulo-4,-Vers%C3%ADculo-3/sampled/").and_return(first_song_sampled)
      allow(URI).to receive(:open).with("https://www.whosampled.com/Racionais-MC%27s/Cap%C3%ADtulo-4,-Vers%C3%ADculo-3/samples/").and_return(first_song_samples)
      second_song = open('./spec/fixtures/exampleMS.html')
      allow(URI).to receive(:open).with("https://www.whosampled.com/Racionais-MC%27s/Vida-Loka-(Parte-II)/").and_return(second_song)
    end

    it 'has 2 songs' do
      songs = Pages.new(page).call
      expect(songs.size).to eq 2
    end

    it 'has a array of hash with song datas' do
      songs = Pages.new(page).call
      expect(songs).to match [
        {
          name: "Capítulo 4, Versículo 3",
          genre:"Hip-Hop / Rap / R&B",
          year: 1997,
          artist:"Racionais MC's",
          sample: an_instance_of(Array),
          sampled: an_instance_of(Array)
        },
        a_hash_including(
          name: "Vida Loka (Parte II)",
          genre:"Hip-Hop / Rap / R&B",
          year: 2002,
          artist:"Racionais MC's",
          sample: an_instance_of(Array),
          sampled: an_instance_of(Array)
        ),
      ]
    end

    context 'first song' do
      context 'samples' do
        it 'has 6 songs' do
          songs = Pages.new(page).call
          expect(songs[0][:sample].size).to eq 6
        end

        it 'has song data parameters' do
          songs = Pages.new(page).call
          expect(songs[0][:sample]).to all(be_a(Hash).and include(:name,:year,:artist,:genre))
        end

        it 'has song data name' do
          names = ["Slippin' Into Darkness", "Sneakin' in the Back", "Pearls", "Pride and Vanity", "Eles Não Sabem Nada", "Apenas Um Rapaz Latino-Americano"]
          songs = Pages.new(page).call
          songs[0][:sample].each_with_index do |song,index|
            expect(song[:name]).to eq(names[index])
          end
        end

        it 'has song data genre' do
          genres = ["Rock / Pop", "Soul / Funk / Disco", "Rock / Pop", "Soul / Funk / Disco", "Hip-Hop / Rap / R&B", "Rock / Pop"]
          songs = Pages.new(page).call
          songs[0][:sample].each_with_index do |song,index|
            expect(song[:genre]).to eq(genres[index])
          end
        end

        it 'has song data artist' do
          artists = ["War", "Tom Scott", "Sade", "Ohio Players", "MRN", "Belchior"]
          songs = Pages.new(page).call
          songs[0][:sample].each_with_index do |song,index|
            expect(song[:artist]).to eq(artists[index])
          end
        end

        it 'has song data year' do
          years = [1971, 1974, 1992, 1972, 1994, 1976]
          songs = Pages.new(page).call
          songs[0][:sample].each_with_index do |song,index|
            expect(song[:year]).to eq(years[index])
          end
        end
      end

      context 'sampled songs' do
        it 'has 10 songs' do
          songs = Pages.new(page).call
          expect(songs[0][:sampled].size).to eq 10
        end

        it 'has song data parameters' do
          songs = Pages.new(page).call
          expect(songs[0][:sampled]).to all(be_a(Hash).and include(:name,:year,:artist,:genre))
        end

        it 'has song data name' do
          names = ["De Onde Cê Vem?!", "Sangue Bom", "Fênix", "Din Din Don 2000", "Cocaína", "Só Idéia Boa", "Intro 2000", "Hip Hop Não Para", "No Meio De Uma Sessão", "DJ Cia"]
          songs = Pages.new(page).call
          songs[0][:sampled].each_with_index do |song,index|
            expect(song[:name]).to eq(names[index])
          end
        end

        it 'has song data genre' do
          genre = "Hip-Hop / Rap / R&B"
          songs = Pages.new(page).call
          songs[0][:sampled].each do |song|
            expect(song[:genre]).to eq(genre)
          end
        end

        it 'has song data artist' do
          artists = ["Emicida", "Thaide & DJ Hum", "Dexter (Rapper)", "Rota De Colisão", "Sabotage", "DJ Jamaika", "Dj Alpiste", "Inquérito", "ConeCrewDiretoria", "RZO"]
          songs = Pages.new(page).call
          songs[0][:sampled].each_with_index do |song,index|
            expect(song[:artist]).to eq(artists[index])
          end
        end

        it 'has song data year' do
          years = [2010, 2000, 2005, 2000, 2001, 1999, 2000, 2010, 2014, 2003]
          songs = Pages.new(page).call
          songs[0][:sampled].each_with_index do |song,index|
            expect(song[:year]).to eq(years[index])
          end
        end
      end
    end

    context 'second song' do
      context 'samples' do
        it 'has 2 songs' do
          songs = Pages.new(page).call
          expect(songs[1][:sample].size).to eq 2
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[1][:sample]).to match [
            {
              name: "Theme From Kiss of Blood",
              genre:"Soul / Funk / Disco",
              year: 1976,
              artist:"The Button Down Brass",
            },
            a_hash_including(
              name: "Programado Pra Morre",
              genre:"Hip-Hop / Rap / R&B",
              year: 2000,
              artist:"Trilha Sonora Do Gueto",
            ),
          ]
        end
      end

      context 'sampled' do
        it 'has 1 song' do
          songs = Pages.new(page).call
          expect(songs[1][:sampled].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[1][:sampled]).to match [
            {
              name: "Sonhar é Viver",
              genre:"Hip-Hop / Rap / R&B",
              year: 2005,
              artist:"Inquérito"
            },
          ]
        end
      end
    end
  end
end







