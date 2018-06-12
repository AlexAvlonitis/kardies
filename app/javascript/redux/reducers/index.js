import { combineReducers } from 'redux';
import users from './reducer_users';

const rootReducer = combineReducers({
  users
});

export default rootReducer;
