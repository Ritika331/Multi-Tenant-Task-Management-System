package com.ritika.taskmanagement.service;

import org.springframework.stereotype.Service;

@Service
public class HealthService {

    public String healthStatus() {
        return "OK";
    }
}
