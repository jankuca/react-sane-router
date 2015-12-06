
startsWith = (str, prefix) ->
  return (str.substr(0, prefix.length) == prefix)


areTargetsEqual = (a, b) ->
  return (
    a.targetPath == b.targetPath and
    JSON.stringify(a.params or {}) == JSON.stringify(b.params or {})
  )


module.exports = {
  areTargetsEqual
  startsWith
}
