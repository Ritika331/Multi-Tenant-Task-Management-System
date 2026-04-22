package com.ritika.taskmanagement.exception;

public class TenantNotSetException extends RuntimeException {
    public TenantNotSetException() {
        super("Tenant not set");
    }
}
