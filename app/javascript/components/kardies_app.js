import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import actions from '../redux/actions';
import NavBar from './nav_bar'
import UsersIndex from './users/users_index'

class KardiesApp extends Component {
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
};

function mapStateToProps(state) {
  return {
    state
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(actions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(KardiesApp);
