import React, { Component } from 'react';

export default class Login extends Component {
  render() {
    return(
      <div id="bg">
        <div className="container-fluid">
          <div className="row justify-content-center">
            <a className="mt-4" href="/">
              <img className="logo"
                src="/assets/kardies-logo-original-e189880f22503d8e575ae9a45f21b59b327b29087754efa0d5b3bcc1132c2608.png"
                alt="Kardies logo original"
              />
            </a>
          </div>
          <div className="row justify-content-center">
            <div className="col-xs-12 col-sm-8 col-md-4 light-grey-bg p-4 effect1 m-4">
              <form role="form" className="new_user" action="/oauth/token" method="post">
                <h1 className="text-center">Σύνδεση</h1>
                <hr className="colorgraph" />
                <div className="form-group">
                  <input autoFocus="autofocus" className="form-control form-control-lg" name="email" placeholder="Email" value="" id="user_email" type="text" />
                </div>
                <div className="form-group">
                  <input autoComplete="off" className="form-control form-control-lg" name="password" placeholder="Κωδικός" id="user_password" type="password" />
                </div>
                <hr className="colorgraph" />
                <div className="form-group">
                  <input name="commit" value="Σύνδεση" className="btn btn-success btn-lg btn-block white-text-bs" id="user-session-submit" data-disable-with="Σύνδεση" type="submit" />
                  <p className="home-p text-center">
                    <a href="https://kardies.gr/user/password/new">Ξεχάσατε τον κωδικό σας?</a>
                  </p>
                </div>
                <div className="form-group">
                  <a className="btn btn-primary btn-sm btn-block" href="/user/auth/facebook">
                    <i className="fa fa-facebook-official fa-lg mr-2" />
                    Σύνδεση με Facebook
                  </a>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
