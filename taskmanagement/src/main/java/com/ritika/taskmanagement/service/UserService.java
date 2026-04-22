package com.ritika.taskmanagement.service;

import com.ritika.taskmanagement.dto.UserCreateRequestDto;
import com.ritika.taskmanagement.dto.UserResponseDto;
import com.ritika.taskmanagement.entity.Organization;
import com.ritika.taskmanagement.entity.User;
import com.ritika.taskmanagement.repository.OrganizationRepository;
import com.ritika.taskmanagement.repository.UserRepository;
import com.ritika.taskmanagement.tenant.TenantContext;
import org.springframework.stereotype.Service;
import com.ritika.taskmanagement.exception.TenantNotSetException;
import com.ritika.taskmanagement.exception.ResourceNotFoundException;
import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final OrganizationRepository organizationRepository;

    public UserService(UserRepository userRepository,
                       OrganizationRepository organizationRepository) {
        this.userRepository = userRepository;
        this.organizationRepository = organizationRepository;
    }

    public UserResponseDto createUser(UserCreateRequestDto request) {

        Long tenantId = TenantContext.getTenantId();

        if (tenantId == null) {
            throw new TenantNotSetException();

        }

        Organization organization = organizationRepository.findById(tenantId)
                .orElseThrow(() -> new ResourceNotFoundException("Organization not found"));

        User user = new User(
                request.getName(),
                request.getEmail(),
                organization
        );

        User saved = userRepository.save(user);

        return new UserResponseDto(
                saved.getId(),
                saved.getName(),
                saved.getEmail()
        );
    }

    public List<UserResponseDto> getUsersForCurrentTenant() {

        Long tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new TenantNotSetException();
        }

        return userRepository
                .findByOrganizationId(tenantId)
                .stream()
                .map(user -> new UserResponseDto(
                        user.getId(),
                        user.getName(),
                        user.getEmail()
                ))
                .toList();
    }

}
