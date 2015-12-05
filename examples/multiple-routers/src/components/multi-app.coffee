React = require 'react'

App = require './app'


MultiApp = ({ routers, onLoginRequest, onLogoutRequest }) ->
  <div className="multi-app">
    <App className="app app-left" router={routers[0]} onLoginRequest={onLoginRequest} onLogoutRequest={onLogoutRequest} />
    <App className="app app-right" router={routers[1]} onLoginRequest={onLoginRequest} onLogoutRequest={onLogoutRequest} />
  </div>


module.exports = MultiApp
