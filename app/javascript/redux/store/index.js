import thunkMiddleware from 'redux-thunk';
import { applyMiddleware, createStore } from 'redux';
import reducer from '../reducers';
import logger from 'redux-logger';

export default () => {
  return createStore(
    reducer,
    applyMiddleware(logger, thunkMiddleware)
  );
}
