import React, { Component } from 'react';
import NavBar from './nav_bar'
import UsersIndex from './users/users_index'

export default class KardiesApp extends Component {
  render() {
    return(
      <div>
        <NavBar />
        <div className="container">
          <UsersIndex />
        </div>
      </div>
    )
  }
}
