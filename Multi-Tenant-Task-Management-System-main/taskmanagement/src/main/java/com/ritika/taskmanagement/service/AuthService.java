package com.ritika.taskmanagement.service;

import com.ritika.taskmanagement.dto.LoginRequestDto;
import com.ritika.taskmanagement.dto.LoginResponseDto;
import com.ritika.taskmanagement.dto.RegisterRequestDto;
import com.ritika.taskmanagement.entity.Organization;
import com.ritika.taskmanagement.entity.User;
import com.ritika.taskmanagement.exception.ResourceNotFoundException;
import com.ritika.taskmanagement.repository.OrganizationRepository;
import com.ritika.taskmanagement.repository.UserRepository;
import com.ritika.taskmanagement.security.JwtUtil;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final OrganizationRepository organizationRepository;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepository,
                       OrganizationRepository organizationRepository,
                       JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.organizationRepository = organizationRepository;
        this.jwtUtil = jwtUtil;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public LoginResponseDto register(RegisterRequestDto request) {
        // Check if user already exists
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalArgumentException("User with this email already exists");
        }

        // Find or create organization
        Organization organization = organizationRepository.findByName(request.getOrganizationName())
                .orElseGet(() -> {
                    Organization newOrg = new Organization(request.getOrganizationName());
                    return organizationRepository.save(newOrg);
                });

        // Create user with hashed password
        String encodedPassword = passwordEncoder.encode(request.getPassword());
        User user = new User(request.getName(), request.getEmail(), encodedPassword, organization);
        User savedUser = userRepository.save(user);

        // Generate JWT token
        String token = jwtUtil.generateToken(savedUser.getId(), savedUser.getEmail(), organization.getId());

        return new LoginResponseDto(
                token,
                savedUser.getId(),
                savedUser.getName(),
                savedUser.getEmail(),
                organization.getId(),
                organization.getName()
        );
    }

    public LoginResponseDto login(LoginRequestDto request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("Invalid email or password"));

        // Validate password
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new ResourceNotFoundException("Invalid email or password");
        }

        Organization organization = user.getOrganization();

        // Generate JWT token
        String token = jwtUtil.generateToken(user.getId(), user.getEmail(), organization.getId());

        return new LoginResponseDto(
                token,
                user.getId(),
                user.getName(),
                user.getEmail(),
                organization.getId(),
                organization.getName()
        );
    }
}
