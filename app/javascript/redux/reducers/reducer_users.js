import { FETCH_USERS } from '../actions/action_get_users';
import { FETCH_SEARCH_USERS } from '../actions/action_get_search_users';
import { CLEARING_RESULTS } from '../actions/action_clear_search_results';

export default (state = { results: [] }, action) => {
  switch (action.type) {

  case FETCH_USERS:
    return Object.assign({}, state, { results: action.payload })

  case FETCH_SEARCH_USERS:
    return Object.assign({}, state, { results: action.payload })

  case CLEARING_RESULTS:
    return Object.assign({}, state, { results: []})

  default:
    return state;
  }
}
