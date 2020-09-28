import React from 'react';
import { Link } from 'react-router-dom';

import styled from 'styled-components';

import { StyledButton, StyledText } from 'styles/app';
import colors from 'styles/colors';


const StyledH1 = styled.h1`
  font-size: 30px;
  font-size: 1.875rem;
  line-height: 36px;
  line-height: 2.25rem;
  font-weight: 400;
  padding-top: 100px;
  padding-top: 6.25rem;
  color: ${colors.white};
`;

const StyledH2 = styled.h2`
  font-size: 20px;
  font-size: 1.25rem;
  line-height: 24px;
  line-height: 1.5rem;
  color: ${colors.blue};
  text-transform: uppercase;
`;

const StyledForm = styled.form`
  width: 390px;
  height: 522px;
  padding: 30px;
  margin: 42px auto 0 auto;
  background-color: #fff;
  text-align: left;
`;

const StyledInput = styled.input`
  width: 330px;
  font-size: 18px;
  font-size: 1.125rem;
  color: #707070;
  border: none;
  padding-bottom: 0.625rem;
  padding-left: 0.25rem;
  padding-right: 0.25rem;
  border-bottom: 1px solid #D2D2D2;
  &::placeholder {
    color: #D2D2D2;
  }
  &:first-child {
    margin-bottom: 20px;
  }
`;

const ForgotPasswordLink = styled.div`
  position: relative;
  a {
    position: absolute;
    top: -0.625rem;
    right: 0;
    font-size: 14px;
    font-size: 0.875rem;
    line-height: 16px;
    line-height: 1rem;
    color: ${colors.gray80};
  }
`;

const ErrorMessage = styled.div`
  font-size: 14px;
  color: ${colors.pink};
`;


const Root = styled.div`
    width: 100%;
    height: 100vh;
    text-align: center;
`;

const ChangePassword = () => {
    const stuff = 'stuff';
    return (
        <Root>
            <StyledH1>
                Welcome to
                <br />
                OpenFIDO
            </StyledH1>
            <StyledForm>
                <StyledH2>Reset Your Password</StyledH2>
                <StyledText
                    size="middle"
                    color="gray"
                >
                    Enter your email address and we will send you a link to reset your password
                </StyledText>
                <div>
                    <label htmlFor="newPassword">
                        <StyledText
                            size="middle"
                            color="gray"
                        >
                            New Password
                        </StyledText>
                    </label>
                    <StyledInput placeholder="password" />
                </div>
                <div>
                    <label htmlFor="confirmPassword">
                        <StyledText
                            size="middle"
                            color="gray"
                        >
                            Re-Enter Password
                        </StyledText>
                    </label>
                    <StyledInput type="password" placeholder="password" />
                </div>
                <ErrorMessage>
                    Minimum 10 characters
                </ErrorMessage>
                <StyledButton
                    color="blue"
                    width="144"
                    role="button"
                    tabIndex={0}
                >
                    Submit
                </StyledButton>
            </StyledForm>
        </Root>
    )
}

export default ChangePassword;
