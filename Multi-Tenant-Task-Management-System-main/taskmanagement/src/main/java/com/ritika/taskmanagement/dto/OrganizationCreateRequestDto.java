package com.ritika.taskmanagement.dto;

import jakarta.validation.constraints.NotBlank;

public class OrganizationCreateRequestDto {

    @NotBlank(message = "Organization name must not be blank")
    private String name;

    public String getName() {
        return name;
    }
}
