import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { getUsers } from '../../redux/actions/action_get_users';
import CardDeck from './card_deck';
import Search from './search';

class UsersIndex extends Component {
  componentDidMount() {
    this.props.getUsers()
  }

  render() {
    return(
      <div>
        <div className="row">
          <Search />
        </div>
        <div className="row justify-content-center">
          <CardDeck />
        </div>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ getUsers }, dispatch);
}

export default connect(null, mapDispatchToProps)(UsersIndex);
