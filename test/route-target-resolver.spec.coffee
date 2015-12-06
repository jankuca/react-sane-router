it = require 'ava'
React = require 'react'

RouteTargetResolver = require '../lib/route-target-resolver'
StatusCodes = require '../lib/status-codes'


it 'should resolve a single-level target path', (test) ->
  targets =
    'what': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what', {})
  test.is(target, targets['what'])


it 'should resolve a two-level target path', (test) ->
  targets =
    'what':
      'is': <div id="a" />
      'up': <div id="b" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/up', {})
  test.is(target, targets['what']['up'])


it 'should resolve a deeper-level target', (test) ->
  targets =
    'what':
      'is':
        'actually':
          'up': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/is/actually/up', {})
  test.is(target, targets['what']['is']['actually']['up'])


it 'should resolve a top-level target factory', (test) ->
  targets =
    'what': -> <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what', {})
  test.same(target, targets['what']())


it 'should resolve a second-level target factory', (test) ->
  targets =
    'what':
      'up': -> <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/up', {})
  test.same(target, targets['what']['up']())


it 'should resolve a deeper-level target factory', (test) ->
  targets =
    'what':
      'is':
        'actually':
          'up': -> <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/is/actually/up', {})
  test.same(target, targets['what']['is']['actually']['up']())


it 'should pass target parameters to the target factory', (test) ->
  targets =
    'what': ({ id, slug }) -> <div id={id} slug={slug} />

  params = { 'id': '123', 'slug': 'what-is-up' }

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what', params)
  test.is(target.props.id, params['id'])
  test.is(target.props.slug, params['slug'])


it 'should resolve a path to the deepest available target', (test) ->
  targets =
    'what':
      'is': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/is/up', {})
  test.is(target, targets['what']['is'])


it 'should unwrap a target subtree factory', (test) ->
  targets =
    'what':
      'is': ->
        'actually':
          'up': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/is/actually/up')
  test.same(target, targets['what']['is']()['actually']['up'])


it 'should resolve a missing top-level target to null', (test) ->
  targets =
    'what': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('another', {})
  test.is(target, null)


it 'should resolve a missing second-level target to null', (test) ->
  targets =
    'what':
      'is': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/another', {})
  test.is(target, null)


it 'should resolve a missing top-level target as NOT_FOUND when available',
(test) ->
  targets =
    "#{StatusCodes.NOT_FOUND}": <div id="not-found" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what', {})
  test.is(target, targets[StatusCodes.NOT_FOUND])


it 'should resolve a missing second-level target as NOT_FOUND when available',
(test) ->
  targets =
    "#{StatusCodes.NOT_FOUND}": <div id="not-found" />
    'what':
      'is': <div id="x" />

  resolver = new RouteTargetResolver(targets)
  target = resolver.resolveTarget('what/up', {})
  test.is(target, targets[StatusCodes.NOT_FOUND])
