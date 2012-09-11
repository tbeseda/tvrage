inspect = require('eyes').inspector maxLength: false
tvrage = require './tvrage'
tv = new tvrage 'key'

console.log "using TVRage key: #{tv.key}"

tv.search 'battlestar', (err, results) ->
  inspect results.length, 'shows found for search "battlestar"'
  console.log '\n'

tv.detailedSearch 'arrested', (err, results) ->
  inspect results.length, 'shows found for detailed search "arrested"'
  console.log '\n'

tv.findOne 'alias', (err, show) ->
  console.log 'findOne for "alias":'
  inspect "#{show.network}, #{show.status}", show.name
  inspect show.genres, "#{show.name} genres"
  inspect show.akas, "#{show.name} AKAs"
  console.log '\n'

tv.fullShowInfo 3548, (err, show) ->
  inspect show.seasons.length, 'Seasons of Firefly'
  console.log '\n'
