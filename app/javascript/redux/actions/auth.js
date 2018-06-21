import { authService } from '../../services/auth_service'

export const LOGIN_REQUEST = 'LOGIN REQUEST';
export const LOGIN_SUCCESS = 'LOGIN SUCCESS';
export const LOGIN_FAILURE = 'LOGIN FAILURE';

export const loginRequest = () => {
  return {
    type: LOGIN_REQUEST
  }
}

export const loginSuccess = (user) => {
  return {
    type: LOGIN_SUCCESS,
    payload: user
  }
}

export const loginFailure = () => {
  return {
    type: LOGIN_FAILURE
  }
}


export const login = (creds) => {
  return (dispatch) => {
    dispatch(loginRequest());
    authService.login(creds)
      .then(
        user => {
          dispatch(loginSuccess(user));
        },
        error => {
          dispatch(loginFailure(error.toString()));
        }
      );
  }
}
