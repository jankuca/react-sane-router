React = require 'react'

Target = require './components/target'
StatusCodes = require './status-codes'

{ areLocationsEqual, areTargetsEqual } = require './utils'


class Router
  StatusCodes: StatusCodes

  constructor: (services) ->
    @_contentStore = services.contentStore
    @_dispatcher  = services.dispatcher
    @_historyManager = services.historyManager
    @_locationStore = services.locationStore
    @_routeStore = services.routeStore

  createTargetElement: ->
    return <Target contentStore={@_contentStore} />

  init: ->
    @_disposeHistoryListener = @_historyManager.listen(@_handleLocation)

  dispose: ->
    @_disposeHistoryListener?.call(null)

  setLocationBase: (locationBase) ->
    @_dispatcher.emit('location-base-set', { locationBase })

  setRoutes: (routes) ->
    @_dispatcher.emit('routes-set', { routes })
    @_routeToCurrentLocation()

  registerTarget: (targetKey, content) ->
    @_dispatcher.emit('target-add', { targetKey, content })
    @_routeToCurrentLocation()

  redirectToUrl: (url) ->
    locationBase = @_locationStore.getLocationBase()
    if locationBase
      url = "#{locationBase}#{url}"

    @_historyManager.pushState(null, url)

  goBack: ->
    @go(-1)

  goForward: ->
    @go(+1)

  go: (delta) ->
    try
      @_historyManager.go(delta)
    catch err
      return err.name == 'Invariant Violation'
      throw err

  reload: ->
    target = @_contentStore.getCurrentTarget()
    @_dispatcher.emit('target-activate', target)

  _handleLocation: (location) =>
    currentLocation = @_locationStore.getCurrentLocation()
    return if areLocationsEqual(currentLocation, location)

    # TODO: Implement alias forwarding/backwarding.
    #   Forwarding:
    #     route(/ -> /projects) + route(/projects -> TARGET)
    #     => / is redirected to /projects
    #   Backwarding:
    #     route(/ -> /projects) + route(/projects -> TARGET)
    #     => /projects is redirected to /
    #   This has to be done via `replaceState()` based on `ContentStore` data.
    @_dispatcher.emit('location-set', { location })
    @_routeToCurrentLocation()

  _routeToCurrentLocation: ->
    location = @_locationStore.getEffectiveLocation()
    @_routeToLocation(location)

  _routeToLocation: (location) ->
    currentTarget = @_contentStore.getCurrentTarget()
    nextTarget = @_routeStore.getLocationTarget(location)
    return if areTargetsEqual(currentTarget, nextTarget)

    @_dispatcher.emit('target-activate', nextTarget)


module.exports = Router
