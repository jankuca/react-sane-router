React = require 'react'
ReactDOM = require 'react-dom'

{ AccessDenied, PageNotFound, Unauthorized } = require './components/errors'
MultiApp = require './components/multi-app'
TestContent = require './components/test-content'

{ createRouter, StatusCodes } = require '../../../'


appContainer = null
projectListRouter = null
userListRouter = null

main = ->
  projectListRouter = createRouter({ historyDriver: 'memory' })
  userListRouter = createRouter({ historyDriver: 'memory' })

  projectListRouter.registerTarget(StatusCodes.UNAUTHORIZED, <Unauthorized onLoginRequest={login} />)
  projectListRouter.registerTarget(StatusCodes.FORBIDDEN, <AccessDenied onLoginRequest={login} />)
  projectListRouter.registerTarget(StatusCodes.NOT_FOUND, <PageNotFound />)
  projectListRouter.setRoutes
    '/': 'test/index'
    '/test/:id': 'test/detail'
    '/test/:id/comments': 'test/comments'

  userListRouter.registerTarget(StatusCodes.UNAUTHORIZED, <Unauthorized onLoginRequest={login} />)
  userListRouter.registerTarget(StatusCodes.FORBIDDEN, <AccessDenied onLoginRequest={login} />)
  userListRouter.registerTarget(StatusCodes.NOT_FOUND, <PageNotFound />)
  userListRouter.setRoutes
    '/': 'test/index'
    '/test/:id': 'test/detail'
    '/test/:id/comments': 'test/comments'

  appContainer = document.createElement('div')
  document.body.appendChild(appContainer)

  login()


login = ->
  projectListRouter.registerTarget 'test',
    'index':
      <TestContent
        onItemOpenRequest={openProject} />

    'detail': ({ id }) ->
      <TestContent itemId={id}
        onCommentShowRequest={showProjectComments}
        onItemCloseRequest={closeProject} />

    'comments': ({ id }) ->
      <TestContent itemId={id} showComments={true}
        onCommentHideRequest={openProject}
        onItemCloseRequest={closeProject} />

  userListRouter.registerTarget 'test',
    'index':
      <TestContent
        onItemOpenRequest={openUser} />

    'detail': ({ id }) ->
      <TestContent itemId={id}
        onCommentShowRequest={showUserComments}
        onItemCloseRequest={closeUser} />

    'comments': ({ id }) ->
      <TestContent itemId={id} showComments={true}
        onCommentHideRequest={openUser}
        onItemCloseRequest={closeUser} />

  ReactDOM.render(
    <MultiApp routers={[ projectListRouter, userListRouter ]} onLogoutRequest={logout}></MultiApp>
    appContainer
  )

logout = ->
  projectListRouter.registerTarget('test', StatusCodes.UNAUTHORIZED)
  userListRouter.registerTarget('test', StatusCodes.UNAUTHORIZED)

  ReactDOM.render(
    <MultiApp routers={[ projectListRouter, userListRouter ]} onLoginRequest={login}></MultiApp>
    appContainer
  )


openProject = ->
  projectListRouter.redirectToUrl('/test/123')

closeProject = ->
  projectListRouter.redirectToUrl('/')

showProjectComments = ->
  projectListRouter.redirectToUrl('/test/123/comments')


openUser = ->
  userListRouter.redirectToUrl('/test/123')

closeUser = ->
  userListRouter.redirectToUrl('/')

showUserComments = ->
  userListRouter.redirectToUrl('/test/123/comments')


main()
