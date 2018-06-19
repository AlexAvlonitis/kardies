import React, { Component } from 'react';
import fetch from 'cross-fetch';
import { Link } from "react-router-dom";

export default class Card extends Component {
  constructor(props) {
    super(props);

    this.state = {
      heartIcon: null
    }
  }

  genderType(gender) {
    if (gender == "male") {
      return <i className="fa fa-male gender"></i>
    } else if (gender == "female") {
      return <i className="fa fa-female gender"></i>
    } else if (gender == "other") {
      return <i className="fa fa-transgender gender"></i>
    } else {
      return <i className="fa fa-male gender"></i>
    }
  }

  openModal = (e) => {
    e.preventDefault();
    let profile_picture = this.props.user.profile_picture;
    let username = this.props.user.username;

    if (typeof this.props.openModal === 'function') {
      this.props.openModal(username, profile_picture);
    }
  }

  renderHeartIcon = () => {
    if(this.state.heartIcon !== null) {
      return <i className={`fa ${this.state.heartIcon} faa-pulse faa-fast`} />
    }

    if(this.props.user.like === true) {
      return <i className="fa fa-heart faa-pulse faa-fast" />
    } else {
      return <i className="fa fa-heart-o faa-pulse faa-fast" />
    }
  }

  sendHeart = (e) => {
    e.preventDefault()
    const postData = (url) => {
      return fetch(url, {
        method: 'PUT'
      })
      .then(response => response.json())
    }

    let like_url = `/api/users/${this.props.user.username}/like`

    postData(like_url)
      .then(res => {
        console.log(res)
        this.setState({heartIcon: res.heart})
      })
  }

  clearResults = () => {
    this.props.clearResults()
  }

  render() {
    return(
      <div className="card effect1 my-4">
        <div className="card-img-top">
          <div className="float-left" />
          <Link to={`/users/${this.props.user.username}`} onClick={this.clearResults}>
            <div className="card-bg"
              style={{display: 'block',
              backgroundImage: `url(${this.props.user.profile_picture_medium})`}}
            />
          </Link>
        </div>
        <div className="card-block">
          <div className="card-title">
            <div className="row mt-3">
              <div className="col-10">
                <p className="orange-text text-left pl-2">
                  <strong>{ this.props.user.username }</strong>
                </p>
              </div>
              <div className="col-2 pl-1">
                <div className='row'>
                  { this.genderType(this.props.user.user_detail.gender) }
                  <small className="ml-2">
                    { this.props.user.user_detail.age }
                  </small>
                </div>
              </div>
            </div>
          </div>
          <div className="card-text text-left pl-2">
            <p>{ this.props.user.user_detail.city } - { this.props.user.user_detail.state }</p>
          </div>
          <div className="card-footer">
            <span className="message">
              <a className="icon-round-message" href="/users" onClick={this.openModal}>
                <i className="fa fa-comment-o"></i>
              </a>
            </span>
            <span className="like">
              <a
                className="icon-round-like like-link faa-parent animated-hover"
                href=''
                onClick={ this.sendHeart }
              >
                { this.renderHeartIcon() }
              </a>
            </span>
          </div>
        </div>
      </div>
    )
  }
}
