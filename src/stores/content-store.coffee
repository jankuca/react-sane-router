{ EventEmitter } = require 'events'
RouteTargetResolver = require '../route-target-resolver'
StatusCodes = require '../status-codes'


class ContentStore extends EventEmitter
  constructor: ({ dispatcher }) ->
    @_dispatcher = dispatcher

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
    @_dispatcher.on('target-add', @_handleTargetAdd)
    @_dispatcher.on('target-activate', @_handleTargetActivate)

  getCurrentTarget: ->
    targetPath: @_currentTargetPath
    params: @_currentTargetParams

  getTargetElement: (targetPath, params) ->
    resolver = new RouteTargetResolver(@_targets)
    return resolver.resolveTarget(targetPath, params)

  getCurrentTargetElement: ->
    return @_currentTargetElement

  _handleTargetAdd: ({ targetKey, content }) =>
    @_targets[targetKey] = content or null
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
