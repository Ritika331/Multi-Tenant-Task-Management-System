package com.ritika.taskmanagement.exception;

public class ApiException extends RuntimeException {

    public ApiException(String message) {
        super(message);
    }
}
