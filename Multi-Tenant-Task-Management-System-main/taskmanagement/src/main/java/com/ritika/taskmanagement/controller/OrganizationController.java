package com.ritika.taskmanagement.controller;

import com.ritika.taskmanagement.dto.OrganizationResponseDto;
import com.ritika.taskmanagement.service.OrganizationService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ritika.taskmanagement.dto.OrganizationCreateRequestDto;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


import java.util.List;

@RestController
@RequestMapping("/organizations")
public class OrganizationController {

    private final OrganizationService organizationService;

    public OrganizationController(OrganizationService organizationService) {
        this.organizationService = organizationService;
    }

    @GetMapping
    public List<OrganizationResponseDto> getOrganizations() {
        return organizationService.getAllOrganizations();
    }
    @PostMapping
    public OrganizationResponseDto createOrganization(
            @Valid @RequestBody OrganizationCreateRequestDto request
    ) {
        return organizationService.createOrganization(request);
    }

}
