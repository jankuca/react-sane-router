
class MockContentStore
  constructor: ->
    @_currentTarget = null
    @_locationTargets = {}

  setCurrentTargetInTest: (target) ->
    @_currentTarget = target

  getCurrentTarget: ->
    return @_currentTarget

  setLocationTargetInTest: (location, target) ->
    @_locationTargets[location?.pathname or '/'] = target

  getLocationTarget: (location) ->
    return @_locationTargets[location?.pathname or '/']


module.exports = MockContentStore
