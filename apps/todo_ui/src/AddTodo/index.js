import React, {useState} from 'react';
import {Post} from '../Request';
import {useApiWithData, useApi} from '../useApi';
import {InputWrapper, CheckBoxWrapper} from '../Styles';
import Error from '../Error';
import Loading from '../Loading';
import styled from 'styled-components';

const doCreateTodo = token => async data => await Post('todos', data, token)
const doCreateDelayedTodo = token => async data => await Post('todos/delayed', data, token)
const onSuccessCallBack = (resetTodoFunc, getTodosFunc) => () => { 
  resetTodoFunc('');
  getTodosFunc(); 
}

const AddWrapper = styled.section`
  display:flex;
  flex-direction:column;
  justify-content:space-between;
`;
const InputGroup = styled.div`
  display:flex;
`;

export default ({token, getData}) => {
  const [newTodo, setNewTodo] = useState('');
  const [delayed, setDelayed] = useState(false);
  const [isLoadingCreate, isErrorCreate, asyncCreateTodo] = useApiWithData(doCreateTodo(token), [200,201], onSuccessCallBack(setNewTodo, getData))
  const [isLoadingDelayed, isErrorDelayed, asyncCreateTodoDelayed] = useApi(doCreateDelayedTodo(token), [200,201], onSuccessCallBack(setNewTodo, getData))
  const handleChange = async e => {
    if(e.key === 'Enter') {
      delayed ? await asyncCreateTodoDelayed({todo:{description:newTodo, completed:false}}) : await asyncCreateTodo({todo:{description:newTodo, completed:false}})
    }
  }
  return(
  <AddWrapper>
    {(isLoadingCreate || isLoadingDelayed) ? <Loading /> :(
      <React.Fragment>
      <InputWrapper placeholder="add todo" value={newTodo} onKeyPress={e => handleChange(e)} onChange={e => setNewTodo(e.target.value)} />
      <InputGroup>
        <CheckBoxWrapper type="checkbox" checked={delayed} onChange={e => setDelayed(e.target.checked)} />
        <label>delayed?</label> 
      </InputGroup>
    {(isErrorCreate || isErrorDelayed) && <Error message="Please try again, something cool happened" />}
    </React.Fragment>)}
  </AddWrapper>)
}