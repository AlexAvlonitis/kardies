import fetch from 'cross-fetch';

export const FETCH_STATES = 'FETCH STATES';

export const getStates = () => {
  return (dispatch) => {
    fetch('/api/states')
      .then(res => res.json())
      .then(states => {
        dispatch({
          type: FETCH_STATES,
          payload: states
        })
      });
  }
}
