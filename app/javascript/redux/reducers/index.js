import { combineReducers } from 'redux';
import users from './reducer_users';
import states from './reducer_states';

const rootReducer = combineReducers({
  users,
  states
});

export default rootReducer;
