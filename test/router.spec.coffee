{ createLocation } = require 'history'
it = require 'ava'
React = require 'react'

{ EventEmitter } = require 'events'
Router = require '../lib/router'

MockContentStore = require '../lib/stores/content-store.mock'
MockHistoryManager = require './_mocks/history-manager.mock'
MockLocationStore = require '../lib/stores/location-store.mock'
MockRouteStore = require '../lib/stores/route-store.mock'


it.beforeEach (test) ->
  test.context.contentStore = new MockContentStore()
  test.context.dispatcher = new EventEmitter()
  test.context.historyManager = new MockHistoryManager()
  test.context.locationStore = new MockLocationStore()
  test.context.routeStore = new MockRouteStore()

  test.context.createRouter = ->
    router = new Router(test.context)
    router.init()
    return router


it 'should dispatch a location base when set', (test) ->
  router = test.context.createRouter()

  expectedLocationBase = '/app/base'

  dispatched = false
  test.context.dispatcher.once 'location-base-set', ({ locationBase }) ->
    test.is(locationBase, expectedLocationBase)
    dispatched = true

  router.setLocationBase(expectedLocationBase)
  test.is(dispatched, true, 'The location base was not dispatched.')


it 'should dispatch routes when set', (test) ->
  router = test.context.createRouter()

  expectedRoutes =
    '/': 'target1'
    '/what': 'target2'

  dispatched = false
  test.context.dispatcher.once 'routes-set', ({ routes }) ->
    test.same(routes, expectedRoutes)
    dispatched = true

  router.setRoutes(expectedRoutes)
  test.is(dispatched, true, 'The routes were not dispatched.')


it 'should activate the target for the effective location ' +
    'after receiving new routes', (test) ->
  router = test.context.createRouter()

  effectiveLocation = createLocation('/what')
  expectedTargetKey = 'target2'

  test.context.locationStore.setEffectiveLocationInTest(effectiveLocation)
  test.context.routeStore.setLocationTargetInTest effectiveLocation,
    targetPath: expectedTargetKey

  activated = false
  test.context.dispatcher.once 'target-activate', ({ targetPath }) ->
    test.is(targetPath, expectedTargetKey)
    activated = true

  router.setRoutes
    '/': 'target1'
    '/what': 'target2'

  test.is(activated, true, 'No target was activated.')


it 'should dispatch a target when registered', (test) ->
  router = test.context.createRouter()

  expectedTarget =
    targetKey: 'target1'
    content: -> <div />

  dispatched = false
  test.context.dispatcher.once 'target-add', ({ targetKey, target }) ->
    test.is(targetKey, expectedTarget.targetKey)
    test.is(target, expectedTarget.content)
    dispatched = true

  router.registerTarget(expectedTarget.targetKey, expectedTarget.content)
  test.is(dispatched, true, 'The target was not dispatched.')


it 'should activate the target for the effective location ' +
    'after new target registration', (test) ->
  router = test.context.createRouter()

  effectiveLocation = createLocation('/what')
  expectedTargetKey = 'target2'

  test.context.locationStore.setEffectiveLocationInTest(effectiveLocation)
  test.context.routeStore.setLocationTargetInTest effectiveLocation,
    targetPath: expectedTargetKey

  activated = false
  test.context.dispatcher.once 'target-activate', ({ targetPath }) ->
    test.is(targetPath, expectedTargetKey)
    activated = true

  router.registerTarget(expectedTargetKey, -> <div />)
  test.is(activated, true, 'The target was not activated.')


it 'should not re-activate a currently active target ' +
    'after new target registration', (test) ->
  router = test.context.createRouter()

  effectiveLocation = createLocation('/what')
  expectedTargetKey = 'target2'

  test.context.locationStore.setEffectiveLocationInTest(effectiveLocation)
  test.context.contentStore.setCurrentTargetInTest
    targetPath: expectedTargetKey
  test.context.routeStore.setLocationTargetInTest effectiveLocation,
    targetPath: expectedTargetKey

  test.context.dispatcher.once 'target-activate', ({ targetPath }) ->
    test.fail('The previously active target was re-activated.')

  router.registerTarget(expectedTargetKey, -> <div />)


