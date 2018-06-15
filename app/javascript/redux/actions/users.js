import fetch from 'cross-fetch';
import { fetchedResults } from './search'
import { fetchingResults } from './search'

export const getUsers = (data = 1) => {
  return (dispatch) => {
    dispatch(fetchingResults())
    fetch(`/api/users?page=${data}`)
     .then(res => res.json())
     .then(users => {
       dispatch(fetchedResults(users))
     });
  }
}
