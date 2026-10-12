package com.ritika.taskmanagement.service;

import com.ritika.taskmanagement.dto.OrganizationResponseDto;
import com.ritika.taskmanagement.entity.Organization;
import com.ritika.taskmanagement.repository.OrganizationRepository;
import org.springframework.stereotype.Service;
import com.ritika.taskmanagement.dto.OrganizationCreateRequestDto;


import java.util.List;

@Service
public class OrganizationService {

    private final OrganizationRepository organizationRepository;

    public OrganizationService(OrganizationRepository organizationRepository) {
        this.organizationRepository = organizationRepository;
    }

    public List<OrganizationResponseDto> getAllOrganizations() {
        return organizationRepository.findAll()
                .stream()
                .map(this::mapToDto)
                .toList();
    }

    private OrganizationResponseDto mapToDto(Organization organization) {
        return new OrganizationResponseDto(
                organization.getId(),
                organization.getName(),
                organization.getCreatedAt()
        );
    }
    public OrganizationResponseDto createOrganization(OrganizationCreateRequestDto request) {
        Organization organization = new Organization(request.getName());
        Organization saved = organizationRepository.save(organization);

        return new OrganizationResponseDto(
                saved.getId(),
                saved.getName(),
                saved.getCreatedAt()
        );
    }

}
