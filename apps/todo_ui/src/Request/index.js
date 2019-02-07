const Request = ({endpoint, method, data, token}) => {
  const baseOptions =  {
    method: method, // *GET, POST, PUT, DELETE, etc.
    mode: "cors", // no-cors, cors, *same-origin
    cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
    credentials: "same-origin", // include, *same-origin, omit
    headers: {
        "Content-Type": "application/json",
    },
    body: JSON.stringify(data), // body data type must match "Content-Type" header
  }
  const options=  !!token ? {...baseOptions, headers : {...baseOptions.headers, authorization: `bearer ${token}`}} : baseOptions;
  return fetch(`http://localhost:4002/api/v1/${endpoint}`, options) 
}

export const Post = (endpoint, data, token = null) => Request({endpoint, method: 'POST', data, token})
export const Put = (endpoint, data, token) => Request({endpoint, method: 'PUT', data, token})
export const Delete = (endpoint,token) => Request({endpoint, method: 'DELETE', token})
export const Get = (endpoint, token) => Request({endpoint, method:'GET', token})