import fetch from 'cross-fetch';
import { fetchedResults } from './search'
import { fetchingResults } from './search'

export const FETCHED_USER = 'FETCHED USER';

export const fetchedUser = (user) => {
  return {
    type: FETCHED_USER,
    payload: user
  }
}

export const getUser = (userName) => {
  return (dispatch) => {
    dispatch(fetchingResults())
    fetch(`/api/users/${userName}`)
     .then(res => res.json())
     .then(user => {
       dispatch(fetchedUser(user))
     });
  }
}

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
