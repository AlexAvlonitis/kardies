import React, { Component } from 'react';
import { connect } from 'react-redux';
import Card from './card';

class CardDeck extends Component {
  renderCard(user) {
   return (
     <li key={user.username}>
      { user.username }
    </li>
   );
 }

  render() {
    return (
      <div className="card-deck justify-content-center">
        <ul>
          { this.props.users.map(this.renderCard) }
        </ul>
      </div>
    );
  }
}

function mapStateToProps({ users }) {
  return { users };
}

export default connect(mapStateToProps)(CardDeck);
