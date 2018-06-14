import fetch from 'cross-fetch';

export const FETCHING_RESULTS = 'FETCHING RESULTS';
export const FETCHED_RESULTS = 'FETCHED RESULTS';

export const fetchingResults = () => {
  return {
    type: FETCHING_RESULTS
  }
}

export const fetchedResults = (users) => {
  return {
    type: FETCHED_RESULTS,
    payload: users
  }
}

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
    dispatch(fetchingResults())
    postData(search_url, criteria)
      .then(users => {
        dispatch(fetchedResults(users))
      });
  }
}
