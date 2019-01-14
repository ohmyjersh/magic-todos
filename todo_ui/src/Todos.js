import React, { useState, useEffect } from 'react'
import {Get} from './Request';
import AddTodo from './AddTodo';
import Todo from './Todo';
import {FlexColumn} from './Styles';
import styled from 'styled-components';

const TodosWrapper = styled.ul`
  list-style-type: none;
  padding: 0px;
`;

export default ({token}) => {
  const [todos, setTodos] = useState([]);
  const [todoId, setTodoEdit] = useState('');
  const getData = async () => {
    const result = await doGetTodos(token)
    !!result ? setTodos(result.data) : setTodos([]);
  }
  useEffect(async () => {
    getData();
  }, []);
return(  
<FlexColumn>
  <TodoHeader />
  <TodosWrapper> { todos.map((x,i) => <Todo key={i} {...{isEdit:(x.id === todoId),id:x.id, description:x.description, completed:x.completed, getData, token, setTodoEdit}} />)}</TodosWrapper>
  <AddTodo {...{token, getData}} />
</FlexColumn>)
}

const doGetTodos = async token => {
const response = await Get('todos', token)
return await response.json()
}


const HeaderWrapper = styled.div`
  display:flex;
  justify-content: space-between;
  font-size:1em;
  font-weight:bold;
  border-bottom: solid 1px #000;
  padding-bottom: 10px;
`;

const TodoHeader = () => (<HeaderWrapper>
  <span>Description</span><span>Complete?</span>
</HeaderWrapper>)