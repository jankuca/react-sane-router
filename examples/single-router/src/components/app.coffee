React = require 'react'


class App extends React.Component
  @propTypes:
    router: React.PropTypes.object.isRequired
    onLogoutRequest: React.PropTypes.func

  render: ->
    <div className="app">
      <button onClick={@props.router.goBack.bind(@props.router)}>Back</button>
      <hr />
      {@props.router.createTargetElement()}
      <hr />
      { if @props.onLoginRequest
        <p><button onClick={@props.onLoginRequest}>Login</button></p>
      else if @props.onLogoutRequest
        <p><button onClick={@props.onLogoutRequest}>Logout</button></p>
      }
    </div>


module.exports = App
