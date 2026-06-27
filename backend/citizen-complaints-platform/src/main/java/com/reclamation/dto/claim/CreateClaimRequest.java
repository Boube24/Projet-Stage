package com.reclamation.dto.claim;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CreateClaimRequest {
    @NotBlank(message = "Le titre est obligatoire")
    private String title;

    @NotBlank(message = "La description est obligatoire")
    private String description;

    @NotNull(message = "La latitude est obligatoire")
    @DecimalMin(value = "-90.0")
    @DecimalMax(value = "90.0")
    private BigDecimal latitude;

    @NotNull(message = "La longitude est obligatoire")
    @DecimalMin(value = "-180.0")
    @DecimalMax(value = "180.0")
    private BigDecimal longitude;

    @NotNull(message = "La catégorie est obligatoire")
    private Long categoryId;

    @NotNull(message = "La commune est obligatoire")
    private Long communeId;

}
