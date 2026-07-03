package com.reclamation.service.impl;

import com.reclamation.dto.auth.RegisterRequest;
import com.reclamation.entity.role;
import com.reclamation.entity.app_user;
import com.reclamation.repository.RoleRepository;
import com.reclamation.repository.UserRepository;
import com.reclamation.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.security.authentication.*;
import  com.reclamation.dto.auth.LoginRequest;
import com.reclamation.security.JwtService;
import  com.reclamation.dto.auth.UserResponse;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    private final AuthenticationManager
            authenticationManager;

    private final JwtService jwtService;

    @Override
    public void register(RegisterRequest request) {

        // check if email exists
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        // get role
        role role = roleRepository.findByName("ROLE_CITIZEN")
                .orElseThrow(() -> new RuntimeException("Role not found"));

        // create user
        app_user user = new app_user();

        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(role);

        // save
        userRepository.save(user);
    }

    @Override
    public String login(
            LoginRequest request) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        return jwtService.generateToken(
                request.getEmail()
        );
    }


    @Override
    public UserResponse getCurrentUser(
            String email) {

        app_user user =
                userRepository.findByEmail(
                                email)
                        .orElseThrow();

        return new UserResponse(
                user.getId(),
                user.getFirstName(),
                user.getLastName(),
                user.getEmail(),
                user.getPhone(),
                user.getRole().getName()
        );
    }


    @Override
    public void updateFcmToken(
            String email,
            String token) {

        app_user user =
                userRepository.findByEmail(email)
                        .orElseThrow(() ->
                                new RuntimeException("Utilisateur introuvable"));

        user.setFcmtoken(token);

        userRepository.save(user);
    }
}