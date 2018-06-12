import React, { Component } from 'react'

export default class Card extends Component {
  render() {
    return(
      <div className="card effect1 my-4">
        <div className="card-img-top">
          { this.props.user.username }
        </div>
      </div>
    )
  }
}
