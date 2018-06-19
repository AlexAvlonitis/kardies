import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import NavBar from './nav_bar'
import UsersIndex from './users/users_index'
import KardiesIndex from './kardies/kardies_index'
import UserProfile from './users/user/profile'

export default class KardiesApp extends Component {
  render() {
    return(
      <Router>
        <div>
          <NavBar />
          <div className="container">
            <Switch>
              <Route path="/users/:userName" component={UserProfile} />
              <Route path="/users" component={UsersIndex} />
              <Route path="/likes" component={KardiesIndex} />
            </Switch>
          </div>
        </div>
      </Router>
    )
  }
}
