# tvrage

```coffeescript
tvrage = require './tvrage'

tv = new tvrage.Proxy()

tv.search 'battlestar', (err, results) ->
  console.log 'shows found for search "battlestar":', results.length
  console.log results[0]
```

The above yields:

```
shows found for search "battlestar": 5
{
    ended: '2009',
    network: null,
    genres: [
        'Action',
        'Adventure',
        'Drama',
        'Military/War',
        'Sci-Fi'
    ],
    link: 'http://www.tvrage.com/Battlestar_Galactica',
    classification: 'Scripted',
    started: '2003',
    id: 2730,
    akas: [],
    seasons: [],
    country: 'US',
    showid: '2730',
    name: 'Battlestar Galactica',
    status: 'Canceled/Ended'
}
```

See `usage.coffee` for more examples.
