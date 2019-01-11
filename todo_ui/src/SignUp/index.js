import React, {useState} from 'react';
import Error from '../Error';
import {Post} from '../Request';
import {views} from '../constants';
import {FormWrapper, InputWrapper, ButtonWrapper, FlexColumn, ButtonGroup} from '../Styles';
import Loading from '../Loading';
import {useApiWithData} from '../useApi';

const doSignUp = async data => Post('sign_up', data)
const onSuccessCallBack = func => response => func(response.jwt);

export default ({setView, setSuccessToken}) => {
  const [isLoading, isError, asyncSignUp] = useApiWithData(doSignUp, [200,201], onSuccessCallBack(setSuccessToken))
  const[email, setEmail] = useState("");
  const[password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const passwordsMatch = (password, passwordConfirmation) => ((password.length > 0 && passwordConfirmation.length > 0) && password !== passwordConfirmation)
  const match = passwordsMatch(password, passwordConfirmation);
  return(<FormWrapper>
    {isLoading ? <Loading /> : <React.Fragment>
      <InputWrapper placeholder="Email" name="email" autoComplete="off" value={email} onChange={e => setEmail(e.target.value)} />
      <InputWrapper placeholder="Password" type="password" autoComplete="off" name="password" value={password} onChange={e => setPassword(e.target.value)} />
      <InputWrapper placeholder="Password Confirmation" autoComplete="off" type="password" name="confirmation" value={passwordConfirmation} onChange={e => setPasswordConfirmation(e.target.value)}/>
      {match ? <Error message="Passwords do not match."/> : null }
      <ButtonGroup>
        <ButtonWrapper backgroundColor="#df0e0ee6" onClick={e => setView(views.login)}>Cancel</ButtonWrapper>
        <ButtonWrapper disabled={match} backgroundColor="#2644ffba" onClick={async e => await asyncSignUp({user: {email, password, passwordConfirmation}})}>Sign Up</ButtonWrapper>
      </ButtonGroup>
      {isError && <Error message="Please try again, something cool happened" />}
    </React.Fragment>}
  </FormWrapper>)
}
