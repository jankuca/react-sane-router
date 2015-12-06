history  = require 'history'

ContentStore = require './stores/content-store'
{ EventEmitter } = require 'events'
LocationStore = require './stores/location-store'
Router = require './router'
RouteStore = require './stores/route-store'
RouteTargetResolver = require './route-target-resolver'
StatusCodes = require './status-codes'
Target = require './components/target'


createRouter = ({ historyDriver, locationBase } = {}) ->
  historyManager = switch historyDriver
    when 'memory' then history.useQueries(history.createMemoryHistory)()
    else history.useQueries(history.createHistory)()

  dispatcher = new EventEmitter()
  contentStore = new ContentStore({ dispatcher })
  locationStore = new LocationStore({ dispatcher })
  routeStore = new RouteStore({ dispatcher })
  router = new Router({
    dispatcher
    contentStore
    historyManager
    locationStore
    routeStore
  })

  contentStore.init()
  locationStore.init()
  routeStore.init()

  if locationBase
    router.setLocationBase(locationBase)

  router.init()

  return router


module.exports = {
  StatusCodes

  ContentStore
  LocationStore
  Router
  RouteStore
  RouteTargetResolver
  Target

  createRouter
}
