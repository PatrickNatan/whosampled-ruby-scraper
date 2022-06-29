# whosampled-ruby-scraper
Fetch music samples data from each tag in https://www.whosampled.com/browse/tags/TAGNAME

Works only in: /song-tag/TAGNAME

Execute scraper will create a file .json with name pageTAGNAME.json in directory

Data Structure
```json
[
   {
      "name":"MUSIC",
      "genre":"GENRE",
      "year":1,
      "artist":"ARTIST",
      "sample":[
         {
            "name":"MUSIC SAMPLE 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE SAMPLE"
         }
      ],
      "sampled":[
         {
            "name":"MUSIC SAMPLED 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE SAMPLED"
         }
      ]
   }
]
```

# Usage
Install all dependencies 

``` bash
bundle install
```

Execute Scraper
``` bash
ruby execute.rb TAG TOTAL_PAGES
```

Execute Tests

``` bash
rspec
```
