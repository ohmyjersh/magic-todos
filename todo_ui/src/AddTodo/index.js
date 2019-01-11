import React, {useState} from 'react';
import {Post} from '../Request';
import {useApiWithData, useApi} from '../useApi';
import {InputWrapper, ButtonWrapper} from '../Styles';
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
  justify-content:space-between;
`;
const InputGroup = styled.div`
display:flex;
flex-direction:column`;

export default ({token, getData}) => {
  const [newTodo, setNewTodo] = useState('');
  const [delayed, setDelayed] = useState(false);
  const [isLoadingCreate, isErrorCreate, asyncCreateTodo] = useApiWithData(doCreateTodo(token), [200,201], onSuccessCallBack(setNewTodo, getData))
  const [isLoadingDelayed, isErrorDelayed, asyncCreateTodoDelayed] = useApi(doCreateDelayedTodo(token), [200,201], onSuccessCallBack(setNewTodo, getData))
  return(
  <AddWrapper>
    <InputGroup>
      <InputWrapper placeholder="add todo" value={newTodo} onChange={e => setNewTodo(e.target.value)} />
      <InputWrapper type="checkbox" checked={delayed} onChange={e => setDelayed(e.target.checked)} /><label>delayed?</label> 
    </InputGroup>
    <ButtonWrapper onClick={async e => delayed ? await asyncCreateTodoDelayed({todo:{description:newTodo, completed:false}}) : await asyncCreateTodo({todo:{description:newTodo, completed:false}})}>add todo</ButtonWrapper>
  </AddWrapper>)
}