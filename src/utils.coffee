
areTargetsEqual = (a, b) ->
  return (
    a.targetPath == b.targetPath and
    JSON.stringify(a.params or {}) == JSON.stringify(b.params or {})
  )


module.exports = {
  areTargetsEqual
}
