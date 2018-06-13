import fetch from 'cross-fetch';
import { fetchedResults } from './search'

export const getUsers = () => {
  return (dispatch) => {
    fetch('/api/users')
      .then(res => res.json())
      .then(users => {
        dispatch(fetchedResults(users))
      });
  }
}
