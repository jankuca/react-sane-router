// Generated by CoffeeScript 1.10.0
var App, MultiApp, React;

React = require('react');

App = require('./app');

MultiApp = function(arg) {
  var onLoginRequest, onLogoutRequest, routers;
  routers = arg.routers, onLoginRequest = arg.onLoginRequest, onLogoutRequest = arg.onLogoutRequest;
  return React.createElement("div", {
    "className": "multi-app"
  }, React.createElement(App, {
    "className": "app app-left",
    "router": routers[0],
    "onLoginRequest": onLoginRequest,
    "onLogoutRequest": onLogoutRequest
  }), React.createElement(App, {
    "className": "app app-right",
    "router": routers[1],
    "onLoginRequest": onLoginRequest,
    "onLogoutRequest": onLogoutRequest
  }));
};

module.exports = MultiApp;
