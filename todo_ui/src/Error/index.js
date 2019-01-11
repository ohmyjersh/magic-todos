import React from 'react';
import styled from 'styled-components';

const ErrorWrapper = styled.div`
  font-size: .8em;
  color: red;
`;

export default ({message}) => (<ErrorWrapper>{message}</ErrorWrapper>)