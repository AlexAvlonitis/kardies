import { FETCHING_RESULTS } from '../actions/search';
import { FETCHED_RESULTS } from '../actions/search';

export default (state = { results: [], isFetching: false }, action) => {
  switch (action.type) {

  case FETCHING_RESULTS:
    return Object.assign({}, state, { isFetching: true})

  case FETCHED_RESULTS:
    return Object.assign({}, state, { results: action.payload, isFetching: false })

  default:
    return state;
  }
}
