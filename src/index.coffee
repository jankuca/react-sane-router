history  = require 'history'

ContentStore = require './stores/content-store'
{ EventEmitter } = require 'events'
LocationStore = require './stores/location-store'
Router = require './router'
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
  router = new Router({ dispatcher, contentStore, historyManager, locationStore })

  contentStore.init()
  locationStore.init()

  if locationBase
    router.setLocationBase(locationBase)

  router.init()

  return router


module.exports = {
  StatusCodes

  ContentStore
  LocationStore
  Router
  RouteTargetResolver
  Target

  createRouter
}
