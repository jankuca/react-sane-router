React = require 'react'
ReactDOM = require 'react-dom'

{ AccessDenied, PageNotFound, Unauthorized } = require './components/errors'
App = require './components/app'
TestContent = require './components/test-content'

{ createRouter, StatusCodes } = require '../../../'


appContainer = null
router = null

main = ->
  router = createRouter({ historyDriver: 'memory' })

  router.registerTarget(StatusCodes.UNAUTHORIZED, <Unauthorized onLoginRequest={login} />)
  router.registerTarget(StatusCodes.FORBIDDEN, <AccessDenied onLoginRequest={login} />)
  router.registerTarget(StatusCodes.NOT_FOUND, <PageNotFound />)
  router.setRoutes
    '/': '/test'
    '/test': 'test/index'
    '/test/:id': 'test/detail'
    '/test/:id/comments': 'test/comments'

  appContainer = document.createElement('div')
  document.body.appendChild(appContainer)

  login()


login = ->
  router.registerTarget 'test',
    'index':
      <TestContent
        onItemOpenRequest={openItem} />

    'detail': ({ id }) ->
      <TestContent itemId={id}
        onCommentShowRequest={showComments}
        onItemCloseRequest={closeItem} />

    'comments': ({ id }) ->
      <TestContent itemId={id} showComments={true}
        onCommentHideRequest={openItem}
        onItemCloseRequest={closeItem} />

  ReactDOM.render(
    <App router={router} onLogoutRequest={logout} />
    appContainer
  )

logout = ->
  router.registerTarget('test', StatusCodes.UNAUTHORIZED)

  ReactDOM.render(
    <App router={router} onLoginRequest={login} />
    appContainer
  )

openItem = ->
  router.redirectToUrl('/test/123')

closeItem = ->
  router.redirectToUrl('/')

showComments = ->
  router.redirectToUrl('/test/123/comments')


main()
