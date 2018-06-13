import { FETCH_SEARCH_USERS } from '../actions/search';
import { FETCHING_RESULTS } from '../actions/search';
import { FETCHED_RESULTS } from '../actions/search';
import { CLEARING_RESULTS } from '../actions/search';

export default (state = { results: [], isFetching: false }, action) => {
  switch (action.type) {

  case FETCHING_RESULTS:
    return Object.assign({}, state, { isFetching: true})

  case FETCHED_RESULTS:
    return Object.assign({}, state, { results: action.payload, isFetching: false })

  case CLEARING_RESULTS:
    return Object.assign({}, state, { results: []})

  default:
    return state;
  }
}
