require 'spec_helper'

RSpec.describe Pages do
  context 'one page from specific tag' do
    let(:page) { Nokogiri::HTML(open('./spec/fixtures/example.html')) }

    before do
      first_song = open('./spec/fixtures/exampleMA.html')
      first_song_samples = open('./spec/fixtures/exampleSamples.html')
      first_song_sampled = open('./spec/fixtures/exampleSampled.html')
      allow(URI).to receive(:open).with('https://www.whosampled.com/Racionais-MC%27s/Cap%C3%ADtulo-4,-Vers%C3%ADculo-3/').and_return(first_song)
      allow(URI).to receive(:open).with('https://www.whosampled.com/Racionais-MC%27s/Cap%C3%ADtulo-4,-Vers%C3%ADculo-3/sampled/').and_return(first_song_sampled)
      allow(URI).to receive(:open).with('https://www.whosampled.com/Racionais-MC%27s/Cap%C3%ADtulo-4,-Vers%C3%ADculo-3/samples/').and_return(first_song_samples)
      second_song = open('./spec/fixtures/exampleMS.html')
      allow(URI).to receive(:open).with('https://www.whosampled.com/Racionais-MC%27s/Vida-Loka-(Parte-II)/').and_return(second_song)
      third_song = open('./spec/fixtures/sambadabencao.html')
      allow(URI).to receive(:open).with('https://www.whosampled.com/Bebel-Gilberto/Samba-Da-Ben%C3%A7%C3%A3o/').and_return(third_song)
      four_song = open('./spec/fixtures/aquareladobrasil.html')
      four_song_sampled = open('./spec/fixtures/aquareladobrasilsampled.html')
      four_song_covered = open('./spec/fixtures/aquareladobrasilcovered1.html')
      four_song_second_page = open('./spec/fixtures/aquareladobrasilcovered2.html')
      four_song_third_page = open('./spec/fixtures/aquareladobrasilcovered3.html')
      four_song_four_page = open('./spec/fixtures/aquareladobrasilcovered4.html')
      allow(URI).to receive(:open).with('https://www.whosampled.com/Francisco-Alves/Aquarela-Do-Brasil/').and_return(four_song)
      allow(URI).to receive(:open).with('https://www.whosampled.comhttps://www.whosampled.com/Francisco-Alves/Aquarela-Do-Brasil/sampled/').and_return(four_song_sampled)
      allow(URI).to receive(:open).with('https://www.whosampled.comhttps://www.whosampled.com/Francisco-Alves/Aquarela-Do-Brasil/covered/').and_return(four_song_covered)
      allow(URI).to receive(:open).with('https://www.whosampled.comhttps://www.whosampled.com/Francisco-Alves/Aquarela-Do-Brasil/covered/?cp=2').and_return(four_song_second_page)
      allow(URI).to receive(:open).with('https://www.whosampled.comhttps://www.whosampled.com/Francisco-Alves/Aquarela-Do-Brasil/covered/?cp=3').and_return(four_song_third_page)
      allow(URI).to receive(:open).with('https://www.whosampled.comhttps://www.whosampled.com/Francisco-Alves/Aquarela-Do-Brasil/covered/?cp=4').and_return(four_song_four_page)
    end

    it 'has 4 songs' do
      songs = Pages.new(page).call
      expect(songs.size).to eq 4
    end

    it 'has a array of hash with song datas' do
      songs = Pages.new(page).call
      expect(songs).to match [
        {
          name: 'Capítulo 4, Versículo 3',
          genre: 'Hip-Hop / Rap / R&B',
          year: 1997,
          artist: "Racionais MC's",
          contains_samples_of: an_instance_of(Array),
          was_sampled_in: an_instance_of(Array)
        },
        a_hash_including(
          name: 'Vida Loka (Parte II)',
          genre: 'Hip-Hop / Rap / R&B',
          year: 2002,
          artist: "Racionais MC's",
          contains_samples_of: an_instance_of(Array),
          was_sampled_in: an_instance_of(Array)
        ),
        a_hash_including(
          name: 'Samba Da Benção',
          genre: 'World / Latin',
          year: 2000,
          artist: 'Bebel Gilberto',
          contains_samples_of: an_instance_of(Array),
          was_sampled_in: an_instance_of(Array),
          is_a_cover: an_instance_of(Array),
          was_covered_in: an_instance_of(Array),
          was_remixed_in: an_instance_of(Array)
        ),
        a_hash_including(
          name: 'Aquarela Do Brasil',
          genre: 'World / Latin',
          year: 1939,
          artist: 'Francisco Alves',
          was_sampled_in: an_instance_of(Array),
          was_covered_in: an_instance_of(Array)
        )
      ]
    end

    context 'first song' do
      context 'samples' do
        it 'contains sample of 6 songs' do
          songs = Pages.new(page).call
          expect(songs[0][:contains_samples_of].size).to eq 6
        end

        it 'has song data parameters' do
          songs = Pages.new(page).call
          expect(songs[0][:contains_samples_of]).to all(be_a(Hash).and(include(:name, :year, :artist, :genre)))
        end

        it 'has song data name' do
          names = ["Slippin' Into Darkness", "Sneakin' in the Back", 'Pearls', 'Pride and Vanity',
                   'Eles Não Sabem Nada', 'Apenas Um Rapaz Latino-Americano']
          songs = Pages.new(page).call
          songs[0][:contains_samples_of].each_with_index do |song, index|
            expect(song[:name]).to eq(names[index])
          end
        end

        it 'has song data genre' do
          genres = ['Rock / Pop', 'Soul / Funk / Disco', 'Rock / Pop', 'Soul / Funk / Disco', 'Hip-Hop / Rap / R&B',
                    'Rock / Pop']
          songs = Pages.new(page).call
          songs[0][:contains_samples_of].each_with_index do |song, index|
            expect(song[:genre]).to eq(genres[index])
          end
        end

        it 'has song data artist' do
          artists = ['War', 'Tom Scott', 'Sade', 'Ohio Players', 'MRN', 'Belchior']
          songs = Pages.new(page).call
          songs[0][:contains_samples_of].each_with_index do |song, index|
            expect(song[:artist]).to eq(artists[index])
          end
        end

        it 'has song data year' do
          years = [1971, 1974, 1992, 1972, 1994, 1976]
          songs = Pages.new(page).call
          songs[0][:contains_samples_of].each_with_index do |song, index|
            expect(song[:year]).to eq(years[index])
          end
        end
      end

      context 'sampled songs' do
        it 'was sampled in 10 songs' do
          songs = Pages.new(page).call
          expect(songs[0][:was_sampled_in].size).to eq 10
        end

        it 'has song data parameters' do
          songs = Pages.new(page).call
          expect(songs[0][:was_sampled_in]).to all(be_a(Hash).and(include(:name, :year, :artist, :genre)))
        end

        it 'has song data name' do
          names = ['De Onde Cê Vem?!', 'Sangue Bom', 'Fênix', 'Din Din Don 2000', 'Cocaína', 'Só Idéia Boa',
                   'Intro 2000', 'Hip Hop Não Para', 'No Meio De Uma Sessão', 'DJ Cia']
          songs = Pages.new(page).call
          songs[0][:was_sampled_in].each_with_index do |song, index|
            expect(song[:name]).to eq(names[index])
          end
        end

        it 'has song data genre' do
          genre = 'Hip-Hop / Rap / R&B'
          songs = Pages.new(page).call
          songs[0][:was_sampled_in].each do |song|
            expect(song[:genre]).to eq(genre)
          end
        end

        it 'has song data artist' do
          artists = ['Emicida', 'Thaide & DJ Hum', 'Dexter (Rapper)', 'Rota De Colisão', 'Sabotage', 'DJ Jamaika',
                     'Dj Alpiste', 'Inquérito', 'ConeCrewDiretoria', 'RZO']
          songs = Pages.new(page).call
          songs[0][:was_sampled_in].each_with_index do |song, index|
            expect(song[:artist]).to eq(artists[index])
          end
        end

        it 'has song data year' do
          years = [2010, 2000, 2005, 2000, 2001, 1999, 2000, 2010, 2014, 2003]
          songs = Pages.new(page).call
          songs[0][:was_sampled_in].each_with_index do |song, index|
            expect(song[:year]).to eq(years[index])
          end
        end
      end
    end

    context 'second song' do
      context 'samples' do
        it 'contains samples of 2 songs' do
          songs = Pages.new(page).call
          expect(songs[1][:contains_samples_of].size).to eq 2
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[1][:contains_samples_of]).to match [
            {
              name: 'Theme From Kiss of Blood',
              genre: 'Soul / Funk / Disco',
              year: 1976,
              artist: 'The Button Down Brass'
            },
            a_hash_including(
              name: 'Programado Pra Morre',
              genre: 'Hip-Hop / Rap / R&B',
              year: 2000,
              artist: 'Trilha Sonora Do Gueto'
            )
          ]
        end
      end

      context 'sampled' do
        it 'was sampled in 1 song' do
          songs = Pages.new(page).call
          expect(songs[1][:was_sampled_in].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[1][:was_sampled_in]).to match [
            {
              name: 'Sonhar é Viver',
              genre: 'Hip-Hop / Rap / R&B',
              year: 2005,
              artist: 'Inquérito'
            }
          ]
        end
      end
    end

    context 'third song' do
      context 'samples' do
        it 'contains samples of 1 songs' do
          songs = Pages.new(page).call
          expect(songs[2][:contains_samples_of].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[2][:contains_samples_of]).to include(
            {
              name: 'Nova',
              genre: 'Electronic / Dance',
              year: 1998,
              artist: 'Amon Tobin'
            }
          )
        end
      end

      context 'sampled' do
        it 'was sampled in 1 song' do
          songs = Pages.new(page).call
          expect(songs[2][:was_sampled_in].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[2][:was_sampled_in]).to include(
            {
              name: 'Daydreaming',
              genre: 'Hip-Hop / Rap / R&B',
              year: 2017,
              artist: 'Kid Abstrakt'
            }
          )
        end
      end

      context 'cover' do
        it 'is a cover of 1 song' do
          songs = Pages.new(page).call
          expect(songs[2][:is_a_cover].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[2][:is_a_cover]).to include(
            {
              name: 'Benção',
              genre: 'World / Latin',
              year: 1963,
              artist: 'Vinicius De Moraes'
            }
          )
        end
      end

      context 'covered' do
        it 'was covered in 1 song' do
          songs = Pages.new(page).call
          expect(songs[2][:was_covered_in].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[2][:was_covered_in]).to include(
            {
              name: 'Samba De Bençao',
              genre: 'Rock / Pop',
              year: 2007,
              artist: 'Luiz Carlos Vinhas'
            }
          )
        end
      end

      context 'remixed' do
        it 'was remixed in 1 song' do
          songs = Pages.new(page).call
          expect(songs[2][:was_remixed_in].size).to eq 1
        end

        it 'has a array of hashs with song data' do
          songs = Pages.new(page).call
          expect(songs[2][:was_remixed_in]).to include(
            {
              name: 'Samba Da Benção (4hero Remix)',
              genre: 'Electronic / Dance',
              year: 2001,
              artist: '4 Hero'
            }
          )
        end
      end
    end

    context 'third song' do
      context 'sampled' do
        it 'was sampled in 12 songs' do
          songs = Pages.new(page).call
          expect(songs[3][:was_sampled_in].size).to eq 12
        end
      end

      context 'covered' do
        it 'was covered in 55 songs' do
          songs = Pages.new(page).call
          expect(songs[3][:was_covered_in].size).to eq 55
        end
      end
    end
  end
end
