package com.ritika.taskmanagement.service;

import com.ritika.taskmanagement.dto.CreateTaskRequestDto;
import com.ritika.taskmanagement.dto.TaskResponseDto;
import com.ritika.taskmanagement.entity.Organization;
import com.ritika.taskmanagement.entity.Task;
import com.ritika.taskmanagement.entity.User;
import com.ritika.taskmanagement.exception.ResourceNotFoundException;
import com.ritika.taskmanagement.exception.TenantNotSetException;
import com.ritika.taskmanagement.repository.OrganizationRepository;
import com.ritika.taskmanagement.repository.TaskRepository;
import com.ritika.taskmanagement.repository.UserRepository;
import com.ritika.taskmanagement.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class TaskService {

    private final TaskRepository taskRepository;
    private final OrganizationRepository organizationRepository;
    private final UserRepository userRepository;

    public TaskService(TaskRepository taskRepository,
                       OrganizationRepository organizationRepository,
                       UserRepository userRepository) {
        this.taskRepository = taskRepository;
        this.organizationRepository = organizationRepository;
        this.userRepository = userRepository;
    }

    // ---------------- CREATE ----------------
    public TaskResponseDto createTask(CreateTaskRequestDto request) {

        Long tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new TenantNotSetException();
        }

        Organization organization = organizationRepository.findById(tenantId)
                .orElseThrow(() -> new ResourceNotFoundException("Organization not found"));

        User assignedUser = validateAssignedUser(request.getAssignedUserId(), tenantId);

        Task task = new Task(
                request.getTitle(),
                request.getDescription(),
                request.getStatus(),
                organization,
                assignedUser
        );

        Task saved = taskRepository.save(task);
        return toDto(saved);
    }

    // ---------------- READ ----------------
    public Page<TaskResponseDto> getTasks(Pageable pageable) {

        Long tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new TenantNotSetException();
        }

        return taskRepository
                .findByOrganizationId(tenantId, pageable)
                .map(this::toDto);
    }

    // ---------------- UPDATE ----------------
    public TaskResponseDto updateTask(Long taskId, CreateTaskRequestDto request) {

        Long tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new TenantNotSetException();
        }

        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new ResourceNotFoundException("Task not found"));

        // 🔐 Tenant isolation
        if (!task.getOrganization().getId().equals(tenantId)) {
            throw new ResourceNotFoundException("Task not found");
        }

        task.setTitle(request.getTitle());
        task.setDescription(request.getDescription());
        task.setStatus(request.getStatus());

        User assignedUser = validateAssignedUser(request.getAssignedUserId(), tenantId);
        task.setAssignedTo(assignedUser);

        Task updated = taskRepository.save(task);
        return toDto(updated);
    }

    // ---------------- DELETE ----------------
    public void deleteTask(Long taskId) {

        Long tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new TenantNotSetException();
        }

        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new ResourceNotFoundException("Task not found"));

        // 🔐 Tenant isolation
        if (!task.getOrganization().getId().equals(tenantId)) {
            throw new ResourceNotFoundException("Task not found");
        }

        taskRepository.delete(task);
    }

    // ---------------- HELPERS ----------------
    private User validateAssignedUser(Long userId, Long tenantId) {

        if (userId == null) {
            return null;
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        if (!user.getOrganization().getId().equals(tenantId)) {
            throw new IllegalArgumentException("User does not belong to this organization");
        }

        return user;
    }

    private TaskResponseDto toDto(Task task) {
        return new TaskResponseDto(
                task.getId(),
                task.getTitle(),
                task.getDescription(),
                task.getStatus(),
                task.getAssignedTo() != null ? task.getAssignedTo().getId() : null,
                task.getAssignedTo()!=null?task.getAssignedTo().getName():null,
                task.getCreatedAt(),
                task.getUpdatedAt()
        );
    }
}
