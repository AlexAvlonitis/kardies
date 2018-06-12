import React, { Component } from 'react';
import { connect } from 'react-redux';
import Card from './card';

class CardDeck extends Component {
  renderCard(user) {
    return (
      <Card key={user.username} user={user}/>
    );
  }

  render() {
    return (
      <div className="card-deck justify-content-center">
        { this.props.users.map(this.renderCard) }
      </div>
    );
  }
}

function mapStateToProps({ users }) {
  return { users };
}

export default connect(mapStateToProps)(CardDeck);
