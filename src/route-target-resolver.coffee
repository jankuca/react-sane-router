React = require 'react'

StatusCodes = require './status-codes'


class RouteTargetResolver
  ###*
  # @param {!Object.<string|StatusCodes, string|StatusCodes|ReactElement>} targets
  ###
  constructor: (targets) ->
    @_targets = targets

  ###*
  # @param {string|StatusCodes} keyPathStr
  # @param {Object.<string, string>=} params
  ###
  resolveTarget: (keyPathStr, params = {}) ->
    if typeof keyPathStr == 'string'
      keyPath = keyPathStr.split('/')
    else
      keyPath = [ keyPathStr ]

    result = @_resolveTargetLevel(@_targets, keyPath, params)
    if typeof result != 'object'
      result = @resolveTarget(result, params)

    return result

  _resolveTargetLevel: (targets, keyPath, params) ->
    key = keyPath[0]
    target = targets[key]
    if typeof target == 'function'
      target = target(params)

    if !target
      return null if key == StatusCodes.NOT_FOUND
      return @resolveTarget(StatusCodes.NOT_FOUND, params)

    if React.isValidElement(target)
      return target

    if typeof target == 'object'
      return @_resolveTargetLevel(target, keyPath.slice(1), params)

    return target or null


module.exports = RouteTargetResolver
