import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { getUsers } from '../../redux/actions/users';
import { clearingResults } from '../../redux/actions/search';
import Loader from 'react-loader-spinner'
import Card from './card';
import Modal from 'react-modal';

const customStyles = {
  content : {
    top                   : '50%',
    left                  : '50%',
    right                 : 'auto',
    bottom                : 'auto',
    marginRight           : '-50%',
    transform             : 'translate(-50%, -50%)'
  }
};

Modal.setAppElement('#root')

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
      <Card key={user.username} user={user} openModal={this.openModal}/>
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

  renderModal = () => {
    return (
      <Modal
        isOpen={this.state.modalIsOpen}
        onAfterOpen={this.afterOpenModal}
        onRequestClose={this.closeModal}
        style={customStyles}
        contentLabel="Example Modal">

        <div className="row">
          <div className='modal-head col-12'>
            <button className="close pull-right" onClick={this.closeModal}>
              <span>&times;</span>
            </button>
            <div className="profile-pic-round-sm m-2"
                 style={{ display: "block", backgroundImage: `url(${this.state.user.profile_picture})`}}/>
            <p>
              Αποστολή μηνύματος:
              <strong> { this.state.user.username }</strong>
            </p>
          </div>
        </div>
        <div className="row">
          <div className='col-12'>
            <div className="form-group">
              <form action="/messages" method="post">
                <textarea name="message[body]" id="message_body" cols="5" className="form-control" required="required" placeholder="Γράψτε το μήνυμά σας"/>
                <input name="message[username]" id="message_username" value={this.state.user.username} type="hidden"/>
                <hr />
                <input name="commit" value="Αποστολή" className="btn btn-outline-primary float-right" data-disable-with="Αποστολή" type="submit"/>
              </form>
            </div>
          </div>
        </div>
      </Modal>
    )
  }

  render() {
    return (
      <div>
        { this.renderModal()}
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
