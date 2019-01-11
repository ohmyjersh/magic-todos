import React, {useState} from 'react';
import {Post} from '../Request';
import {InputWrapper, ButtonWrapper, FlexColumn, ButtonGroup} from '../Styles';
import {views} from '../constants';
import Error from '../Error';
import Loading from '../Loading';
import {useApiWithData} from '../useApi';
const doLogin = async data => await Post('sign_in', data)
const onSuccessCallBack = func => response => func(response.jwt);

export default ({setView, setSuccessToken}) => {
  const [isLoading, isError, asyncLogin] = useApiWithData(doLogin, [200,201], onSuccessCallBack(setSuccessToken))
  const[email, setEmail] = useState("");
  const[password, setPassword] = useState("");
  return(
  <FlexColumn>
    {isLoading ? <Loading /> : 
    <React.Fragment>
    <InputWrapper placeholder="email" name="email" value={email} onChange={e => setEmail(e.target.value)} />
    <InputWrapper placeholder="password" type="password" name="password" value={password} onChange={e => setPassword(e.target.value)} />
    <ButtonGroup>
      <ButtonWrapper backgroundColor="#df0e0ee6" onClick={e => setView(views.signup)}>Sign Up</ButtonWrapper>
      <ButtonWrapper backgroundColor="#2644ffba" onClick={async e => await asyncLogin({email, password})}>Sign In</ButtonWrapper>
    </ButtonGroup>
    {isError && <Error message="Please try again, something cool happened" />}
    </React.Fragment>
    }
  </FlexColumn>)
}