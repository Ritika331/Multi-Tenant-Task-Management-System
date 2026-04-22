package com.ritika.taskmanagement.repository;

import com.ritika.taskmanagement.entity.Task;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskRepository extends JpaRepository<Task, Long> {

    Page<Task> findByOrganizationId(Long organizationId, Pageable pageable);
}
