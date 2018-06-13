import React, { Component } from 'react'
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { getSearchUsers } from '../../redux/actions/action_get_search_users';
import { clearResults } from '../../redux/actions/action_clear_search_results';
import { getStates } from '../../redux/actions/action_get_states';

class Search extends Component {
  componentDidMount = () => {
    this.props.getStates();
    this.props.clearResults()
  }

  renderPlaces = (state) => {
    return <option key={state[1]} value={state[1]}>{state[0]}</option>
  }

  handleSubmit = (e) => {
    e.preventDefault();
    const data = new FormData(e.target);

    this.props.getSearchUsers(data);

  }

  render() {
    return(
      <div className="top-search effect3 white-text-bs">
        <h3 className="text-center p-2" id="search-collapse">
          Αναζήτηση
          <i className="fa search-icon fa-search-minus"/>
        </h3>
        <form id="search" action="/api/search" method="post" onSubmit={ this.handleSubmit } >
          <hr />
          <div className="row">
            <div className="form-group col-md-5">
              <div className="form-group">
                <select name="state"
                        id="state"
                        className="state-selection form-control form-control-lg custom-select">
                  <option value="">Ελλάδα</option>
                  { this.props.states.map(this.renderPlaces) }
                </select>
              </div>
              <div className="form-group">
                <select name="gender"
                        id="gender"
                        className="form-control form-control-lg custom-select">
                  <option value="">Φύλο</option>
                  <option value="male">Άντρας</option>
                  <option value="female">Γυναίκα</option>
                  <option value="other">Άλλο</option>
                </select>
              </div>
            </div>
            <div className="form-group col-md-2">
              <div className="form-group">
                <p>Συνδεδεμένοι τώρα</p>
                <label className="switch">
                  <input name="is_signed_in"
                         id="is_signed_in"
                         value="true"
                         type="checkbox" />
                  <span className="slider round" />
                </label>
              </div>
            </div>
          </div>
          <div className="row justify-content-center">
            <div className="form-group col-md-5">
              <input name="commit"
                     id='search-submit'
                     value="Αναζήτηση"
                     className="btn btn-outline-light btn-lg btn-block"
                     type="submit" />
            </div>
          </div>
        </form>
      </div>
    )
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    ...bindActionCreators({
      getSearchUsers,
      getStates,
      clearResults
    }, dispatch)
  }
}

const mapStateToProps = ({ states }) => {
  return { states };
}

export default connect(mapStateToProps, mapDispatchToProps)(Search);
