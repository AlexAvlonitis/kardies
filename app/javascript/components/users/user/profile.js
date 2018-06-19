import React, { Component } from 'react';
import { connect } from 'react-redux';
import { withRouter } from 'react-router';
import { bindActionCreators } from 'redux';
import Loader from 'react-loader-spinner'
import { getUser } from '../../../redux/actions/users';
import { clearingResults } from '../../../redux/actions/search';
import ProfilePicPanel from './profile_pic_panel';

class UserProfile extends Component {
  componentDidMount() {
    let paramsUsername = this.props.match.params.userName
    this.props.getUser(paramsUsername);
  }

  renderProfilePicPanel = () => {
    return (
      <ProfilePicPanel
        profilePicture={ this.props.user.profile_picture }
        profilePictureMedium={ this.props.user.profile_picture_medium }
        userName={ this.props.user.username }
        like={ this.props.user.like }
        age={ this.props.user.user_detail.age }
        city={ this.props.user.user_detail.city }
        state={ this.props.user.user_detail.state }
      />
    )
  }

  renderLoader = () => {
    return (
      <div className="col-12 text-center">
        <Loader type="Hearts" color="red" height={80} width={80} />
      </div>
    )
  }

  render() {
    return(
      <div>
        <div className="row justify-content-center mt-2">
          <div className="col-lg-4 p-4 my-1 effect2 text-center bg-white" id="profile-pic-panel">
            { this.props.loading ? this.renderLoader() :
                this.renderProfilePicPanel() }
          </div>
          <div className="col-lg-8 p-4 my-1 effect2 bg-white">
          </div>
        </div>
        <div className="row justify-content-center mt-2">
          <div className="col-12 p-4 my-1 effect2 text-center bg-white">
          </div>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    user: state.users.user,
    loading: state.users.isFetching
  };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ getUser, clearingResults }, dispatch);
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(UserProfile))
