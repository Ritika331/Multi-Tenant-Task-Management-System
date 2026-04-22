package com.ritika.taskmanagement.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class UpdateTaskRequestDto {

    @NotBlank
    private String title;

    private String description;

    @NotNull
    private String status;

    private Long assignedToUserId;

    // getters & setters
}
