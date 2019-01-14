import React, {useState} from 'react';
import {Put} from '../Request';
import {InputWrapper, CheckBoxWrapper} from '../Styles';
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
  width:100%;
`;

export default ({isEdit, id, description, completed, getData, token, setTodoEdit}) => {
  const [isLoading, isError, asyncUpdateTodo] = useApiWithData(doUpdateTodo(token), [200,201], onSuccessCallBack(getData))
 return (<TodoWrapper>
  { isEdit
    ? isLoading 
      ? <Loading /> 
      : <EditTodo {...{id, completed,description, setTodoEdit, asyncUpdateTodo}} />
    : <DisplayTodo {...{setTodoEdit, id, description}} />
  }
    <CheckBoxWrapper name="complete" type="checkbox" checked={completed} onChange={async e => await asyncUpdateTodo({id, todo: {description, completed: !completed}})}/>
</TodoWrapper>)}

const EditTodo = ({id, completed,description, setTodoEdit, asyncUpdateTodo}) => {  
  const [editTodo, setEditTodo] = useState(description);
  const handleChange = async e => {
    if(e.key === 'Enter') {
      await asyncUpdateTodo({id, todo: {description: editTodo, completed:completed}}); 
      setTodoEdit('')
    }
  }
  return (<InputWrapper value={editTodo} nKeyPress={e => handleChange(e)} onChange={e => setEditTodo(e.target.value)}/>) 
}

const DisplayTodoWrapper = styled.div`
  display:flex;
  word-break:break-all;
  padding:5px 0px;
  width:100%;
`;
const DisplayTodo = ({setTodoEdit, id, description}) => (
  <DisplayTodoWrapper onClick={ e => { setTodoEdit(id)}}>{description}</DisplayTodoWrapper>
)