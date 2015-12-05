React = require 'react'


class Target extends React.Component
  @propTypes:
    contentStore: React.PropTypes.object.isRequired

  constructor: ->
    super
    @state = @_getContentStoreState()

  _getContentStoreState: ->
    contentComponent: @props.contentStore.getCurrentTargetElement()

  componentDidMount: ->
    @props.contentStore.on('change', @_handleLocationChange)

  componentWillUnmount: ->
    @props.contentStore.removeListener('change', @_handleLocationChange)

  _handleLocationChange: =>
    @setState(@_getContentStoreState())

  render: ->
    return @state.contentComponent or <div />


module.exports = Target
