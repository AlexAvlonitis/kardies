import React, { Component } from 'react';
import { connect } from 'react-redux';
import Loader from 'react-loader-spinner'
import Card from './card';

class CardDeck extends Component {
  renderCard(user) {
    return (
      <Card key={user.username} user={user}/>
    );
  }

  renderEmpty = () => {
    return <p> Δοκιμάστε άλλη Αναζήτηση </p>
  }

  renderLoader = () => {
    return (
      <div className="col-12 text-center">
        <Loader type="Hearts" color="red" height={80} width={80} />
      </div>
    )
  }

  render() {
    return (
      <div className="card-deck justify-content-center">
        { this.props.users.isFetching ? this.renderLoader() : null }

        { this.props.users.results.length === 0 ? this.renderEmpty() :
            this.props.users.results.map(this.renderCard)
        }
      </div>
    );
  }
}

function mapStateToProps({ users }) {
  return { users };
}

export default connect(mapStateToProps)(CardDeck);
