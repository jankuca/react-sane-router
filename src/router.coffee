React = require 'react'

Target = require './components/target'
StatusCodes = require './status-codes'

{ areTargetsEqual } = require './utils'


class Router
  StatusCodes: StatusCodes

  constructor: ({ contentStore, dispatcher, historyManager, locationStore }) ->
    @_contentStore = contentStore
    @_dispatcher  = dispatcher
    @_historyManager = historyManager
    @_locationStore = locationStore

  createTargetElement: ->
    return <Target contentStore={@_contentStore} />

  init: ->
    @_disposeHistoryListener = @_historyManager.listen(@_handleLocation)

  dispose: ->
    @_disposeHistoryListener?.call(null)

  setRoutes: (routes) ->
    @_dispatcher.emit('routes-set', { routes })
    @_routeToCurrentLocation()

  registerTarget: (targetKey, targetStates) ->
    if typeof targetStates == 'object'
      @_dispatcher.emit('target-add', { targetKey, targetStates })
    else
      targetStatusCode = targetStates
      @_dispatcher.emit('target-add', { targetKey, targetStatusCode })

    @_routeToCurrentLocation()

  redirectToUrl: (url) ->
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
    @_routeToCurrentLocation()

  _handleLocation: (location) =>
    # TODO: Implement alias forwarding/backwarding.
    #   Forwarding:
    #     route(/ -> /projects) + route(/projects -> TARGET)
    #     => / is redirected to /projects
    #   Backwarding:
    #     route(/ -> /projects) + route(/projects -> TARGET)
    #     => /projects is redirected to /
    #   This has to be done via `replaceState()` based on `ContentStore` data.
    @_dispatcher.emit('location-set', { location })
    @_routeToLocation(location)

  _routeToCurrentLocation: ->
    location = @_locationStore.getCurrentLocation()
    @_routeToLocation(location)

  _routeToLocation: (location) ->
    currentTarget = @_contentStore.getCurrentTarget()
    nextTarget = @_contentStore.getLocationTarget(location)
    return if areTargetsEqual(currentTarget, nextTarget)

    @_dispatcher.emit('target-activate', nextTarget)


module.exports = Router
