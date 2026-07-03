package com.reclamation.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class FcmTokenRequest {

    @NotBlank(message = "Le token FCM est obligatoire")
    private String token;

}