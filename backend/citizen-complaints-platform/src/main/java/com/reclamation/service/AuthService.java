package com.reclamation.service;

import  com.reclamation.dto.auth.RegisterRequest;
import  com.reclamation.dto.auth.LoginRequest;
import  com.reclamation.dto.auth.UserResponse;

public interface AuthService {

    void register(RegisterRequest request) ;

    String login(LoginRequest request);

    UserResponse getCurrentUser(
            String email);
}
