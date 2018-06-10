import React, { Component } from 'react'


export default class NavBar extends Component {
  constructor(props) {
    super(props);
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
                <a className="nav-link" href="/users">
                  <i className="fa fa-users"></i>
                  Μέλη
                </a>
              </li>
              <li className="nav-item" id="likes">
                <a className="nav-link" href="/likes">
                  <i className="fa fa-heart"></i>
                  Καρδιές
                </a>
              </li>
              <li className="nav-item" id="conversations">
                <a className="nav-link" href="/conversations">
                  <i className="fa fa-envelope"></i>
                  Μηνύματα
                </a>
              </li>
              <li className="nav-item" id="personalities">
                <a className="nav-link" href="/test-prosopikotitas">
                  <i className="fa fa-flask"></i>
                  Προσωπικότητα
                </a>
              </li>
              <li className="nav-item dropdown">
                <a aria-expanded="false" aria-haspopup="true" className="profile-pic-round-xs btn btn-secondary nav-item" data-toggle="dropdown" href="#" id="navbarDropdownMenuLink" role="button">
                  <img src="https://imisi-production.s3.amazonaws.com/user_details/profile_pictures/000/000/001/thumb/alex.png?1509848572"/>
                </a>
                <div aria-labelledby="navbarDropdownMenuLink" className="dropdown-menu">
                  <a className="dropdown-item" href="/user/edit">
                    <i className="fa fa-cogs"></i>
                    Ρυθμίσεις
                  </a>
                  <a className="dropdown-item" href="/admin/application/index">
                    <i className="fa fa-key"></i>
                    <span className="translation_missing" title="translation missing: el.layouts.navbar.admin">Admin</span>
                  </a>
                  <div className="dropdown-divider"></div>
                  <a className="dropdown-item red-text" rel="nofollow" data-method="delete" href="/user/sign_out">
                    <i className="fa fa-power-off"></i>
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
