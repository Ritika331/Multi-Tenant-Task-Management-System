package com.ritika.taskmanagement.controller;

import com.ritika.taskmanagement.dto.UserCreateRequestDto;
import com.ritika.taskmanagement.dto.UserResponseDto;
import com.ritika.taskmanagement.service.UserService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController{
    private final UserService userService;
    public UserController(UserService userService){
        this.userService=userService;
    }
    @PostMapping
    public UserResponseDto createUser(@RequestBody @Valid UserCreateRequestDto request){
        return userService.createUser(request);
    }
    @GetMapping
    public List<UserResponseDto>getUsers(){
        return userService.getUsersForCurrentTenant();
    }
}