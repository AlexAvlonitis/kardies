import React, { Component } from 'react';

export default class Footer extends Component {
  render() {
    return(
      <footer>
        <div className="container-fluid">
          <div className="row">
            <div className="col">
              <p><a href="/contacts">Επικοινωνία</a></p>
            </div>
            <div className="col text-center">
              © 2016 Δικαιώματα Κardies.gr
            </div>
            <div className="col text-right">
              <a href="/terms">Όροι χρήσης</a>
              <p>
                <a target="_blank" href="https://www.facebook.com/kardies.gr">
                  <i className="fa fa-facebook-square fa-2x"/>
                </a>
              </p>
            </div>
          </div>
        </div>
      </footer>
    )
  }
}
