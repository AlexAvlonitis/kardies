import React, { Component } from 'react'
import NavBar from './nav_bar'
import PropTypes from 'prop-types'

export default class KardiesApp extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return(
      <div>
        <NavBar />
        <div className="container">
          <p> hello { this.props.current_user.username } </p>
        </div>
      </div>
    )
  }
}
