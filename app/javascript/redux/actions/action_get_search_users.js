import fetch from 'cross-fetch';

export const FETCH_SEARCH_USERS = 'FETCH SEARCH USERS';

const postData = (url, data) => {
  return fetch(url, {
    body: JSON.stringify(data),
    method: 'POST'
  })
  .then(response => response.json())
}

export const getSearchUsers = (criteria) => {
  const search_url= '/api/search_criteria'

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
