urlmatch = require 'url-match'

{ EventEmitter } = require 'events'

RouteTargetResolver = require '../route-target-resolver'
StatusCodes = require '../status-codes'


class ContentStore extends EventEmitter
  constructor: ({ dispatcher }) ->
    @_dispatcher = dispatcher

    ###* @type {!Array.<{ match: function(string): Array }>} ###
    @_routes = []

    ###*
    # @type {!Object.<
    #   (string|StatusCodes),
    #   (string|StatusCodes|ReactElement|
    #     function(Object.<string, string>):(string|StatusCodes|ReactElement))
    # >}
    ###
    @_targets = {}

    ###* @type {!Object.<string, string|number>} ###
    @_currentTargetParams = {}

    ###* @type {string|StatusCodes|null} ###
    @_currentTargetPath = null

    ###* @type {string|StatusCodes|ReactElement} ###
    @_currentTargetElement = null

  init: ->
    @_dispatcher.on('routes-set', @_handleRoutes)
    @_dispatcher.on('target-add', @_handleTargetAdd)
    @_dispatcher.on('target-activate', @_handleTargetActivate)

  getLocationTarget: (location) ->
    { targetPath, params } = @_getLocationRoute(location)

    if /^\//.test(targetPath)
      aliasedLocation = { pathname: targetPath }
      return @getLocationTarget(aliasedLocation)

    return { targetPath, params }

  _getLocationRoute: (location) ->
    pathname = location?.pathname or '/'

    targetPath = null
    params = {}

    @_routes.some (route) ->
      match = route.pattern.match(pathname)
      if match
        targetPath = route.targetPath
        params = match.namedParams
        return true

    return { targetPath, params }

  getCurrentTarget: ->
    targetPath: @_currentTargetPath
    params: @_currentTargetParams

  getTargetElement: (targetPath, params) ->
    resolver = new RouteTargetResolver(@_targets)
    return resolver.resolveTarget(targetPath, params)

  getCurrentTargetElement: ->
    return @_currentTargetElement

  _handleRoutes: ({ routes }) =>
    @_routes = Object.keys(routes).map (pathnamePattern) =>
      pattern = urlmatch.generate(pathnamePattern)
      return { pattern, targetPath: routes[pathnamePattern] }

    @_updateCurrentTargetElement()
    @emit('change')

  _handleTargetAdd: ({ targetKey, targetStates, targetStatusCode }) =>
    @_targets[targetKey] = targetStates or targetStatusCode or null
    @_updateCurrentTargetElement()
    @emit('change')

  _handleTargetActivate: ({ targetPath, params }) =>
    @_currentTargetPath = targetPath
    @_currentTargetParams = params
    @_updateCurrentTargetElement()
    @emit('change')

  _updateCurrentTargetElement: ->
    if @_currentTargetPath
      @_currentTargetElement = @getTargetElement(
        @_currentTargetPath
        @_currentTargetParams
      )
    else
      @_currentTargetElement = @getTargetElement(StatusCodes.NOT_FOUND)


module.exports = ContentStore
