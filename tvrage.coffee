request = require 'superagent'
xml2js = require 'xml2js'

class TvRageProxy
  uri: 'http://services.tvrage.com/'
  parser: new xml2js.Parser(explicitArray: false)

  constructor: (@key) ->

  search: (show, done) ->
    request
      .get("#{@uri}feeds/search.php")
      .query( show: show )
      .end (response) =>
        if response.ok
          @parser.parseString response.text, (xml_err, result) ->
            unless result.Results is '0'
              shows = []
              shows.push(new TvRageShow(show)) for show in result.Results.show
              done xml_err, shows
            else
              done null, []

  detailedSearch: (show, done) ->
    request
      .get("#{@uri}feeds/full_search.php")
      .query( show: show )
      .end (response) =>
        if response.ok
          @parser.parseString response.text, (xml_err, result) ->
            shows = []
            shows.push(new TvRageShow(show)) for show in result.Results.show
            done xml_err, shows

  findOne: (show, done) ->
    @detailedSearch show, (err, shows) ->
      done err, shows[0]

  fullShowInfo: (id, done) ->
    request
      .get("#{@uri}feeds/full_show_info.php")
      .query( sid: id )
      .end (response) =>
        if response.ok
          @parser.parseString response.text, (xml_err, result) ->
            done xml_err, new TvRageShow(result.Show)

  fullSchedule: (country, done) =>
    request
      .get("#{@uri}feeds/fullschedule.php")
      .query( country: country )
      .end (response) =>
        if response.ok
          @parser.parseString response.text, (xml_err, result) ->
            done xml_err, result.schedule

  quickSchedule: (country, done) =>
    request
    .get("#{@uri}tools/quickschedule.php")
    .query( country: country )
    .end (response) =>
      # This API does not return XML
      # just return the raw output for now
      if response.ok
        done response.text

class TvRageShow
  constructor: (@data) ->
    # Re-map some attributes
    @id = parseInt @data['showid']
    @ended = if @data['ended']? then @data['ended'] else false
    @network = if @data['network']? then @data['network']['_'] else null
    @genres = @genres()
    @akas = @akas()
    @seasons = @seasons()

    for key, val of @data
      @[key] = val unless @[key]?

  genres: ->
    genres = []

    if @data['genres']? and typeof @data['genres']['genre'] is 'string'
      genres = [ @data['genres']['genre'] ]
    else if @data['genres']?
      genres = @data['genres']['genre']

    return genres

  akas: ->
    akas = []

    if @data['akas']? and typeof @data['akas']['aka'] is 'string'
      akas = [ @data['akas']['aka'] ]
    else if @data['akas']?

      for aka in @data['akas']['aka']
        if aka['_']? and aka['$']
          akas.push
            name: aka['_']
            country: aka['$'].country
        else if typeof aka is 'string'
          # some akas dont have country attributes
          akas.push name: aka

    return akas

  seasons: ->
    seasons = []

    if @data['Episodelist']?

      if @data['Episodelist']['Season'] instanceof Array
        for season in @data['Episodelist']['Season']
          seasons.push episodes: season.episode
      else if @data['Episodelist']['Season'] instanceof Object
        # Only one season
        seasons = [ episodes: @data['Episodelist']['Season']['episode'] ]

      delete @data['Episodelist'] # not a reliable enough attribute to keep

    return seasons

module.exports =
  Proxy: (key) -> new TvRageProxy(key)
  Show: TvRageShow
