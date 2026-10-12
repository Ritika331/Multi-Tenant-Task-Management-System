package com.ritika.taskmanagement.controller;

import com.ritika.taskmanagement.dto.CreateTaskRequestDto;
import com.ritika.taskmanagement.dto.TaskResponseDto;
import com.ritika.taskmanagement.service.TaskService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/tasks")
public class TaskController {

    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    // ---------------- CREATE TASK ----------------
    @PostMapping
    public TaskResponseDto createTask(
            @RequestBody @Valid CreateTaskRequestDto request
    ) {
        return taskService.createTask(request);
    }

    // ---------------- LIST TASKS (PAGINATED + TENANT SAFE) ----------------
    @GetMapping
    public Page<TaskResponseDto> listTasks(Pageable pageable) {
        return taskService.getTasks(pageable);
    }

    // ---------------- UPDATE TASK ----------------
    @PutMapping("/{taskId}")
    public TaskResponseDto updateTask(
            @PathVariable Long taskId,
            @RequestBody @Valid CreateTaskRequestDto request
    ) {
        return taskService.updateTask(taskId, request);
    }

    // ---------------- DELETE TASK ----------------
    @DeleteMapping("/{taskId}")
    public void deleteTask(@PathVariable Long taskId) {
        taskService.deleteTask(taskId);
    }
}
