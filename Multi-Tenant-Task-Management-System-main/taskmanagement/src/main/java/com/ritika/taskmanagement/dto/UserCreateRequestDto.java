package com.ritika.taskmanagement.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class UserCreateRequestDto {

    @NotBlank(message = "User name must not be blank")
    private String name;

    @Email(message = "Email must be valid")
    @NotBlank(message = "Email must not be blank")
    private String email;

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }
}
