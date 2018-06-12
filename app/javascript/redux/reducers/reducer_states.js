import { FETCH_STATES } from '../actions/action_get_states';

let initialState = [];

export default (state = initialState, action) => {
  switch (action.type) {
  case FETCH_STATES:
    return [...state, ...action.payload]
  default:
    return state;
  }
}
