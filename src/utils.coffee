
startsWith = (str, prefix) ->
  return (str.substr(0, prefix.length) == prefix)


areLocationsEqual = (a, b) ->
  if a == b
    return true

  if !a or !b
    return false

  return (a.pathname == b.pathname)


areTargetsEqual = (a, b) ->
  if a == b
    return true

  if !a or !b
    return false

  return (
    a.targetPath == b.targetPath and
    JSON.stringify(a.params or {}) == JSON.stringify(b.params or {})
  )


module.exports = {
  areLocationsEqual
  areTargetsEqual
  startsWith
}
