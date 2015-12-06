it = require 'ava'
React = require 'react'

ContentStore = require '../lib/stores/content-store'
{ EventEmitter } = require 'events'


it.beforeEach (test) ->
  test.context.dispatcher = new EventEmitter()

  test.context.createContentStore = ->
    contentStore = new ContentStore(test.context)
    contentStore.init()
    return contentStore


it 'should return a missing target as the current target by default', (test) ->
  contentStore = test.context.createContentStore()
  currentTarget = contentStore.getCurrentTarget()
  test.is(currentTarget.targetPath, null)
  test.same(currentTarget.params, {})


it 'should not return a current target element by default', (test) ->
  contentStore = test.context.createContentStore()
  targetElement = contentStore.getCurrentTargetElement()
  test.is(targetElement, null)


it 'should not return an arbitrary target element by default', (test) ->
  contentStore = test.context.createContentStore()
  targetElement = contentStore.getTargetElement('what', {})
  test.is(targetElement, null)


it 'should return the element of an arbitrary registered target', (test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div id="x" />

  targetElement = contentStore.getTargetElement('what', {})
  test.same(targetElement, <div id="x" />)


it 'should return the last activated target as the current target', (test) ->
  contentStore = test.context.createContentStore()

  target1 = { targetPath: 'what/is/this', params: { id: '1' }}
  target2 = { targetPath: 'what/another', params: { id: '2' }}

  test.context.dispatcher.emit('target-activate', target1)
  test.context.dispatcher.emit('target-activate', target2)

  currentTarget = contentStore.getCurrentTarget()
  test.is(currentTarget.targetPath, target2.targetPath)
  test.same(currentTarget.params, target2.params)


it 'should not return a target element ' +
    'when the active target is not registered', (test) ->
  contentStore = test.context.createContentStore()

  target = { targetPath: 'what/is/up', params: {} }
  test.context.dispatcher.emit('target-activate', target)

  targetElement = contentStore.getCurrentTargetElement()
  test.is(targetElement, null)


it 'should return the element of an activated previously registered target',
(test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div />

  target = { targetPath: 'what', params: {} }
  test.context.dispatcher.emit('target-activate', target)

  targetElement = contentStore.getCurrentTargetElement()
  test.same(targetElement, <div />)


it 'should return the element of an registered previously activated target',
(test) ->
  contentStore = test.context.createContentStore()

  target = { targetPath: 'what', params: {} }
  test.context.dispatcher.emit('target-activate', target)

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div />

  targetElement = contentStore.getCurrentTargetElement()
  test.same(targetElement, <div />)


it 'should return an up-to-date element for a re-registered active target',
(test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div id="a" />

  target = { targetPath: 'what', params: {} }
  test.context.dispatcher.emit('target-activate', target)

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div id="b" />

  targetElement = contentStore.getCurrentTargetElement()
  test.same(targetElement, <div id="b" />)


it 'should return an up-to-date element for an arbitrary re-registered target', (test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div id="a" />

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div id="b" />

  targetElement = contentStore.getTargetElement('what', {})
  test.same(targetElement, <div id="b" />)


it 'should return the element of an active nested registered target', (test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content:
      'is':
        'up': <div id="x" />

  target = { targetPath: 'what/is/up', params: {} }
  test.context.dispatcher.emit('target-activate', target)

  targetElement = contentStore.getCurrentTargetElement()
  test.same(targetElement, <div id="x" />)


it 'should return the element of an arbitrary nested registered target',
(test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content:
      'is':
        'up': <div id="x" />

  targetElement = contentStore.getTargetElement('what/is/up', {})
  test.same(targetElement, <div id="x" />)


it 'should return the element of the deepest registered parent target ' +
    'when an active nested target is not registered', (test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content:
      'is': <div id="x" />

  target = { targetPath: 'what/is/up/bro', params: {} }
  test.context.dispatcher.emit('target-activate', target)

  targetElement = contentStore.getCurrentTargetElement()
  test.same(targetElement, <div id="x" />)


it 'should return the element of the deepest registered parent target ' +
    'for an arbitrary nested target which is not registered', (test) ->
  contentStore = test.context.createContentStore()

  test.context.dispatcher.emit 'target-add',
    targetKey: 'what'
    content: <div id="x" />

  targetElement = contentStore.getTargetElement('what/is/up', {})
  test.same(targetElement, <div id="x" />)