it 'should dispatch received locations', (test) ->
  router = test.context.createRouter()

  locations = [
    createLocation('/what')
    createLocation('/is')
    createLocation('/this')
  ]

  dispatchedLocations = []
  test.context.dispatcher.on 'location-set', ({ location }) ->
    dispatchedLocations.push(location)

  test.context.historyManager.emitLocationInTest(locations[0])
  test.context.historyManager.emitLocationInTest(locations[1])
  test.context.historyManager.emitLocationInTest(locations[2])

  test.is(dispatchedLocations.length, 3)
  test.is(dispatchedLocations[0], locations[0])
  test.is(dispatchedLocations[1], locations[1])
  test.is(dispatchedLocations[2], locations[2])


it 'should not dispatch a received location ' +
    'when it matches the current location', (test) ->
  router = test.context.createRouter()

  test.context.locationStore.setCurrentLocationInTest(createLocation('/what'))

  dispatched = false
  test.context.dispatcher.on 'location-set', ({ location }) ->
    dispatched = true

  test.context.historyManager.emitLocationInTest(createLocation('/what'))
  test.is(dispatched, false, 'The location was dispatched.')


it 'should not re-activate a currently active target ' +
    'after new target registration', (test) ->
  router = test.context.createRouter()

  effectiveLocation = createLocation('/what')
  expectedTargetKey = 'target2'

  test.context.locationStore.setEffectiveLocationInTest(effectiveLocation)
  test.context.contentStore.setCurrentTargetInTest
    targetPath: expectedTargetKey
  test.context.routeStore.setLocationTargetInTest effectiveLocation,
    targetPath: expectedTargetKey

  test.context.dispatcher.once 'target-activate', ({ targetPath }) ->
    test.fail('The previously active target was re-activated.')

  router.registerTarget(expectedTargetKey, -> <div />)


it 'should re-activate the currently active target ' +
    'on a reload request', (test) ->
  router = test.context.createRouter()

  effectiveLocation = createLocation('/what')
  expectedTargetKey = 'target2'

  test.context.locationStore.setEffectiveLocationInTest(effectiveLocation)
  test.context.contentStore.setCurrentTargetInTest
    targetPath: expectedTargetKey
  test.context.routeStore.setLocationTargetInTest effectiveLocation,
    targetPath: expectedTargetKey

  reactivated = false
  test.context.dispatcher.once 'target-activate', ({ targetPath }) ->
    test.is(targetPath, expectedTargetKey)
    reactivated = true

  router.reload()
  test.is(reactivated, true, 'The previously active target was not re-activated.')


it 'should push a new history state on a redirect request', (test) ->
  router = test.context.createRouter()

  expectedPathname = '/what'

  pushed = false
  test.context.historyManager.listen (location) ->
    test.is(location.pathname, expectedPathname)
    pushed = true

  router.redirectToUrl(expectedPathname)
  test.is(pushed, true, 'The redirect URL was not pushed to the history.')


it 'should add the location base to the redirect request pathname', (test) ->
  router = test.context.createRouter()

  expectedPathname = '/app/what'

  test.context.locationStore.setLocationBaseInTest('/app')

  pushed = false
  test.context.historyManager.listen (location) ->
    test.is(location.pathname, expectedPathname)
    pushed = true

  router.redirectToUrl('/what')
  test.is(pushed, true, 'The redirect URL was not pushed to the history.')


it 'should step back in history on a go-back request', (test) ->
  router = test.context.createRouter()

  expectedPathname = '/b'
  test.context.historyManager.pushState(null, '/a')
  test.context.historyManager.pushState(null, expectedPathname)
  test.context.historyManager.pushState(null, '/c')

  stepped = false
  test.context.historyManager.listen (location) ->
    test.is(location.pathname, expectedPathname)
    stepped = true

  router.goBack()
  test.is(stepped, true, 'The history step back was not requested.')


it 'should step forward in history on a go-forward request', (test) ->
  router = test.context.createRouter()

  expectedPathname = '/c'
  test.context.historyManager.pushState(null, '/a')
  test.context.historyManager.pushState(null, '/b')
  test.context.historyManager.pushState(null, expectedPathname)
  test.context.historyManager.goBack()

  stepped = false
  test.context.historyManager.listen (location) ->
    test.is(location.pathname, expectedPathname)
    stepped = true

  router.goForward()
  test.is(stepped, true, 'The history step forward was not requested.')


it 'should not fail on a go-back request ' +
    'when a step back in history is not possible', (test) ->
  router = test.context.createRouter()

  test.context.historyManager.pushState(null, '/a')
  router.goBack()


it 'should not fail on a go-forward request ' +
    'when a step forward in history is not possible', (test) ->
  router = test.context.createRouter()

  test.context.historyManager.pushState(null, '/a')
  router.goForward()
