should = require 'should'
tvrage = require '../tvrage'

tv = new tvrage.Proxy 'my_api_key'

describe 'searching', ->
  describe 'with simple search', ->
    it 'should return simple Show objects', (done) ->
      tv.search 'buffy', (err, results) ->
        results[0].should.be.instanceof tvrage.Show
        results[0].akas.should.be.empty
        results[0].id.should.be.a('number')
        should.not.exist results[0].runtime
        results[0].seasons.should.be.empty
        done()

    it 'should be empty when there are no results', (done) ->
      tv.search 'Nx8bw1NkNR', (err, results) ->
        results.should.be.empty
        done()

  describe 'with detailed search', ->
    it 'should return extended Show objects', (done) ->
      tv.detailedSearch 'buffy', (err, results) ->
        results[0].should.be.instanceof tvrage.Show
        results[0].akas.should.not.be.empty
        results[0].id.should.be.a('number')
        results[0].runtime.should.exist
        results[0].seasons.should.be.empty
        done()

  describe 'for one show', ->
    it 'should return a single extended Show object', (done) ->
      tv.findOne 'alias', (err, result) ->
        result.should.be.instanceof tvrage.Show
        result.akas.should.not.be.empty
        result.id.should.be.a('number')
        result.runtime.should.exist
        result.seasons.should.be.empty
        done()

describe 'shows', ->
  it 'should have data', (done) ->
    tv.fullShowInfo 3548, (err, result) ->
      result.should.be.instanceof tvrage.Show
      result.akas.should.exist
      result.id.should.be.a('number')
      result.runtime.should.exist
      result.seasons.should.not.be.empty
      result.seasons[0].episodes[0].airdate.should.exist
      done()

# describe 'schedules', ->
