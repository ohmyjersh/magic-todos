import React from 'react';
import styled from 'styled-components'
import {FaSpinner} from 'react-icons/fa'

const LoadingWrapper = styled.section`
  display:flex;
  height:100%;
  width:100%;
  justify-content:center;
  align-items:center;
`;

export default () => <LoadingWrapper><FaSpinner /></LoadingWrapper>