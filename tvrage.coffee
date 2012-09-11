request = require 'superagent'
xml2js = require 'xml2js'

module.exports = (key) -> new TVrage(key)

class TVrage
  uri: 'http://services.tvrage.com/'
  parser: new xml2js.Parser
    explicitArray: false

  constructor: (@key) ->

  search: (show, done) ->
    request
      .get("#{@uri}feeds/search.php")
      .send( show: show )
      .end (request_err, response) =>
        unless request_err
          @parser.parseString response.text, (xml_err, result) ->
            shows = []
            shows.push(new Show(show)) for show in result.Results.show
            done xml_err, shows

  detailedSearch: (show, done) ->
    request
      .get("#{@uri}feeds/full_search.php")
      .send( show: show )
      .end (request_err, response) =>
        unless request_err
          @parser.parseString response.text, (xml_err, result) ->
            shows = []
            shows.push(new Show(show)) for show in result.Results.show
            done xml_err, shows

  findOne: (show, done) ->
    @detailedSearch show, (err, shows) ->
      done err, shows[0]

  fullShowInfo: (id, done) ->
    request
      .get("#{@uri}feeds/full_show_info.php")
      .send( sid: id )
      .end (request_err, response) =>
        unless request_err
          @parser.parseString response.text, (xml_err, result) ->
            done xml_err, new Show(result.Show)

  fullSchedule: (country, done) =>
    request
      .get("#{@uri}feeds/fullschedule.php")
      .send( country: country )
      .end (request_err, response) =>
        unless request_err
          @parser.parseString response.text, (xml_err, result) ->
            done xml_err, result.schedule

  quickSchedule: (country, done) =>
    request
    .get("#{@uri}tools/quickschedule.php")
    .send( country: country )
    .end (request_err, response) =>
      # This API does not return XML
      # just return the raw output for now
      done request_err, response.text

class Show
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

    genres

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

    akas

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

    seasons
