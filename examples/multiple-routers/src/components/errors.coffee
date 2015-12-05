React = require 'react'


Unauthorized = ->
  <div>Not Authorized</div>


AccessDenied = ->
  <div>Access Denied</div>


PageNotFound = ->
  <div>Page Not Found</div>


module.exports = {
  Unauthorized
  AccessDenied
  PageNotFound
}
