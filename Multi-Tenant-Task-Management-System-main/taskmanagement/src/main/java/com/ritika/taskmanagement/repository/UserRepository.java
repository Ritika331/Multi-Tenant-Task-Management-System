package com.ritika.taskmanagement.repository;

import com.ritika.taskmanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByOrganizationId(Long organizationId);
    Optional<User> findByEmail(String email);
}
