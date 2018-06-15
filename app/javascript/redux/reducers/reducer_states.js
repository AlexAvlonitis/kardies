import {
  FETCHING_STATES,
  FETCHED_STATES,
} from '../actions/states';

export default (state = { allStates: [], isFetching: false }, action) => {
  switch (action.type) {

  case FETCHING_STATES:
    return Object.assign({}, state, { isFetching: true})

  case FETCHED_STATES:
    return Object.assign({}, state, { allStates: action.payload, isFetching: false })

  default:
    return state;
  }
}
