export const authService = { login };

function login(creds) {
  const requestOptions = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(creds)
  };

  return fetch('/oauth/token', requestOptions)
    .then(handleResponse)
    .then(user => {
      if (user.access_token) {
        localStorage.setItem('user', JSON.stringify(user));
      }

      return user;
    });
}

function handleResponse(response) {
  return response.json().then(data => {
    if (!response.ok) {
      if (response.status === 401) {
        // auto logout if 401 response returned from api
        logout();
        location.reload(true);
      }

      const error = (data && data.message) || response.statusText;
      return Promise.reject(error);
    }

    return data;
  });
}
