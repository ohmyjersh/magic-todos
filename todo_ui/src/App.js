import React, { useState } from 'react'
import Login from './Login';
import SignUp from './SignUp';
import Todos from './Todos';
import {views} from './constants';
import './App.css';

const App = () => {
  const [ token, setToken] = useState(null);
  const [view, setView] = useState("login")
  const setSuccessToken = (token) => {
    setToken(token)
    setView(views.todo)
  }
  return (
    <div className="App">
      { views.login === view && <Login {...{setSuccessToken, setView}} /> }
      { views.signup === view && <SignUp {...{setSuccessToken, setView}} /> }
      { (!!token && view === views.todo) && <Todos  {...{token}} />}
    </div>
    );
  }

export default App;
