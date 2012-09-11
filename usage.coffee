inspect = require('eyes').inspector maxLength: false
tvrage = require './tvrage'

tv = new tvrage.Proxy 'my_api_key' # key only needed for summaries
                                    # which isn't implemented yet

console.log "using TVRage key: #{tv.key}"

tv.search 'battlestar', (err, results) ->
  inspect results.length, 'shows found for search "battlestar"'
  console.log '\n'

tv.detailedSearch 'arrested', (err, results) ->
  inspect results.length, 'shows found for detailed search "arrested"'
  delete results[0].data
  inspect results[0]
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
