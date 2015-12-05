React = require 'react'


class TestContent extends React.Component
  render: ->
    <div>
      { if @props.itemId then [
        <p>Item ID: {@props.itemId}</p>
        <p><button onClick={@props.onItemCloseRequest}>Close Item</button></p>
      ]
      else if @props.onItemOpenRequest
        <p><button onClick={@props.onItemOpenRequest}>Open Item</button></p>
      }

      { if @props.showComments and @props.onCommentHideRequest then [
        <ul>
          <li key="comment-1">Comment 1</li>
          <li key="comment-2">Comment 2</li>
          <li key="comment-3">Comment 3</li>
        </ul>
        <p><button onClick={@props.onCommentHideRequest}>Hide Comments</button></p>
      ]
      else if @props.onCommentShowRequest
        <p><button onClick={@props.onCommentShowRequest}>Show Comments</button></p>
      }
    </div>


module.exports = TestContent
