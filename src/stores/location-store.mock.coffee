
class MockLocationStore
  constructor: ->
    @_locationBase = null
    @_currentLocation = null
    @_effectiveLocation = null

  setLocationBaseInTest: (locationBase) ->
    @_locationBase = locationBase or null

  getLocationBase: ->
    return @_locationBase

  setCurrentLocationInTest: (location) ->
    @_currentLocation = location

  getCurrentLocation: ->
    return @_currentLocation

  setEffectiveLocationInTest: (location) ->
    @_effectiveLocation = location

  getEffectiveLocation: ->
    return @_effectiveLocation


module.exports = MockLocationStore
