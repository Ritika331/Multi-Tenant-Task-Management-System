package com.ritika.taskmanagement.controller;

import com.ritika.taskmanagement.dto.LoginRequestDto;
import com.ritika.taskmanagement.dto.LoginResponseDto;
import com.ritika.taskmanagement.dto.RegisterRequestDto;
import com.ritika.taskmanagement.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public LoginResponseDto register(@Valid @RequestBody RegisterRequestDto request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public LoginResponseDto login(@Valid @RequestBody LoginRequestDto request) {
        return authService.login(request);
    }
}
