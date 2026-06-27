package com.reclamation.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor

public class UserResponse {


        private Long id;

        private String firstName;

        private String lastName;

        private String email;

        private String phone;

        private String role;

}
