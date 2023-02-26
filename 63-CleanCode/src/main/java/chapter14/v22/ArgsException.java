package chapter14.v22;

public class ArgsException extends Exception{
    private char errorArgumentId = '\0';
    private String errorParameter = null;
    private ErrorCode errorCode = ErrorCode.OK;

    public ArgsException() {
    }

    public ArgsException(String message) {
        super(message);
    }

    public enum ErrorCode {
        OK, MISSING_STRING, MISSING_INTEGER, INVALID_INTEGER, UNEXPECTED_ARGUMENT,
        MISSING_DOUBLE, INVALID_DOUBLE
    }
}
