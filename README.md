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
      "contains_samples_of":[
         {
            "name":"MUSIC SAMPLE 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE SAMPLE"
         }
      ],
      "was_sampled_in":[
         {
            "name":"MUSIC SAMPLED 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE SAMPLED"
         }
      ]
      "was_covered_in":[
         {
            "name":"MUSIC COVERED 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE COVERED"
         }
      ],
      "is_a_cover":[
         {
            "name":"MUSIC COVER 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE COVER"
         }
      ],
      "was_remixed_in":[
         {
            "name":"MUSIC REMIXED 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE REMIXED"
         }
      ],
      "is_a_remix":[
         {
            "name":"MUSIC REMIX 1",
            "genre":"GENRE",
            "year":2000,
            "artist":"ONE REMIX"
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
ruby execute.rb TAG [TOTAL_PAGES]
```

Execute Tests

``` bash
rspec
```

# Example Usage

```
ruby execute.rb Iraq
```

Create a pageIraq.json


<details>
<summary>Open pageIraq.json</summary>

```json
[
   {
      "name":"Kon Yamak (Mawal)",
      "year":2005,
      "artist":"Majid Al Muhandis",
      "genre":"Other",
      "was_sampled_in":[
         {
            "name":"Der Junge Said",
            "year":2008,
            "artist":"Fard",
            "genre":"Hip-Hop / Rap / R&B"
         }
      ]
   },
   {
      "name":"Love Poem (Lamma Anakhu)",
      "year":1973,
      "artist":"Saadoun Al-Bayati",
      "genre":"World / Latin",
      "was_sampled_in":[
         {
            "name":"Beat 2#",
            "year":2009,
            "artist":"Ras G",
            "genre":"Hip-Hop / Rap / R&B"
         }
      ]
   },
   {
      "name":"This Is Iraq (العراق)",
      "year":2018,
      "artist":"I-NZ",
      "genre":"Hip-Hop / Rap / R&B",
      "is_a_cover":[
         {
            "name":"This Is America",
            "year":2018,
            "artist":"Childish Gambino",
            "genre":"Hip-Hop / Rap / R&B"
         }
      ]
   }
]
```

</details>
