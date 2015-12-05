{ EventEmitter } = require 'events'


class LocationStore extends EventEmitter
  constructor: ({ dispatcher }) ->
    @_dispatcher = dispatcher

    @_currentLocation = null

  init: ->
    @_dispatcher.on('location-set', @_handleLocation)

  getCurrentLocation: ->
    return @_currentLocation

  _handleLocation: ({ location }) =>
    @_currentLocation = location
    @emit('change')


module.exports = LocationStore
