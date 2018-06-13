import React, { Component } from 'react';
import { connect } from 'react-redux';
import Card from './card';

class CardDeck extends Component {
  renderCard(user) {
    return (
      <Card key={user.username} user={user}/>
    );
  }

  renderEmpty = () => {
    return <p> empty </p>
  }

  render() {
    return (
      <div className="card-deck justify-content-center">
        { this.props.users.results.length > 0 ? this.props.users.results.map(this.renderCard) : this.renderEmpty() }
      </div>
    );
  }
}

function mapStateToProps({ users }) {
  return { users };
}

export default connect(mapStateToProps)(CardDeck);
