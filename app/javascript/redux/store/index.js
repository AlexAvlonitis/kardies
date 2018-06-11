import { applyMiddleware, compose, createStore } from 'redux';
import reducer from '../reducers';
import { createLogger } from 'redux-logger';

let finalCreateStore = compose(
  applyMiddleware(
    createLogger()
  )
)(createStore);

export default function configureStore(initialState = {}) {
  return finalCreateStore(reducer, initialState);
}
