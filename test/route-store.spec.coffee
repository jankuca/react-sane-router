{ createLocation } = require 'history'
it = require 'ava'
React = require 'react'

RouteStore = require '../lib/stores/route-store'
{ EventEmitter } = require 'events'


it.beforeEach (test) ->
  test.context.dispatcher = new EventEmitter()

  test.context.createRouteStore = ->
    routeStore = new RouteStore(test.context)
    routeStore.init()
    return routeStore


it 'should return a missing target for an arbitrary location by default',
(test) ->
  routeStore = test.context.createRouteStore()

  missingTarget = { targetPath: null, params: {} }

  locationTarget1 = routeStore.getLocationTarget(createLocation('/'))
  locationTarget2 = routeStore.getLocationTarget(createLocation('/what'))
  locationTarget3 = routeStore.getLocationTarget(createLocation('/nested/yo'))
  test.same(locationTarget1, missingTarget)
  test.same(locationTarget2, missingTarget)
  test.same(locationTarget3, missingTarget)


it 'should return the target declared for a location', (test) ->
  routeStore = test.context.createRouteStore()

  test.context.dispatcher.emit 'routes-set',
    routes:
      '/something': 'target1'
      '/what': 'target2'
      '/another': 'target3'

  locationTarget = routeStore.getLocationTarget(createLocation('/what'))
  test.is(locationTarget.targetPath, 'target2')
  test.same(locationTarget.params, {})


it 'should return an up-to-date target for a re-declared location', (test) ->
  routeStore = test.context.createRouteStore()

  test.context.dispatcher.emit 'routes-set',
    routes:
      '/what': 'target1'

  test.context.dispatcher.emit 'routes-set',
    routes:
      '/what': 'target2'

  locationTarget = routeStore.getLocationTarget(createLocation('/what'))
  test.is(locationTarget.targetPath, 'target2')
  test.same(locationTarget.params, {})


it 'should follow a location alias and return the declared target', (test) ->
  routeStore = test.context.createRouteStore()

  test.context.dispatcher.emit 'routes-set',
    routes:
      '/check-this': '/what'
      '/what': 'target1'

  locationTarget = routeStore.getLocationTarget(createLocation('/check-this'))
  test.is(locationTarget.targetPath, 'target1')
  test.same(locationTarget.params, {})


it 'should parse and return pathname parameters', (test) ->
  routeStore = test.context.createRouteStore()

  test.context.dispatcher.emit 'routes-set',
    routes:
      '/projects/:id/:slug/edit': 'edit-project'

  location = createLocation('/projects/123/what-is-up/edit')
  locationTarget = routeStore.getLocationTarget(location)
  test.is(locationTarget.targetPath, 'edit-project')
  test.same(locationTarget.params, { 'id': '123', 'slug': 'what-is-up' })


it 'should pass parameters from an alias pathname to the aliased pathname',
(test) ->
  routeStore = test.context.createRouteStore()

  test.context.dispatcher.emit 'routes-set',
    routes:
      '/projects/:date/:id/edit': '/projects/:date/:id/what-is-up/edit'
      '/projects/:date/:id/:slug/edit': 'edit-project'

  location = createLocation('/projects/2015-12-06/123/edit')
  locationTarget = routeStore.getLocationTarget(location)
  test.is(locationTarget.targetPath, 'edit-project')
  test.same locationTarget.params,
    'id': '123'
    'date': '2015-12-06'
    'slug': 'what-is-up'
