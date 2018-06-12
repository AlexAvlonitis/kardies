import { FETCH_USERS } from '../actions/action_get_users';

let initialState = [];

export default (state = initialState, action) => {
  switch (action.type) {
  case FETCH_USERS:
    return [...state, ...action.payload]
  default:
    return state;
  }
}
