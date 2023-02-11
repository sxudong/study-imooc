package com.myimooc;

public class ArgsException extends Exception {
    private char errorArgument = '\0';
    private String errorParameter = "TILT";

    private ErrorCode errorCode = ErrorCode.OK;

    public ErrorCode getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }

    public ArgsException() {
    }

    public ArgsException(String message) {
        super(message);
    }

    public ArgsException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }

    public enum ErrorCode {
        OK, MISSING_STRING, MISSING_INTEGER,
        INALID_INTEGER, INALID_STRING, UNEXPECTED_ARGUMENT;

    }
}

