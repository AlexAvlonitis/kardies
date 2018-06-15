import React, { Component } from 'react';
import { Link } from "react-router-dom";

export default class NavBar extends Component {
  constructor(props){
    super(props)

    this.state = {
      user: {
        username: '',
        profile_picture: ''
      }
    }
  }

  componentDidMount() {
    let profile_picture = document.getElementById("root").getAttribute('data-profile-picture');
    let username = document.getElementById("root").getAttribute('data-username');

    this.setState({
      user: {
        username: username,
        profile_picture: profile_picture
      }
    });
  }

  render() {
    return(
      <nav className="navbar navbar-expand-md navbar-dark bg-orange">
        <div className="container">
          <button aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation" className="navbar-toggler navbar-toggler-right" data-target="#navbarNav" data-toggle="collapse" type="button">
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className="navbar-brand">
            <a href="/">
              <img className="logo-small shake-bottom" src="/assets/kardies-logo-small-4298fa9e843f516ee37d00c2a161bf47e231f137feb19668cf82ebc06b854fe5.png" alt="Kardies logo small" />
            </a>
          </div>
          <div className="collapse navbar-collapse" id="navbarNav">
            <ul className="navbar-nav ml-auto">
              <li className="nav-item border-bottom-nav-link" id="users">
                <Link className="nav-link" to="/users">
                  <i className="fa fa-users mr-1" />
                  Μέλη
                </Link>
              </li>
              <li className="nav-item" id="likes">
                <Link className="nav-link" to="/likes">
                  <i className="fa fa-heart mr-1" />
                  Καρδιές
                </Link>
              </li>
              <li className="nav-item" id="conversations">
                <a className="nav-link" href="/conversations">
                  <i className="fa fa-envelope mr-1"></i>
                  Μηνύματα
                </a>
              </li>
              <li className="nav-item" id="personalities">
                <a className="nav-link" href="/test-prosopikotitas">
                  <i className="fa fa-flask mr-1"></i>
                  Προσωπικότητα
                </a>
              </li>
              <li className="nav-item dropdown">
                <a aria-expanded="false" aria-haspopup="true" className="nav-item" data-toggle="dropdown" href="#" id="navbarDropdownMenuLink" role="button">
                  <img src={this.state.user.profile_picture} className="profile-pic-round-xs"/>
                </a>
                <div aria-labelledby="navbarDropdownMenuLink" className="dropdown-menu">
                  <a className="dropdown-item" href="/user/edit">
                    <i className="fa fa-cogs mr-1"></i>
                    Ρυθμίσεις
                  </a>
                  <a className="dropdown-item" href="/admin/application/index">
                    <i className="fa fa-key mr-1"></i>
                    <span className="translation_missing" title="translation missing: el.layouts.navbar.admin">Admin</span>
                  </a>
                  <div className="dropdown-divider"></div>
                  <a className="dropdown-item red-text" rel="nofollow" data-method="delete" href="/user/sign_out">
                    <i className="fa fa-power-off mr-1"></i>
                    Αποσύνδεση
                  </a>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    )
  }
}
