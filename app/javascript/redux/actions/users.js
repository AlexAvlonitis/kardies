import fetch from 'cross-fetch';
import { fetchedResults } from './search'
import { fetchingResults } from './search'

export const getUsers = () => {
  return (dispatch) => {
    dispatch(fetchingResults())
    fetch('/api/users')
      .then(res => res.json())
      .then(users => {
        dispatch(fetchedResults(users))
      });
  }
}
