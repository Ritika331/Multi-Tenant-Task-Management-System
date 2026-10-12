package com.ritika.taskmanagement.dto;

public class UserResponseDto {

    private Long id;
    private String name;
    private String email;
    private Long organizationId;
    private String organizationName;

    public UserResponseDto(Long id, String name, String email, Long organizationId, String organizationName) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.organizationId = organizationId;
        this.organizationName = organizationName;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public Long getOrganizationId() {
        return organizationId;
    }

    public String getOrganizationName() {
        return organizationName;
    }
}
