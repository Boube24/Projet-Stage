package com.reclamation.dto.auth;


import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegisterRequest {
    @NotBlank
    private String firstName;

    @NotBlank
    private String lastName;

    @Email
    private String email;

    @NotBlank
    private String phone;


    @NotBlank
    private String password;
}
