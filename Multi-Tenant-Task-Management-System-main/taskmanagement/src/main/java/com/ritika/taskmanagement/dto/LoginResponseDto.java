package com.ritika.taskmanagement.dto;

public class LoginResponseDto {

    private String token;
    private Long userId;
    private String name;
    private String email;
    private Long organizationId;
    private String organizationName;

    public LoginResponseDto(String token, Long userId, String name, String email, Long organizationId, String organizationName) {
        this.token = token;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.organizationId = organizationId;
        this.organizationName = organizationName;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Long getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(Long organizationId) {
        this.organizationId = organizationId;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }
}
