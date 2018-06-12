import fetch from 'cross-fetch';

export const FETCH_USERS = 'FETCH USERS';

export const getUsers = () => {
  return (dispatch) => {
    fetch('/api/users')
      .then(res => res.json())
      .then(users => {
        dispatch({
          type: FETCH_USERS,
          payload: users
        })
      });
  }
}
