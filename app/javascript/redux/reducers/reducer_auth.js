import {
  LOGIN_REQUEST,
  LOGIN_SUCCESS,
  LOGIN_FAILURE
} from '../actions/auth';

export default (state = { loggingIn: false, loggedIn: false, user: {} }, action) => {
  switch (action.type) {

  case LOGIN_REQUEST:
    return Object.assign({}, state, { loggingIn: true })

  case LOGIN_SUCCESS:
    return Object.assign({}, state, { loggingIn: false, loggedIn: true, user: action.payload })

  case LOGIN_FAILURE:
    return Object.assign({}, state, { loggingIn: false, loggedIn: false, user: {} })

  default:
    return state;
  }
}
