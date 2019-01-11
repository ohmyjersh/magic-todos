import React, {useState} from 'react';
import {Put} from '../Request';
import {InputWrapper, ButtonWrapper} from '../Styles';
import {useApiWithData} from '../useApi';
import Error from '../Error';
import Loading from '../Loading';
import styled from 'styled-components';

const doUpdateTodo = token => async data => await Put(`todos/${data.id}`, {todo: {description: data.todo.description, completed:data.todo.completed}}, token)
const onSuccessCallBack = getTodosFunc => () => { 
  getTodosFunc();
}

const TodoWrapper = styled.li`
  display:flex;
  justify-content:space-between;
`;

export default ({id, description, completed, getData, token}) => {
  const [isEdit, setIsEdit] = useState(false);
  const [isLoading, isError, asyncUpdateTodo] = useApiWithData(doUpdateTodo(token), [200,201], onSuccessCallBack(getData))
 return (<TodoWrapper>
  { isEdit
    ? 
    <EditTodo {...{id, completed,description,setIsEdit, asyncUpdateTodo}} />
    : <DisplayTodo {...{setIsEdit, description}} />
  }
    <input name="complete" type="checkbox" checked={completed} onChange={async e => await asyncUpdateTodo({id, todo: {description, completed: !completed}})}/>
</TodoWrapper>)}


const EditTodoWrapper = styled.div`
  display:flex;
  justify-content:space-between;
`;

const EditTodo = ({id, completed,description, setIsEdit, asyncUpdateTodo}) => {  
  const [editTodo, setEditTodo] = useState(description);
  return (<EditTodoWrapper>
          <InputWrapper value={editTodo} onChange={e => setEditTodo(e.target.value)}/>
          <ButtonWrapper onClick={async e => { await asyncUpdateTodo({id, todo: {description: editTodo, completed:completed}}); setIsEdit(false)}}>update</ButtonWrapper>
          </EditTodoWrapper>) 
}

const DisplayTodoWrapper = styled.div`
  display:flex;
  word-break:break-all;
`;
const DisplayTodo = ({setIsEdit, description}) => (
  <DisplayTodoWrapper onClick={ e => { setIsEdit(true)}}>{description}</DisplayTodoWrapper>
)