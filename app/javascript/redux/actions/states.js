import fetch from 'cross-fetch';

export const FETCHING_STATES = 'FETCHING STATES';
export const FETCHED_STATES = 'FETCHED STATES';

export const fetchingStates = () => {
  return {
    type: FETCHING_STATES
  }
}

export const fetchedStates = (states) => {
  return {
    type: FETCHED_STATES,
    payload: states
  }
}

export const getStates = () => {
  return (dispatch) => {
    dispatch(fetchingStates());
    fetch('/api/states')
      .then(res => res.json())
      .then(states => {
        dispatch(fetchedStates(states))
      });
  }
}
