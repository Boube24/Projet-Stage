package com.reclamation.controller;


import com.reclamation.dto.auth.MessageResponse;
import com.reclamation.dto.auth.RegisterRequest;
import com.reclamation.dto.auth.LoginRequest;
import com.reclamation.dto.auth.LoginResponse;
import com.reclamation.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import  com.reclamation.dto.auth.UserResponse;
import org.springframework.security.core.Authentication;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<MessageResponse>
    register(
            @Valid
            @RequestBody
            RegisterRequest request) {

        authService.register(request);

        return ResponseEntity.ok(
                new MessageResponse(
                        "User registered successfully"));
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse>
    login(
            @RequestBody
            LoginRequest request) {

        String token =
                authService.login(
                        request);

        return ResponseEntity.ok(
                new LoginResponse(
                        token));
    }

    @GetMapping("/me")
    public ResponseEntity<UserResponse>
    me(
            Authentication authentication) {

        return ResponseEntity.ok(
                authService.getCurrentUser(
                        authentication.getName()));
    }
}
