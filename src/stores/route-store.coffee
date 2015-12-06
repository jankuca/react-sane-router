urlmatch = require 'url-match'

{ EventEmitter } = require 'events'


class RouteStore extends EventEmitter
  constructor: ({ dispatcher }) ->
    @_dispatcher = dispatcher

    ###* @type {!Array.<{ match: function(string): Array }>} ###
    @_routes = []

  init: ->
    @_dispatcher.on('routes-set', @_handleRoutes)

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

  _handleRoutes: ({ routes }) =>
    @_routes = Object.keys(routes).map (pathnamePattern) =>
      pattern = urlmatch.generate(pathnamePattern)
      return { pattern, targetPath: routes[pathnamePattern] }

    @emit('change')


module.exports = RouteStore
