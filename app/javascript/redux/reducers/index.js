import { combineReducers } from 'redux';
import CardReducer from './reducer_card';

const rootReducer = combineReducers({
  card: CardReducer
});

export default rootReducer;
