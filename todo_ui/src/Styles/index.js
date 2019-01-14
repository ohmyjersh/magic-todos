import styled from 'styled-components';

export const InputWrapper = styled.input`
  box-sizing : border-box;
  width:100%;
  padding: 5px 10px;
  font-size: 1em;
  border: solid 1px #e0e0e0;
  border-radius: .5em;
  &:focus {
    outline: none;
  }
`;

export const CheckBoxWrapper = styled.input`
  box-sizing : border-box;
  margin: 10px;
  font-size: 1em;
  border: solid 1px #e0e0e0;
  border-radius: .5em;
  &:focus {
    outline: none;
  }
`;

export const ButtonGroup = styled.div`
  display:flex;
  flex-direction:row;
  > * {
    &:not(:last-child) {
      margin-right: 10px;
    }
  }
`;

export const ButtonWrapper = styled.button`
  font-weight: 600
  text-align: center
  font-size: 16px
  color: #fff
  background-color: ${props => props.backgroundColor || '#000'}
  width: 100%
  border: none
  border-radius: 4px
  cursor: pointer
  overflow: hidden
  transition: all 200ms ease-in-out
  box-shadow: 0px 2px 6px rgba(0,0,0,0.3);
  &:hover {
    box-shadow: 0px 6px 10px rgba(0,0,0,0.3);
    transform: translateY(-4px)
  }
  &:focus {
    border:none;
  }
`

export const FlexColumn = styled.section`
  background-color: #ffffff;
  padding: 2em;
  border-radius: 8px;
  min-width: 50%;
  display:flex;
  flex-wrap: wrap;
  flex-direction: column;
  justify-content: center;
  box-shadow: 0 10px 40px -14px rgba(0,0,0,0.25);
  > * {
    &:not(:last-child) {
      margin-bottom: 20px;
    }
  }
`

export const FormWrapper = styled.form`
  background-color: #ffffff;
  padding: 2em;
  border-radius: 8px;
  min-width: 50%;
  display:flex;
  flex-wrap: wrap;
  flex-direction: column;
  justify-content: center;
  box-shadow: 0 10px 40px -14px rgba(0,0,0,0.25);
  > * {
    &:not(:last-child) {
      margin-bottom: 20px;
    }
  }
`