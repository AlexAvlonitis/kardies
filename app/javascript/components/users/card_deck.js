import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { getUsers } from '../../redux/actions/users';
import { clearingResults } from '../../redux/actions/search';
import Loader from 'react-loader-spinner'
import Card from './card';
import MessageModal from './message_modal';

class CardDeck extends Component {
  constructor(props) {
    super(props);

    this.state = {
      page: 1,
      modalIsOpen: false,
      user: {
        username: '',
        profile_picture: ''
      }
    };
  }

  openModal = (username, profile_picture) => {
    this.setState({ modalIsOpen: true, user: { username, profile_picture } });
  }

  closeModal = () => {
    this.setState({modalIsOpen: false});
  }

  componentDidMount() {
    this.props.getUsers();
  }

  componentWillUnmount() {
    this.props.clearingResults();
  }

  renderCard = (user) => {
    return (
      <Card
        key={user.username}
        user={user}
        openModal={this.openModal}
      />
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
        <MessageModal
          modalIsOpen={this.state.modalIsOpen}
          username={this.state.user.username}
          profile_picture={this.state.user.profile_picture}
          closeModal={this.closeModal}
        />

        <div className="card-deck justify-content-center">
          { this.props.users.isFetching ? this.renderLoader() :
              (this.props.users.results.length === 0 ? this.renderEmpty() :
              this.props.users.results.map(this.renderCard)) }
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
