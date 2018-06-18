import React, { Component } from 'react';

export default class UserProfile extends Component {
  render() {
    return(
      <div>
        Hello {this.props.match.params.userName}
      </div>
    );
  }
}
