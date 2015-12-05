history  = require 'history'

ContentStore = require './stores/content-store'
{ EventEmitter } = require 'events'
LocationStore = require './stores/location-store'
Router = require './router'
RouteTargetResolver = require './route-target-resolver'
StatusCodes = require './status-codes'
Target = require './components/target'


createRouter = ({ historyDriver } = {}) ->
  historyManager = switch historyDriver
    when 'memory' then history.useQueries(history.createMemoryHistory)()
    else history.useQueries(history.createHistory)()

  dispatcher = new EventEmitter()
  contentStore = new ContentStore({ dispatcher })
  locationStore = new LocationStore({ dispatcher })
  router = new Router({ dispatcher, contentStore, historyManager, locationStore })

  router.init()
  contentStore.init()
  locationStore.init()

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
