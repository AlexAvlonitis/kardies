import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { getUsers } from '../../redux/actions/users';
import { clearingResults } from '../../redux/actions/search';
import Loader from 'react-loader-spinner'
import Card from './card';

class CardDeck extends Component {
  constructor(props) {
    super(props);

    this.state = {
      page: 1
    }
  }

  componentDidMount() {
    this.props.getUsers();
  }

  componentWillUnmount() {
    this.props.clearingResults();
  }

  renderCard(user) {
    return (
      <Card key={user.username} user={user}/>
    );
  }

  renderEmpty = () => {
    return <p> Δοκιμάστε άλλη Αναζήτηση </p>
  }

  renderMoreButton = () => {
    return (
      <div className="row justify-content-center">
        <button className="btn btn-outline-primary mb-3"
                onClick={this.fetchMore} >
          Περισσότερα...
        </button>
      </div>
    )
  }

  renderLoader = () => {
    return (
      <div className="col-12 text-center">
        <Loader type="Hearts" color="red" height={80} width={80} />
      </div>
    )
  }

  fetchMore = () => {
    this.setState({ page: this.state.page += 1 })
    this.props.getUsers(this.state.page);
  }

  render() {
    return (
      <div>
        <div className="card-deck justify-content-center">
          { this.props.users.isFetching ? this.renderLoader() : null }

          { this.props.users.results.length === 0 ? this.renderEmpty() :
              this.props.users.results.map(this.renderCard) }
        </div>
        { this.renderMoreButton() }
      </div>
    );
  }
}

function mapStateToProps({ users }) {
  return { users };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ getUsers, clearingResults }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(CardDeck);
