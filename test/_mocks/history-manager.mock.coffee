invariant = require 'invariant'
{ createLocation } = require 'history'

{ EventEmitter } = require 'events'


class MockHistoryManager
  constructor: ->
    @_emitter = new EventEmitter()
    @_locationStack = []
    @_activeLocationIndex = -1

  listen: (locationListener) ->
    # NOTE: This allows the same listener to be registered multiple times
    #   while keeping a dedicated unregistration function for each.
    listenerProxy = (location) ->
      locationListener(location)

    @_emitter.on('location', listenerProxy)
    return =>
      @_emitter.removeListener('location', listenerProxy)

  emitLocationInTest: (location) ->
    @_emitter.emit('location', location)

  pushState: (state, url) ->
    location = createLocation(url)
    @_locationStack = @_locationStack.slice(0, @_activeLocationIndex + 1)
    @_locationStack.push(location)
    @_activeLocationIndex += 1
    @emitLocationInTest(location)

  replaceState: (state, url) ->
    location = createLocation(url)
    @_locationStack = @_locationStack.slice(0, @_activeLocationIndex)
    @_locationStack.push(location)
    @emitLocationInTest(location)

  go: (delta) ->
    nextIndex = @_activeLocationIndex + delta
    invariant(
      nextIndex >= 0 and nextIndex <= @_locationStack.length - 1
      'There is not enough history.'
    )
    @_activeLocationIndex = nextIndex
    location = @_locationStack[@_activeLocationIndex]
    @emitLocationInTest(location)

  goBack: ->
    @go(-1)

  goForward: ->
    @go(+1)


module.exports = MockHistoryManager
