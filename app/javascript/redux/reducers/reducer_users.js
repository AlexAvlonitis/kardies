import {
  FETCHING_RESULTS,
  FETCHED_RESULTS,
  CLEARING_RESULTS
} from '../actions/search';

import { FETCHED_USER } from '../actions/users';

export default (state = { results: [], isFetching: true, user: {} }, action) => {
  switch (action.type) {

  case FETCHING_RESULTS:
    return Object.assign({}, state, { isFetching: true });

  case FETCHED_RESULTS:
    return Object.assign({}, state, { results: state.results.concat(action.payload), isFetching: false });

  case FETCHED_USER:
    return Object.assign({}, state, { user: action.payload, isFetching: false });

  case CLEARING_RESULTS:
    return Object.assign({}, state, { results: [], user: [], isFetching: true });

  default:
    return state;
  }
}
