{ EventEmitter } = require 'events'

{ startsWith } = require '../utils'


class LocationStore extends EventEmitter
  constructor: ({ dispatcher }) ->
    @_dispatcher = dispatcher

    @_locationBase = null
    @_currentLocation = null
    @_effectiveLocation = null

  init: ->
    @_dispatcher.on('location-set', @_handleLocation)
    @_dispatcher.on('location-base-set', @_handleLocationBase)

  getLocationBase: ->
    return @_locationBase

  getCurrentLocation: ->
    return @_currentLocation

  getEffectiveLocation: ->
    return @_effectiveLocation

  _handleLocation: ({ location }) =>
    @_currentLocation = location
    @_updateEffectiveLocation()
    @emit('change')

  _handleLocationBase: ({ locationBase }) =>
    if locationBase
      locationBase = locationBase.replace(/\/$/, '')

    @_locationBase = locationBase or null
    @_updateEffectiveLocation()
    @emit('change')

  _updateEffectiveLocation: ->
    locationBase = @_locationBase
    currentPathname = @_currentLocation?.pathname or null
    if !currentPathname or !locationBase
      @_effectiveLocation = @_currentLocation
    else if startsWith(currentPathname + '/', locationBase + '/')
      @_effectiveLocation =
        pathname: currentPathname.substr(locationBase.length)
    else
      @_effectiveLocation = null


module.exports = LocationStore
