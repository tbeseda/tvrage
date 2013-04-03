# tvrage

```coffeescript
tvrage = require './tvrage'

tv = new tvrage.Proxy()

tv.findOne 'alias', (err, show) ->
  console.log 'findOne for "alias":'
  cosnole.log "#{show.name}: #{show.network}, #{show.status}" # Alias: ABC, Canceled/Ended
  console.log show.genres # [ 'Action', 'Adventure', 'Drama' ]
  console.log show.akas[0] # { name: 'A Vingadora', country: 'PT' }

tv.fullShowInfo 3548, (err, show) ->
  console.log show.seasons.length, 'seasons of Firefly' # 1 season of Firefly

tv.search 'battlestar', (err, results) ->
  console.log "#{results.length} results for 'battlestar' search" # 5 results...
  console.log results[0]
```

See `usage.coffee` and the tests for more examples.
