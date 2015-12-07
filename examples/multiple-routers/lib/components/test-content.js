// Generated by CoffeeScript 1.10.0
var React, TestContent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

TestContent = (function(superClass) {
  extend(TestContent, superClass);

  function TestContent() {
    return TestContent.__super__.constructor.apply(this, arguments);
  }

  TestContent.prototype.render = function() {
    return React.createElement("div", null, (this.props.itemId ? [
      React.createElement("p", null, "Item ID: ", this.props.itemId), React.createElement("p", null, React.createElement("button", {
        "onClick": this.props.onItemCloseRequest
      }, "Close Item"))
    ] : this.props.onItemOpenRequest ? React.createElement("p", null, React.createElement("button", {
      "onClick": this.props.onItemOpenRequest
    }, "Open Item")) : void 0), (this.props.showComments && this.props.onCommentHideRequest ? [
      React.createElement("ul", null, React.createElement("li", {
        "key": "comment-1"
      }, "Comment 1"), React.createElement("li", {
        "key": "comment-2"
      }, "Comment 2"), React.createElement("li", {
        "key": "comment-3"
      }, "Comment 3")), React.createElement("p", null, React.createElement("button", {
        "onClick": this.props.onCommentHideRequest
      }, "Hide Comments"))
    ] : this.props.onCommentShowRequest ? React.createElement("p", null, React.createElement("button", {
      "onClick": this.props.onCommentShowRequest
    }, "Show Comments")) : void 0), this.props.children);
  };

  return TestContent;

})(React.Component);

module.exports = TestContent;
