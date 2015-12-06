
class MockRouteStore
  constructor: ->
    @_locationTargets = {}

  setLocationTargetInTest: (location, target) ->
    @_locationTargets[location?.pathname or '/'] = target

  getLocationTarget: (location) ->
    return @_locationTargets[location?.pathname or '/']


module.exports = MockRouteStore
