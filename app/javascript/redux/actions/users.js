import fetch from 'cross-fetch';
import { fetchedResults } from './search'
import { fetchingResults } from './search'

export const getUsers = (page = 1) => {
  return (dispatch) => {
    dispatch(fetchingResults())
    fetch(`/api/users?page=${page}`)
     .then(res => res.json())
     .then(users => {
       dispatch(fetchedResults(users))
     });
  }
}
