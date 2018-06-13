import fetch from 'cross-fetch';

export const FETCH_SEARCH_USERS = 'FETCH SEARCH USERS';

const postData = (url, data) => {
  return fetch(url, {
    body: data,
    method: 'POST'
  })
  .then(response => response.json())
}

export const getSearchUsers = (criteria) => {
const search_url= '/api/search'

  return (dispatch) => {
    postData(search_url, criteria)
      .then(users => {
        dispatch({
          type: FETCH_SEARCH_USERS,
          payload: users
        })
      });
  }
}
