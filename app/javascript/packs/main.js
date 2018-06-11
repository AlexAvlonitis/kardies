import React from 'react';
import { render } from 'react-dom';
import KardiesApp from '../components/kardies_app';
import configureStore from '../redux/store';
import { Provider } from 'react-redux';

let initialState = {};
let store = configureStore(initialState);

render(
  <Provider store={store}>
    <KardiesApp/>
  </Provider>,
  document.getElementById('root')
);
