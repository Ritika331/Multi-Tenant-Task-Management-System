package com.ritika.taskmanagement.dto;

import com.ritika.taskmanagement.entity.TaskStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class CreateTaskRequestDto {

    @NotBlank(message = "Title must not be blank")
    private String title;

    @Size(max = 1000, message = "Description must be at most 1000 characters")
    private String description;

    @NotNull(message = "Status is required")
    private TaskStatus status;

    // Optional: assign task to user
    private Long assignedUserId;

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public TaskStatus getStatus() {
        return status;
    }

    public Long getAssignedUserId() {
        return assignedUserId;
    }
}
