inspect = require('eyes').inspector maxLength: false
tvrage = require './tvrage'
tv = new tvrage 'key'

console.log "using TVRage key: #{tv.key}"

tv.search 'battlestar', (err, results) ->
  inspect results.length, 'shows found for "battlestar"'

tv.detailedSearch 'bad', (err, results) ->
  inspect results.length, 'shows found for "bad"'

tv.findOne 'alias', (err, show) ->
  inspect "#{show.network}, #{show.status}", show.name
  inspect show.genres, 'Genres'
  inspect show.akas, 'AKAs'
