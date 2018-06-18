import React, { Component } from 'react';

export default class ProfilePicPanel extends Component {
  constructor(props) {
    super(props)

    this.state = { currentUsername: '' }
  }

  componentDidMount = () => {
    let username = document.getElementById("root").getAttribute('data-username');

    this.setState({currentUsername: username})
  }

  renderCurrentUserSettings = () => {
    return (
      <a className="btn btn-primary btn-round-lg" href="/user/edit">
        <i className="fa fa-gears mr-1" />
        Επεξεργασία προφίλ
      </a>
    )
  }

  renderUserSettings = () => {
    return (
      <div>
        <p>
          <a className="btn btn-sm nice-blue-bg btn-round-lg" href=''>
            <i className="fa fa-comment-o mr-1" />
            Αποστολή μηνύματος
          </a>
        </p>
        <p>
          <a className="like-link btn btn-sm btn-danger btn-round-lg animated-hover" id={this.props.userName} href={`/api/users/${this.props.userName}/like`}>
            { this.renderHeartIcon() }
            Αποστολή καρδιάς
          </a>
        </p>
      </div>
    )
  }

  renderHeartIcon = () => {
    if(this.props.like === true) {
      return <i className="fa fa-heart mr-1" />
    } else {
      return <i className="fa fa-heart-o mr-1" />
    }
  }

  render() {
    return(
      <div>
        <div className="row justify-content-center">
          <div className="gallery mt-2">
            <a href={this.props.profilePicture} className='swipebox'>
              <div
                className="profile-pic"
                style={{ backgroundImage: `url(${this.props.profilePictureMedium})`}}
              />
            </a>
          </div>
        </div>
        <h3 className="mt-2">
          <strong className="narrow">
            { this.props.userName } - { this.props.age }
          </strong>
          <span className="online-now"/>
        </h3>
        <p>
          { this.props.city } - { this.props.state }
        </p>
        { (this.state.currentUsername == this.props.userName) ?
            this.renderCurrentUserSettings() : this.renderUserSettings() }
      </div>
    );
  }
}
