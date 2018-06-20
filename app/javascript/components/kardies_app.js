import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import NavBar from './nav_bar'
import UsersIndex from './users/users_index'
import KardiesIndex from './kardies/kardies_index'
import UserProfile from './users/user/profile'
import Home from './home/home_index'
import Login from './home/login'

export default class KardiesApp extends Component {
  render() {
    return(
      <Router>
        <Switch>
          <Route exact path="/" component={Home} />
          <Route path="/users/login" component={Login} />
          <NavBar />

          <div className="container">
            <Route path="/users" component={UsersIndex} />
            <Route path="/users/:userName" component={UserProfile} />
            <Route path="/likes" component={KardiesIndex} />
          </div>
        </Switch>
      </Router>
    )
  }
}
